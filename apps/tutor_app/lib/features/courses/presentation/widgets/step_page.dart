import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_app/common/widgets/app_text.dart';

class CourseStepPage extends StatelessWidget {
  final String title;
  final Widget bodyContent;
  final VoidCallback onNext;
  final IconData icon;
  final String? backtext;
  final String? nexttext;

  const CourseStepPage({
    super.key,
    required this.title,
    required this.bodyContent,
    required this.icon,
    required this.onNext,
    this.backtext,
    this.nexttext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Padding(
        padding:  EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.08,
          horizontal: MediaQuery.of(context).size.width * 0.05,
    
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  const SizedBox(width: 8),
                  AppText(text: title,)
                ],
              ),
              
            ),
            Divider(
              indent: MediaQuery.of(context).size.width * 0.2,
              endIndent: MediaQuery.of(context).size.width * 0.2,
              color: Colors.deepOrange,
              thickness: 2,
            ),
            const SizedBox(height: 10),
            Expanded(child: Padding(
              padding:  EdgeInsets.only(top:8.0),
              child: bodyContent,
            )),
             Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFE8EAEF),
                            ),
                            backgroundColor: Colors.white,
                            shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)                            ),
                          ),
                          child:AppText(text:backtext?? "Cancel",color: Colors.grey,weight: FontWeight.bold,) ,
                         
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onNext();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            backgroundColor: const Color(0xFFFF6636),
                            shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)   
                            ),
                          ),
                          child: AppText(text:nexttext?? "Next",color: const Color.fromARGB(255, 255, 255, 255),weight: FontWeight.bold,) ,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
