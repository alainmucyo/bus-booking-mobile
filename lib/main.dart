import 'package:booking_app/screens/admin_dashboard.dart';
import 'package:booking_app/screens/admin_dashboard.dart';
import 'package:booking_app/screens/admin_login.dart';
import 'package:booking_app/screens/admin_login.dart';
import 'package:booking_app/screens/admin_reports.dart';
import 'package:booking_app/screens/admin_reports.dart';
import 'package:booking_app/screens/home.dart';
import 'package:booking_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Booking Horizon Bus',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: CustomColor.PRIMARY,
          accentColor: CustomColor.ACCENT_COLOR,
          hintColor: Colors.grey[400],
          appBarTheme: AppBarTheme(
            backgroundColor: CustomColor.PRIMARY,
          ),
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: CustomColor.DARK_GREY,
                  displayColor: CustomColor.DARK_GREY,
                ),
          ),
        ),
        home: SplashScreen(),
        routes: {
          Home.routeName: (_) => Home(),
          AdminLogin.routeName: (_) => AdminLogin(),
          AdminDashboard.routeName: (_) => AdminDashboard(),
        },
      ),
    );
  }
}
