import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/model/driver/rider_history_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_appbar.dart';
import 'package:flutter_extension/views/base/custom_newtwok_image.dart';
import 'package:flutter_svg/svg.dart';

class DriverRideHistoryDetails extends StatefulWidget {
  final bool isParcel;
  final RiderHistoryItem? riderHistoryItem;

  const DriverRideHistoryDetails({
    super.key,
    required this.isParcel,
    required this.riderHistoryItem,
  });

  @override
  State<DriverRideHistoryDetails> createState() =>
      _DriverRideHistoryDetailsState();
}

class _DriverRideHistoryDetailsState extends State<DriverRideHistoryDetails> {

  @override
  Widget build(BuildContext context) {
    final totalCost = widget.riderHistoryItem?.totalCost ?? 0;
    final radeefFee = (totalCost * 0.02).toInt();
    final driverEarn = totalCost - radeefFee;

    return Scaffold(
      backgroundColor: const Color(0xFFE6EAF0),
      appBar: const CustomAppbar(title: "Ride Details"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          widget.isParcel ? const SizedBox(height: 10) : const SizedBox(height: 186),
          widget.isParcel
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF345983),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CustomNetworkImage(
                          imageUrl:
                              "${ApiConstant.imageBaseUrl}${widget.riderHistoryItem?.user?.avatar}",
                          height: 48,
                          width: 48,
                          boxShape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          "${widget.riderHistoryItem?.user?.name}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 34),
                      widget.isParcel
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

                                  CustomNetworkImage(
                                    imageUrl:
                                        "${ApiConstant.imageBaseUrl}${widget.riderHistoryItem?.deliveryProofFiles}",
                                    border: Border.all(
                                      color: const Color(0xFF11DF7F),
                                      width: 0.5,
                                    ),
                                    height: 28,
                                    borderRadius: BorderRadius.circular(4),
                                    width: 28,
                                  ),
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
                                    widget.riderHistoryItem?.pickupAddress ??
                                        "",
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
                                    widget.riderHistoryItem?.dropoffAddress ??
                                        "",
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
                            widget.isParcel
                                ? Row(
                                    children: [
                                      SvgPicture.asset("assets/icons/box.svg"),
                                      const SizedBox(width: 12),
                                      Text(
                                        "\$${widget.riderHistoryItem?.totalCost}",
                                        style: const TextStyle(
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
                                Text(
                                  "${widget.riderHistoryItem?.amount}",
                                  style: const TextStyle(
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
                      color: const Color(0xFF345983),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomNetworkImage(
                              imageUrl:
                                  "${ApiConstant.imageBaseUrl}${widget.riderHistoryItem?.user?.avatar}",
                              border: Border.all(
                                color: const Color(0xFF11DF7F),
                                width: 0.5,
                              ),
                              height: 48,
                              borderRadius: BorderRadius.circular(4),
                              width: 48,
                            ),
                            const SizedBox(width: 12),
                            Center(
                              child: Text(
                                "${widget.riderHistoryItem?.user?.name}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 34),

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
                                      widget.riderHistoryItem?.pickupAddress ??
                                          "",
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
                                      widget.riderHistoryItem?.dropoffAddress ??
                                          "",
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
                                  Text(
                                    widget.riderHistoryItem?.totalCost
                                            .toString() ??
                                        "",
                                    style: const TextStyle(
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
              color: const Color(0xFF345983),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
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
                      color: Colors.white,
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
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "$driverEarn (£)",
                        style: const TextStyle(
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
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SvgPicture.asset("assets/icons/percentige.svg"),
                    const SizedBox(width: 4),
                    Text(
                      "$radeefFee",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "(£)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                        color: Color(0xFFFFFFFF),
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
