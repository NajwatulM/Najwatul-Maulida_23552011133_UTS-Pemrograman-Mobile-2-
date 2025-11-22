import 'package:flutter/material.dart';
class QuranStackPage extends StatelessWidget {
  const QuranStackPage({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> _surahList = List.generate(
    20,
    (index) => {
      'number': index + 1,
      'name': 'Surah ${index + 1}',
      'arabic': 'سورة ${index + 1}',
      'verses': 5 + (index % 6),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 
            _buildBackground(),

            // 
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: _buildTopBar(context),
            ),

            // 
            Positioned(
              left: 0,
              right: 0,
              top: 120,
              bottom: 0,
              child: _buildContent(context),
            ),

            // 
            Positioned(
              right: 16,
              bottom: 24,
              child: FloatingActionButton.extended(
                onPressed: () {
                  // 
                  _openSurahPreview(context, _surahList.first);
                },
                icon: const Icon(Icons.book),
                label: const Text('Last Read'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEBF5F4), Color(0xFFD9EEF0)],
        ),
      ), 
        opacity: 0.08,
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 8.0),
            child: Icon(
              Icons.star, // 
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // 
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.menu_book, size: 28, color: Colors.black87),
          ),
          const SizedBox(width: 12),

          // 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Al-Qur\'an Digital',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text
              ],
            ),
          ),

          // 
          IconButton(
            onPressed: () => _showSearchModal(context),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      // 
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () => _showSearchModal(context),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, size: 20),
                    SizedBox(width: 8),
                    Text('Cari surah atau kata', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),

          // 
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Daftar Surah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),

          // 
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 80, left: 8, right: 8),
              itemBuilder: (context, index) {
                final s = _surahList[index];
                return ListTile(
                  onTap: () => _openSurahPreview(context, s),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade50,
                    child: Text('${s['number']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  title: Text(s['name']),
                  subtitle: Text('${s['verses']} ayat • ${s['arabic']}'),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 2),
              itemCount: _surahList.length,
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: 320,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Ketik nama surah atau kata...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onSubmitted: (value) {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Contoh suggestion statis
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(title: Text('Al-Fatihah')),
                      ListTile(title: Text('Al-Baqarah')),
                      ListTile(title: Text('Ali Imran')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSurahPreview(BuildContext context, Map<String, dynamic> surah) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(surah['name']),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  surah['verses'],
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Teks Arab (placeholder)
                        Text('آية ${i + 1}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 22)),

                        const SizedBox(height: 8),

                        // Terjemahan contoh
                        Text('Terjemahan ayat ${i + 1} dari ${surah['name']}.', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tutup')),
            TextButton(
              onPressed: () {
                // contoh aksi: bookmark
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Disimpan ke bookmark')));
              },
              child: const Text('Bookmark'),
            ),
          ],
        );
      },
    );
  }
}
