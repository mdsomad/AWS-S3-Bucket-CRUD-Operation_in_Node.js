import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application/Provider/home/home_provider.dart';
import 'package:flutter_application/Repository/existing_post_single_new_Image_upload_repository.dart';
import 'package:flutter_application/Utils/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ExistingPostSingleNewImageUploadProvider with ChangeNotifier {
  ExistingPostSingleNewImageUploadProvider() : super() {
    // filePathCler();
  }

  final _myRepo = ExistingPostSingleNewImageUploadRepository();
  final logger = Logger();

  File? filePath;

  filePathCler() {
    filePath = null;
    notifyListeners();
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      filePath = File(pickedFile.path);
      notifyListeners();
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
  Future<dynamic> existingPostSingleNewImageUpload(
      String id, BuildContext context) async {
    setLoading(true);
    try {
      _myRepo.ExistingPostSingleNewImageUploadRespons(id, filePath!)
          .then((value) {
        setLoading(false);

        logger.i(
            "Image Single Upload Successful Data Info log 👉 ${value.message.toString()}");
        Utils.toastMessage(
            "Image Update Successful" + value.message.toString(), true);

        Provider.of<HomePageProvider>(context, listen: false)
            .fatchAllPostListApi();
      }).onError((error, stackTrace) {
        logger.e("Image Upload Error This 👉 ${error.toString()}");
        Utils.ftushBarErrorMessage(error.toString(), context);
      }); //* <-- ExistingPostSingleNewImageUploadRespons Function call
    } catch (e) {
      setLoading(false);
      throw e;
    }
  }
}
