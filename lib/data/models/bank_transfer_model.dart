class BankTransferModel {
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String iban;
  final DateTime transferDate;
  final String referenceNumber;
  final double amount;

  BankTransferModel({
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.iban,
    required this.transferDate,
    required this.referenceNumber,
    required this.amount,
  });

  factory BankTransferModel.fromJson(Map<String, dynamic> json) {
    return BankTransferModel(
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountName: json['accountName'] ?? '',
      iban: json['iban'] ?? '',
      transferDate: DateTime.parse(json['transferDate']),
      referenceNumber: json['referenceNumber'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'iban': iban,
      'transferDate': transferDate.toIso8601String(),
      'referenceNumber': referenceNumber,
      'amount': amount,
    };
  }
}