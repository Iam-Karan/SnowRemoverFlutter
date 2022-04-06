class cartModel {
  String? uid;
  String? image;
  String? name;
  String? quantity;
  String? type;

  cartModel({
    this.uid,
    this.image,
    this.name,
    this.quantity,
    this.type,
  });


  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'name': name,
      'image': image ,
      'quantity': quantity,
      'type': type,
    };
  }


}