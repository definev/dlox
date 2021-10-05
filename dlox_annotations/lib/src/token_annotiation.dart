class TokenAnnotation {
  final Map<String, String> tokenMap;
  final List<String> identifiers;
  final List<String> keywords;

  const TokenAnnotation({required this.tokenMap, required this.identifiers, required this.keywords});
}
