import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui; // Import dart:ui with a prefix to avoid name clashes
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../core/constant/app_colors.dart';
import '../bloc/order_details_bloc.dart';

class SketchView extends StatefulWidget {
  const SketchView({super.key});

  @override
  State<SketchView> createState() => _SketchViewState();
}

class _SketchViewState extends State<SketchView> {
  // A GlobalKey is needed to access the state of the SignaturePad widget.
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  void _handleSaveButtonPressed() async {
    // 1. Render the signature pad content as an image.
    final ui.Image image = await _signaturePadKey.currentState!.toImage();

    // 2. Convert the image to byte data in PNG format.
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) return;
    final Uint8List pngBytes = byteData.buffer.asUint8List();

    // 3. Get the application's temporary directory to save the file.
    final tempDir = await getTemporaryDirectory();
    final fileName = 'sketch_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = await File('${tempDir.path}/$fileName').create();

    // 4. Write the image data to the file.
    await file.writeAsBytes(pngBytes);

    print('[SketchView] Sketch saved to local path: ${file.path}');

    // 5. Dispatch an event to the BLoC with the new file path.
    if (mounted) {
      context.read<OrderDetailsBloc>().add(SketchSaved(filePath: file.path));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sketch saved and attached to order.'),
          backgroundColor: AppColors.accent,
        ),
      );
      // Clear the pad after saving.
      _signaturePadKey.currentState!.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // The main drawing area.
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mediumGrey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SfSignaturePad(
                key: _signaturePadKey,
                backgroundColor: Colors.white,
                strokeColor: Colors.black,
                minimumStrokeWidth: 1.0,
                maximumStrokeWidth: 4.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons for the sketch pad.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mediumGrey,
                ),
                onPressed: () {
                  _signaturePadKey.currentState!.clear();
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Sketch'),
                onPressed: _handleSaveButtonPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
