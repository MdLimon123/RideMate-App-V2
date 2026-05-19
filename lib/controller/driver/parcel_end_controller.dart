import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/model/driver/rider_history_model.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ParcelEndController extends GetxController {
  Rx<File?> parcelImage = Rx<File?>(null);
  var isLoading = false.obs;

  final RxString selectedOption = 'All'.obs;
  final RxString selectedTab = 'trip'.obs;

  final RxList<RiderHistoryItem> riderHistoryList = <RiderHistoryItem>[].obs;

  int page = 1;
  bool hasMore = true;

  final Map<String, String> optionsMap = {
    'All': 'all_time',
    'This Week': 'this_week',
    'This Month': 'this_month',
  };

  void changeOption(String newValue) {
    selectedOption.value = newValue;
    page = 1;
    hasMore = true;
    riderHistoryList.clear();
    fetchRiderHistory();
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  Future<void> pickParcelImage({bool fromCamera = true}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile != null) {
      parcelImage.value = pickedFile;
    }
  }

  Future<List<String>?> uplaodParcelImage({
    required String imagePath,
    required String parcelId,
  }) async {
    try {
      isLoading(true);

      final multipartBody = [MultipartBody('files', File(imagePath))];

      final response = await ApiClient.postMultipartData(
        "/parcels/deliver-parcel",
        {"parcel_id": parcelId},
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(response.statusText, isError: false);
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        if (body is Map && body['files'] is List) {
          return List<String>.from(body['files']);
        }
      } else {
        showCustomSnackBar(response.statusText, isError: true);
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
    return null;
  }

  Future<void> fetchRiderHistory() async {
    if (!hasMore) return;

    isLoading(true);

    String url = '/ride-history';
    if (selectedOption.value.isNotEmpty) {
      String dateRange = optionsMap[selectedOption.value] ?? '-1';
      url = '/ride-history?dateRange=$dateRange&page=$page';
    }

    final response = await ApiClient.getData(url);

    if (response.statusCode == 200) {
      final json = response.body;
      final model = RiderHistoryModel.fromJson(json);
      riderHistoryList.addAll(model.data);
      hasMore = model.data.isNotEmpty;
    } else {
      hasMore = false;
      debugPrint("Failed to load rider history: ${response.statusCode}");
    }

    isLoading(false);
  }
}
