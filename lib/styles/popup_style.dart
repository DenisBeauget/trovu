import 'package:Trovu/model/product.dart';
import 'package:Trovu/model/user_stock.dart';
import 'package:Trovu/service/user_stocks_service.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void showReportDialog(BuildContext context, LocalProduct? product) {
  final TextEditingController nameController =
      TextEditingController(text: product?.name);
  final TextEditingController codeController =
      TextEditingController(text: product?.barcode);
  final TextEditingController quantityController =
      TextEditingController(text: '1');
  final TextEditingController nutricoreController =
      TextEditingController(text: '${product?.nutriscore} (optionnel)');
  final TextEditingController dlcController =
      TextEditingController(text: '(optionnel)');

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('fr'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
      dlcController.text = dateFormatter.format(pickedDate);
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final String titleText =
          product == null ? 'Ajouter un produit' : 'Modifier le produit';
      return AlertDialog(
        title: Center(
            child: Text(
          titleText,
        )),
        content: SingleChildScrollView(
          child: Column(
            children: [
              if (product?.imageUrl != null) ...[
                ClipOval(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Image.network(
                      product!.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.shopping_basket),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Code barre',
                  prefixIcon: Icon(Icons.code),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nutricoreController,
                decoration: const InputDecoration(
                  labelText: 'Nutriscore',
                  prefixIcon: Icon(Icons.score),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantité',
                  prefixIcon: Icon(Icons.production_quantity_limits),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.datetime,
                controller: dlcController,
                decoration: const InputDecoration(
                  labelText: 'Date limite',
                  prefixIcon: Icon(Icons.date_range),
                ),
                readOnly: true,
                onTap: () async {
                  await selectDate(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: btnSmallPrimaryStyle(context),
            onPressed: () async {
              final quantity = quantityController.text.trim();
              final name = nameController.text.trim();
              final date = dlcController.text.trim();

              final dateTime = date != '(optionall)'
                  ? DateFormat('yyyy-MM-dd').parse(date)
                  : null;

              if (quantity.isEmpty || name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Veuillez remplir au moins 1 des champs'),
                ));
              } else {
                try {
                  UserStock? result = await UserStocksService()
                      .insertUserStock(product!, quantity, dateTime);

                  if (result != null) {
                    showReportSnackbar(context);
                  } else {
                    showErrorSnackbar(
                        context, "Erreur pendant l'ajout, réessayez");
                  }
                } catch (e) {
                  rethrow;
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text('Ajoutez'),
          ),
        ],
      );
    },
  );
}
