import 'dart:async';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'fields.dart';

class CezeriAutocompleteTextField<T extends Object> extends StatelessWidget {
  final String? fieldTitle;
  final bool? isMandatory;
  final bool mustSelect; //* Ob ein Item ausgewählt werden muss
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final double maxWidth;
  final double maxHeight;
  final List<T>? items;
  final Future<List<T>> Function(TextEditingValue)? loadItems;
  final void Function(T)? onSelected;
  final String Function(T) displayStringForOption;
  final Widget Function(BuildContext, T)? customListTileBuilder;
  final void Function(String)? onSubmitted;
  final ColorScheme colorScheme;
  final Color? dropdownBackgroundColor;

  const CezeriAutocompleteTextField({
    super.key,
    this.fieldTitle,
    this.isMandatory,
    this.mustSelect = true,
    this.controller,
    this.focusNode,
    this.initialValue,
    required this.maxWidth,
    this.maxHeight = 200,
    this.items,
    this.loadItems,
    this.onSelected,
    required this.displayStringForOption,
    this.customListTileBuilder,
    this.onSubmitted,
    required this.colorScheme,
    this.dropdownBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldTitle != null) CezeriFieldTitle(fieldTitle: fieldTitle!, isMandatory: isMandatory!),
        RawAutocomplete<T>(
          textEditingController: controller,
          focusNode: focusNode ?? FocusNode(),
          optionsBuilder: (textEditingValue) async {
            if (items != null) return items!;

            await Future.delayed(const Duration(milliseconds: 500));

            if (loadItems == null) return [];
            return await loadItems!(textEditingValue);
          },
          onSelected: onSelected,
          displayStringForOption: displayStringForOption,
          initialValue: initialValue != null ? TextEditingValue(text: initialValue!) : null,
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              onTapOutside: (_) async {
                if (mustSelect) {
                  final items = await loadItems!(TextEditingValue(text: controller!.text));
                  if (!items.any((e) => displayStringForOption(e).contains(controller!.text))) {
                    controller!.clear();
                  }
                }
                focusNode.unfocus();
              },
              onFieldSubmitted: (value) async {
                if (mustSelect) {
                  final items = await loadItems!(TextEditingValue(text: controller!.text));
                  if (!items.any((e) => displayStringForOption(e).contains(controller!.text))) {
                    controller!.clear();
                  }
                }
                onSubmitted?.call(value);
                focusNode.unfocus();
              },
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 14),
                hintStyle: const TextStyle().copyWith(letterSpacing: 0),
                fillColor: colorScheme.surfaceContainerHighest,
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: isDesktop ? 9 : 5.5),
                isDense: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixStyle: const TextStyle(fontSize: 14),
                // suffix: const Text('€'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.red)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: colorScheme.surfaceContainerLow),
                ),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: colorScheme.primary)),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final items = options.toList();

            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                color: dropdownBackgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
                  child: Scrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        if (customListTileBuilder != null) {
                          return customListTileBuilder!(context, item);
                        }

                        return ListTile(
                          dense: true,
                          leading: Image.network((item as dynamic).imageSource, width: 40, height: 40, fit: BoxFit.cover),
                          title: Text(displayStringForOption(item)),
                          onTap: () => onSelected(item),
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
