import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Post/existing_post_single_new_Image_upload_provider.dart';

class ExistingPostSingleNewImageUpload extends StatefulWidget {
  final String sId;
  ExistingPostSingleNewImageUpload({super.key, required this.sId});

  @override
  State<ExistingPostSingleNewImageUpload> createState() =>
      EexistingPostSingleNewImageUploadState();
}

class EexistingPostSingleNewImageUploadState
    extends State<ExistingPostSingleNewImageUpload> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final existingPostSingleNewImageUploadProviderProvider =
          Provider.of<ExistingPostSingleNewImageUploadProvider>(context,
              listen: false);
      existingPostSingleNewImageUploadProviderProvider.filePathCler();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(" Existing Post New Image Upload"),
        ),
        body: Consumer<ExistingPostSingleNewImageUploadProvider>(
            builder: (context, providerValue, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // color: Colors.yellow,
                padding:
                    providerValue.filePath == null ? EdgeInsets.all(15) : null,
                height: providerValue.filePath != null ? 250 : 200,
                width: providerValue.filePath != null
                    ? MediaQuery.of(context).size.width
                    : null,
                child: providerValue.filePath != null
                    ? GestureDetector(
                        onTap: () {
                          _viewImageInDialog(providerValue.filePath!,
                              context); //* <-- _viewImageInDialog Widget call
                        },
                        child: Stack(
                          children: [
                            Hero(
                              tag:
                                  'imageHero${providerValue.filePath.toString()}',
                              child: Image.file(
                                providerValue.filePath!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            providerValue.loading
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox()
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          // _getImage();
                          providerValue.getImage();
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
                                  'You can select upto 1 image',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                  onTap: () {
                    providerValue.existingPostSingleNewImageUpload(
                        widget.sId, context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 2 - 70,
                        vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text("Single Upload Image"),
                  )),
            ],
          );
        }));
  }
}

//TODO: Create _viewImageInDialog
void _viewImageInDialog(File filePath, BuildContext context) {
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
              tag: 'imageHero${filePath.toString()}',
              child: Image.file(
                filePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    },
  );
}
