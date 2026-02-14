import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_svg/svg.dart';

class DriverRideHistoryDetails extends StatefulWidget {
    final bool isParcel;

  const DriverRideHistoryDetails({super.key, required this.isParcel});

  @override
  State<DriverRideHistoryDetails> createState() =>
      _DriverRideHistoryDetailsState();
}

class _DriverRideHistoryDetailsState extends State<DriverRideHistoryDetails> {
  bool isParcel = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Ride Details"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 10),
          isParcel
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EAF0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage("assets/images/demo.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Center(
                      //   child: CustomNetworkImage(
                      //     imageUrl:
                      //         "${ApiConstant.imageBaseUrl}${widget.riderHistoryItem?.user?.avatar}",
                      //     height: 48,
                      //     width: 48,
                      //     boxShape: BoxShape.circle,
                      //     border: Border.all(color: Colors.white, width: 2),
                      //   ),
                      // ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          "Walid",
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icons/cycle.svg"),
                              const SizedBox(width: 4),
                              const Text(
                                "Trip",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "5",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Icon(Icons.star, color: Color(0xFF012F64)),
                              const SizedBox(width: 4),
                              const Text(
                                "4.5",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      isParcel
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Picture for end trip",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColor,
                                    ),
                                  ),

                                  Container(
                                    height: 28,
                                    width: 28,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: const Color(0xFF11DF7F),
                                        width: 0.5,
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          "assets/images/demo.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  //   CustomNetworkImage(
                                  //     imageUrl:
                                  //         "${ApiConstant.imageBaseUrl}${widget.riderHistoryItem?.deliveryProofFiles}",
                                  //     border: Border.all(
                                  //       color: Color(0xFF11DF7F),
                                  //       width: 0.5,
                                  //     ),
                                  //     height: 28,
                                  //     borderRadius: BorderRadius.circular(4),
                                  //     width: 28,
                                  //   ),
                                  // ],
                                ],
                              ),
                            )
                          : const SizedBox(),

                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/pick.svg'),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Pizza Burge Main St, Maintown ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/location.svg',
                                  color: AppColors.textColor,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "456 Oak Ave, Sometown (7.00 km)",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            isParcel
                                ? Row(
                                    children: [
                                      SvgPicture.asset("assets/icons/box.svg"),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "10",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF012F64),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "(£)",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/box.svg',
                                  color: AppColors.textColor,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "10",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF012F64),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "(£)",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w200,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EAF0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage("assets/images/demo.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // CustomNetworkImage(
                            //   imageUrl:
                            //       "${ApiConstant.imageBaseUrl}${widget.riderHistoryItem?.user?.avatar}",
                            //   border: Border.all(
                            //     color: Color(0xFF11DF7F),
                            //     width: 0.5,
                            //   ),
                            //   height: 48,
                            //   borderRadius: BorderRadius.circular(4),
                            //   width: 48,
                            // ),
                            const SizedBox(width: 12),
                            const Center(
                              child: Text(
                                "Walid",
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/pick.svg'),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Pizza Burge Main St, Maintown ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/location.svg',
                                    color: AppColors.textColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "456 Oak Ave, Sometown (6.00 km) ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/box.svg',
                                    color: AppColors.textColor,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "100",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF012F64),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "(£)",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w200,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Your earn of this trip",
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 187,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EAF0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "10 (£)",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF012F64),
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Radeef ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SvgPicture.asset(
                      "assets/icons/percentige.svg",
                      color: const Color(0xFF333333),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "2",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "(£)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
