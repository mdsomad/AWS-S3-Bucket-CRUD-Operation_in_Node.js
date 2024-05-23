// import 'dart:async';

// import 'package:flutter/material.dart';

// class ImageCarouselSlider extends StatefulWidget {
//   final List<String> imageUrlList;
//   ImageCarouselSlider({super.key, required this.imageUrlList});

//   @override
//   State<ImageCarouselSlider> createState() => _ImageCarouselSliderState();
// }

// final List<String> imageUrl = [
//   "https://somaddev-yt.s3.ap-south-1.amazonaws.com/IMG_20220916_152642_497.jpg",
//   "https://somaddev-yt.s3.ap-south-1.amazonaws.com/images/Videoshot_20240125_204809.jpg",
//   "https://somaddev-yt.s3.ap-south-1.amazonaws.com/pexels-modernafflatusphotography-404153.jpg"
// ];

// late List<Widget> _pages;

// int _activePage = 0;

// final PageController _pageController = new PageController(initialPage: 0);

// Timer? _timer;

// class _ImageCarouselSliderState extends State<ImageCarouselSlider> {
//   void startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 3), (timer) {
//       if (_pageController.page == imageUrl.length - 1) {
//         //*Checks if it's on the last
//         _pageController.animateToPage(0,
//             duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
//       } else {
//         _pageController.nextPage(
//             duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
//       }
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // for (int i = 0; i < widget.imageUrlList.length; i++) {
//     //   print(widget.imageUrlList[i]);
//     //   imageUrl.add(
//     //     widget.imageUrlList[i],
//     //   );
//     // }
//     _pages = List.generate(
//         imageUrl.length,
//         (index) => ImagePlaceholder(
//               url: imageUrl[index],
//             ));

//     startTimer();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _timer?.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       SizedBox(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height / 4,
//         child: PageView.builder(
//           controller: _pageController,
//           onPageChanged: (value) {
//             setState(() {
//               _activePage = value;
//             });
//           },
//           itemCount: imageUrl.length,
//           itemBuilder: (context, index) {
//             return _pages[index];
//           },
//         ),
//       ),
//       Positioned(
//         bottom: 10,
//         left: 0,
//         right: 0,
//         child: Container(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//                 _pages.length,
//                 (index) => Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5),
//                       child: InkWell(
//                         onTap: () {
//                           _pageController.animateToPage(index,
//                               duration: Duration(milliseconds: 30),
//                               curve: Curves.easeIn);
//                         },
//                         child: CircleAvatar(
//                           radius: 4,
//                           backgroundColor: _activePage == index
//                               ? Colors.yellow
//                               : Colors.grey,
//                         ),
//                       ),
//                     )),
//           ),
//         ),
//       )
//     ]);
//   }
// }

// class ImagePlaceholder extends StatelessWidget {
//   final String url;
//   const ImagePlaceholder({super.key, required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Image.network(
//       url,
//       fit: BoxFit.cover,
//     );
//   }
// }


