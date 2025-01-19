  import 'package:medic/notification/notification.dart';
  import 'package:flutter/material.dart';
  import 'screens/alarms/alarms_screen.dart';
  import 'screens/medications/medications_screen.dart';
  import 'widgets/custom_navbar.dart';
  import 'package:timezone/data/latest.dart' as tz;

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationService.init();
    tz.initializeTimeZones();
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Gerenciador de Medicamentos',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      );
    }
  }

  class HomeScreen extends StatefulWidget {
    @override
    _HomeScreenState createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    int _selectedIndex = 0;

    final List<Widget> _screens = [
      AlarmsScreen(),
      MedicationsScreen(),
    ];

    void _onNavBarTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: CustomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onNavBarTapped,
        ),
      );
    }
    
  }
