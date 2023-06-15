param name string
param location string = resourceGroup().location

param linuxFxVersion string = 'DOTNETCORE|7.0'

param appServicePlanId string

@secure()
param appInsightsInstrumentationKey string
@secure()
param appInsightsConnectionString string

param useSql bool = false
@secure()
param adminUsername string
@secure()
param adminPassword string

param useAoai bool = false
param aoaiApiEndpoint string
param aoaiApiVersion string = '2022-12-01'
param aoaiApiDeploymentId string

var asplan = {
  id: appServicePlanId
}

var appInsights = {
  instrumentationKey: appInsightsInstrumentationKey
  connectionString: appInsightsConnectionString
}

var aoai = {
  endpoint: aoaiApiEndpoint
  apiVersion: aoaiApiVersion
  deploymentId: aoaiApiDeploymentId
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
]
var appSettings = concat(concat(commonAppSettings, useAoai ? [
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
    name: 'AOAI_API_DEPLOYMENT_ID'
    value: aoai.deploymentId
  }
] : []), useSql ? [
  // Azure SQL Database
  {
    name: 'ConnectionString__Databases__AzureSQL'
    value: 'Driver={ODBC Driver 18 for SQL Server};Server=tcp:sqlsvr-${name}${environment().suffixes.sqlServerHostname},1433;Database=sqldb-${name};Uid=${adminUsername};Pwd=${adminPassword};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;'
  }
]: [])

var apiApp = {
  name: 'appsvc-${name}'
  location: location
  siteConfig: {
    linuxFxVersion: linuxFxVersion
    appSettings: appSettings
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
      // appSettings: [
      //   // Common Settings
      //   {
      //     name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      //     value: appInsights.instrumentationKey
      //   }
      //   {
      //     name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
      //     value: appInsights.connectionString
      //   }
      //   // Azure OpenAI Service
      //   {
      //     name: 'AOAI_API_ENDPOINT'
      //     value: aoai.endpoint
      //   }
      //   {
      //     name: 'AOAI_API_VERSION'
      //     value: aoai.apiVersion
      //   }
      //   {
      //     name: 'AOAI_API_DEPLOYMENT_ID'
      //     value: aoai.deploymentId
      //   }
      // ]
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
