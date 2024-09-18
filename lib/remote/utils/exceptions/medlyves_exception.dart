class MedlyvesException implements Exception {
  String errorCode;
  String errorMessage;

  MedlyvesException(this.errorCode,
      {this.errorMessage =
          'Unexpected error has occured. Please contact support'});
}
