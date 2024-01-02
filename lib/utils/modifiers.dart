String capitalize(String s) {
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

String quitUnderScore(String s) {
  return s.replaceAll("_", " ");
}