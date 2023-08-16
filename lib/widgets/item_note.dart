import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_note/controller/note_controller.dart';

import '../models/note.dart';

class ItemNote extends StatefulWidget {
  final Note item;
  const ItemNote({super.key, required this.item});

  @override
  State<ItemNote> createState() => _ItemNoteState();
}

class _ItemNoteState extends State<ItemNote> {
  final noteController = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.memory(
              widget.item.imageList![0].bytes!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.item.title ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  widget.item.description ?? '-',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              noteController.noteList.remove(widget.item);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
