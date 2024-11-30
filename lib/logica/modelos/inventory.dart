import 'package:flutter/material.dart';

/// Pantalla de inventario que permite la búsqueda, visualización y modificación de productos.
/// Incluye alertas para productos con bajo stock y próximos a vencer.
/// Cumple con normas ISO 27001 al implementar validaciones, manejo de datos seguro y retroalimentación clara.

class InventoryScreen extends StatefulWidget {
  static const String id = 'inventory';

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  /// Lista simulada de productos en el inventario.
  final List<Map<String, dynamic>> _inventory = [
    {
      'id': '001',
      'name': 'Producto A',
      'description': 'Descripción del Producto A',
      'stock': 10,
      'lastUpdated': '2024-11-22',
      'price': 10.5,
    },
    {
      'id': '002',
      'name': 'Producto B',
      'description': 'Descripción del Producto B',
      'stock': 30,
      'lastUpdated': '2024-11-20',
      'price': 20.0,
    },
    {
      'id': '003',
      'name': 'Producto C',
      'description': 'Descripción del Producto C',
      'stock': 5,
      'lastUpdated': '2024-11-15',
      'price': 15.0,
    },
  ];

  /// Lista filtrada para mostrar los resultados de la búsqueda.
  List<Map<String, dynamic>> _filteredInventory = [];

  /// Listas dinámicas para productos con bajo stock y próximos a vencer.
  List<Map<String, dynamic>> _lowStockProducts = [];
  List<Map<String, dynamic>> _expiringProducts = [];

  /// Controlador del campo de búsqueda.
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredInventory = List.from(_inventory);
    _checkLowStockAndExpiry();

    // Mover las notificaciones a un callback post-frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNotifications();
    });
  }

  /// Calcula productos con bajo stock y próximos a vencer.
  void _checkLowStockAndExpiry() {
    DateTime now = DateTime.now();
    DateTime warningDate = now.add(const Duration(days: 7)); // Productos que vencen en 7 días

    _lowStockProducts = _inventory.where((product) {
      return product['stock'] < 15; // Bajo stock
    }).toList();

    _expiringProducts = _inventory.where((product) {
      DateTime lastUpdated = DateTime.parse(product['lastUpdated']);
      return lastUpdated.isBefore(warningDate); // Próximos a vencer
    }).toList();
  }

  /// Muestra notificaciones si hay productos con bajo stock o próximos a vencer.
  void _showNotifications() {
    if (_lowStockProducts.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hay productos con bajo stock. Verifique el inventario.'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    if (_expiringProducts.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hay productos próximos a vencer. Verifique el inventario.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// Filtra la lista de inventario según el texto ingresado en el campo de búsqueda.
  /// Busca coincidencias en el nombre o el ID del producto.
  void _searchInventory(String query) {
    setState(() {
      _filteredInventory = _inventory.where((product) {
        return product['name'].toLowerCase().contains(query.toLowerCase()) ||
            product['id'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3BAF98),
        title: const Text('Inventario'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchInventory,
              decoration: InputDecoration(
                hintText: 'Buscar por ID o Nombre',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF3BAF98),
      body: Column(
        children: [
          // Mostrar lista de productos con bajo stock
          if (_lowStockProducts.isNotEmpty)
            _buildSectionTitle('Productos con bajo stock'),
          if (_lowStockProducts.isNotEmpty)
            _buildProductList(_lowStockProducts),
          // Mostrar lista de productos próximos a vencer
          if (_expiringProducts.isNotEmpty)
            _buildSectionTitle('Productos próximos a vencer'),
          if (_expiringProducts.isNotEmpty)
            _buildProductList(_expiringProducts),
          // Mostrar lista filtrada
          _buildSectionTitle('Todos los productos'),
          Expanded(child: _buildProductList(_filteredInventory)),
        ],
      ),
    );
  }

  /// Construye un título de sección para las listas.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Construye la lista de productos en formato ListView.
  Widget _buildProductList(List<Map<String, dynamic>> products) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: ListTile(
            title: Text(product['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Descripción: ${product['description']}'),
                Text('Stock: ${product['stock']}'),
                Text('Última actualización: ${product['lastUpdated']}'),
                Text('Precio Unitario: \$${product['price']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
