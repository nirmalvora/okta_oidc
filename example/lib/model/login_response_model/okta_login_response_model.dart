class OktaLoginResponse {
  String? message;
  bool? status;

  OktaLoginResponse({required this.message, required this.status});
  OktaLoginResponse.fromJson(Map<dynamic, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
