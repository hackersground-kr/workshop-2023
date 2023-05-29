targetScope = 'subscription'

param name string
param location string = 'Korea Central'

param apiManagementPublisherName string = 'GitHub Issues Summary'
param apiManagementPublisherEmail string = 'apim@contoso.com'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${name}'
  location: location
}

// module cogsvc './provision-cognitiveServices.bicep' = {
//   name: 'CognitiveServices'
//   scope: rg
//   params: {
//     name: name
//     location: location
//   }
// }

var apps = [
  {
    name: 'DOTNET'
    useApp: true
    suffix: 'dotnet'
    useAoai: false
    aoai: {
      apiKey: ''
      apiEndpoint: ''
      apiVersion: ''
      apiDeploymentId: ''
    }
    apimApi: {
      name: 'GitHubIssues'
      displayName: 'GitHubIssues'
      description: 'GitHub Issues API'
      serviceUrl: 'https://appsvc-${name}-dotnet.azurewebsites.net'
      path: ''
      api: {
        format: 'openapi-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/openapi-dotnet.yaml'
      }
      policy: {
        format: 'xml-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-dotnet.xml'
      }
      subscriptionRequired: false
    }
  }
  {
    name: 'JAVA'
    useApp: true
    suffix: 'java'
    useAoai: true
    aoai: {
      apiKey: 'to_be_replaced' //cogsvc.outputs.aoaiApiKey
      apiEndpoint: 'to_be_replaced' //cogsvc.outputs.aoaiApiEndpoint
      apiVersion: 'to_be_replaced' //cogsvc.outputs.aoaiApiVersion
      apiDeploymentId: 'to_be_replaced' //cogsvc.outputs.aoaiApiDeploymentId
    }
    apimApi: {
      name: 'ChatCompletion'
      displayName: 'ChatCompletion'
      description: 'Chat Completion API'
      serviceUrl: 'https://appsvc-${name}-java.azurewebsites.net'
      path: ''
      api: {
        format: 'openapi-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/openapi-java.yaml'
      }
      policy: {
        format: 'xml-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-java.xml'
      }
      subscriptionRequired: false
    }
  }
  {
    name: 'PYTHON'
    useApp: true
    suffix: 'python'
    useAoai: false
    aoai: {
      apiKey: ''
      apiEndpoint: ''
      apiVersion: ''
      apiDeploymentId: ''
    }
    apimApi: {
      name: 'GitHubIssueStorage'
      displayName: 'GitHubIssueStorage'
      description: 'GitHub Issue Storage API'
      serviceUrl: 'https://appsvc-${name}-python.azurewebsites.net'
      path: ''
      api: {
        format: 'openapi-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/openapi-python.yaml'
      }
      policy: {
        format: 'xml-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-python.xml'
      }
      subscriptionRequired: false
    }
  }
  {
    name: 'BFF'
    useApp: false
    suffix: 'bff'
    useAoai: false
    aoai: {
      apiKey: ''
      apiEndpoint: ''
      apiVersion: ''
      apiDeploymentId: ''
    }
    apimApi: {
      name: 'GitHubIssuesSummary'
      displayName: 'GitHubIssuesSummary'
      description: 'GitHub Issues Summary API'
      serviceUrl: 'https://apim-${name}.azurewebsites.net'
      path: 'bff'
      api: {
        format: 'openapi-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/openapi-bff.yaml'
      }
      policy: {
        format: 'xml-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-bff.xml'
      }
      subscriptionRequired: false
    }
  }
]

module appsvc './provision-appService.bicep' = [for (app, i) in apps: if (app.useApp == true) {
  name: 'AppService_${app.name}'
  scope: rg
  params: {
    name: '${name}-${app.suffix}'
    location: location
    aoaiApiKey: app.useAoai ? app.aoai.apiKey : ''
    aoaiApiEndpoint: app.useAoai ? app.aoai.apiEndpoint : ''
    aoaiApiVersion: app.useAoai ? app.aoai.apiVersion : ''
    aoaiApiDeploymentId: app.useAoai ? app.aoai.apiDeploymentId : ''
  }
}]
    
module apim './provision-apiManagement.bicep' = {
  name: 'ApiManagement'
  scope: rg
  params: {
    name: name
    location: location
    apiManagementPublisherName: apiManagementPublisherName
    apiManagementPublisherEmail: apiManagementPublisherEmail
    apiManagementPolicyFormat: 'xml-link'
    apiManagementPolicyValue: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-global.xml'
  }
}

module apis './provision-apiManagementApi.bicep' = [for (app, i) in apps: {
  name: 'ApiManagementApi_${app.name}'
  scope: rg
  dependsOn: [
    apim
  ]
  params: {
    name: name
    location: location
    apiManagementApiName: app.apimApi.name
    apiManagementApiDisplayName: app.apimApi.displayName
    apiManagementApiDescription: app.apimApi.description
    apiManagementApiServiceUrl: app.apimApi.serviceUrl
    apiManagementApiPath: app.apimApi.path
    apiManagementApiFormat: app.apimApi.api.format
    apiManagementApiValue: app.apimApi.api.value
    apiManagementApiPolicyFormat: app.apimApi.policy.format
    apiManagementApiPolicyValue: app.apimApi.policy.value
    apiManagementApiSubscriptionRequired: app.apimApi.subscriptionRequired
  }
}]

module sttapp './provision-staticWebApp.bicep' = {
  name: 'StaticWebApp'
  scope: rg
  params: {
    name: name
    location: location
    apiManagementId: apim.outputs.id
  }
}
