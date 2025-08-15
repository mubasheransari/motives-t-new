import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motives_tneww/screens/dashboard.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  GoogleMapController? _mapController;
  final List<_Place> _places = const [
    _Place('New York', LatLng(40.7128, -74.0060)),
    _Place('Los Angeles', LatLng(34.0522, -118.2437)),
    _Place('Chicago', LatLng(41.8781, -87.6298)),
    _Place('Houston', LatLng(29.7604, -95.3698)),
    _Place('Phoenix', LatLng(33.4484, -112.0740)),
    _Place('Philadelphia', LatLng(39.9526, -75.1652)),
    _Place('San Antonio', LatLng(29.4241, -98.4936)),
    _Place('San Diego', LatLng(32.7157, -117.1611)),
    _Place('Dallas', LatLng(32.7767, -96.7970)),
    _Place('San Jose', LatLng(37.3382, -121.8863)),
    _Place('Austin', LatLng(30.2672, -97.7431)),
    _Place('Jacksonville', LatLng(30.3322, -81.6557)),
  ];

  late final Set<Marker> _markers = {
    for (final p in _places)
      Marker(
        markerId: MarkerId(p.name),
        position: p.latLng,
        infoWindow: InfoWindow(title: p.name),
        onTap: () {
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: p.latLng, zoom: 10),
            ),
          );
          setState(() => _selectedPlace = p);
        },
      ),
  };

  _Place? _selectedPlace;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(39.8283, -98.5795),
    zoom: 3.8,
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final overlayWidth = width * 0.90;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            onMapCreated: (controller) => _mapController = controller,
            mapType: MapType.normal,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            markers: _markers,
          ),

          // TOP glassmorphic bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            child: _GlassCard(
              width: overlayWidth,
              height: 50,
              borderRadius: 16,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  //  const Icon(Icons.public, size: 20),
                  const SizedBox(width: 8),
                  ShaderMaskText(text: 'Search', textxfontsize: 16),
                  // const Text(
                  //   'New Task Alert',
                  //   style: TextStyle(fontWeight: FontWeight.w600),
                  // ),
                  const Spacer(),
                  // IconButton(
                  //   tooltip: 'Center on Australia',
                  //   icon: const Icon(Icons.center_focus_strong_outlined),
                  //   onPressed: () {
                  //     _mapController?.animateCamera(
                  //       CameraUpdate.newCameraPosition(_initialCamera),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),

          // BOTTOM glassmorphic panel
     /*     Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: _GlassCard(
              width: overlayWidth,
              height: 170,
              borderRadius: 20,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New Orders",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "Earnings :",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          " 12\$",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.lock_clock,
                          size: 23,
                        ),
                        Text(
                          "Today 2:20",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 23,
                        ),
                        Text(
                          "Perth, WA 6000, Australia",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /*    _selectedPlace == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Popular Spots',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.separated(
                              itemCount: _places.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1, thickness: .5),
                              itemBuilder: (_, i) => ListTile(
                                dense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                leading: const Icon(Icons.place_outlined),
                                title: Text(_places[i].name),
                                onTap: () {
                                  _mapController?.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: _places[i].latLng,
                                        zoom: 10,
                                      ),
                                    ),
                                  );
                                  setState(() => _selectedPlace = _places[i]);
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.place, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _selectedPlace!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  setState(() => _selectedPlace = null);
                                },
                                child: const Text('See all'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Lat: ${_selectedPlace!.latLng.latitude.toStringAsFixed(4)}, '
                                  'Lng: ${_selectedPlace!.latLng.longitude.toStringAsFixed(4)}',
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Tip: Tap other markers to update this panel.',
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: () {
                                      _mapController?.animateCamera(
                                        CameraUpdate.newLatLngZoom(
                                          _selectedPlace!.latLng,
                                          13,
                                        ),
                                      );
                                    },
                                    child: const Text('Zoom In'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),*/
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Widget child;

  const _GlassCard({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.10),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Place {
  final String name;
  final LatLng latLng;
  const _Place(this.name, this.latLng);
}
