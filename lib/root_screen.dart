import 'package:depth_tracker/screens/form/recievable_form_screen.dart';
import 'package:depth_tracker/screens/home_screen.dart';
import 'package:depth_tracker/screens/loan_screen.dart';
import 'package:depth_tracker/screens/profile_screen.dart';
import 'package:depth_tracker/screens/receivalbe_screen.dart';
import 'package:depth_tracker/widgets/my_app_Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  static const routeName = '/RootScreen';

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;

  late PageController pageViewController;

  late int currentScreen = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    screens = [HomeScreen(), ReceivalbeScreen(), LoanScreen(), ProfileScreen()];
    pageViewController = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentScreen == 3
          ? null
          : MyAppBar(title: "Debt Tracker", hasTitleDecoration: true),
      body: PageView(
        controller: pageViewController,
        physics: NeverScrollableScrollPhysics(),
        children: screens,
        onPageChanged: (value) {
          setState(() {
            currentScreen = value;
          });
        },
      ),
      floatingActionButton: currentScreen == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, RecievableFormScreen.roatName);
              },
              elevation: 0,
              backgroundColor: const Color.fromARGB(76, 138, 138, 138),
              child: Icon(
                IconlyBroken.plus,
                color: const Color.fromARGB(255, 228, 228, 228),
              ),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 72,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            indicatorColor:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
            iconTheme: MaterialStateProperty.resolveWith(
              (states) => IconThemeData(
                color: states.contains(MaterialState.selected)
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            labelTextStyle: MaterialStateProperty.resolveWith(
              (states) => TextStyle(
                fontWeight:
                    states.contains(MaterialState.selected) ? FontWeight.w700 : FontWeight.w500,
                color: states.contains(MaterialState.selected)
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: currentScreen,
            onDestinationSelected: (value) {
              setState(() {
                currentScreen = value;
              });
              pageViewController.jumpToPage(currentScreen);
            },
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(IconlyLight.home),
                icon: Icon(Icons.home_filled),
                label: "Home",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.receipt_outlined),
                icon: Icon(Icons.receipt_sharp),
                label: "Receivables",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.whatshot_outlined),
                icon: Icon(Icons.whatshot),
                label: "Loan",
              ),
              NavigationDestination(
                selectedIcon: Icon(IconlyBold.profile),
                icon: Icon(IconlyLight.profile),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
