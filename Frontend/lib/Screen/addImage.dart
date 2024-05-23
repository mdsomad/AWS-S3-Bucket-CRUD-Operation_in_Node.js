import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/API_Url/api_url.dart';
import 'package:flutter_application/Provider/home/home_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class AddImagetScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddImagetScreen({super.key});

  @override
  State<AddImagetScreen> createState() => _AddImagetScreenState();
}

class _AddImagetScreenState extends State<AddImagetScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productQuantityController =
      TextEditingController();

  List<File> _images = [];
  File? filepath;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      filepath = File(pickedFile.path);
      setState(() {
        _images.add(File(pickedFile.path));
        // _images.add(pickedFile.path as File);
      });
    }
  }

  Future<Future<bool?>?> uploadImage2() async {
    if (_images.length > 0) {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            ApiUrl.imagePostEndPint,
          ));
      print(Uri.parse(
        ApiUrl.imagePostEndPint,
      ));
      for (var i = 0; i < _images.length; i++) {
        print(_images.length);

        request.files.add(http.MultipartFile.fromBytes(
            'images', File(_images[i].path).readAsBytesSync(),
            filename: _images[i].path.split("/").last));
      }

      var res = await request.send();
      var responseData = await res.stream.toBytes();
      var result = String.fromCharCodes(responseData);
      // print(_images[i].path);
      log(result + " Uploaded Successfully");

      // _submitedSuccessfully(context);
    } else {
      log("Please Select atleast one image");
      // return Fluttertoast.showToast(
      //     msg: "Please Select atleast one image",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
    }
  }

