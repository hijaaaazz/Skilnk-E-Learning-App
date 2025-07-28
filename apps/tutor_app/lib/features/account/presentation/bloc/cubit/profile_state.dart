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

  const ProfileImageUpdated(
    this.imageUrl, {
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


class ProfileCategoriesLoading extends ProfileState {

  const ProfileCategoriesLoading(
     {
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.interests,
  }) : super();

}

class ProfileCategoriesUpdated extends ProfileState {
    final List<String> categoriesLoaded;
  const ProfileCategoriesUpdated(
    this.categoriesLoaded, {
    super.currentName,
    super.currentImageUrl,
    super.currentBio,
    super.interests,
  }) : super();

}


class ProfileActivitiesLoading extends ProfileState {
  const ProfileActivitiesLoading({
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
