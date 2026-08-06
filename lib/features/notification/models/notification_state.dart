class NotificationState {

  final bool hasPermission;

  const NotificationState({
    this.hasPermission = false,
  });

  NotificationState copyWith({
    bool? hasPermission,
  }) {
    return NotificationState(
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}