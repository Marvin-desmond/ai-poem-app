import 'package:ai_poem_app/common.dart';
import 'package:ai_poem_app/logic/app_logic.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keep native splash screen up until app is finished bootstrapping
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  registerSingletons();
  runApp(
    ChangeNotifierProvider(
      create: (context) => PoemNotifier(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'AI Poem App',
        routerConfig: appRouter,
      ),
    ),
  );
  await appLogic.bootstrap();
  // Remove splash screen when bootstrap is complete
  FlutterNativeSplash.remove();
}

void registerSingletons() {
  // Top level app controller
  GetIt.I.registerLazySingleton<AppLogic>(() => AppLogic());
  GetIt.I.registerLazySingleton<PoemNotifier>(() => PoemNotifier());
}

AppLogic get appLogic => GetIt.I.get<AppLogic>();
PoemNotifier get poemNotifier => GetIt.I.get<PoemNotifier>();
