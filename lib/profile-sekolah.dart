import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileSekolahScreen extends StatefulWidget {
  @override
  _ProfileSekolahScreenState createState() => _ProfileSekolahScreenState();
}

class _ProfileSekolahScreenState extends State<ProfileSekolahScreen> {
  List<dynamic> profileData = [];

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/api/profile-sekolah'));

    if (response.statusCode == 200) {
      List<dynamic> allData = json.decode(response.body)['data'];
      setState(() {
        profileData = allData;
      });
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Sekolah',
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
        child: profileData.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF20B2AA)),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: profileData.length,
                itemBuilder: (context, index) {
                  final item = profileData[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 2,
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
                            item['isi'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B6B6B),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Diperbarui: ${item['updated_at']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF20B2AA), // Tosca medium
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
