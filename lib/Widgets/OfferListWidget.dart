import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';

class OfferListWidget extends StatefulWidget {
  const OfferListWidget({Key? key}) : super(key: key);

  @override
  State<OfferListWidget> createState() => _OfferListWidgetState();
}

class _OfferListWidgetState extends State<OfferListWidget> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return Expanded(
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: appState.offerList.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final offers = appState.offerList[index];
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    //borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/home.jpg'),
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
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  // Handle page change if needed
                  setState(() {
                    _currentIndex = index;
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
        ),
      );

  }
}
