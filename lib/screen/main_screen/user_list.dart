import 'package:flutter/material.dart';
import 'package:hadirin_app/api/user_api.dart'; // Sesuaikan dengan path kamu
import 'package:hadirin_app/api/training_api.dart';
import 'package:hadirin_app/model/user_response.dart'; // Sesuaikan juga

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<DataUser> _allUsers = [];
  List<DataUser> _filteredUsers = [];
  Map<String, String> _trainingMap = {};
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsersAndTrainings();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsersAndTrainings() async {
    try {
      final userRes = await UserService.listUser();
      final trainingRes = await TrainingApi.getTraining();

      final trainingMap = {
        for (var item in trainingRes.data) item.id.toString(): item.title,
      };

      setState(() {
        _allUsers = userRes.data;
        _filteredUsers = _allUsers;
        _trainingMap = trainingMap;
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers =
          _allUsers.where((user) {
            final nameMatch = user.name.toLowerCase().contains(keyword);
            final emailMatch = user.email.toLowerCase().contains(keyword);
            return nameMatch || emailMatch;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Pengguna"),
        backgroundColor: Colors.blue,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari nama atau email...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _fetchUsersAndTrainings,
                      child:
                          _filteredUsers.isEmpty
                              ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(height: 100),
                                  Center(
                                    child: Text("Tidak ada data ditemukan"),
                                  ),
                                ],
                              )
                              : ListView.builder(
                                itemCount: _filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = _filteredUsers[index];
                                  final gender =
                                      user.jenisKelamin?.name ?? "N/A";
                                  final trainingName =
                                      _trainingMap[user.trainingId] ??
                                      "Tidak diketahui";
                                  final imageUrl =
                                      user.profilePhoto != null
                                          ? "https://appabsensi.mobileprojp.com/public/${user.profilePhoto}"
                                          : null;

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: ListTile(
                                      leading:
                                          imageUrl != null
                                              ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  imageUrl,
                                                ),
                                              )
                                              : const CircleAvatar(
                                                child: Icon(Icons.person),
                                              ),
                                      title: Text(user.name),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Email: ${user.email}"),
                                          Text("Gender: $gender"),
                                          Text("Pelatihan: $trainingName"),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ),
                ],
              ),
    );
  }
}
