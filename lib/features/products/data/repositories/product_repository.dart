import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<List<ProductModel>> getProducts({
    String? category,
    String? search,
  }) async {
    final queryParams = <String, String>{};
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _apiClient.get(
      ApiConstants.products,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );

    final productsJson = response['data']['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await _apiClient.get(ApiConstants.productById(id));
    return ProductModel.fromJson(
      response['data']['product'] as Map<String, dynamic>,
    );
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await _apiClient.post(
      ApiConstants.products,
      body: product.toJson(),
    );
    return ProductModel.fromJson(
      response['data']['product'] as Map<String, dynamic>,
    );
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await _apiClient.put(
      ApiConstants.productById(product.id!),
      body: product.toJson(),
    );
    return ProductModel.fromJson(
      response['data']['product'] as Map<String, dynamic>,
    );
  }

  Future<void> deleteProduct(int id) async {
    await _apiClient.delete(ApiConstants.productById(id));
  }
}
