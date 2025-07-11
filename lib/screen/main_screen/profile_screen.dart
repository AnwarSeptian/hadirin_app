import 'package:flutter/material.dart';
import 'package:hadirin_app/api/user_api.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/constant/app_style.dart';
import 'package:hadirin_app/model/user_response.dart';
import 'package:hadirin_app/screen/auth/login.dart';
import 'package:hadirin_app/utils/shared_preference.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  DataProfile? profileUser;
  bool isLoading = true;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    try {
      final profilRes = await UserService().getProfile();

      setState(() {
        profileUser = profilRes.data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE6F0FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 44),
          child: Center(
            child: Column(
              children: [
                Center(
                  child: AppStyle.titleBold(
                    text: "Profile",
                    color: Colors.blueGrey,
                    fontSize: 38,
                  ),
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 95,
                  child: CircleAvatar(
                    backgroundColor: Color(0xffE6F0FA),
                    radius: 90,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                ),
                AppStyle.normalTitle(
                  text: profileUser?.name,
                  color: Colors.blueGrey,
                  fontSize: 32,
                ),
                AppStyle.normalTitle(
                  text: profileUser?.trainingTitle ?? "",
                  color: Colors.blueGrey,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              radius: 20,

                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),

                        trailing: IconButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    title: TextFormField(
                                      decoration: InputDecoration(
                                        label: Text("Edit Nama Profile"),
                                      ),
                                      controller: nameController,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: Text("Batal"),
                                      ),
                                      ElevatedButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: Text("Ubah"),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          icon: Icon(
                            Icons.navigate_next_sharp,
                            color: AppColor.bluelight,
                            size: 30,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              radius: 20,

                              child: Icon(
                                Icons.receipt_outlined,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Riwayat Pesanan",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        // trailing: IconButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => HalamanPesanan(),
                        //       ),
                        //     );
                        //   },
                        //   icon: Icon(
                        //     Icons.navigate_next_sharp,
                        //     color: AppColor.bold3,
                        //     size: 30,
                        //   ),
                        // ),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              radius: 20,

                              child: Icon(
                                Icons.person_search_sharp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Daftar Pengguna",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        // trailing: IconButton(
                        //   onPressed: () {
                        //     tampilkanDaftarPengguna();
                        //   },
                        //   icon: Icon(
                        //     Icons.navigate_next_sharp,
                        //     color: AppColor.bold3,
                        //     size: 30,
                        //   ),
                        // ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          fixedSize: Size(280, 50),
                        ),
                        onPressed: () {
                          PreferenceHandler.deleteToken();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false,
                          );
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.info(message: "Logout berhasil"),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Sign Out",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
