import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:motives_tneww/screens/dashboard.dart';
import 'package:motives_tneww/screens/home.dart';
import 'package:motives_tneww/widget/glass_card.dart';
import 'package:motives_tneww/widget/toast_widget.dart';


class MarkAttendanceView extends StatefulWidget {
  const MarkAttendanceView({super.key});

  @override
  State<MarkAttendanceView> createState() => _MarkAttendanceViewState();
}

class _MarkAttendanceViewState extends State<MarkAttendanceView> {
  final loc.Location location = loc.Location();
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  BitmapDescriptor? _currentMarkerIcon;
  BitmapDescriptor? _shopMarkerIcon;
  LatLng? _currentLatLng;
  CameraPosition? _initialCameraPosition;
  String distanceInfo = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    await _loadCustomMarkers();
    await _requestPermissionAndFetchLocation();
    // _addRandomShopMarkers();
    setState(() {
      _isMapReady = true;
      distanceInfo = '';
    });
  }

  Future<void> _loadCustomMarkers() async {
    _currentMarkerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/g_marker.png',
    );
  }

  Future<void> _requestPermissionAndFetchLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    final currentLocation = await location.getLocation();
    _currentLatLng = LatLng(
      currentLocation.latitude ?? 24.8607,
      currentLocation.longitude ?? 67.0011,
    );

    _initialCameraPosition = CameraPosition(target: _currentLatLng!, zoom: 14);

    if (_currentMarkerIcon != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLatLng!,
          icon: _currentMarkerIcon!,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }
  }


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  final ImagePicker _picker = ImagePicker();
  File? _capturedImage;

  void _markAttendance() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    String formattedTime =
      DateFormat('hh:mm a').format(now); 
    final storage = GetStorage();
    storage.write("checkin_time", formattedTime);
    storage.write("checkin_date", formattedDate);
    if (photo != null) {
      setState(() {
        _capturedImage = File(photo.path);
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen()));

      toastWidget(
          "Your Attendence is marked successfully at $formattedTime on $formattedDate.",
          Colors.green);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera cancelled or failed')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      //  drawer: CustomNavDrawer(),
      body: Stack(
        children: [
          if (_isMapReady && _initialCameraPosition != null)
            GoogleMap(
              padding: const EdgeInsets.only(bottom: 60),
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialCameraPosition!,
              mapType: MapType.normal,
              markers: _markers,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          // Positioned(
          //   top: 38,
          //   left: 16,
          //   child: DrawerMenuButton(scaffoldKey: _scaffoldKey),
          // ),
          if (distanceInfo.isNotEmpty)
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  distanceInfo,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child:InkWell(
              onTap: _markAttendance,
              child: GlassCard(
                width: MediaQuery.of(context).size.width * 0.80,
                height: 60,
                borderRadius: 16,
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const SizedBox(width: 8),
                    ShaderMaskText(text: 'Mark Attendence', textxfontsize: 19),
                    const Spacer(),
                         
                  ],
                ),
              ),
            ), 
          ),
        ],
      ),
    );
  }
}


