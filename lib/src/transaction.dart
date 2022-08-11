import 'dart:convert';

class Transaction {
  final String amount;
  final String currency;
  final String requestDate;
  List? debitParty;
  List? creditParty;
  List? fees;
  final String status;
  final String creationDate;
  final String transactionReference;

  Transaction(
    this.amount,
    this.currency,
    this.requestDate,
    this.status,
    this.creationDate,
    this.transactionReference,
  );

  factory Transaction.fromJson(Map<String, dynamic> jsonMap) {
    return Transaction(
      jsonMap['amount'],
      jsonMap['currency'],
      jsonMap['requestDate'],
      jsonMap['transactionStatus'],
      jsonMap['creationDate'],
      jsonMap['transactionReference'],
    );
  }

  @override
  String toString() {
    return {
      'status': status,
      'date': creationDate,
      // 'reference': reference,
      'debitParty': debitParty,
      'creditParty': creditParty,
    }.toString();
  }
}
