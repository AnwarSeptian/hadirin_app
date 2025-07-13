import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadirin_app/api/attendace_api.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

final LatLng allowedLocation = LatLng(-6.210881, 106.812942); // lokasi kantor
const double allowedRadiusInMeters = 100; // radius 100 meter

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666);
  String _currentAddress = "Alamat tidak di temukan";
  Marker? _marker;
  bool isLoading = false;
  bool hasCheckedIn = false;

  void handleCheckIn() async {
    try {
      // Ambil posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Jarak user dan lokasi kantor
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        allowedLocation.latitude,
        allowedLocation.longitude,
      );

      //validator radius
      if (distance > allowedRadiusInMeters) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Anda berada di luar area kantor",
          ),
        );
        return;
      }

      //konversi konversi dari latitude & longitude ke alamat teks
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String location =
          "${placemarks[0].locality}, ${placemarks[0].administrativeArea}";
      String address =
          "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].country}";

      // Kirim data ke backend
      final response = await AttendaceApi.postCheckIn(
        lat: position.latitude,
        lng: position.longitude,
        location: location,
        address: address,
      );

      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(message: "Checkin Berhasil"),
      );
      Navigator.pop(context);
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: e.toString()),
      );
    }
  }

  Future<void> handleCheckout() async {
    setState(() => isLoading = true);

    try {
      // Ambil posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Jarak user dan lokasi kantor
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        allowedLocation.latitude,
        allowedLocation.longitude,
      );

      //validator radius
      if (distance > allowedRadiusInMeters) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(message: "Anda berada di luar kantor"),
        );
        return; // Stop eksekusi jika tidak di lokasi yang diperbolehkan
      }

      //konversi dari latitude & longitude ke alamat teks
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String location = "${place.locality}, ${place.administrativeArea}";
      String address =
          "${place.street}, ${place.subLocality}, ${place.country}";

      // Kirim lokasi
      final response = await AttendaceApi.postCheckout(
        lat: position.latitude,
        lng: position.longitude,
        location: location,
        address: address,
      );

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: response.message),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error saat checkout: $e");
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: e.toString()),
      );
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentPosition = LatLng(position.latitude, position.longitude);
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];
    setState(() {
      _marker = Marker(
        markerId: MarkerId("lokasi_saya"),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: "Lokasi Anda",
          snippet: "${place.street}, ${place.locality}",
        ),
      );
      _currentAddress = "${place.name},${place.street},${place.country}";

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16),
        ),
      );
    });
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

      if (todayData != null && todayData.checkInTime != null) {
        setState(() {
          hasCheckedIn = true;
        });
      }
    } catch (e) {
      print("Gagal cek status absen: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    checkTodayAttendanceStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendace"),
        actions: [
          IconButton(
            onPressed: () {
              _getCurrentLocation();
            },
            icon: Icon(Icons.my_location_sharp),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 600,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 8,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  markers: _marker != null ? {_marker!} : {},
                  // myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (hasCheckedIn) {
                        handleCheckout();
                      } else {
                        handleCheckIn();
                      }
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
                  const SizedBox(height: 8),
                  Text(
                    hasCheckedIn ? "Check Out" : "Check In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
