import 'package:flutter/material.dart';
import 'BarChartWidget.dart';
import 'get_users.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class YourScreen extends StatefulWidget {
  @override
  _YourScreenState createState() => _YourScreenState();
}
List<Widget> buildUniqueDiseaseWidgets(List<dynamic> diseasesData) {
  List<String> uniqueDiseases = diseasesData
      .map((disease) => disease['tendichbenh'] as String)
      .toSet()
      .toList();

  return uniqueDiseases
      .map((uniqueDisease) => Text('Tên dịch bệnh: $uniqueDisease'))
      .toList();
}
class _YourScreenState extends State<YourScreen> {
  late Future<List<Map<String, dynamic>>> userData;

  @override
  void initState() {
    super.initState();
    // Gọi hàm lấy dữ liệu ở đây
    userData = getAllUserData();
    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biểu đồ cột thống kê theo địa điểm'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[200],
              ),
              margin: const EdgeInsets.all(1.0),
              padding: const EdgeInsets.all(5.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: userData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    return BarChartWidget(data: snapshot.data!);
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey[200],
                    ),
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(5.0),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: userData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('Không có sẵn dữ liệu'));
                        } else {
                          // Accessing data from snapshot.data
                          List<Map<String, dynamic>>? userData = snapshot.data;

                          Map<String, dynamic>? highestDiachiData =
                              userData!.isNotEmpty ? userData.first : null;

                          if (highestDiachiData == null) {
                            return const Center(
                              child: Text(
                                  'Không có dữ liệu có sẵn cho địa chỉ cao nhât.'),
                            );
                          }

                          // Lấy thông tin về các cây và số lượng dịch bệnh tương ứng từ dữ liệu diachi cao nhất
                          List<Map<String, dynamic>> treeData =
                              highestDiachiData['userData'];
                          treeData.sort((a, b) => b['numberOfDiseases'].compareTo(a['numberOfDiseases']));
                          // Tạo series cho biểu đồ mới
                          final treeSeries =

                              charts.Series<Map<String, dynamic>, String>(
                            id: 'Dich bệnh',
                            domainFn: (datum, _) => datum['vegetableData']
                                ['tenvegetable'] as String,
                            measureFn: (datum, _) =>
                                datum['numberOfDiseases'] as int,
                            data: treeData,
                            colorFn: (_, __) =>
                                charts.MaterialPalette.red.shadeDefault,
                            labelAccessorFn: (datum, _) =>
                                'Diseases: ${datum['diseasesData']['tendichbenh']}',
                          );

                          // Tạo danh sách series cho biểu đồ
                          final seriesList = [treeSeries];
                          return Scaffold(
                            body: charts.BarChart(

                              seriesList,
                              animate: true,
                              barGroupingType: charts.BarGroupingType.grouped,
                              behaviors: [charts.SeriesLegend()],
                              domainAxis: const charts.OrdinalAxisSpec(
                                renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 60,
                                  labelAnchor: charts.TickLabelAnchor.centered,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey[200],
                    ),
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(5.0),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: userData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No data available'));
                        } else {
                          List<Map<String, dynamic>>? userData = snapshot.data;
                          Map<String, dynamic>? highestDiachiData =
                          userData!.isNotEmpty ? userData.first : null;

                          if (highestDiachiData != null) {
                            List<dynamic> userData = highestDiachiData['userData'];

                            List<Widget> widgets = [];
                            for (var data in userData) {
                              String tenVegetable = data['vegetableData']['tenvegetable'];
                              List<dynamic> diseasesData = data['diseasesData'];

                              if (diseasesData.isNotEmpty) {
                                widgets.add(ListTile(
                                  title: Text('Tên cây trồng: $tenVegetable'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: buildUniqueDiseaseWidgets(diseasesData),
                                  ),
                                ));
                              } else {
                                widgets.add(ListTile(
                                  title: Text('Tên cây trồng: $tenVegetable'),
                                  subtitle: const Text('Không có dữ liệu về dịch bệnh'),
                                ));
                              }
                            }

                            return ListView(
                              children: widgets,
                            );
                          } else {
                            return const Center(child: Text('Không có dữ liệu'));
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
