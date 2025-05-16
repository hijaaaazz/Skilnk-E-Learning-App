import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';
import 'package:tutor_app/features/courses/presentation/widgets/text_field.dart';

class CoursePriceForm extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController discountController;

  const CoursePriceForm({
    super.key,
    required this.priceController,
    required this.discountController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<AddCourseCubit, AddCourseState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Course Pricing',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                FlutterToggleTab(
                  width: screenWidth * 0.2,
                  height: 40,
                  selectedTextStyle: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  unSelectedTextStyle: GoogleFonts.outfit(
                    color: const Color.fromARGB(104, 80, 80, 80),
                    fontWeight: FontWeight.w300,
                  ),
                  selectedBackgroundColors: [Colors.deepOrange],
                  dataTabs:  [
                    DataTab(title: "Free"),
                    DataTab(title: "Paid"),
                  ],
                  selectedIndex: state.isPaid ? 1 : 0,
                  selectedLabelIndex: (index) {
                    context.read<AddCourseCubit>().updateIsPaid(index == 1);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: state.isPaid ? 1.0 : 0.3,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: !state.isPaid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.35,
                      child: AppTextField(
                        label: "Discount",
                        hintText: state.offer.toString(),
                        controller: discountController,
                        errorText: state.offerError ?? "",
                        
                        keyboardType: TextInputType.number,
                        suffixIcon: Icons.percent_rounded,
                        onChanged: (value){
                          context.read<AddCourseCubit>().updateDiscount(value);
                        },
                      
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: screenWidth * 0.35,
                      child: AppTextField(
                        label: 'Price',
                        hintText: 'Price',
                        suffixIcon: Icons.currency_rupee_sharp,
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        errorText: state.priceError ?? "",
                        onChanged: (value) {
                          context.read<AddCourseCubit>().updatePrice(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
