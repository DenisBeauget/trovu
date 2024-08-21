import 'package:Trovu/model/user_product.dart';
import 'package:Trovu/styles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final UserProduct userProduct;
  const ProductCard({super.key, required this.userProduct});

  @override
  Widget build(BuildContext context) {
    String? imageUrl = userProduct.imageUrl ?? "";

    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: imageUrl.isEmpty
                    ? const AssetImage('assets/images/clean-wall-texture.png')
                    : NetworkImage(imageUrl),
              ),
            ),
            VerticalDivider(
                thickness: 1,
                width: 12,
                color: Theme.of(context).colorScheme.primary),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userProduct.name, style: classicMediumText()),
                    const SizedBox(height: 4),
                    Text(
                        "${AppLocalizations.of(context)!.product_card_date} ${userProduct.date}",
                        style: classicMediumText()),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                            "${AppLocalizations.of(context)!.product_card_quantity}   ${userProduct.quantity}",
                            style: classicMediumText()),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add,
                                color: Theme.of(context).colorScheme.primary))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(
                thickness: 1,
                width: 12,
                color: Theme.of(context).colorScheme.primary),
            IconButton(
              icon: Icon(Icons.restaurant,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
