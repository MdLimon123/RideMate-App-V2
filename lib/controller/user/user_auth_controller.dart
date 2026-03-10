import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/data_controller.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/model/user/user_info_model.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/user/auth/setUpProfile/user_verify_screen.dart';
import 'package:flutter_extension/views/screen/user/auth/user_login_screen.dart';
import 'package:flutter_extension/views/screen/user/auth/user_otp_verify_screen.dart';
import 'package:flutter_extension/views/screen/user/auth/user_reset_password_screen.dart';
import 'package:flutter_extension/views/screen/user/auth/user_terms_comdition_screen.dart';
import 'package:flutter_extension/views/screen/user/home/user_home.dart';
import 'package:get/get.dart';

class UserAuthController extends GetxController {
  var isLoading = false.obs;
  var isForgetLoading = false.obs;
  var isForgetOtp = "".obs;
  var isVerify = false.obs;

  var isResetLoading = false.obs;
  final _dataController = Get.put(DataController());
  final _rideController = Get.put(RideController(), permanent: true );

  /// Signup

  Future<void> signup({required String email, required String password}) async {
    isLoading(true);

    final body = {"email": email, "password": password, "role": "USER"};
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
      print("status text ====> ${response.statusText}");
      showCustomSnackBar(response.statusText, isError: false);
      Get.to(() => const UserTermsComditionScreen());
    } else {
      print("status text ====> ${response.statusText}");
      showCustomSnackBar(response.statusText, isError: true);
    }
    isLoading(false);
  }

  /// Login
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
      final userInfo = UserInfoModel.fromJson(response.body);

      final token = response.body['access_token'];
      print("token : $token");

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

      Future.delayed(const Duration(milliseconds: 300), () async{
        if (userInfo.user.isActive) {
          Get.offAll(() => const UserHome());
          try {
            await _rideController.listenTripAndParcel();
          } catch (e) {
            debugPrint('⚠️ Socket connection failed, but continuing: $e');
          }
        } else {
          Get.offAll(() => const UserVerifyScreen());
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

      Get.to(() => UserOtpVerifyScreen(email: email));
    } else {
      showCustomSnackBar(resposne.statusText, isError: true);
    }
    isForgetLoading(false);
  }

  /// otp

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
      showCustomSnackBar(response.statusText, isError: false);
      Get.to(() => const UserResetPasswordScreen());
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isVerify(false);
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
      Get.to(() => const UserLoginScreen());
    } else {
      showCustomSnackBar(response.statusText, isError: true);
    }
    isResetLoading(false);
  }
}
