import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note/models/note_model.dart';

class FirestoreHelper {
  final noteRef = FirebaseFirestore.instance
      .collection('notes')
      .withConverter<NoteModel>(
        fromFirestore: (snapshot, _) => NoteModel.fromJson(snapshot.data()!),
        toFirestore: (note, _) => note.toJson(),
      );

  Future<DocumentReference<NoteModel>> addNote(NoteModel note) {
    return noteRef.add(note);
  }

  Future<List<NoteModel>> fetchNotes() async {
    final querySnapshot = await noteRef.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
