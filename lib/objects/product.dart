class Product {
  String name = "";
  String description = "";
  int price = 0;

  Product({
    required this.name,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['name'],
        description: json['description'],
        price: json['price']);
  }

  Map<String, dynamic> toJson() =>
      {"name": this.name, "description": this.description, "price": this.price};
}
