import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'transaction.dart';
import 'transaction_response.dart';
import 'transaction_status_response.dart';
import 'utils.dart';

//TODO: Improve parameters

/// A dart client for the MVola API that allows us to make transactions and get the
/// details or status of a transaction based on its [correlationID].
class MVolaClient {
  String? _accessToken;
  String _userlanguage = 'FR';
  final String _consumerKey;
  final String _consumerSecret;
  String _version = '1.0';
  String _baseUrl;
  String? _callbackUrl;

  String? get accessToken => _accessToken;

  /// Create a MVolaClient object
  ///
  /// Takes [baseUrl], [consumerKey] and [consumerSecret] as mandatory parameters
  ///
  /// You can optionnally provide [callbackUrl], an URL where the MVola APi will send
  /// the result of a transaction whethere it failed or it succeded.
  MVolaClient(String baseUrl, String consumerKey, String consumerSecret,
      {String? callbackUrl})
      : _baseUrl = baseUrl,
        _consumerKey = consumerKey,
        _consumerSecret = consumerSecret,
        _callbackUrl = callbackUrl;

  /// Generate an access token using the [consumerKey] and [consumerSecret] provided
  /// at object instanciation.
  ///
  /// Return the [accessToken] as a string if successful, otherwise throw an Exception.
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
      } else {
        throw Exception({
          'Exception': "Couldn't get access token.",
          'Status code': response.statusCode,
          'Response body': json.decode(response.body) as Map<String, dynamic>,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Initiate a transaction.
  ///
  /// Send [amount] amount of money to [creditNumber] from [debitNumber].
  /// A short [description] and [partnerName] (the phone number ) must be provided.
  ///
  /// Return a [TransactionResponse] if succeed, otherwise throw an Exception
  Future<TransactionResponse> initTransaction({
    required String partnerName,
    required String partnerNumber,
    required String creditNumber,
    required int amount,
    required String debitNumber,
    required String description,
  }) async {
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
      'UserAccountIdentifier': 'msisdn;$creditNumber',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
      'partnerName': partnerName,
      'Cache-Control': 'no-cache',
    };

    if (_callbackUrl != null) {
      headers['X-Callback-URL'] = _callbackUrl!;
    }

    final body = {
      'amount': amount.toString(),
      'currency': 'Ar',
      'descriptionText': description,
      'requestingOrganisationTransactionReference': Uuid().v1(),
      'requestDate': formatDate(DateTime.now()),
      'debitParty': [
        {
          'key': 'msisdn',
          'value': debitNumber,
        }
      ],
      'creditParty': [
        {
          'key': 'msisdn',
          'value': creditNumber,
        }
      ],
      'metadata': [
        {
          'key': 'partnerName',
          'value': partnerName,
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
      } else {
        throw Exception({
          'Exception': "Couldn't perform transaction.",
          'Status code': response.statusCode,
          'Response body': json.decode(response.body) as Map<String, dynamic>,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get the status of a transaction based on the [serverCorrelationId]
  ///
  /// If the transaction has not been approved, the [objectReference] whill
  /// be empty and can't be used to get the details of that transaction.
  ///
  /// returned in the response a [initTransaction] call
  Future<TransactionStatusResponse> getTransactionStatus(
    String serverCorrelationId,
    String merchantNumber,
    String partnerName,
  ) async {
    var url = Uri.parse(
        '$_baseUrl/mvola/mm/transactions/type/merchantpay/1.0.0/status/$serverCorrelationId');

    var headers = {
      'Authorization': 'Bearer $_accessToken',
      'Version': _version,
      'X-CorrelationID': Uuid().v1(),
      'UserLanguage': _userlanguage,
      'UserAccountIdentifier': 'msisdn;$merchantNumber',
      'partnerName': partnerName,
      'Content-Type': 'application/json',
      'Cache-control': 'no-cache',
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return TransactionStatusResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception({
          'Exception': "Couldn't get transaction status",
          'Status Code': response.statusCode,
          'Response body': response.body,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get the details of a transaction based on [transactionId], return as [objectReference] from
  /// calling [getTransactionDetail] method
  ///
  /// Return a [Transaction] object
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
      if (response.statusCode == 200) {
        return Transaction.fromJson(json.decode(response.body));
      } else {
        throw Exception({
          'Exception': "Couldn't get transaction details",
          'Status code': response.statusCode,
          'Response body': response.body,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Change/set some variables of the MVolaClient object
  ///
  /// Takes any of [version], [userLanguage], [callbackUrl], [partnerName] or [baseUrl]
  /// as optional named parameters
  void setOptions({
    String? version,
    String? userLanguage,
    String? callbackUrl,
    String? baseUrl,
  }) {
    // TODO : Check entered values
    _version = version ?? _version;
    _userlanguage = userLanguage ?? _userlanguage;
    _callbackUrl = callbackUrl ?? _callbackUrl;
    _baseUrl = baseUrl ?? _baseUrl;
  }
}
