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

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Transaction' : 'Add Transaction';
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            buildName(),
            const SizedBox(
              height: 8.0,
            ),
            buildAmount()
          ],
        ),
      ),

    );
  }
  Widget buildName(){
    return TextFormField(
      controller: nameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter Name',
      ),
      validator: (name) => name != null && name.isEmpty ? 'Enter a name' : null,
    );
  }
  
  Widget buildAmount(){
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter Amount',
      ),
      keyboardType: TextInputType.number,
      validator: (amount) => amount != null && double.tryParse(amount) == null ?
      'Enter a valid number' : null,
      controller: amountController,
    );
  }

}
