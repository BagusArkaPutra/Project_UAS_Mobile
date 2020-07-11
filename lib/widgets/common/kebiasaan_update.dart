import 'package:flutter/material.dart';

class KebiasaanUpdate extends StatelessWidget {
  final Function() onEdit;
  final Function() onDelete;

  KebiasaanUpdate({this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: onEdit,
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 24,
          child: Divider(
            color: Colors.white,
            thickness: 1,
          ),
        ),
        GestureDetector(
          onTap: onDelete,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
