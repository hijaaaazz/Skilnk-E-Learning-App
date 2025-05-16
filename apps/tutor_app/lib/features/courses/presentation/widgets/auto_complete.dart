import 'dart:developer';

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
    super.key,
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
  });

  @override
  State<AppAutocomplete<T>> createState() => _AppAutocompleteState<T>();
}

class _AppAutocompleteState<T extends Object> extends State<AppAutocomplete<T>> {
  late final TextEditingController _controller;
  T? _selectedOption;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _updateSelectedOption();
  }

  @override
  void didUpdateWidget(covariant AppAutocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue || widget.options != oldWidget.options) {
      _controller.text = widget.initialValue ?? '';
      _updateSelectedOption();
    }
  }

  void _updateSelectedOption() {
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty && widget.options.isNotEmpty) {
      try {
        _selectedOption = widget.options.firstWhere(
          (option) => widget.displayStringForOption(option).trim().toLowerCase() == widget.initialValue!.trim().toLowerCase(),
          // ignore: cast_from_null_always_fails
          orElse: () => null as T,
        );
        if (_selectedOption != null) {
          log('AppAutocomplete: Found matching option for initialValue "${widget.initialValue}": ${widget.displayStringForOption(_selectedOption!)}');
          widget.onSelected(_selectedOption!);
        } else {
          log('AppAutocomplete: No matching option for initialValue "${widget.initialValue}" in options: ${widget.options.map(widget.displayStringForOption).toList()}');
        }
      } catch (e) {
        log('AppAutocomplete: Error finding matching option: $e');
      }
    } else {
      _selectedOption = null;
      log('AppAutocomplete: initialValue="${widget.initialValue}", options length=${widget.options.length}');
    }
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
          return widget.options;
        }
        return widget.options.where((option) =>
            widget.displayStringForOption(option)
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: widget.displayStringForOption,
      onSelected: (T selected) {
        _controller.text = widget.displayStringForOption(selected);
        _selectedOption = selected;
        widget.onSelected(selected);
        log('AppAutocomplete: Selected option: ${widget.displayStringForOption(selected)}');
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
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: index == options.length - 1
                                ? Colors.transparent
                                // ignore: deprecated_member_use
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
                              // ignore: deprecated_member_use
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