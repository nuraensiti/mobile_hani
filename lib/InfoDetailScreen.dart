import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoDetailScreen extends StatefulWidget {
  final String judul;
  final String isi;
  final String tanggal;
  final int postId;

  InfoDetailScreen({
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.postId,
  });

  @override
  _InfoDetailScreenState createState() => _InfoDetailScreenState();
}

class _InfoDetailScreenState extends State<InfoDetailScreen> {
  List<dynamic> galleries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGalleries();
  }

  Future<void> fetchGalleries() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/api/galeries'));
      if (response.statusCode == 200) {
        List<dynamic> allGalleries = json.decode(response.body);
        setState(() {
          galleries = allGalleries.where((gallery) => gallery['post_id'] == widget.postId).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching galleries: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Informasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF40E0D0), // Tosca terang
                Color(0xFF20B2AA), // Tosca medium
                Color(0xFF008080), // Tosca gelap
              ],
            ),
          ),
        ),
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFE0FFFF), // Tosca sangat muda
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.judul,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008080), // Tosca gelap
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tanggal: ${widget.tanggal}',
                  style: TextStyle(
                    color: Color(0xFF20B2AA), // Tosca medium
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  widget.isi,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A4A4A), // Abu-abu gelap
                    height: 1.5,
                  ),
                ),
                if (galleries.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Text(
                    'Galeri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF008080), // Tosca gelap
                    ),
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: galleries.length,
                    itemBuilder: (context, index) {
                      final gallery = galleries[index];
                      String imageUrl = 'http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/storage/${gallery['post']['image']}'; // Pastikan URL gambar benar
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Color(0xFFE0FFFF),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF20B2AA)),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Color(0xFFE0FFFF),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: Color(0xFF008080),
                                              size: 32,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Gagal memuat gambar',
                                              style: TextStyle(
                                                color: Color(0xFF008080),
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gallery['judul'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF008080),
                                      ),
                                    ),
                                    if (gallery['deskripsi'] != null) ...[
                                      SizedBox(height: 4),
                                      Text(
                                        gallery['deskripsi'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF20B2AA),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
