import 'dart:convert';

import 'package:get/get.dart';

import '../constant.dart';
import 'storage_service.dart';

class HttpService extends GetConnect {
  // Base URL for your API
  final String baseUrl;
  final StorageService storageService = Get.find<StorageService>();
  @override
  Future<void> onInit() async {
    super.onInit();
    var access = await storageService.get(AuthConstant.user);
    if (access != null) {
      var user_access = json.decode(access);
      print('Emersonnnnnnn --------${user_access['access_token']['access']}');
      headers.addEntries([
        MapEntry(
            'Authorization', 'Bearer  ${user_access['access_token']['access']}')
      ]);
    }
  }

  // Headers for HTTP requests
  Map<String, String> headers = {
    "Accept": "application/json;odata=verbose",
  };

  HttpService(this.baseUrl);

  // Function for making a GET request
  Future<Response> getRequest(String endpoint) async {
    return await get(endpoint, headers: headers);
  }

  // Function for making a POST request
  Future<Response> postRequest(String endpoint, dynamic data) async {
    return await post(endpoint, data, headers: headers);
  }

  // Function for making a PUT request
  Future<Response> putRequest(String endpoint, dynamic data) async {
    return await put(endpoint, data, headers: headers);
  }

  // Future<Response> postRequest(String uri, dynamic body) async {
  //   try {
  //     Response response = await post(
  //       uri,
  //       body,
  //       headers: headers,
  //     );
  //     response = handleResponse(response);
  //     // if(Foundation.kDebugMode) {
  //     //   log('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
  //     // }
  //     return response;
  //   } catch (e) {
  //     return Response(statusCode: 1, statusText: e.toString());
  //   }
  // }

  // Response handleResponse(Response response) {
  //   Response _response = response;
  //   if (_response.hasError &&
  //       _response.body != null &&
  //       _response.body is! String) {
  //     if (_response.body.toString().startsWith('{errors: [{code:')) {
  //       _response = Response(
  //           statusCode: _response.statusCode,
  //           body: _response.body,
  //           statusText: "Error");
  //     } else if (_response.body.toString().startsWith('{message')) {
  //       _response = Response(
  //           statusCode: _response.statusCode,
  //           body: _response.body,
  //           statusText: _response.body['message']);
  //     }
  //   } else if (_response.hasError && _response.body == null) {
  //     print("The status code is " + _response.statusCode.toString());
  //     _response = Response(
  //         statusCode: 0,
  //         statusText:
  //             'Connection to API server failed due to internet connection');
  //   }
  //   return _response;
  // }

  // Function for making a PATCH request
  Future<Response> patchRequest(String endpoint, dynamic data) async {
    return await patch('$baseUrl/$endpoint', data, headers: headers);
  }

  // Function for making a DELETE request
  Future<Response> deleteRequest(String endpoint) async {
    return await delete('$baseUrl/$endpoint', headers: headers);
  }
}
