import 'package:flutter/material.dart';

class CharacterDetailPage extends StatelessWidget {
  final Map<String, dynamic> character;

  CharacterDetailPage({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradasi background untuk keseluruhan halaman
      appBar: AppBar(
        title: Text(character['name'] ?? 'Character Detail', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.redAccent, Colors.deepPurple.shade900],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Character Image
                if (character['image'] != null)
                  Center(
                    child: ClipOval(
                      child: Image.network(
                        character['image'],
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 16),

                // Container untuk detail karakter dengan background putih
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        "Name: ${character['name'] ?? 'Unknown'}",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),

                      // Alternate Names
                      Text(
                        "Alternate Names: ${character['alternate_names']?.join(', ') ?? 'None'}",
                        style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 81, 77, 207)),
                      ),
                      SizedBox(height: 8),

                      // Species, Gender, House, Date of Birth, Year of Birth
                      _buildDetailText("Species", character['species']),
                      _buildDetailText("Gender", character['gender']),
                      _buildDetailText("House", character['house']),
                      _buildDetailText(
                          "Date of Birth", character['dateOfBirth']),
                      _buildDetailText(
                          "Year of Birth", character['yearOfBirth']),

                      // Wizard status
                      Text(
                          "Wizard: ${character['wizard'] == true ? 'Yes' : 'No'}",
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),

                      // Ancestry and other details
                      _buildDetailText("Ancestry", character['ancestry']),
                      _buildDetailText("Eye Colour", character['eyeColour']),
                      _buildDetailText("Hair Colour", character['hairColour']),

                      // Wand details (if available)
                      if (character['wand'] != null) ...[
                        SizedBox(height: 8),
                        Text("Wand:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        _buildDetailText("Wood", character['wand']['wood']),
                        _buildDetailText("Core", character['wand']['core']),
                        _buildDetailText("Length", character['wand']['length']),
                      ],

                      // Patronus, Hogwarts status, Actor, Alive status
                      _buildDetailText("Patronus", character['patronus']),
                      _buildDetailText("Hogwarts Student",
                          character['hogwartsStudent'] == true ? 'Yes' : 'No'),
                      _buildDetailText("Hogwarts Staff",
                          character['hogwartsStaff'] == true ? 'Yes' : 'No'),
                      _buildDetailText("Actor", character['actor']),
                      _buildDetailText(
                          "Alive", character['alive'] == true ? 'Yes' : 'No'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create styled detail text
  Widget _buildDetailText(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Unknown',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
