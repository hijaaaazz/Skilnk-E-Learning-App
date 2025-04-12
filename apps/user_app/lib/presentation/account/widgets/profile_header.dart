import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:user_app/presentation/account/widgets/profile_image_bottom_sheet.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade800, Colors.deepOrange.shade600],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => showProfileImageBottomSheet(context),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: user.image!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: user.image!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => CircularProgressIndicator(color: Colors.deepOrange.shade300),
                              errorWidget: (context, url, error) => const Icon(Icons.person, size: 60, color: Colors.white),
                            )
                          : const Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.deepOrange.shade800, width: 2),
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.deepOrange.shade800, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(user.email, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9))),
          ],
        ),
      ),
    );
  }
}
