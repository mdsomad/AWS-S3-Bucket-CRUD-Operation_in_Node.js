import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/Provider/Post/update_provider.dart';
import 'package:flutter_application/Provider/home/home_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateImagetScreen extends StatefulWidget {
  final String sId;
  final List<dynamic> imageUrl;
  UpdateImagetScreen({super.key, required this.imageUrl, required this.sId});

  @override
  State<UpdateImagetScreen> createState() => _UpdateImagetScreenState();
}

class _UpdateImagetScreenState extends State<UpdateImagetScreen> {
  List<imageMab> _images = [];

  Future<void> _getImage(int index, imageUrl) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // List<imageMab> data =
      //     _images.where((element) => element.isUpdate == true).toList();

      _images.asMap().forEach((index, value) {
        if (value.isUpdate == true) {
          _images[index].isUpdate = false;
        }
      });
      setState(() {
        _images[index] = imageMab(
            isUpdate: true,
            filePath: File(pickedFile.path),
            imageUrl: imageUrl);
        // _images.add(File(pickedFile.path));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final postPageProvider =
        Provider.of<PostPageProvider>(context, listen: false);

    postPageProvider.setUrlImageList(widget.imageUrl);
    // for (int i = 0; i < widget.imageUrl.length; i++) {
    //   _images.add(imageMab(
    //     isUpdate: false,
    //     filePath: null,
    //     imageUrl: widget.imageUrl[i],
    //   ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final homePageProvider =
        Provider.of<HomePageProvider>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
            titleSpacing: 0.0,
            title: Text(
              "Update Image Screen",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            )),
      ),
      body: Consumer<PostPageProvider>(
        builder: (context, providerValue, child) {
          return SingleChildScrollView(
            child: Form(
                child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  providerValue.images.length == 0
                      ? GestureDetector(
                          onTap: () {
                            // _getImage(index, imageUrl)
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Select Upload Images',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    'You can select upto 6 images',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 300,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: providerValue.images.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _viewImageInDialog(
                                      providerValue.images[index],
                                      index,
                                      context); //* <-- _viewImageInDialog Widget call
                                },
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: 'imageHero$index',
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: providerValue
                                                    .images[index].isUpdate ==
                                                false
                                            ? Image.network(
                                                providerValue
                                                    .images[index].imageUrl
                                                    .toString(),
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                providerValue
                                                    .images[index].filePath!,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      child: providerValue
                                                  .images[index].isUpdate ==
                                              false
                                          ? InkWell(
                                              onTap: () {
                                                providerValue.singleImageDelete(
                                                    widget.sId,
                                                    providerValue.images[index]
                                                        .imageUrl!,
                                                    index,
                                                    context);
                                                log("image deleted Button Call");
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(20.0),
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: Colors.red,
                                                  )),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                providerValue
                                                    .updateImageItemList(
                                                  index: index,
                                                  inUpdateData: imageMab(
                                                    isUpdate: false,
                                                    filePath: null,
                                                    imageUrl: "",
                                                  ),
                                                );
                                                log("Removed Image path button Call");
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(20.0),
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                      bottom: 50,
                                      right: 50,
                                      child: InkWell(
                                        onTap: () {
                                          providerValue.getImage(index);
                                          // setState(() {
                                          //   _getImage(
                                          //       index,
                                          //       _images[index]
                                          //           .imageUrl
                                          //           .toString());
                                          // });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          height:
                                              providerValue.loading == true &&
                                                      providerValue
                                                              .images[index]
                                                              .isUpdate ==
                                                          true
                                                  ? 40
                                                  : null,
                                          width:
                                              providerValue.loading == true &&
                                                      providerValue
                                                              .images[index]
                                                              .isUpdate ==
                                                          true
                                                  ? 40
                                                  : null,
                                          decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.75),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child:
                                              providerValue.loading == true &&
                                                      providerValue
                                                              .images[index]
                                                              .isUpdate ==
                                                          true
                                                  ? CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      color: Colors.green,
                                                    )
                                                  : Icon(
                                                      Icons.image,
                                                      color: providerValue
                                                                  .images[index]
                                                                  .isUpdate ==
                                                              false
                                                          ? Colors.green
                                                          : Colors.blue,
                                                      size: 20,
                                                    ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                      onTap: () {
                        List<dynamic> data = providerValue.images
                            .where((element) => element.isUpdate == true)
                            .toList();
                        providerValue.imageUpdate(
                            data[0].filePath!, data[0].imageUrl!, context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width / 2 - 70,
                            vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text("Update Image"),
                      )),
                ],
              ),
            )),
          );
        },
      ),
    );
  }

//TODO: Create _viewImageInDialog
  void _viewImageInDialog(imageMab imageObj, int index, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Hero(
                tag: 'imageHero$index',
                child: imageObj.isUpdate == false
                    ? Image.network(
                        imageObj.imageUrl.toString(),
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        imageObj.filePath!,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
