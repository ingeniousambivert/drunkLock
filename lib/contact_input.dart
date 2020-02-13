import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:toast/toast.dart';

class ContactImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactImageInput();
  }
}

class _ContactImageInput extends State<ContactImageInput> {
  // To store the file provided by the image_picker
  File _imageFile;

  // To track the file uploading state
  bool _isUploading = false;

  String baseUrl = 'http://192.168.1.225/contactUpload';

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = image;
    });

    // Closes the bottom sheet
    Navigator.pop(context);
  }

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    setState(() {
      _isUploading = true;
    });

    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
    lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    // Initialize the multipart request
    final imageUploadRequest =
    http.MultipartRequest('POST', Uri.parse(baseUrl));

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('image', image.path,
                                                       contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpg
    // Which creates some problem at the server side to manage
    // or verify the file extension

    imageUploadRequest.fields['ext'] = mimeTypeData[1];

    imageUploadRequest.files.add(file);

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        return null;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      _resetState();

      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Test request
  Future<http.Response> makeRequest() {
    final getResponse = http.get(baseUrl);
    print(getResponse);
    // Check if any error occured
    if (getResponse == null) {
      Toast.show("GET Request failed !", context,
                     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("GET Request successful !", context,
                     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    return getResponse;
  }

  void _startUploading() async {
    final Map<String, dynamic> response = await _uploadImage(_imageFile);
    print(response);
    // Check if any error occured
    if (response == null || response.containsKey("error")) {
      Toast.show("Image upload failed !", context,
                     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Image upload successful !", context,
                     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _resetState() {
    setState(() {
      _isUploading = false;
      _imageFile = null;
    });
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
          color: Colors.pinkAccent[700],
          textColor: Colors.white,
          ),
        );
    }
    return btnWidget;
  }
  Widget _buildFinishBtn() {
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
          child: Text('Finish'),
          onPressed: () {
            Toast.show("Registeration Complete", context,
                           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          },
          color: Colors.pinkAccent[700],
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
        child : Column(
          mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            ),
          Text(
            'Security Contact Info',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
            ),
          Padding(
            padding:  const EdgeInsets.only(bottom: 10.0),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              color: Colors.grey[900],
              elevation: 3.0,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: Icon(Icons.person_outline, color: Colors.white),
                    ),
                  contentPadding: EdgeInsets.all(18),
                  labelText: "Firstname", labelStyle: TextStyle(
                  color: Colors.white60,

                  ),),
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              color: Colors.grey[900],
              elevation: 3.0,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: Icon(Icons.person_outline, color: Colors.white),
                    ),
                  contentPadding: EdgeInsets.all(18),
                  labelText: "Lastname", labelStyle: TextStyle(
                  color: Colors.white60,

                  ),),
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              color: Colors.grey[900],
              elevation: 3.0,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: Icon(Icons.local_phone, color: Colors.white),
                    ),
                  contentPadding: EdgeInsets.all(18),
                  labelText: "Phone number", labelStyle: TextStyle(
                  color: Colors.white60,

                  ),),
                ),
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
          _buildFinishBtn()
        ],
        ),
          ),
        ),
      );
  }
}
