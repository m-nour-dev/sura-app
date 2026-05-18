import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String role; // 'student' or 'teacher'
  final String? country;
  final String? level;
  final String? goal;
  final int dailyMinutes;
  final bool linkWithPrayer;
  final int streakDays;
  final DateTime? lastActiveDate;
  final double totalHours;
  final double recitationHours;
  final int memorizedJuz;
  final int rank;
  final String activityLevel;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.role,
    this.country,
    this.level,
    this.goal,
    this.dailyMinutes = 0,
    this.linkWithPrayer = false,
    this.streakDays = 0,
    this.lastActiveDate,
    this.totalHours = 0.0,
    this.recitationHours = 0.0,
    this.memorizedJuz = 0,
    this.rank = 0,
    this.activityLevel = 'active',
    this.createdAt,
  });

  // من Firestore إلى التطبيق
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      role: map['role'] ?? 'student',
      country: map['country'],
      level: map['level'],
      goal: map['goal'],
      dailyMinutes: map['dailyMinutes']?.toInt() ?? 0,
      linkWithPrayer: map['linkWithPrayer'] ?? false,
      streakDays: map['streakDays']?.toInt() ?? 0,
      lastActiveDate: (map['lastActiveDate'] as Timestamp?)?.toDate(),
      totalHours: map['totalHours']?.toDouble() ?? 0.0,
      recitationHours: map['recitationHours']?.toDouble() ?? 0.0,
      memorizedJuz: map['memorizedJuz']?.toInt() ?? 0,
      rank: map['rank']?.toInt() ?? 0,
      activityLevel: map['activityLevel'] ?? 'active',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // من التطبيق إلى Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
      'country': country,
      'level': level,
      'goal': goal,
      'dailyMinutes': dailyMinutes,
      'linkWithPrayer': linkWithPrayer,
      'streakDays': streakDays,
      'lastActiveDate': lastActiveDate != null
          ? Timestamp.fromDate(lastActiveDate!)
          : FieldValue.serverTimestamp(),
      'totalHours': totalHours,
      'recitationHours': recitationHours,
      'memorizedJuz': memorizedJuz,
      'rank': rank,
      'activityLevel': activityLevel,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
