// const kioskId = 'Demo-Medlyves'; // Demo
//const kioskId = 'TH-BC-001'; // praram 9
const kioskId = 'k123'; // praram 9
// const kioskId = 'TH-SI-001'; //siriraj

// Cloud backend
const httpPrefix = 'https://';
const wsPrefix = 'wss://';
const env = String.fromEnvironment('ENV', defaultValue: 'dev');
// const host = env == 'prod' ? 'api.medlyves.com' : 'api.medlyves.com';
const host = "medlyves-api-5hohk5qryq-as.a.run.app";
// ? 'medlyves-api-prod-5hohk5qryq-as.a.run.app'
// : 'medlyves-api-5hohk5qryq-as.a.run.app';

// String.fromEnvironment('HOST',
//     defaultValue: 'medlyves-api-5hohk5qryq-as.a.run.app');

// localhost
// const httpPrefix = 'http://';
// const wsPrefix = 'ws://';
// const host = '10.0.2.2:8000';
const baseUrl = 'https://$host';
