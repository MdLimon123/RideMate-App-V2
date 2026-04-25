import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/data_controller.dart';
import 'package:flutter_extension/controller/driver/driver_ride_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/model/driver/driver_info_model.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_email_verify_page.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_login_screen.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_otp_verify_screen.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_terms_condition_screen.dart';
import 'package:flutter_extension/views/screen/driver/auth/reset_password_screen.dart';
import 'package:flutter_extension/views/screen/driver/auth/setUpProfile/driver_verify_screen.dart';
import 'package:flutter_extension/views/screen/driver/main/main_driver.dart';
import 'package:get/get.dart';

class DriverAuthController extends GetxController {
  var isLoading = false.obs;
  var isForgetLoading = false.obs;
  var isForgetOtp = "".obs;
  var isVerify = false.obs;
  final DriverRideController _driverRideController = Get.put(
    DriverRideController(),
    permanent: true,
  );

  var isResetLoading = false.obs;
  final _dataController = Get.put(DataController());

  Future<void> signup({
    required String email,
    required String password,
    required String phone,
  }) async {
    isLoading(true);

    final body = {
      "email": email,
      "password": password,
      "role": "DRIVER",
      "phone": phone,
    };
    var headers = {'Content-Type': 'application/json'};

    final response = await ApiClient.postData(
      "/auth/register",
      body,
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await PrefsHelper.setString(
        AppConstants.bearerTokenKEN,
        response.body['access_token'],
      );
      await ApiClient.refreshToken();
      print("status text ====> ${response.statusText}");
      showCustomSnackBar(response.statusText, isError: false);
      Get.to(() => DriverEmailVerifyPage(email: email));
    } else {
      print("status text ====> ${response.statusText}");
      showCustomSnackBar(response.statusText, isError: true);
    }
    isLoading(false);
  }

  /// Login
  ///
  Future<void> login({required String email, required String password}) async {
    isLoading(true);

    final body = {"email": email, "password": password};

    var headers = {'Content-Type': 'application/json'};

    final response = await ApiClient.postData(
      "/auth/login",
      body,
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final driverInfo = DriverInfoModel.fromJson(response.body);

      final token = response.body['access_token'];

      await PrefsHelper.setString(AppConstants.bearerTokenKEN, token);
      await PrefsHelper.setUserInfo(response.body);

      /// Force refresh ApiClient headers with new token
      await ApiClient.refreshToken();

      _dataController.setProfileData(
        isActiveD: response.body['user']['is_active'],
        idD: response.body['user']['id'],
        nameD: response.body['user']['name'],
        roleD: response.body['user']['role'],
      );

      showCustomSnackBar(response.statusText, isError: false);

      Future.delayed(const Duration(milliseconds: 300), () async {
        if (driverInfo.driver.isActive) {
          try {
            await _driverRideController.listenDriverRide();
          } catch (e) {
            debugPrint('⚠️ Socket connection failed, but continuing: $e');
          }
          Get.offAll(() => const MainDriver());
        } else {
          Get.offAll(() => const DriverVerifyScreen());
        }
      });
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isLoading(false);
  }

  /// forget
  Future<void> forgetPassword({required String email}) async {
    isForgetLoading(true);

    final body = {"email": email};

    var headers = {'Content-Type': 'application/json'};

    final resposne = await ApiClient.postData(
      "/auth/forgot-password",
      body,
      headers: headers,
    );

    if (resposne.statusCode == 200 || resposne.statusCode == 201) {
      showCustomSnackBar(resposne.statusText, isError: false);

      Get.to(() => DriverOtpVerifyScreen(email: email));
    } else {
      showCustomSnackBar(resposne.statusText, isError: true);
    }
    isForgetLoading(false);
  }

  /// otp

  Future<void> otpEmailVerify({required String email}) async {
    isVerify(true);
    final body = {"email": email, "otp": isForgetOtp.value};

    var headers = {'Content-Type': 'application/json'};

    final response = await ApiClient.postData(
      "/auth/account-verify",
      body,
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await PrefsHelper.setString(
        AppConstants.bearerTokenKEN,
        response.body['access_token'],
      );
      await ApiClient.refreshToken();
      showCustomSnackBar(response.statusText, isError: false);
      Get.to(() => const DriverTermsConditionScreen());
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isVerify(false);
  }

  Future<void> otpForgetVerify({required String email}) async {
    isVerify(true);
    final body = {"email": email, "otp": isForgetOtp.value};

    var headers = {'Content-Type': 'application/json'};

    final response = await ApiClient.postData(
      "/auth/forgot-password/otp-verify",
      body,
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await PrefsHelper.setString(
        AppConstants.bearerTokenKEN,
        response.body['reset_token'],
      );
      await ApiClient.refreshToken();
      showCustomSnackBar(response.statusText, isError: false);
      Get.to(() => const ResetPasswordScreen());
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isVerify(false);
  }

  Future<void> resendEmailVerify({required String email}) async {
    final body = {"email": email};
    var headers = {'Content-Type': 'application/json'};

    final response = await ApiClient.postData(
      "/auth/account-verify/otp-send",
      body,
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
  }

  Future<void> resendOtpVerify({required String email}) async {
    final body = {"email": email};
    var headers = {'Content-Type': 'application/json'};

    final response = await ApiClient.postData(
      "/auth/forgot-password",
      body,
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
  }

  Future<void> resetPassword({required String passwordText}) async {
    isResetLoading(true);

    final body = {"password": passwordText};

    final response = await ApiClient.postData("/auth/reset-password", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(response.statusText, isError: false);
      Get.to(() => const DriverLoginScreen());
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isResetLoading(false);
  }
}
