import '../models/perfume.dart';

List<Perfume> samplePerfumes() {
  return [
    Perfume(
      namaParfum: 'Dior Sauvage',
      merek: 'Dior',
      aroma: 'Fresh Spicy',
      ukuran: '100ml',
      konsentrasi: 'EDT',
      status: 'Favorit',
      catatan: 'Cocok digunakan untuk acara malam dan kegiatan outdoor.',
      imageUrl:
          'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=500&q=80',
    ),
    Perfume(
      namaParfum: 'Bleu de Chanel',
      merek: 'Chanel',
      aroma: 'Woody Aromatic',
      ukuran: '100ml',
      konsentrasi: 'EDP',
      status: 'Sering Dipakai',
      catatan: 'Aromanya elegan, clean, dan tahan lama.',
      imageUrl:
          'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=500&q=80',
    ),
    Perfume(
      namaParfum: 'YSL Y',
      merek: 'Yves Saint Laurent',
      aroma: 'Fresh Aromatic',
      ukuran: '60ml',
      konsentrasi: 'EDP',
      status: 'Casual',
      catatan: 'Cocok untuk pemakaian harian.',
      imageUrl:
          'https://images.unsplash.com/photo-1587017539504-67cfbddac569?auto=format&fit=crop&w=500&q=80',
    ),
    Perfume(
      namaParfum: 'California',
      merek: 'Mykonos',
      aroma: 'Citrus Aquatic',
      ukuran: '50ml',
      konsentrasi: 'EDP',
      status: 'Rekomendasi',
      catatan: 'Aroma citrus yang segar, akuatik, dan nyaman untuk siang hari.',
      imageUrl:
          'https://images.unsplash.com/photo-1595425970377-c9703cf48b6d?auto=format&fit=crop&w=500&q=80',
    ),
  ];
}
