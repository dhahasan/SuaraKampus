import 'package:flutter/foundation.dart';

enum UserRole { student, admin }

enum VerificationStatus { pending, verified, rejected }

enum MenfessCategory {
  semua,
  akademik,
  sarpras,
  keuangan,
  layananIt,
}

extension MenfessCategoryExtension on MenfessCategory {
  String get label {
    switch (this) {
      case MenfessCategory.semua:
        return 'Semua';
      case MenfessCategory.akademik:
        return 'Akademik';
      case MenfessCategory.sarpras:
        return 'Sarpras';
      case MenfessCategory.keuangan:
        return 'Keuangan';
      case MenfessCategory.layananIt:
        return 'Layanan IT';
    }
  }

  String get fullDisplayName {
    switch (this) {
      case MenfessCategory.semua:
        return 'Semua Kategori';
      case MenfessCategory.akademik:
        return 'Akademik & Dosen';
      case MenfessCategory.sarpras:
        return 'Sarana dan prasarana';
      case MenfessCategory.keuangan:
        return 'Keuangan & UKT';
      case MenfessCategory.layananIt:
        return 'Layanan IT & Fasilitas';
    }
  }
}

enum MenfessStatus {
  pending,
  approved,
  rejected,
  inProgress,
  resolved,
}

extension MenfessStatusExtension on MenfessStatus {
  String get label {
    switch (this) {
      case MenfessStatus.pending:
        return 'Menunggu';
      case MenfessStatus.approved:
        return 'Disetujui';
      case MenfessStatus.rejected:
        return 'Ditolak';
      case MenfessStatus.inProgress:
        return 'Diproses';
      case MenfessStatus.resolved:
        return 'Selesai';
    }
  }
}

@immutable
class AppUser {
  final String id;
  final String email;
  final UserRole role;
  final VerificationStatus verificationStatus;
  final String? ktmUrl;
  final int monthlyQuotaUsed;
  final int monthlyQuotaMax;
  final String? rejectionReason;

  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    required this.verificationStatus,
    this.ktmUrl,
    this.monthlyQuotaUsed = 2,
    this.monthlyQuotaMax = 5,
    this.rejectionReason,
  });

  int get remainingQuota => (monthlyQuotaMax - monthlyQuotaUsed).clamp(0, monthlyQuotaMax);
  bool get isQuotaExhausted => remainingQuota <= 0;
  bool get isVerified => verificationStatus == VerificationStatus.verified;
  bool get isAdmin => role == UserRole.admin;

  AppUser copyWith({
    String? id,
    String? email,
    UserRole? role,
    VerificationStatus? verificationStatus,
    String? ktmUrl,
    int? monthlyQuotaUsed,
    int? monthlyQuotaMax,
    String? rejectionReason,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      ktmUrl: ktmUrl ?? this.ktmUrl,
      monthlyQuotaUsed: monthlyQuotaUsed ?? this.monthlyQuotaUsed,
      monthlyQuotaMax: monthlyQuotaMax ?? this.monthlyQuotaMax,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'role': role.name,
    'verificationStatus': verificationStatus.name,
    'ktmUrl': ktmUrl,
    'monthlyQuotaUsed': monthlyQuotaUsed,
    'monthlyQuotaMax': monthlyQuotaMax,
    'rejectionReason': rejectionReason,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    email: json['email'] as String,
    role: UserRole.values.byName(json['role'] as String),
    verificationStatus: VerificationStatus.values.byName(json['verificationStatus'] as String),
    ktmUrl: json['ktmUrl'] as String?,
    monthlyQuotaUsed: json['monthlyQuotaUsed'] as int? ?? 2,
    monthlyQuotaMax: json['monthlyQuotaMax'] as int? ?? 5,
    rejectionReason: json['rejectionReason'] as String?,
  );
}

@immutable
class Menfess {
  final String id;
  final String code; // "MNF-1042"
  final MenfessCategory category;
  final String body;
  final String? attachmentUrl;
  final String? attachmentName;
  final MenfessStatus status;
  final bool allowInstagram;
  final bool isAnonymous;
  final int supportCount;
  final int reportCount;
  final DateTime createdAt;
  final String? reportReasonSummary;
  final bool isSensitive;

