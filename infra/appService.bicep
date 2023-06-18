param name string
param location string = resourceGroup().location

param linuxFxVersion string = 'DOTNETCORE|7.0'

param appServicePlanId string

@secure()
param appInsightsInstrumentationKey string
@secure()
param appInsightsConnectionString string

@secure()
param appServiceKey string

param isDotNet bool = false
param isJava bool = false
param isPython bool = false
param openApiDocTitle string
param openApiDocVersion string
param openApiDocServer string
param openApiIncludeOnDeployment bool = false
param githubAgent string
@secure()
param githubClientId string
@secure()
param githubClientSecret string

@secure()
param sqlAdminUsername string
@secure()
param sqlAdminPassword string

param aoaiApiEndpoint string
param aoaiApiVersion string = '2022-12-01'
@secure()
param aoaiApiKey string
param aoaiApiDeploymentId string

var asplan = {
  id: appServicePlanId
}

var appInsights = {
  instrumentationKey: appInsightsInstrumentationKey
  connectionString: appInsightsConnectionString
}

var openApi = {
  title: openApiDocTitle
  version: openApiDocVersion
  server: openApiDocServer
  includeOnDeployment: openApiIncludeOnDeployment
}
var github = {
  agent: githubAgent
  clientId: githubClientId
  clientSecret: githubClientSecret
}

var aoai = {
  endpoint: aoaiApiEndpoint
  apiVersion: aoaiApiVersion
  apiKey: aoaiApiKey
  deploymentId: aoaiApiDeploymentId
}

var sql = {
  connectionString: 'Driver={ODBC Driver 18 for SQL Server};Server=tcp:sqlsvr-${name}${environment().suffixes.sqlServerHostname},1433;Database=sqldb-${name};Uid=${sqlAdminUsername};Pwd=${sqlAdminPassword};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;'
}

var commonAppSettings = [
  // Common Settings
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: appInsights.instrumentationKey
  }
  {
    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
    value: appInsights.connectionString
  }
  // Auth - API Key
  {
    name: 'Auth__ApiKey'
    value: appServiceKey
  }
]
var appSettings = concat(concat(commonAppSettings, isDotNet ? [
  // OpenAPI
  {
    name: 'OpenApi__Title'
    value: openApi.title
  }
  {
    name: 'OpenApi__Version'
    value: openApi.version
  }
  {
    name: 'OpenApi__Server'
    value: openApi.server
  }
  {
    name: 'OpenApi__IncludeOnDeployment'
    value: openApi.includeOnDeployment
  }
  // GitHub
  {
    name: 'GitHub__Agent'
    value: github.agent
  }
] : []), isJava ? [
  // Azure OpenAI Service
  {
    name: 'AOAI_API_ENDPOINT'
    value: aoai.endpoint
  }
  {
    name: 'AOAI_API_VERSION'
    value: aoai.apiVersion
  }
  {
    name: 'AOAI_API_KEY'
    value: aoai.apiKey
  }
  {
    name: 'AOAI_API_DEPLOYMENT_ID'
    value: aoai.deploymentId
  }
] : [])

var connectionStrings = isPython? [
  {
    name: 'STORAGE'
    type: 'SQLAzure'
    connectionString: sql.connectionString
  }
] : []

var apiApp = {
  name: 'appsvc-${name}'
  location: location
  siteConfig: {
    linuxFxVersion: linuxFxVersion
    appSettings: appSettings
    connectionStrings: connectionStrings
  }
}

resource appsvc 'Microsoft.Web/sites@2022-03-01' = {
  name: apiApp.name
  location: apiApp.location
  kind: 'app,linux'
  properties: {
    serverFarmId: asplan.id
    httpsOnly: true
    reserved: true
    siteConfig: {
      linuxFxVersion: apiApp.siteConfig.linuxFxVersion
      alwaysOn: true
      appSettings: apiApp.siteConfig.appSettings
      connectionStrings: apiApp.siteConfig.connectionStrings
      appCommandLine: isPython ? 'pip install -r requirements.txt && python -m uvicorn main:app --host=0.0.0.0': null
    }
  }
}

var policies = [
  {
    name: 'scm'
    allow: false
  }
  {
    name: 'ftp'
    allow: false
  }
]

resource appsvcPolicies 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = [for policy in policies: {
  name: '${appsvc.name}/${policy.name}'
  location: apiApp.location
  properties: {
    allow: policy.allow
  }
}]

output id string = appsvc.id
output name string = appsvc.name
