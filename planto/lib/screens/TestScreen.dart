import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planto/Model/diseaseProvider.dart';
import 'package:planto/screens/diseaseData.dart';
import 'package:planto/widgets/planto_bar.dart';
import 'package:planto/widgets/recent_Carousel.dart';
import 'package:tflite/tflite.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var _isLoading = false;
  var _isInit = true;

  PickedFile _image;
  List _output;
  final _picker = ImagePicker();

  @override
  void initState() {
    // implement initState
    super.initState();
    _isLoading = true;
    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      labels: "assets/labels.txt",
      model: "assets/model_unquant.tflite",
    );
  }

  chooseImage() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _isLoading = true;
      _image = image;
    });
    runModelOnImage(image);
  }

  runModelOnImage(PickedFile image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 15,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5);
    setState(() {
      _isLoading = false;
      _output = output;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Disease>(context).findRecentSearch().then((_) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Color elevatedBtnColor = HexColor('70EE9C');
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    final diseaseData = Provider.of<Disease>(context);

    return FutureBuilder<FirebaseApp>(
      // Initialize FlutterFire:
      future: _initialization,
      // ignore: missing_return
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: CircularProgressIndicator());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60), child: PlantoBar()),
          body: _isLoading
              ? Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                )
              : Container(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*  Container(
                        alignment: Alignment.center,
                        child:  */
                      _image == null || _isLoading
                          ? RecentCarousel(diseaseData: diseaseData)
                          : Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Card(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(File(_image.path)),
                                ),
                              ),
                              //),
                            ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: _output == null
                            ? Text("")
                            : Column(
                                children: [
                                  Text(
                                    "${_output[0]["label"]}",
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: elevatedBtnColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            DiseaseData(
                                          value: "${_output[0]["label"]}",
                                          img: File(_image.path),
                                        ),
                                        transitionsBuilder: (context, animation,
                                                secondaryAnimation, child) =>
                                            ScaleTransition(
                                          scale: animation,
                                          child: child,
                                          alignment: Alignment.bottomCenter,
                                        ),
                                      ));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.13,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Info',
                                            style: TextStyle(
                                                color: HexColor('145E2E'),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
                                              color: HexColor('145E2E'))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            label: Text(
              'Test Sample',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            foregroundColor: HexColor('145E2E'),
            backgroundColor: HexColor('70EE9C'),
            icon: Icon(Icons.local_florist),
            onPressed: () {
              chooseImage();
            },
          ),
        );
      },
    );
  }
}
