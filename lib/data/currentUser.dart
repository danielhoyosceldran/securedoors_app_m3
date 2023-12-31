late String _currentUserName;
late String _currentUserCredentials;
late String _currentUserPhoto;

void updateCurrentUser({
  currentUserName = String,
  currentUserCredentials = String,
  currentUserPhoto = String
}) {
  _currentUserCredentials = currentUserCredentials;
  _currentUserName = currentUserName;
  _currentUserPhoto = currentUserPhoto;
}

String getCurrentUserName() {
  return  _currentUserName;
}
String getCurrentUserPhoto() {
  return  _currentUserPhoto;
}
String getCurrentUserCredentials() {
  return  _currentUserCredentials;
}