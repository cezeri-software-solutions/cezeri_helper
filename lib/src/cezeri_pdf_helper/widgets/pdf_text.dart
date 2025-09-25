import 'package:pdf/widgets.dart' as pw;

class PdfText extends pw.Text {
  PdfText(super.text, {pw.TextStyle? style, super.textAlign, super.maxLines, super.overflow, super.textDirection, bool super.softWrap = true})
    : super(style: style ?? const pw.TextStyle(fontSize: 8));
}
