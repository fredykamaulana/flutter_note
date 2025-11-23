import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_note/models/note_model.dart';

class FirestoreHelper {
  final _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  late final _currentUserRef = FirebaseFirestore.instance
      .collection('users_notes')
      .doc(_currentUserId);
  //.collection('notes')
  // .withConverter<NoteModel>(
  //   fromFirestore: (snapshot, _) => NoteModel.fromJson(snapshot.data()!),
  //   toFirestore: (note, _) => note.toJson(),
  // );

  final _noteRef = FirebaseFirestore.instance
      .collection('notes')
      .withConverter<NoteModel>(
        fromFirestore: (snapshot, _) => NoteModel.fromJson(snapshot.data()!),
        toFirestore: (note, _) => note.toJson(),
      );

  Future<DocumentReference<NoteModel>> addNote(NoteModel note) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    late final currentUserRef = FirebaseFirestore.instance
        .collection('users_notes')
        .doc(currentUserId);

    late final noteRef = currentUserRef
        .collection('notes')
        .withConverter<NoteModel>(
          fromFirestore: (snapshot, _) => NoteModel.fromJson(snapshot.data()!),
          toFirestore: (note, _) => note.toJson(),
        );

    print('current user id: $currentUserId');

    final doc = await noteRef.add(note);

    final noteRefUpdated = noteRef.doc(doc.id);
    //noteRefUpdated.set(note..noteId = doc.id);
    noteRefUpdated.update({'note_id': doc.id});

    // result.update({'note_id': result.id});
    return doc;
  }

  Future<List<NoteModel>> fetchNotes() async {
    // final _currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // late final _currentUserRef = FirebaseFirestore.instance
    //     .collection('users_notes')
    //     .doc(_currentUserId)
    //     .collection('notes')
    //     .withConverter<NoteModel>(
    //       fromFirestore: (snapshot, _) => NoteModel.fromJson(snapshot.data()!),
    //       toFirestore: (note, _) => note.toJson(),
    //     );

    final querySnapshot = await _noteRef
        .orderBy('created_at', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> updateNote(NoteModel note) async {
    // final _currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // late final _currentUserRef = FirebaseFirestore.instance
    //     .collection('users_notes')
    //     .doc(_currentUserId)
    //     .collection('notes')
    //     .withConverter<NoteModel>(
    //       fromFirestore: (snapshot, _) => NoteModel.fromJson(snapshot.data()!),
    //       toFirestore: (note, _) => note.toJson(),
    //     );

    if (note.noteId == null) {
      throw ArgumentError('Note ID cannot be null for update operation.');
    }
    final docRef = _noteRef.doc(note.noteId);
    await docRef.set(note);
  }

  Future<void> deleteNote(String noteId) async {
    // final _currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // late final _currentUserRef = FirebaseFirestore.instance
    //     .collection('users_notes')
    //     .doc(_currentUserId)
    //     .collection('notes')
    //     .withConverter<NoteModel>(
    //       fromFirestore: (snapshot, _) => NoteModel.fromJson(snapshot.data()!),
    //       toFirestore: (note, _) => note.toJson(),
    //     );

    final docRef = _noteRef.doc(noteId);
    await docRef.delete();
  }

  Stream<QuerySnapshot<NoteModel>> getNoteStream() {
    // final _currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // late final _currentUserRef = FirebaseFirestore.instance
    //     .collection('users_notes')
    //     .doc(_currentUserId)
    //     .collection('notes')
    //     .withConverter<NoteModel>(
    //       fromFirestore: (snapshot, _) => NoteModel.fromJson(snapshot.data()!),
    //       toFirestore: (note, _) => note.toJson(),
    //     );

    return _noteRef.snapshots();
  }
}
