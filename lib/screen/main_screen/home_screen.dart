import 'package:flutter/material.dart';
import 'package:hadirin_app/constant/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(color: AppColor.coklat),
              child: Row(children: [CircleAvatar()]),
            ),
          ],
        ),
      ),
    );
  }
}
