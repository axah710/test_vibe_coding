import 'package:personal_finance_app/features/transactions/domain/entities/transaction.dart';

enum TransactionTypeFilter { all, income, expense }

enum SortBy { date, amount }

enum SortOrder { ascending, descending }

class TransactionFilter {
  final TransactionTypeFilter typeFilter;
  final String? categoryFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final SortBy sortBy;
  final SortOrder sortOrder;

  const TransactionFilter({
    this.typeFilter = TransactionTypeFilter.all,
    this.categoryFilter,
    this.startDate,
    this.endDate,
    this.sortBy = SortBy.date,
    this.sortOrder = SortOrder.descending,
  });

  List<Transaction> applyFilters(List<Transaction> transactions) {
    var filtered =
        transactions.where((transaction) {
          if (typeFilter != TransactionTypeFilter.all &&
              transaction.type != typeFilter.name) {
            return false;
          }

          if (categoryFilter != null &&
              transaction.category != categoryFilter) {
            return false;
          }

          if (startDate != null && transaction.date.isBefore(startDate!)) {
            return false;
          }

          if (endDate != null && transaction.date.isAfter(endDate!)) {
            return false;
          }

          return true;
        }).toList();

    filtered.sort((a, b) {
      int comparison;
      if (sortBy == SortBy.date) {
        comparison = a.date.compareTo(b.date);
      } else {
        comparison = a.amount.compareTo(b.amount);
      }

      return sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return filtered;
  }

  TransactionFilter copyWith({
    TransactionTypeFilter? typeFilter,
    String? categoryFilter,
    DateTime? startDate,
    DateTime? endDate,
    SortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return TransactionFilter(
      typeFilter: typeFilter ?? this.typeFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
