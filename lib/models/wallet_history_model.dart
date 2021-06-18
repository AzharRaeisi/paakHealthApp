class WalletHistoryModel{

  int old_balance;
  int new_balance;
  int add_deduct_amount;
  String description;
  String transaction_date;
  int transaction_type;

  WalletHistoryModel(
      {this.old_balance,
      this.new_balance,
      this.add_deduct_amount,
      this.description,
      this.transaction_date,
      this.transaction_type});

  WalletHistoryModel.fromMap(Map<String, dynamic> map)
  :
        old_balance = map['old_balance'],
        new_balance = map['new_balance'],
        add_deduct_amount = map['add_deduct_amount'],
        description = map['description'],
        transaction_date = map['transaction_date'],
        transaction_type = map['transaction_type'];
}