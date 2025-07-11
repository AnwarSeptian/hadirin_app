import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hadirin_app/api/attendace_api.dart';
import 'package:hadirin_app/constant/app_style.dart';
import 'package:hadirin_app/model/attendace_response.dart';
import 'package:hadirin_app/screen/main_screen/maps_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DataAttendace> attendaceHistory = [];
  late Timer _clockTimer;
  bool isLoading = true;
  String _alamatSaatIni = "Alamat belum dipilih";
  String _currentTime = DateFormat('HH.mm.ss').format(DateTime.now());
  final String _currentDate = DateFormat(
    'EEEE, d MMMM yyyy',
    'id_ID',
  ).format(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchAttendance();
    _clockTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentTime = DateFormat('HH.mm.ss').format(DateTime.now());
      });
    });
  }

  Future<void> fetchAttendance() async {
    try {
      final response = await AttendaceApi.historyAbsen();
      setState(() {
        attendaceHistory = response.data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching attendance: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6F0FA),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Color(0xff007BFF),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(4),

                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.black),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppStyle.normalTitle(
                          text: _alamatSaatIni,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final alamat = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapsScreen(),
                            ),
                          );
                          if (alamat != null && alamat is String) {
                            setState(() {
                              _alamatSaatIni = alamat;
                            });
                          }
                        },

                        child: AppStyle.titleBold(
                          text: "Open Maps",
                          fontSize: 12,
                          color: Color(0xff007BFF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppStyle.titleBold(
                  text: _currentTime,
                  color: Colors.white,
                  fontSize: 36,
                ),
                AppStyle.normalTitle(text: _currentDate, color: Colors.white),
                const SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Check-in
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapsScreen()),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.fingerprint,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Check in",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              AppStyle.normalTitle(text: "Checkin"),
                              AppStyle.normalTitle(text: "08.00 AM"),
                            ],
                          ),
                          Spacer(),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              AppStyle.normalTitle(text: "Clockout"),
                              AppStyle.normalTitle(text: "15.00 PM"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Attendance History
          Expanded(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : attendaceHistory.isEmpty
                    ? Center(child: Text("Belu, ada data absensi"))
                    : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "🕒 Attendance History",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: AppStyle.titleBold(
                                    text: "View All",
                                    fontSize: 14,
                                    color: Color(0xff007BFF),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: attendaceHistory.length,
                                itemBuilder: (context, index) {
                                  final item = attendaceHistory[index];
                                  final DateFormatted = DateFormat(
                                    'EEE, dd MMM yyyy',
                                  ).format(item.attendanceDate);
                                  final checkIn = item.checkInTime ?? "-";
                                  final checkOut = item.checkOutTime ?? "-";
                                  final late =
                                      int.tryParse(checkIn.split(":")[0]) ??
                                      0 > 8;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppStyle.normalTitle(
                                          text: DateFormatted,
                                        ),
                                        AppStyle.normalTitle(text: checkIn),

                                        const Text(" - "),
                                        AppStyle.normalTitle(
                                          text: checkOut.toString(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
