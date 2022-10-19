import 'package:flutter/material.dart';
import '../model/transaction.dart';

class TransactionDialog extends StatefulWidget {
  final Transaction? transaction;
  final Function(
      String name,
      double amount,
      bool isExpense
      ) onClickedDone;
  const TransactionDialog({Key? key,
    this.transaction,
    required this.onClickedDone
  }) : super(key: key);

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
