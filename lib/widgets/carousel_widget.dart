import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  final List<NetworkImage> images;

  const Carousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images.map((image) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image(
            image: image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset("img/thumbnail.png", fit: BoxFit.cover),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: false,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        enableInfiniteScroll: true,
        pauseAutoPlayOnTouch: true,
      ),
    );
  }
}
