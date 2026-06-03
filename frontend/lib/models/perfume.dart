class Perfume {
  int? id;
  String namaParfum;
  String merek;
  String aroma;
  String ukuran;
  String konsentrasi;
  String status;
  String catatan;
  String imageUrl;

  Perfume({
    this.id,
    required this.namaParfum,
    required this.merek,
    required this.aroma,
    required this.ukuran,
    required this.konsentrasi,
    required this.status,
    required this.catatan,
    required this.imageUrl,
  });

  factory Perfume.fromJson(Map<String, dynamic> json) {
    return Perfume(
      id: json['id'] as int?,
      namaParfum: json['nama_parfum']?.toString() ?? '',
      merek: json['merek']?.toString() ?? '',
      aroma: json['aroma']?.toString() ?? '',
      ukuran: json['ukuran']?.toString() ?? '',
      konsentrasi: json['konsentrasi']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      catatan: json['catatan']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_parfum': namaParfum,
      'merek': merek,
      'aroma': aroma,
      'ukuran': ukuran,
      'konsentrasi': konsentrasi,
      'status': status,
      'catatan': catatan,
      'image_url': imageUrl,
    };
  }
}
