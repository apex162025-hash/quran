class CurrencyModel {
  String? icon;

  CurrencyModel({this.icon});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
  }
}