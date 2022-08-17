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
    partnerName: 'name',
    partnerNumber: '0343500004',
    creditNumber: '0343500004',
    amount: 5000,
    debitNumber: '0343500003',
    description: 'short description',
  );

  print(transactionResponse);

  // We have to wait for the transaction to be approved to be able 
  // to get the ID to get the details
  await Future.delayed(Duration(seconds: 30));

  var transactionStatus = await mvola.getTransactionStatus(
    transactionResponse.serverCorrelationId,
    '0343500003',
    'name',
  );
  print(transactionStatus);

  var transactionDetails = await mvola.getTransactionDetail(
    transactionStatus.transactionReference,
    'name',
    '0343500004',
  );
  print(transactionDetails);
}
