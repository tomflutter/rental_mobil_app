import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference rentals = FirebaseFirestore.instance.collection('rentals');

  Future<void> addRental(String nama, String mobil, int durasi) async {
    await rentals.add({
      'nama': nama,
      'mobil': mobil,
      'durasi': durasi,
    });
  }
}
