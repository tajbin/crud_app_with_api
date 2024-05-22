import 'dart:convert';
import 'package:crud_app/add_product.dart';
import 'package:crud_app/product_model.dart';
import 'package:crud_app/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _getProductListInProgress = false;
  List<ProductModel> productList=[];
  @override
  void initState() {
  _getProductList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Product List"),
      ),
      body: RefreshIndicator(
        onRefresh: _getProductList,
        child: Visibility(
          visible: _getProductListInProgress == false,
          replacement: const Center(
              child: CircularProgressIndicator(),
          ),
          child: ListView.separated(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return _buildProductItem(productList[index]);
              },
              separatorBuilder: (_, __) => const Divider()
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>const AddProduct()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductItem(ProductModel productItem) {
    return ListTile(
            //leading: Image.network(
                //"https://static-01.daraz.com.bd/p/d8e5e50b4673c77bcd8c4e619bc47da4.jpg_750x750.jpg_.webp"),
            title: Text(productItem.productName?? "Unknown"),
            subtitle:  Wrap(
              children: [
                Text("Unit Price: ${productItem.unitPrice}  "),
                Text("Quantity: ${productItem.quantity}  "),
                Text("Total Price: ${productItem.totalPrice}"),
              ],
            ),
            trailing: Wrap(children: [
              IconButton(
                onPressed: () async{

               final result = await Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> UpdateProducts(
                        product: productItem,
                      )
                       ));
               if(result == true){
                 _getProductList();
               }
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                _showDeleteConfirmationDialog(productItem.id!);
                },
                icon: const Icon(Icons.delete),
              )
            ]),
          );
  }
  
  Future<void> _getProductList() async{
 _getProductListInProgress = true;
 setState(() {});
 productList.clear();
 const String productListUrl ="https://crud.teamrabbil.com/api/v1/ReadProduct";

 Uri uri = Uri.parse(productListUrl);

 Response response = await get(uri);
 print(response.statusCode);

 if(response.statusCode == 200){
   final decodeData = jsonDecode(response.body);
   final jsonProductList = decodeData["data"];
   for(Map<String, dynamic> json in jsonProductList){
     ProductModel productModel = ProductModel.fromJson(json);
     productList.add(productModel);
   }
 }else{
   ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text("Get Product Failed, Try again")));
 }
 _getProductListInProgress = false;
 setState(() {});
}
 void _showDeleteConfirmationDialog(String productId){
    showDialog(context: context,
        builder: (context){
      return AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are You Sure that you want to delete this product?"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Cancel")),
          TextButton(onPressed: (){
            _deleteProduct(productId);
            Navigator.pop(context);
          }, child: const Text("Yes, Delete"))
        ],
      );
        });
 }
  Future<void> _deleteProduct(String productId) async{
    _getProductListInProgress=true;
    setState(() {});

    String deleteProductUrl = "https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId";
    Uri uri = Uri.parse(deleteProductUrl);
    Response response = await get(uri);

    if(response.statusCode == 200){
      _getProductList();
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
              content: Text("Delete Success")));
    }else{
      _getProductListInProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
              content: Text("Delete Failed. Try again")));
    }

  }

}
