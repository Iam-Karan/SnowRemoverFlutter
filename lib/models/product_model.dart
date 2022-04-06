class ProductModel {
  final String brand;
  final String name;
  final String description;
  String mainImage;
  final double priceNumerical;
  final int selfId;
  final String type;
  final int stockUnit;
  final String videoURL;
  final String imageURL;
  final String id;
  bool archiveStatus;

  ProductModel(
      this.brand,
      this.name,
      this.description,
      this.mainImage,
      this.priceNumerical,
      this.selfId,
      this.type,
      this.stockUnit,
      this.videoURL,
      this.imageURL,
      this.id,
      this.archiveStatus);

  Map<String, dynamic> toMap() {
    return {
      'archive': false,
      'brand': brand,
      'description': description,
      'main_image': mainImage,
      'name': name,
      'price_numerical': priceNumerical.toString(),
      'self_id': selfId,
      'stock_unit': stockUnit,
      'type': type,
      'video_url': videoURL,
    };
  }
}
