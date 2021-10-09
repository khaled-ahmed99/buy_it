import 'package:buy_it/constants.dart';
import 'package:buy_it/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static void addProduct(Product product) {
    _firestore.collection(kProductsCollection).add({
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductDescription: product.pDescription,
      kProductCategory: product.pCategory,
      kProductLocation: product.pLocation,
    });
  }

  static Stream<QuerySnapshot> loadProducts() {
    return _firestore.collection(kProductsCollection).snapshots();
  }

  static void deleteProduct(String id) {
    _firestore.collection(kProductsCollection).doc(id).delete();
  }

  static void editProduct(String pId, Map<String, String> editedProduct) {
    _firestore.collection(kProductsCollection).doc(pId).update(editedProduct);
  }

  static Future<void> storeOrders(
      Map<String, dynamic> data, List<Product> products) async {
    var doc = _firestore.collection(kOrders).doc();
    await doc.set(data);
    for (Product product in products)
      doc.collection(kOrderDetails).add({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductQuantity: product.pQuantity,
        kProductLocation: product.pLocation,
        kProductCategory: product.pCategory,
      });
  }

  static Stream<QuerySnapshot> loadOrders() {
    return _firestore.collection(kOrders).snapshots();
  }

  static Stream<QuerySnapshot> loadOrderDetails(String id) {
    return _firestore
        .collection(kOrders)
        .doc(id)
        .collection(kOrderDetails)
        .snapshots();
  }

  static void deleteOrder(String id) {
    _firestore.collection(kOrders).doc(id).delete();
  }
}
