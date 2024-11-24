import 'package:flutter/material.dart';
import 'home.dart';
import 'informasi.dart';
import 'agenda.dart';
import 'gallery.dart';
import 'login.dart'; // Import LoginScreen
import 'profile-sekolah.dart';

class WelcomeScreen extends StatefulWidget {
  final int initialIndex;

  WelcomeScreen({this.initialIndex = 0});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    HomeScreen(),
    InfoScreen(),
    AgendaScreen(),
    GalleryScreen(),
    ProfileSekolahScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Perbaikan fungsi logout dengan menambahkan clearance data
  void _logout() async {
    // Di sini Anda bisa menambahkan logic untuk membersihkan data sesi
    // Contoh: await SharedPreferences.getInstance().clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, // Ini akan menghapus semua route sebelumnya
    );
  }

  // Perbaikan fungsi login tanpa mengarahkan ke Dashboard Admin
  void _login() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );

    // Menambahkan logika setelah login jika diperlukan
    if (result == true) {
      // Logic after login
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Konfirmasi',
                  style: TextStyle(
                    color: Color(0xFF008080), // Tosca gelap
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  'Apakah Anda yakin ingin keluar dari aplikasi?',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'Tidak',
                      style: TextStyle(
                        color: Color(0xFF20B2AA), // Tosca medium
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      'Ya',
                      style: TextStyle(
                        color: Color(0xFF008080), // Tosca gelap
                      ),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          title: Text(
            'Gamaki App SMKN 4 Bogor',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 3.0,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
          ),
          centerTitle: true,
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
          shadowColor: Colors.black.withOpacity(0.5),
          actions: [
            IconButton(
              icon: Icon(Icons.login, color: Colors.white),
              onPressed: _login,
              tooltip: 'Login',
            ),
          ],
        ),
        body: Container(
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
          child: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF40E0D0),
                Color(0xFF20B2AA),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'Informasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Agenda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo),
                label: 'Galeri',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Profile-Sekolah',
              ),
            ],
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Color(0xFF003333), // Tosca sangat gelap
            unselectedItemColor: Color(0xFF006666), // Tosca gelap
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            elevation: 0,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
