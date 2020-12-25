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

class CoCartTotals {
  String subtotal;
  String subtotalTax;
  String shippingTotal;
  String shippingTax;
  List shippingTaxes;
  String discountTotal;
  String discountTax;
  String cartContentsTotal;
  String cartContentsTax;
  List cartContentsTaxes;
  String feeTotal;
  String feeTax;
  List feeTaxes;
  String total;
  String totalTax;

  CoCartTotals({
    this.subtotal,
    this.subtotalTax,
    this.shippingTotal,
    this.shippingTax,
    this.shippingTaxes,
    this.discountTotal,
    this.discountTax,
    this.cartContentsTaxes,
    this.cartContentsTax,
    this.cartContentsTotal,
    this.feeTax,
    this.feeTaxes,
    this.feeTotal,
    this.total,
    this.totalTax,
  });

  factory CoCartTotals.fromJson(Map json) => CoCartTotals(
    shippingTax: json['shipping_tax'],
    shippingTaxes: json['shipping_taxes'],
    total: json['total'],
    totalTax: json['total_tax'],
    discountTax: json['discount_tax'],
    discountTotal: json['discount_total'],
    cartContentsTax: json['cart_contents_tax'],
    cartContentsTotal: json['cart_contents_total'],
    cartContentsTaxes: json['cart_contents_taxes'],
    feeTax: json['fee_tax'],
    feeTaxes: json['fee_taxes'],
    feeTotal: json['fee_total'],
    shippingTotal: json['shipping_total'],
    subtotal: json['subtotal'],
    subtotalTax: json['subtotal_tax'],
  );
}
