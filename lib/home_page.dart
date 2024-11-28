import 'package:flutter/material.dart';
import 'services/harry_potter_api.dart';
import 'profile_page.dart';
import 'saranKesan.dart';
import 'character_payment_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _searchQuery = "";
  List<dynamic> _characters = [];
  List<dynamic> _filteredCharacters = [];

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    try {
      final characters = await HarryPotterAPI.fetchCharacters();
      setState(() {
        _characters = characters;
        _filteredCharacters = characters;
      });
    } catch (error) {
      // Tampilkan error jika gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch characters: $error")),
      );
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCharacters = _characters
          .where((character) =>
              character['name']?.toLowerCase()?.contains(query.toLowerCase()) ??
              false)
          .toList();
    });
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1: // Saran & Kesan
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedbackPage()),
        );
        break;
      case 2: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar
          AppBar(
            title: const Text(
              'Harry Potter Characters',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () => _logout(context), icon: Icon(Icons.logout))
            ],
            backgroundColor: Colors.redAccent,
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
          ),

          // Search Bar
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.redAccent,
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: "Search by name...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),

          // Body Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.redAccent,
                    Colors.deepPurple.shade900,
                  ],
                ),
              ),
              child: _filteredCharacters.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _filteredCharacters.length,
                      itemBuilder: (context, index) {
                        final character = _filteredCharacters[index];
                        final imageUrl = character['image'] ?? '';
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CharacterPaymentPage(
                                      character: character),
                                ));
                          },
                          child: Hero(
                            tag: character['name'] ?? 'unknown',
                            child: SizedBox(
                              width: 80,
                              height: 100,
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 12),
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
                                        color:
                                            _getHouseColor(character['house']),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: const Color.fromARGB(255, 206, 27, 27), // Warna ungu
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: "Saran & Kesan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
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
