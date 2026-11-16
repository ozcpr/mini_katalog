import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

/// Ana sayfa: banner, arama, kategori filtresi ve ürün listesi (GridView).
class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  String _searchText = '';
  String _selectedCategory = 'Tümü';

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.loadProducts();
  }

  // Arama metni ve seçili kategoriye göre ürünleri süzer
  List<Product> _filterProducts(List<Product> products) {
    return products.where((product) {
      final bool matchesCategory =
          _selectedCategory == 'Tümü' || product.category == _selectedCategory;
      final bool matchesSearch =
          product.name.toLowerCase().contains(_searchText.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F4EF),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Keşfet', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Sana uygun ürünü bul',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: const [CartIconButton(), SizedBox(width: 8)],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Ürünler yüklenemedi.'));
          }

          final List<Product> allProducts = snapshot.data!;
          final List<String> categories = [
            'Tümü',
            ...allProducts.map((product) => product.category).toSet(),
          ];
          final List<Product> visibleProducts = _filterProducts(allProducts);

          return Column(
            children: [
              // Arama kutusu
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  onChanged: (value) => setState(() => _searchText = value),
                  decoration: InputDecoration(
                    hintText: 'Ürün ara...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Banner görseli
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/banner.png',
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Kategori filtreleri
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final String category = categories[index];
                    return ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = category);
                      },
                    );
                  },
                ),
              ),
              // Ürün listesi
              Expanded(
                child: visibleProducts.isEmpty
                    ? const Center(child: Text('Aramana uygun ürün bulunamadı.'))
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: visibleProducts.length,
                        itemBuilder: (context, index) {
                          final Product product = visibleProducts[index];
                          return ProductCard(
                            product: product,
                            // Ürün, detay sayfasına Route Arguments ile gönderilir
                            onTap: () => Navigator.pushNamed(
                              context,
                              ProductDetailScreen.routeName,
                              arguments: product,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
