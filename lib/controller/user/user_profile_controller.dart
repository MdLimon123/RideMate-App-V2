import 'package:get/get.dart';

class UserProfileController extends GetxController {

  
  final RxString selectedOption = 'All'.obs;
  final Map<String, String> optionsMap = {
    'All': 'all_time',
    'This Week': 'this_week',
    'This Month': 'this_month',
  };

  void changeOption(String newValue) {
    selectedOption.value = newValue;
  }
}
