import 'dart:io';

import 'package:flutter_application/API_Url/api_url.dart';
import 'package:flutter_application/Data/network/BaseApiServices.dart';
import 'package:flutter_application/Data/network/NetworkAPIServices.dart';
import 'package:flutter_application/Models/Success/success_model.dart';

class ExistingPostSingleNewImageUploadRepository {
  BaseAPIServices _apiServices =
      NetworkApiServices(); //TODO Create object NetworkApiServices class call

  // TODO Image Update Function Create
  Future<SuccessModel> ExistingPostSingleNewImageUploadRespons(
    String id,
    File filePath,
  ) async {
    try {
      dynamic response =
          await _apiServices.existingPostSingleNewImageUploadRespons(
              "${ApiUrl.existingPostSingleNewImageUploadEndPint}?id=${id}",
              filePath); //* <-- imageUpdateRespons Function call
      return SuccessModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
