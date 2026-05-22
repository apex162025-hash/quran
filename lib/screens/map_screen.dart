import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(30.0444, 31.2357); // Cairo, Egypt
  LatLng _currentLocation = const LatLng(30.0444, 31.2357);
  final Set<Marker> _markers = {};
  
  bool _isSearching = false;
  bool _isLoadingParams = false;
  String _currentPlaceName = "Cairo, Egypt";
  String _currentPlaceAddress = "Capital of Egypt";
  String? _currentPlacePhotoUrl;

  Timer? _debounce;
  final Dio _dio = Dio();
  final String _googleApiKey = "AIzaSyDqHIVmDFiVPbCMhSYHD7Qzz7grreCCDlM";

  @override
  void initState() {
    super.initState();
    _fetchCairoMosques();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<BitmapDescriptor> _createMarkerImageFromUrl(String url) async {
    try {
      final response = await _dio.get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
      final Uint8List imageBytes = Uint8List.fromList(response.data!);

      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes, targetWidth: 120, targetHeight: 120);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      const double radius = 60;
      final Paint borderPaint = Paint()..color = Colors.teal;
      canvas.drawCircle(const Offset(radius, radius), radius, borderPaint);

      final Path clipPath = Path()..addOval(Rect.fromCircle(center: const Offset(radius, radius), radius: radius - 6));
      canvas.clipPath(clipPath);
      canvas.drawImage(image, const Offset(0, 0), Paint());

      final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(120, 120);
      final ByteData? byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      return BitmapDescriptor.fromBytes(pngBytes);
    } catch (e) {
      debugPrint("Marker Creation Error: $e");
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    }
  }

  Future<void> _fetchCairoMosques() async {
    setState(() => _isLoadingParams = true);
    final url = "https://maps.googleapis.com/maps/api/place/textsearch/json";
    try {
      final response = await _dio.get(url, queryParameters: {
        "query": "mosques in cairo",
        "key": _googleApiKey,
      });

      if (response.statusCode == 200 && response.data["status"] == "OK") {
        final results = response.data["results"] as List;
        
        Set<Marker> newMarkers = {};
        for (var place in results) {
          final loc = place["geometry"]["location"];
          final latLng = LatLng(loc["lat"], loc["lng"]);
          
          String? photoUrl;
          BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
          
          if (place["photos"] != null && place["photos"].isNotEmpty) {
            final photoRef = place["photos"][0]["photo_reference"];
            photoUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRef&key=$_googleApiKey";
            icon = await _createMarkerImageFromUrl("https://maps.googleapis.com/maps/api/place/photo?maxwidth=120&photo_reference=$photoRef&key=$_googleApiKey");
          }

          newMarkers.add(
            Marker(
              markerId: MarkerId(place["place_id"]),
              position: latLng,
              icon: icon,
              onTap: () {
                setState(() {
                  _currentLocation = latLng;
                  _currentPlaceName = place["name"] ?? "Mosque";
                  _currentPlaceAddress = place["formatted_address"] ?? "Cairo, Egypt";
                  _currentPlacePhotoUrl = photoUrl;
                });
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: latLng, zoom: 16),
                ));
              },
            )
          );
        }
        
        if (mounted) {
          setState(() {
            _markers.clear();
            _markers.addAll(newMarkers);
          });
        }
      }
    } catch (e) {
      debugPrint("Fetch Mosques Error: $e");
    } finally {
      if (mounted) setState(() => _isLoadingParams = false);
    }
  }

  Future<List<Map<String, String>>> _fetchAutocompleteSuggestions(String query) async {
    if (query.trim().isEmpty) return [];
    
    final url = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    try {
      final response = await _dio.get(url, queryParameters: {
        "input": query,
        "key": _googleApiKey,
      });
      
      if (response.statusCode == 200 && response.data["status"] == "OK") {
        final predictions = response.data["predictions"] as List;
        return predictions.map((p) => {
          "description": p["description"] as String,
          "place_id": p["place_id"] as String,
        }).toList();
      }
    } catch (e) {
      debugPrint("Autocomplete Error: $e");
    }
    return [];
  }

  Future<Iterable<Map<String, String>>> _getSuggestions(TextEditingValue textEditingValue) async {
    final query = textEditingValue.text;
    if (query.length < 3) return Iterable<Map<String, String>>.empty();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    Completer<Iterable<Map<String, String>>> completer = Completer();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      completer.complete(await _fetchAutocompleteSuggestions(query));
    });

    return completer.future;
  }

  Future<void> _fetchPlaceDetails(String placeId, String description) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoadingParams = true;
      _isSearching = false; // close search UI on select
    });

    final url = "https://maps.googleapis.com/maps/api/place/details/json";
    try {
      final response = await _dio.get(url, queryParameters: {
        "place_id": placeId,
        "key": _googleApiKey,
      });

      if (response.statusCode == 200 && response.data["status"] == "OK") {
        final result = response.data["result"];
        final location = result["geometry"]["location"];
        final newLatLng = LatLng(location["lat"], location["lng"]);
        
        final placeName = result["name"] ?? description.split(',').first;
        final placeAddress = result["formatted_address"] ?? description;
        
        String? photoUrl;
        if (result["photos"] != null && result["photos"].isNotEmpty) {
          final photoRef = result["photos"][0]["photo_reference"];
          photoUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRef&key=$_googleApiKey";
        }

        setState(() {
          _currentLocation = newLatLng;
          _currentPlaceName = placeName;
          _currentPlaceAddress = placeAddress;
          _currentPlacePhotoUrl = photoUrl;
          _markers.add(
            Marker(
              markerId: const MarkerId('searched_location'),
              position: newLatLng,
              infoWindow: InfoWindow(
                title: _currentPlaceName,
                snippet: _currentPlaceAddress,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
            )
          );
        });

        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: newLatLng, zoom: 15),
        ));
      } else {
        throw Exception("Place details not found");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not load location details.'),
            backgroundColor: Colors.redAccent,
          )
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingParams = false;
        });
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    
    // A customized, sleek dark theme for a modern look
    String mapStyle = '''
    [
      {
        "elementType": "geometry",
        "stylers": [ {"color": "#212121"} ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [ {"visibility": "off"} ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [ {"color": "#757575"} ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [ {"color": "#212121"} ]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [ {"color": "#757575"} ]
      },
      {
        "featureType": "administrative.country",
        "elementType": "labels.text.fill",
        "stylers": [ {"color": "#9e9e9e"} ]
      },
      {
        "featureType": "administrative.land_parcel",
        "stylers": [ {"visibility": "off"} ]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [ {"color": "#bdbdbd"} ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [ {"color": "#757575"} ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [ {"color": "#181818"} ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [ {"color": "#2c2c2c"} ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [ {"color": "#8a8a8a"} ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [ {"color": "#373737"} ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [ {"color": "#3c3c3c"} ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [ {"color": "#000000"} ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [ {"color": "#3d3d3d"} ]
      }
    ]
    ''';
    
    // Set style automatically if context's brightness is dark
    // For stunning impact we use dark mode by default unless the app theme is light
    if (WidgetsBinding.instance.window.platformBrightness == Brightness.dark) {
       mapController.setMapStyle(mapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Google Map Foundation
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: _markers,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          
          // 2. Custom Glassmorphic Header Component
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FadeInDown(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    height: 125.h,
                    padding: EdgeInsets.only(top: 55.h, left: 20.w, right: 20.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xff121212).withOpacity(0.5) : Colors.white.withOpacity(0.5),
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_isSearching) {
                              setState(() => _isSearching = false);
                              FocusScope.of(context).unfocus();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                              border: Border.all(
                                color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                              )
                            ),
                            child: Icon(Icons.arrow_back_ios_new_rounded, 
                              size: 18, 
                              color: isDark ? Colors.white : Colors.black87
                            ),
                          ),
                        ),
                        if (_isSearching)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Autocomplete<Map<String, String>>(
                                displayStringForOption: (option) => option["description"] ?? "",
                                optionsBuilder: _getSuggestions,
                                onSelected: (option) => _fetchPlaceDetails(option["place_id"]!, option["description"]!),
                                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    style: GoogleFonts.inter(
                                      color: isDark ? Colors.white : Colors.black87,
                                      fontSize: 16.sp,
                                    ),
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: "Search location...",
                                      hintStyle: GoogleFonts.inter(
                                        color: isDark ? Colors.white54 : Colors.black54,
                                        fontSize: 16.sp,
                                      ),
                                      border: InputBorder.none,
                                      suffixIcon: _isLoadingParams ? 
                                         Container(
                                          padding: const EdgeInsets.all(12),
                                          width: 20, 
                                          height: 20, 
                                          child: const CircularProgressIndicator(strokeWidth: 2)
                                        ) : null,
                                    ),
                                  );
                                },
                                optionsViewBuilder: (context, onSelected, options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4.0,
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: isDark ? const Color(0xff1A1A1A) : Colors.white,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width - 110.w,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            final option = options.elementAt(index);
                                            return InkWell(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(16.w),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.location_on_outlined, 
                                                      size: 20, 
                                                      color: Colors.teal
                                                    ),
                                                    SizedBox(width: 12.w),
                                                    Expanded(
                                                      child: Text(
                                                        option["description"] ?? "",
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.inter(
                                                          color: isDark ? Colors.white70 : Colors.black87,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        else
                          Text(
                            'Islamic Landmarks',
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        if (!_isSearching)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearching = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                                border: Border.all(
                                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                                )
                              ),
                              child: Icon(Icons.search, 
                                size: 18, 
                                color: isDark ? Colors.white : Colors.black87
                              ),
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearching = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? Colors.white.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                                border: Border.all(
                                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                                )
                              ),
                              child: Icon(Icons.close, 
                                size: 18, 
                                color: isDark ? Colors.white : Colors.redAccent
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 3. Floating Interactive Action Card at Bottom
          Positioned(
            bottom: 40.h,
            left: 20.w,
            right: 20.w,
            child: FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xff1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 55.w,
                      height: 55.w,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: _currentPlacePhotoUrl == null
                          ? const Icon(Icons.mosque_rounded, color: Colors.teal, size: 28)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: CachedNetworkImage(
                                imageUrl: _currentPlacePhotoUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.mosque_rounded, color: Colors.teal, size: 28),
                              ),
                            ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentPlaceName,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _currentPlaceAddress,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        mapController.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(target: _currentLocation, zoom: 17),
                        ));
                      },
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        ),
                        child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 22),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          
          // 4. Floating Zoom Controls
          Positioned(
            right: 20.w,
            bottom: 165.h,
            child: FadeInRight(
              delay: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: "zoomIn",
                    onPressed: () {
                      mapController.animateCamera(CameraUpdate.zoomIn());
                    },
                    backgroundColor: isDark ? const Color(0xff2C2C2C) : Colors.white,
                    child: Icon(Icons.add_rounded, color: isDark ? Colors.white : Colors.black87),
                  ),
                  SizedBox(height: 12.h),
                  FloatingActionButton.small(
                    heroTag: "zoomOut",
                    onPressed: () {
                      mapController.animateCamera(CameraUpdate.zoomOut());
                    },
                    backgroundColor: isDark ? const Color(0xff2C2C2C) : Colors.white,
                    child: Icon(Icons.remove_rounded, color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
