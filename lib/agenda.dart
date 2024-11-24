import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<dynamic> agendaData = [];

  @override
  void initState() {
    super.initState();
    fetchAgendaData();
  }

  Future<void> fetchAgendaData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/api/posts')); // Updated API URL

    if (response.statusCode == 200) {
      List<dynamic> allData = json.decode(response.body);
      setState(() {
        agendaData = allData.where((item) => item['category_id'] == 2).toList();
      });
    } else {
      throw Exception('Failed to load agenda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agenda',
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
        child: agendaData.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF20B2AA)),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: agendaData.length,
                itemBuilder: (context, index) {
                  final item = agendaData[index];
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
                            builder: (context) => AgendaDetailScreen(
                              judul: item['judul'],
                              isi: item['isi'],
                              tanggal: item['tanggal_posts'],
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

class AgendaDetailScreen extends StatelessWidget {
  final String judul;
  final String isi;
  final String tanggal;

  AgendaDetailScreen({
    required this.judul,
    required this.isi,
    required this.tanggal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Agenda',
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
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008080), // Tosca gelap
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tanggal: $tanggal',
                      style: TextStyle(
                        color: Color(0xFF20B2AA), // Tosca medium
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Text(
                        isi,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A4A4A),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
