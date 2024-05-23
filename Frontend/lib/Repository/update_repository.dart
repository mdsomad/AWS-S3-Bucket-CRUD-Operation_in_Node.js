import 'dart:io';

import 'package:flutter_application/API_Url/api_url.dart';
import 'package:flutter_application/Data/network/BaseApiServices.dart';
import 'package:flutter_application/Data/network/NetworkAPIServices.dart';
import 'package:flutter_application/Models/Success/success_model.dart';

class UpdateRepository {
  BaseAPIServices _apiServices =
      NetworkApiServices(); //TODO Create object NetworkApiServices class call

  // TODO Image Update Function Create
  Future<SuccessModel> imageUpdateRespons(
      File filePath, String imageUrl) async {
    try {
      dynamic response = await _apiServices.imageUpdateRespons(
          "${ApiUrl.imageUpdateEndPint}?ImageUrl=${imageUrl}",
          filePath); //* <-- imageUpdateRespons Function call
      return SuccessModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  // TODO Existing Post Single Image Delete Function Create
  Future<SuccessModel> existingPostSingleImageDeleteApiRespons(
      var id, String ImageUrl) async {
    try {
      dynamic response = await _apiServices.deleteApiRespons(ApiUrl
              .singleImageDeleteEndPint +
          "?id=${id}&ImageUrl=${ImageUrl}"); //* <-- deleteApiRespons Function call
      return SuccessModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
