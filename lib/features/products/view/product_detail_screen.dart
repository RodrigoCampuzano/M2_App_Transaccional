import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/product_viewmodel.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().loadProductById(widget.productId);
    });
  }

  Color _getStockColor(int stock) {
    if (stock <= 0) return Colors.red;
    if (stock <= 10) return Colors.orange;
    return Colors.green;
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electrónica':
        return Icons.devices_rounded;
      case 'ropa':
        return Icons.checkroom_rounded;
      case 'alimentos':
        return Icons.restaurant_rounded;
      case 'hogar':
        return Icons.home_rounded;
      case 'deportes':
        return Icons.sports_basketball_rounded;
      case 'salud':
        return Icons.health_and_safety_rounded;
      case 'tecnología':
        return Icons.computer_rounded;
      case 'juguetes':
        return Icons.toys_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Consumer<ProductViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.selectedProduct == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = vm.selectedProduct;
          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  const Text('Producto no encontrado'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cs.primaryContainer, cs.secondaryContainer],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getCategoryIcon(product.category),
                        size: 100,
                        color: cs.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductFormScreen(product: product),
                        ),
                      );
                      if (result == true && mounted) {
                        vm.loadProductById(widget.productId);
                      }
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y precio
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: cs.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Info cards
                      Row(
                        children: [
                          Expanded(
                            child: _infoCard(
                              context,
                              Icons.category_rounded,
                              'Categoría',
                              product.category,
                              cs,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoCard(
                              context,
                              Icons.inventory_rounded,
                              'Stock',
                              '${product.stock} unidades',
                              cs,
                              valueColor: _getStockColor(product.stock),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Descripción
                      Text(
                        'Descripción',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.description.isNotEmpty
                              ? product.description
                              : 'Sin descripción disponible.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Fechas
                      if (product.createdAt != null)
                        ListTile(
                          leading: Icon(
                            Icons.calendar_today_rounded,
                            color: cs.primary,
                          ),
                          title: const Text('Fecha de creación'),
                          subtitle: Text(product.createdAt!),
                          contentPadding: EdgeInsets.zero,
                        ),
                      if (product.updatedAt != null)
                        ListTile(
                          leading: Icon(
                            Icons.update_rounded,
                            color: cs.secondary,
                          ),
                          title: const Text('Última actualización'),
                          subtitle: Text(product.updatedAt!),
                          contentPadding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    ColorScheme cs, {
    Color? valueColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: cs.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
