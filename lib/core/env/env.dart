import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  // ignore: non_constant_identifier_names
  static final String API_KEY = _Env.API_KEY;
}