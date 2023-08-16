import 'dart:developer' as dev;
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:image_note/models/note.dart';

import '../controller/note_controller.dart';

class DialogAddNewNote extends StatefulWidget {
  const DialogAddNewNote({super.key});

  @override
  State<DialogAddNewNote> createState() => _DialogAddNewNoteState();
}

class _DialogAddNewNoteState extends State<DialogAddNewNote> {
  TextEditingController controllerTitle = TextEditingController(text: '');
  TextEditingController controllerDescription = TextEditingController(text: '');
  late DropzoneViewController controllerDropzone;
  bool isHoverItem = false;
  List<PlatformFile> imageList = [];
  dynamic argumentData = Get.arguments;
  final noteController = Get.find<NoteController>();

  @override
  void initState() {
    if (argumentData != null) {
      imageList.add(argumentData as PlatformFile);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.8,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.edit_note_rounded,
                    size: 40,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Note',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Drag and drop an image or paste it from your clipboard.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.clear,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Images',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Container(
              decoration: BoxDecoration(
                color: isHoverItem ? Colors.green[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              height: 200,
              child: Stack(
                children: [
                  DropzoneView(
                    operation: DragOperation.copy,
                    cursor: CursorType.grab,
                    onCreated: (DropzoneViewController ctrl) =>
                        controllerDropzone = ctrl,
                    onError: (String? ev) => dev.log('Error: $ev'),
                    onHover: () {
                      setState(() {
                        isHoverItem = true;
                      });
                    },
                    onDrop: (dynamic ev) async {
                      imageList.add(PlatformFile(
                        name: await controllerDropzone.getFilename(ev),
                        size: await controllerDropzone.getFileSize(ev),
                        path: await controllerDropzone.createFileUrl(ev),
                        bytes: await controllerDropzone.getFileData(ev),
                      ));
                      setState(() {});
                    },
                    onLeave: () {
                      setState(() {
                        isHoverItem = false;
                      });
                    },
                  ),
                  const Center(
                    child: Text(
                      'Drop your image here',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.memory(
                                imageList[index].bytes!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        itemCount: imageList.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Masukkan judul",
                fillColor: Colors.white70,
              ),
              controller: controllerTitle,
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Masukkan deskripsi",
                fillColor: Colors.white70,
              ),
              minLines: 5,
              maxLines: 12,
              controller: controllerDescription,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var rnd = Random();
                int randomNumber = rnd.nextInt(100);
                noteController.noteList.add(Note(
                  index: randomNumber,
                  description: controllerDescription.text,
                  imageList: imageList,
                  isDone: false,
                  title: controllerTitle.text,
                ));
                Get.back();
              },
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
