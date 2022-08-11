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

  await mvola.generateAccessToken();

  var transactionResponse = await mvola.initTransaction(
    'gvola',
    '0343500004',
    5000,
    '0343500003',
  );
  print(transactionResponse);

  var transactionStatus = await mvola.getTransactionStatus(transactionResponse.serverCorrelationId, '0343500004', 'gvola');
  print(transactionStatus);

  var transaction = await mvola.getTransactionDetail("636838929", "gvola", "0343500004");
  print(transaction);  
}
