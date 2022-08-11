import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'transaction.dart';
import 'transaction_response.dart';
import 'utils.dart';

/// A dart client for the MVola API that allows us to make transactions and get the
/// details or status of a transaction based on its [correlationID].
class MVolaClient {
  String? _accessToken;
  String _userlanguage = 'FR';
  final String _consumerKey;
  final String _consumerSecret;
  String _version = '1.0';
  final String _baseUrl;

  String? get accessToken => _accessToken;

  MVolaClient(String baseUrl, String consumerKey, String consumerSecret)
      : _baseUrl = baseUrl,
        _consumerKey = consumerKey,
        _consumerSecret = consumerSecret;

  /// Generate an access token using the [consumerKey] and [consumerSecret] provided
  /// at object instanciation.
  ///
  /// Return the token as a string
  Future<String> generateAccessToken() async {
    final url = Uri.parse('$_baseUrl/token');

    final base64Key =
        base64Encode(utf8.encode('$_consumerKey:$_consumerSecret'));

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

  Future<TransactionResponse> initTransaction(
    String merchantName,
    String merchantNumber,
    int amount,
    String customerNumber, [
    String description = 'description',
    String callbackUrl = '',
  ]) async {
    if (_accessToken == null) {
      throw Exception(
          'No access token, you can generate one by calling the generateAccessToken method.');
    }

    final url =
        Uri.parse('$_baseUrl/mvola/mm/transactions/type/merchantpay/1.0.0/');

    final headers = {
      'Version': _version,
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
      'descriptionText': description,
      'requestingOrganisationTransactionReference': Uuid().v1(),
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
      if (response.statusCode == 202) {
        return TransactionResponse.fromJson(json.decode(response.body));
      }
      print(response.body);
      print(response.statusCode);
      throw Exception();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Transaction> getTransactionDetail(
    String transactionId,
    String partnerName,
    String merchantNumber,
  ) async {
    var url = Uri.parse(
        '$_baseUrl/mvola/mm/transactions/type/merchantpay/1.0.0/$transactionId');
    var headers = {
      'Authorization': 'Bearer $_accessToken',
      'Version': _version,
      'X-CorrelationID': Uuid().v4(),
      'UserLanguage': _userlanguage,
      'UserAccountIdentifier': 'msisdn;$merchantNumber',
      'partnerName': partnerName,
      'Content-Type': 'application/json',
      'Cache-control': 'no-cache',
    };

    try {
      var response = await http.get(url, headers: headers);
      return Transaction.fromJson(jsonDecode(response.body));
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> getTransactionStatus(
    String serverCorrelationId,
    String merchantNumber,
    String partnerName,
  ) async {
    var url = Uri.parse(
        '$_baseUrl/mvola/mm/transactions/type/merchantpay/1.0.0/status/$serverCorrelationId');

    var headers = {
      'Authorization': 'Bearer $_accessToken',
      'Version': _version,
      'X-CorrelationID': Uuid().v4(),
      'UserLanguage': _userlanguage,
      'UserAccountIdentifier': 'msisdn;$merchantNumber',
      'partnerName': partnerName,
      'Content-Type': 'application/json',
      'Cache-control': 'no-cache',
    };

    try {
      var response = await http.get(url, headers: headers);
      print(response.body);
      return jsonDecode(response.body)['status'];
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void setOptions({
    String? version,
    String? userLanguage,
    String? callbackUrl,
    String? partnerName,
  }) {
    _version = version ?? _version;
    _userlanguage = userLanguage ?? _userlanguage;
  }
}
