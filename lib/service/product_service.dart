import 'package:Trovu/model/product.dart';
import 'package:Trovu/service/ofa_api_service.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  static final supabase = Supabase.instance.client;

  Future<LocalProduct?> scanAndSaveProduct() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Annuler',
        true,
        ScanMode.BARCODE,
      );

      LocalProduct? existingProduct = await getLocalProductByBarcode(barcode);

      if (existingProduct != null) {
        return existingProduct;
      }

      ProductResultV3 result = await OfaApiService().getProduct(barcode);

      if (result.status == ProductResultV3.statusSuccess) {
        final newProduct = LocalProduct(
          id: '',
          name: result.product!.productName ?? 'Produit inconnu',
          barcode: barcode,
          nutriscore: result.product!.nutriscore?.toUpperCase(),
          imageUrl: result.product!.imageFrontSmallUrl,
        );

        insertProduct(newProduct);

        return newProduct;
      } else {
        throw Exception('Cant find product');
      }
    } catch (e) {
      return null;
    }
  }

  Future<LocalProduct> insertProduct(LocalProduct product) async {
    final response = await supabase
        .from('products')
        .insert(product.toJson())
        .select()
        .single();
    return LocalProduct.fromJson(response);
  }

  Future<LocalProduct?> getLocalProductByBarcode(String barcode) async {
    try {
      final product = await supabase
          .from('products')
          .select()
          .eq('barcode', barcode)
          .maybeSingle();

      if (product != null) {
        return LocalProduct.fromJson(product);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<LocalProduct?> getLocalProductById(String id) async {
    try {
      final product =
          await supabase.from('products').select().eq('id', id).maybeSingle();

      if (product != null) {
        return LocalProduct.fromJson(product);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
