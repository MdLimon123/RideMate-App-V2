import 'package:get/get.dart';

class LanguageController extends GetxController {
  var isExpanded = false.obs;
  var selectedLanguage = 'French'.obs;

  List<String> languages = ['French', 'English', 'Português', 'Arabic'];

  void selectLanguage(String lang) {
    selectedLanguage.value = lang;
  }
}
