import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timers_project/bloc/timers_bloc.dart';
import 'package:timers_project/bloc/timers_events.dart';
import 'repositories/timer_repository.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final timerRepository = TimerRepository(prefs);
  runApp(MyApp(isDarkMode: isDarkMode, timerRepository: timerRepository));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  final TimerRepository timerRepository;

  const MyApp({
    Key? key,
    required this.isDarkMode,
    required this.timerRepository,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    widget.timerRepository.setDarkMode(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(widget.timerRepository)..add(LoadTimers()),
      child: MaterialApp(
        title: 'Timer App',
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: HomeScreen(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      ),
    );
  }
}
