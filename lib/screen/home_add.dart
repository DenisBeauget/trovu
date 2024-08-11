import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/styles/popup_style.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:Trovu/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAdd extends StatefulWidget {
  const HomeAdd({super.key});

  @override
  State<HomeAdd> createState() => _HomeAddState();
}

class _HomeAddState extends State<HomeAdd> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text("Bienvenue ${userProvider.user!.display_name}",
                  style: classicMediumText())),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              showReportDialog(context);
            },
            style: btnPrimaryStyle(context),
            child: const Text("Signaler"),
          )
        ],
      ),
    );
  }
}
