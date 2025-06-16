import 'package:flutter/material.dart';
import 'package:wallix_app/Model/wallpaper_model.dart';
import 'package:wallix_app/Views/imageView.dart';


Widget brandName() {
  return RichText(
    textAlign: TextAlign.center,
    text: const TextSpan(
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      children: [
        TextSpan(text: "WALLIX", style: TextStyle(color: Colors.black)),
        TextSpan(text: "GEN", style: TextStyle(color: Colors.amber)),
      ],
    ),
  );
}

Widget wallpaperList({
  required List<WallpaperModel> wallpapers,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GridView.count(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 0.62,
      children: wallpapers
          .where((wallpaper) =>
              wallpaper.src != null && wallpaper.src!.portrait != null)
          .map((wallpaper) {
        String imageUrl = wallpaper.src!.portrait!;
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageView(imgUrl: imageUrl),
                ),
              );
            },
            child: Hero(
              tag: imageUrl,
              child: Material(
                color: Colors.transparent,
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                              color: Colors.amber,
                            ),
                          );
                        },
                        
                        // Error handling for image loading
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.25),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(Icons.download_rounded, color: Colors.amber[800], size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}