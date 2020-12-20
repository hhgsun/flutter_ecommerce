class CoCartItem {
  String key;
  int productId;
  int variationId;
  List variation;
  int quantity;
  String dataHash;
  Map lineTaxData;
  int lineSubtotal;
  int lineSubtotalTax;
  int lineTotal;
  int lineTax;
  Map data;
  String productName;
  String productTitle;
  String productPrice;
  String productImage;

  CoCartItem({
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

  factory CoCartItem.fromJson(Map<String, dynamic> json) => CoCartItem(
        key: json['key'],
        productId: json['product_id'],
        variationId: json['variation_id'],
        variation: json['variation'],
        quantity: json['quantity'],
        dataHash: json['dataHash'],
        lineTaxData: json['line_tax_data'],
        lineSubtotal: json['line_subtotal'],
        lineSubtotalTax: json['line_subtotal_tax'],
        lineTotal: json['line_total'],
        lineTax: json['line_tax'],
        data: json['data'],
        productName: json['product_name'],
        productTitle: json['product_title'],
        productPrice: json['product_price'],
        productImage: json['product_image'],
      );

  /* @override
  toString() => this.toJson().toString(); */
}
