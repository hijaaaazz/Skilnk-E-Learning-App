import 'package:flutter/material.dart';
import 'package:tutor_app/common/widgets/app_text.dart';
import 'package:tutor_app/features/courses/presentation/widgets/text_field.dart';

class AppAutocomplete<T extends Object> extends StatefulWidget {
  final String label;
  final String hintText;
  final List<T> options;
  final String? initialValue;
  final String Function(T) displayStringForOption;
  final void Function(T) onSelected;
  final Widget Function(BuildContext, T)? optionBuilder;
  final String? errorText;
  final Color primaryColor;
  final double borderRadius;

  const AppAutocomplete({
    Key? key,
    required this.label,
    required this.hintText,
    this.initialValue,
    required this.options,
    required this.displayStringForOption,
    required this.onSelected,
    this.optionBuilder,
    this.errorText,
    this.primaryColor = Colors.deepOrange,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  State<AppAutocomplete<T>> createState() => _AppAutocompleteState<T>();
}

class _AppAutocompleteState<T extends Object> extends State<AppAutocomplete<T>> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      textEditingController: _controller,
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return Iterable<T>.empty();
        }
        return widget.options.where((option) =>
            widget.displayStringForOption(option)
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: widget.displayStringForOption,
      onSelected: (T selected) {
        _controller.text = widget.displayStringForOption(selected);
        widget.onSelected(selected);
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            color: Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final T option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: index == options.length - 1
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: widget.optionBuilder != null
                          ? widget.optionBuilder!(context, option)
                          : ListTile(
                              dense: true,
                              title: AppText(
                                text: widget.displayStringForOption(option),
                                style: const TextStyle(fontSize: 14),
                              ),
                              hoverColor: widget.primaryColor.withOpacity(0.1),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return AppTextField(
          label: widget.label,
          controller: controller,
          focusNode: focusNode,
          hintText: widget.hintText,
          errorText: widget.errorText,
          primaryColor: widget.primaryColor,
          borderRadius: widget.borderRadius,
        );
      },
    );
  }
}
