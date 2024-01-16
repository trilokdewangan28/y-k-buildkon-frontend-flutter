import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:real_state/Pages/Property/FullImageView.dart';
import 'package:real_state/config/ApiLinks.dart';

class ImageSlider extends StatefulWidget {
  final Map<String, dynamic> propertyData;
  bool asFinder;

  ImageSlider({required this.propertyData, required this.asFinder});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<dynamic>? imageUrlList;
  PageController _pageController = PageController(initialPage: 0);
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    imageUrlList = widget.propertyData['pi_name'];
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  void updateImageUrlList() {
    imageUrlList = widget.propertyData['pi_name'];
  }

  @override
  void didUpdateWidget(covariant ImageSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.propertyData != widget.propertyData) {
      updateImageUrlList();
      _pageController.jumpToPage(0); // Reset the page index to the first image
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: PageView.builder(
            controller: _pageController,
            itemCount: imageUrlList!.length,
            itemBuilder: (BuildContext context, int index) {
              final singleImageUrl =
                  '${ApiLinks.accessPropertyImages}/${imageUrlList![index]}';
              return ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullImageView(
                                imageUrl: imageUrlList![index],
                                asFinder: widget.asFinder),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: singleImageUrl,
                        placeholder: (context, url) =>
                            LinearProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        //height: 200,
                        fit: BoxFit.fitHeight,
                      )));
            },
          ),
        ),
        imageUrlList!.isNotEmpty
            ? DotsIndicator(
                dotsCount: imageUrlList!.length,
                position: _currentPage.toInt(),
                decorator: DotsDecorator(
                  activeColor: Theme.of(context).hintColor,
                  activeSize: const Size(10.0, 25.0),
                  spacing: EdgeInsets.all(4),
                ),
              )
            : Text('length 0'),
      ],
    );
  }
}
