import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  final DocumentSnapshot cityDoc;
  String name, imageUrl, imagePath;
  List<Location> locations = [];
  City(this.cityDoc) {
    Map<String, dynamic> locations, data = cityDoc.data();
    this.name = data['name'];
    this.imageUrl = data['image_url'];
    this.imagePath = data['image_path'];
    locations = data['locations'];
    locations?.forEach(
      (location, km) => this
          .locations
          .add(Location(name: location, imagePath: this.imagePath, km: km)),
    );
  }
}

class Location {
  final String name, imagePath;
  final int km;
  Location({this.name, this.imagePath, this.km});

  String get displayName {
    final words = this.name.split(' ');
    if (words.length == 1)
      return words.first.substring(0, 1).toUpperCase() +
          words.first.substring(1);
    else {
      var name = '';
      words.forEach((word) =>
          name += word.substring(0, 1).toUpperCase() + word.substring(1) + " ");
      return name;
    }
  }

  String get imageUrl =>
      this.imagePath + this.name.split(' ').first.toLowerCase() + '.jpg';
}
