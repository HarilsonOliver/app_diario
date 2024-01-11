import 'package:app_diario/models/note.dart';
import 'package:app_diario/repository/notes_repository.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  void initState(){
    if(widget.note != null){
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Anotação'),
        actions: [
          widget.note != null? IconButton(
            onPressed: () {
              showDialog(context: context, builder: (context) => AlertDialog(
                content: const Text('Deseja deletar essa anotação permanentemente?'),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  },
                    child: const Text('Não'),
                  ),
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                    _deleteNote();
                  },
                    child: const Text('Sim'),
                  )
                ],
              ));
            },
            icon: const Icon(Icons.delete_outline),
          ): const SizedBox(),
          IconButton(
            onPressed: widget.note == null? _insertNote: _updateNote,
            icon: const Icon(Icons.done),
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                  hintText: 'Titulo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                    hintText: 'Escreva aqui...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                ),
                maxLines: 50,
              ),
            )
          ],
        ),
      ),
    );
  }

  _insertNote() async{
    final note = Note(
        title: _title.text,
        description: _description.text,
        createdAt: DateTime.now()
    );
    await NotesRepository.insert(note: note);
    _refreshAndNavigateToHome();
  }

  _updateNote() async{
    final note = Note(
        id: widget.note!.id!,
        title: _title.text,
        description: _description.text,
        createdAt: widget.note!.createdAt
    );
    await NotesRepository.update(note: note);
    _refreshAndNavigateToHome();
  }

  _deleteNote() async {
    NotesRepository.delete(note: widget.note!).then((e) {
      _refreshAndNavigateToHome();
    });

  }

  void _refreshAndNavigateToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

}
