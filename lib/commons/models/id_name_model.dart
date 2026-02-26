class IdNameModel {
  dynamic id;
  dynamic name;
  dynamic image;
  dynamic key;
  dynamic icon;
  dynamic type;
  dynamic propertiesCount;

  IdNameModel({this.id, this.name, this.image, this.key});
  IdNameModel.fromJson(Map<String, dynamic> json) {
    id = (json['id']) is String ? int.parse(json['id']) : json['id'];
    name = json['title'] ?? json['name'];
    image = json['image'];
    key = json['key'];
    icon = json['icon'];
    type = json['type'];
    propertiesCount = json['properties_count'];
  }
}
