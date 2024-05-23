import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/Provider/home/home_provider.dart';
import 'package:flutter_application/Repository/update_repository.dart';
import 'package:flutter_application/Utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PostPageProvider with ChangeNotifier {
  // PostPageProvider() : super() {
  //   log("PostPageProvider  initialized");
  // }

  final _myRepo = UpdateRepository();
  final logger = Logger();

  List<imageMab> images = [];
  List<imageMab> _isUpdateData = [];
  List<imageMab> get isUpdateData => _isUpdateData;

  void updateImageItemList(
      {required int index, required imageMab inUpdateData}) {
    images[index] = imageMab(
        isUpdate: false, filePath: null, imageUrl: images[index].imageUrl
        // widget.imageUrl[index],
        );
    notifyListeners();
  }

  void deleteImageItemList(
      {required int index}) {
    images.remove(images[index]);
    notifyListeners();
  }

  Future<void> getImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      images.asMap().forEach((i, value) {
        if (value.isUpdate == true) {
          images[i].isUpdate = false;
        }
      });

      images[index] = imageMab(
          isUpdate: true,
          filePath: File(pickedFile.path),
          imageUrl: images[index].imageUrl);
      // _images.add(File(pickedFile.path));
      notifyListeners();
    }
  }

  setUrlImageList(List<dynamic> imageUrl) {
    if (images.isNotEmpty) {
      print(images.isNotEmpty);
      images.clear();
    }
    for (int i = 0; i < imageUrl.length; i++) {
      images.add(imageMab(
        isUpdate: false,
        filePath: null,
        imageUrl: imageUrl[i],
      ));
    }
  }

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    //* <-- Yah hai loading ka function
    _loading = value;
    notifyListeners();
  }

  //TODO Image Update Function Create
  Future<dynamic> imageUpdate(
      File filePath, String imageUrl, BuildContext context) async {
    setLoading(true);
    late int index;
    images.forEach((element) {
      print(images.indexOf(element));
      log("index This --> " +
          images.indexWhere((img) => img.imageUrl == imageUrl).toString());

      index = images.indexWhere((img) => img.imageUrl == imageUrl);
    });
    try {
      _myRepo.imageUpdateRespons(filePath, imageUrl).then((value) {
        setLoading(false);
        logger.i(
            "Image Update Successful Data Info log ✅ 👉 ${value.message.toString()}");
        Utils.toastMessage(
            "Image Update Successful" + value.message.toString(), true);
        updateImageItemList(
          index: index,
          inUpdateData: imageMab(
            isUpdate: false,
            filePath: null,
            imageUrl: imageUrl,
          ),
        );
        // return value.message;
      }).onError((error, stackTrace) {
        logger.e("Image Update Error This 👉 ${error.toString()}");
        Utils.ftushBarErrorMessage(error.toString(), context);
      }); //* <-- getPostApiRespons Function call
    } catch (e) {
      setLoading(false);
      throw e;
    }
  }

  //TODO Single Image Delete Function Create
  Future<dynamic> singleImageDelete(id, ImageUrl,index, BuildContext context) async {
    try {
      dynamic response = await _myRepo
          .existingPostSingleImageDeleteApiRespons(id, ImageUrl)
          .then((value) {
        final homePageProvider =
            Provider.of<HomePageProvider>(context, listen: false);
        homePageProvider.fatchAllPostListApi();
        deleteImageItemList(index:index);
        logger.i("Image Delete Data Info log ✅ 👉 ${value.message}");
        Utils.toastMessage("Image Delete Successful ✅ ${value.message}", true);
        // fatchAllPostListApi();
      }).onError((error, stackTrace) {
        logger.e("Image Delete Error This 👉 ${error.toString()}");
        Utils.ftushBarErrorMessage(error.toString(), context);
      }); //* <-- getPostApiRespons Function call
      return response;
    } catch (e) {
      throw e;
    }
  }
}

class imageMab {
  bool? isUpdate = false;
  File? filePath;
  String? imageUrl;

  imageMab({this.isUpdate, this.filePath, this.imageUrl});

  imageMab.fromJson(Map<String, dynamic> json) {
    isUpdate = json['isUpdate'];
    filePath = json['filePath'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson(Map map) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isUpdate'] = this.isUpdate;
    data['filePath'] = this.filePath;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
