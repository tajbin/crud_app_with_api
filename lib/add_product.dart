import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _productCodeEditingController = TextEditingController();
  final TextEditingController _unitEditingController = TextEditingController();
  final TextEditingController _quantityEditingController = TextEditingController();
  final TextEditingController _totalPriceEditingController = TextEditingController();
  final TextEditingController _imageEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewProductInProgress= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameEditingController,
                  decoration: const InputDecoration(
                      labelText: "Name", hintText: "Name"),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _productCodeEditingController,
                  decoration: const InputDecoration(
                      labelText: "Product Code", hintText: "Product Code"),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write Product Code';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                TextFormField(
                  controller: _unitEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Unit Price', labelText: 'Unit Price'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write  unit price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _quantityEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                    hintText: "quantity",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _totalPriceEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Total Price",
                    hintText: "Total Price",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write total price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                TextFormField(
                  controller: _imageEditingController,
                  decoration: const InputDecoration(
                    labelText: "Image",
                    hintText: "Image",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Give image';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                 visible: _addNewProductInProgress == false,
                  replacement: const Center(
                      child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addNewProduct();
                      }
                    },
                    child: const Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addNewProduct() async {
    const String addNewProductUrl =
        "https://crud.teamrabbil.com/api/v1/CreateProduct";
    final Map<String, dynamic> inputData = {
      "ProductName": _nameEditingController.text,
      "ProductCode": _productCodeEditingController.text,
      "Img": _imageEditingController.text,
      "UnitPrice": _unitEditingController.text,
      "Qty": _quantityEditingController.text,
      "TotalPrice": _totalPriceEditingController.text,
    };
    Uri uri = Uri.parse(addNewProductUrl);

    Response response = await post(
      uri,
      body: jsonEncode(inputData),
      headers: {"content-type": "application/json"},
    );
    print(response.statusCode);
    _addNewProductInProgress=false;
    setState(() {});
    if(response.statusCode==200){
      _nameEditingController.clear();
      _quantityEditingController.clear();
      _unitEditingController.clear();
      _productCodeEditingController.clear();
      _totalPriceEditingController.clear();
      _imageEditingController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New product added")));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add product failed")));
    }
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _unitEditingController.dispose();
    _quantityEditingController.dispose();
    _totalPriceEditingController.dispose();
    _imageEditingController.dispose();
    super.dispose();
  }
}
