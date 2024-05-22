import 'dart:convert';
import 'package:crud_app/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProducts extends StatefulWidget {
  const UpdateProducts({super.key, required this.product});

  final ProductModel product;
  @override
  State<UpdateProducts> createState() => _UpdateProductsState();
}

class _UpdateProductsState extends State<UpdateProducts> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _unitEditingController = TextEditingController();
  final TextEditingController _quantityEditingController =
      TextEditingController();
  final TextEditingController _totalPriceEditingController =
      TextEditingController();
  final TextEditingController _imageEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameEditingController.text = widget.product.productName?? "";
    _productCodeController.text=widget.product.productCode??"";
    _unitEditingController.text = widget.product.unitPrice??'';
    _quantityEditingController.text= widget.product.quantity??"";
    _totalPriceEditingController.text=widget.product.totalPrice??"";
    _imageEditingController.text=widget.product.totalPrice??"";


  }

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
                  controller: _productCodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Product Code', labelText: 'Product Code'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Write  Product Code";
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
                  visible: _updateProductInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateProduct();
                      }
                    },
                    child: const Text("Update"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
Future<void> updateProduct () async{
    _updateProductInProgress = true;
    setState(() {});

    Map<String, String> inputData ={
      "Img": _imageEditingController.text,
      "ProductCode": _productCodeController.text,
      "ProductName": _nameEditingController.text,
      "Qty": _quantityEditingController.text,
      "TotalPrice": _totalPriceEditingController.text,
      "UnitPrice": _unitEditingController.text,
    };
    String updateProductUrl = "https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}";

    Uri uri =Uri.parse(updateProductUrl);
    Response response = await post(uri,
    body: jsonEncode(inputData),
    headers: {"content-type": "application/json"},
    );
    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("update Completed")));
      Navigator.pop(context,true);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("update failed")));
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
