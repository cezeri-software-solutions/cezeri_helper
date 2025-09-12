import 'package:flutter/material.dart';

class CezeriFieldTitle extends StatelessWidget {
  final String fieldTitle;
  final bool isMandatory;

  const CezeriFieldTitle({super.key, required this.fieldTitle, required this.isMandatory});

  @override
  Widget build(BuildContext context) {
    if (!isMandatory) {
      return Text(
        ' $fieldTitle',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.outline),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Row(
      children: [
        Text(
          ' $fieldTitle',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.outline),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text('*', maxLines: 1, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.error)),
      ],
    );
  }
}
