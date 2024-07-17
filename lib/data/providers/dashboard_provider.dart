import 'dart:convert';
import 'package:bits_trade/data/modals/child_data_modal.dart';
import 'package:bits_trade/data/modals/parent_data_modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/custom_toast.dart';
import '../modals/get_funds_model.dart';
import '../modals/parent_positions_model.dart';

// Define a provider for the API service
final parentApiServiceProvider = Provider<ParentApiService>(
  (ref) => ParentApiService(client: http.Client(),  ref), // Inject ref
);
class ParentApiService {
  final http.Client _client;
    final ProviderRef<ParentApiService> ref; 

  ParentApiService(this.ref, {required http.Client client}) : _client = client;

  Future<GetFundsModel?> getFunds(
    String parentId,
  ) async {
    final url = Uri.parse(
        '${Constants.apiBaseUrl}/api/v1/parent/get-funds?parentId=$parentId');
    var token = await SharedPrefs.getToken();
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return GetFundsModel.fromJson(jsonResponse);
      } else if(response.statusCode == 400) {
        var message =await json.decode(response.body)['status']['message'];
      if (message.contains('Invalid broker token, login again')) {

        await ref.read(dashboardProvider.notifier).loadParentData();
        showToast('Failed to fetch funds. Please re-login to your broker account');


       return null;
        
      }
        // print('Error fetching funds: ${response.body} ,${response.statusCode}');
        // Handle errors as needed (e.g., throw an exception)
        return null;
      }else{
        print('Error fetching funds: ${response.body} ,${response.statusCode}');
        // Handle errors as needed (e.g., throw an exception)
        return null;
      }
    } catch (e) {
      print('Error fetching funds: ${e.toString()}');
      // Handle network or other exceptions
      return null;
    }
  }

  Future<ParentPositionsModel?> getPositions(
    String parentId,
  ) async {
    final url = Uri.parse(
        '${Constants.apiBaseUrl}/api/v1/parent/get-positions?parentId=$parentId');
    var token = await SharedPrefs.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ParentPositionsModel.fromJson(jsonResponse);
      } else {
        print('Error fetching positions: ${response.statusCode}');
        // Handle errors as needed
        return null;
      }
    } catch (e) {
      print('Error fetching positions: ${e.toString()}');
      // Handle exceptions
      return null;
    }
  }

  //close all positions

  Future<void> closeAllPositions(String parentId) async {
    var token = await SharedPrefs.getToken();
    try {
      // Define the API endpoint
      final String endpoint =
          '${Constants.apiBaseUrl}/api/v1/parent/close-all-positions?parentId=$parentId';

      // Make the DELETE request
      final response = await _client.delete(
        Uri.parse(endpoint),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      print(response.body);

      // Handle the response
      switch (response.statusCode) {
        
        case 200:
          // Successful response
          showToast('All positions closed successfully');
          break;
        case 400:
          // Unauthorized
          showToast('Please re-login to your broker account');
          break;
        default:
          // Other errors
          showToast('An error occurred');
      }
    } catch (e) {
      // Handle any network errors
      showToast('Something went wrong');
    }
  }

  // Method to add a new parent
  Future<void> addParent(Map<String, dynamic> parent) async {
    var token = await SharedPrefs.getToken();
    try {
      // Define the API endpoint
      const String endpoint = '${Constants.apiBaseUrl}/api/v1/parent/add';

      // Make the POST request
      final response = await _client.post(
        Uri.parse(endpoint),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(parent),
      );
      print('parent api send data $parent');
      print('response $response');

      // Handle the response
      switch (response.statusCode) {
        case 200:
          // Successful response
          showToast('Parent added successfully');
          break;
        case 422:
          // Validation error
          // Extract the error details from the response
          final errorDetails = jsonDecode(response.body)['detail'] as List;
          // Extract the error message from the error details
          String errorMessage =
              errorDetails.map((error) => error['msg']).join(', ');
          showToast(errorMessage);
          break;
        case 401:
          // Unauthorized
          showToast('Unauthorized');
          break;
        default:
          // Other errors
          showToast('An error occurred');
      }
    } catch (e) {
      // Handle any network errors
      showToast('Something went wrong');
    }
  }

  Future<String?> startSocket(String parentId) async {
    final url = Uri.parse(
        '${Constants.apiBaseUrl}/api/v1/parent/start-socket?parentId=$parentId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        print(response.body);
        return response.body;
      } else if (response.statusCode == 422) {
        // If the server returns a 422 Unprocessable Entity response, parse the error details.
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception('Validation error: ${errorResponse['detail']}');
      } else {
        // If the server returns any other response, throw an exception.
        throw Exception(
            'Failed to start socket. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the HTTP request.
      print('Error: $e');
      rethrow;
    }
  }

  Future<String?> stopSocket(String parentId) async {
    final url = Uri.parse(
        '${Constants.apiBaseUrl}/api/v1/parent/stop-socket?parentId=$parentId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
        // If the server returns a 200 OK response, parse the JSON.
        return response.body;
      } else if (response.statusCode == 422) {
        // If the server returns a 422 Unprocessable Entity response, parse the error details.
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception('Validation error: ${errorResponse['detail']}');
      } else {
        // If the server returns any other response, throw an exception.
        throw Exception(
            'Failed to stop socket. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the HTTP request.
      print('Error: $e');
      rethrow;
    }
  }

  // Method to get all parent data
  Future<ParentData?> getParents() async {
    var token = await SharedPrefs.getToken();
    try {
      // Define the API endpoint
      const String endpoint =
          '${Constants.apiBaseUrl}/api/v1/parent/getParents';

      // Make the GET request

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print(response.body);

      // Handle the response
      switch (response.statusCode) {
        case 200:
          // Successful response
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          return ParentData.fromJson(jsonData);
        case 401:
          // Unauthorized
          showToast('Unauthorized');
          break;
        default:
          // Other errors
          showToast('An error occurred');
      }
    } catch (e) {
      // Handle any network errors
      showToast('Something went wrong');
      return null;
    }
    return ParentData(); // Return an empty ParentData object on error
  }

  // Method to update a parent
  Future<void> updateParent(Map<String, dynamic> parent) async {
    var token = await SharedPrefs.getToken();

    try {
      // Define the API endpoint
      const String endpoint = '${Constants.apiBaseUrl}/api/v1/parent/update';
      print('update parent $parent');
      // Make the PUT request
      final response = await _client.put(
        Uri.parse(endpoint),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(parent),
      );
      print(response.body);
      // Handle the response
      switch (response.statusCode) {
        case 200:
          await getParents();

          // Successful response
          showToast('Parent updated successfully');
          break;
        case 422:
          // Validation error
          // Extract the error details from the response
          final errorDetails = jsonDecode(response.body)['detail'] as List;
          // Extract the error message from the error details
          String errorMessage =
              errorDetails.map((error) => error['msg']).join(', ');
          showToast(errorMessage);
          break;
        case 401:
          // Unauthorized
          showToast('Unauthorized');
          break;
        default:
          // Other errors
          showToast('An error occurred');
      }
    } catch (e) {
      // Handle any network errors
      showToast('Something went wrong');
    }
  }

  // Method to delete a parent
  Future<void> deleteParent(String parentId) async {
    var token = await SharedPrefs.getToken();

    try {
      // Define the API endpoint
      final String endpoint =
          '${Constants.apiBaseUrl}/api/v1/parent/delete?parentId=$parentId';

      // Make the DELETE request
      final response = await _client.delete(
        Uri.parse(endpoint),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      // Handle the response
      switch (response.statusCode) {
        case 200:
          // Successful response
          showToast('Parent deleted successfully');
          break;
        case 401:
          // Unauthorized
          showToast('Unauthorized');
          break;
        default:
          // Other errors
          showToast('An error occurred');
      }
    } catch (e) {
      // Handle any network errors
      showToast('Something went wrong');
    }
  }

  // Add a method to update parent login status
  Future<void> updateParentLoginStatus(
    String parentId,
  ) async {
    var token = await SharedPrefs.getToken();

    try {
      // Define the API endpoint
      final String endpoint =
          '${Constants.apiBaseUrl}/api/v1/parent/login?parentId=$parentId';

      // Make the PUT request
      final response = await _client.post(
        Uri.parse(endpoint),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      print(response.body);
      // Handle the response
      switch (response.statusCode) {
        case 200:
          print('login status response ${response.body}');
          // Successful response
          // Update the state in the dashboard provider
          showToast('Parent login status updated successfully');
          break;
        case 401:
          // Unauthorized
          showToast('Unauthorized');
          break;
        default:
          // Other errors
          showToast('An error occurred');
      }
    } catch (e) {
      // Handle any network errors
      showToast('Something went wrong');
    }
  }
}

// Child Provider
final childApiServiceProvider = Provider<ChildApiService>((ref) {
  return ChildApiService(Dio(),ref);
});

class ChildApiService {
  final Dio _dio;
    final ProviderRef<ChildApiService> ref; // Add ProviderRef

  ChildApiService(this._dio, this.ref);

  Future<String?> updateChildStatus(
    String childId,
    bool status,
  ) async {
    var accessToken = await SharedPrefs.getToken();
    final url = Uri.parse(
        '${Constants.apiBaseUrl}/api/v1/child/updateStatus?childId=$childId&status=$status');

    try {
      final response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Successful response
        print('Child status updated successfully!');
        return "Success"; // or return the response body if needed
      } else {
        // Handle errors based on the status code
        print('Error updating child status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null; // Or throw an exception
      }
    } catch (e) {
      // Handle network or other exceptions
      print('Error updating child status: ${e.toString()}');
      return null; // Or throw an exception
    }
  }

  Future<GetFundsModel?> getFunds(
    String childId,
  ) async {
    final url = Uri.parse(
        '${Constants.apiBaseUrl}/api/v1/child/get-funds?childId=$childId');
    var token = await SharedPrefs.getToken();
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('child funds: ${response.body}');
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return GetFundsModel.fromJson(jsonResponse);
      }else if(response.statusCode == 400) {
        var message =await json.decode(response.body)['status']['message'];
      if (message.contains('Invalid broker token, login again')) {

        await ref.read(dashboardProvider.notifier).loadChildData();
        showToast('Failed to fetch funds. Please re-login to your broker account');


       return null;
        
      }
        // print('Error fetching funds: ${response.body} ,${response.statusCode}');
        // Handle errors as needed (e.g., throw an exception)
        return null;
      }else{
        print('Error fetching funds: ${response.body} ,${response.statusCode}');
        // Handle errors as needed (e.g., throw an exception)
        return null;
      }
    } catch (e) {
      print('Error fetching funds: ${e.toString()}');
      // Handle network or other exceptions
      return null;
    }
  }

  Future<ParentPositionsModel?> getPositions(
    String childId,
  ) async {
    final url = Uri.parse(
        '${Constants.apiBaseUrl}/api/v1/child/get-positions?childId=$childId');
    var token = await SharedPrefs.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('child Postions: ${response.body}');
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ParentPositionsModel.fromJson(jsonResponse);
      } else {
        print('Error fetching positions: ${response.statusCode}');
        // Handle errors as needed
        return null;
      }
    } catch (e) {
      print('Error fetching positions: ${e.toString()}');
      // Handle exceptions
      return null;
    }
  }

  Future<void> addChild(Map<String, dynamic> childData) async {
    var token = await SharedPrefs.getToken();
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/api/v1/child/add'),
        body: json.encode(childData),
        headers: headers,
      );
      // Handle success response (if needed)
      print('childData add child ------ $childData');
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        showToast('Child added successfully');
      } else if (response.statusCode == 422) {
        // Validation error
        // Extract the error details from the response
        // final errorDetails = jsonDecode(response.body)['detail'] as List;
        // // Extract the error message from the error details
        // String errorMessage =
        //     errorDetails.map((error) => error['msg']).join(', ');
        // showToast(errorMessage);
      } else if (response.statusCode == 401) {
        // Unauthorized
        showToast('Unauthorized');
      } else {
        // Other errors
        showToast('An error occurred');
      }
    } catch (error) {
      // Handle API errors
      showToast('Something went wrong');
      print(error);
    }
  }

  Future<void> updateChild(
      Map<String, dynamic> childData, String childId) async {
    var token = await SharedPrefs.getToken();
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await _dio.put(
          '${Constants.apiBaseUrl}/api/v1/child/update?childId=$childId',
          data: childData,
          options: Options(headers: headers));
      // Handle success response (if needed)
      print(response.data);
      if (response.statusCode == 200) {
        showToast('Child updated successfully');
      } else if (response.statusCode == 422) {
        // Validation error
        // Extract the error details from the response
        // final errorDetails = jsonDecode(response.body)['detail'] as List;
        // // Extract the error message from the error details
        // String errorMessage =
        //     errorDetails.map((error) => error['msg']).join(', ');
        // showToast(errorMessage);
      } else if (response.statusCode == 401) {
        // Unauthorized
        showToast('Unauthorized');
      } else {
        print(response.data);
        // Other errors
        showToast('An error occurred');
      }
    } catch (error) {
      // Handle API errors
      showToast('Something went wrong');
      print(error);
    }
  }

  Future<ChildData?> getChild(String childId) async {
    var token = await SharedPrefs.getToken();
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await _dio.get(
          '${Constants.apiBaseUrl}/api/v1/child/single?childId=$childId',
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        return ChildData.fromJson(response.data);
      } else if (response.statusCode == 401) {
        // Unauthorized
        showToast('Unauthorized');
      } else {
        // Other errors
        showToast('An error occurred');
      }
    } catch (error) {
      // Handle API errors
      showToast('Something went wrong');
      print(error);
    }
    return null;
  }

  Future<List<ChildData>> getChilds() async {
    var token = await SharedPrefs.getToken();
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await _dio.get(
          '${Constants.apiBaseUrl}/api/v1/child/getChilds',
          options: Options(headers: headers));
      print(response);
      if (response.statusCode == 200) {
        print(response.data['data']);
        var data = response.data['data'];
        if (data.isEmpty) {
          return [];
        } else {
          final List<dynamic> data = response.data['data'];
          return data.map((child) => ChildData.fromJson(child)).toList();
        }
      } else if (response.statusCode == 401) {
        // Unauthorized
        showToast('Unauthorized');
      } else {
        // Other errors
        showToast('An error occurred');
      }
    } catch (error) {
      // Handle API errors
      showToast('Something went wrong');
      print(error);
    }
    return [];
  }

  Future<void> deleteChild(String childId) async {
    var token = await SharedPrefs.getToken();
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await _dio.delete(
          '${Constants.apiBaseUrl}/api/v1/child/delete?childId=$childId',
          options: Options(headers: headers));
      // Handle success response (if needed)
      if (response.statusCode == 200) {
        showToast('Child Deleted Successfully');
      } else if (response.statusCode == 401) {
        // Unauthorized
        showToast('Unauthorized');
      } else {
        // Other errors
        showToast('An error occurred');
      }
      print(response.data);
    } catch (error) {
      showToast('Something went wrong');
      // Handle API errors
      print(error);
    }
  }

  Future<void> updateChildLoginStatus(String childId) async {
    var token = await SharedPrefs.getToken();

    try {
      // Define the API endpoint
      final String endpoint =
          '${Constants.apiBaseUrl}/api/v1/child/login?childId=$childId';

      // Make the PUT request
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      print(response.body);
      print(childId);
      // Handle the response
      switch (response.statusCode) {
        case 200:
          print('login status response ${response.body}');
          // Successful response
          // Update the state in the dashboard provider
          showToast('Child login status updated successfully');
          break;
        case 401:
          // Unauthorized
          showToast('Unauthorized');
          break;
        default:
          // Other errors
          showToast('An error occurred');
      }
    } catch (e) {
      // Handle any network errors
      showToast('Something went wrong');
    }
  }
}

