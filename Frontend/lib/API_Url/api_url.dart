class ApiUrl {
  static var BASE_URL = "http://10.0.2.2:3001/";
  static var GetAllPostEndPint = BASE_URL + "getPosts";
  static var imagePostEndPint = BASE_URL + "multipleUpload";
  static var imageUpdateEndPint = BASE_URL + "singleImageUpdate";

  static var deletePostEndPint = BASE_URL + "deletePost";
  static var singleImageDeleteEndPint = BASE_URL + "singleImageDelete";
  static var existingPostSingleNewImageUploadEndPint =
      BASE_URL + "existingPostSingleNewImageUpload";
}
