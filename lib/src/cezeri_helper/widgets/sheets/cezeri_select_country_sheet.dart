import 'package:auto_route/auto_route.dart';
import 'package:cezeri_helper/cezeri_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CezeriSelectCountrySheet extends StatefulWidget {
  final String? fieldTitle;
  final String? labelText;
  final String? hintText;
  final String selectedCountry;
  final void Function(CezeriCountry country) onSelectCountry;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final ColorScheme? colorScheme;
  final TextTheme? textTheme;

  const CezeriSelectCountrySheet({
    super.key,
    this.fieldTitle,
    this.labelText,
    this.hintText,
    required this.selectedCountry,
    required this.onSelectCountry,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.colorScheme,
    this.textTheme,
  });

  @override
  State<CezeriSelectCountrySheet> createState() => _CezeriSelectCountrySheetState();
}

class _CezeriSelectCountrySheetState extends State<CezeriSelectCountrySheet> {
  late CezeriCountry selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = CezeriCountry.countryList.where((e) => e.name == widget.selectedCountry).first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.fieldTitle != null) CezeriFieldTitle(fieldTitle: widget.fieldTitle!, isMandatory: true),
        InkWell(
          onTap:
              () => showDialog(
                context: context,
                builder: (context) {
                  final screenHeight = context.screenSize.height;
                  final screenWidth = context.screenSize.width;
                  return SelectVehicleDialog(onSelectCountry: _selectVehicleBrand, screenHeight: screenHeight, screenWidth: screenWidth);
                },
              ),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: const TextStyle().copyWith(letterSpacing: 0),
              hintText: widget.hintText,
              hintStyle: const TextStyle().copyWith(letterSpacing: 0),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              constraints: const BoxConstraints(maxHeight: 35),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: widget.colorScheme != null ? widget.colorScheme!.surfaceContainerLow : Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: widget.colorScheme != null ? widget.colorScheme!.primary : Colors.blue),
              ),
            ),
            child: Row(
              children: [
                CezeriCountryFlag(country: selectedCountry, size: 16),
                Gaps.w16,
                Text(selectedCountry.name, style: widget.textTheme != null ? widget.textTheme!.bodyLarge : TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _selectVehicleBrand(CezeriCountry country) => setState(() {
    selectedCountry = country;
    widget.onSelectCountry(country);
  });
}

class SelectVehicleDialog extends StatefulWidget {
  final void Function(CezeriCountry country) onSelectCountry;
  final double screenHeight;
  final double screenWidth;

  const SelectVehicleDialog({super.key, required this.onSelectCountry, required this.screenHeight, required this.screenWidth});

  @override
  State<SelectVehicleDialog> createState() => _SelectVehicleDialogState();
}

final _controller = TextEditingController();

class _SelectVehicleDialogState extends State<SelectVehicleDialog> {
  @override
  Widget build(BuildContext context) {
    List<CezeriCountry> countryList = CezeriCountry.countryList;

    if (_controller.text.isNotEmpty) countryList = countryList.where((e) => e.name.toLowerCase().contains(_controller.text.toLowerCase())).toList();

    return Dialog(
      child: SizedBox(
        height: widget.screenHeight > 1000 ? 1000 : widget.screenHeight - 400,
        width: widget.screenWidth > 500 ? 500 : widget.screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoSearchTextField(controller: _controller, onChanged: (value) => setState(() {}), onSuffixTap: () => _controller.clear()),
              Expanded(
                child: ListView.builder(
                  itemCount: countryList.length,
                  itemBuilder: (context, index) {
                    final country = countryList[index];
                    return Column(
                      children: [
                        if (index == 0) Gaps.h10,
                        ListTile(
                          leading: SizedBox(
                            width: 40,
                            child: CezeriAvatar(
                              name: country.isoCode,
                              imageUrl: country.flagUrl,
                              radius: 18,
                              fontSize: 14,
                              fit: BoxFit.scaleDown,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          title: Text(country.name),
                          onTap: () {
                            print('onTap: ${country.name}');
                            _controller.clear();
                            widget.onSelectCountry(country);
                            context.router.maybePop();
                          },
                        ),
                        const Divider(height: 0),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
