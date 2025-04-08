import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:personal_finance_app/features/transactions/domain/entities/transaction_filter.dart';
import 'package:personal_finance_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:personal_finance_app/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:personal_finance_app/features/transactions/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;
  TransactionFilter _filter = const TransactionFilter();

  TransactionBloc(this._repository) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<UpdateFilter>(_onUpdateFilter);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(TransactionLoading());
      final transactions = await _repository.getTransactions();
      final filteredTransactions = _filter.applyFilters(transactions);

      final totalIncome = filteredTransactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);

      final totalExpense = filteredTransactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);

      final balance = totalIncome - totalExpense;

      emit(
        TransactionLoaded(
          transactions: filteredTransactions,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          balance: balance,
        ),
      );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _repository.saveTransaction(event.transaction);
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _repository.saveTransaction(event.transaction);
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _repository.deleteTransaction(event.id);
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  void _onUpdateFilter(UpdateFilter event, Emitter<TransactionState> emit) {
    _filter = event.filter;
    add(LoadTransactions());
  }
}
