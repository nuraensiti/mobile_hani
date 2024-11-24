import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'informasi.dart';  // Import your Informasi screen
import 'agenda.dart';  // Import your Agenda screen
import 'gallery.dart';  // Import your Gallery screen

class Category {
  final int id;
  final String nama;
  final String deskripsi;

  Category({
    required this.id,
    required this.nama,
    required this.deskripsi,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  List<dynamic> sliders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchSliders();
  }

  Future<void> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/api/categories'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = data
              .where((category) =>
                  category['id'] == 1 || category['id'] == 2) // Filter for Informasi and Agenda
              .map((category) => Category.fromJson(category))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSliders() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/api/sliders'));
      if (response.statusCode == 200) {
        setState(() {
          sliders = json.decode(response.body);
        });
      }
    } catch (e) {
      print('Error fetching sliders: $e');
    }
  }

  void _navigateToScreen(int categoryId) {
    if (categoryId == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InfoScreen()),  // Navigate to InfoScreen
      );
    } else if (categoryId == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AgendaScreen()),  // Navigate to AgendaScreen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang di Gallery SMKN 4 Bogor!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008080),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Simpan Kenangan Semasa Sekolah dengan Gallery Masa Kini Karena Waktu Tidak Dapat Diputar Kembali.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF20B2AA),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                sliders.isNotEmpty
                    ? SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sliders.length,
                          itemBuilder: (context, index) {
                            final slider = sliders[index];
                            return GestureDetector(
                              onTap: () {
                                print('Navigating to: ${slider['link']}');
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Card(
                                  color: Color.fromARGB(255, 189, 196, 204),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        slider['image'],
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          1)
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.error,
                                              size: 50, color: Colors.red);
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          'Klik untuk lebih lanjut',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GalleryScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat foto lainnya',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF20B2AA),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Color(0xFF20B2AA),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008080),
                  ),
                ),
                SizedBox(height: 16),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () =>
                                _navigateToScreen(categories[index].id),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF40E0D0),
                                    Color(0xFF20B2AA),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    categories[index].id == 1
                                        ? Icons.info_outline
                                        : Icons.calendar_today,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    categories[index].nama,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
