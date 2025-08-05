import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
                            return Image.file(
                              File(photos[index]),
                              fit: BoxFit.cover,
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
