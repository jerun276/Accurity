import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickAndCompressImage({required ImageSource source}) async {
    try {
      Permission permission;

      if (source == ImageSource.camera) {
        permission = Permission.camera;
      } else {
        permission = Permission.photos;
      }

      PermissionStatus status = await permission.status;

      if (status.isDenied || status.isPermanentlyDenied) {
        PermissionStatus newStatus = await permission.request();

        if (newStatus.isPermanentlyDenied) {
          await openAppSettings();
          return null;
        }

        if (!newStatus.isGranted) {
          return null;
        }
      }

      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile == null) {
        return null;
      }

      final documentsDir = await getApplicationDocumentsDirectory();
      final targetPath = p.join(
        documentsDir.path,
        'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
            pickedFile.path,
            targetPath,
            quality: 65,
          );

      if (compressedFile == null) {
        return null;
      }

      return File(compressedFile.path);
    } catch (e) {
      return null;
    }
  }
}
