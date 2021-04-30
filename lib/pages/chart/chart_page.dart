import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'indicator.dart';
import 'package:shared_expenses/theme/colors.dart';

class MyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Column(
        children: [
          Container(
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
                  colors: myColors[2],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 2.0],
                  tileMode: TileMode.clamp),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50, right: 20, left: 20, bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Text(
                  //   "Preferences",
                  //   style: TextStyle(
                  //       fontSize: 21,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.white),
                  // ),
                ],
              ),
            ),
          ),
          Text("Thisss"),
          SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width,
            child: LineChart(
              sampleData1(),
            ),
          ),
        ],
      ),
    ));
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

class LineChartSample9 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartSample9State();
}

class LineChartSample9State extends State<LineChartSample9> {
  bool isShowingMainData;
  int touchedIndex;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      // decoration: const BoxDecoration(
      //   borderRadius: BorderRadius.all(Radius.circular(18)),
      // ),
      child: Column(
        children: <Widget>[
          const Text(
            'Monthly Sales',
            style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
            textAlign: TextAlign.center,
          ),
          LineChart(
            sampleData1(),
            // swapAnimationDuration: const Duration(milliseconds: 250),
          ),

          // Expanded(
          //   child: PieChart(
          //     PieChartData(
          //         pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
          //           setState(() {
          //             final desiredTouch =
          //                 pieTouchResponse.touchInput is! PointerExitEvent &&
          //                     pieTouchResponse.touchInput is! PointerUpEvent;
          //             if (desiredTouch &&
          //                 pieTouchResponse.touchedSection != null) {
          //               touchedIndex =
          //                   pieTouchResponse.touchedSection.touchedSectionIndex;
          //             } else {
          //               touchedIndex = -1;
          //             }
          //           });
          //         }),
          //         sectionsSpace: 0,
          //         centerSpaceRadius: 0,
          //         sections: showingSections()),
          //   ),
          // ),
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
          // getTitles: (value) {
          //   switch (value.toInt()) {
          //     case 1:
          //       return '1m';
          //     case 2:
          //       return '2m';
          //     case 3:
          //       return '3m';
          //     case 4:
          //       return '5m';
          //   }
          //   return '';
          // },
          // margin: 8,
          // reservedSize: 30,
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

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? 20 : 16;
        final double radius = isTouched ? 110 : 100;
        // final double widgetSize = isTouched ? 55 : 40;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: 40,
              title: '40%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
              titlePositionPercentageOffset: .4,
              badgePositionPercentageOffset: .9,
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xfff8b250),
              value: 30,
              title: '30%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
              badgePositionPercentageOffset: .98,
            );
          case 2:
            return PieChartSectionData(
              color: const Color(0xff845bef),
              value: 16,
              title: '16%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
              badgePositionPercentageOffset: .98,
            );
          case 3:
            return PieChartSectionData(
              color: const Color(0xff13d38e),
              value: 15,
              title: '15%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
              badgePositionPercentageOffset: .98,
            );
          default:
            return null;
        }
      },
    );
  }

  getWidget(String txt, double fontSize) {
    return Text(txt,
        style: TextStyle(
          backgroundColor: Colors.white,
          fontSize: fontSize - 2,
          // fontWeight: FontWeight.bold,
        ));
  }
}
