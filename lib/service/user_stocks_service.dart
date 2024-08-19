import 'package:Trovu/model/product.dart';
import 'package:Trovu/model/user_stock.dart';
import 'package:Trovu/service/product_service.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserStocksService {
  static final supabase = Supabase.instance.client;

  Future<UserStock?> insertUserStock(
      LocalProduct product, int quantity, String date) async {
    String formattedDate = '';
    if (date.isNotEmpty) {
      DateTime parsedDate = DateTime.parse(date);
      DateTime utcDate =
          DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
      formattedDate = utcDate.toIso8601String();
    }

    if (product.id.isEmpty) {
      // doesnt exist
      product = await ProductService().insertProduct(product);
    }

    UserStock? userStock =
        await getUserStockById(supabase.auth.currentUser!.id, product.id);

    if (userStock != null) {
      //already an entry
      await updateUserStockQuantityById(
          supabase.auth.currentUser!.id, product.id, quantity);
      return userStock;
    }

    userStock = UserStock(
        userId: supabase.auth.currentUser?.id,
        productId: product.id,
        quantity: quantity,
        date: formattedDate);

    await supabase.from('user_stocks').insert(userStock.toJson());
    return userStock;
  }

  Future<UserStock?> getUserStockById(String userId, String productId) async {
    try {
      final stock = await supabase
          .from('user_stocks')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (stock != null) {
        return UserStock.fromJson(stock);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserStockQuantityById(
      String userId, String productId, int quantity) async {
    try {
      await supabase.rpc(
        'increment_quantity',
        params: {
          'p_user_id': userId,
          'p_product_id': productId,
          'delta': quantity
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserStock>> getUserStockListById(String userId) async {
    try {
      final result =
          await supabase.from('user_stocks').select().eq("user_id", userId);

      final data = result as List<dynamic>;

      return data.map((item) => UserStock.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
