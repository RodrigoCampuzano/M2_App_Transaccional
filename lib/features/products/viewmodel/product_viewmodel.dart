import 'package:flutter/foundation.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository;

  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  String? _selectedCategory;
  String _searchQuery = '';

  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  ProductViewModel({required ProductRepository repository})
    : _repository = repository;

  Future<void> loadProducts() async {
    _setLoading(true);
    _clearError();

    try {
      _products = await _repository.getProducts(
        category: _selectedCategory,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _setLoading(false);
    } catch (e) {
      _setError(_parseError(e));
      _setLoading(false);
    }
  }

  Future<void> loadProductById(int id) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedProduct = await _repository.getProductById(id);
      _setLoading(false);
    } catch (e) {
      _setError(_parseError(e));
      _setLoading(false);
    }
  }

  Future<bool> createProduct(ProductModel product) async {
    _setLoading(true);
    _clearError();

    try {
      final newProduct = await _repository.createProduct(product);
      _products.insert(0, newProduct); // Agregar al inicio de la lista
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedProduct = await _repository.updateProduct(product);

      final index = _products.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      if (_selectedProduct?.id == updatedProduct.id) {
        _selectedProduct = updatedProduct;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);

      if (_selectedProduct?.id == id) {
        _selectedProduct = null;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      _setLoading(false);
      return false;
    }
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    loadProducts();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadProducts();
  }

  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    loadProducts();
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  String _parseError(dynamic error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring(11);
    }
    return message;
  }
}
