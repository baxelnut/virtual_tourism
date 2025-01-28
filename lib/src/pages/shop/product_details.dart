import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final String productImage;
  final String productName;
  final String productPrice;
  final String? productDescription;

  const ProductDetails({
    super.key,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    this.productDescription,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: Text(
              productName,
              style: theme.textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            backgroundColor: Colors.transparent,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height / 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.network(
                      productImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Product',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Price',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          productName,
                          style: theme.textTheme.headlineSmall,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Rp$productPrice',
                          style: theme.textTheme.headlineSmall,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                  child: Text(
                    productDescription ?? 'No Description Available',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 100)
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: SizedBox(
          height: 60,
          width: screenSize.width - 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Rp$productPrice',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffEFFFFB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Add to cart',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xff121212),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