  const Menfess({
    required this.id,
    required this.code,
    required this.category,
    required this.body,
    this.attachmentUrl,
    this.attachmentName,
    required this.status,
    this.allowInstagram = true,
    this.isAnonymous = true,
    this.supportCount = 0,
    this.reportCount = 0,
    required this.createdAt,
    this.reportReasonSummary,
    this.isSensitive = false,
  });

  Menfess copyWith({
    String? id,
    String? code,
    MenfessCategory? category,
    String? body,
    String? attachmentUrl,
    String? attachmentName,
    MenfessStatus? status,
    bool? allowInstagram,
    bool? isAnonymous,
    int? supportCount,
    int? reportCount,
    DateTime? createdAt,
    String? reportReasonSummary,
    bool? isSensitive,
  }) {
    return Menfess(
      id: id ?? this.id,
      code: code ?? this.code,
      category: category ?? this.category,
      body: body ?? this.body,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentName: attachmentName ?? this.attachmentName,
      status: status ?? this.status,
      allowInstagram: allowInstagram ?? this.allowInstagram,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      supportCount: supportCount ?? this.supportCount,
      reportCount: reportCount ?? this.reportCount,
      createdAt: createdAt ?? this.createdAt,
      reportReasonSummary: reportReasonSummary ?? this.reportReasonSummary,
      isSensitive: isSensitive ?? this.isSensitive,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'category': category.name,
    'body': body,
    'attachmentUrl': attachmentUrl,
    'attachmentName': attachmentName,
    'status': status.name,
    'allowInstagram': allowInstagram,
    'isAnonymous': isAnonymous,
    'supportCount': supportCount,
    'reportCount': reportCount,
    'createdAt': createdAt.toIso8601String(),
    'reportReasonSummary': reportReasonSummary,
    'isSensitive': isSensitive,
  };

  factory Menfess.fromJson(Map<String, dynamic> json) => Menfess(
    id: json['id'] as String,
    code: json['code'] as String,
    category: MenfessCategory.values.byName(json['category'] as String),
    body: json['body'] as String,
    attachmentUrl: json['attachmentUrl'] as String?,
    attachmentName: json['attachmentName'] as String?,
    status: MenfessStatus.values.byName(json['status'] as String),
    allowInstagram: json['allowInstagram'] as bool? ?? true,
    isAnonymous: json['isAnonymous'] as bool? ?? true,
    supportCount: json['supportCount'] as int? ?? 0,
    reportCount: json['reportCount'] as int? ?? 0,
    createdAt: DateTime.parse(json['createdAt'] as String),
    reportReasonSummary: json['reportReasonSummary'] as String?,
    isSensitive: json['isSensitive'] as bool? ?? false,
  );
}

@immutable
class Report {
  final String id;
  final String menfessId;
  final String reason;
  final DateTime createdAt;

