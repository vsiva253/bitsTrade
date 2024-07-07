// data/modals/child_data_modal.dart

class ChildData {
  final String? id;
  final String? broker;
  final String? userId;
  final String? loginPassword;
  final String? totpScanKey;
  final String? apiKey;
  final String? apiSecret;
  final bool? loginStatus;
  final bool? status;
  final String? multiplier;
  final String? nameTag;
  final bool? withApi;
    String? redirectUrl;
  String? pin;
  String? mobile; // Add the 'mobile' field

  ChildData({
    this.id,
    this.broker,
    this.userId,
    this.loginPassword,
    this.totpScanKey,
    this.apiKey,
    this.apiSecret,
    this.loginStatus,
    this.status,
    this.multiplier,
    this.nameTag,
    this.withApi,
    this.redirectUrl,
    this.pin,
    this.mobile, // Add the 'mobile' field

  });

  factory ChildData.fromJson(Map<String, dynamic> json) {
    return ChildData(
      id: json['id'],
      broker: json['broker'],
      userId: json['user_id'],
      loginPassword: json['login_password'],

      totpScanKey: json['totp_scan_key'],
      apiKey: json['api_key'],
      apiSecret: json['api_secret'],
      multiplier: json['multiplier'],
      nameTag: json['name_tag'],
      withApi: json['with_api']
      , redirectUrl: json['redirect_url'],
      pin: json['pin'],
      mobile: json['mobile'], 
      loginStatus: json['login_status'],
      status: json['status'],
      
      // Add the 'mobile' field

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'broker': broker,
      'user_id': userId,
      'login_password': loginPassword,
      'totp_scan_key': totpScanKey,
      'api_key': apiKey,
      'api_secret': apiSecret,
      'multiplier': multiplier,

      'name_tag': nameTag,
      'with_api':withApi,
      'redirect_url': redirectUrl,
      'pin': pin,
      'mobile': mobile, // Add the 'mobile' field
      'login_status':loginStatus,
      'status':status,


    };
  }
}