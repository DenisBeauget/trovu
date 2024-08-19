import 'package:Trovu/model/product.dart';
import 'package:Trovu/model/user_product.dart';
import 'package:Trovu/widget/product_card.dart';
import 'package:flutter/material.dart';

class Fridge extends StatefulWidget {
  const Fridge({super.key});

  @override
  State<Fridge> createState() => _FridgeState();
}

class _FridgeState extends State<Fridge> {
  UserProduct userProduct1 = UserProduct(
      name: 'Sirop',
      nutriscore: 'A',
      quantity: 1,
      date: '21/08/2024',
      imageUrl:
          'https://play-lh.googleusercontent.com/ZvMvaLTdYMrD6U1B3wPKL6siMYG8nSTEnzhLiMsH7QHwQXs3ZzSZuYh3_PTxoU5nKqU');
  UserProduct userProduct2 = UserProduct(
      name: 'Sirop',
      nutriscore: 'A',
      quantity: 1,
      date: '21/08/2024',
      imageUrl:
          'https://play-lh.googleusercontent.com/ZvMvaLTdYMrD6U1B3wPKL6siMYG8nSTEnzhLiMsH7QHwQXs3ZzSZuYh3_PTxoU5nKqU');
  UserProduct userProduct3 = UserProduct(
      name: 'Sirop',
      nutriscore: 'A',
      quantity: 1,
      date: '21/08/2024',
      imageUrl:
          'https://play-lh.googleusercontent.com/ZvMvaLTdYMrD6U1B3wPKL6siMYG8nSTEnzhLiMsH7QHwQXs3ZzSZuYh3_PTxoU5nKqU');

  List<UserProduct> productList = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    productList.add(userProduct1);
    productList.add(userProduct2);
    productList.add(userProduct3);

    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (context, index) {
        final product = productList[index];
        return ProductCard(
          userProduct: product,
        );
      },
    );
  }
}
