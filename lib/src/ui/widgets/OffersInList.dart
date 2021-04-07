import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Secondlist extends StatefulWidget {
  @override
  _SecondlistState createState() => _SecondlistState();
}

final List<String> imgList = [
  'https://cdn.grabon.in/gograbon/images/web-images/uploads/1576647728222/oven-story-coupons.jpg',
  'https://www.1mg.com/articles/wp-content/uploads/2016/06/offer-2.png',
  'https://cdn.grabon.in/gograbon/images/category/1546252575451.png',
  'https://v.fastcdn.co/u/b33fcfa6/53561878-0-20201005-india.jpg',
  'https://thumbs.dreamstime.com/z/diwali-sale-banner-poster-design-discount-offer-top-view-rangoli-decorated-illuminated-oil-lamp-diya-brown-159433686.jpg'
];

class _SecondlistState extends State<Secondlist> {
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        item,
                        fit: BoxFit.fill,
                        width: 1000.0,
                        height: 500,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
          child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
        ),
        items: imageSliders,
      )),
    );
  }
}
