// ambient variable to access the service locator
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

 void setup() {
   locator.registerLazySingleton(() => null);
}