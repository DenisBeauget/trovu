import 'package:openfoodfacts/openfoodfacts.dart';

class OfaApiService {
  Future<ProductResultV3> getProduct(String barcode) async {
    try {
      ProductQueryConfiguration configuration = ProductQueryConfiguration(
          barcode,
          language: OpenFoodFactsLanguage.FRENCH,
          fields: [
            ProductField.NAME,
            ProductField.IMAGE_FRONT_SMALL_URL,
            ProductField.NUTRISCORE
          ],
          version: ProductQueryVersion.v3);

      return await OpenFoodAPIClient.getProductV3(configuration);
    } catch (e) {
      rethrow;
    }
  }
}
