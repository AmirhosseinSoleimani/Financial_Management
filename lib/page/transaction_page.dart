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
  void dispose() {
    Hive.close();
    super.dispose();
  }

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
          return buildContent(transaction);
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

  Widget buildContent(List<Transaction> transaction){
    if(transaction.isEmpty){
      return const Center(
        child: Text(
            'No expense yet!',
          style: TextStyle(
            fontSize: 24
          ),
        ),
      );
    } else{
      final netExpense = transaction.fold<double>(
        0,
          (previousValue,transaction) => transaction.isExpense ?
              previousValue - transaction.amount :
              previousValue + transaction.amount,
      );
      final newExpenseString = '\$${netExpense.toStringAsFixed(2)}';
      final color = netExpense > 0 ? Colors.green : Colors.red;
      return Column(
        children: [
          const SizedBox(
            height: 24.0,
          ),
          Text(
            'Net Expense: $newExpenseString',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: color
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                  itemCount: transaction.length,
                  itemBuilder: (BuildContext context,int index){
                  final transactions = transaction[index];
                  return buildTransaction(context,transactions);
                  }),
          )
        ],
      );
    }

  }

  Widget buildTransaction(BuildContext context,Transaction transaction){
    final color = transaction.isExpense ? Colors.red : Colors.green;
    final date = DateFormat.yMMMd().format(transaction.createData);
    final amount = transaction.isExpense ? ' - ${transaction.amount.toStringAsFixed(2)} \$' : '+ ${transaction.amount.toStringAsFixed(2)} \$';
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),
        title: Text(
          transaction.name,
          maxLines: 2,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0
          ),
        ),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16.0
          ),
        ),
        children: [
          buildButtons(context,transaction)
        ],
      ),
    );

  }

  Widget buildButtons(BuildContext context,Transaction transaction){
    return Row(
      children: [
        Expanded(
            child: TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                  builder: (context) => TransactionDialog(
                    transaction: transaction,
                      onClickedDone: (name,amount,isExpense){
                      editTransaction(transaction, name, amount, isExpense);
                      }
                  )
                ),
                ),
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Edit'
                ),
            ),
        ),
        Expanded(
            child: TextButton.icon(
                onPressed: () => deleteTransaction(transaction),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
            ),
        )
      ],
    );
  }

  void editTransaction(Transaction transaction,String name,double amount,bool isExpense){
    transaction.name = name;
    transaction.amount = amount;
    transaction.isExpense = isExpense;
    final box = Boxes.getTransactions();
    box.put(transaction.key, transaction);
    transaction.save();
  }

  void deleteTransaction(Transaction transaction){
    final box = Boxes.getTransactions();
    box.delete(transaction);
    transaction.delete();
  }

  Future addTransaction(String name, double amount, bool isExpense) async{
    final transaction = Transaction()
        ..name = name
        ..createData = DateTime.now()
        ..amount = amount
        ..isExpense = isExpense;
    final box = Boxes.getTransactions();
    box.add(transaction);
  }
}
