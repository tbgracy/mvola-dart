import 'package:mvola/mvola.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  var env = DotEnv()..load();
  var mvola = MVolaClient(env['CONSUMER_KEY']!, env['CONSUMER_SECRET']!);
  var token = await mvola.generateAccessToken();
  // print(token);
  // print('*' * 40);
  var transaction = await mvola.initTransaction('gvola',
      '0343500004', 3000, '0343500003');
  print(transaction);
  // print(Uuid().v1());
  // print(Uuid().v4());
}