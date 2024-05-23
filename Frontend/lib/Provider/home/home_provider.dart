import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/Data/response/api_response.dart';
import 'package:flutter_application/Models/Posts/AllPost_Model.dart';
import 'package:flutter_application/Repository/home_repository.dart';
import 'package:flutter_application/Utils/Utils.dart';
import 'package:logger/logger.dart';

class HomePageProvider with ChangeNotifier {
  final _myRepo = HomeRepository();
  final logger = Logger();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    //* <-- Yah hai loading ka function
    _loading = value;
    notifyListeners();
  }

  ApiResponse<AllPostModel> moviesList = ApiResponse.loading();

  setMoviesList(ApiResponse<AllPostModel> response) {
    moviesList = response;
    notifyListeners();
  }

  Future<void> fatchAllPostListApi() async {
    setMoviesList(ApiResponse.loading());

    print('data loading');

    _myRepo.fetchAllPostLinkList().then((value) {
      setMoviesList(ApiResponse.completed(value));
      logger.i("Data Info log 👉 ${value.post.toString()}");
    }).onError((error, stackTrace) {
      logger.e("Get All Image Error This 👉 ${error.toString()}");
      setMoviesList(ApiResponse.error(error.toString()));
    });
    print('End Run');
  }

  //TODO Image Post Function Create
  Future<dynamic> imageUplad(List<File> data, BuildContext context) async {
    try {
      _myRepo.imagePostApiRespons(data).then((value) {
        logger.i(
            "Image Upload Successful Data Info log ✅ 👉 ${value.toString()}");
        Utils.toastMessage("Image Upload Successful", true);
        fatchAllPostListApi();
      }).onError((error, stackTrace) {
        logger.e("Image Upload Error This 👉 ${error.toString()}");
        Utils.ftushBarErrorMessage(error.toString(), context);
      }); //* <-- getPostApiRespons Function call
    } catch (e) {
      throw e;
    }
  }

  //TODO Image Post Function Create
  Future<dynamic> deletePost(id, BuildContext context) async {
    try {
      dynamic response = await _myRepo.deletePostApiRespons(id).then((value) {
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
