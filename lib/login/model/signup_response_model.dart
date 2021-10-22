class SignUpResponseModel {
  String? user;

  SignUpResponseModel({this.user});

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    return data;
  }
}
