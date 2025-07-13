import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:hadirin_app/utils/endpoint.dart';
import 'package:image_picker/image_picker.dart';
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
  bool isUploadingPhoto = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
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

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Future<void> _pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      File file = File(pickedFile.path);
      String? token = await PreferenceHandler.getToken();

      setState(() {
        isUploadingPhoto = true;
      });

      await UserService.uploadProfilePhoto(token: token!, photoFile: file);
      await loadData();

      setState(() {
        isUploadingPhoto = false;
      });
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "Foto berhasil diperbarui"),
      );
      loadData();
    } catch (e) {
      setState(() {
        isUploadingPhoto = false;
      });
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "Gagal upload foto: $e"),
      );
      print("Upload error: $e");
    }
  }

  void _showEditNameDialog() {
    nameController.text = profileUser?.name ?? "";
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Nama"),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama baru",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final overlay = Overlay.of(context);
                  Navigator.pop(context);
                  try {
                    await UserService().updateProfile(
                      name: nameController.text.trim(),
                    );
                    if (overlay != null) {
                      showTopSnackBar(
                        overlay,
                        CustomSnackBar.success(
                          message: "Nama berhasil diperbarui",
                        ),
                      );
                    }

                    await loadData();
                  } catch (e) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.error(message: "Gagal ubah nama: $e"),
                    );
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileImage;
    if (profileUser?.profilePhoto != null &&
        profileUser!.profilePhoto!.isNotEmpty) {
      profileImage = NetworkImage(
        profileUser!.profilePhoto!.startsWith("http")
            ? profileUser!.profilePhoto!
            : Endpoint.baseImageUrl + profileUser!.profilePhoto!,
      );
    } else {
      profileImage = const AssetImage("assets/images/profile.png");
    }

    return Scaffold(
      backgroundColor: const Color(0xffE6F0FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 44),
          child: Center(
            child:
                isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                      children: [
                        Center(
                          child: AppStyle.titleBold(
                            text: "Profile",
                            color: Colors.blueGrey,
                            fontSize: 38,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xffE6F0FA),
                              radius: 90,
                              backgroundImage: profileImage,
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap:
                                    isUploadingPhoto
                                        ? null
                                        : _pickAndUploadPhoto,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue,
                                  child:
                                      isUploadingPhoto
                                          ? const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : const Icon(
                                            Icons.camera_alt_sharp,
                                            color: Colors.white,
                                          ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppStyle.normalTitle(
                              text: profileUser?.name,
                              color: Colors.blueGrey,
                              fontSize: 32,
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _showEditNameDialog(),
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        AppStyle.normalTitle(
                          text: profileUser?.trainingTitle ?? "",
                          color: Colors.blueGrey,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.group,
                                        color: Colors.blueGrey,
                                      ),
                                      title: AppStyle.titleBold(text: "Batch"),
                                      subtitle: AppStyle.normalTitle(
                                        text:
                                            "Batch ke-${profileUser?.batchKe ?? '-'}",
                                      ),
                                    ),
                                    const Divider(height: 0),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.date_range,
                                        color: Colors.blueGrey,
                                      ),
                                      title: AppStyle.titleBold(
                                        text: "Tanggal Mulai",
                                      ),
                                      subtitle: AppStyle.normalTitle(
                                        text: _formatDate(
                                          profileUser?.batch.startDate,
                                        ),
                                      ),
                                    ),
                                    const Divider(height: 0),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.event,
                                        color: Colors.blueGrey,
                                      ),
                                      title: AppStyle.titleBold(
                                        text: "Tanggal Berakhir",
                                      ),
                                      subtitle: AppStyle.normalTitle(
                                        text: _formatDate(
                                          profileUser?.batch.endDate,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  fixedSize: const Size(280, 50),
                                ),
                                onPressed: () {
                                  PreferenceHandler.deleteToken();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.success(
                                      message: "Logout berhasil",
                                    ),
                                  );
                                },
                                child: const Row(
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
