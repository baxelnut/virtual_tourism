import 'package:flutter/material.dart';

import '../../../../core/global_values.dart';
import '../../../pages/shop/shop_page.dart';

class ButtonShop extends StatelessWidget {
  final Map<String, dynamic> destinationData;
  const ButtonShop({
    super.key,
    required this.destinationData,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 8, bottom: 12),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ShopPage(
                destinationData: destinationData,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 20,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(width: 5),
            Text(
              'Shop',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
