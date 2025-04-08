import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum TransactionType { income, expense }

class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String? description;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.description,
  });

  factory Transaction.create({
    required String title,
    required double amount,
    required TransactionType type,
    required String category,
    String? description,
  }) {
    return Transaction(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: DateTime.now(),
      type: type,
      category: category,
      description: description,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: json['amount'] as double,
      date: DateTime.parse(json['date'] as String),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      category: json['category'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'category': category,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    amount,
    date,
    type,
    category,
    description,
  ];
}
