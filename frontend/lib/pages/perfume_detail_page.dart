import 'package:flutter/material.dart';

import '../models/perfume.dart';
import '../theme/app_colors.dart';
import '../widgets/perfume_photo.dart';
import 'perfume_form_page.dart';

class PerfumeDetailPage extends StatelessWidget {
  final Perfume perfume;

  const PerfumeDetailPage({super.key, required this.perfume});

  Future<void> editPerfume(BuildContext context) async {
    final updatedPerfume = await Navigator.push<Perfume>(
      context,
      MaterialPageRoute(builder: (_) => PerfumeFormPage(perfume: perfume)),
    );

    if (updatedPerfume != null && context.mounted) {
      Navigator.pop(context, {'action': 'update', 'perfume': updatedPerfume});
    }
  }

  void confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Parfum'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus data parfum ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, {'action': 'delete'});
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Parfum')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Center(
                  child: PerfumePhoto(
                    imageUrl: perfume.imageUrl,
                    width: 170,
                    height: 210,
                    borderRadius: 18,
                  ),
                ),
                const SizedBox(height: 20),
                detailItem('Nama Parfum', perfume.namaParfum),
                detailItem('Merek', perfume.merek),
                detailItem('Aroma', perfume.aroma),
                detailItem('Ukuran', perfume.ukuran),
                detailItem('Konsentrasi', perfume.konsentrasi),
                detailItem('Status', perfume.status),
                detailItem('Catatan', perfume.catatan),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => editPerfume(context),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                        ),
                        onPressed: () => confirmDelete(context),
                        icon: const Icon(Icons.delete),
                        label: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
