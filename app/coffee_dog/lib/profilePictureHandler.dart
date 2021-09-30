import 'package:coffee_dog/repo/repo.dart';
import 'package:coffee_dog/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePicPicker extends StatefulWidget {
  final Repo repo;
  ProfilePicPicker({required this.repo});

  @override
  _ProfilePicPickerState createState() => _ProfilePicPickerState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ProfilePicPickerState extends State<ProfilePicPicker> {
  AppState state = AppState.free;
  ImagePicker imgPicker = ImagePicker();
  XFile? profImage;
  File? croppedProf;
  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localPic async {
    final path = await _localPath;
    return File('$path/img/proffDog.png');
  }

  _setProfilePic() async {
    if (croppedProf != null) {
      // open a bytestream
      var stream = new http.ByteStream(croppedProf!.openRead());
      stream.cast();
      // get file length
      var length = await croppedProf!.length();

      // string to uri
      var uri = Uri.parse("http://ip:8082/composer/predict");

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(croppedProf!.path));

      // add file to multipart
      request.files.add(multipartFile);

      // send
      var response = await request.send();
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
    setState(() {
      state = AppState.free;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Velg proilbilde"),
      ),
      body: Center(
        child: Container(), // imageFile != null ? Image.file(imageFile!) :
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SECONDARY_COLOR,
        onPressed: () {
          if (state == AppState.free)
            _pickImage();
          else if (state == AppState.picked)
            _cropImage();
          else if (state == AppState.cropped) _setProfilePic();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  _pickImage() async {
    profImage = await imgPicker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    croppedProf = await ImageCropper.cropImage(
        sourcePath: profImage!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedProf != null) {
      // imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }
}
