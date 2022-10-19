import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_project/boxes.dart';
import 'package:hive_project/model/transaction.dart';
import 'package:hive_project/widget/transaction_dialog.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Expense Tracker'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Transaction>>(
        valueListenable: Boxes.getTransactions().listenable(),
        builder: (context,box,_){
          final transaction = box.values.toList().cast<Transaction>();
          return buildContent();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
            context: context,
            builder: (context) => TransactionDialog(onClickedDone: addTransaction)),
      ),
    );
  }

  Widget buildContent(){
    return const Center(
      child: Text(
        'No expense yet!'
      ),
    );
  }

  Future addTransaction(
      String name,
      double amount,
      bool isExpense
      ) async{
    final transaction = Transaction()
        ..name = name
        ..createData = DateTime.now()
        ..amount = amount
        ..isExpense = isExpense;
    final box = Boxes.getTransactions();
    box.add(transaction);
  }
}
