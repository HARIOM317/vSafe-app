import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:v_safe/widgets/bottom_nav_bar.dart';
import 'package:v_safe/widgets/drawer_widgets/feedback_page.dart';
import 'package:v_safe/widgets/drawer_widgets/help_page.dart';
import 'package:v_safe/widgets/drawer_widgets/history_page.dart';
import 'package:v_safe/widgets/drawer_widgets/notification_page.dart';
import 'package:v_safe/widgets/drawer_widgets/privacy_policy_page.dart';
import 'package:v_safe/widgets/drawer_widgets/setting_page.dart';
import 'package:v_safe/widgets/drawer_widgets/share_page.dart';


class DrawerScreen extends StatelessWidget {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff4801FF).withOpacity(0.75), Color(0xff7010fb).withOpacity(0.70), Color(0xff7918F2).withOpacity(0.65)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(

        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "vSafe",
            style: TextStyle(
                fontFamily: 'Dosis-Regular',
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),

          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xff6416ff), Color(0xff5623a3)]),
            ),
          ),

          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),

        body: BottomNavBar(),
      ),

      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, size: 100, color: Colors.white,)
                ),

                // setting button
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AppSetting()));
                  },
                  leading: Icon(Icons.settings),
                  title: Text('Setting'),
                ),

                // notification button
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage()));
                  },
                  leading: Icon(Icons.notifications),
                  title: Text('Notification'),
                ),

                // feedback button
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryPage()));
                  },
                  leading: Icon(Icons.history),
                  title: Text('History'),
                ),

                Divider(
                  thickness: 1,
                  color: Colors.white70,
                ),

                // setting button
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharePage()));
                  },
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                ),

                // setting button
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpPage()));
                  },
                  leading: Icon(Icons.help),
                  title: Text('Help'),
                ),

                Divider(
                  thickness: 1,
                  color: Colors.white70,
                ),

                // setting button
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserFeedback()));
                  },
                  leading: Icon(Icons.feedback),
                  title: Text('Feedback'),
                ),

                // policy button
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivacyPolicy()));
                  },
                  leading: Icon(Icons.privacy_tip),
                  title: Text('Privacy Policy'),
                ),

                Spacer(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
