import 'package:dosen_users/model/model_dosen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditDosenPage extends StatefulWidget {
  final ModelDosen dosen;
  const EditDosenPage({super.key, required this.dosen});

  @override
  State<EditDosenPage> createState() => _EditDosenPageState();
}

class _EditDosenPageState extends State<EditDosenPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nipController;
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController noTeleponController;
  late TextEditingController alamatController;

  @override
  void initState() {
    super.initState();
    nipController = TextEditingController(text: widget.dosen.nip);
    namaController = TextEditingController(text: widget.dosen.namaLengkap);
    emailController = TextEditingController(text: widget.dosen.email);
    noTeleponController = TextEditingController(text: widget.dosen.noTelepon);
    alamatController = TextEditingController(text: widget.dosen.alamat);
  }

  Future<void> updateDosen() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse('http://192.168.18.179:8000/api/dosen/${widget.dosen.no}'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "nip": nipController.text,
          "nama_lengkap": namaController.text,
          "email": emailController.text,
          "no_telepon": noTeleponController.text,
          "alamat": alamatController.text,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Dosen'), backgroundColor: Colors.orange),
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
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
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
                onPressed: updateDosen,
                child: const Text('Update'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
