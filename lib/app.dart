import 'package:crud_app/product_list_screen.dart';
import 'package:flutter/material.dart';

class CrudApp extends StatelessWidget {
  const CrudApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud App',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),

          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),

          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),

          ),
          errorBorder:   OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),

          ),
          focusedErrorBorder:   OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),

          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(double.maxFinite),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
        )
      ),
      home: const ProductListScreen(),
    );
  }
}
