import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/order.model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _tableName = 'orders';

  Future<String?> createOrder(Order order) async {
    final response = await _client
        .from(_tableName)
        // Use the new Supabase-specific map
        .insert(order.toSupabaseMap()) 
        .select('id')
        .single();

    return response['id'];
  }

  Future<void> updateOrder(Order order) async {
    if (order.supabaseId == null) {
      throw Exception('Cannot update order without a supabaseId');
    }
    await _client
        .from(_tableName)
        // Use the new Supabase-specific map
        .update(order.toSupabaseMap())
        .eq('id', order.supabaseId!);
  }

    Future<List<Map<String, dynamic>>> fetchOrdersForUser(String userId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select() // Select all columns
          .eq('user_id', userId); // Filter where the user_id matches

      // The response is a List of Maps, which is exactly what we need.
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching orders from Supabase: $e');
      return []; // Return an empty list on error
    }
  }
}