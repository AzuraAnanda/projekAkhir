import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  // Saran dan kesan yang sudah ada (pre-filled)
  final String suggestions = "Sebelum diberikan tugas besar, contoh-contoh kecil bisa membantu memahami logika dasar dari materi yang diajarkan.";
  final String comments = "Mata kuliah ini limayan karena langsung belajar bikin aplikasi yang bisa dipakai sehari-hari. Walaupun sering bikin pusing kalau ada error, tapi pas berhasil rasanya lega banget.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saran dan Kesan", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Halaman
              Text(
                "Kami sangat menghargai masukan Anda!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Saran yang sudah ada
              Text(
                "Saran atau Masukan:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  suggestions,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Kesan yang sudah ada
              Text(
                "Kesan Penggunaan Aplikasi:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  comments,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