class DashboardState extends StateNotifier<DashboardData> {
  final ParentApiService parentApiService;
  final ChildApiService childApiService;

  DashboardState(this.parentApiService, this.childApiService)
      : super(DashboardData());

  Future<void> loadParentData() async {
    final parentData = await parentApiService.getParents();
    print(parentData);
    state = state.copyWith(parentData: parentData);
  }

  Future<void> loadChildData() async {
    final childData = await childApiService.getChilds();
    state = state.copyWith(childData: childData);
  }

  Future<void> updateParentConnection(
    String parentId,
  ) async {
    try {
      await parentApiService.updateParentLoginStatus(parentId);
      // Refresh parent data to update the connection status in the UI
      await loadParentData();
    } catch (e) {
      print('Error updating parent connection: ${e.toString()}');
    }
  }

  Future<void> updateChildConnection(String childId) async {
    try {
      await childApiService.updateChildLoginStatus(childId);
      await loadChildData();
    } catch (e) {
      print('Error updating child connection: ${e.toString()}');
    }
  }

  Future<void> updateChildStatus(String childId, bool status) async {
    try {
      await childApiService.updateChildStatus(childId, status);
      // Refresh child data to update the status in the UI
      await loadChildData();
    } catch (e) {
      print('Error updating child status: ${e.toString()}');
    }
  }
}

class DashboardData {
  final ParentData? parentData;
  final List<ChildData>? childData;

  DashboardData({this.parentData, this.childData});

  DashboardData copyWith({
    ParentData? parentData,
    List<ChildData>? childData,
  }) {
    return DashboardData(
      parentData: parentData ?? this.parentData,
      childData: childData ?? this.childData,
    );
  }
}

final dashboardProvider = StateNotifierProvider<DashboardState, DashboardData>(
  (ref) {
    final parentApiService = ref.watch(parentApiServiceProvider);
    final childApiService = ref.watch(childApiServiceProvider);

    return DashboardState(parentApiService, childApiService);
  },
);
