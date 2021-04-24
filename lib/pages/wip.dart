import 'package:flutter/material.dart';
import 'package:shared_expenses/theme/colors.dart';
import "package:shared_expenses/pages/detail_page.dart";
import 'package:shared_expenses/scoped_model/expenseScope.dart';
import 'package:fl_chart/fl_chart.dart';

class MyChartPage extends StatelessWidget {
  // final ExpenseModel model;
  // final Function callback;
  // const MyChartPage({Key key, @required this.model, this.callback})      : super(key: key);
  const MyChartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // List<Map<String, String>> _expenses = model.getExpenses;
    // print(model.expense);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.01),
                  spreadRadius: 10,
                  blurRadius: 3,
                ),
              ],
              gradient: LinearGradient(
                  colors: myColors[0],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 2.0],
                  tileMode: TileMode.clamp),
            ),
            // child: Padding(
            //   padding: const EdgeInsets.only(
            //       top: 50, right: 20, left: 20, bottom: 15),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text(
            //         "",
            //         style: TextStyle(
            //             fontSize: 21,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white),
            //       ),
            //     ],
            //   ),
            // ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width,
            child: LineChart(
              sampleData1(),
            ),
          ),
          Row(
            children: [
              Column(
                children: [Text("jgweuwe"), Text("jwhfui")],
              ),
              LineChart(
                sampleData1(),
              ),
            ],
          )
        ],
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Color(0xff4e4965),
          ),
          // right: BorderSide(
          //   color: Colors.transparent,
          // ),
          // top: BorderSide(
          //   color: Colors.transparent,
          // ),
        ),
      ),
      minX: 0,
      maxX: 14,
      maxY: 4,
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(1, 2.8),
            FlSpot(3, 1.9),
            FlSpot(6, 3),
            FlSpot(10, 1.3),
            FlSpot(13, 2.5),
          ],
          isCurved: false,
          colors: const [
            Color(0xff27b6fc),
          ],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        )
      ],
    );
  }
}
