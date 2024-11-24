import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<dynamic> galleryData = [];
  List<dynamic> photosData = [];
  bool isPhotoView = false;
  int currentGalleryId = 0;

  @override
  void initState() {
    super.initState();
    fetchGalleryData();
  }

  // Fetch gallery data from the API
  Future<void> fetchGalleryData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/api/galeries'));

    if (response.statusCode == 200) {
      setState(() {
        galleryData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load gallery data');
    }
  }

  // Fetch photos for a specific gallery
  Future<void> fetchPhotos(int galleryId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/api/photos'));

    if (response.statusCode == 200) {
      List<dynamic> photos = json.decode(response.body)['data'];
      setState(() {
        photosData = photos.where((photo) => photo['galery_id'] == galleryId).toList();
        isPhotoView = true;
        currentGalleryId = galleryId;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  // Build a single gallery item
  Widget _buildGalleryItem(dynamic item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          fetchPhotos(item['id']);
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
                  color: Color(0xFF008080),
                ),
              ),
              SizedBox(height: 8),
              Text(
                item['deskripsi'],
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B6B6B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the photo grid view for a gallery
  Widget _buildPhotosView() {
    return GridView.builder(
      padding: EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: photosData.length,
      itemBuilder: (context, index) {
        final photo = photosData[index];

        // Construct the full URL for the image (replace with the actual server path if necessary)
        String imageUrl = 'http://10.0.2.2/ujikom_hani/ujikom_web_hani/public/storage/${photo['isi_foto']}';

        return Card(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Color(0xFFE0FFFF),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF20B2AA),
                              ),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    photo['judul_foto'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF008080),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPhotoView ? 'Foto Gallery' : 'Gallery',
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
        actions: isPhotoView
            ? [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      isPhotoView = false;
                      photosData = [];
                    });
                  },
                ),
              ]
            : [],
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
        child: isPhotoView
            ? _buildPhotosView()
            : galleryData.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF20B2AA)),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: galleryData.length,
                    itemBuilder: (context, index) {
                      final item = galleryData[index];
                      return _buildGalleryItem(item);
                    },
                  ),
      ),
    );
  }
}
