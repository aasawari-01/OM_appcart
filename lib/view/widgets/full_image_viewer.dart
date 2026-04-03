import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:get/get.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../constants/colors.dart';

class FullImageViewer extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final ImageProvider? imageProvider;
  final String heroTag;

  const FullImageViewer({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.imageProvider,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider provider;
    if (imageProvider != null) {
      provider = imageProvider!;
    } else if (imageFile != null) {
      provider = FileImage(imageFile!);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      provider = NetworkImage(imageUrl!);
    } else {
      provider = const AssetImage('assets/images/drawer/profile_pic.png');
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(TablerIcons.x, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Hero(
          tag: heroTag,
          child: PhotoView(
            imageProvider: provider,
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? null
                    : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                color: AppColors.blue,
              ),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            initialScale: PhotoViewComputedScale.contained,
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, {String? imageUrl, File? imageFile, ImageProvider? imageProvider, required String heroTag}) {
    Get.to(
      () => FullImageViewer(
        imageUrl: imageUrl,
        imageFile: imageFile,
        imageProvider: imageProvider,
        heroTag: heroTag,
      ),
      transition: Transition.fadeIn,
      fullscreenDialog: true,
    );
  }
}
