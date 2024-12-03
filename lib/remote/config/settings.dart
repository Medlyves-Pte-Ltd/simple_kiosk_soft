const httpPrefix = 'https://';
const wsPrefix = 'wss://';

// dev 开发环境
// API Base Link: https://medlyves-api-5hohk5qryq-as.a.run.app
// Doctor Portal Link: https://dev-portal-v3-portal-v3-feat-dev-5hohk5qryq-as.a.run.app
// kioskid CN-ICD-DEV-1

// prod 生产环境
// API Base Link: https://api.medlyves.com
// Doctor Portal Link: https://carenet.medlyves.com
// kioskid TH-BC-010
String host = "api.medlyves.com";
String firebaseRdbUrl =
    'https://medlyves-doctor-default-rtdb.asia-southeast1.firebasedatabase.app';
String firebaseApiKey = 'AIzaSyBAUht4QU85pHQ9pZMdhgwzfVyyHGLCxM0';
String firebaseAppId = '1:1091315824870:android:36a4510a48d38ec6f2a327';
String firebaseMessagingSenderId = '1091315824870';
String firebaseProjectId = 'medlyves-doctor';
String firebaseStorageBucket = "medlyves-doctor.firebasestorage.app";

String baseUrl = 'https://$host';
