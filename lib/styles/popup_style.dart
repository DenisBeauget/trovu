import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void showReportDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final supabase = Supabase.instance.client;
      return AlertDialog(
        title: const Text('Signaler un client'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: btnSmallPrimaryStyle(context),
            onPressed: () {
              final email = emailController.text.trim();
              final phone = phoneController.text.trim();
              final name = nameController.text.trim();

              if (email.isEmpty && phone.isEmpty && name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Veuillez remplir au moins 1 des champs'),
                ));
              } else {
                try {
                  showReportSnackbar(context);
                } catch (e) {
                  rethrow;
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text('Signaler'),
          ),
        ],
      );
    },
  );
}
