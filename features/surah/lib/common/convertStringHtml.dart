String removeHtmlTags(String htmlText) {
  final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  return htmlText.replaceAll(regex, '');
}
