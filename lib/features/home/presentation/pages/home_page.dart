import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_app/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:personal_finance_app/features/transactions/domain/entities/transaction.dart';
import 'package:personal_finance_app/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:intl/intl.dart';

import '../../../transactions/presentation/bloc/transaction_event.dart';
import '../../../transactions/presentation/bloc/transaction_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTransactionPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionInitial) {
            context.read<TransactionBloc>().add(LoadTransactions());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionError) {
            return Center(child: Text(state.message));
          }

          if (state is TransactionLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionBloc>().add(LoadTransactions());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildSummaryCards(context, state),
                    const SizedBox(height: 16),
                    _buildRecentTransactions(context, state),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, TransactionLoaded state) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Balance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(state.balance),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormat.format(state.totalIncome),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Expenses',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormat.format(state.totalExpense),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(
    BuildContext context,
    TransactionLoaded state,
  ) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (state.transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('No transactions yet')),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        transaction.type == TransactionType.income
                            ? Colors.green
                            : Colors.red,
                    child: Icon(
                      transaction.type == TransactionType.income
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(transaction.title),
                  subtitle: Text(
                    '${dateFormat.format(transaction.date)} • ${transaction.category}',
                  ),
                  trailing: Text(
                    currencyFormat.format(transaction.amount),
                    style: TextStyle(
                      color:
                          transaction.type == TransactionType.income
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // TODO: Show transaction details
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
