import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewHintScreen extends StatefulWidget {
  const ViewHintScreen({Key? key}) : super(key: key);

  @override
  _ViewHintScreenState createState() => _ViewHintScreenState();
}

class _ViewHintScreenState extends State<ViewHintScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text('힌트 보기'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: CarouselSlider(
          options: CarouselOptions(height: 400.0),
          items: [1,2,3,4,5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.amber
                    ),
                    child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                );
              },
            );
          }).toList(),
        ),
      )
    );
  }

  titleText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Text(text, style: TextStyle(fontSize: Get.width * 0.06),),
    );
  }

  bodyText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(text, style: TextStyle(fontSize: Get.width * 0.04),),
    );
  }
}
