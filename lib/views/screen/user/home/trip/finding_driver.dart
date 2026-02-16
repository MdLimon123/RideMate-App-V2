import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/ride_controller.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FindingDriver extends StatefulWidget {
  final String pickLocation;
  final String dropLocation;

  const FindingDriver({
    super.key,
    required this.pickLocation,
    required this.dropLocation,
  });

  @override
  State<FindingDriver> createState() => _FindingDriverState();
}

class _FindingDriverState extends State<FindingDriver>
    with TickerProviderStateMixin {
  final RideController _rideController = Get.find<RideController>();

  final pickupLocationController = TextEditingController();
  final dropLocationController = TextEditingController();

  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _rotationController;

  late Animation<double> _xScale;
  late Animation<double> _yScale;
  late Animation<double> _rotation;

  @override
  void initState() {
    setupAnimation();
    super.initState();
  }

  void setupAnimation() {
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _xScale = Tween<double>(
      begin: 0.9,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _xController, curve: Curves.easeInOut));

    _yScale = Tween<double>(
      begin: 0.9,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _yController, curve: Curves.easeInOut));

    _rotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _rotationController.dispose();

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
                readOnly: true,
                controller: pickupLocationController,
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
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _xController,
                        _yController,
                        _rotationController,
                      ]),
                      builder: (context, child) {
                        return Transform.scale(
                          scaleX: _xScale.value,
                          scaleY: _yScale.value,
                          child: Transform.rotate(
                            angle: _rotation.value * 6.28319,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    blurRadius: 30,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/icons/search_fill.svg',
                        color: Colors.white,
                        width: 72,
                        height: 72,
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
              Spacer(),
              Obx(
                () => CustomButton(
                  loading: _rideController.isLoading.value,
                  onTap: () {
                    final tripData = _rideController.tripResponse.value.data;
                    if (tripData != null) {
                      _rideController.cancelTrip(tripData.id);
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
