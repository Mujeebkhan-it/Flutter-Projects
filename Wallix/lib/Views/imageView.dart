import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:flutter/services.dart';

class ImageView extends StatefulWidget {
  final String? imgUrl;
  const ImageView({super.key, required this.imgUrl});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool _isSaving = false;
  static const MethodChannel _platform = MethodChannel('flutter/platform'); // Channel to get Android SDK version

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl!,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imgUrl!,
                fit: BoxFit.cover, 
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _isSaving ? null : _saveImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                              width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isSaving)
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2.5,  // Adjust stroke width for better visibility
                                ),
                              )
                            else
                              const Icon(Icons.download_rounded,
                                  color: Colors.white, size: 28),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isSaving
                                      ? "Saving..."
                                      : "Download Wallpaper",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const Text(
                                  "Image will be saved in gallery",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage() async {
    setState(() => _isSaving = true);
    bool hasPermission = await _askPermission();

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied!")),
      );
      setState(() => _isSaving = false);
      return;
    }

    try {
      final response = await Dio().get(
        widget.imgUrl!,
        options: Options(responseType: ResponseType.bytes),
      );

      final result = await ImageGallerySaverPlus.saveImage(
        response.data,
        quality: 100,
        name: "wallpaper_${DateTime.now().millisecondsSinceEpoch}", // Unique name for the image
      );

      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image saved to gallery!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save image.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving image: $e")),
      );
    }

    setState(() => _isSaving = false);
  }

  Future<bool> _askPermission() async {
    if (Platform.isIOS) {
      return await Permission.photos.request().isGranted;
    }

    int sdkInt = await _getAndroidSdkInt();

    if (sdkInt >= 33) {
      return await Permission.photos.request().isGranted;
    }

    return await Permission.storage.request().isGranted;
  }

  Future<int> _getAndroidSdkInt() async {
    try {
      final int? sdkInt = await _platform.invokeMethod<int>('getSdkInt');
      return sdkInt ?? 0;
    } catch (_) {
      return 0;
    }
  }
}