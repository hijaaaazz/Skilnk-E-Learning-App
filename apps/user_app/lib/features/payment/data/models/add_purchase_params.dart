class AddPurchaseParams {
  final String courseId;
  final String userId;
  final String tutorId;
  final double amount;
  final String? purchaseId;

  AddPurchaseParams({
    required this.amount,
    required this.courseId,
    required this.purchaseId,
    required this.tutorId,
    required this.userId,
  });

  AddPurchaseParams copyWith({
    String? courseId,
    String? userId,
    String? tutorId,
    double? amount,
    String? purchaseId,
  }) {
    return AddPurchaseParams(
      courseId: courseId ?? this.courseId,
      userId: userId ?? this.userId,
      tutorId: tutorId ?? this.tutorId,
      amount: amount ?? this.amount,
      purchaseId: purchaseId ?? this.purchaseId,
    );
  }
}