import 'package:flutter/material.dart';
import 'package:bikerr/models/location.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:bikerr/utilities/constants.dart';

class CityDetails extends StatefulWidget {
  final City city;
  const CityDetails(this.city);
  @override
  _CityDetailsState createState() => _CityDetailsState();
}

class _CityDetailsState extends State<CityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              iconTheme: IconThemeData(color: secondary),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.city.name + 'image',
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: primary,
                      image: DecorationImage(
                        image: FirebaseImage(widget.city.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Hero(
                  tag: widget.city.name + 'title',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.city.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        color: secondary,
                        fontSize: 25,
                        fontFamily: 'Raleway',
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
              widget.city.locations
                  .map(
                    (location) => _buildLocation(location),
                  )
                  .toList(),
            ))
          ],
        ),
      ),
    );
  }

  Container _buildLocation(Location location) {
    try {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FirebaseImage(location.imageUrl),
                      fit: BoxFit.cover),
                ),
              ),
              ListTile(
                title: Text(
                  location.displayName,
                  style: TextStyle(color: secondary, fontSize: 18),
                ),
                trailing: Text(
                  '${location.km} KM',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print(location.name);
      print(e.toString());
      return Container();
    }
  }
}
