import 'package:app/core/routes/routs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once for each
  /// State object it creates.
  ///
  /// Override this method to perform initialization that
  /// depends on the location of this object in the tree.
  ///
  /// This method should not be used to schedule any asynchronous
  /// operations, such as Future.delayed calls, because the
  /// timing of such calls is not predictable. Instead, they should be
  /// scheduled either in the next frame, using a
  /// WidgetsBinding.instance.scheduleFrameCallback call, or
  /// in response to a lifecycle state change, using a
  /// framework-provided LifecycleAwareWidget.
  ///
  /// If a State object's build method is invoked without any
  /// intervening call to initState, then that object is being
  /// rebuilt due to an InheritedWidget changing its configuration.
  /// In this case, the object is rebuilt from scratch, and its
  /// initState and dispose methods are not invoked.
  ///
  /// Subclasses of State must call super.initState when they
  /// override this method.
  /*******  979eb8f1-38a5-4ef5-967e-ebd22a475937  *******/
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      GoRouter.of(context).pushReplacement(Routs.preLogin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/photo_2021.png",
          width: 200.w,
          height: 200.h,
        ),
      ),
    );
  }
}
