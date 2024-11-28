import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';  // Untuk menangani file gambar

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _hobbiesController = TextEditingController();

  late Box profileBox;
  bool isEditing = false;  // Untuk menentukan apakah kita sedang dalam mode edit
  File? _profileImage;  // Variabel untuk menyimpan gambar profil

  @override
  void initState() {
    super.initState();
    // Membuka box Hive
    _openProfileBox();
  }

  Future<void> _openProfileBox() async {
    profileBox = await Hive.openBox('profile');
    _loadProfile();
  }

  void _loadProfile() {
    // Tidak ada data default, biarkan kosong pada awalnya
    _nameController.text = '';
    _nimController.text = '';
    _birthDateController.text = '';
    _hobbiesController.text = '';
    setState(() {});
  }

  void _saveProfile() {
    // Simpan data profil ke Hive
    profileBox.put('name', _nameController.text.trim());
    profileBox.put('nim', _nimController.text.trim());
    profileBox.put('birthDate', _birthDateController.text.trim());
    profileBox.put('hobbies', _hobbiesController.text.trim());
    if (_profileImage != null) {
      // Jika ada gambar, simpan path gambar
      profileBox.put('profileImage', _profileImage!.path);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profil berhasil disimpan!")),
    );
    setState(() {
      isEditing = false;  // Setelah disimpan, kembali ke tampilan profil
    });
  }

  void _deleteProfile() {
    // Hapus semua data profil dari Hive
    profileBox.deleteAll(['name', 'nim', 'birthDate', 'hobbies', 'profileImage']);
    _loadProfile(); // Reset tampilan dengan data kosong
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profil berhasil dihapus!")),
    );
    setState(() {});
  }

  Future<void> _pickImage() async {
    // Menggunakan ImagePicker untuk memilih gambar dari galeri atau kamera
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);  // Menyimpan gambar yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Ikon Profil yang dapat diganti
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,  // Posisi ikon upload di sudut kanan bawah
                  children: [
                    GestureDetector(
                      onTap: _pickImage,  // Ketika tap, pilih gambar
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage: _profileImage == null
                            ? null
                            : FileImage(_profileImage!), // Menampilkan gambar jika ada
                        child: _profileImage == null
                            ? Icon(
                                Icons.account_circle,
                                size: 75,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    // Ikon upload foto di pojok kanan bawah
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      color: Colors.white,
                      iconSize: 30,
                      onPressed: _pickImage,  // Memilih gambar
                      tooltip: 'Upload Foto',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tampilan Profil jika tidak dalam mode edit
              if (!isEditing) ...[
                _buildProfileField('Name', _nameController.text),
                _buildProfileField('NIM', _nimController.text),
                _buildProfileField('Date of Birth', _birthDateController.text),
                _buildProfileField('Hobbies', _hobbiesController.text),
              ]
              // Form untuk mengedit profil
              else ...[
                _buildEditableField('Name', _nameController),
                _buildEditableField('NIM', _nimController),
                _buildEditableField('Date of Birth', _birthDateController),
                _buildEditableField('Hobbies', _hobbiesController),
              ],

              const SizedBox(height: 24),

              // Tombol Edit, Save dan Delete
              if (!isEditing) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isEditing = true;  // Masuk ke mode edit
                    });
                  },
                  icon: Icon(Icons.edit),
                  label: Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,  // Warna teks menjadi putih
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _deleteProfile,
                  icon: Icon(Icons.delete),
                  label: Text("Delete Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,  // Warna teks menjadi putih
                  ),
                ),
              ]
              else ...[
                ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: Icon(Icons.save),
                  label: Text("Save Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,  // Warna teks menjadi putih
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isEditing = false;  // Keluar dari mode edit tanpa menyimpan
                    });
                    _loadProfile(); // Reset form ke data sebelumnya (kosong)
                  },
                  icon: Icon(Icons.cancel),
                  label: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,  // Warna teks menjadi putih
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // Tombol Kembali ke Home
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.home),
                label: Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: Colors.white,  // Warna teks menjadi putih
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan field profil (non-editable)
  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value.isEmpty ? "Belum diisi" : value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Widget untuk field profil yang dapat diedit
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
