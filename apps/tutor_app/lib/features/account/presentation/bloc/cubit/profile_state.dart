abstract class ProfileState {
  final String? currentName;
  final String? currentImageUrl;
  final String? currentBio;
  final List<String>? categories;
  final List<String>? interests;

  const ProfileState({
    this.currentName,
    this.currentImageUrl,
    this.currentBio,
    this.categories,
    this.interests,
  });
}

class ProfileInitial extends ProfileState {
  const ProfileInitial({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  });
}

class ProfileNameEditMode extends ProfileState {
  const ProfileNameEditMode({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  });
}

class ProfileNameShowMode extends ProfileState {
  const ProfileNameShowMode({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  });
}

class ProfileNameOptimisticUpdate extends ProfileState {
  final String optimisticName;

  const ProfileNameOptimisticUpdate(
    this.optimisticName, {
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  }) : super(currentName: optimisticName);

  @override
  List<Object?> get props => [optimisticName, currentImageUrl, currentBio, categories, interests];
}

class ProfileNameEditLoading extends ProfileState {
  final String? optimisticName;

  const ProfileNameEditLoading({
    this.optimisticName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  }) : super(currentName: optimisticName);

  @override
  List<Object?> get props => [optimisticName, currentImageUrl, currentBio, categories, interests];
}

class ProfileNameUpdated extends ProfileState {
  final String name;

  const ProfileNameUpdated(
    this.name, {
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  }) : super(currentName: name);

  @override
  List<Object?> get props => [name, currentImageUrl, currentBio, categories, interests];
}

class ProfileNameUpdateFailed extends ProfileState {
  const ProfileNameUpdateFailed({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  });
}

class ProfileImageOptimisticUpdate extends ProfileState {
  final String optimisticImageUrl;

  const ProfileImageOptimisticUpdate(
    this.optimisticImageUrl, {
    super.currentName,
    super.currentBio,
    super.categories,
    super.interests,
  }) : super(currentImageUrl: optimisticImageUrl);

  @override
  List<Object?> get props => [optimisticImageUrl, currentName, currentBio, categories, interests];
}

class ProfileImagePickerLoading extends ProfileState {
  final String? optimisticImageUrl;

  const ProfileImagePickerLoading({
    this.optimisticImageUrl,
    super.currentName,
    super.currentBio,
    super.categories,
    super.interests,
  }) : super(currentImageUrl: optimisticImageUrl);

  @override
  List<Object?> get props => [optimisticImageUrl, currentName, currentBio, categories, interests];
}

class ProfileImageUpdated extends ProfileState {
  final String imageUrl;

  const ProfileImageUpdated(
    this.imageUrl, {
    super.currentName,
    super.currentBio,
    super.categories,
    super.interests,
  }) : super(currentImageUrl: imageUrl);

  @override
  List<Object?> get props => [imageUrl, currentName, currentBio, categories, interests];
}

class ProfileImageShowMode extends ProfileState {
  const ProfileImageShowMode({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  });
}

class ProfileImageUpdateFailed extends ProfileState {
  const ProfileImageUpdateFailed({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  });
}

class ProfileBioUpdated extends ProfileState {
  final String bio;

  const ProfileBioUpdated(
    this.bio, {
    super.currentName,
    super.currentImageUrl,
    super.categories,
    super.interests,
  }) : super(currentBio: bio);

  @override
  List<Object?> get props => [bio, currentName, currentImageUrl, categories, interests];
}

class ProfileCategoriesUpdated extends ProfileState {
  final List<String> updatedCategories;

  const ProfileCategoriesUpdated(
    this.updatedCategories, {
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.interests,
  }) : super(categories: updatedCategories);

  @override
  List<Object?> get props => [updatedCategories, currentName, currentImageUrl, currentBio, interests];
}

class ProfileInterestsUpdated extends ProfileState {
  final List<String> updatedInterests;

  const ProfileInterestsUpdated(
    this.updatedInterests, {
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
  }) : super(interests: updatedInterests);

  @override
  List<Object?> get props => [updatedInterests, currentName, currentImageUrl, currentBio, categories];
}

class ProfileActivitiesLoading extends ProfileState {
  const ProfileActivitiesLoading({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  });
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(
    this.message, {
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.categories,
    super.interests,
  });

  @override
  List<Object?> get props => [message, currentName, currentImageUrl, currentBio, categories, interests];
}
