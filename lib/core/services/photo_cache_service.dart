import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PhotoCacheService {
  /// Takes a Supabase URL, downloads the image, and saves it locally.
  /// It's smart enough not to re-download an image that already exists.
  /// Returns the local File object of the cached image.
  Future<File?> cacheImageFromUrl(String url) async {
    try {
      // Create a predictable file name from the URL.
      // We use the last part of the URL's path, which is the unique file name in Supabase Storage.
      final fileName = p.basename(Uri.parse(url).path);

      final documentsDir = await getApplicationDocumentsDirectory();
      final localFilePath = p.join(documentsDir.path, fileName);
      final localFile = File(localFilePath);

      // 1. Check if the file already exists locally. If so, we're done.
      if (await localFile.exists()) {
        print('[PhotoCacheService] Image already cached locally: $fileName');
        return localFile;
      }

      // 2. If it doesn't exist, download it.
      print('[PhotoCacheService] Downloading image: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // 3. Save the downloaded image bytes to the local file.
        await localFile.writeAsBytes(response.bodyBytes);
        print(
          '[PhotoCacheService] Image successfully cached at: $localFilePath',
        );
        return localFile;
      } else {
        throw Exception(
          'Failed to download image. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('[PhotoCacheService] ERROR caching image from URL $url: $e');
      return null; // Return null on any failure.
    }
  }
}
