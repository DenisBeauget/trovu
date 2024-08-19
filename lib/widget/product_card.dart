import 'package:Trovu/model/user_product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final UserProduct userProduct;
  const ProductCard({super.key, required this.userProduct});

  @override
  Widget build(BuildContext context) {
    String? imageUrl = userProduct.imageUrl;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(imageUrl!),
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('name ${userProduct.name}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Date limite: ${userProduct.date}',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Quantité:  ${userProduct.quantity}',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            IconButton(
              icon: const Icon(Icons.gavel_sharp, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
