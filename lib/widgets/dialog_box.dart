import 'package:bikerr/utilities/constants.dart';
import 'package:flutter/material.dart';

class DialogBox extends StatefulWidget {
  final String title, description, buttonText1, buttonText2;
  final Function button1Func, button2Func;
  final IconData icon;
  final Color iconColor;
  final Color titleColor;
  final Color btn1Color;
  final Color btn2Color;
  const DialogBox({
    Key key,
    @required this.title,
    @required this.description,
    this.buttonText1,
    this.button1Func,
    this.buttonText2,
    this.button2Func,
    this.icon,
    this.iconColor,
    this.titleColor,
    this.btn1Color,
    this.btn2Color,
  }) : super(key: key);
  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.only(
                    top: widget.icon == null ? 30.0 : 60, left: 10, right: 10),
                decoration: new BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: widget.titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    if (widget.description != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 25.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          widget.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    if (widget.buttonText1 != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                splashColor: primary,
                                onPressed: widget.button1Func,
                                child: Text(
                                  widget.buttonText1,
                                  style: TextStyle(
                                    color: widget.buttonText2 == null
                                        ? primary
                                        : widget.btn1Color,
                                  ),
                                ),
                              ),
                            ),
                            if (widget.buttonText2 != null)
                              Expanded(
                                child: FlatButton(
                                  splashColor: primary,
                                  onPressed: widget.button2Func,
                                  child: Text(
                                    widget.buttonText2,
                                    style: TextStyle(color: widget.btn2Color),
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            if (widget.icon != null)
              Positioned(
                top: 0,
                child: CircleAvatar(
                  backgroundColor:
                      widget.iconColor != null ? widget.iconColor : Colors.teal,
                  child: Icon(
                    widget.icon,
                    size: 60.0,
                    color: Colors.white,
                  ),
                  radius: 35,
                ),
              )
          ],
        ),
      ),
    );
  }
}
