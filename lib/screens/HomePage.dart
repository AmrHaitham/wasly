// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/tabs/home_tab.dart';
import 'package:e_commerce/tabs/buy_tab.dart';
import 'package:e_commerce/tabs/search_tab.dart';
import 'package:e_commerce/widgets/bottom_tabs.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _tapPageController;
  int _selectedTab = 0;
  @override
  void initState() {
    _tapPageController = PageController();
    super.initState();
  }
  @override
  void dispose() {
    _tapPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PageView(
                controller: _tapPageController,
                onPageChanged: (num){
                  setState(() {
                    _selectedTab = num ;
                  });
                },
                children: [
                  HomeTab(),
                  SearchTab(),
                  BuyTab()
                ],
              ),
            ),
            BottomTabs(
              selectedTap: _selectedTab,
              tabPressed: (num){
                _tapPageController.animateToPage(
                    num,
                    duration:Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic
                );
              },
            )
          ],
        ),
      )
    );
  }
}
