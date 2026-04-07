class AppUrls {
  /// Base URL for all API calls.
  static const String baseUrl = 'http://192.168.1.65:8000/';

  /// Auth endpoints
  static const String login = 'auth/login';
  static const String updateUsers = 'users';
  static const String getUsers = 'users/getUser';


  /// Lost & Found endpoints
  static const String lostFoundTable = 'lostfound/table';
  static const String singleLostFoundData = 'lostfound/singleData';
  static const String createLostFound = 'lostfound';
  static const String autoMatch = 'lostfound/auto-match';
  static const String finalizeMatch = 'lostfound/finalize-match';
  static const String bulkSoftDeleteLostFound = 'lostfound/bulk-soft-delete';

  /// Master endpoints
  static const String getStations = 'master/station/';
  static const String getCities = 'master/city/';
  static const String getDepartmentTypes = 'master/departmentType/';
  static const String getRoles = 'master/role/';
  static const String getDesignations = 'master/designation/';
}

