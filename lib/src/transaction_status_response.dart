class TransactionStatusResponse {
  String status;
  String serverCorrelationId;
  String notificationMethod;
  String transactionReference;

  TransactionStatusResponse(
    this.status,
    this.serverCorrelationId,
    this.notificationMethod,
    this.transactionReference,
  );

  factory TransactionStatusResponse.fromJson(Map<String, dynamic> jsonMap) {
    return TransactionStatusResponse(
      jsonMap['status'],
      jsonMap['serverCorrelationId'],
      jsonMap['notificationMethod'],
      jsonMap['objectReference'],
    );
  }

  @override
  String toString() {
    return {
      'status': status,
      'serverCorrelationId': serverCorrelationId,
      'notificationMethod': notificationMethod,
      'objectReference': transactionReference,
    }.toString();
  }
}
