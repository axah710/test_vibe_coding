import 'package:personal_finance_app/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();
  Future<void> saveTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
  Future<void> clearTransactions();
}
