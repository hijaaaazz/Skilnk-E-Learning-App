import 'dart:typed_data';

abstract class ProfileState {
  final String? currentName;
  final String? currentImageUrl;
  final String? currentBio;
  final List<String>? userCategories;
  final List<String>? interests;

  const ProfileState({
    this.currentName,
    this.currentImageUrl,
    this.currentBio,
    this.userCategories,
    this.interests,
  });
}

class ProfileInitial extends ProfileState {
  const ProfileInitial({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  });
}

class ProfileNameEditMode extends ProfileState {
  const ProfileNameEditMode({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  });
}

class ProfileNameShowMode extends ProfileState {
  const ProfileNameShowMode({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  });
}

class ProfileNameOptimisticUpdate extends ProfileState {
  final String optimisticName;

  const ProfileNameOptimisticUpdate(
    this.optimisticName, {
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  }) : super(currentName: optimisticName);
}

class ProfileNameEditLoading extends ProfileState {
  final String? optimisticName;

  const ProfileNameEditLoading({
    this.optimisticName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  }) : super(currentName: optimisticName);
}

class ProfileNameUpdated extends ProfileState {
  final String name;

  const ProfileNameUpdated(
    this.name, {
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  }) : super(currentName: name);
}

class ProfileNameUpdateFailed extends ProfileState {
  const ProfileNameUpdateFailed({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  });
}

class ProfileImageOptimisticUpdate extends ProfileState {
  final String optimisticImageUrl;

  const ProfileImageOptimisticUpdate(
    this.optimisticImageUrl, {
    super.currentName,
    super.currentBio,
    super.userCategories,
    super.interests,
  }) : super(currentImageUrl: optimisticImageUrl);
}

class ProfileImagePickerLoading extends ProfileState {
  final String? optimisticImageUrl;

  const ProfileImagePickerLoading({
    this.optimisticImageUrl,
    super.currentName,
    super.currentBio,
    super.userCategories,
    super.interests,
  }) : super(currentImageUrl: optimisticImageUrl);
}

class ProfileImageUpdated extends ProfileState {
  final String imageUrl;
  final Uint8List? imageBytes; // Only for web

  const ProfileImageUpdated(
    this.imageUrl, {
    this.imageBytes,
    super.currentName,
    super.currentBio,
    super.userCategories,
    super.interests,
  }) : super(currentImageUrl: imageUrl);
}


class ProfileImageShowMode extends ProfileState {
  const ProfileImageShowMode({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  });
}

class ProfileImageUpdateFailed extends ProfileState {
  const ProfileImageUpdateFailed({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  });
}

class ProfileBioOptimisticUpdate extends ProfileState {
  final String optimisticBio;

  const ProfileBioOptimisticUpdate(
    this.optimisticBio, {
    super.currentName,
    super.currentImageUrl,
    super.userCategories,
    super.interests,
  }) : super(currentBio: optimisticBio);
}

class ProfileBioLoading extends ProfileState {
  final String? optimisticBio;

  const ProfileBioLoading({
    this.optimisticBio,
    super.currentName,
    super.currentImageUrl,
    super.userCategories,
    super.interests,
  }) : super(currentBio: optimisticBio);
}

class ProfileBioUpdated extends ProfileState {
  final String bio;

  const ProfileBioUpdated(
    this.bio, {
    super.currentName,
    super.currentImageUrl,
    super.userCategories,
    super.interests,
  }) : super(currentBio: bio);
}

class ProfileBioUpdateFailed extends ProfileState {
  const ProfileBioUpdateFailed({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  });
}

class ProfileCategoriesOptimisticUpdate extends ProfileState {
  final List<String> optimisticCategories;

  const ProfileCategoriesOptimisticUpdate(
    this.optimisticCategories, {
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.interests,
  }) : super(userCategories: optimisticCategories);
}

class ProfileCategoriesLoading extends ProfileState {
  const ProfileCategoriesLoading({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
    super.interests,
  });
}

class ProfileCategoriesUpdated extends ProfileState {
  final List<String> categories;

  const ProfileCategoriesUpdated(
    this.categories, {
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.interests,
  }) : super(userCategories: categories);
}

class ProfileCategoriesUpdateFailed extends ProfileState {
  const ProfileCategoriesUpdateFailed({
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.userCategories,
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
    super.userCategories,
    super.interests,
  });
}