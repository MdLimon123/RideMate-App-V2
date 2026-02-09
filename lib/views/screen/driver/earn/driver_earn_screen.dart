import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/driver/parcel_end_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DriverEarnScreen extends StatefulWidget {
  const DriverEarnScreen({super.key});

  @override
  State<DriverEarnScreen> createState() => _DriverEarnScreenState();
}

class _DriverEarnScreenState extends State<DriverEarnScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _parcelEndController = Get.put(ParcelEndController());

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Earnings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Obx(
                    () => DropdownButton<String>(
                      value: _parcelEndController.selectedOption.value,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged: (value) {
                        if (value != null) {
                          _parcelEndController.changeOption(value);
                        }
                      },
                      items: _parcelEndController.optionsMap.keys
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Tabs
              TabBar(
                onTap: (index) {
                  _parcelEndController.changeTab(
                    index == 0 ? 'trip' : 'parcel',
                  );
                },
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFFE6EAF0),
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: "Trips"),
                  Tab(text: "Parcels"),
                ],
              ),
              const SizedBox(height: 16),

              /// Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildEarningTab('trip'),
                    buildEarningTab('parcel'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= TAB BODY =================
  Widget buildEarningTab(String tab) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EAF0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                Text(
                  "Total Earnings",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  "847.25 (£)",
                  style: TextStyle(
                    color: Color(0xFF012F64),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Stats
          Row(
            children: [
              buildInfoCard(
                icon: 'assets/icons/cycle.svg',
                title: "Total Trips",
                value: tab == 'trip' ? "28" : "28",
              ),
              const SizedBox(width: 12),
              buildInfoCard(
                icon: 'assets/icons/clock.svg',
                title: "Online Time",
                value: tab == 'trip' ? "100h 20m" : "100h 20m",
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Daily List
          buildEarningList(tab),
        ],
      ),
    );
  }

  /// ================= LIST BUILDER =================
  Widget buildEarningList(String tab) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 10,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        return buildItem(date: "12/12/2022", count: 5, time: 100, cost: 12.5);
      },
    );
  }

  /// ================= ITEM BUILDER =================
  Widget buildItem({
    required String date,
    required int count,
    required int time,
    required num cost,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EAF0).withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                "Trips: $count, Time: $time min",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            "cost (£)",
            style: TextStyle(
              color: Color(0xFF012F64),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= INFO CARD =================
  Widget buildInfoCard({
    required String icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E6E6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 22),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF545454),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
