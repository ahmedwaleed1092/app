import 'package:app/core/routes/routs.dart';
import 'package:app/feture/auth/login/presentation/login_screen.dart';
import 'package:app/feture/auth/login/presentation/pre_login_screen.dart';
import 'package:app/feture/auth/register/view/presentation/register_screen.dart';
import 'package:app/feture/main/view/presentation/home_screen.dart';
import 'package:app/feture/main/view/presentation/notifications_screen.dart';
import 'package:app/feture/main/view/presentation/settings_screen.dart';
import 'package:app/feture/search/view/presentation/category_screen.dart';
import 'package:app/feture/sevice_view/view/presentation/service_view.dart';
import 'package:app/feture/splash/view/presentation/splash_screen.dart';
import 'package:go_router/go_router.dart';

class RoutConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: Routs.splash,
    routes: [
      GoRoute(
        path: Routs.splash,
        name: Routs.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: Routs.login,
        name: Routs.login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: Routs.signUp,
        name: Routs.signUp,
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: Routs.home,
        name: Routs.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routs.preLogin,
        name: Routs.preLogin,
        builder: (context, state) => const PreLoginScreen(),
      ),
      GoRoute(
        path: Routs.category,
        name: Routs.category,
        builder: (context, state) => const CategoryScreen(),
      ),
      GoRoute(
        path: Routs.serviceView,
        name: Routs.serviceView,
        builder: (context, state) {
          // هنا نستقبل البيانات المرسلة (اسم القسم)
          // نستخدم "as String" لأننا متأكدين أننا سنرسل نصاً
          final category = state.extra as String;

          return ServiceView(categoryName: category);
        },
      ),
      GoRoute(
        path: Routs.notifications,
        name: Routs.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routs.settings,
        name: Routs.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
