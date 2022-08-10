enum TransactionStatus { completed, failed }

class Transaction {
  final TransactionStatus status;
  final String serverCorrelationId;
  final String date;
  final int reference;
  final List<String> debitParty;
  final List<String> creditParty;
  final double fees;

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
      debitParty: jsonMap['debitParty'],
      creditParty: jsonMap['creditParty'],
      fees: jsonMap['fees']['feeAmount'],
    );
  }
}
