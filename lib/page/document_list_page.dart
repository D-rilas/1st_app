import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentListPage extends StatefulWidget {
  const DocumentListPage({super.key});

  @override
  State<DocumentListPage> createState() => DocumentListPageState();
}

class DocumentListPageState extends State<DocumentListPage> {
  final List<Map<String, dynamic>> documents = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final supabaseService = SupabaseService();
      final data = await supabaseService.fetchDocuments();

      if (!mounted) return;

      setState(() {
        documents.clear();
        documents.addAll(data);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = 'Erreur lors du chargement des documents: $e';
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: Impossible de charger les documents'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openPDF(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d\'ouvrir le document'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadDocuments,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Une erreur est survenue',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: loadDocuments,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (documents.isEmpty) {
      return const Center(
        child: Text('Aucun document trouvé'),
      );
    }

    return RefreshIndicator(
      onRefresh: loadDocuments,
      child: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.description),
              title: Text(doc['name'] ?? 'Nom non disponible'),
              subtitle: Text(doc['type'] ?? 'Type non disponible'),
              onTap: () {
                final url = doc['url'] as String?;
                if (url != null) {
                  _openPDF(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('URL du document non disponible'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
