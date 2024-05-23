import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_application/Data/app_expositions.dart';
import 'package:flutter_application/Data/network/BaseApiServices.dart';
import 'package:flutter_application/Models/error/Error_Model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class NetworkApiServices extends BaseAPIServices {
  //* NetworkApiServices class Link this BaseAPIServices class
  final logger = Logger();

  @override
  Future getGetApiRespons(String Url) async {
    // TODO: implement getGetApiRespons

    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(Url)).timeout(Duration(seconds: 60));

      responseJson =
          returnResponse(response); //* <-- returnResponse Finction call
    } on SocketException {
      throw FetchDataException(
          'No Internet Conncetion'); //* <-- FetchDataException class call
    }
    return responseJson;
  }

  @override
  Future getPostApiRespons(String url, List<File> newfileList) async {
    // TODO: implement getPostApiRespons

    if (kDebugMode) {
      print("This Url  👉 $url");
      print("File List  👉 $newfileList");
    }

    dynamic responseJson;
    try {
      var uri = Uri.parse(url);
      http.MultipartRequest request = new http.MultipartRequest('POST', uri);

      List<http.MultipartFile> newList = [];

      for (int i = 0; i < newfileList.length; i++) {
        File imageFile = File(newfileList[i].path);

        var stream = new http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();

        var multipartFile = new http.MultipartFile("images", stream, length,
            filename: basename(imageFile.path.split("/").last));
        newList.add(multipartFile);
      }

      request.files.addAll(newList);

      var streamedResponse = await request.send();

      if (kDebugMode) {
        print(streamedResponse.toString());
      }
      final response = await http.Response.fromStream(streamedResponse);

      //!👇 Currently Not Used
      /*-
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        print('value');
        // print(value);
        print("Response Data This 👉 ${value.toString()}");
      });

      */

      responseJson =
          returnResponse(response); //* <-- returnResponse Finction call
    } on SocketException {
      throw FetchDataException('No Internet Conncetion');
    }

    return responseJson;
  }

  @override
  Future imageUpdateRespons(String url, File filePath) async {
    // TODO: implement imageUpdateRespons

    logger.i("Url This  👉 $url");
    logger.i("File Path This  👉 $filePath");

    dynamic responseJson;
    try {
      //*👇 string to uri
      var uri = Uri.parse(url);
      http.MultipartRequest request = new http.MultipartRequest('PUT', uri);

      var stream = new http.ByteStream(filePath.openRead());
      //*👇 get file length
      var length = await filePath.length(); //* <-- imageFile is your image file

      //!👇 Headers Map Currently Not Used
      //    Map<String, String> headers = {
      //   "Accept": "application/json",
      //   "Authorization": "Bearer " + token
      // }; // ignore this headers if there is no authentication

      //*👇 multipart that takes file
      var multipartFileSign = new http.MultipartFile("image", stream, length,
          filename: basename(filePath.path.split("/").last));
      //*👇 add file to multipart
      request.files.add(multipartFileSign);

      //!👇 headers addAll Currently Not Used
      //*add headers
      // request.headers.addAll(headers);

      //!👇 Adding params fields Currently Not Used
      //* adding params
      // request.fields['loginId'] = '12';
      // request.fields['firstName'] = 'abc';
      // // request.fields['lastName'] = 'efg';

      //*👇 Send
      var streamedResponse = await request.send();

      if (kDebugMode) {
        logger.i(streamedResponse.statusCode);
        logger.i(streamedResponse.toString());
      }
      final response = await http.Response.fromStream(streamedResponse);

      //!👇 streamedResponse Currently Not Used
      //*👇 listen for response
      /*-
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        print('value');
        // print(value);
        print("Response Data This 👉 ${value.toString()}");
      });

      */

      responseJson =
          returnResponse(response); //* <-- returnResponse Finction call
    } on SocketException {
      throw FetchDataException('No Internet Conncetion');
    }

    return responseJson;
  }

  @override
  Future existingPostSingleNewImageUploadRespons(
      String url, File filePath) async {
    // TODO: implement imageUpdateRespons

    logger.i("Url This  👉 $url");
    logger.i("File Path This  👉 $filePath");

    dynamic responseJson;
    try {
      //*👇 string to uri
      var uri = Uri.parse(url);
      http.MultipartRequest request = new http.MultipartRequest('POST', uri);

      var stream = new http.ByteStream(filePath.openRead());
      //*👇 get file length
      var length = await filePath.length(); //* <-- imageFile is your image file

      //!👇 Headers Map Currently Not Used
      //    Map<String, String> headers = {
      //   "Accept": "application/json",
      //   "Authorization": "Bearer " + token
      // }; // ignore this headers if there is no authentication

      //*👇 multipart that takes file
      var multipartFileSign = new http.MultipartFile("image", stream, length,
          filename: basename(filePath.path.split("/").last));
      //*👇 add file to multipart
      request.files.add(multipartFileSign);

      //!👇 headers addAll Currently Not Used
      //*add headers
      // request.headers.addAll(headers);

      //!👇 Adding params fields Currently Not Used
      //* adding params
      // request.fields['loginId'] = '12';
      // request.fields['firstName'] = 'abc';
      // // request.fields['lastName'] = 'efg';

      //*👇 Send
      var streamedResponse = await request.send();

      if (kDebugMode) {
        logger.i(streamedResponse.statusCode);
        logger.i(streamedResponse.toString());
      }
      final response = await http.Response.fromStream(streamedResponse);

      //!👇 streamedResponse Currently Not Used
      //*👇 listen for response
      /*-
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        print('value');
        // print(value);
        print("Response Data This 👉 ${value.toString()}");
      });

      */

      responseJson =
          returnResponse(response); //* <-- returnResponse Finction call
    } on SocketException {
      throw FetchDataException('No Internet Conncetion');
    }

    return responseJson;
  }

  @override
  Future deleteApiRespons(String Url) async {
    // TODO: implement getGetApiRespons
    log(Url);
    dynamic responseJson;
    try {
      final response =
          await http.delete(Uri.parse(Url)).timeout(Duration(seconds: 60));

      responseJson =
          returnResponse(response); //* <-- returnResponse Finction call
      print(responseJson);
    } on SocketException {
      throw FetchDataException(
          'No Internet Conncetion'); //* <-- FetchDataException class call
    }
    return responseJson;
  }

// TODO returnResponse Function Create
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(ErrorModel.fromJson(
            jsonDecode(response.body))); //* <-- BadRequestException class Call
      case 500:
        throw InternalServerErrorException(ErrorModel.fromJson(jsonDecode(
            response.body))); //* <-- InternalServerErrorException class Call
      case 404:
        throw UnauthorisedException(ErrorModel.fromJson(jsonDecode(
            response.body))); //* <-- UnauthorisedException class Call
      case 422:
        throw UnprocessableContentException(ErrorModel.fromJson(jsonDecode(
            response.body))); //* <-- UnauthorisedException class Call
      default:
        throw FetchDataException(
            ' Error accured white communicating with server ' + //* <-- FetchDataException  class Call
                'with status code' +
                response.statusCode.toString());
    }
  }
}
