import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BannerItem extends StatefulWidget {
  // ? is null - needed?
  final String? title;
  final String? desc;
  final String img;
  // num can use 9 and 9.0
  final num height;
  final num width;

  BannerItem(
      {Key? key,
      required this.title,
      required this.desc,
      required this.img,
      this.height = 1.0,
      this.width = 0.8})
      : super(key: key);

  @override
  _BannerItemState createState() => _BannerItemState();
}

class _BannerItemState extends State<BannerItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      // child: GestureDetector(
      //   onTap: () => print("clicked"),
      //   child: Card(
      //     clipBehavior: Clip.antiAlias,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(24),
      //     ),
      //     child: Stack(
      //       alignment: Alignment.center,
      //       children: [
      //         Ink.image(
      //           image: Image.asset("${widget.img}").image,
      //           child: InkWell(
      //             onTap: () {},
      //           ),
      //           height: 240,
      //           fit: BoxFit.cover,
      //         ),
      //         Text(
      //           'Card With Splash',
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             color: Colors.white,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // )

      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: 150,
        child: GestureDetector(
          onTap: () {
            print("tapped: ${widget.img}");
          },
          child: Card(
            elevation: 0,
            semanticContainer: false,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
            ),
            child: Image.network("${widget.img}", fit: BoxFit.cover,),
            
          ),
        ),
      )
    );
  }
}
