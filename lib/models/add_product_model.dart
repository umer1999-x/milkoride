

class AddProduct {
  String productId;
  String productAdderUid;
  String productName;
  int productPrice;
  String productType;
  String productUnit;
  String productPicUrl;

  AddProduct(
      {
        required this.productId,
        required this.productAdderUid,
      required this.productName,
      required this.productPrice,
      required this.productType,
      required this.productUnit,
      required this.productPicUrl,
      });

  Map<String, dynamic> toMap() {
    return {
      'productId':productId,
      'productAdderUid':productAdderUid,
      'productName': productName,
      'productPrice': productPrice,
      'productType': productType,
      'productUnit': productUnit,
      'productPicUrl': productPicUrl,
    };
  }

  
}
