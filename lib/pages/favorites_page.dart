import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/services/inherited_container.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favList = [];

  void getFavsLoad() {
    CustomApiService.getFavs().then((meta) {
      setState(() {
        favList = List.from(meta.value);
      });
    });
  }

  @override
  void initState() {
    getFavsLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Divider(height: 50),
        Text("Favs"),
        MaterialButton(
          child: Text("Kullanıcıyı göster"),
          onPressed: () {
            loggedInCustomer.metaData.forEach((element) {
              print(loggedInCustomer.id.toString() +
                  ' user ' +
                  element.key +
                  ': ' +
                  element.value.toString());
            });
          },
        ),
      ],
    );
  }
}
