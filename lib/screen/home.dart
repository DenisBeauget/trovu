import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final bool showSnackbar;

  const Home({super.key, required this.showSnackbar});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (showSnackbar) {
      Future.delayed(Duration.zero, () {
        showLoginSnackbar(context);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: userProvider.user == null
            ? const Text('No user')
            : Text(
                'Welcome, ${userProvider.user!.email} la forme le s? ${userProvider.user!.display_name}',
              ),
      ),
    );
  }
}
