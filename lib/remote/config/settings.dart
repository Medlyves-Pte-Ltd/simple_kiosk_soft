// Cloud backend
const httpPrefix = 'https://';
const wsPrefix = 'wss://';
const env = String.fromEnvironment('ENV', defaultValue: 'dev');
// const host = env == 'prod' ? 'api.medlyves.com' : 'api.medlyves.com';

// Production Environment:
// API Base Link: https://api.medlyves.com
// Doctor Portal Link: https://carenet.medlyves.com
//
// Development Environment:
// API Base Link: https://medlyves-api-5hohk5qryq-as.a.run.app
// Doctor Portal Link: https://dev-portal-v3-portal-v3-feat-dev-5hohk5qryq-as.a.run.app

const host = "api.medlyves.com";
//const host = "medlyves-api-5hohk5qryq-as.a.run.app";
// 开发环境kioskid CN-ICD-DEV-1
// 生产环境kioskid TH-BC-010
const baseUrl = 'https://$host';
