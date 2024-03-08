class Constants {
  static const String base = 'https://web.abhinavramakrishnan.tech';

  static const String auth = '/api/auth';

  static const String login = '$base$auth/loginStudent';
  static const String register = '$base$auth/registerStudent';
  static const String verify = '$base$auth/verifyStudent';
  static const String forgot = '$base$auth/forgotPasswordStudent';
  static const String reset = '$base$auth/resetPasswordStudent';

  static const String user = '/api/user/';
  static const String editProfile = '$base${user}editStudentProfile';
  static const String getProfile = '$base${user}getStudentProfile';
  static const String getallEvents = '$base${user}getAllEvents';
  static const String getEventData = '$base${user}getEventData';
  static const String buyPassport = '$base${user}buyPassport';
  static const String verifyTransaction = '$base${user}verifyTransaction';
  static const String registerEvent = '$base${user}registerForEventStepOne';
  static const String getAlltransactions = '$base${user}getAllTransactions';
  static const String getRegisteredEvents = '$base${user}getRegisteredEvents';
  static const String toggleStarredEvents = '$base${user}toggleStarredEvent';
  static const String getAllTags = '$base/api/admin/getAllTags';
  static const String getRegisteredEventData = '$base${user}registeredEventData';
  static const String getCrew = '$base${user}getCrew';
  static const String getPassportContent = '$base${user}getPassportContent';
  // key = ypfBaJ
}
