// ignore_for_file: depend_on_referenced_packages, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';

class ApiClient extends GetxService {
  static ApiClient get instance => Get.find<ApiClient>();
  static var client = http.Client();

  static String baseUrl = ApiConstant.BASE_URL;
  static SharedPreferences? _prefs;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  static int timeoutInSeconds = 30;
  static String? token;
  static Map<String, String>? _mainHeaders;

  static Future<void> loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    token = await PrefsHelper.getString(AppConstants.bearerTokenKEN);
    _mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Force reload token and headers (call after login/logout)
  static Future<void> refreshToken() async {
    _prefs = null;
    token = null;
    _mainHeaders = null;
    await loadPrefs();
  }

  static Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      if (_prefs == null) await loadPrefs();
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      http.Response response = await client
          .get(Uri.parse(baseUrl + uri), headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('------------${e.toString()}');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> postData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      if (_prefs == null) await loadPrefs();
      debugPrint(
        '====> API Call: $uri\nHeader: ${headers ?? _mainHeaders} \nBody: $body',
      );
      http.Response response = await client
          .post(
            Uri.parse(baseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      debugPrint('====> API Response: ${response.body}');

      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  // static Future<Response> postData(
  //   String uri,
  //   Map<String, dynamic> body, {
  //   Map<String, String>? headers,
  // }) async {
  //   try {
  //     token = await PrefsHelper.getString(AppConstants.bearerTokenKEN);
  //     var mainHeaders = {
  //       // 'Content-Type': 'application/x-www-form-urlencoded',
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     };
  //     debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
  //     debugPrint('====> API Body: $body');
  //     debugPrint("Full API URL: ${baseUrl + uri}");

  //     http.Response response = await client
  //         .post(
  //           Uri.parse(baseUrl + uri),
  //           body: jsonEncode(body),
  //           headers: headers ?? _mainHeaders,
  //         )
  //         .timeout(Duration(seconds: timeoutInSeconds));

  //     debugPrint(
  //       "==========> Response Post Method :------ : ${response.statusCode}",
  //     );
  //     return handleResponse(response, uri);
  //   } catch (e) {
  //     print(" ==========> Error Post Method :------ : ${e.toString()}");
  //     return Response(statusCode: 1, statusText: noInternetMessage);
  //   }
  // }

  static Future<Response> postMultipartData(
    String uri,
    Map<String, String> body, {
    required List<MultipartBody> multipartBody,
    Map<String, String>? headers,
  }) async {
    try {
      if (_prefs == null) await loadPrefs();
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody.length} picture');

      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + uri));
      request.headers.addAll(headers ?? _mainHeaders!);
      for (MultipartBody element in multipartBody) {
        request.files.add(
          await http.MultipartFile.fromPath(element.key, element.file.path),
        );
      }
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(
        await request.send(),
      );
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      if (_prefs == null) await loadPrefs();
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      debugPrint('====> API Body: $body');
      http.Response response = await http
          .put(
            Uri.parse(baseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> putMultipartData(
    String uri,
    Map<String, String> body, {
    required List<MultipartBody> multipartBody,
    Map<String, String>? headers,
  }) async {
    try {
      if (_prefs == null) await loadPrefs();
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody.length} picture');
      var request = http.MultipartRequest('PUT', Uri.parse(baseUrl + uri));
      request.headers.addAll(headers ?? _mainHeaders!);
      // for (MultipartBody element in multipartBody) {
      //   for (MultipartBody element in multipartBody) {
      //     request.files.add(
      //       await http.MultipartFile.fromPath(element.key, element.file.path),
      //     );
      //   }
      // }
      for (MultipartBody element in multipartBody) {
        request.files.add(
          await http.MultipartFile.fromPath(element.key, element.file.path),
        );
      }
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(
        await request.send(),
      );
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> deleteData(
    String uri, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      if (_prefs == null) await loadPrefs();
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      debugPrint('====> API Call: $uri\n Body: $body');
      http.Response response = await http
          .delete(
            Uri.parse(baseUrl + uri),
            headers: headers ?? _mainHeaders,
            body: body,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
        headers: response.request!.headers,
        method: response.request!.method,
        url: response.request!.url,
      ),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      response0 = Response(
        statusCode: response0.statusCode,
        body: response0.body,
        statusText: response0.statusText,
      );
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint(
      '====> API Response: [${response0.statusCode}] $uri\n${response0.body}',
    );
    return response0;
  }

  static Future<Response> patchMultipartData(
    String uri,
    Map<String, String> body, {
    required List<MultipartBody> multipartBody,
    Map<String, String>? headers,
  }) async {
    try {
      String? bearerToken = await PrefsHelper.getString(
        AppConstants.bearerTokenKEN,
      );

      var mainHeaders = {'Authorization': 'Bearer $bearerToken'};

      var request = http.MultipartRequest('PATCH', Uri.parse(baseUrl + uri));
      request.headers.addAll(headers ?? mainHeaders);

      // Add files safely
      for (MultipartBody element in multipartBody) {
        if (!element.file.existsSync()) {
          print("File not found: ${element.file.path}");
          continue;
        }

        String extension = element.file.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';
        if (extension == 'png') mimeType = 'image/png';
        if (extension == 'jpg' || extension == 'jpeg') mimeType = 'image/jpeg';
        if (extension == 'avif') mimeType = 'image/avif';

        try {
          request.files.add(
            await http.MultipartFile.fromPath(
              element.key,
              element.file.path,
              contentType: http.MediaType(
                mimeType.split('/')[0],
                mimeType.split('/')[1],
              ),
            ),
          );
        } catch (e) {
          print("Error adding file: $e");
        }
      }

      request.fields.addAll(body);

      // Send request
      http.StreamedResponse streamedResponse = await request.send();
      String responseString = await streamedResponse.stream.bytesToString();

      print("Status code: ${streamedResponse.statusCode}");
      print("Response string: $responseString");

      return Response(
        statusCode: streamedResponse.statusCode,
        body: responseString,
      );
    } catch (e) {
      print("PATCH Multipart Exception: $e");
      return Response(statusCode: 0, body: e.toString());
    }
  }
}

class MultipartBody {
  String key;
  File file;
  MultipartBody(this.key, this.file);
}
