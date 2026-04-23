class AppUrls {
  /// Base URL for all API calls.
  static const String baseUrl = 'http://192.168.1.45:8000/';

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
  static const String getFailureCategoryTypes = 'master/failureCategoryType/';
  static const String getLocations = 'master/location/';
  static const String getFunctionLocations = 'master/functionLocation/';
  static const String getSubLocations = 'master/subLocation/';
  static const String getObjectParts = 'master/objectPart';
  static const String getFaults = 'master/fault';
  static const String getRootCauses = 'master/rootCause';
  static const String getMaterials = 'master/material';
  static const String getActionTaken = 'master/actionTaken';
  static const String getStoreLocations = 'master/storeLocation';
}

