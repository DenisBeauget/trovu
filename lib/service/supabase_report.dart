import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseReport {
  Future<bool> reportNoShow({
    required String userId,
    required String customerName,
    required String email,
    required String phone,
  }) async {
    final supabase = Supabase.instance.client;

    try {
      final customerQuery = await supabase
          .from('customers')
          .select('id')
          .or('email.eq.$email,phone.eq.$phone')
          .limit(1)
          .maybeSingle();

      String customerId;

      if (customerQuery != null) {
        customerId = customerQuery['id'] as String;

        await supabase.rpc('increment_total_reports',
            params: {'customer_id': customerId});
      } else {
        final insertCustomerResponse = await supabase
            .from('customers')
            .insert({
              'name': customerName,
              'email': email,
              'phone': phone,
              'total_reports': 1,
              'created_at': DateTime.now().toIso8601String(),
            })
            .select()
            .single();

        customerId = insertCustomerResponse['id'] as String;
      }

      await supabase.from('reports').insert({
        'user_id': userId,
        'customer_id': customerId,
        'created_at': DateTime.now().toIso8601String(),
      }).select();

      return true;
    } catch (error) {
      rethrow;
    }
  }
}
