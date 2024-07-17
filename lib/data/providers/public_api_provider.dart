import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../utils/constants.dart';
import '../modals/publicModals/unified_form_fields.dart';

class PublicApiServices {
  static Future<dynamic> getFormFields(
      String brokerType, String formType) async {
    final url = '${Constants.apiBaseUrl}/api/v1/public/$brokerType/$formType';
   try{
     final response =
        await http.get(Uri.parse(url), headers: {'accept': 'application/json'});

    if (response.statusCode == 200) {
      print('zerodha form fields ${response.body}');
      final jsonData = json.decode(response.body);
      if (brokerType == 'zerodha') {
        return ZerodhaFormFieldsResponse.fromJson(jsonData);
      } else if (brokerType == 'upstox') {
        return FormFieldsResponse.fromJson(jsonData);
      } else {
        throw Exception('Unsupported broker type');
      }
    } else {
      throw Exception('Failed to load form fields');
    }
   }catch(e){
      print('Error in getFormFields: $e');
    
   }
  }
}

final formFieldsProvider =
    FutureProvider.family<dynamic, String>((ref, brokerType) async {
  return await PublicApiServices.getFormFields(brokerType, 'parent');
});

final formFieldsProvider2 =
    FutureProvider.family<dynamic, String>((ref, brokerType) async {
  return await PublicApiServices.getFormFields(brokerType, 'child');
});
