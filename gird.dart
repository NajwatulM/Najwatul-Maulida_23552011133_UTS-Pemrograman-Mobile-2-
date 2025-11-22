// grid.dart
import 'package:flutter/material.dart';

class Surah {
  final int number;
  final String name;
  final String englishName;
  final int ayahCount;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.ayahCount,
  });
}

// 
final List<Surah> sampleSurahList = List.generate(
  30,
  (i) => Surah(
    number: i + 1,
    name: 'Surah ${i + 1}',
    englishName: 'Chapter ${i + 1}',
    ayahCount: (5 + (i % 10)),
  ),
);

// 
class QuranGridPage extends StatefulWidget {
  final List<Surah> surahList;

  const QuranGridPage({Key? key, this.surahList = sampleSurahList}) : super(key: key);

  @override
  _QuranGridPageState createState() => _QuranGridPageState();
}

class _QuranGridPageState extends State<QuranGridPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.surahList.where((s) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      return s.name.toLowerCase().contains(q) || s.englishName.toLowerCase().contains(q) || s.number.toString() == q;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Qur\'an — Daftar Surah'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari surah (nama atau nomor)...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              onChanged: (v) => setState(() => _query = v),
              keyboardType: TextInputType.text,
            ),
          ),

          // Expanded grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsif: jumlah kolom bergantung lebar layar
                  final crossAxisCount = constraints.maxWidth > 900
                      ? 6
                      : constraints.maxWidth > 600
                          ? 4
                          : 2;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final surah = filtered[index];
                      return _SurahCard(
                        surah: surah,
                        onTap: () => _openSurahDetail(context, surah),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openSurahDetail(BuildContext context, Surah surah) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SurahDetailPage(surah: surah),
      ),
    );
  }
}

// 
class _SurahCard extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const _SurahCard({Key? key, required this.surah, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 
              CircleAvatar(
                radius: 22,
                child: Text(surah.number.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 12),

              // 
              Text(
                surah.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // 
              Text(
                surah.englishName,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${surah.ayahCount} ayat', style: Theme.of(context).textTheme.bodySmall),
                  Icon(Icons.bookmark_border, size: 18),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 
class SurahDetailPage extends StatelessWidget {
  final Surah surah;

  const SurahDetailPage({Key? key, required this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${surah.name} — ${surah.englishName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Surah nomor: ${surah.number}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Jumlah ayat: ${surah.ayahCount}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),

            // 
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Di sini isi ayat-ayat akan ditampilkan. Untuk aplikasi produksi, ambil teks Al-Qur\'an dari file assets JSON atau API resmi.\n\n' +
                      'Contoh: ayat 1. Bismillahirrahmanirrahim... (dummy)\n' * 6,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

