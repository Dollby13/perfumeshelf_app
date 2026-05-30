import 'package:flutter/material.dart';

import '../models/perfume.dart';
import '../theme/app_colors.dart';

class PerfumeFormPage extends StatefulWidget {
  final Perfume? perfume;

  const PerfumeFormPage({super.key, this.perfume});

  @override
  State<PerfumeFormPage> createState() => _PerfumeFormPageState();
}

class _PerfumeFormPageState extends State<PerfumeFormPage> {
  final namaController = TextEditingController();
  final merekController = TextEditingController();
  final aromaController = TextEditingController();
  final ukuranController = TextEditingController();
  final konsentrasiController = TextEditingController();
  final statusController = TextEditingController();
  final catatanController = TextEditingController();
  final imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.perfume != null) {
      namaController.text = widget.perfume!.namaParfum;
      merekController.text = widget.perfume!.merek;
      aromaController.text = widget.perfume!.aroma;
      ukuranController.text = widget.perfume!.ukuran;
      konsentrasiController.text = widget.perfume!.konsentrasi;
      statusController.text = widget.perfume!.status;
      catatanController.text = widget.perfume!.catatan;
      imageUrlController.text = widget.perfume!.imageUrl;
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    merekController.dispose();
    aromaController.dispose();
    ukuranController.dispose();
    konsentrasiController.dispose();
    statusController.dispose();
    catatanController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void saveData() {
    if (namaController.text.isEmpty ||
        merekController.text.isEmpty ||
        aromaController.text.isEmpty ||
        ukuranController.text.isEmpty ||
        konsentrasiController.text.isEmpty ||
        statusController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua data wajib')),
      );
      return;
    }

    final perfume = Perfume(
      namaParfum: namaController.text,
      merek: merekController.text,
      aroma: aromaController.text,
      ukuran: ukuranController.text,
      konsentrasi: konsentrasiController.text,
      status: statusController.text,
      catatan: catatanController.text,
      imageUrl: imageUrlController.text,
    );

    Navigator.pop(context, perfume);
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.perfume != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Parfum' : 'Tambah Parfum')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Data Parfum',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Isi informasi parfum dengan lengkap.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            inputField(
              label: 'Nama Parfum',
              controller: namaController,
              icon: Icons.spa,
            ),
            inputField(
              label: 'Merek',
              controller: merekController,
              icon: Icons.label,
            ),
            inputField(
              label: 'Aroma',
              controller: aromaController,
              icon: Icons.air,
            ),
            inputField(
              label: 'Ukuran',
              controller: ukuranController,
              icon: Icons.local_drink,
            ),
            inputField(
              label: 'Konsentrasi',
              controller: konsentrasiController,
              icon: Icons.science,
            ),
            inputField(
              label: 'Status',
              controller: statusController,
              icon: Icons.favorite,
            ),
            inputField(
              label: 'Catatan',
              controller: catatanController,
              icon: Icons.note,
              maxLines: 3,
            ),
            inputField(
              label: 'URL Gambar',
              controller: imageUrlController,
              icon: Icons.image,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveData,
                child: Text(isEdit ? 'Update' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
