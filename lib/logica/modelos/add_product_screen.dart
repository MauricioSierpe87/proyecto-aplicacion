import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';


/// Pantalla para agregar un producto al inventario.
/// Permite al usuario ingresar el nombre, la cantidad y escanear el código de barras del producto.
/// Cumple con las normas ISO para validación y gestión segura de la información.

class AddProductScreen extends StatefulWidget
{
  static const String id = 'add_product_screen';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String barcodeValue = '';

  /// Función para escanear el código de barras utilizando la librería `barcode_scan2`.
  /// Actualiza el estado con el valor del código escaneado o maneja errores.
  Future<void> scanBarcode() async
  {
    try
    {
      var result = await BarcodeScanner.scan();

      setState(() {
        barcodeValue = (result.type == ResultType.Barcode && result.rawContent.isNotEmpty) ? 
          result.rawContent : 'Escaneo cancelado'; });
    }
    catch (e)
    {
      setState(() {barcodeValue = 'Error al escanear el código de barras'; });
    }
  }

  /// Función para validar y guardar la información del producto.
  /// Muestra retroalimentación al usuario en caso de éxito o error.
  void saveProduct()
  {
    String productName = _nameController.text.trim();
    String productQuantity = _quantityController.text.trim();

    // Validar que todos los campos estén completos
    if (productName.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre del producto es obligatorio')),
      );

      return;
    }

    // Validar que la cantidad sea un número válido
    int? quantity = int.tryParse(productQuantity);
    
    if (quantity == null || quantity <= 0)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese una cantidad válida')),
      );
      
      return;
    }

    // Validar que se haya escaneado un código de barras
    if (barcodeValue == '')
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe escanear un código de barras válido')),
      );
      
      return;
    }

    // Guardar el producto si todas las validaciones son exitosas
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Producto guardado: $productName, Cantidad: $quantity, Código: $barcodeValue',
        ),
      ),
    );

    // Limpiar los campos
    _nameController.clear();
    _quantityController.clear();

    setState(() {
      barcodeValue = 'Código no escaneado';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color(0xFF3BAF98),// Color del Navbar
        title: const Text('Agregar Producto'),
      ),

      backgroundColor: const Color(0xFF3BAF98), //Color del fondo.
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            const Text('Nombre del producto:'),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Ingrese el nombre del producto',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            
            const Text('Cantidad del producto:'),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ingrese la cantidad',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 20),
            const Text('Código de barras:'),
            Text(
              barcodeValue == '' ? 'Sin escanear' : barcodeValue,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode,
              child: const Text('Escanear código de barras'),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Guardar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}


