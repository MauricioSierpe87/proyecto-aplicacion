import 'package:flutter/material.dart';
import 'package:leufucadeapp/logica/modelos/dashboardVet.dart';
import 'package:leufucadeapp/logica/modelos/deleteproducto.dart';
import 'package:leufucadeapp/logica/common/str_util.dart';

import 'add_product_screen.dart';
import 'inventory.dart';
import 'loginpage.dart';

class MainMenu extends StatelessWidget {
  static const String id = 'main_menu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('𝓥𝓮𝓽𝓛𝓮𝓾𝓯𝓾𝓬𝓪𝓭𝓮'),
        actions: [
          // Botón de búsqueda
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _CustomSearchDelegate(),
              );
            },
          ),
          // Menú desplegable
          PopupMenuButton<String>(
            onSelected: (value) {
              _handleMenuSelection(context, value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'add_product',
                  child: Text('Ingresar Productos'),
                ),
                PopupMenuItem(
                  value: 'delete_product',
                  child: Text('Borrar Productos'),
                ),
                PopupMenuItem(
                  value: 'inventory',
                  child: Text('Inventario'),
                ),
                PopupMenuItem(
                  value: 'dashboard',
                  child: Text('Información'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Cerrar Sesión'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/a.jpg'),
                fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el fondo
              ),
            ),
          ),
          // Contenido principal
          GridView.count(
            padding: EdgeInsets.all(16.0),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildMenuOption(
                  context, 'Ingresar Productos', Icons.camera_alt, AddProductScreen.id),
              _buildMenuOption(
                  context, 'Borrar Productos', Icons.delete, DeleteProductScreen.id),
              _buildMenuOption(
                  context, 'Inventario', Icons.inventory, InventoryScreen.id),
              _buildMenuOption(
                  context, 'Información', Icons.dashboard, DashboardVet.id),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
      BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 251, 187, 187).withOpacity(0.8), // Color de fondo con opacidad
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepOrangeAccent),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black, // Cambiar color del texto
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'add_product':
        Navigator.pushNamed(context, AddProductScreen.id);
        break;
      case 'delete_product':
        Navigator.pushNamed(context, DeleteProductScreen.id);
        break;
      case 'inventory':
        Navigator.pushNamed(context, InventoryScreen.id);
        break;
      case 'dashboard':
        Navigator.pushNamed(context, DashboardVet.id);
        break;
      case 'logout':
        Navigator.pushReplacementNamed(context, LoginPage.id);
        break;
    }
  }
}

class _CustomSearchDelegate extends SearchDelegate {
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
    return Center(
      child: Text('Resultado para "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Sugerencia 1 para "$query"'),
        ),
        ListTile(
          title: Text('Sugerencia 2 para "$query"'),
        ),
      ],
    );
  }
}
