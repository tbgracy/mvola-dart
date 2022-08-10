import 'package:mvola/mvola.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  var env = DotEnv()..load();
  var mvola = MVolaClient(env['CONSUMER_KEY']!, env['CONSUMER_SECRET']!);
  var token = await mvola.generateAccessToken();
  print(token);
}
