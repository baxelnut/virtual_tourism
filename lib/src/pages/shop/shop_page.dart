import 'package:flutter/material.dart';

import 'product_details.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.onSurface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),
            title: const Text("Shop"),
            floating: true,
            snap: true,
            actions: [
              GestureDetector(
                onTap: () {
                  print('bag clicked');
                },
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                ),
              ),
              const SizedBox(width: 30),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(90),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 30,
                  left: 30,
                  bottom: 20,
                ),
                child: searchBar(
                  theme: theme,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Bro's products",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        buildShopCard(
                          productImage:
                              'https://cdns.klimg.com/mav-prod-resized/0x0/ori/newsOg/2024/6/7/1717747914308-0snos.jpeg',
                          productName: 'Nike Jordan "Why Not?" Zer0.3 PF',
                          productPrice: '180.000',
                          screenSize: screenSize,
                          theme: theme,
                        ),
                        buildShopCard(
                          productImage:
                              'https://cdns.klimg.com/mav-prod-resized/0x0/ori/newsOg/2024/6/7/1717747914308-0snos.jpeg',
                          productName: 'Nike Joyride CC3 Setter',
                          productPrice: '175.000',
                          screenSize: screenSize,
                          theme: theme,
                        ),
                        buildShopCard(
                          productImage:
                              'https://cdns.klimg.com/mav-prod-resized/0x0/ori/newsOg/2024/6/7/1717747914308-0snos.jpeg',
                          productName: 'Nike Joyride CC3 Setter',
                          productPrice: '175.000',
                          screenSize: screenSize,
                          theme: theme,
                        ),
                        buildShopCard(
                          productImage:
                              'https://cdns.klimg.com/mav-prod-resized/0x0/ori/newsOg/2024/6/7/1717747914308-0snos.jpeg',
                          productName: 'Nike Joyride CC3 Setter',
                          productPrice: '175.000',
                          screenSize: screenSize,
                          theme: theme,
                        ),
                        Container(
                          color: Colors.amber,
                          height: 500,
                          child: const Placeholder(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBar({required ThemeData theme}) {
    return ListTile(
      leading: Icon(
        Icons.search_rounded,
        color: theme.colorScheme.surface,
      ),
      title: Text(
        'Search...',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.surface,
        ),
      ),
      tileColor: theme.colorScheme.onSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () {
        print('search bar pressed');
      },
    );
  }

  Widget buildShopCard({
    required String productImage,
    required String productName,
    required String productPrice,
    required Size screenSize,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProductDetails(),
          ),
        );
      },
      child: Container(
        height: screenSize.width / 2,
        width: screenSize.width / 2.5,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.surface.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        productImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  productName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.surface,
                    fontWeight: FontWeight.w100,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  'Rp$productPrice',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.surface,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
