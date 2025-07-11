import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadirin_app/api/attendace_api.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/constant/app_style.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666);
  String _currentAddress = "Alamat tidak di temukan";
  Marker? _marker;
  bool isLoading = false;

  void handleCheckIn() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String location =
          "${placemarks[0].locality}, ${placemarks[0].administrativeArea}";
      String address =
          "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].country}";

      final response = await AttendaceApi.postCheckIn(
        lat: position.latitude,
        lng: position.longitude,
        location: location,
        address: address,
      );
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "Checkin Berhasil"),
      );
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
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final lat = position.latitude;
      final lng = position.longitude;
      final location = "$lat,$lng";
      final address =
          "Alamat otomatis"; // Nanti bisa pakai geocoding untuk alamat sebenarnya

      final response = await AttendaceApi.postCheckout(
        lat: lat,
        lng: lng,
        location: location,
        address: address,
      );
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: response.message),
      );
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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
            icon: Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 8,
          ),
          onMapCreated: (controller) {
            mapController = controller;
          },
          markers: _marker != null ? {_marker!} : {},
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppStyle.titleBold(text: "Check in"),
              AppStyle.titleBold(text: "Check Out"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: 'select',
                onPressed: () {
                  handleCheckIn();
                },
                tooltip: "Pilih Alamat Ini",
                backgroundColor: AppColor.blue,
                child: Icon(Icons.fingerprint_sharp, color: Colors.white),
              ),

              FloatingActionButton(
                heroTag: 'select',
                onPressed: () {
                  handleCheckout();
                },
                tooltip: "Pilih Alamat Ini",
                backgroundColor: AppColor.coklat,
                child: Icon(Icons.fingerprint_sharp, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
