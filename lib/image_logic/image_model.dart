class ImageModel {
  final int id;
  final String name;
  final String image;

  ImageModel(this.id, this.name, this.image);

  ImageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};
}
