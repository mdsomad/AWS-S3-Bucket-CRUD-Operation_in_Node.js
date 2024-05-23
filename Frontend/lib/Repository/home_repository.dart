import 'dart:io';

import 'package:flutter_application/Data/network/BaseApiServices.dart';
import 'package:flutter_application/Data/network/NetworkAPIServices.dart';
import 'package:flutter_application/Models/Posts/AllPost_Model.dart';
import 'package:flutter_application/API_Url/api_url.dart';
import 'package:flutter_application/Models/Posts/Image_Upload_Model.dart';
import 'package:flutter_application/Models/Success/success_model.dart';

class HomeRepository {
  BaseAPIServices _apiServices =
      NetworkApiServices(); //TODO Create object NetworkApiServices class call

  // TODO Video Get Function Create
  Future<AllPostModel> fetchAllPostLinkList() async {
    try {
      dynamic response = await _apiServices.getGetApiRespons(
          ApiUrl.GetAllPostEndPint); //* <-- getGetApiRespons Function call
      return AllPostModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  // TODO Image Post Function Create
  Future<ImageUpladModel> imagePostApiRespons(List<File> data) async {
    try {
      dynamic response = await _apiServices.getPostApiRespons(
          ApiUrl.imagePostEndPint,
          data); //* <-- imagePostApiRespons Function call
      return ImageUpladModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  // TODO Image And Post Delete Function Create
  Future<SuccessModel> deletePostApiRespons(id) async {
    try {
      dynamic response = await _apiServices.deleteApiRespons(
          ApiUrl.deletePostEndPint +
              "?id=${id}"); //* <-- deleteApiRespons Function call
      return SuccessModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
