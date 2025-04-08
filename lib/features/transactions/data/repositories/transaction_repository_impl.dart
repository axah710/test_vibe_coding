import 'package:personal_finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:personal_finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:personal_finance_app/features/transactions/data/datasources/transaction_local_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<List<Transaction>> getTransactions() async {
    return localDataSource.getTransactions();
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    await localDataSource.saveTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await localDataSource.deleteTransaction(id);
  }

  @override
  Future<void> clearTransactions() async {
    await localDataSource.clearTransactions();
  }
}
