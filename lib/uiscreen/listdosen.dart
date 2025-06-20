import 'package:dosen_users/model/model_dosen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_dosen.dart';
import 'edit_dosen.dart';

class ListDosenPage extends StatefulWidget {
  const ListDosenPage({super.key});

  @override
  State<ListDosenPage> createState() => _ListDosenPageState();
}

class _ListDosenPageState extends State<ListDosenPage> {
  late Future<List<ModelDosen>> futureDosen;

  @override
  void initState() {
    super.initState();
    futureDosen = fetchDosen();
  }

  Future<List<ModelDosen>> fetchDosen() async {
    final response = await http.get(
      Uri.parse('http://192.168.18.179:8000/api/dosen'),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ModelDosen.fromJson(data)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<void> refreshData() async {
    final updatedData = await fetchDosen();
    setState(() {
      futureDosen = Future.value(updatedData);
    });
  }

  Future<void> deleteDosen(int no) async {
    final response = await http.delete(
      Uri.parse('http://192.168.18.179:8000/api/dosen/$no'),
    );
    if (response.statusCode == 200) {
      await refreshData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Dosen'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<ModelDosen>>(
        future: futureDosen,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data kosong'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final dosen = snapshot.data![index];
                return ListTile(
                  title: Text(dosen.namaLengkap),
                  subtitle: Text('NIP: ${dosen.nip}\nEmail: ${dosen.email}'),
                  isThreeLine: true,
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDosenPage(dosen: dosen),
                            ),
                          );
                          await refreshData();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Konfirmasi Hapus'),
                              content: Text(
                                  'Apakah Anda yakin ingin menghapus data dosen "${dosen.namaLengkap}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await deleteDosen(dosen.no);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDosenPage()),
          );
          await refreshData();
        },
      ),
    );
  }
}
