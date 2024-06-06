import 'package:bodysyncapp/presentation/instructor/homeInstructor_screen.dart';
import 'package:bodysyncapp/presentation/instructor/memberInstructor.screen.dart';
import 'package:bodysyncapp/presentation/login_screen.dart';
import 'package:bodysyncapp/presentation/miembros/gymBrosScreen.dart';
import 'package:bodysyncapp/presentation/miembros/gymUser_Screen.dart';
import 'package:bodysyncapp/presentation/miembros/musclePainLogScreen.dart';
import 'package:bodysyncapp/presentation/register_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/auth/login',
  routes: [
    GoRoute(
        path: '/auth/login',
        name: LoginScreen.name,
        builder: (context, state) => const LoginScreen()),
    GoRoute(
        path: '/auth/register',
        name: RegisterScreen.name,
        builder: (context, state) => const RegisterScreen()),
    GoRoute(
        path: '/auth/homeUser',
        name: GymUserScreen.name,
        builder: (context, state) => const GymUserScreen()),
    GoRoute(
        path: '/auth/homeInstructor',
        name: HomeInstructorScreen.name,
        builder: (context, state) => const HomeInstructorScreen()),
    GoRoute(
        path: '/auth/memberInstructor',
        name: HomeMemberScreen.name,
        builder: (context, state) => const HomeMemberScreen()),
    GoRoute(
        path: '/auth/musclePainLogScreen',
        name: MusclePainLogScreen.name,
        builder: (context, state) => const MusclePainLogScreen(
              gymUserId: 0,
            )),
    GoRoute(
        path: '/auth/gymBrosScreen',
        name: GymBrosScreen.name,
        builder: (context, state) =>  GymBrosScreen()),
  ],
);
