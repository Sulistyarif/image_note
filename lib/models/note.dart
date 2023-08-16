import 'package:file_picker/file_picker.dart';

class Note {
  int? index;
  String? title;
  String? description;
  List<PlatformFile>? imageList;
  bool? isDone;

  Note({this.index, this.title, this.description, this.imageList, this.isDone});
}
