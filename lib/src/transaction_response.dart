class TransactionResponse {
  String status;
  String serverCorrelationId;
  String notificationMethod;

  TransactionResponse(
      this.status, this.serverCorrelationId, this.notificationMethod);

  factory TransactionResponse.fromJson(Map<String, dynamic> jsonMap) {
    return TransactionResponse(
      jsonMap['status']!,
      jsonMap['serverCorrelationId']!,
      jsonMap['notificationMethod']!,
    );
  }

  @override
  String toString() {
    return {
      'status': status,
      'serverCorrelationId': serverCorrelationId,
      'notificationMethod': notificationMethod,
    }.toString();
  }
}
