import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/language_controller.dart';
import 'package:flutter_extension/controller/localization_controller.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/util/style.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/screen/driver/auth/driver_login_screen.dart';
import 'package:get/get.dart';

class DriverSelectedLangugeScreen extends StatefulWidget {
  const DriverSelectedLangugeScreen({super.key});

  @override
  State<DriverSelectedLangugeScreen> createState() =>
      _DriverSelectedLangugeScreenState();
}

class _DriverSelectedLangugeScreenState
    extends State<DriverSelectedLangugeScreen> {
  final _languageController = Get.put(LanguageController());
  final _localizationController = Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              "choose".tr,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "select".tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 32),
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  GestureDetector(
                    onTap: () => _languageController.isExpanded.toggle(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6EAF0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _languageController.selectedLanguage.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Icon(
                            _languageController.isExpanded.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFF333333),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_languageController.isExpanded.value) ...[
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6EAF0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _languageController.languages.map((lang) {
                          return GestureDetector(
                            onTap: () {
                              _languageController.selectLanguage(lang.tr);

                              final selectedLangModel = AppConstants.languages
                                  .firstWhere(
                                    (language) => language.languageName == lang,
                                    orElse: () => AppConstants.languages[0],
                                  );

                              _localizationController.setLanguage(
                                Locale(
                                  selectedLangModel.languageCode,
                                  selectedLangModel.countryCode,
                                ),
                              );

                              _languageController.isExpanded.value = false;
                            },
                            child: ListTile(
                              title: Text(
                                lang.tr,
                                style: AppStyles.h3(
                                  color: const Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              );
            }),
            const SizedBox(height: 205),
            CustomButton(
              onTap: () {
                Get.offAll(() => const DriverLoginScreen());
              },
              text: "next".tr,
            ),
          ],
        ),
      ),
    );
  }
}
