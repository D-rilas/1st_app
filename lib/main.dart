import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'page/document_list_page.dart'; // Import de la page pour la liste des documents

void main() async {
  // Initialisation de Supabase
  await Supabase.initialize(
    url: 'https://wihqbdsjrbzcctpiotfb.supabase.co', // Ton URL Supabase
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpaHFiZHNqcmJ6Y2N0cGlvdGZiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczNTYzNzUwOCwiZXhwIjoyMDUxMjEzNTA4fQ.UGt4bDZ9Jfq7wY0VeijbYGXpB5eOUZbmBSi1EzsZmAQ', // Ta clé anonyme
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          const DocumentListPage(), // Page principale pour afficher les documents
    );
  }
}
