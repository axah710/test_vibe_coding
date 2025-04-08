import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_finance_app/features/transactions/domain/entities/transaction.dart';

class TransactionLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _transactionsKey = 'transactions';

  TransactionLocalDataSource(this.sharedPreferences);

  Future<List<Transaction>> getTransactions() async {
    final transactionsJson =
        sharedPreferences.getStringList(_transactionsKey) ?? [];
    return transactionsJson
        .map((json) => Transaction.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveTransaction(Transaction transaction) async {
    final transactions = await getTransactions();
    transactions.add(transaction);
    await _saveTransactions(transactions);
  }

  Future<void> deleteTransaction(String id) async {
    final transactions = await getTransactions();
    transactions.removeWhere((transaction) => transaction.id == id);
    await _saveTransactions(transactions);
  }

  Future<void> clearTransactions() async {
    await sharedPreferences.remove(_transactionsKey);
  }

  Future<void> _saveTransactions(List<Transaction> transactions) async {
    final transactionsJson =
        transactions
            .map((transaction) => jsonEncode(transaction.toJson()))
            .toList();
    await sharedPreferences.setStringList(_transactionsKey, transactionsJson);
  }
}
