import 'package:flutter/material.dart';
import 'package:hadirin_app/api/training_api.dart';
import 'package:hadirin_app/api/user_api.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/constant/app_style.dart';
import 'package:hadirin_app/model/batch_response.dart';
import 'package:hadirin_app/model/training_respons.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nohandphoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<DataTraining> pelatihanList = [];
  List<BatchData> batchList = [];

  bool passwordVisible = true;
  String selectedGender = 'L';

  int? selectedBatchId;
  int? selectedPelatihanId;
  bool isLoadingPelatihan = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchPelatihan();
    fetchBatch();
  }

  Future<void> fetchPelatihan() async {
    try {
      final result = await TrainingApi.getTraining();
      setState(() {
        pelatihanList = result.data;
        isLoadingPelatihan = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPelatihan = false;
      });
    }
  }

  Future<void> fetchBatch() async {
    try {
      final result = await TrainingApi.getBatch();
      setState(() {
        batchList = result.data;
      });
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "Gagal memuat data batch"),
      );
    }
  }

  void register() async {
    print("Memulai proses registrasi...");
    try {
      final response = await UserService.registerUser(
        email: emailController.text,
        name: nameController.text,
        password: passwordController.text,
        gender: selectedGender,
        batchId: selectedBatchId!,
        trainingId: selectedPelatihanId!,
      );

      if (response.data != null) {
        print("Token: ${response.data!.token}");
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: response.message ?? "Registrasi berhasil",
          ),
        );
        Navigator.pop(context);
      } else {
        // Registrasi gagal tapi tidak exception (status 200, tapi data null)
        String pesanError = "";

        if (response.errors != null) {
          pesanError = response.errors!.entries
              .map((e) => e.value.join(', '))
              .join('\n');
        } else if (response.message != null) {
          pesanError = response.message!;
        } else {
          pesanError = "Terjadi kesalahan tidak diketahui.";
        }

        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: pesanError),
        );
      }
    } catch (e) {
      print("Exception saat register: $e");
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "Gagal terhubung ke server."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.blue,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 400),
                    Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(
                        color: AppColor.bluelight,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppStyle.titleBold(
                          color: Color(0xFFffffff),
                          fontSize: 32,
                          text: "Register",
                        ),
                        SizedBox(height: 14),
                        AppStyle.normalTitle(
                          color: Color(0xFFffffff),
                          text: "Register your account",
                        ),
                        SizedBox(height: 24),
                        Container(
                          width: 351,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppStyle.normalTitle(
                                  color: AppColor.coklat,
                                  text: "Nama",
                                ),
                                SizedBox(height: 14),
                                AppStyle.TextField(
                                  controller: nameController,
                                  color: Color(0xffE6E6E6),
                                  colorItem: AppColor.coklat,
                                ),
                                SizedBox(height: 14),
                                AppStyle.normalTitle(
                                  color: AppColor.coklat,
                                  text: "Email",
                                ),
                                SizedBox(height: 14),
                                AppStyle.TextField(
                                  controller: emailController,
                                  color: Color(0xffE6E6E6),
                                  colorItem: AppColor.coklat,
                                ),
                                SizedBox(height: 14),
                                AppStyle.normalTitle(
                                  color: AppColor.coklat,
                                  text: "Password",
                                ),
                                SizedBox(height: 14),
                                AppStyle.TextField(
                                  controller: passwordController,
                                  color: Color(0xffE6E6E6),
                                  isPassword: true,
                                  isVisibility: passwordVisible,
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),

                                // 🔽 Gender Section Start
                                SizedBox(height: 20),
                                AppStyle.normalTitle(
                                  color: AppColor.coklat,
                                  text: "Jenis Kelamin",
                                ),
                                RadioListTile<String>(
                                  title: Text('Laki-laki'),
                                  value: 'L',
                                  groupValue: selectedGender,
                                  activeColor: AppColor.coklat,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text('Perempuan'),
                                  value: 'P',
                                  groupValue: selectedGender,
                                  activeColor: AppColor.coklat,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                AppStyle.normalTitle(
                                  color: AppColor.coklat,
                                  text: "Jenis Pelatihan",
                                ),
                                isLoadingPelatihan
                                    ? Center(child: CircularProgressIndicator())
                                    : DropdownButtonFormField<int>(
                                      isExpanded: true,
                                      value: selectedPelatihanId,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xffE6E6E6),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      items:
                                          pelatihanList.map((pelatihan) {
                                            return DropdownMenuItem<int>(
                                              value: pelatihan.id,
                                              child: Text(
                                                pelatihan.title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPelatihanId = value!;
                                        });
                                      },
                                      validator:
                                          (value) =>
                                              value == null
                                                  ? 'Jenis pelatihan harus dipilih'
                                                  : null,
                                    ),
                                SizedBox(height: 20),
                                AppStyle.normalTitle(
                                  color: AppColor.coklat,
                                  text: "Pilih Batch",
                                ),
                                DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  value: selectedBatchId,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffE6E6E6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items:
                                      batchList.map((batch) {
                                        return DropdownMenuItem<int>(
                                          value: batch.id,
                                          child: Text(
                                            "Batch ${batch.batchKe} (${batch.startDate.year})",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBatchId = value;
                                    });
                                  },
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Batch harus dipilih'
                                              : null,
                                ),
                                SizedBox(height: 34),
                                SizedBox(
                                  height: 56,
                                  width: double.infinity,
                                  child: AppStyle.buttonAuth(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        register();
                                      }
                                    },
                                    text: "Register",
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppStyle.normalTitle(text: "Have account?"),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: AppStyle.titleBold(
                                        text: "Sign in",
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.copyright),
                                    AppStyle.normalTitle(
                                      text: "Copyright 2025",
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
