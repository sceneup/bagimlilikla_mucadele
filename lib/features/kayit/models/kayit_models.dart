class KayitState {
  final bool isLoading;
  final String? errorMessage;

  final DateTime? birthDate;
  final String? selectedGender;
  final String? selectedMaritalStatus;
  final String? selectedEducation;
  final String? selectedEmploymentStatus;
  final String? selectedLivingStatus;
  final String selectedAvatar;

  const KayitState({
    this.isLoading = false,
    this.errorMessage,
    this.birthDate,
    this.selectedGender,
    this.selectedMaritalStatus,
    this.selectedEducation,
    this.selectedEmploymentStatus,
    this.selectedLivingStatus,
    this.selectedAvatar = "assets/images/avatars/varsayilan.JPG",
  });

  KayitState copyWith({
    bool? isLoading,
    String? errorMessage,
    DateTime? birthDate,
    String? selectedGender,
    String? selectedMaritalStatus,
    String? selectedEducation,
    String? selectedEmploymentStatus,
    String? selectedLivingStatus,
    String? selectedAvatar,
  }) {
    return KayitState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      birthDate: birthDate ?? this.birthDate,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedMaritalStatus:
      selectedMaritalStatus ?? this.selectedMaritalStatus,
      selectedEducation:
      selectedEducation ?? this.selectedEducation,
      selectedEmploymentStatus:
      selectedEmploymentStatus ?? this.selectedEmploymentStatus,
      selectedLivingStatus:
      selectedLivingStatus ?? this.selectedLivingStatus,
      selectedAvatar: selectedAvatar ?? this.selectedAvatar,
    );
  }
}