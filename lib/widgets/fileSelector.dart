import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:test_flutter_app/services/cloudStorageService.dart';
import 'package:test_flutter_app/widgets/simpleButton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

typedef void ImageCallback(File image);

class FileSelector extends StatelessWidget {
  final ImageCallback onImageSelected;
  FileSelector({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SimpleButton(
          onPressedFunction: () async => {
            selectImage()
          }, buttonLabel: "Select image"),
    );
  }

  // void selectImage() async {
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  // }
  void selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File? file;

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    if(file != null){
      log(file.absolute.path);
      onImageSelected(file);
      // await CloudStorageService.putPropertyImage(file, Uuid().v4());
    }
  }

  // void selectImage() async {
  //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //   final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  //   String? _fileName;
  //   String? _saveAsFileName;
  //   List<PlatformFile>? _paths;
  //   String? _directoryPath;
  //   String? _extension;
  //   bool _isLoading = false;
  //   bool _userAborted = false;
  //   bool _multiPick = false;
  //   FileType _pickingType = FileType.any;
  //   TextEditingController _controller = TextEditingController();
  //   try {
  //     _paths = (await FilePicker.platform.pickFiles(
  //       type: _pickingType,
  //       allowMultiple: _multiPick,
  //       onFileLoading: (FilePickerStatus status) => print(status),
  //       allowedExtensions: (_extension?.isNotEmpty ?? false)
  //           ? _extension?.replaceAll(' ', '').split(',')
  //           : null,
  //     ))
  //         ?.files;
  //   } on PlatformException catch (e) {
  //     log('Unsupported operation' + e.toString());
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }
}
