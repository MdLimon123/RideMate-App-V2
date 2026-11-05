import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/driver_profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

class TermsServiceScreen extends StatefulWidget {
  const TermsServiceScreen({super.key});

  @override
  State<TermsServiceScreen> createState() => _TermsServiceScreenState();
}

class _TermsServiceScreenState extends State<TermsServiceScreen> {
  final _driverProfileController = Get.put(DriverProfileController());

  @override
  void initState() {
    super.initState();
    _driverProfileController.fetchTermsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Terms & Services"),
      body: Obx(
        () => _driverProfileController.termModel.value.content == null
            ? Center(child: CustomLoading(color: AppColors.primaryColor))
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                children: [
                  Html(
                    data: _driverProfileController.termModel.value.content!,
                    style: {
                      "p": Style(
                        fontSize: FontSize(14),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF5A5A5A),
                      ),
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
