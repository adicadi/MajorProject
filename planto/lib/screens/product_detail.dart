import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:planto/Model/product_provider.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final stockedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(stockedProduct.title),
        shadowColor: Colors.transparent,
        backgroundColor: HexColor('e2ffec'),
        foregroundColor: HexColor('145E2E'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                stockedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${stockedProduct.price}',
              style: Theme.of(context).textTheme.headline1,
            ),
            Divider(
              indent: 10,
              thickness: 2,
              color: HexColor('145E2E'),
              endIndent: 10,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                stockedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}