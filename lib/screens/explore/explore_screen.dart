import 'package:bikerr/models/location.dart';
import 'package:bikerr/services/database.dart';
import 'package:bikerr/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

import 'city_details.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService.explore.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return loader();
            List<City> cities =
                snapshot.data.docs.map((doc) => City(doc)).toList();
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Explore',
                    style: Theme.of(context).textTheme.headline3.copyWith(
                        color: primary,
                        letterSpacing: 2,
                        fontFamily: 'Raleway'),
                  ),
                ),
                ...cities.map(
                  (city) => Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CityDetails(city),
                            fullscreenDialog: true,
                          ),
                        ),
                        child: Card(
                          elevation: 5,
                          shadowColor: primary,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              Hero(
                                tag: city.name + 'image',
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FirebaseImage(city.imageUrl),
                                        colorFilter: ColorFilter.mode(
                                            Colors.black38, BlendMode.darken),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Hero(
                                  tag: city.name + 'title',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      city.name,
                                      style: TextStyle(
                                        color: Colors.tealAccent[100],
                                        fontWeight: FontWeight.w100,
                                        fontSize: 25,
                                        fontFamily: 'Raleway',
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.tealAccent[100],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
