import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:optigo/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus { initial, loading, codeSent, verifying, authenticated, unregistered , error}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth;
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Helper để lấy Supabase client với Firebase token
  SupabaseClient get _authenticatedSupabase {
    // Lưu ý: Trong thực tế, bạn nên cập nhật token này định kỳ
    // Ở đây ta sử dụng client hiện tại nhưng sẽ truyền token vào headers mỗi khi gọi
    return _supabase;
  }

  AuthProvider({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.initial;

  String? errorText;
  AuthStatus get status => _status;
  String? get errorMessage => errorText;

  UserModel? _user;
  UserModel? get user => _user;

  bool get isLoading => status == AuthStatus.loading;
  bool get isSent => status == AuthStatus.codeSent;
  bool get isVerifying => status == AuthStatus.verifying;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isError => status == AuthStatus.error;

  String? _verificationId;

  Future<void> sendOtp(String phoneNumber) async {
    try {
      _status = AuthStatus.loading;
      errorText = null;
      notifyListeners();

      final completer = Completer<void>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('[AUTH] verificationCompleted fired');
          try {
            UserCredential userCredential = await _auth.signInWithCredential(credential);
            await _handleUserSignIn(userCredential);
          } catch (e) {
            if (!completer.isCompleted) completer.completeError(e);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('[AUTH] verificationFailed fired: ${e.code} - ${e.message}');
          errorText = e.message ?? e.toString();
          _status = AuthStatus.error;
          notifyListeners();
          if (!completer.isCompleted) completer.completeError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          print('[AUTH] codeSent fired! verificationId: $verificationId');
          _verificationId = verificationId;
          _status = AuthStatus.codeSent;
          notifyListeners();
          if (!completer.isCompleted) completer.complete();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('[AUTH] codeAutoRetrievalTimeout fired');
          _verificationId = verificationId;
        },
      );

      return completer.future;
    } catch (e) {
      errorText = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    if (_verificationId == null) {
      return;
    }
    try {
      _status = AuthStatus.verifying;
      errorText = null;
      notifyListeners();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      await _handleUserSignIn(userCredential);
    } on FirebaseAuthException catch (e) {
      errorText = e.message ?? e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      errorText = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      rethrow;
    }
  }
  Future<void> updateProfile(String name, UserRole role) async {
    if (_user == null) return;
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      // Lấy ID Token từ Firebase
      final idToken = await _auth.currentUser?.getIdToken();

      // Lưu vào Supabase profiles với JWT của Firebase
      await SupabaseClient(
        dotenv.env['SUPABASE_URL']!,
        dotenv.env['SUPABASE_ANON_KEY']!,
        headers: {'Authorization': 'Bearer $idToken'},
      ).from('profiles').upsert({
        'id': _user!.uid,
        'user_name': name,
        'phone': _user!.phoneNumber,
        'role': role.name,
        'updated_at': DateTime.now().toIso8601String(),
      });

      _user = UserModel(
        uid: _user!.uid,
        userName: name,
        phoneNumber: _user!.phoneNumber,
        role: role,
      );
      _status = AuthStatus.authenticated;

      notifyListeners();
    } catch (e) {
      debugPrint("Lỗi cập nhật profile: $e");
      errorText = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
    }
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _status = AuthStatus.initial;
    notifyListeners();
  }

  Future<void> _handleUserSignIn(UserCredential userCredential) async {
    final String uid = userCredential.user?.uid ?? '';
    await _loadUserProfile(uid);
    notifyListeners();
  }
  Future<void> _loadUserProfile(String uid) async {
    final idToken = await _auth.currentUser?.getIdToken();

    // Đọc thông tin từ Supabase với JWT của Firebase
    final response = await SupabaseClient(
      dotenv.env['SUPABASE_URL']!,
      dotenv.env['SUPABASE_ANON_KEY']!,
      headers: {'Authorization': 'Bearer $idToken'},
    ).from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (response != null) {
      final profileData = Map<String, dynamic>.from(response);
      profileData['phone_number'] = response['phone'];

      _user = UserModel.formMap(profileData, uid);
      _status = AuthStatus.authenticated;
    } else {
      _user = UserModel(
        uid: uid,
        userName: '',
        phoneNumber: _auth.currentUser?.phoneNumber ?? '',
      );
      _status = AuthStatus.unregistered;
    }
  }

  Future<void> checkAuthStatus() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _loadUserProfile(currentUser.uid);
    }else{
      _status = AuthStatus.initial;
      notifyListeners();
    }
  }
}
