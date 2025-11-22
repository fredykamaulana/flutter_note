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

  Future<void> updateNote(NoteModel note) async {
    if (note.noteId == null) {
      throw ArgumentError('Note ID cannot be null for update operation.');
    }
    final docRef = noteRef.doc(note.noteId);
    await docRef.set(note);
  }

  Future<void> deleteNote(String noteId) async {
    final docRef = noteRef.doc(noteId);
    await docRef.delete();
  }
}
