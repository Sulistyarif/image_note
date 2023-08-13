import 'package:file_picker/file_picker.dart';

class Note {
  String? title;
  String? description;
  List<PlatformFile>? imageList;
  bool? isDone;

  Note({this.title, this.description, this.imageList, this.isDone});
}
