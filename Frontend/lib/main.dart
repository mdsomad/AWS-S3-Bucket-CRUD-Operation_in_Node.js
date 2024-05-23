import 'package:flutter/material.dart';
import 'package:flutter_application/Provider/Post/update_provider.dart';
import 'package:flutter_application/Provider/home/home_provider.dart';
import 'package:flutter_application/Screen/HomePage.dart';
import 'package:provider/provider.dart';

import 'Provider/Post/existing_post_single_new_Image_upload_provider.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //* <-- Yah Method Sa MultiProvider Use Kar Sakte hai
          ChangeNotifierProvider<HomePageProvider>(
            create: (context) => HomePageProvider(),
          ),
          ChangeNotifierProvider<PostPageProvider>(
            create: (context) => PostPageProvider(),
          ),
          ChangeNotifierProvider<ExistingPostSingleNewImageUploadProvider>(
            create: (context) => ExistingPostSingleNewImageUploadProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
            useMaterial3: false,
          ),
          home: HomePage(),
        ));
  }
}
