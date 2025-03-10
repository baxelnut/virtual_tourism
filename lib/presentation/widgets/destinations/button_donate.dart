import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ButtonDonate extends StatefulWidget {
  final Map<String, dynamic> destinationData;
  const ButtonDonate({
    super.key,
    required this.destinationData,
  });

  @override
  State<ButtonDonate> createState() => _ButtonDonateState();
}

class _ButtonDonateState extends State<ButtonDonate> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _donationController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  String _selectedCurrency = 'IDR';

  final List<Map<String, String>> _currencyList = [
    {'code': 'IDR', 'label': 'Indonesian Rupiah'},
    {'code': 'USD', 'label': 'US Dollar'},
    {'code': 'GBP', 'label': 'British Pound'},
    {'code': 'EUR', 'label': 'Euro'},
  ];

  NumberFormat _getCurrencyFormat() {
    switch (_selectedCurrency) {
      case 'IDR':
        return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
      case 'USD':
        return NumberFormat.currency(
            locale: 'en_US', symbol: '\$', decimalDigits: 0);
      case 'GBP':
        return NumberFormat.currency(
            locale: 'en_GB', symbol: '£', decimalDigits: 0);
      case 'EUR':
        return NumberFormat.currency(
            locale: 'en_IE', symbol: '€', decimalDigits: 0);
      default:
        return NumberFormat.currency(
            locale: 'en_US', symbol: _selectedCurrency, decimalDigits: 0);
    }
  }

  _getImageProvider() {
    const invalidPhotoURLs = {
      'assets/profile.png',
      'not provided',
      'gs://virtual-tourism-7625f.appspot.com/users/.default/profile.png',
      'users/.default/profile.png',
    };

    if (user?.photoURL != null && !invalidPhotoURLs.contains(user?.photoURL)) {
      return NetworkImage(user!.photoURL!);
    } else {
      return const AssetImage('assets/profile.png');
    }
  }

  @override
  void dispose() {
    _donationController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 8, bottom: 12),
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Donate to ${widget.destinationData['destinationName'] ?? 'Unknown'}",
                        style: theme.textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _donationController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter amount',
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                              ),
                              style: theme.textTheme.headlineSmall,
                              onChanged: (value) {
                                final numericString =
                                    value.replaceAll(RegExp(r'[^\d]'), '');
                                if (numericString.isEmpty) return;
                                final int? number = int.tryParse(numericString);
                                if (number != null) {
                                  final formatted =
                                      _getCurrencyFormat().format(number);
                                  _donationController.value = TextEditingValue(
                                    text: formatted,
                                    selection: TextSelection.collapsed(
                                      offset: formatted.length,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: _selectedCurrency,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedCurrency = newValue;
                                  final numericString = _donationController.text
                                      .replaceAll(RegExp(r'[^\d]'), '');
                                  if (numericString.isNotEmpty) {
                                    final int? number =
                                        int.tryParse(numericString);
                                    if (number != null) {
                                      final formatted =
                                          _getCurrencyFormat().format(number);
                                      _donationController.text = formatted;
                                    }
                                  }
                                });
                              }
                            },
                            items: _currencyList.map((currency) {
                              return DropdownMenuItem<String>(
                                value: currency['code'],
                                child: Text(currency['label']!),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: _getImageProvider(),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            user?.displayName ?? 'username',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        subtitle: TextField(
                          controller: _commentController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          style: theme.textTheme.bodyMedium,
                          maxLines: 6,
                          onChanged: (value) {
                            final numericString =
                                value.replaceAll(RegExp(r'[^\d]'), '');
                            if (numericString.isEmpty) return;
                            final int? number = int.tryParse(numericString);
                            if (number != null) {
                              final formatted =
                                  _getCurrencyFormat().format(number);
                              _donationController.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                  offset: formatted.length,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width,
                        child: ElevatedButton(
                          onPressed: () {
                            final donationAmount =
                                _donationController.text.trim();
                            final comment = _commentController.text.trim();
                            print('DONATED: $donationAmount');
                            print('COMMENT: $comment');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                          ),
                          child: Text(
                            'Donate',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
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
              Icons.attach_money_outlined,
              size: 20,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(width: 5),
            Text(
              'Donate',
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
