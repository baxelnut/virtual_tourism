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

    const Color colorLight = Color(0xffEFFFFB);
    const Color colorDark = Color(0xff121212);

    // temporary
    const String loremIpsum =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?';

    return Scaffold(
      backgroundColor: colorLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: colorLight,
              ),
            ),
            backgroundColor: colorDark,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),
            title: const Text(
              "Shop",
              style: TextStyle(
                color: colorLight,
              ),
            ),
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
                  color: colorLight,
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
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorDark,
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
                          productDescription: loremIpsum,
                          screenSize: screenSize,
                          colorDark: colorDark,
                          colorLight: colorLight,
                          theme: theme,
                        ),
                        buildShopCard(
                          productImage:
                              'https://apollo.olx.co.id/v1/files/678ce09890ad9-ID/image;s=780x0;q=60',
                          productName: 'Mercedes-Benz C250 (2015)',
                          productPrice: '425.000.000',
                          productDescription: loremIpsum,
                          screenSize: screenSize,
                          colorDark: colorDark,
                          colorLight: colorLight,
                          theme: theme,
                        ),
                        buildShopCard(
                          productImage:
                              'https://cdns.klimg.com/mav-prod-resized/0x0/ori/newsOg/2024/6/7/1717747914308-0snos.jpeg',
                          productName: 'Nike Joyride CC3 Setter',
                          productPrice: '175.000',
                          productDescription: loremIpsum,
                          screenSize: screenSize,
                          colorDark: colorDark,
                          colorLight: colorLight,
                          theme: theme,
                        ),
                        buildShopCard(
                          productImage:
                              'https://cdns.klimg.com/mav-prod-resized/0x0/ori/newsOg/2024/6/7/1717747914308-0snos.jpeg',
                          productName: 'Nike Joyride CC3 Setter',
                          productPrice: '175.000',
                          productDescription: loremIpsum,
                          screenSize: screenSize,
                          colorDark: colorDark,
                          colorLight: colorLight,
                          theme: theme,
                        ),
                        Container(
                          color: Colors.amber,
                          height: 500,
                          child: const Placeholder(),
                        ),
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

  Widget searchBar({
    required ThemeData theme,
  }) {
    return ListTile(
      leading: const Icon(
        Icons.search_rounded,
        color: Color(0xff121212),
      ),
      title: Text(
        'Search...',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: const Color(0xff121212),
        ),
      ),
      tileColor: const Color(0xffEFFFFB),
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
    String? productDescription,
    required Size screenSize,
    required Color colorLight,
    required Color colorDark,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              productImage: productImage,
              productName: productName,
              productPrice: productPrice,
              productDescription: productDescription,
            ),
          ),
        );
      },
      child: Container(
        height: screenSize.width / 2,
        width: screenSize.width / 2.5,
        decoration: BoxDecoration(
          color: colorLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorDark.withOpacity(0.3),
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
                    color: colorDark,
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
                    color: colorDark,
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
