import 'package:app_diario/repository/notes_repository.dart';
import 'package:app_diario/screens/add-note/add_note_screen.dart';
import 'package:app_diario/screens/home/widgets/item_note.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Diário'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: NotesRepository.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            if(snapshot.data == null || snapshot.data!.isEmpty){
              return const Center(child: Text("Vazio"));
            }
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [
                for(var note in snapshot.data!)
                  ItemNote(note: note)
              ],
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNoteScreen()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
