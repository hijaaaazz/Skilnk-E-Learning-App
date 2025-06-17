import 'package:user_app/features/account/data/models/activity_model.dart';

abstract class ProfileState {
  final String? currentName;
  final String? currentImageUrl;

  const ProfileState({this.currentName, this.currentImageUrl});

}

class ProfileInitial extends ProfileState {
  const ProfileInitial({super.currentName, super.currentImageUrl});
}

class ProfileNameEditMode extends ProfileState {
  const ProfileNameEditMode({super.currentName, super.currentImageUrl});
}

class ProfileNameShowMode extends ProfileState {
  const ProfileNameShowMode({super.currentName, super.currentImageUrl});
}

class ProfileNameOptimisticUpdate extends ProfileState {
  final String optimisticName;

  const ProfileNameOptimisticUpdate(this.optimisticName, {super.currentImageUrl})
      : super(currentName: optimisticName);

  @override
  List<Object?> get props => [optimisticName, currentImageUrl];
}

class ProfileNameEditLoading extends ProfileState {
  final String? optimisticName;

  const ProfileNameEditLoading({this.optimisticName, super.currentImageUrl})
      : super(currentName: optimisticName);

  @override
  List<Object?> get props => [optimisticName, currentImageUrl];
}

class ProfileNameUpdated extends ProfileState {
  final String name;

  const ProfileNameUpdated(this.name, {super.currentImageUrl})
      : super(currentName: name);

  @override
  List<Object?> get props => [name, currentImageUrl];
}

class ProfileNameUpdateFailed extends ProfileState {
  const ProfileNameUpdateFailed({super.currentName, super.currentImageUrl});
}

class ProfileImageOptimisticUpdate extends ProfileState {
  final String optimisticImageUrl;

  const ProfileImageOptimisticUpdate(this.optimisticImageUrl, {super.currentName})
      : super(currentImageUrl: optimisticImageUrl);

  @override
  List<Object?> get props => [optimisticImageUrl, currentName];
}

class ProfileImagePickerLoading extends ProfileState {
  final String? optimisticImageUrl;

  const ProfileImagePickerLoading({this.optimisticImageUrl, super.currentName})
      : super(currentImageUrl: optimisticImageUrl);

  @override
  List<Object?> get props => [optimisticImageUrl, currentName];
}

class ProfileImageUpdated extends ProfileState {
  final String imageUrl;

  const ProfileImageUpdated(this.imageUrl, {super.currentName})
      : super(currentImageUrl: imageUrl);

  @override
  List<Object?> get props => [imageUrl, currentName];
}

class ProfileImageShowMode extends ProfileState {
  const ProfileImageShowMode({super.currentName, super.currentImageUrl});
}

class ProfileImageUpdateFailed extends ProfileState {
  const ProfileImageUpdateFailed({super.currentName, super.currentImageUrl});
}

class ProfileActivitiesLoading extends ProfileState {
  const ProfileActivitiesLoading({super.currentName, super.currentImageUrl});
}

class ProfileActivitiesLoaded extends ProfileState {
  final List<Activity> activities;

  const ProfileActivitiesLoaded(this.activities, {super.currentName, super.currentImageUrl});

  @override
  List<Object?> get props => [activities, currentName, currentImageUrl];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message, {super.currentName, super.currentImageUrl});

  @override
  List<Object?> get props => [message, currentName, currentImageUrl];
}