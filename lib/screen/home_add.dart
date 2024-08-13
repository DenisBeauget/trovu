import 'package:Trovu/model/product.dart';
import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/styles/popup_style.dart';
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

    const SizedBox(height: 30);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                  child: Text("Bienvenue ${userProvider.user!.display_name}",
                      style: classicText())),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 350,
                  height: 400,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                          height: 100,
                          width: 100,
                          child: Image(
                              fit: BoxFit.contain,
                              image:
                                  AssetImage('assets/images/basket_gif.gif'))),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          LocalProduct? result =
                              await ProductService().scanAndSaveProduct();

                          if (result != null) {
                            showReportDialog(context, result);
                          }
                        },
                        style: btnPrimaryStyle(context),
                        child: const Text("Scanner un produit"),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          showReportDialog(context, null);
                        },
                        style: btnPrimaryStyle(context),
                        child: const Text("Ajout d'un produit"),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
