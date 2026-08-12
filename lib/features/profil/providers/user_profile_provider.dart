import 'package:bagimlilik/features/profil/models/user_profile.dart';
import 'package:bagimlilik/features/profil/repositories/user_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileRepositoryProvider =
Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

final userProfileProvider =
AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);

class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  late final UserProfileRepository _repository;

  @override
  Future<UserProfile?> build() async {
    _repository = ref.read(userProfileRepositoryProvider);

    return _repository.getCurrentProfile();
  }

  Future<void> refreshProfile() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => _repository.getCurrentProfile(),
    );
  }

  Future<bool> updateProfile({
    String? fullName,
    String? username,
    String? avatar,
    DateTime? birthDate,
    String? gender,
    String? maritalStatus,
    String? livingStatus,
    String? educationLevel,
    String? employmentStatus,
  }) async {
    try {
      final updatedProfile = await _repository.updateProfile(
        fullName: fullName,
        username: username,
        avatar: avatar,
        birthDate: birthDate,
        gender: gender,
        maritalStatus: maritalStatus,
        livingStatus: livingStatus,
        educationLevel: educationLevel,
        employmentStatus: employmentStatus,
      );

      if (updatedProfile == null) {
        return false;
      }

      state = AsyncData(updatedProfile);

      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return false;
    }
  }
}