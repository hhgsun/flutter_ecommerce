import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/widgets/product_gridview_comp.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(context: context, delegate: CustomSearchDelegate());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: colorPrimary),
        ),
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Row(
          children: [
            SizedBox(width: 5.0),
            Icon(Icons.search, color: colorPrimary),
            SizedBox(width: 15.0),
            Text('Ürün Araması Yapın')
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Arama terimi iki harften uzun olmalıdır.",
            ),
          )
        ],
      );
    }

    return StreamBuilder(
      stream: woocommerce.getProducts(search: query).asStream(),
      builder: (context, AsyncSnapshot<List<WooProduct>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data.length == 0) {
          return Center(child: Text("Sonuç Bulunamadı."));
        } else {
          var results = snapshot.data;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ProductGridviewComp(results),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arama"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
