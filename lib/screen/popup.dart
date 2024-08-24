import 'package:Trovu/model/product.dart';
import 'package:Trovu/model/user_stock.dart';
import 'package:Trovu/service/user_stocks_service.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showReportDialog(BuildContext context, LocalProduct? product) {
  final TextEditingController nameController =
      TextEditingController(text: product?.name);
  final TextEditingController codeController =
      TextEditingController(text: product?.barcode);
  final TextEditingController quantityController =
      TextEditingController(text: '1');
  final TextEditingController nutricoreController = TextEditingController(
      text: product != null ? '${product.nutriscore}' : '');
  final TextEditingController dlcController = TextEditingController();
  String databaseDate = '';

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('fr'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final DateFormat displayFormatter = DateFormat('dd-MM-yyyy');
      dlcController.text = displayFormatter.format(pickedDate);
      final DateTime utcDate = pickedDate.toUtc();
      databaseDate = utcDate.toIso8601String();
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final String titleText = product == null
          ? AppLocalizations.of(context)!.popup_add_product
          : AppLocalizations.of(context)!.popup_modify_product;
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.popup_name,
                  prefixIcon: const Icon(Icons.shopping_basket),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.popup_barcode,
                  prefixIcon: const Icon(Icons.code),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nutricoreController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.popup_nutriscore,
                  prefixIcon: const Icon(Icons.score),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.popup_quantity,
                  prefixIcon: const Icon(Icons.production_quantity_limits),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.datetime,
                controller: dlcController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.popup_date,
                  prefixIcon: const Icon(Icons.date_range),
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
            child: Text(AppLocalizations.of(context)!.popup_cancel),
          ),
          ElevatedButton(
            style: btnSmallPrimaryStyle(context),
            onPressed: () async {
              final quantity = int.parse(quantityController.text.trim());
              final name = nameController.text.trim();

              if (name.isEmpty ||
                  (quantity.isNegative || quantity.isNaN) ||
                  codeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.popup_mandatory_fields),
                ));
              } else {
                try {
                  LocalProduct? productInsert = product;
                  if (product == null) {
                    //manual case
                    productInsert = LocalProduct(
                        id: '',
                        name: name,
                        barcode: codeController.text,
                        nutriscore: nutricoreController.text);
                  }

                  UserStock? result = await UserStocksService()
                      .insertUserStock(productInsert!, quantity, databaseDate);

                  if (result != null) {
                    showReportSnackbar(context, "");
                  } else {
                    showErrorSnackbar(
                        context, AppLocalizations.of(context)!.popup_add_error);
                  }
                } catch (e) {
                  rethrow;
                }
                Navigator.of(context).pop();
              }
            },
            child: Text(AppLocalizations.of(context)!.popup_add_button),
          ),
        ],
      );
    },
  );
}
