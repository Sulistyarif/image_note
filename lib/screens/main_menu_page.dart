import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_note/controller/note_controller.dart';
import 'package:image_note/widgets/dialog_add_new_note.dart';
import 'package:image_note/widgets/item_note.dart';
import 'package:pasteboard/pasteboard.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  List<PlatformFile> imageList = [];
  List<LogicalKeyboardKey> keys = [];
  late DropzoneViewController controllerDropzone;
  bool isHoverItem = false;
  PlatformFile? imageTest;
  final noteController = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) => RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) async {
          final key = event.logicalKey;
          if (event is RawKeyDownEvent) {
            if (keys.contains(key)) return;

            setState(() {
              keys.add(key);
            });

            if (keys.contains(LogicalKeyboardKey.controlLeft) &&
                keys.contains(LogicalKeyboardKey.keyV)) {
              log('paste key windows left called');
              onPasteImage();
            }
            if (keys.contains(LogicalKeyboardKey.controlRight) &&
                keys.contains(LogicalKeyboardKey.keyV)) {
              log('paste key windows right called');
              onPasteImage();
            }
            if (keys.contains(LogicalKeyboardKey.metaLeft) &&
                keys.contains(LogicalKeyboardKey.keyV)) {
              log('paste key mac left called');
              onPasteImage();
            }
            if (keys.contains(LogicalKeyboardKey.metaRight) &&
                keys.contains(LogicalKeyboardKey.keyV)) {
              log('paste key mac right called');
              onPasteImage();
            }
          } else {
            setState(() {
              keys.remove(key);
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.lightBlue[50],
          body: Stack(
            children: [
              DropzoneView(
                operation: DragOperation.copy,
                cursor: CursorType.grab,
                onCreated: (DropzoneViewController ctrl) =>
                    controllerDropzone = ctrl,
                onError: (String? ev) => log('Error: $ev'),
                onHover: () {
                  setState(() {
                    isHoverItem = true;
                  });
                },
                onDrop: (dynamic ev) async {
                  var imageDropped = PlatformFile(
                    name: await controllerDropzone.getFilename(ev),
                    size: await controllerDropzone.getFileSize(ev),
                    path: await controllerDropzone.createFileUrl(ev),
                    bytes: await controllerDropzone.getFileData(ev),
                  );
                  setState(() {
                    isHoverItem = false;
                  });
                  Get.dialog(
                    const DialogAddNewNote(),
                    arguments: imageDropped,
                  );
                },
                onLeave: () {
                  setState(() {
                    isHoverItem = false;
                  });
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(
                      child: imageTest != null
                          ? Image.memory(
                              imageTest!.bytes!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(),
                    ),
                    Text(
                      'Image Note',
                      style: GoogleFonts.getFont('Pacifico', fontSize: 50),
                    ),
                    Text(
                      'note your image easyly',
                      style: GoogleFonts.getFont('Varela',
                          fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return ItemNote(
                                item: noteController.noteList[index]);
                          },
                          itemCount: noteController.noteList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                child: isHoverItem
                    ? Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.amber[50]!.withOpacity(0.8),
                        ),
                        child: Center(
                          child: Text(
                            'Drop Your Image Here',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 40,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );

  void onPasteImage() async {
    final imageBytes = await Pasteboard.image;
    var imageFile = PlatformFile(
      name: 'clipboard',
      size: imageBytes?.length ?? 0,
      bytes: await Pasteboard.image,
    );
    Get.dialog(
      const DialogAddNewNote(),
      arguments: imageFile,
    );
    /* setState(() {
      imageTest = imageFile;
    }); */
  }
}
