import 'dart:convert';
import 'package:bits_trade/data/modals/child_data_modal.dart';
import 'package:bits_trade/data/modals/parent_data_modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/custom_toast.dart';

// Define a provider for the API service
final parentApiServiceProvider = Provider<ParentApiService>(
    (ref) => ParentApiService(client: http.Client()));

class ParentApiService {
  final http.Client _client;

  ParentApiService({required http.Client client}) : _client = client;

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
      print(parent);
      print(token);

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
      String parentId,) async {
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
  return ChildApiService(Dio());
});

class ChildApiService {
  final Dio _dio;

  ChildApiService(this._dio);

  Future<void> addChild(Map<String, dynamic> childData) async {
    var token = await SharedPrefs.getToken();
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await _dio.post(
          '${Constants.apiBaseUrl}/api/v1/child/add',
          data: childData,
          options: Options(headers: headers));
      // Handle success response (if needed)
print('childData bp------ $childData');
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
  Future<void> updateChildLoginStatus(String childId)async{

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

  Future<void> updateParentConnection(String parentId,) async {
    try {
      await parentApiService.updateParentLoginStatus(parentId);
      // Refresh parent data to update the connection status in the UI
      await loadParentData();
    } catch (e) {
      print('Error updating parent connection: ${e.toString()}');
    }
  }

  Future<void> updateChildConnection(String childId)async{
    try{
      await childApiService.updateChildLoginStatus(childId);
      await loadChildData();
    }catch (e){

        print('Error updating child connection: ${e.toString()}');
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

