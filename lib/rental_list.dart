import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_service.dart';

class RentalList extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Penyewaan Mobil'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService.rentals.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var rental = snapshot.data!.docs[index];
              return ListTile(
                title: Text(rental['nama']),
                subtitle: Text('Mobil: ${rental['mobil']} | Durasi: ${rental['durasi']} hari'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRentalDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddRentalDialog(BuildContext context) async {
    TextEditingController namaController = TextEditingController();
    TextEditingController mobilController = TextEditingController();
    TextEditingController durasiController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Penyewaan'),
          content: Column(
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
              ),
              TextField(
                controller: mobilController,
                decoration: InputDecoration(labelText: 'Nama Mobil'),
              ),
              TextField(
                controller: durasiController,
                decoration: InputDecoration(labelText: 'Durasi (hari)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _firebaseService.addRental(
                  namaController.text,
                  mobilController.text,
                  int.parse(durasiController.text),
                );
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
