import 'package:flutter/material.dart';
import 'logica/modelos/inventory.dart';
import 'logica/modelos/loginpage.dart';
import 'logica/modelos/add_product_screen.dart';
import 'logica/modelos/main_menu.dart';
import 'logica/modelos/register_screen.dart';
import 'logica/modelos/deleteproducto.dart';
import 'logica/modelos/dashboardVet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        RegisterScreen.id: (context) => RegisterScreen(),
        MainMenu.id: (context) => MainMenu(),
        AddProductScreen.id: (context) => AddProductScreen(),
        DeleteProductScreen.id: (context) => DeleteProductScreen(),
        InventoryScreen.id: (context) => InventoryScreen(),
        DashboardVet.id: (context) => DashboardVet(),
      },
    );
  }
}

