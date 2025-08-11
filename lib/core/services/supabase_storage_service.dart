import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A service to handle all interactions with Supabase Storage.
class SupabaseStorageService {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _bucketName = 'inspection-photos';

  /// Uploads an image file to the 'inspection_photos' bucket.
  ///
  /// [imageFile] is the local file to upload.
  /// [fileName] is the unique name for the file in the bucket (e.g., 'order_15_photo_1.jpg').
  ///
  /// Returns the public URL of the uploaded image.
  Future<String> uploadImage(File imageFile, String fileName) async {
    try {
      // 1. Upload the file to the specified path in the bucket.
      await _client.storage
          .from(_bucketName)
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600', // Cache the image for 1 hour
              upsert: false, // Do not overwrite existing files
            ),
          );

      // 2. Once the upload is complete, get the public URL for the file.
      final String publicUrl = _client.storage
          .from(_bucketName)
          .getPublicUrl(fileName);

      return publicUrl;
    } on StorageException catch (e) {
      // Handle potential storage-specific errors
      print('Supabase Storage Error: ${e.message}');
      rethrow;
    } catch (e) {
      // Handle any other errors
      print('An unexpected error occurred during image upload: $e');
      rethrow;
    }
  }
}
