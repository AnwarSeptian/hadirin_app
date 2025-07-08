import 'package:flutter/material.dart';
import 'package:hadirin_app/constant/app_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> attendanceHistory = [
    {"date": "Mon, 18 April 2023", "in": "08:00", "out": "05:00"},
    {"date": "Fri, 15 April 2023", "in": "08:52", "out": "05:00"},
    {"date": "Thu, 14 April 2023", "in": "07:45", "out": "05:00"},
    {"date": "Wed, 13 April 2023", "in": "07:55", "out": "05:00"},
    {"date": "Tue, 12 April 2023", "in": "08:48", "out": "05:00"},
    {"date": "Mon, 11 April 2023", "in": "07:52", "out": "05:00"},
  ];

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
                        child: Text(
                          "148 Rd No 12C Gulshan Dhaka - 1234",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
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
                const Text(
                  "12:30 PM",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Tuesday, March-25, 2025",
                  style: TextStyle(color: Colors.white),
                ),
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
                      // check in
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                        itemCount: attendanceHistory.length,
                        itemBuilder: (context, index) {
                          final item = attendanceHistory[index];
                          final late =
                              int.tryParse(item['in']!.split(":")[0])! > 8;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['date']!),
                                Row(
                                  children: [
                                    Text(
                                      item['in']!,
                                      style: TextStyle(
                                        color: late ? Colors.red : Colors.black,
                                        fontWeight:
                                            late
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                    const Text(" - "),
                                    Text(
                                      item['out']!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
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
