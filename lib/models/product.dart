class Product {
  String pId, pName, pPrice, pDescription, pCategory, pLocation;
  int pQuantity;
  Product({
    this.pId,
    this.pName,
    this.pPrice,
    this.pDescription,
    this.pCategory,
    this.pLocation,
    this.pQuantity,
  });

  @override
  bool operator ==(Object other) {
    return other is Product && this.pId == other.pId;
  }
}
