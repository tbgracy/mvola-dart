import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'constants.dart';
import 'transaction.dart';
import 'utils.dart';

class MVolaClient {
  String? _accessToken;
  String _userlanguage = 'FR';
  String consumerKey;
  String consumerSecret;

  String? get accessToken => _accessToken;

  MVolaClient(this.consumerKey, this.consumerSecret);

  /// Generate an access token using the provided consumer key and consumer secret during instanciation
  @override
  Future<String> generateAccessToken() async {
    final url = Uri.parse('$sandboxUrl/token');

    final base64Key = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));

    final headers = {
      'Authorization': 'Basic $base64Key',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cache-Control': 'no-cache',
    };

    const body = {
      'grant_type': 'client_credentials',
      'scope': 'EXT_INT_MVOLA_SCOPE',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final bodyMap = jsonDecode(response.body);
        _accessToken = bodyMap['access_token'];
        return _accessToken!;
      }
      // TODO : handles null return value
      return _accessToken!;
    } catch (e) {
      // TODO : Exception handling
      print(e);
      rethrow;
    }
  }

  Future<Transaction> initTransaction(
    String merchantName,
    String merchantNumber,
    int amount,
    String customerNumber,
  ) async {
    if (_accessToken == null) {
      throw Exception(
          'No access token, you can generate one by calling the generateAccessToken method.');
    }

    final url =
        Uri.parse('$sandboxUrl/mvola/mm/transactions/type/merchantpay/1.0.0/');

    final headers = {
      'Version': '1.0',
      'X-CorrelationID': Uuid().v1(),
      'UserLanguage': _userlanguage,
      'UserAccountIdentifier': 'msisdn;$merchantNumber',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
      // 'partnerName': merchantName,
      // 'X-Callback-URL': '',
      'Cache-Control': 'no-cache',
    };

    final body = {
      'amount': amount.toString(),
      'currency': 'Ar',
      'descriptionText': 'hahaa',
      'requestingOrganisationTransactionReference': 'jlkjlksjdf',
      'requestDate': formatDate(DateTime.now()),
      'debitParty': [
        {
          'key': 'msisdn',
          'value': customerNumber,
        }
      ],
      'creditParty': [
        {
          'key': 'msisdn',
          'value': merchantNumber,
        }
      ],
      'metadata': [
        {
          'key': 'partnerName',
          'value': merchantName,
        },
        {
          'key': 'fc',
          'value': 'USD',
        },
        {
          'key': 'amountFc',
          'value': '1',
        }
      ],
    };

    try {
      var response =
          await http.post(url, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        return Transaction.fromJson(json.decode(response.body));
      }
      print(response.body);
      print(response.statusCode);
      throw Exception();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Transaction getTransactionDetail() {
    throw UnimplementedError();
  }

  String getTransactionStatus() {
    throw UnimplementedError();
  }

  void changeOptions() {}
}
