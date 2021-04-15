import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_expenses/theme/colors.dart';
import 'package:shared_expenses/pages/daily_page.dart';
import 'package:shared_expenses/pages/stats_page.dart';
import 'package:shared_expenses/pages/profile_page.dart';
import 'package:shared_expenses/pages/newentry_page.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<ExpenseModel>(
        builder: (context, child, model) => IndexedStack(
          index: pageIndex,
          children: <Widget>[
            DailyPage(model: model),
            StatsPage(model: model),
            // BudgetPage(),
            ProfilePage(),
            NewEntryLog(model: model)
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: myColors[pageIndex][0],
        splashColor: myColors[pageIndex][1],
        inactiveColor: Colors.black.withOpacity(0.5),
        icons: <IconData>[
          Ionicons.md_calendar,
          Ionicons.md_stats,
          // Ionicons.md_wallet,
          Ionicons.md_settings,
        ],
        activeIndex: pageIndex,
        // gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.softEdge,
        // leftCornerRadius: 10,
        iconSize: 30,
        // rightCornerRadius: 10,
        onTap: (index) {
          selectedTab(index);
        },
        //other params
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            selectedTab(3);
          },
          child: Icon(
            Icons.add,
            size: 25,
          ),
          backgroundColor: Colors.pink
          //params
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;

    });
  }
}
