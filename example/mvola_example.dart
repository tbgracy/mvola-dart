import 'package:mvola/mvola.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mvola/src/constants.dart';

void main() async {
  var env = DotEnv()..load();
  var mvola = MVolaClient(
    env['DEV_ENV'] == '1' ? sandboxUrl : productionUrl,
    env['CONSUMER_KEY']!,
    env['CONSUMER_SECRET']!,
  );

  // tokony atao agnaty try catch block
  var token = await mvola.generateAccessToken();
  print(token);

  var transactionResponse = await mvola.initTransaction(
    'gvola',
    '0343500004',
    3000,
    '0343500003',
  );
  
  print(transactionResponse);

  var transactionStatus = await mvola.getTransactionStatus(transactionResponse.serverCorrelationId, '0343500003', 'gracy');
  print(transactionStatus);

  var transaction = await mvola.getTransactionDetail("636042511", "gracy", "0343500004");
  print(transaction);  
}
