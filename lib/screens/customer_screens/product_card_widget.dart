import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milkoride/models/cart_model.dart';
import 'package:milkoride/services/controllers.dart';
import 'package:get/get.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, this.snap}) : super(key: key);
  final snap;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final RxInt _quantity = 1.obs;
  String dropDownValue = 'Daily';
  var items = ['Daily', 'Alternate Days', 'Weekly'];

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.centerRight,
      margin: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height / 3.5,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
            widget.snap['productPicUrl'].toString(),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.snap['productName'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' Rs ' + widget.snap['productPrice'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' Per ' + widget.snap['productUnit'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  CartModel productCart = CartModel(
                    productId: widget.snap['productId'].toString(),
                    productName: widget.snap['productName'].toString(),
                    productImage: widget.snap['productPicUrl'].toString(),
                    productPrice: widget.snap['productPrice'],
                    productUnit: widget.snap['productUnit'].toString(),
                    cost:widget.snap['productPrice'] * _quantity.value,
                    quantity: _quantity,
                    orderType: widget.snap['orderType'].toString(),
                  );
                  cartController.addToCart(productCart);
                  cartController.cartPrice();
                },
                child: const Text(
                  'Add to cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    //isExpanded: true,
                    dropdownColor: Colors.red,
                    alignment: Alignment.center,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      );
                    }).toList(),
                    value: dropDownValue,
                    onChanged: (String? value) {
                      setState(() {
                        dropDownValue = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
