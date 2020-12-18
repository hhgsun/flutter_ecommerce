class CartItem {
  String key;
  String productId;
  String variationId;
  String quantity;
  String lineSubtotal;
  String lineSubtotalTax;
  String lineTotal;
  String lineTax;
  String productName;
  String productTitle;
  String productPrice;
  String productImage;
  String dataHash;
  Map data;
  Map lineTaxData;
  List variation;

  CartItem({
    this.key,
    this.productId,
    this.variationId,
    this.variation,
    this.quantity,
    this.dataHash,
    this.lineTaxData,
    this.lineSubtotal,
    this.lineSubtotalTax,
    this.lineTotal,
    this.lineTax,
    this.data,
    this.productName,
    this.productTitle,
    this.productPrice,
    this.productImage,
  });

  factory CartItem.fromJson(Map json) => CartItem(
        key: json['key'].toString(),
        productId: json['product_id'].toString(),
        variationId: json['variation_id'].toString(),
        quantity: json['quantity'].toString(),
        lineTaxData: json['line_tax_data'],
        lineSubtotal: json['line_subtotal'].toString(),
        lineSubtotalTax: json['line_subtotal_tax'].toString(),
        lineTotal: json['line_total'].toString(),
        lineTax: json['line_tax'].toString(),
        productName: json['product_name'].toString(),
        productTitle: json['product_title'].toString(),
        productPrice: json['product_price'].toString(),
        productImage: json['product_image'].toString(),
        dataHash: json['data_hash'],
        data: json['data'],
        variation: json['variation'],
      );
}