  const Report({
    required this.id,
    required this.menfessId,
    required this.reason,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'menfessId': menfessId,
    'reason': reason,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    id: json['id'] as String,
    menfessId: json['menfessId'] as String,
    reason: json['reason'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

@immutable
class DispositionLog {
  final String time;
  final String text;

  const DispositionLog({required this.time, required this.text});

  Map<String, dynamic> toJson() => {'time': time, 'text': text};
  factory DispositionLog.fromJson(Map<String, dynamic> json) =>
      DispositionLog(time: json['time'] as String, text: json['text'] as String);
}

@immutable
class Disposition {
  final String id;
  final String ticketCode; // e.g. #SK-8821
  final String menfessId;
  final String unit; // e.g. "Biro Sarana & Prasarana", "Layanan IT & Jaringan"
  final String unitLocation; // e.g. "Gedung 3", "Perpustakaan Lt. 2"
  final String status; // "Diproses", "Menunggu Respons", "Selesai"
  final String estimateRemaining; // "2 hari kerja" or "Telah melebihi 24 jam batas"
  final bool isOverdue;
  final String menfessQuote;
  final String? correspondenceDetail;
  final List<DispositionLog> logs;

  const Disposition({
    required this.id,
    required this.ticketCode,
    required this.menfessId,
    required this.unit,
    required this.unitLocation,
    required this.status,
    required this.estimateRemaining,
    this.isOverdue = false,
    required this.menfessQuote,
    this.correspondenceDetail,
    this.logs = const [],
  });

  Disposition copyWith({
    String? id,
    String? ticketCode,
    String? menfessId,
    String? unit,
    String? unitLocation,
    String? status,
    String? estimateRemaining,
    bool? isOverdue,
    String? menfessQuote,
    String? correspondenceDetail,
    List<DispositionLog>? logs,
  }) {
    return Disposition(
      id: id ?? this.id,
      ticketCode: ticketCode ?? this.ticketCode,
      menfessId: menfessId ?? this.menfessId,
      unit: unit ?? this.unit,
      unitLocation: unitLocation ?? this.unitLocation,
      status: status ?? this.status,
      estimateRemaining: estimateRemaining ?? this.estimateRemaining,
      isOverdue: isOverdue ?? this.isOverdue,
      menfessQuote: menfessQuote ?? this.menfessQuote,
      correspondenceDetail: correspondenceDetail ?? this.correspondenceDetail,
      logs: logs ?? this.logs,
    );
  }
}

@immutable
class InstagramPost {
  final String id;
  final String scheduleNumber; // e.g. "#83", "#84"
  final String menfessId;
  final String scheduledTimeText; // e.g. "19:00 WIB", "Besok, 12:00 WIB"
  final String format; // "Carousel (3/3)" or "Format Single Post"
  final String quoteText;
  final String caption;
  final String facultyTag;
  final bool autoPublish;
  final String status; // "Terjadwal", "Draft Desain Feed", "Sudah Terbit"

  const InstagramPost({
    required this.id,
    required this.scheduleNumber,
    required this.menfessId,
    required this.scheduledTimeText,
    required this.format,
    required this.quoteText,
    required this.caption,
    required this.facultyTag,
    this.autoPublish = true,
    this.status = 'Terjadwal',
  });

  InstagramPost copyWith({
    String? id,
    String? scheduleNumber,
    String? menfessId,
    String? scheduledTimeText,
    String? format,
    String? quoteText,
    String? caption,
    String? facultyTag,
    bool? autoPublish,
    String? status,
  }) {
    return InstagramPost(
      id: id ?? this.id,
      scheduleNumber: scheduleNumber ?? this.scheduleNumber,
      menfessId: menfessId ?? this.menfessId,
      scheduledTimeText: scheduledTimeText ?? this.scheduledTimeText,
      format: format ?? this.format,
      quoteText: quoteText ?? this.quoteText,
      caption: caption ?? this.caption,
      facultyTag: facultyTag ?? this.facultyTag,
      autoPublish: autoPublish ?? this.autoPublish,
      status: status ?? this.status,
    );
  }
}

@immutable
class WeeklyTrend {
  final String week; // "Mgg 1", "Mgg 2", "Mgg 3", "Mgg 4"
  final int incoming;
  final int resolved;

  const WeeklyTrend({
    required this.week,
    required this.incoming,
    required this.resolved,
  });
}

@immutable
class CategoryDistribution {
  final String categoryName;
  final int count;
  final double percentage;

  const CategoryDistribution({
    required this.categoryName,
    required this.count,
    required this.percentage,
  });
}

@immutable
class UnitPerformance {
  final String name;
  final String avgResponse;
  final double rate;
  final String badgeText;
  final String badgeType; // "success", "info", "danger"

  const UnitPerformance({
    required this.name,
    required this.avgResponse,
    required this.rate,
    required this.badgeText,
    required this.badgeType,
  });
}

@immutable
class AnalyticsSummary {
  final int total;
  final String totalTrend;
  final double resolvedRate;
  final String resolvedRateNote;
  final double avgResponseDays;
  final String avgResponseNote;
  final int violations;
  final String violationsNote;
  final List<WeeklyTrend> weeklyTrend;
  final List<CategoryDistribution> categoryDistribution;
  final List<UnitPerformance> unitPerformance;

  const AnalyticsSummary({
    required this.total,
    required this.totalTrend,
    required this.resolvedRate,
    required this.resolvedRateNote,
    required this.avgResponseDays,
    required this.avgResponseNote,
    required this.violations,
    required this.violationsNote,
    required this.weeklyTrend,
    required this.categoryDistribution,
    required this.unitPerformance,
  });
}
