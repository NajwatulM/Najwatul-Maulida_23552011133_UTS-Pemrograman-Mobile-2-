import 'package:flutter/material.dart';

void main() => runApp(AlQuranApp());

class AlQuranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Qur\'an Mini',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ------------------- Splash Screen -------------------
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 900), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.book, size: 88, color: Colors.green[700]),
            SizedBox(height: 16),
            Text('Al-Qur\'an Mini', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text(, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}

// ------------------- Sample Data -------------------
// This sample contains 2 surah with a couple of ayat each.
// Replace this with a real API or a bundled JSON file for a complete app.
final List<Map<String, dynamic>> sampleSurahList = [
  {
    'number': 1,
    'name_ar': 'الفاتحة',
    'name_trans': 'Al-Fatihah',
    'ayah_count': 7,
    'translation': 'Pembukaan',
    'ayahs': [
      {
        'number': 1,
        'ar': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'id': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.'
      },
      {
        'number': 2,
        'ar': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        'id': 'Segala puji bagi Allah, Tuhan semesta alam.'
      }
    ]
  },
  {
    'number': 2,
    'name_ar': 'البقرة',
    'name_trans': 'Al-Baqarah',
    'ayah_count': 286,
    'translation': 'Sapi Betina',
    'ayahs': [
      {
        'number': 1,
        'ar': 'الم',
        'id': 'Alif Lam Mim.'
      },
      {
        'number': 2,
        'ar': 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
        'id': 'Kitab (Al-Qur\'an) ini tidak ada keraguan padanya; petunjuk bagi mereka yang bertakwa.'
      }
    ]
  }
];

// ------------------- Home Page (List of Surah) -------------------
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> displayed = sampleSurahList;

  void _openSurah(Map<String, dynamic> surah) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SurahPage(surah: surah)),
    );
  }

  void _onSearch(String q) {
    final text = q.trim().toLowerCase();
    if (text.isEmpty) {
      setState(() => displayed = sampleSurahList);
      return;
    }
    setState(() {
      displayed = sampleSurahList.where((s) {
        final name = (s['name_trans'] as String).toLowerCase();
        final trans = (s['translation'] as String).toLowerCase();
        final arab = (s['name_ar'] as String);
        return name.contains(text) || trans.contains(text) || arab.contains(text);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Surah'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Al-Qur\'an Mini',
              applicationVersion: '1.0',
              children: [Text(, 
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Cari surah (nama/arti)...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: _onSearch,
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: displayed.length,
        separatorBuilder: (_, __) => Divider(height: 1),
        itemBuilder: (context, index) {
          final s = displayed[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[50],
              child: Text('${s['number']}', style: TextStyle(color: Colors.green[800])),
            ),
            title: Text('${s['name_trans']}', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${s['translation']} • ${s['ayah_count']} ayat'),
            trailing: Text('${s['name_ar']}', style: TextStyle(fontSize: 18)),
            onTap: () => _openSurah(s),
          );
        },
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green[50]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Al-Qur\'an Mini', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text(,),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Daftar Surah'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Pengaturan (coming soon)'),
                onTap: () => Navigator.pop(context),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('© ${DateTime.now().year} Al-Qur\'an Mini', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- Surah Page -------------------
class SurahPage extends StatelessWidget {
  final Map<String, dynamic> surah;
  SurahPage({required this.surah});

  @override
  Widget build(BuildContext context) {
    final ayahs = surah['ayahs'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${surah['name_trans']}', style: TextStyle(fontSize: 16)),
            Text('${surah['translation']} • ${surah['ayah_count']} ayat', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          final a = ayahs[index] as Map<String, dynamic>;
          return Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ayat ${a['number']}', style: TextStyle(fontWeight: FontWeight.w600)),
                      IconButton(
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tambah ke favorit (demo)')));
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  // Arabic text aligned to right
                  Text('${a['ar']}', textAlign: TextAlign.right, style: TextStyle(fontSize: 22, height: 1.5, fontFamily: 'Amiri')),
                  SizedBox(height: 12),
                  Text('${a['id']}', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
