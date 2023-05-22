// ignore_for_file: must_be_immutable, deprecated_member_use, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({required this.onSubmit, super.key});

  final void Function(String, double, DateTime) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate!);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              TextField(
                onSubmitted: (_) => _submitForm(),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Título",
                ),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitForm(),
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: "Valor R\$",
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'Selecionar data'
                          : 'Data selecionada: ${DateFormat('dd/MM/y').format(_selectedDate!)}'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _showDatePicker,
                      child: const Text(
                        'Selecionar data',
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).textTheme.button?.color,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: _submitForm,
                child: const Text("Nova Transação"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
