import 'package:flutter/material.dart';
import 'package:test_application/widgets/mainheader/desktop_header.dart';
import 'package:test_application/widgets/mainheader/mobile_header.dart';
import 'package:test_application/widgets/mainheader/nav_bar.dart';
import 'package:test_application/views/content_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController tabController;
  late double headerHeight;

  List<ContentView> contentViews = [
    ContentView(
      tab: const NavBarItem(title: 'Home'),
      content: Center(child: Container(color: Colors.green, width: 100, height: 100))
    ),
    ContentView(
      tab: const NavBarItem(title: 'About'),
      content: Center(child: Container(color: Colors.blue, width: 100, height: 100))
    ),
    ContentView(
      tab: const NavBarItem(title: 'Contact'),
      content: Center(child: Container(color: Colors.red, width: 100, height: 100))
    ),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: contentViews.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    headerHeight = 50;

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: drawer(),
      key: scaffoldKey,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 715) {
            return desktopView();
          } else {
            return mobileView();
          }
        }
      )
    );
  }

  Widget desktopView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        DesktopHeader(
          title: 'GAME-SHIELD App',
          controller: tabController,
          navItems: contentViews.map((e) => e.tab).toList(),
          height: headerHeight,
        ),
        Flexible(
          child: TabBarView(
            controller: tabController, 
            children: contentViews.map((e) => e.content).toList(),
          )
        )
      ]
    );
  }

  Widget mobileView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MobileHeader(
            title: 'GAME-SHIELD App',
            height: headerHeight,
            scaffoldState: scaffoldKey
          ),
          Flexible(
            child: TabBarView(
              controller: tabController,
              children: contentViews.map((e) => e.content).toList(),
            )
          )
        ]
      )
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: contentViews.map((e) => 
        Container(
          child: ListTile(
            title: Text(e.tab.title),
            onTap: () {
              tabController.index = contentViews.indexOf(e);
              scaffoldKey.currentState?.closeEndDrawer();
            }),
        )).toList(),
      )
    );
  }
}
