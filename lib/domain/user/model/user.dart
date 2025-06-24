class User {
  final int xp;
  final String id;
  final int level;
  final Goal? goal;
  final String name;
  final String email;
  final String username;
  final int nextLevelXp;
  final DateTime birthDate;

  User({
    this.goal,
    required this.id,
    required this.xp,
    required this.name,
    required this.email,
    required this.level,
    required this.username,
    required this.birthDate,
    required this.nextLevelXp,
  });

  User copyWith({
    int? xp,
    String? id,
    int? level,
    Goal? goal,
    String? email,
    String? username,
    String? fullName,
    int? nextLevelXp,
    DateTime? birthDate,
  }) {
    return User(
      xp: xp ?? this.xp,
      id: id ?? this.id,
      name: fullName ?? name,
      goal: goal ?? this.goal,
      level: level ?? this.level,
      email: email ?? this.email,
      username: username ?? this.username,
      birthDate: birthDate ?? this.birthDate,
      nextLevelXp: nextLevelXp ?? this.nextLevelXp,
    );
  }
}

class Goal {
  final int? daysPerWeek;
  final int? dailyDistanceInMeters;
  final List<WeekActivity>? weeklyDistances;

  const Goal({
    this.daysPerWeek,
    this.dailyDistanceInMeters,
    this.weeklyDistances,
  });

  List<int> get weeklyDistancesInMeters {
    return weeklyDistances?.map((e) => e.distanceInMeters).toList() ?? [];
  }
}

class WeekActivity {
  final DateTime day;
  final int distanceInMeters;

  WeekActivity({
    required this.day,
    required this.distanceInMeters,
  });
}
