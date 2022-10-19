import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_project/boxes.dart';
import 'package:hive_project/model/transaction.dart';

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
    );
  }

  Widget buildContent(){
    return const Center(
      child: Text(
        'No expense yet!'
      ),
    );
  }
}
