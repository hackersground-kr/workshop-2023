param name string
param location string = resourceGroup().location

param linuxFxVersion string = 'DOTNETCORE|7.0'

param useSql bool = false
param sqlService object = {
  location: ''
  admin: {
    username: ''
    password: ''
  }
}
param useAoai bool = false
param aoaiApiEndpoint string
param aoaiApiVersion string = '2022-12-01'
param aoaiApiDeploymentId string

module sqlsvc './azureSql.bicep' = if (useSql == true) {
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
    useSql: useSql
    adminUsername: sqlService.admin.username
    adminPassword: sqlService.admin.password
    useAoai: useAoai
    aoaiApiEndpoint: aoaiApiEndpoint
    aoaiApiVersion: aoaiApiVersion
    aoaiApiDeploymentId: aoaiApiDeploymentId
  }
}

output id string = appsvc.outputs.id
output name string = appsvc.outputs.name
