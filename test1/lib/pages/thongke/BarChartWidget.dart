import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  BarChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    // Sắp xếp dữ liệu từ lớn đến nhỏ dựa trên numberOfVegetables

    return Scaffold(
      body: _buildChart(),
    );
  }

  Widget _buildChart() {
    List<charts.Series<Map<String, dynamic>, String>> series = [];

    // Tạo dữ liệu cho biểu đồ
    List<charts.Series<Map<String, dynamic>, String>> _createData() {
      // Sắp xếp dữ liệu theo chỉ số từ cao xuống thấp

      data.sort((a, b) => b['numberOfVegetables']!.compareTo(a['numberOfVegetables']!));

      final vegetablesSeries = charts.Series<Map<String, dynamic>, String>(
        id: 'Cây trồng',
        domainFn: (datum, _) => datum['diachi'] as String,
        measureFn: (datum, _) => datum['numberOfVegetables'] as int,
        data: data.reversed.toList(), // Sử dụng reversed ở đây
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (datum, _) => 'Vegetables: ${datum['numberOfVegetables']}',
      );

      final diseasesSeries = charts.Series<Map<String, dynamic>, String>(
        id: 'Dịch bệnh',
        domainFn: (datum, _) => datum['diachi'] as String,
        measureFn: (datum, _) => datum['totalNumberOfDiseases'] as int,
        data: data.reversed.toList(), // Sử dụng reversed ở đây
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        labelAccessorFn: (datum, _) => 'Diseases: ${datum['totalNumberOfDiseases']}',
      );

      return [vegetablesSeries, diseasesSeries];
    }

    series.addAll(_createData());

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [charts.SeriesLegend()],
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 60,
          labelAnchor: charts.TickLabelAnchor.centered,
        ),
      ),
    );
  }

}

