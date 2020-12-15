import 'package:ecommerceapp/services/inherited_container.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Column(
            children: BaseContainer.of(context)
                .data
                .favs
                .map((pid) => ListTile(
                      title: Text(pid.toString()),
                    ))
                .toList(),
          ),
          MaterialButton(
            child: Text("ekle fav"),
            onPressed: () => BaseContainer.of(context).data.addFav("4"),
          ),
          Divider(height: 50),
          MaterialButton(
            child: Text("sil fav"),
            onPressed: () => BaseContainer.of(context).data.deleteFav("4"),
          ),
        ],
      ),
    );
  }
}
