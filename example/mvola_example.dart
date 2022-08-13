import 'package:mvola/mvola.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mvola/src/constants.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  var mvola = MVolaClient(
    env['DEV_ENV'] == '1' ? sandboxUrl : productionUrl,
    env['CONSUMER_KEY']!,
    env['CONSUMER_SECRET']!,
  );

  var token = await mvola.generateAccessToken();
  print(token);

  var transactionResponse = await mvola.initTransaction(
    'name',
    '0343500004',
    5000,
    '0343500003',
    'short description',
  );
  print(transactionResponse);

  var transactionStatus = await mvola.getTransactionStatus(transactionResponse.serverCorrelationId, '0343500003', 'name');
  print(transactionStatus);
}
