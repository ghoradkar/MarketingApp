import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:marketingapp/dashboard/dashboard_screen.dart';
import 'package:marketingapp/utils/color_constants.dart';

class ImageCarouselWithIndicator extends StatefulWidget {
  final List<SliderImage>? list;

  const ImageCarouselWithIndicator({super.key, this.list});

  @override
  ImageCarouselWithIndicatorState createState() =>
      ImageCarouselWithIndicatorState();
}

class ImageCarouselWithIndicatorState
    extends State<ImageCarouselWithIndicator> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.list?.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.only(left: 4,right: 4),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Image.asset(url.img),
                );
              },
            );
          }).toList(),
        ),
        // const SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.list != null
              ? widget.list!.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      _currentIndex = entry.key;
                    }),
                    child: Container(
                      width: _currentIndex == entry.key ? 20 : 8.0,
                      height: _currentIndex == entry.key ? 7 : 7,
                      margin: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(
                            _currentIndex == entry.key ? 12 : 60),
                        color: _currentIndex == entry.key
                            ? AppColor.primaryBackgroundColor // Active indicator color
                            : Colors.grey[400], // Inactive indicator color
                      ),
                    ),
                  );
                }).toList()
              : [],
        ),
      ],
    );
  }
}
