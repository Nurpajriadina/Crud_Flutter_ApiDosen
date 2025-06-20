class ModelDosen {
  final int no;
  final String nip;
  final String namaLengkap;
  final String? noTelepon; // Nullable untuk menghindari error jika null
  final String email;
  final String? alamat;     // Nullable juga

  ModelDosen({
    required this.no,
    required this.nip,
    required this.namaLengkap,
    this.noTelepon,
    required this.email,
    this.alamat,
  });

  factory ModelDosen.fromJson(Map<String, dynamic> json) {
    return ModelDosen(
      no: json['no'] is int ? json['no'] : int.tryParse(json['no'].toString()) ?? 0,
      nip: json['nip'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      noTelepon: json['no_telepon'],
      email: json['email'] ?? '',
      alamat: json['alamat'],
    );
  }

  Map<String, dynamic> toJson() => {
        'no': no,
        'nip': nip,
        'nama_lengkap': namaLengkap,
        'no_telepon': noTelepon,
        'email': email,
        'alamat': alamat,
      };
}
