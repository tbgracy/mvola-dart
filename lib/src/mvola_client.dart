import 'package:http/http.dart' as http;
import 'package:mvola/src/constants.dart';

import 'dart:convert';

import 'transaction.dart';

enum UserLanguage { fr, mg }

abstract class MVolaClient {
  void generateAccessToken();
  Transaction getTransactionDetail();
  Transaction initTransaction();
}

class MVolaClientImpl implements MVolaClient {
  String? _accessToken;
  UserLanguage _userLanguage = UserLanguage.mg;
  String consumerKey;
  String consumerSecret;

  MVolaClientImpl(this.consumerKey, this.consumerSecret);

  /// Generate an access token using the provided consumer key and consumer secret during instanciation
  @override
  void generateAccessToken() async {
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
      }
      // print(response.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  Transaction getTransactionDetail() {
    // TODO: implement getTransactionDetail
    throw UnimplementedError();
  }

  @override
  Transaction initTransaction() {
    throw UnimplementedError();
  }
}

void main(List<String> args) {
  MVolaClient mvola = MVolaClientImpl(
      '_Bq5IdbuDxI7v0ZUWeqdJmyrgdsa', 'xSQqSP1_2dwoqcFiRMDqbXLwoMka');
  mvola.generateAccessToken();
}
