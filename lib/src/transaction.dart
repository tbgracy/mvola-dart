enum TransactionStatus { completed, failed }

class Transaction {
  final String status;
  final String serverCorrelationId;
  final String date;
  final int reference;
  final List<Map<String, String>> debitParty;
  final List<Map<String, String>> creditParty;
  final List<Map<String, double>> fees;

  Transaction({
    required this.status,
    required this.serverCorrelationId,
    required this.date,
    required this.reference,
    required this.debitParty,
    required this.creditParty,
    required this.fees,
  });

  factory Transaction.fromJson(Map<String, dynamic> jsonMap) {
    return Transaction(
      status: jsonMap['transactionStatus'],
      serverCorrelationId: jsonMap['serverCorrelationId'],
      date: jsonMap['requestDate'],
      reference: jsonMap['transactionReference'],
      debitParty: [
        {
          'key': 'msisdn',
          'value': jsonMap['debitParty'][0]['value'],
        }
      ],
      creditParty: [
        {
          'key': 'msisdn',
          'value': jsonMap['creditParty'][0]['value'],
        }
      ],
      fees: jsonMap['fees']['feeAmount'],
    );
  }

  @override
  String toString() {
    return {
      'status': status,
      'serverCorrelationId': serverCorrelationId,
      'date': date,
      'reference': reference,
      'debitParty': debitParty,
      'creditParty': creditParty,
    }.toString();
  }
}
