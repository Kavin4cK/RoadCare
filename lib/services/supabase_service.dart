import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance =>
      _instance ??= SupabaseService._internal();

  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    final envString = await rootBundle.loadString('env.json');
    final env = json.decode(envString);

    final supabaseUrl = env["SUPABASE_URL"];
    final supabaseAnonKey = env["SUPABASE_ANON_KEY"];

    if (supabaseUrl==null || supabaseAnonKey==null) {
      throw Exception(
          'Supabase URL and Anon Key are required. Please check your env.json file.');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: false,
    );
  }

  // Authentication methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
    String? role,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName ?? '',
          'role': role ?? 'citizen',
        },
      );
      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  // User Profile methods
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) return null;

      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final user = client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await client.from('user_profiles').update(updates).eq('id', user.id);
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
  }

  // Issues methods
  Future<List<dynamic>> getIssues({
    String? status,
    String? category,
    String? priority,
    int? limit,
  }) async {
    try {
      var query = client.from('issues').select('''
            *,
            reporter:user_profiles!reporter_id(*),
            assigned_worker:user_profiles!assigned_worker_id(*)
          ''');

      if (status != null) {
        query = query.eq('status', status);
      }
      if (category != null) {
        query = query.eq('category', category);
      }
      if (priority != null) {
        query = query.eq('priority', priority);
      }

      final response =
          await query.order('created_at', ascending: false).limit(limit ?? 50);

      return response;
    } catch (error) {
      throw Exception('Failed to get issues: $error');
    }
  }

  Future<Map<String, dynamic>> createIssue({
    required String title,
    required String description,
    required String category,
    String priority = 'medium',
    double? latitude,
    double? longitude,
    String? address,
    String? beforeImageUrl,
  }) async {
    try {
      final user = client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await client
          .from('issues')
          .insert({
            'reporter_id': user.id,
            'title': title,
            'description': description,
            'category': category,
            'priority': priority,
            'location_latitude': latitude,
            'location_longitude': longitude,
            'location_address': address,
            'before_image_url': beforeImageUrl,
          })
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to create issue: $error');
    }
  }

  Future<void> updateIssueStatus({
    required String issueId,
    required String status,
    String? afterImageUrl,
    double? actualCost,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (afterImageUrl != null) {
        updates['after_image_url'] = afterImageUrl;
      }
      if (actualCost != null) {
        updates['actual_cost'] = actualCost;
      }
      if (status == 'completed') {
        updates['completion_date'] = DateTime.now().toIso8601String();
      }

      await client.from('issues').update(updates).eq('id', issueId);
    } catch (error) {
      throw Exception('Failed to update issue status: $error');
    }
  }

  // Comments methods
  Future<List<dynamic>> getIssueComments(String issueId) async {
    try {
      final response = await client.from('issue_comments').select('''
            *,
            commenter:user_profiles!commenter_id(*)
          ''').eq('issue_id', issueId).order('created_at', ascending: true);

      return response;
    } catch (error) {
      throw Exception('Failed to get comments: $error');
    }
  }

  Future<Map<String, dynamic>> addComment({
    required String issueId,
    required String comment,
    bool isInternal = false,
  }) async {
    try {
      final user = client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await client
          .from('issue_comments')
          .insert({
            'issue_id': issueId,
            'commenter_id': user.id,
            'comment': comment,
            'is_internal': isInternal,
          })
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to add comment: $error');
    }
  }

  // Voting methods
  Future<void> voteOnIssue({
    required String issueId,
    required String voteType, // 'upvote' or 'downvote'
  }) async {
    try {
      final user = client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await client.from('issue_votes').upsert({
        'issue_id': issueId,
        'voter_id': user.id,
        'vote_type': voteType,
      });
    } catch (error) {
      throw Exception('Failed to vote: $error');
    }
  }

  Future<Map<String, dynamic>> getIssueVotes(String issueId) async {
    try {
      final response =
          await client.from('issue_votes').select().eq('issue_id', issueId);

      final upvotes =
          response.where((vote) => vote['vote_type'] == 'upvote').length;
      final downvotes =
          response.where((vote) => vote['vote_type'] == 'downvote').length;

      return {
        'upvotes': upvotes,
        'downvotes': downvotes,
        'total': upvotes + downvotes,
      };
    } catch (error) {
      throw Exception('Failed to get votes: $error');
    }
  }

  // Storage methods
  Future<String> uploadImage({
    required String bucketName,
    required String filePath,
    required List<int> fileBytes,
    String? contentType,
  }) async {
    try {
      await client.storage.from(bucketName).uploadBinary(filePath, Uint8List.fromList(fileBytes));

      final url = client.storage.from(bucketName).getPublicUrl(filePath);

      return url;
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }

  Future<void> deleteImage({
    required String bucketName,
    required String filePath,
  }) async {
    try {
      await client.storage.from(bucketName).remove([filePath]);
    } catch (error) {
      throw Exception('Failed to delete image: $error');
    }
  }

  // Real-time subscriptions
  RealtimeChannel subscribeToIssueUpdates(
      String issueId, Function(dynamic) callback) {
    return client
        .channel('issue_updates_$issueId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'issues',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: issueId,
          ),
          callback: callback,
        )
        .subscribe();
  }

  // Utility methods
  User? get currentUser => client.auth.currentUser;

  bool get isAuthenticated => client.auth.currentUser != null;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}