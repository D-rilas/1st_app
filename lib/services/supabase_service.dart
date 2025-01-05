import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchDocuments() async {
    try {
      final response = await supabase.from('documents').select();
      return response;
    } catch (e) {
      print('Erreur lors de la récupération des documents : $e');
      return [];
    }
  }
}
