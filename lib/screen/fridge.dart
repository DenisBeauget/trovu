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
  bool limitDateChecked = false;
  bool passLimitDateChecked = false;

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
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<UserProduct> filteredList = userProductList;

    if (searchController.text.isNotEmpty) {
      filteredList = filteredList
          .where((product) => product.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    if (limitDateChecked) {
      final thresholdDate = DateTime.now().subtract(const Duration(days: 3));
      filteredList = filteredList.where((product) {
        DateTime? productDate = DateTime.tryParse(product.date!);
        return productDate != null && productDate.isAfter(thresholdDate);
      }).toList();
    }

    if (passLimitDateChecked) {
      final thresholdDate = DateTime.now();
      filteredList = filteredList.where((product) {
        DateTime? productDate = DateTime.tryParse(product.date!);
        return productDate != null && productDate.isBefore(thresholdDate);
      }).toList();
    }

    setState(() {
      filteredUserProductList = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserProducts();

    searchController.addListener(_applyFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary, width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Rechercher...',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                              borderRadius: BorderRadius.circular(30)),
                          prefixIcon: Icon(Icons.search,
                              color: Theme.of(context).primaryColor)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text("Date courte"),
                        selected: limitDateChecked,
                        onSelected: (bool value) {
                          setState(() {
                            limitDateChecked = value;
                            _applyFilters();
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text("Périmé"),
                        selected: passLimitDateChecked,
                        onSelected: (bool value) {
                          setState(() {
                            passLimitDateChecked = value;
                            _applyFilters();
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredUserProductList.length,
                      itemBuilder: (context, index) {
                        final product = filteredUserProductList[index];
                        return ProductCard(
                          userProduct: product,
                          onDelete: () {
                            setState(() {
                              userProductList.removeWhere((item) =>
                                  item.productId == product.productId);
                              _applyFilters();
                            });
                          },
                          onAdd: () {
                            setState(() {
                              final productIndex = userProductList.indexWhere(
                                  (item) =>
                                      item.productId == product.productId);
                              if (productIndex != -1) {
                                userProductList[productIndex].quantity += 1;
                                _applyFilters();
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
