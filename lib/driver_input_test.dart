import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:toast/toast.dart';

class DriverImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DriverImageInput();
  }
}

class _DriverImageInput extends State<DriverImageInput> {

  File _imageFile;
  bool _isUploading = false;

  String baseUrl = 'http://192.168.1.220:8000/driverUpload';

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = image;
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }



  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                SizedBox(
                  height: 10.0,
                  ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text(
                    'Use Camera',
                    style: TextStyle(color: Colors.black),
                    ),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                  ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text(
                    'Use Gallery',
                    style: TextStyle(color: Colors.black),
                    ),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                  ),
              ],
              ),
            );
        });
  }

  void _startUploading() async {

    String fileName = _imageFile.path.split('/').last;
    Dio dio = new Dio();
    FormData data = FormData.fromMap({
                                       "file": await MultipartFile.fromFile(
                                         _imageFile.path,
                                         filename: fileName,
                                         ),
                                     });

    dio.post(baseUrl, data: data)
        .then((response) =>  Toast.show("Image upload successful", context,
                                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM))
        .catchError((error) =>  Toast.show("Image upload failed", context,
                                               duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  Widget _buildUploadBtn() {
    Widget btnWidget = Container();

    if (_isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else if (!_isUploading && _imageFile != null) {
      // If image is picked by the user then show a upload btn

      btnWidget = Container(
        margin: EdgeInsets.only(top: 10.0),
        child: RaisedButton(
          child: Text('Upload'),
          onPressed: () {
            //makeRequest();
            _startUploading();
          },
          color: Colors.blueAccent,
          textColor: Colors.white,
          ),
        );
    }
    return btnWidget;
  }
  Widget _buildNextBtn() {
    Widget btnWidget = Container();

    if (_isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else if (!_isUploading && _imageFile != null) {
      // If image is picked by the user then show a upload btn
      btnWidget = Container(
        margin: EdgeInsets.only(top: 10.0),
        child: RaisedButton(
          child: Text('Next'),
          onPressed: () {
            Navigator.pushNamed(context, '/contactInput');
          },
          color: Colors.blueAccent,
          textColor: Colors.white,
          ),
        );
    }
    return btnWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Drunk Lock',
            style: TextStyle(color: Colors.white),
            ),
          ),
        body: Center(
          child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  ),Text(
                  'Driver Info',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
                  ),
                Padding(
                  padding:  const EdgeInsets.only(bottom: 10.0),
                  ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      decorationColor: Colors.black,
                      fontWeight: FontWeight.w300,
                      ),
                    decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xFFf7d426),width:2)),
                        contentPadding: EdgeInsets.all(18),
                        labelText: "Firstname"),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      decorationColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      ),
                    decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xFFf7d426),width:2)),
                        contentPadding: EdgeInsets.all(18),
                        labelText: "Lastname"),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  ),
                _imageFile == null
                    ? Text('Please pick an image of your face')
                    : Image.file(
                  _imageFile,
                  fit: BoxFit.cover,
                  height: 300.0,
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width,
                  ),
                Padding(
                    padding:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: SizedBox(
                      width: 250,
                      child: OutlineButton(
                        onPressed: () => _openImagePickerModal(context),
                        borderSide: BorderSide(color: Color(0xFFf7d426), width: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              ),
                            Icon(Icons.camera_alt),
                            SizedBox(
                              width: 5.0,
                              ),
                            Text('Add Image'),
                          ],
                          ),
                        ),
                      )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  ),
                _buildUploadBtn(),
                _buildNextBtn()
              ],
              ),
            ),
          )
        );
  }
}
