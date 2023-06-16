param name string
param location string = resourceGroup().location

@secure()
param appServiceKey string
param linuxFxVersion string = 'DOTNETCORE|7.0'
param isDotNet bool = false
param isJava bool = false
param isPython bool = false
param openapi object = {
  title: ''
  version: ''
  server: ''
  includeOnDeployment: false
}
param github object = {
  agent: ''
  clientId: ''
  clientSecret: ''
}
param sqlService object = {
  location: ''
  admin: {
    username: ''
    password: ''
  }
}
param aoaiService object = {
  apiEndpoint: ''
  apiVersion: ''
  deploymentId: ''
}

module sqlsvc './azureSql.bicep' = if (isPython == true) {
  name: 'SqlServer_AppService_${name}'
  params: {
    name: '${name}'
    location: sqlService.location
    adminUsername: sqlService.admin
    adminPassword: sqlService.password
  }
}

module wrkspc './logAnalyticsWorkspace.bicep' = {
  name: 'LogAnalyticsWorkspace_AppService_${name}'
  params: {
    name: '${name}-api'
    location: location
  }
}

module appins './applicationInsights.bicep' = {
  name: 'ApplicationInsights_AppService_${name}'
  params: {
    name: '${name}-api'
    location: location
    workspaceId: wrkspc.outputs.id
  }
}

module asplan './appServicePlan.bicep' = {
  name: 'AppServicePlan_AppService_${name}'
  params: {
    name: '${name}-api'
    location: location
  }
}

module appsvc './appService.bicep' = {
  name: 'AppService_AppService_${name}'
  params: {
    name: '${name}-api'
    location: location
    linuxFxVersion: linuxFxVersion
    appInsightsInstrumentationKey: appins.outputs.instrumentationKey
    appInsightsConnectionString: appins.outputs.connectionString
    appServicePlanId: asplan.outputs.id
    isDotNet: isDotNet
    isJava: isJava
    isPython: isPython
    appServiceKey: appServiceKey
    openApiDocTitle: openapi.title
    openApiDocVersion: openapi.version
    openApiDocServer: openapi.server
    openApiIncludeOnDeployment: openapi.includeOnDeployment
    githubAgent: github.agent
    githubClientId: github.clientId
    githubClientSecret: github.clientSecret
    sqlAdminUsername: isPython ? sqlService.admin.username : ''
    sqlAdminPassword: isPython ? sqlService.admin.password : ''
    aoaiApiEndpoint: isJava ? aoaiService.apiEndpoint : ''
    aoaiApiVersion: isJava ? aoaiService.apiVersion : ''
    aoaiApiDeploymentId: isJava ? aoaiService.deploymentId : ''
  }
}

output id string = appsvc.outputs.id
output name string = appsvc.outputs.name
