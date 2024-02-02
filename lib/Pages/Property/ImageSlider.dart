import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:real_state/Pages/Property/FullImageView.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';

class ImageSlider extends StatefulWidget {
  final Map<String, dynamic> propertyData;
  bool asFinder;

  ImageSlider({required this.propertyData, required this.asFinder});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<dynamic>? imageUrlList;
  final PageController _pageController = PageController(initialPage: 0);
  double _currentPage = 0.0;

  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    _mounted = true;
    imageUrlList = widget.propertyData['pi_name'];
    _pageController.addListener(() {
      if(_mounted){
        setState(() {
          _currentPage = _pageController.page!;
        });
      }
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
    _mounted = false;
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
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
                        const LinearProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        //height: 200,
                        fit: BoxFit.fitHeight,
                      )
                  )
              );
            },
          ),
        ),
        imageUrlList!.isNotEmpty
            ? DotsIndicator(
                dotsCount: imageUrlList!.length,
                position: _currentPage.toInt(),
                decorator: DotsDecorator(
                  activeColor: Theme.of(context).primaryColor,
                  activeSize: const Size(10.0, 25.0),
                  spacing: const EdgeInsets.all(4),
                ),
              )
            : const Text('length 0'),
      ],
    );
  }
}
