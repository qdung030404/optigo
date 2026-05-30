import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:optigo/providers/splash_provider.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/views/auth/login_screen.dart';
import 'package:optigo/views/auth/otp_screen.dart';
import 'package:optigo/views/auth/set_user_name.dart';
import 'package:optigo/views/booking/booking_detail_screen.dart';
import 'package:optigo/views/booking/booking_manager.dart';
import 'package:optigo/views/driver/post_a_trip/create_trip.dart';
import 'package:optigo/views/home/home_screen.dart';
import 'package:optigo/views/splash_screen.dart';
import 'package:optigo/views/trip/trip_detail_screen.dart';
import 'package:optigo/views/trip/trip_list_view.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProxyProvider<SearchProvider, MapProvider>(
          create: (_) => MapProvider(),
          update: (_, searchProvider, mapProvider) =>
              mapProvider!..update(searchProvider),
        ),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider())
      ],
      child: ScreenUtilInit(
        designSize: Size(414, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: ((context, child){
          return MaterialApp(
            title: 'Optigo',
            initialRoute: Routes.splash,
            routes: {
              Routes.splash: (ctx) => SplashScreen(),
              Routes.login: (ctx) => LoginScreen(),
              Routes.otp: (ctx) => OtpScreen(),
              Routes.setUserName: (ctx) => SetUserName(),
              Routes.home: (ctx) => HomeScreen(),
              Routes.tripList: (ctx) => TripListView(),
              Routes.tripDetail: (ctx) => TripDetailScreen(),
              Routes.bookingManager: (ctx) => BookingManager(),
              Routes.createTrip: (ctx) => CreateTrip(),
              Routes.bookingDetail: (ctx) => BookingDetailScreen(),
            },
          );
        }),
      ),
    );
  }
}