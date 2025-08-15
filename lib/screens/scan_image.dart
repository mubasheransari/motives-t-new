import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widget/shader_mask_text.dart';

class ReportScreen extends StatelessWidget {
  final File capturedImage;
  ReportScreen({required this.capturedImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        title: ShaderMaskText(
          text: "Report Details",
          textxfontsize: 20,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: const Color(0xFF1E1E1E), // Dark card color
          elevation: 8,
          shadowColor: Colors.purple.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Image with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    capturedImage,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                // Title using ShaderMaskText
                ShaderMaskText(
                  text: "Tiretest.AI Report",
                  textxfontsize: 22,
                ),
                const SizedBox(height: 8),

                // Report Description
                Text(
                  "The tread depth is optimal and there are no visible cracks. "
                  "The tire pressure appears consistent; however, a full check is recommended after 1000 km.",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),

                const SizedBox(height: 20),

                // Stylish Gradient Button
                InkWell(
                  onTap: () {
                    // Action here
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Download Report",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class ReportScreen extends StatelessWidget {
//     File capturedImage;
//    ReportScreen({required this.capturedImage});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FA),
//       appBar: AppBar(
//         title: const Text(

//           "Report Details",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 6,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Image.file(
//                capturedImage,
//                 width: 300,
//                 height: 200,
//                 fit: BoxFit.cover,
//               ),
//                 // Image
//                 // ClipRRect(
//                 //   borderRadius: BorderRadius.circular(12),
//                 //   child: Image.asset(
//                 //     'assets/report_image.png', // Change to your image
//                 //     height: 180,
//                 //     width: double.infinity,
//                 //     fit: BoxFit.cover,
//                 //   ),
//                 // ),
//                 const SizedBox(height: 20),

//                 // Report Text
//                 const Text(
//                   "Tiretest.AI Report",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//           //       Padding(
//           //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           //   child: Text(
//           //     '✔️ Tread depth is optimal\n'
//           //     '✔️ No visible cracks\n'
//           //     '✔️ Tire pressure appears consistent\n'
//           //     '⚠️ Recommend full check after 1000km\n',
//           //               style: TextStyle(
//           //           fontSize: 15,
//           //           color: Colors.black54,
//           //           height: 1.5,
//           //         ),
//           //         textAlign: TextAlign.justify,
//           //   ),
//           // ),
//                 const Text(
//                   "The tread depth is optimal and there are no visible cracks. The tire pressure appears consistent; however, a full check is recommended after 1000 km.",
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.black54,
//                     height: 1.5,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class TireScannerScreen extends StatefulWidget {
  File capturedImage;
  TireScannerScreen({required this.capturedImage});

  @override
  _TireScannerScreenState createState() => _TireScannerScreenState();
}

class _TireScannerScreenState extends State<TireScannerScreen> {
  File? _capturedImage;
  bool _showReport = false;

  Future<void> _scanImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _capturedImage = File(pickedFile.path);
        _showReport = false;
      });

      // Open full-screen ad screen
      final bool completed = await Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => FullScreenAdView(),
        ),
      );

      // If ad was completed, show report
      if (completed) {
        setState(() {
          _showReport = true;
        });
      } else {
        Fluttertoast.showToast(
          msg: "You should complete the ad to get your tire report",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  Widget _buildScanView() {
    return GestureDetector(
      onTap: _scanImage,
      child: Container(
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        child: Center(
          child: Text(
            '📷 Tap to Scan Image',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[100],
                  child: Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.27),
              Text(
                "Report",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              widget.capturedImage,
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Tiretest.ai Analysis',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              '✔️ Tread depth is optimal\n'
              '✔️ No visible cracks\n'
              '✔️ Tire pressure appears consistent\n'
              '⚠️ Recommend full check after 1000km\n',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              _buildResultView()), // appbartitle: _showReport ?'Report':'Scan',
    );
  }
}

// ---------------------
// Full-Screen Ad Widget
// ---------------------
class FullScreenAdView extends StatefulWidget {
  @override
  _FullScreenAdViewState createState() => _FullScreenAdViewState();
}

class _FullScreenAdViewState extends State<FullScreenAdView> {
  late VideoPlayerController _controller;
  bool _isAdComplete = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/sample_ad.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // Complete the ad after 15 seconds
    Timer(Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          _isAdComplete = true;
        });
        Navigator.pop(context, true); // return true = ad completed
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClosePressed() {
    if (!_isAdComplete) {
      Navigator.pop(context, false); // return false = ad not completed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : CircularProgressIndicator(),
          ),
          // Close button
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: _onClosePressed,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class TireScannerScreen extends StatefulWidget {
//   @override
//   _TireScannerScreenState createState() => _TireScannerScreenState();
// }

// class _TireScannerScreenState extends State<TireScannerScreen> {
//   File? _capturedImage;
//   bool _isAdShowing = false;
//   bool _showReport = false;
//   VideoPlayerController? _videoController;

//   Future<void> _scanImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       setState(() {
//         _isAdShowing = true;
//         _capturedImage = File(pickedFile.path);
//         _showReport = false;
//       });

//       _videoController = VideoPlayerController.asset('assets/sample_ad.mp4')
//         ..initialize().then((_) {
//           setState(() {});
//           _videoController!.play();
//         });

//       // Delay 15 seconds before showing result
//       await Future.delayed(Duration(seconds: 15));

//       _videoController?.pause();
//       setState(() {
//         _isAdShowing = false;
//         _showReport = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   Widget _buildScanView() {
//     return GestureDetector(
//       onTap: _scanImage,
//       child: Container(
//         width: 250,
//         height: 150,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: Colors.blueAccent, width: 2),
//         ),
//         child: Center(
//           child: Text(
//             '📷 Tap to Scan Image',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAdScreen() {
//     return Center(
//       heightFactor: MediaQuery.of(context).size.height,
//       child: _videoController != null && _videoController!.value.isInitialized
//           ? AspectRatio(
//               aspectRatio: _videoController!.value.aspectRatio,
//               child: VideoPlayer(_videoController!),
//             )
//           : CircularProgressIndicator(),
//     );
//   }

//   Widget _buildResultView() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           if (_capturedImage != null)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.file(
//                 _capturedImage!,
//                 width: 300,
//                 height: 200,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           SizedBox(height: 20),
//           Text(
//             'Tiretest.ai Analysis',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           Divider(thickness: 2),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Text(
//               '✔️ Tread depth is optimal\n'
//               '✔️ No visible cracks\n'
//               '✔️ Tire pressure appears consistent\n'
//               '⚠️ Recommend full check after 1000km\n',
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget bodyContent;

//     if (_isAdShowing) {
//       bodyContent = _buildAdScreen();
//     } else if (_showReport) {
//       bodyContent = _buildResultView();
//     } else {
//       bodyContent = Center(child: _buildScanView());
//     }

//     return CustomScaffoldWidget(
//      // appBar: AppBar(title: Text('Tiretest.ai Anaylsis')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: bodyContent,
//       ), appbartitle: 'Report',
//     );
//   }
//}
