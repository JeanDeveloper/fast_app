import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class modalBottom {
  void showModalBottom(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.link),
                title: new Text('Get link'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.edit),
                title: new Text('Edit name'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Delete Collection'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
