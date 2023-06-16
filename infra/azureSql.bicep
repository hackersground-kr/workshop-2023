param name string
param location string = resourceGroup().location

@secure()
param adminUsername string
@secure()
param adminPassword string

var sqlService = {
  name: 'sqlsvr-${name}'
  location: location
  server: {
    admin: {
      username: adminUsername
      password: adminPassword
    }
  }
  database: {
    name: 'sqldb-${name}'
  }
}

resource sqlsvr 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlService.name
  location: location
  properties: {
    administratorLogin: sqlService.server.admin.username
    administratorLoginPassword: sqlService.server.admin.password
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource sqldb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlService.database.name}'
  parent: sqlsvr
  location: location
  sku: {
    name: 'GP_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 2
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    licenseType: 'LicenseIncluded'
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Local'
    isLedgerOn: false
  }
}

resource sqlsvrFirewall 'Microsoft.Sql/servers/firewallRules@2022-05-01-preview' = {
  name: 'AllowAllWindowsAzureIps'
  parent: sqlsvr
  dependsOn: [
    sqldb
  ]
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output id string = sqlsvr.id
output name string = sqlsvr.name
output connectionString string = 'Driver={ODBC Driver 18 for SQL Server};Server=tcp:${sqlsvr.name}${environment().suffixes.sqlServerHostname},1433;Database=${sqldb.name};Uid=${sqlService.server.admin.username};Pwd=${sqlService.server.admin.password};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;'
