import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/order_details_bloc.dart';

class PhotosView extends StatelessWidget {
  const PhotosView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        if (state is OrderDetailsLoaded) {
          final photos = state.order.photoPaths;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      onPressed: () => context.read<OrderDetailsBloc>().add(
                        const AddPhotoRequested(source: ImageSource.camera),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      onPressed: () => context.read<OrderDetailsBloc>().add(
                        const AddPhotoRequested(source: ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Expanded(
                  child: photos.isEmpty
                      ? const Center(child: Text('No photos added.'))
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final path = photos[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to a new screen to view the image in full-screen
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => _FullScreenImageView(
                                      path: path,
                                      tag:
                                          path, // Use the path as a unique Hero tag
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag:
                                    path, // The same unique tag for a smooth animation
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: path.startsWith('http')
                                      ? CachedNetworkImage(
                                          imageUrl: path,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : Image.file(
                                          File(path),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// A new widget to display a single image in full-screen
class _FullScreenImageView extends StatelessWidget {
  final String path;
  final Object tag;

  const _FullScreenImageView({required this.path, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // A dark background for the photo view
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // White icons on a dark app bar
      ),
      body: Center(
        child: Hero(
          tag: tag, // The same tag as the thumbnail
          child: path.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: path,
                  fit: BoxFit.contain, // Contain the image within the screen
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.white),
                )
              : Image.file(File(path), fit: BoxFit.contain),
        ),
      ),
    );
  }
}
