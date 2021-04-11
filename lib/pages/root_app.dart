// import 'package:budget_tracker_ui/pages/budget_page.dart';
import 'package:budget_tracker_ui/pages/create_budge_page.dart';
import 'package:budget_tracker_ui/pages/daily_page.dart';
import 'package:budget_tracker_ui/pages/profile_page.dart';
import 'package:budget_tracker_ui/pages/stats_page.dart';
import 'package:budget_tracker_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
        body: IndexedStack(
          index: pageIndex,
          children: [
            DailyPage(),
            StatsPage(),
            // BudgetPage(),
            ProfilePage(),
            CreatBudgetPage()
          ],
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          activeColor: primary,
          splashColor: secondary,
          inactiveColor: Colors.black.withOpacity(0.5),
          icons: [
            Ionicons.md_calendar,
            Ionicons.md_stats,
            // Ionicons.md_wallet,
            Ionicons.ios_person,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked);
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
