import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application/Data/response/status.dart';
import 'package:flutter_application/Provider/home/home_provider.dart';
import 'package:flutter_application/Screen/Existing_Post_Single_New_Image_Upload.dart';
import 'package:flutter_application/Screen/addImage.dart';
import 'package:flutter_application/Screen/update_image_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

CarouselController buttonCarouselController = CarouselController();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      final homePageProvider =
          Provider.of<HomePageProvider>(context, listen: false);

      homePageProvider
          .fatchAllPostListApi(); //* <-- This fatchMoviesListApi() Function Call
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Home'),
      ),
      body: Consumer<HomePageProvider>(
        builder: (context, value, child) {
          switch (value.moviesList.status) {
            case Status.LOADING:
              return Center(child: CircularProgressIndicator());

            case Status.ERROR:
              return InkWell(
                  onTap: (() {
                    value.fatchAllPostListApi();
                  }),
                  child:
                      Center(child: Text(value.moviesList.message.toString())));

            case Status.COMPLETED:
              return ListView.builder(
                itemCount: value.moviesList.data!.post!.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3.4,
                      child: Column(
                        children: [
                          Stack(children: [
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                autoPlay: false,
                                aspectRatio: 1.8,
                                enlargeCenterPage: false,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                // height: 300,
                                // aspectRatio: 16 / 9,
                                viewportFraction: 0.9,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeFactor: 0.3,
                                onPageChanged: (index, reason) {
                                  print(index);
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                              itemCount: value.moviesList.data!.post![index]
                                  .imageUrl!.length,
                              carouselController: buttonCarouselController,
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                return Container(
                                    width: double.infinity,
                                    child: ImagePlaceholder(
                                      url: value.moviesList.data!.post![index]
                                          .imageUrl![itemIndex],
                                    ));
                              },
                            ),
                          ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: InkWell(
                                  onTap: () {
                                    log("Edit Image");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ExistingPostSingleNewImageUpload(
                                            sId: value.moviesList.data!
                                                .post![index].sId
                                                .toString(),
                                          ),
                                        ));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 20, right: 20),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateImagetScreen(
                                            sId: value.moviesList.data!
                                                .post![index].sId!,
                                            imageUrl: value.moviesList.data!
                                                .post![index].imageUrl!,
                                          ),
                                        ));
                                    log("Edit Image");
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: InkWell(
                                  onTap: () {
                                    log("Edit Image");
                                    value.deletePost(
                                        value.moviesList.data!.post![index].sId
                                            .toString(),
                                        context);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );

            default:
              return Text("NO Data");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          log("onPressed");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddImagetScreen(),
              ));
        },
        // tooltip: 'Increment',
        child: Icon(Icons.upload),
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final String url;
  const ImagePlaceholder({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
    );
  }
}
