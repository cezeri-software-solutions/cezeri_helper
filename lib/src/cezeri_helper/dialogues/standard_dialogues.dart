import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/cezeri_helper.dart';

Future<void> showCZRDialogLoading({required BuildContext context, String text = '', bool canPop = false}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60, width: 60, child: CircularProgressIndicator(strokeWidth: 12)),
                if (text.isNotEmpty) ...[const SizedBox(height: 38), Text(text, style: context.textTheme.titleLarge, textAlign: TextAlign.center)],
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showCZRDialogAlert({required BuildContext context, required String title, required String content, bool canPop = true}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: context.textTheme.headlineLarge),
                  Gaps.h16,
                  Text(content, style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showCZRDialogDelete({
  required BuildContext context,
  String? title,
  String? content,
  required VoidCallback onConfirm,
  bool canPop = true,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title ?? 'Löschen', style: context.textTheme.headlineLarge),
                  Gaps.h16,
                  Text(
                    content ?? 'Bist du sicher, dass du es unwiederruflich löschen willst?',
                    style: context.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(child: const Text('Abbrechen'), onPressed: () => context.router.maybePop()),
                      OutlinedButton(onPressed: onConfirm, child: const Text('Löschen')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showCZRDialogNotImplemented({required BuildContext context, String? title, String? content, bool canPop = true}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title ?? 'Achtung', style: context.textTheme.headlineLarge),
                  Gaps.h16,
                  Text(content ?? 'Diese Funktion ist noch nicht implementiert', style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                  Gaps.h32,
                  OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showCZRDialogCustom({
  required BuildContext context,
  String? title,
  required String content,
  String? buttonTextCancel,
  String? buttonTextConfirm,
  required VoidCallback onConfirm,
  bool canPop = true,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title ?? 'Achtung', style: context.textTheme.headlineLarge),
                  Gaps.h16,
                  Text(content, style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(child: Text(buttonTextCancel ?? 'Abbrechen'), onPressed: () => context.router.maybePop()),
                      OutlinedButton(onPressed: onConfirm, child: Text(buttonTextConfirm ?? 'JA')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// Future<void> showCZRDialogProducts({
//   required BuildContext context,
//   String? title = 'Artikel',
//   required List<Product> productsList,
//   bool canPop = true,
// }) async {
//   final screenWidth = context.screenWidth;

//   await showDialog<void>(
//     context: context,
//     barrierDismissible: canPop,
//     builder: (_) {
//       return PopScope(
//         canPop: canPop,
//         child: Dialog(
//           child: SizedBox(
//             width: screenWidth > 700 ? 1000 : screenWidth,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Text('${title!} (${productsList.length})', style: context.textTheme.headlineLarge),
//                   ),
//                   Gaps.h32,
//                   Flexible(
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       itemCount: productsList.length,
//                       itemBuilder: (context, index) {
//                         final product = productsList[index];

//                         return ListTile(
//                           leading: SizedBox(
//                             width: 60,
//                             child: MyAvatar(
//                               name: product.name,
//                               imageUrl:
//                                   product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
//                               radius: 30,
//                               fontSize: 20,
//                               shape: BoxShape.circle,
//                               onTap:
//                                   product.listOfProductImages.isNotEmpty
//                                       ? () => context.router.push(
//                                         MyFullscreenImageRoute(
//                                           imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(),
//                                           initialIndex: 0,
//                                           isNetworkImage: true,
//                                         ),
//                                       )
//                                       : null,
//                             ),
//                           ),
//                           title: Text(product.name),
//                           subtitle: Text(product.articleNumber),
//                         );
//                       },
//                       separatorBuilder: (context, index) => const Divider(height: 0),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

Future<void> showCZRDialogLoadingWolt({required BuildContext context, String? text, bool canPop = false}) async {
  await WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          child: PopScope(
            canPop: canPop,
            child: SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 60, width: 60, child: CircularProgressIndicator(strokeWidth: 12)),
                    if (text != null && text.isNotEmpty) ...[
                      const SizedBox(height: 38),
                      Text(text, style: context.textTheme.titleLarge, textAlign: TextAlign.center),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ];
    },
    modalTypeBuilder: (_) => WoltModalType.dialog(),
    onModalDismissedWithBarrierTap: canPop ? () => Navigator.of(context).pop() : null,
    barrierDismissible: canPop,
  );
}

Future<void> showCZRDialogDeleteWolt({
  required BuildContext context,
  String? title,
  String? content,
  required VoidCallback onConfirm,
  bool canPop = true,
}) async {
  await WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          child: PopScope(
            canPop: canPop,
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title ?? 'Löschen', style: context.textTheme.headlineLarge),
                    Gaps.h16,
                    Text(
                      content ?? 'Bist du sicher, dass du es unwiederruflich löschen willst?',
                      style: context.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    Gaps.h32,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(child: const Text('Abbrechen'), onPressed: () => context.router.maybePop()),
                        FilledButton(
                          onPressed: onConfirm,
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.error,
                            foregroundColor: Theme.of(context).colorScheme.onError,
                          ),
                          child: const Text('Löschen'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ];
    },
    modalTypeBuilder: (_) => WoltModalType.dialog(),
    onModalDismissedWithBarrierTap: canPop ? () => Navigator.of(context).pop() : null,
    barrierDismissible: canPop,
  );
}

Future<void> showCZRDialogAlertWolt({
  required BuildContext context,
  required String title,
  required String content,
  String? buttonTextConfirm,
  Color? buttonBackgroundColor,
  Color? buttonForegroundColor,
  VoidCallback? onConfirm,
  bool canPop = true,
}) async {
  await WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          child: PopScope(
            canPop: canPop,
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: context.textTheme.headlineLarge),
                    Gaps.h16,
                    Text(content, style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                    Gaps.h32,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilledButton(
                          onPressed: () {
                            if (onConfirm != null) onConfirm();

                            Navigator.pop(context);
                          },
                          style: FilledButton.styleFrom(backgroundColor: buttonBackgroundColor, foregroundColor: buttonForegroundColor),
                          child: Text(buttonTextConfirm ?? 'OK'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ];
    },
    modalTypeBuilder: (_) => WoltModalType.dialog(),
    onModalDismissedWithBarrierTap: canPop ? () => Navigator.of(context).pop() : null,
    barrierDismissible: canPop,
  );
}

Future<void> showCZRDialogNotImplementedWolt({required BuildContext context, String? title, String? content, bool canPop = true}) async {
  await WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          child: PopScope(
            canPop: canPop,
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title ?? 'Achtung', style: context.textTheme.headlineLarge),
                    Gaps.h16,
                    Text(content ?? 'Diese Funktion ist noch nicht implementiert', style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                    Gaps.h32,
                    OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ];
    },
    modalTypeBuilder: (_) => WoltModalType.dialog(),
    onModalDismissedWithBarrierTap: canPop ? () => Navigator.of(context).pop() : null,
    barrierDismissible: canPop,
  );
}

Future<void> showCZRDialogCustomWolt({
  required BuildContext context,
  String? title,
  required String content,
  String? buttonTextCancel,
  String? buttonTextConfirm,
  required VoidCallback onConfirm,
  bool canPop = true,
}) async {
  await WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          child: PopScope(
            canPop: canPop,
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title ?? 'Achtung', style: context.textTheme.headlineLarge),
                    Gaps.h16,
                    Text(content, style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                    Gaps.h32,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(onPressed: () => context.router.maybePop(), child: Text(buttonTextCancel ?? 'Abbrechen')),
                        OutlinedButton(onPressed: onConfirm, child: Text(buttonTextConfirm ?? 'JA')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ];
    },
    modalTypeBuilder: (_) => WoltModalType.dialog(),
    onModalDismissedWithBarrierTap: canPop ? () => Navigator.of(context).pop() : null,
    barrierDismissible: canPop,
  );
}

// Future<void> showCZRDialogProductsWolt({
//   required BuildContext context,
//   String? title = 'Artikel',
//   required List<Product> productsList,
//   bool canPop = true,
// }) async {
//   final screenWidth = context.screenWidth;

//   await WoltModalSheet.show<void>(
//     context: context,
//     pageListBuilder: (context) {
//       return [
//         WoltModalSheetPage(
//           hasTopBarLayer: false,
//           child: PopScope(
//             canPop: canPop,
//             child: SizedBox(
//               width: screenWidth > 700 ? 1000 : screenWidth,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Text('${title!} (${productsList.length})', style: context.textTheme.headlineLarge),
//                     ),
//                     Gaps.h32,
//                     Flexible(
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         itemCount: productsList.length,
//                         itemBuilder: (context, index) {
//                           final product = productsList[index];

//                           return ListTile(
//                             leading: SizedBox(
//                               width: 60,
//                               child: MyAvatar(
//                                 name: product.name,
//                                 imageUrl:
//                                     product.listOfProductImages.isNotEmpty
//                                         ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl
//                                         : null,
//                                 radius: 30,
//                                 fontSize: 20,
//                                 shape: BoxShape.circle,
//                                 onTap:
//                                     product.listOfProductImages.isNotEmpty
//                                         ? () => context.router.push(
//                                           MyFullscreenImageRoute(
//                                             imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(),
//                                             initialIndex: 0,
//                                             isNetworkImage: true,
//                                           ),
//                                         )
//                                         : null,
//                               ),
//                             ),
//                             title: Text(product.name),
//                             subtitle: Text(product.articleNumber),
//                           );
//                         },
//                         separatorBuilder: (context, index) => const Divider(height: 0),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ];
//     },
//     modalTypeBuilder: (_) => WoltModalType.dialog(),
//     onModalDismissedWithBarrierTap: canPop ? () => Navigator.of(context).pop() : null,
//     barrierDismissible: canPop,
//   );
// }
