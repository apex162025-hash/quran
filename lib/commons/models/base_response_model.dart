class BaseApiResponse {
  bool? status;
  String? message;

  BaseApiResponse({
    this.status,
    this.message,
  });

  BaseApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}

