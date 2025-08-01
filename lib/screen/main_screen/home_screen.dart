import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hadirin_app/api/attendace_api.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/constant/app_style.dart';
import 'package:hadirin_app/model/attendace_response.dart';
import 'package:hadirin_app/screen/main_screen/history_attendace.dart';
import 'package:hadirin_app/screen/main_screen/maps_screen.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DataAttendace> attendaceHistory = [];
  late Timer _clockTimer;

  bool hasCheckedIn = false;
  bool isLoading = true;
  String _currentTime = DateFormat('HH.mm.ss').format(DateTime.now());
  final String _currentDate = DateFormat(
    'EEEE, d MMMM yyyy',
    'id_ID',
  ).format(DateTime.now());

  @override
  void initState() {
    super.initState();
    checkTodayAttendanceStatus();
    fetchAttendance();
    _clockTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = DateFormat('HH.mm.ss').format(DateTime.now());
      });
    });
  }

  void _showIzinDialog(BuildContext context) {
    final TextEditingController alasanController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      top: 24,
                      left: 24,
                      right: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColor.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.send_and_archive_sharp,
                                    color: AppColor.blue,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppStyle.titleBold(
                                    text: "Ajukan Izin",
                                    fontSize: 18,
                                    color: AppColor.blue,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Date Picker
                            AppStyle.normalTitle(
                              text: "Pilih Tanggal",
                              fontSize: 14,
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 30),
                                  ),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 30),
                                  ),
                                  locale: const Locale("id", "ID"),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: AppColor.blue,
                                          onPrimary: Colors.white,
                                          surface: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (pickedDate != null) {
                                  setState(() => selectedDate = pickedDate);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.blue),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedDate == null
                                          ? "Pilih tanggal izin"
                                          : DateFormat(
                                            'EEEE, dd MMM yyyy',
                                            'id_ID',
                                          ).format(selectedDate!),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            selectedDate == null
                                                ? Colors.grey[600]
                                                : Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      color: AppColor.blue,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Reason TextField
                            AppStyle.normalTitle(
                              text: "Alasan Izin",
                              fontSize: 14,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: alasanController,
                              decoration: InputDecoration(
                                hintText: "Masukkan alasan izin...",
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColor.blue,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.blue),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 24),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: AppColor.blue),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      minimumSize: const Size(0, 48),
                                    ),
                                    child: AppStyle.titleBold(
                                      text: "Batal",
                                      color: AppColor.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (selectedDate == null) {
                                        showTopSnackBar(
                                          Overlay.of(context),
                                          const CustomSnackBar.error(
                                            message:
                                                "Pilih tanggal terlebih dahulu",
                                          ),
                                        );
                                        return;
                                      }

                                      Navigator.pop(context);
                                      _ajukanIzin(
                                        alasan: alasanController.text.trim(),
                                        tanggal: selectedDate!,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      minimumSize: const Size(0, 48),
                                    ),
                                    child: AppStyle.titleBold(
                                      text: "Kirim",
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _ajukanIzin({
    required String alasan,
    required DateTime tanggal,
  }) async {
    try {
      // Cek apakah tanggal yang dipilih sudah ada di riwayat absensi
      final selectedList =
          attendaceHistory
              .where(
                (item) =>
                    item.attendanceDate.year == tanggal.year &&
                    item.attendanceDate.month == tanggal.month &&
                    item.attendanceDate.day == tanggal.day,
              )
              .toList();

      final selectedDateAttendance =
          selectedList.isNotEmpty ? selectedList.first : null;

      if (selectedDateAttendance != null) {
        // Sudah checkin di tanggal itu
        if (selectedDateAttendance.checkInTime != null) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Anda sudah check-in di tanggal tersebut",
            ),
          );
          return;
        }

        // Sudah ajukan izin di tanggal itu
        if (selectedDateAttendance.status.toLowerCase() == "izin") {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Anda sudah mengajukan izin di tanggal tersebut",
            ),
          );
          return;
        }
      }

      // Jika lolos pengecekan, kirim permintaan izin
      final response = await AttendaceApi.postIzin(
        alasan: alasan,
        tanggal: DateFormat('yyyy-MM-dd').format(tanggal),
      );

      if (!mounted) return;

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "Izin berhasil diajukan"),
      );

      await fetchAttendance(); // refresh data
      checkTodayAttendanceStatus();
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "Gagal ajukan izin: $e"),
      );
    }
  }

  DataAttendace? getTodayAttendance() {
    final today = DateTime.now();
    try {
      return attendaceHistory.firstWhere(
        (item) =>
            item.attendanceDate.year == today.year &&
            item.attendanceDate.month == today.month &&
            item.attendanceDate.day == today.day,
      );
    } catch (_) {
      return null;
    }
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

  void checkTodayAttendanceStatus() async {
    try {
      final response = await AttendaceApi.historyAbsen();
      final today = DateTime.now();
      final todayData = response.data.firstWhere(
        (item) =>
            item.attendanceDate.year == today.year &&
            item.attendanceDate.month == today.month &&
            item.attendanceDate.day == today.day,
      );
      if (todayData.checkInTime != null) {
        setState(() {
          hasCheckedIn = true;
        });
      }
    } catch (_) {
      print("Gagal cek status absen");
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayAttendance = getTodayAttendance();
    final checkInTime = todayAttendance?.checkInTime ?? "-";
    final checkOutTime = todayAttendance?.checkOutTime ?? "-";

    return Scaffold(
      backgroundColor: const Color(0xffE6F0FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 16,
                  right: 16,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xff007BFF),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    AppStyle.titleBold(
                      text: _currentTime,
                      color: Colors.white,
                      fontSize: 36,
                    ),
                    AppStyle.normalTitle(
                      text: _currentDate,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Checkin / Checkout Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if ((todayAttendance?.checkInTime != null &&
                                  todayAttendance?.checkOutTime != null) ||
                              todayAttendance?.status.toLowerCase() == "izin") {
                            return;
                          }

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapsScreen(),
                            ),
                          );
                          fetchAttendance(); //refresh setelah kembali dari MapsScreen
                          checkTodayAttendanceStatus();
                        },

                        child: Opacity(
                          opacity:
                              (todayAttendance?.checkInTime != null &&
                                          todayAttendance?.checkOutTime !=
                                              null ||
                                      todayAttendance?.status.toLowerCase() ==
                                          "izin")
                                  ? 0.4
                                  : 1.0,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.fingerprint,
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        (todayAttendance?.checkInTime != null &&
                                    todayAttendance?.checkOutTime != null ||
                                todayAttendance?.status.toLowerCase() == "izin")
                            ? "Completed"
                            : hasCheckedIn
                            ? "Check Out"
                            : "Check In",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
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
                                  AppStyle.normalTitle(text: "Check in"),
                                  const SizedBox(height: 8),
                                  AppStyle.normalTitle(text: checkInTime),
                                ],
                              ),
                              Spacer(),
                              Container(
                                width: 1,
                                height: 54,
                                color: Colors.grey,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  AppStyle.normalTitle(text: "Checkout"),
                                  const SizedBox(height: 8),
                                  AppStyle.normalTitle(text: checkOutTime),
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

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showIzinDialog(context),
                  icon: Icon(Icons.send_and_archive_sharp, color: Colors.white),
                  label: AppStyle.titleBold(
                    text: "Ajukan Izin",
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // Attendance History
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : attendaceHistory.isEmpty
                          ? const Center(child: Text("Belum ada data absensi"))
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "🕒 Attendance History",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HistoryScreen(),
                                        ),
                                      );
                                    },
                                    child: AppStyle.titleBold(
                                      text: "View All",
                                      fontSize: 14,
                                      color: Color(0xff007BFF),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  itemCount: attendaceHistory.length,
                                  itemBuilder: (context, index) {
                                    final item = attendaceHistory[index];
                                    final formattedDate = DateFormat(
                                      'EEEE, dd MMM yyyy',
                                      'id_ID',
                                    ).format(item.attendanceDate);
                                    final status = item.status.toLowerCase();

                                    late Icon statusIcon;
                                    late String statusLabel;
                                    late Color statusColor;

                                    if (item.checkInTime != null &&
                                        item.checkOutTime != null) {
                                      statusIcon = const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      );
                                      statusLabel = "Masuk";
                                      statusColor = Colors.green;
                                    } else if (item.checkInTime != null &&
                                        item.checkOutTime == null) {
                                      // ⚠️ Sudah Check-in, Belum Check-out
                                      statusIcon = const Icon(
                                        Icons.warning,
                                        color: Colors.orange,
                                      );
                                      statusLabel = "Tidak Lengkap";
                                      statusColor = Colors.orange;
                                    } else if (item.status.toLowerCase() ==
                                        "izin") {
                                      statusIcon = const Icon(
                                        Icons.event_busy,
                                        color: Colors.blue,
                                      );
                                      statusLabel = "Izin";
                                      statusColor = Colors.blue;
                                    } else {
                                      statusIcon = const Icon(
                                        Icons.cancel,
                                        color: Colors.grey,
                                      );
                                      statusLabel = "Tidak Hadir";
                                      statusColor = Colors.grey;
                                    }
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      elevation: 3,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.calendar_today,
                                          color: statusColor,
                                        ),
                                        title: Text(formattedDate),
                                        subtitle: Text("Status: $statusLabel"),
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
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copyright, color: Colors.blueGrey, size: 20),
                  AppStyle.normalTitle(
                    text: "2025 Hadirin App",
                    color: Colors.blueGrey,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
