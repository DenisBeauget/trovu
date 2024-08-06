import 'package:Trovu/provider/user_provider.dart';
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
        _showLoginSnackbar(context);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: userProvider.user == null
            ? const Text('No user')
            : Text('Welcome, ${userProvider.user!.email}'),
      ),
    );
  }
}

void _showLoginSnackbar(BuildContext context) {
  final snackBar = SnackBar(
    backgroundColor: Theme.of(context).primaryColor,
    behavior: SnackBarBehavior.floating,
    elevation: 10,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    action: SnackBarAction(
      label: 'Dismiss',
      onPressed: () {},
      textColor: const ColorScheme.light().onPrimaryContainer,
    ),
    content: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.done_all,
              color: const ColorScheme.light().onPrimaryContainer),
        ),
        Text(
          'Successfully logged in!',
          style: TextStyle(color: const ColorScheme.light().onPrimaryContainer),
        ),
      ],
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
