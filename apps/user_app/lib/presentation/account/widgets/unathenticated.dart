import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import  'package:user_app/core/routes/app_route_constants.dart';
import  'package:user_app/features/account/presentation/widgets/login_suggession.dart';
import  'package:user_app/features/account/presentation/widgets/option_tile.dart';


Widget buildUnauthenticatedUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Login suggestion at top
          Container(
            margin: const EdgeInsets.all(20),
            child: const LoginSuggession(),
          ),
          
          const SizedBox(height: 20),
          
          // General options section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "General",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 194, 45, 0),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          //General options available without login
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                
                
                buildDivider(),
                buildOptionTile(
                  context,
                  "Help & Support",
                  Icons.help_outline,
                  onTap: () {
      context.pushNamed(AppRouteConstants.helpandsupportpage);
      
  
                  },
                ),
                buildDivider(),
                buildOptionTile(
                  context,
                  "Legal Policies",
                  Icons.info_outline,
                  onTap: () {
                    context.pushNamed(AppRouteConstants.termsconditions);
                  },
                ),
                
                buildDivider(),
                buildOptionTile(
                  context,
                  "Share this App",
                  Icons.description_outlined,
                  onTap: () {
                     // ignore: deprecated_member_use
                     Share.share(
      'Check out the Skilnk App – a simple way to learn and grow! 🚀\nDownload now: https://example.com/download',
      subject: 'Skilnk – Learn with ease',
    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
      
    );

    
}
    
   
  