import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:real_state/config/ApiLinks.dart';

class OfferSlider extends StatefulWidget {
  const OfferSlider({Key? key}) : super(key: key);

  @override
  State<OfferSlider> createState() => _OfferSliderState();
}

class _OfferSliderState extends State<OfferSlider>                {
  int _currentIndex = 0;
  bool _imagesLoaded = false;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: appState.offerList.length ?? 0,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final offers = appState.offerList[index];
            final imageUrl = '${ApiLinks.accessOfferImage}/${offers['of_image']}?timestamp=${DateTime.now().millisecondsSinceEpoch}';
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration:  BoxDecoration(
                color: Colors.grey,
                //borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  //NetworkImage(offerImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 150.0,
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: true,
            autoPlay: _imagesLoaded,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              if (index == appState.offerList!.length - 1) {
                // Last page reached, all images are loaded
                setState(() {
                  _imagesLoaded = true;
                });
              }
              setState(() {
                _currentIndex = index;
                _imagesLoaded = false;
              });
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        CarouselIndicator(
          count: appState.offerList.length,
          index: _currentIndex,
          color: Colors.grey,
          activeColor: Theme.of(context).hintColor, // Change this color to indicate the current page
          height: 8,
          width: 25,
          cornerRadius: 8,
        ),
      ],
    );

  }
}
