import 'package:bikerr/models/mileage.dart';
import 'package:bikerr/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Performance extends StatefulWidget {
  @override
  _PerformanceState createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  Mileage _mileage;
  TextEditingController _kmController;
  FocusNode _kmFocus;
  int kms = 0;

  @override
  void initState() {
    super.initState();
    _kmController = TextEditingController();
    _kmFocus = FocusNode();
  }

  @override
  void dispose() {
    _kmController.dispose();
    _kmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Performance',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      color: primary, letterSpacing: 2, fontFamily: 'Raleway'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Calculate Mileage',
                  style: TextStyle(
                      color: primary, fontFamily: 'Raleway', fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'So How much is your CC ?',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      letterSpacing: 1,
                      fontSize: 20,
                      color: secondary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Card(
                  child: DropdownButton<Mileage>(
                    value: _mileage,
                    elevation: 5,
                    dropdownColor: primary,
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_drop_down_circle_outlined),
                    ),
                    iconEnabledColor: primary,
                    items: Mileage.mileageList
                        .map((mileage) => DropdownMenuItem(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ListTile(
                                  title: Text(
                                    mileage.cc.toString() + " CC",
                                  ),
                                ),
                              ),
                              value: mileage,
                            ))
                        .toList(),
                    onChanged: (val) => setState(() {
                      _mileage = val;
                      FocusScope.of(context).requestFocus(_kmFocus);
                    }),
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text('Select CC of your vehicle'),
                    ),
                    underline: Container(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Enter KM',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      letterSpacing: 1,
                      fontSize: 20,
                      color: secondary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(_kmFocus),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: (_kmController.text.length * 25).toDouble(),
                        child: TextField(
                          cursorColor: secondary,
                          maxLength: 5,
                          controller: _kmController,
                          focusNode: _kmFocus,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "0",
                            counterText: "",
                          ),
                          onChanged: (_) => setState(() =>
                              kms = int.tryParse(_kmController.text) ?? 0),
                          onSubmitted: _handleKm,
                        ),
                      ),
                      SizedBox(width: _kmController.text.length == 0 ? 15 : 0),
                      Text(
                        'KM',
                        style: TextStyle(fontSize: 18, color: secondary),
                      )
                    ],
                  ),
                ),
              ),
              buildFuel()
            ],
          ),
        ),
      ),
    );
  }

  void _handleKm(String value) {
    FocusScope.of(context).unfocus();
  }

  Widget buildFuel() {
    double liters = (kms / _mileage.km).toDouble();
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: kms == 0 ? 0 : 200,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'You will need ',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    letterSpacing: 1,
                    fontSize: 20,
                    color: secondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    liters.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Ltr',
                    style: TextStyle(fontSize: 18, color: secondary),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
