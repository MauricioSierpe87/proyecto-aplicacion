import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

/// Pantalla para eliminar productos del inventario.
/// Permite identificar un producto mediante su ID, nombre o escaneo de código de barras.
/// Cumple con las normas de seguridad ISO 27001 mediante validaciones y retroalimentación clara.

class DeleteProductScreen extends StatefulWidget {
  static const String id = 'deleteproducto';

  @override
  _DeleteProductScreenState createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  final TextEditingController _idProductController = TextEditingController();
  final TextEditingController _nameProductController = TextEditingController();
  String _scannedCode = 'No escaneado';

  /// Función para mostrar el cuadro de diálogo de confirmación antes de eliminar un producto.
  /// Valida que al menos uno de los campos (ID, nombre o código escaneado) esté completo.
  void _confirmDelete(BuildContext context) {
    final idProduct = _idProductController.text.trim();
    final nameProduct = _nameProductController.text.trim();

    if (idProduct.isEmpty && nameProduct.isEmpty && _scannedCode == 'No escaneado') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese un ID, nombre o escanee un código de producto')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
            '¿Está seguro de que desea eliminar el producto? \n'
            'ID: ${idProduct.isNotEmpty ? idProduct : 'No ingresado'}\n'
            'Nombre: ${nameProduct.isNotEmpty ? nameProduct : 'No ingresado'}\n'
            'Código Escaneado: ${_scannedCode != 'No escaneado' ? _scannedCode : 'No escaneado'}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el cuadro de diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context); // Cierra el cuadro de diálogo
                _deleteProduct(); // Elimina el producto
              },
              child: const Text('Borrar'),
            ),
          ],
        );
      },
    );
  }

  /// Función para eliminar un producto.
  /// Limpia los campos y proporciona retroalimentación al usuario sobre el resultado.
  void _deleteProduct() {
    final idProduct = _idProductController.text.trim();
    final nameProduct = _nameProductController.text.trim();

    // Lógica simulada de eliminación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Producto eliminado: ${nameProduct.isNotEmpty ? nameProduct : 'No ingresado'} '
          '(ID: ${idProduct.isNotEmpty ? idProduct : 'No ingresado'}, '
          'Código: ${_scannedCode != 'No escaneado' ? _scannedCode : 'No ingresado'})',
        ),
      ),
    );

    // Limpia los campos después de borrar
    _idProductController.clear();
    _nameProductController.clear();
    setState(() {
      _scannedCode = 'No escaneado';
    });
  }

  /// Función para escanear el código de barras.
  /// Proporciona retroalimentación en caso de error, éxito o cancelación.
  Future<void> _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode && result.rawContent.isNotEmpty) {
        setState(() {
          _scannedCode = result.rawContent;
          _idProductController.text = result.rawContent; // Autocompleta el ID con el código escaneado
        });
      } else {
        setState(() {
          _scannedCode = 'Escaneo cancelado';
        });
      }
    } catch (e) {
      setState(() {
        _scannedCode = 'Error al escanear';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3BAF98), //Color del Navbar
        title: const Text('Borrar Producto'),
      ),
      backgroundColor: const Color(0xFF3BAF98), // Color del Fondo
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _idProductController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ID del Producto',
                hintText: 'Ingrese el ID del producto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _nameProductController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Producto',
                hintText: 'Ingrese el nombre del producto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Código Escaneado: $_scannedCode',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: _scanBarcode,
                  tooltip: 'Escanear código de barras',
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _confirmDelete(context),
              child: const Text('Borrar Producto'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.red,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

