import 'package:Trovu/model/product.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  static final supabase = Supabase.instance.client;

  static Future<LocalProduct?> scanAndSaveProduct() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Annuler',
        true,
        ScanMode.BARCODE,
      );

      if (barcode == '-1') {
        throw Exception('Scan annulé');
      }

      final existingProduct = await supabase
          .from('products')
          .select()
          .eq('barcode', barcode)
          .maybeSingle();

      if (existingProduct != null) {
        return LocalProduct.fromJson(existingProduct);
      }

      ProductQueryConfiguration configuration = ProductQueryConfiguration(
          barcode,
          language: OpenFoodFactsLanguage.FRENCH,
          fields: [
            ProductField.NAME,
            ProductField.IMAGE_FRONT_SMALL_URL,
            ProductField.NUTRISCORE
          ],
          version: ProductQueryVersion.v3);

      ProductResultV3 result =
          await OpenFoodAPIClient.getProductV3(configuration);

      if (result.status == ProductResultV3.statusSuccess) {
        final newProduct = LocalProduct(
          name: result.product!.productName ?? 'Produit inconnu',
          barcode: barcode,
          nutriscore: result.product!.nutriscore,
          imageUrl: result.product!.imageFrontSmallUrl,
        );

        final productJson = newProduct.toJson();

        final insertResult =
            await supabase.from('products').insert(productJson).single();

        return LocalProduct.fromJson(insertResult);
      } else {
        throw Exception('Produit non trouvé dans Open Food Facts');
      }
    } catch (e) {
      print('Erreur lors du scan et de la sauvegarde du produit: $e');
      return null;
    }
  }
}
