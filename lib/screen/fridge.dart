import 'package:Trovu/model/product.dart';
import 'package:Trovu/model/user_product.dart';
import 'package:Trovu/model/user_stock.dart';
import 'package:Trovu/service/product_service.dart';
import 'package:Trovu/service/user_stocks_service.dart';
import 'package:Trovu/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Fridge extends StatefulWidget {
  const Fridge({super.key});

  @override
  State<Fridge> createState() => _FridgeState();
}

class _FridgeState extends State<Fridge> {
  final supabase = Supabase.instance.client;

  List<UserProduct> userProductList = List.empty(growable: true);
  List<UserProduct> filteredUserProductList = List.empty(growable: true);
  final TextEditingController searchController = TextEditingController();
  bool _isLoading = true;

  Future<void> _loadUserProducts() async {
    final supabase = Supabase.instance.client;

    List<UserStock> userStockList = await UserStocksService()
        .getUserStockListById(supabase.auth.currentUser!.id);

    List<UserProduct> loadedUserProductList = List.empty(growable: true);

    for (UserStock userStock in userStockList) {
      LocalProduct? localProduct =
          await ProductService().getLocalProductById(userStock.productId);

      if (localProduct != null) {
        loadedUserProductList.add(UserProduct(
            productId: userStock.productId,
            name: localProduct.name,
            nutriscore: localProduct.nutriscore,
            quantity: userStock.quantity,
            date: userStock.date,
            imageUrl: localProduct.imageUrl ?? ""));
      }
    }
    setState(() {
      userProductList = loadedUserProductList;
      filteredUserProductList = loadedUserProductList;
      _isLoading = false;
    });
  }

  void _filterProducts(String query) {
    List<UserProduct> filteredList = userProductList
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredUserProductList = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserProducts();

    searchController.addListener(() {
      _filterProducts(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher...',
            hintStyle: TextStyle(color: Theme.of(context).primaryColor),
            icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor, value: 4))
          : ListView.builder(
              itemCount: filteredUserProductList.length,
              itemBuilder: (context, index) {
                final product = filteredUserProductList[index];
                return ProductCard(
                  userProduct: product,
                  onDelete: () {
                    setState(() {
                      userProductList.removeAt(index);
                      _filterProducts(searchController.text);
                    });
                  },
                  onAdd: () {
                    setState(() {
                      userProductList.elementAt(index).quantity += 1;
                      _filterProducts(searchController.text);
                    });
                  },
                );
              },
            ),
    );
  }
}
