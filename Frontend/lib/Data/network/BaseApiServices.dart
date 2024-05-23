//TODOclass abstract Create
import 'dart:io';

abstract class BaseAPIServices {
  //* <-- Link this calss NetworkApiServices
  Future<dynamic> getGetApiRespons(String url);
  Future<dynamic> getPostApiRespons(
    String url,
    List<File> file,
  );
  Future<dynamic> imageUpdateRespons(
    String url,
    File filePath,
  );

  Future<dynamic> existingPostSingleNewImageUploadRespons(
    String url,
    File filePath,
  );
  Future<dynamic> deleteApiRespons(String url);
  // Future<dynamic> singleImageDeleteApiRespons(String url);

  // Future<dynamic> getGetBearerApiRespons(String url,String Token);
}
