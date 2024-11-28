import 'package:flutter/material.dart';
import 'character_payment_page.dart';  // Import halaman pembayaran
import '../services/harry_potter_api.dart';
import 'character_detail_page.dart';

class HarryPotterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Characters'),
        backgroundColor: const Color.fromARGB(255, 53, 59, 125), // Warna ungu gelap
      ),
      body: FutureBuilder(
        future: HarryPotterAPI.fetchCharacters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            final characters = snapshot.data as List<dynamic>;
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.7,
              ),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                final imageUrl = character['image'] ?? '';
                return GestureDetector(
                  onTap: () {
                    // Arahkan ke halaman pembayaran terlebih dahulu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterPaymentPage(character: character),
                      ),
                    );
                  },
                  child: Hero(
                    tag: character['name'] ?? 'unknown',
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          // Gambar bulat
                          ClipOval(
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 120,
                                    width: 120,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 12),
                          // Nama dan rumah karakter
                          Text(
                            character['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            character['house'] ?? 'No House',
                            style: TextStyle(
                              fontSize: 14,
                              color: _getHouseColor(character['house']),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Color _getHouseColor(String? house) {
    switch (house) {
      case 'Gryffindor':
        return Colors.red.shade700;
      case 'Slytherin':
        return Colors.green.shade700;
      case 'Hufflepuff':
        return Colors.yellow.shade700;
      case 'Ravenclaw':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade600;
    }
  }
}