//!-----------------------------------------------------------------------

  Future uploadImageToServer(BuildContext context) async {
    try {
      setState(() {
        // showSpinner = true ;
      });

      var uri = Uri.parse(ApiUrl.imagePostEndPint);
      http.MultipartRequest request = new http.MultipartRequest('POST', uri);

      List<http.MultipartFile> newList = [];

      for (int i = 0; i < _images.length; i++) {
        File imageFile = File(_images[i].path);

        var stream = new http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();

        var multipartFile = new http.MultipartFile("images", stream, length,
            filename: basename(imageFile.path));
        newList.add(multipartFile);
      }

      request.files.addAll(newList);
      var response = await request.send();
      print(response.toString());

      response.stream.transform(utf8.decoder).listen((value) {
        print('value');
        print(value);
      });

      if (response.statusCode == 201) {
        setState(() {
          // showSpinner = false;
        });

        print('uploaded');
      } else {
        setState(() {
          // showSpinner = false;
        });
        print('failed');
      }
    } catch (e) {
      setState(() {
        // showSpinner = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
            title: Text(
              "Post Upload Screen",
              style: TextStyle(color: Colors.black),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Form(
            child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              _images.length == 0
                  ? GestureDetector(
                      onTap: _getImage,
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
                                'You can select upto 6 images',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 300,
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _images.length + 1,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemBuilder: (context, index) {
                          if (index == _images.length) {
                            if (_images.length == 6) {
                              return SizedBox();
                            } else {
                              return GestureDetector(
                                onTap: _getImage,
                                child: Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.add),
                                ),
                              );
                            }
                          } else {
                            return GestureDetector(
                              onTap: () {
                                _viewImageInDialog(_images[index], index,
                                    context); //* <-- _viewImageInDialog Widget call
                              },
                              child: Stack(
                                children: [
                                  Hero(
                                    tag: 'imageHero$index',
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Image.file(
                                        _images[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _images.remove(_images[index]);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                  onTap: () {
                    print(_images.length);

                    final homePageProvider =
                        Provider.of<HomePageProvider>(context, listen: false);
                    homePageProvider.imageUplad(_images, context);

                    // uploadImage2();
                    // uploadImageToServer(context);
                    //  AdminController().sellProduct

                    //  (
                    //   context: context,
                    //   name: 'MacbookPro', description: 'Des',
                    //   price: 20000,
                    //   quantity: 232,
                    //   category: 'adada',
                    //   images: _images,

                    //  );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 2 - 70,
                        vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text("Uplaod Image"),
                  )),
            ],
          ),
        )),
      ),
    );
  }

//TODO: Create _viewImageInDialog
  void _viewImageInDialog(File imageFile, int index, BuildContext context) {
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
                tag: 'imageHero$index',
                child: Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}













































//*BackUp Code

// import 'dart:io';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class AddImagetScreen extends StatefulWidget {
//   static const String routeName = '/add-product';
//   const AddImagetScreen({super.key});

//   @override
//   State<AddImagetScreen> createState() => _AddImagetScreenState();
// }

// class _AddImagetScreenState extends State<AddImagetScreen> {
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController productDescriptionController =
//       TextEditingController();
//   final TextEditingController productPriceController = TextEditingController();
//   final TextEditingController productQuantityController =
//       TextEditingController();

//   String category = 'Computer';
//   List<String> productCat = [
//     'Mobiles',
//     'Clothes',
//     'Computer',
//     'Makeup',
//     'Audio',
//     'Printers',
//     'Toys',
//     'Electronics'
//   ];

//   List<File> _images = [];

//   Future<void> _getImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _images.add(File(pickedFile.path));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(50),
//         child: AppBar(
//             title: Text(
//               "Add Product",
//               style: TextStyle(color: Colors.black),
//             ),
//             flexibleSpace: Container(
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent,
//               ),
//             )),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//             child: Padding(
//           padding: const EdgeInsets.all(14.0),
//           child: Column(
//             children: [
//               _images.length == 0
//                   ? GestureDetector(
//                       onTap: _getImage,
//                       child: DottedBorder(
//                         borderType: BorderType.RRect,
//                         radius: const Radius.circular(10),
//                         dashPattern: const [10, 4],
//                         strokeCap: StrokeCap.round,
//                         child: Container(
//                           width: double.infinity,
//                           height: 150,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.folder_open,
//                                 size: 40,
//                               ),
//                               const SizedBox(height: 15),
//                               Text(
//                                 'Select Upload Images',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.grey.shade400,
//                                 ),
//                               ),
//                               Text(
//                                 'You can select upto 6 images',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey.shade400,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   : SizedBox(
//                       height: 300,
//                       child: GridView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: _images.length + 1,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 4.0,
//                           mainAxisSpacing: 4.0,
//                         ),
//                         itemBuilder: (context, index) {
//                           if (index == _images.length) {
//                             if (_images.length == 6) {
//                               return SizedBox();
//                             } else {
//                               return GestureDetector(
//                                 onTap: _getImage,
//                                 child: Container(
//                                   color: Colors.grey[200],
//                                   child: Icon(Icons.add),
//                                 ),
//                               );
//                             }
//                           } else {
//                             return GestureDetector(
//                               onTap: () {
//                                 _viewImageInDialog(_images[index],
//                                     index); //* <-- _viewImageInDialog Widget call
//                               },
//                               child: Stack(
//                                 children: [
//                                   Hero(
//                                     tag: 'imageHero$index',
//                                     child: Container(
//                                       width: double.infinity,
//                                       height: double.infinity,
//                                       child: Image.file(
//                                         _images[index],
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     child: InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           _images.remove(_images[index]);
//                                         });
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.only(
//                                             bottomRight: Radius.circular(20.0),
//                                           ),
//                                         ),
//                                         child: Icon(
//                                           Icons.close,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     ),
//               SizedBox(
//                 height: 30,
//               ),
//               TextFormField(
//                 controller: productNameController,
//                 keyboardType: TextInputType.name,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Enter a product name.';
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   focusedErrorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.red)),
//                   errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.red)),
//                   hintText: "Product Name",
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextFormField(
//                 controller: productDescriptionController,
//                 keyboardType: TextInputType.text,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Enter a product description.';
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   focusedErrorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.red)),
//                   errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.red)),
//                   hintText: "Product Description",
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextFormField(
//                 controller: productPriceController,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Enter a product price.';
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   focusedErrorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.red)),
//                   errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.red)),
//                   hintText: "Product Price (in Rs.)",
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextFormField(
//                 controller: productQuantityController,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Enter a product price.';
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   focusedErrorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.red)),
//                   errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.red)),
//                   hintText: "Product Quantity",
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: DropdownButton(
//                     value: category,
//                     items: productCat.map((String item) {
//                       return DropdownMenuItem(
//                         child: Text(item),
//                         value: item,
//                       );
//                     }).toList(),
//                     onChanged: (String? newVal) {
//                       setState(() {
//                         category = newVal!;
//                       });
//                     }),
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               InkWell(
//                   onTap: () {
//                     print(_images.length);
//                     //  AdminController().sellProduct

//                     //  (
//                     //   context: context,
//                     //   name: 'MacbookPro', description: 'Des',
//                     //   price: 20000,
//                     //   quantity: 232,
//                     //   category: 'adada',
//                     //   images: _images,

//                     //  );
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width / 2 - 70,
//                         vertical: 20),
//                     decoration: BoxDecoration(color: Colors.amberAccent),
//                     child: const Text("Add Product"),
//                   )),
//             ],
//           ),
//         )),
//       ),
//     );
//   }

// //TODO: Create _viewImageInDialog
//   void _viewImageInDialog(File imageFile, int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: Container(
//               width: double.infinity,
//               height: double.infinity,
//               child: Hero(
//                 tag: 'imageHero$index',
//                 child: Image.file(
//                   imageFile,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
