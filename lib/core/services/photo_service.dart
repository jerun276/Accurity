import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A service dedicated to handling image picking and compression logic.
class PhotoService {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the specified source (camera or gallery),
  /// compresses it, and returns the resulting [File].
  ///
  /// Returns `null` if the user cancels the operation or an error occurs.
  Future<File?> pickAndCompressImage({
    ImageSource source = ImageSource.camera,
  }) async {
    try {
      // 1. Pick the original image file using image_picker.
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile == null) {
        // User canceled the picker.
        return null;
      }

      // 2. Define a unique path in the app's private documents directory
      //    to save the new, compressed image file.
      final documentsDir = await getApplicationDocumentsDirectory();
      final targetPath = p.join(
        documentsDir.path,
        'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // 3. Compress the image using flutter_image_compress.
      //    This significantly reduces file size for storage and upload.
      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
            pickedFile.path,
            targetPath,
            quality: 65, // A good balance between size and quality.
          );

      if (compressedFile == null) {
        return null;
      }

      return File(compressedFile.path);
    } catch (e) {
      // Log the error for debugging purposes.
      print('Failed to pick and compress image: $e');
      return null;
    }
  }
}
