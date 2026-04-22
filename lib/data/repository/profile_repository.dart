import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final _supabase = Supabase.instance.client;

  /// Stream dữ liệu profile theo ID của user hiện tại.
  Stream<List<Map<String, dynamic>>> watchCurrentUserProfile() {
    final userId = _supabase.auth.currentUser!.id;
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId);
  }
}