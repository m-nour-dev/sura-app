import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSchemaInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initialize() async {
    const userId = 'exampleUser123';
    const circleId = 'circle123';
    const planId = 'plan123';
    const chatId = 'chat123';
    const lessonId = 'lesson123';

    // USERS
    await _firestore.collection('users').doc(userId).set({
      'uid': userId,
      'name': 'Ahmed',
      'email': 'ahmed@example.com',
      'photoUrl': '',
      'role': 'student',
      'country': 'Turkey',
      'level': 'beginner',
      'goal': 'memorize',
      'dailyMinutes': 30,
      'linkWithPrayer': true,
      'streakDays': 0,
      'lastActiveDate': Timestamp.now(),
      'totalHours': 0.0,
      'recitationHours': 0.0,
      'memorizedJuz': 0,
      'rank': 0,
      'activityLevel': 'low',
      'createdAt': Timestamp.now(),
    });

    // ACTIVITY
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('activity')
        .doc('2026-05-09')
        .set({
      'date': Timestamp.now(),
      'minutesSpent': 0,
      'pagesMemorized': 0,
      'pagesReviewed': 0,
      'didTadabbur': false,
    });

    // ACHIEVEMENTS
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .doc('achievement1')
        .set({
      'title': 'First Achievement',
      'iconUrl': '',
      'earnedAt': Timestamp.now(),
      'type': 'streak',
    });

    // CIRCLES
    await _firestore.collection('circles').doc(circleId).set({
      'name': 'Quran Circle',
      'teacherId': 'teacher123',
      'teacherName': 'Abdullah',
      'description': 'Circle for Quran memorization',
      'level': 'beginner',
      'maxStudents': 20,
      'currentStudents': 1,
      'isActive': true,
      'schedule': 'Daily',
      'country': 'Turkey',
      'createdAt': Timestamp.now(),
    });

    // MEMBERS
    await _firestore
        .collection('circles')
        .doc(circleId)
        .collection('members')
        .doc(userId)
        .set({
      'userId': userId,
      'name': 'Ahmed',
      'photoUrl': '',
      'role': 'student',
      'joinedAt': Timestamp.now(),
      'status': 'active',
    });

    // MESSAGES
    await _firestore
        .collection('circles')
        .doc(circleId)
        .collection('messages')
        .doc('message1')
        .set({
      'senderId': userId,
      'senderName': 'Ahmed',
      'senderPhoto': '',
      'type': 'text',
      'content': 'السلام عليكم',
      'audioUrl': '',
      'widgetData': {},
      'createdAt': Timestamp.now(),
    });

    // DAILY TASKS
    await _firestore
        .collection('circles')
        .doc(circleId)
        .collection('dailyTasks')
        .doc('task1')
        .set({
      'teacherId': 'teacher123',
      'date': Timestamp.now(),
      'tasks': [
        {
          'title': 'حفظ',
          'completedBy': [userId]
        }
      ]
    });

    // PLANS
    await _firestore.collection('plans').doc(planId).set({
      'userId': userId,
      'circleId': circleId,
      'teacherId': 'teacher123',
      'startPage': 1,
      'endPage': 20,
      'dailyPages': 2,
      'startDate': Timestamp.now(),
      'estimatedEndDate': Timestamp.now(),
      'status': 'active',
      'approvedByTeacher': true,
      'createdAt': Timestamp.now(),
    });

    // PLAN SESSIONS
    await _firestore
        .collection('plans')
        .doc(planId)
        .collection('sessions')
        .doc('session1')
        .set({
      'date': Timestamp.now(),
      'pageStart': 1,
      'pageEnd': 2,
      'type': 'memorize',
      'status': 'present',
      'teacherNote': '',
      'rating': 5,
      'audioUrl': '',
      'errors': [],
      'approvedByTeacher': true,
    });

    // NOTES
    await _firestore.collection('notes').doc('note1').set({
      'targetUserId': userId,
      'teacherId': 'teacher123',
      'circleId': circleId,
      'type': 'correction',
      'content': 'راجع التجويد',
      'pageNumber': 1,
      'ayahNumber': 1,
      'isRead': false,
      'isPinned': false,
      'audioUrl': '',
      'createdAt': Timestamp.now(),
    });

    // TADABBUR
    await _firestore.collection('tadabbur').doc(lessonId).set({
      'title': 'Lesson 1',
      'subtitle': 'Introduction',
      'content': 'Content here',
      'imageUrl': '',
      'surah': 1,
      'ayahStart': 1,
      'ayahEnd': 7,
      'pageNumber': 1,
      'level': 1,
      'estimatedMinutes': 10,
      'isPublished': true,
    });

    // TADABBUR PROGRESS
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tadabburProgress')
        .doc(lessonId)
        .set({
      'lessonId': lessonId,
      'isCompleted': false,
      'completedAt': Timestamp.now(),
    });

    // PRIVATE CHATS
    await _firestore.collection('privateChats').doc(chatId).set({
      'teacherId': 'teacher123',
      'studentId': userId,
      'circleId': circleId,
      'lastMessage': 'مرحبا',
      'lastMessageTime': Timestamp.now(),
    });

    // PRIVATE CHAT MESSAGES
    await _firestore
        .collection('privateChats')
        .doc(chatId)
        .collection('messages')
        .doc('message1')
        .set({
      'senderId': userId,
      'type': 'text',
      'content': 'السلام عليكم',
      'audioUrl': '',
      'rating': 0,
      'ratingNote': '',
      'pageNumber': 1,
      'ayahNumber': 1,
      'isRead': false,
      'createdAt': Timestamp.now(),
    });

    // LEADERBOARD
    await _firestore
        .collection('leaderboard')
        .doc('circles')
        .collection(circleId)
        .doc('stats')
        .set({
      'circleId': circleId,
      'circleName': 'Quran Circle',
      'teacherName': 'Abdullah',
      'totalReviews': 0,
      'totalRecitations': 0,
      'totalLogins': 0,
      'rank': 1,
      'weeklyScore': 0,
      'updatedAt': Timestamp.now(),
    });

    print(' Firestore schema initialized');
  }
}