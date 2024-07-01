// data/modals/child_data_modal.dart

class ChildData {
  final String? id;
  final String? broker;
  final String? loginPassword;
  final String? totpScanKey;
  final String? apiKey;
  final String? apiSecret;
  final String? multiplier;
  final String? nameTag;
  final bool? withApi;

  ChildData({
    this.id,
    this.broker,
    this.loginPassword,
    this.totpScanKey,
    this.apiKey,
    this.apiSecret,
    this.multiplier,
    this.nameTag,
    this.withApi
  });

  factory ChildData.fromJson(Map<String, dynamic> json) {
    return ChildData(
      id: json['id'],
      broker: json['broker'],
      loginPassword: json['login_password'],
      totpScanKey: json['totp_scan_key'],
      apiKey: json['api_key'],
      apiSecret: json['api_secret'],
      multiplier: json['multiplier'],
      nameTag: json['name_tag'],
      withApi: json['with_api']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'broker': broker,
      'login_password': loginPassword,
      'totp_scan_key': totpScanKey,
      'api_key': apiKey,
      'api_secret': apiSecret,
      'multiplier': multiplier,

      'name_tag': nameTag,
      'with_api':withApi
    };
  }
}