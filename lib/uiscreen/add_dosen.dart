import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddDosenPage extends StatefulWidget {
  const AddDosenPage({super.key});

  @override
  State<AddDosenPage> createState() => _AddDosenPageState();
}

class _AddDosenPageState extends State<AddDosenPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noTeleponController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  bool isLoading = false;

  Future<void> tambahDosen() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final response = await http.post(
          Uri.parse('http://192.168.18.179:8000/api/dosen'),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {
            "nip": nipController.text,
            "nama_lengkap": namaController.text,
            "email": emailController.text,
            "no_telepon": noTeleponController.text,
            "alamat": alamatController.text,
          },
        );

        if (response.statusCode == 201) {
          Navigator.pop(context); // kembali ke halaman list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan data: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Dosen'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nipController,
                decoration: const InputDecoration(labelText: 'NIP'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (!value.contains('@')) return 'Email tidak valid';
                  return null;
                },
              ),
              TextFormField(
                controller: noTeleponController,
                decoration: const InputDecoration(labelText: 'No Telepon'),
              ),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : tambahDosen,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
