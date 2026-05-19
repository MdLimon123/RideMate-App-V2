import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FindingForParcelRewuest extends StatefulWidget {
  final String pickLocation;
  final String dropLocation;
  const FindingForParcelRewuest({
    super.key,
    required this.pickLocation,
    required this.dropLocation,
  });

  @override
  State<FindingForParcelRewuest> createState() =>
      _FindingForParcelRewuestState();
}

class _FindingForParcelRewuestState extends State<FindingForParcelRewuest>
    with TickerProviderStateMixin {
  final RideController _rideController = Get.find<RideController>();

  final pickupLocationController = TextEditingController();
  final dropLocationController = TextEditingController();

  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;


  @override
  void initState() {
    setupAnimation();
    super.initState();
  }

  void setupAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _opacityAnim = Tween<double>(
      begin: 0.4,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();

    //SocketService().socket?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pickupLocationController.text = widget.pickLocation;
    dropLocationController.text = widget.dropLocation;
    return Scaffold(
      appBar: const CustomAppbar(title: "Searching"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: pickupLocationController,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/pick.svg'),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFB5F5D7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFB5F5D7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFB5F5D7)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFE6E6E6).withValues(alpha: 0.24),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                readOnly: true,
                controller: dropLocationController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/location.svg'),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFB5F5D7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFB5F5D7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFB5F5D7)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFE6E6E6).withValues(alpha: 0.24),
                ),
              ),

              const SizedBox(height: 32),

              Container(
                height: 260,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF345983),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


               
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnim.value * 1.2,
                                child: Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(
                                      _opacityAnim.value * 0.5,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnim.value,
                                child: Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(
                                      _opacityAnim.value,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          AnimatedBuilder(
                            animation: _rotateController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotateController.value * 2 * 3.14159,
                                child: child,
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/icons/search_fill.svg',
                              colorFilter: ColorFilter.mode(
                                Colors.white.withOpacity(0.9),
                                BlendMode.srcIn,
                              ),
                              width: 72,
                              height: 72,
                            ),
                          ),
                        ],
                      ),
                    ),



                    const SizedBox(height: 15),

                    Text(
                      "searching".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),

              Obx(
                () => CustomButton(
                  loading: _rideController.isLoading.value,
                  onTap: () {
                    final parcelData =
                        _rideController.parcelResponse.value.data;
                    if (parcelData != null) {
                      _rideController.cancelParcel(parcelData.id);
                    } else {
                      print("No trip data available yet.");
                    }
                  },
                  text: "cancel".tr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
