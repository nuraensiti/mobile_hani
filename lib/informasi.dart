import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'InfoDetailScreen.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<dynamic> infoData = [];

  @override
  void initState() {
    super.initState();
    fetchInfoData();
  }

  Future<void> fetchInfoData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/api/posts'));

    if (response.statusCode == 200) {
      List<dynamic> allData = json.decode(response.body);

      setState(() {
        infoData = allData.where((item) => item['category_id'] == 1).toList();
      });
    } else {
      throw Exception('Failed to load information');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informasi',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEEEEE), // Abu-abu muda
              Color(0xFFF8F8F8), // Abu-abu sangat muda
            ],
          ),
        ),
        child: infoData.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF20B2AA)),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: infoData.length,
                itemBuilder: (context, index) {
                  final item = infoData[index];
                  String preview = item['isi'].length > 50
                      ? item['isi'].substring(0, 50) + '...'
                      : item['isi'];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoDetailScreen(
                              judul: item['judul'],
                              isi: item['isi'],
                              tanggal: item['tanggal_posts'],
                              postId: item['id'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Color(0xFFF5F5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['judul'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF008080), // Tosca gelap
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              preview,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B6B6B),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tanggal: ${item['tanggal_posts']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF20B2AA), // Tosca medium
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
