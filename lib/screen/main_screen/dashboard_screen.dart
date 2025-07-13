import 'package:flutter/material.dart';
import 'package:hadirin_app/api/attendace_api.dart';
import 'package:hadirin_app/api/training_api.dart';
import 'package:hadirin_app/api/user_api.dart';
import 'package:hadirin_app/constant/app_style.dart';
import 'package:hadirin_app/model/attendace_response.dart';
import 'package:hadirin_app/model/batch_response.dart';
import 'package:hadirin_app/model/training_respons.dart';
import 'package:hadirin_app/model/user_response.dart';
import 'package:hadirin_app/screen/main_screen/history_attendace.dart';
import 'package:hadirin_app/screen/main_screen/profile_screen.dart';
import 'package:hadirin_app/screen/main_screen/user_list.dart';
import 'package:hadirin_app/utils/endpoint.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DataProfile? profileUser;
  DataStatistik? statistikData;

  void loadData() async {
    try {
      final profilRes = await UserService().getProfile();
      final statistikRes =
          await AttendaceApi.statistikAbsen(); // Ambil statistik

      setState(() {
        profileUser = profilRes.data;
        statistikData = statistikRes.data;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6F0FA),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xff007BFF),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    profileUser?.profilePhoto != null
                        ? CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            "${Endpoint.baseImageUrl}${profileUser!.profilePhoto}",
                          ),
                        )
                        : const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.blue),
                        ),

                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppStyle.titleBold(
                              text: profileUser?.name ?? "Loading..",
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ],
                        ),

                        AppStyle.normalTitle(
                          text: "Best wishes for your day!",
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Overview section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppStyle.titleBold(text: "Data Pelatihan", fontSize: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Grid cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserListScreen(),
                          ),
                        );
                      },
                      child: _buildStatCard(Icons.groups_sharp, "List User"),
                    ),
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppStyle.titleBold(
                                      text: "Daftar Pelatihan",
                                      fontSize: 18,
                                    ),
                                    const SizedBox(height: 12),
                                    FutureBuilder<ListPelatihan>(
                                      future: TrainingApi.getTraining(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Padding(
                                            padding: EdgeInsets.all(24),
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              "Gagal memuat data: ${snapshot.error}",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.data.isEmpty) {
                                          return const Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Text(
                                              "Tidak ada pelatihan yang tersedia.",
                                            ),
                                          );
                                        } else {
                                          final trainings = snapshot.data!.data;
                                          return SizedBox(
                                            height: 300,
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: trainings.length,
                                              separatorBuilder:
                                                  (_, __) =>
                                                      const Divider(height: 1),
                                              itemBuilder: (context, index) {
                                                final item = trainings[index];
                                                return ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                      ),
                                                  leading: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blue[100],
                                                    child: Icon(
                                                      Icons.school,
                                                      color: Colors.blue[800],
                                                    ),
                                                  ),
                                                  title: Text(
                                                    item.title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Tutup",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },

                      child: _buildStatCard(Icons.assignment, "List Training"),
                    ),

                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppStyle.titleBold(
                                      text: "Daftar Batch",
                                      fontSize: 18,
                                    ),
                                    const SizedBox(height: 12),
                                    FutureBuilder<ListBatch>(
                                      future: TrainingApi.getBatch(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Padding(
                                            padding: EdgeInsets.all(24),
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              "Gagal memuat data: ${snapshot.error}",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.data.isEmpty) {
                                          return const Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Text(
                                              "Tidak ada batch yang tersedia.",
                                            ),
                                          );
                                        } else {
                                          final batches = snapshot.data!.data;
                                          return SizedBox(
                                            height: 300,
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: batches.length,
                                              separatorBuilder:
                                                  (_, __) =>
                                                      const Divider(height: 1),
                                              itemBuilder: (context, index) {
                                                final item = batches[index];
                                                return ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blue[100],
                                                    child: Icon(
                                                      Icons.group_sharp,
                                                      color: Colors.blue[800],
                                                    ),
                                                  ),
                                                  title: Text(
                                                    " Batch ${item.batchKe}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Tutup",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },

                      child: _buildStatCard(Icons.group, "List Batch"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    AppStyle.titleBold(
                      text: "Statistik Absen Anda",
                      fontSize: 20,
                    ),
                    Divider(height: 20, thickness: 2, color: Colors.blue),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Statistics Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatTile(
                      Icons.person,
                      "Total Absen",
                      statistikData?.totalAbsen.toString() ?? "-",
                    ),
                    _buildStatTile(
                      Icons.done_all_sharp,
                      "Total Masuk",
                      statistikData?.totalMasuk.toString() ?? "-",
                    ),
                    _buildStatTile(
                      Icons.airline_seat_individual_suite,
                      "Total Izin",
                      statistikData?.totalIzin.toString() ?? "-",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label) {
    return Container(
      width: 114,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 8),

          AppStyle.titleBold(text: label, fontSize: 12),
        ],
      ),
    );
  }

  Widget _buildStatTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[50],
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
