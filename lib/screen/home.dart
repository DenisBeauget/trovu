import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/screen/dashboard.dart';
import 'package:Trovu/screen/home_add.dart';
import 'package:Trovu/screen/search.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:Trovu/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  final bool showSnackbar;

  const Home({super.key, required this.showSnackbar});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _snackBarShown = false;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeAdd(),
    const Search(),
    const Dashboard(),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.showSnackbar && !_snackBarShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoginSnackbar(context);
        _snackBarShown = true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            onPressed: () {
              _showQrCodeDialog(context);
            },
            icon: const Icon(Icons.share),
            color: const ColorScheme.light().inversePrimary,
          )
        ],
        title: const SizedBox(
            height: 50,
            child: Image(image: AssetImage('assets/trovu_icon.png'))),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            height: 2,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_home,
                  ),
                  label: '',
                  activeIcon: Icon(Icons.add_home_outlined)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: '',
                  activeIcon: Icon(Icons.search_outlined)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: '',
                  activeIcon: Icon(Icons.bar_chart_outlined)),
            ],
          ),
        ],
      ),
    );
  }

  void _showQrCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('Partage Trovu !', style: classicText())),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: 'https://flutter.dev',
                version: QrVersions.auto,
                embeddedImage: const AssetImage('assets/trovu_icon.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(50, 50),
                    color: Theme.of(context).colorScheme.primary),
                size: 200.0,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Share.share(
                      'Téléchargez notre application ici : https://flutter.dev');
                },
                style: btnPrimaryStyle(context),
                child: const Text('Partager'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
