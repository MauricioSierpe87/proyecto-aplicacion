import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Pantalla del dashboard veterinario que se conecta con herramientas de Machine Learning.
/// Permite la visualización de:
/// - Atenciones mensuales.
/// - Entradas y salidas de productos.
/// - Gráficos de atenciones según enfermedades.

class DashboardVet extends StatefulWidget {
  static const String id = 'dashboardVet';

  @override
  _DashboardVetState createState() => _DashboardVetState();
}

class _DashboardVetState extends State<DashboardVet> {
  // Simulación de datos. Esto puede ser reemplazado por datos obtenidos de una API en la nube (DigitalOcean).
  final List<Map<String, dynamic>> monthlyVisits = [
    {'month': 'Enero', 'visits': 45},
    {'month': 'Febrero', 'visits': 60},
    {'month': 'Marzo', 'visits': 75},
    {'month': 'Abril', 'visits': 30},
    {'month': 'Mayo', 'visits': 50},
  ];

  final List<Map<String, dynamic>> productData = [
    {'type': 'Entrada', 'value': 150},
    {'type': 'Salida', 'value': 120},
  ];

  final List<Map<String, dynamic>> diseaseData = [
    {'disease': 'Parvovirus', 'cases': 20},
    {'disease': 'Moquillo', 'cases': 15},
    {'disease': 'Otitis', 'cases': 30},
    {'disease': 'Gastroenteritis', 'cases': 25},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3BAF98), // Color de Navbar
        title: const Text('Dashboard Veterinario'),
      ),
      backgroundColor: const Color(0xFF3BAF98), // Color del fondo
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gráfico de atenciones mensuales
              _buildSectionTitle('Atenciones Mensuales'),
              _buildMonthlyVisitsChart(),
              const SizedBox(height: 20),

              // Gráfico de entradas y salidas de productos
              _buildSectionTitle('Productos (Entradas vs Salidas)'),
              _buildProductChart(),
              const SizedBox(height: 20),

              // Gráfico de atenciones según enfermedades
              _buildSectionTitle('Atenciones por Enfermedades'),
              _buildDiseaseChart(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un título de sección.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Construye un gráfico de barras para las atenciones mensuales.
  Widget _buildMonthlyVisitsChart() {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: monthlyVisits
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value['visits'].toDouble(),
                      color: Colors.blue,
                    ),
                  ],
                ),
              )
              .toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  if (value >= 0 && value < monthlyVisits.length) {
                    return Text(monthlyVisits[value.toInt()]['month']);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construye un gráfico de pastel para las entradas y salidas de productos.
  Widget _buildProductChart() {
    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: productData.map((product) {
            return PieChartSectionData(
              title: '${product['type']}: ${product['value']}',
              value: product['value'].toDouble(),
              color: product['type'] == 'Entrada' ? Colors.green : Colors.red,
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Construye un gráfico de barras para las atenciones según enfermedades.
  Widget _buildDiseaseChart() {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: diseaseData
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value['cases'].toDouble(),
                      color: Colors.green,
                    ),
                  ],
                ),
              )
              .toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  if (value >= 0 && value < diseaseData.length) {
                    return Text(diseaseData[value.toInt()]['disease']);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
