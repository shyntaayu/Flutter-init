// Flutter code sample for material.BottomNavigationBar.1

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'models/post.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  final Future<ImageResponse> post;

  MyApp({Key key, this.post}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  File _image;
  var alist;

  List listA = List();
  String a, type;
  var isLoading = false;

  Response response;

  Future<void> fetchPost(image) async {
    String username = 'apikey';
    String password = 'R4lK6W9XkqMK3IXA-HSJMbrF4x70S2ByS6lig4EdFv6O';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);
    var url =
        'https://gateway.watsonplatform.net/visual-recognition/api/v3/classify?version=2018-03-19';
    // var requestBody = '{"images_file": ' + image + '}';
    var bytes = utf8.encode("$username:$password");
    var credentials = base64.encode(bytes);
    var headers = {"Authorization": "Basic $credentials"};

    Dio dio = new Dio();
    FormData formdata = new FormData(); // just like JS
    formdata.add(
        "images_file", new UploadFileInfo(image, basename(image.path)));
    // try {
    setState(() {
      isLoading = true;
    });
    response = await dio.post(url,
        data: formdata,
        options:
            Options(method: 'POST', headers: headers // or ResponseType.JSON
                ));
    print(response.statusCode);
    print(response);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.toString());
      ImageResponse imageResponse = new ImageResponse.fromJson(jsonResponse);
      print(imageResponse.images[0].classifiers[0].classes.toString());
      List<ImageResponse> list;
      // List<Classes> list = (imageResponse.images[0].classifiers[0].classes);
      // list = (json.decode(response.data) as List)
      //     .map((data) => new Classes.fromJson(data))
      //     .toList();
      // list = (json.decode(response.data) as List)
      //     .map((data) => new ImageResponse.fromJson(data))
      //     .toList();
      // print(list);
      List<Map<String, dynamic>> c =
          imageResponse.images[0].classifiers[0].classes
              .map((something) => {
                    "class": something.classa,
                    "score": something.score,
                  })
              .toList();
      listA = c;
      setState(() {
        listA = c;
        isLoading = false;
      });
      return list;
    } else {
      throw Exception("Error");
    }
    // print(response["images"]["classifiers"]["classess"]);
    // print(ImageResponse.fromJson(response.data));
    // print(list);
    // return ImageResponse.fromJson(response.data);
    // } catch (error, stacktrace) {
    //   print("Exception occured: $error stackTrace: $stacktrace");
    //   throw Exception('Failed to load post');
    // }
  }

  static List<Classes> parseClasses(String responseBody) {
    final jsonResponse = json.decode(responseBody.toString());
    List<Classes> imagesList =
        jsonResponse.map((i) => Classes.fromJson(i)).toList();
    return imagesList;
  }

  Future<String> loadImagesFromAsset() async {
    return await rootBundle.loadString('jsons/post.json');
  }

  Future loadImages() async {
    setState(() {
      isLoading = true;
    });
    String jsonString = await loadImagesFromAsset();
    final jsonResponse = json.decode(jsonString);
    ImageResponse imageResponse = new ImageResponse.fromJson(jsonResponse);
// print(imageResponse["images"]["classifiers"]["classess"]);
    List<Classes> list = (imageResponse.images[0].classifiers[0].classes);
    // print(list[0].score);
    // print('IP: ${imageResponse.images[0].classifiers[0].classes}');
    List<Map<String, dynamic>> c =
        imageResponse.images[0].classifiers[0].classes
            .map((something) => {
                  "class": something.classa,
                  "score": something.score,
                })
            .toList();
    listA = c;
    print(c);
    print(listA);
    print(jsonResponse);
    a = c[0].toString();
    type = c[1].toString();
    setState(() {
      listA = c;
      alist = jsonResponse;
      isLoading = false;
    });
  }

  Future getCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    fetchPost(_image);
  }

  Future getGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = image;
    });
    fetchPost(_image);
  }

  void _onItemTapped(int index) {
    // loadImages();
    print(index);
    print("UPIL yjhfbcbfjvbjbfjgbv");
    if (index == 0) {
      getCamera();
    } else if (index == 1) {
      getGallery();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('V2Text'),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
              child: Expanded(
            child: _image == null
                ? new Text('No image selected')
                : new Image.file(_image),
          )),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : new Container(
                  child: Expanded(
                      child: ListView.builder(
                    itemCount: listA.length,
                    itemBuilder: (BuildContext ctxt, int index) => Card(
                          child: ListTile(
                            leading: FlutterLogo(size: 40.0),
                            title: Text(listA[index]['class']),
                            subtitle: Text(
                                (listA[index]['score'] * 100).toString() +
                                    " %"),
                            trailing: Icon(Icons.more_vert),
                          ),
                        ),
                  )),
                ),
        ],
      )),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            title: Text('Camera'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_in_picture_alt),
            title: Text('Gallery'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: RaisedButton(
      //     child: new Text("Fetch Data"),
      //     onPressed: loadImages,
      //   ),
      // ),
    );
  }
}
