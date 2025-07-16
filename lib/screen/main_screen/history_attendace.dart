import 'package:flutter/material.dart';
import 'package:hadirin_app/api/attendace_api.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/constant/app_style.dart';
import 'package:hadirin_app/model/attendace_response.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DataAttendace> _history = [];
  bool _isLoading = true;
  String _selectedStatus = 'Semua';

  final List<String> _statusOptions = [
    'Semua',
    'Masuk',
    'Tidak Lengkap',
    'Izin',
  ];

  @override
  void initState() {
    super.initState();
    _loadAttendanceHistory();
  }

  Future<void> _loadAttendanceHistory() async {
    try {
      final response = await AttendaceApi.historyAbsen();
      setState(() {
        _history = response.data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  List<DataAttendace> _filteredHistory() {
    return _history.where((item) {
      if (_selectedStatus == 'Masuk') {
        return item.checkInTime != null && item.checkOutTime != null;
      } else if (_selectedStatus == 'Tidak Lengkap') {
        return item.checkInTime != null && item.checkOutTime == null;
      } else if (_selectedStatus == 'Izin') {
        return item.status.toLowerCase() == 'izin';
      }
      return true; // Semua
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff007BFF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: AppStyle.titleBold(text: "Riwayat Absensi", color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _history.isEmpty
              ? const Center(child: Text("Belum ada riwayat absensi"))
              : SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Wrap(
                        spacing: 8,
                        children:
                            _statusOptions.map((status) {
                              final isSelected = _selectedStatus == status;
                              return ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedStatus = status;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isSelected
                                          ? Colors.blue
                                          : Colors.grey[300],

                                  foregroundColor:
                                      isSelected ? Colors.white : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(status),
                              );
                            }).toList(),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: _filteredHistory().length,
                        itemBuilder: (context, index) {
                          final item = _filteredHistory()[index];
                          final formattedDate = DateFormat(
                            'EEEE, dd MMM yyyy',
                            'id_ID',
                          ).format(item.attendanceDate);
                          final checkIn = item.checkInTime ?? "-";
                          final checkOut = item.checkOutTime ?? "-";

                          late Icon statusIcon;
                          late String statusLabel;
                          late Color statusColor;

                          if (item.checkInTime != null &&
                              item.checkOutTime != null) {
                            final jamMasukKerja = DateTime(
                              item.attendanceDate.year,
                              item.attendanceDate.month,
                              item.attendanceDate.day,
                              8,
                              0,
                              0,
                            );
                            final parsedCheckIn = DateFormat(
                              "HH:mm",
                            ).parse(item.checkInTime!);
                            final checkInDateTime = DateTime(
                              item.attendanceDate.year,
                              item.attendanceDate.month,
                              item.attendanceDate.day,
                              parsedCheckIn.hour,
                              parsedCheckIn.minute,
                            );
                            final isLate = checkInDateTime.isAfter(
                              jamMasukKerja,
                            );

                            statusIcon =
                                isLate
                                    ? const Icon(
                                      Icons.access_time_filled,
                                      color: Colors.red,
                                    )
                                    : const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    );
                            statusLabel = isLate ? "Telat" : "Masuk";
                            statusColor = isLate ? Colors.red : Colors.green;
                          } else if (item.checkInTime != null &&
                              item.checkOutTime == null) {
                            statusIcon = const Icon(
                              Icons.warning,
                              color: Colors.orange,
                            );
                            statusLabel = "Tidak Lengkap";
                            statusColor = Colors.orange;
                          } else if (item.status.toLowerCase() == "izin") {
                            statusIcon = const Icon(
                              Icons.mark_email_read_sharp,
                              color: Colors.blue,
                            );
                            statusLabel = "Izin";
                            statusColor = Colors.blue;
                          } else {
                            return const SizedBox.shrink();
                          }

                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: AppColor.blue, width: 1),
                            ),
                            shadowColor: AppColor.blue,

                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: statusIcon,
                              title: AppStyle.titleBold(text: formattedDate),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppStyle.normalTitle(
                                    text: "Check in: $checkIn",
                                  ),
                                  AppStyle.normalTitle(
                                    text: "Check out: $checkOut",
                                  ),
                                  AppStyle.normalTitle(
                                    text: "Status: $statusLabel",
                                  ),
                                  if (item.status.toLowerCase() == "izin" &&
                                      item.alasanIzin != null)
                                    AppStyle.titleBold(
                                      text: "Alasan : ${item.alasanIzin}",
                                    ),
                                  SizedBox(height: 4),
                                  if (item.checkInAddress != null)
                                    AppStyle.normalTitle(
                                      text: item.checkInAddress,
                                    ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.circle,
                                color: statusColor,
                                size: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.copyright),
                        AppStyle.normalTitle(text: "Copyright 2025"),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
