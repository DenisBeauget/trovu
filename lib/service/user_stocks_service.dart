import 'package:Trovu/model/product.dart';
import 'package:Trovu/model/user_stock.dart';
import 'package:Trovu/service/product_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserStocksService {
  static final supabase = Supabase.instance.client;

  Future<UserStock?> insertUserStock(
      LocalProduct product, String quantity, DateTime? date) async {
    LocalProduct? localProduct =
        await ProductService().getLocalProductByBarcode(product.barcode);
    UserStock userStock = UserStock(
        userId: supabase.auth.currentUser?.id,
        productId: localProduct!.id,
        quantity: quantity,
        date: date?.toIso8601String());

    await supabase.from('user_stocks').insert(userStock.toJson());
    return userStock;
  }
}
