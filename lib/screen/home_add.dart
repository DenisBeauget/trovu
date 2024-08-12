import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/styles/popup_style.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:Trovu/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Trovu/service/product_service.dart';

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
          const SizedBox(
              height: 100,
              width: 100,
              child: Image(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/basket_gif.gif'))),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              await ProductService.scanAndSaveProduct();
            },
            style: btnPrimaryStyle(context),
            child: const Text("Scanner un produit"),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              await ProductService.scanAndSaveProduct();
            },
            style: btnPrimaryStyle(context),
            child: const Text("Ajout d'un produit"),
          )
        ],
      ),
    );
  }
}
