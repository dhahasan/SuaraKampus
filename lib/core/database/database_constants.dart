class DatabaseConstants {
  static const String databaseName = 'suara_kampus.db';
  static const int databaseVersion = 1;

  // Table names
  static const String tableUsers = 'users';
  static const String tableMenfess = 'menfess';
  static const String tableReports = 'reports';
  static const String tableDispositions = 'dispositions';
  static const String tableDispositionLogs = 'disposition_logs';
  static const String tableInstagramPosts = 'instagram_posts';

  // Users columns
  static const String colUserId = 'id';
  static const String colUserEmail = 'email';
  static const String colUserRole = 'role';
  static const String colUserVerificationStatus = 'verification_status';
  static const String colUserKtmUrl = 'ktm_url';
  static const String colUserMonthlyQuotaUsed = 'monthly_quota_used';
  static const String colUserMonthlyQuotaMax = 'monthly_quota_max';
  static const String colUserRejectionReason = 'rejection_reason';

  // Menfess columns
  static const String colMenfessId = 'id';
  static const String colMenfessCode = 'code';
  static const String colMenfessCategory = 'category';
  static const String colMenfessBody = 'body';
  static const String colMenfessAttachmentUrl = 'attachment_url';
  static const String colMenfessAttachmentName = 'attachment_name';
  static const String colMenfessStatus = 'status';
  static const String colMenfessAllowInstagram = 'allow_instagram';
  static const String colMenfessIsAnonymous = 'is_anonymous';
  static const String colMenfessSupportCount = 'support_count';
  static const String colMenfessReportCount = 'report_count';
  static const String colMenfessCreatedAt = 'created_at';
  static const String colMenfessReportReasonSummary = 'report_reason_summary';
  static const String colMenfessIsSensitive = 'is_sensitive';

  // Reports columns
  static const String colReportId = 'id';
  static const String colReportMenfessId = 'menfess_id';
  static const String colReportReason = 'reason';
  static const String colReportCreatedAt = 'created_at';

  // Dispositions columns
  static const String colDispId = 'id';
  static const String colDispTicketCode = 'ticket_code';
  static const String colDispMenfessId = 'menfess_id';
  static const String colDispUnit = 'unit';
  static const String colDispUnitLocation = 'unit_location';
  static const String colDispStatus = 'status';
  static const String colDispEstimateRemaining = 'estimate_remaining';
  static const String colDispIsOverdue = 'is_overdue';
  static const String colDispMenfessQuote = 'menfess_quote';
  static const String colDispCorrespondenceDetail = 'correspondence_detail';

  // Disposition Logs columns
  static const String colLogId = 'id';
  static const String colLogDispositionId = 'disposition_id';
  static const String colLogTime = 'time';
  static const String colLogText = 'text';

  // Instagram Posts columns
  static const String colIgId = 'id';
  static const String colIgScheduleNumber = 'schedule_number';
  static const String colIgMenfessId = 'menfess_id';
  static const String colIgScheduledTimeText = 'scheduled_time_text';
  static const String colIgFormat = 'format';
  static const String colIgQuoteText = 'quote_text';
  static const String colIgCaption = 'caption';
  static const String colIgFacultyTag = 'faculty_tag';
  static const String colIgAutoPublish = 'auto_publish';
  static const String colIgStatus = 'status';
}

