class person {
  final double Price;
  final int age;
  final String description;
  final String id;
  String imageurl;
  final String name;
  final int personId;
  bool archiveStatus;
  final int ordersCompleted;

  person(this.Price, this.age, this.description, this.id, this.imageurl,
      this.name, this.personId, this.archiveStatus, this.ordersCompleted);
  Map<String, dynamic> toMap() {
    return {
      'Price': Price.toString(),
      'age': age,
      'archive': false,
      'completed_order': ordersCompleted,
      'description': description,
      'id': id,
      'imageurl': imageurl,
      'name': name,
      'personId': personId
    };
  }
}
