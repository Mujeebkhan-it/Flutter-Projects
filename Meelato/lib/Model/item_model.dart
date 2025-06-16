class Item {
  int? id;
  String name;
  String price;
  String description;
  String imagePath;

  Item({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imagePath': imagePath,
    };
  }
}
