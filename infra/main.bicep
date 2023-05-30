targetScope = 'subscription'

param name string
param location string = 'Korea Central'
@secure()
param appServiceKey string

param apiManagementPublisherName string = 'GitHub Issues Summary'
param apiManagementPublisherEmail string = 'apim@hackersground.kr'

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
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|7.0'
    }
    useAoai: false
    aoai: {}
    apimApi: {
      name: 'GitHubIssues'
      displayName: 'GitHubIssues'
      description: 'GitHub Issues API'
      serviceUrl: 'https://appsvc-${name}-dotnet-api.azurewebsites.net'
      path: 'github'
      api: {
        format: 'openapi-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/openapi-dotnet.yaml'
      }
      policy: {
        format: 'xml-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-dotnet.xml'
      }
      operations: []
      subscriptionRequired: false
    }
  }
  {
    name: 'JAVA'
    useApp: true
    suffix: 'java'
    siteConfig: {
      linuxFxVersion: 'JAVA|17-java17'
    }
    useAoai: true
    aoai: {
      apiEndpoint: 'to_be_replaced' //cogsvc.outputs.aoaiApiEndpoint
      apiVersion: 'to_be_replaced' //cogsvc.outputs.aoaiApiVersion
      apiDeploymentId: 'to_be_replaced' //cogsvc.outputs.aoaiApiDeploymentId
    }
    apimApi: {
      name: 'ChatCompletions'
      displayName: 'ChatCompletions'
      description: 'Chat Completions API'
      serviceUrl: 'https://appsvc-${name}-java-api.azurewebsites.net'
      path: 'aoai'
      api: {
        format: 'openapi-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/openapi-java.yaml'
      }
      policy: {
        format: 'xml-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-java.xml'
      }
      operations: []
      subscriptionRequired: false
    }
  }
  {
    name: 'PYTHON'
    useApp: true
    suffix: 'python'
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.11'
    }
    useAoai: false
    aoai: {}
    apimApi: {
      name: 'GitHubIssueStorage'
      displayName: 'GitHubIssueStorage'
      description: 'GitHub Issue Storage API'
      serviceUrl: 'https://appsvc-${name}-python-api.azurewebsites.net'
      path: 'storage'
      api: {
        format: 'openapi-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/openapi-python.yaml'
      }
      policy: {
        format: 'xml-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-python.xml'
      }
      operations: []
      subscriptionRequired: false
    }
  }
  {
    name: 'BFF'
    useApp: false
    suffix: 'bff'
    siteConfig: {}
    useAoai: false
    aoai: {}
    apimApi: {
      name: 'GitHubIssuesSummary'
      displayName: 'GitHubIssuesSummary'
      description: 'GitHub Issues Summary API'
      serviceUrl: 'https://apim-${name}.azure-api.net'
      path: 'bff'
      api: {
        format: 'openapi-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/openapi-bff.yaml'
      }
      policy: {
        format: 'xml-link'
        value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-bff.xml'
      }
      operations: [
        {
          name: 'ChatCompletions'
          policy: {
            format: 'xml-link'
            value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-bff-op-chatcompletions.xml'
          }
        }
        {
          name: 'Issues'
          policy: {
              format: 'xml-link'
              value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-bff-op-issues.xml'
          }  
        }
        {
          name: 'IssueById'
          policy: {
            format: 'xml-link'
            value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-bff-op-issuebyid.xml'
          }
        }
        {
          name: 'Storage'
          policy: {
            format: 'xml-link'
            value: 'https://raw.githubusercontent.com/hackersground-kr/workshop/main/infra/apim-policy-api-bff-op-storage.xml'
          }
        }
      ]
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
    linuxFxVersion: app.siteConfig.linuxFxVersion
    useAoai: app.useAoai
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
    appServiceKey: appServiceKey
    aoaiToken: 'to_be_replaced' //cogsvc.outputs.aoaiApiKey
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
    suffix: app.suffix
    apiManagementApiName: app.apimApi.name
    apiManagementApiDisplayName: app.apimApi.displayName
    apiManagementApiDescription: app.apimApi.description
    apiManagementApiServiceUrl: app.apimApi.serviceUrl
    apiManagementApiPath: app.apimApi.path
    apiManagementApiFormat: app.apimApi.api.format
    apiManagementApiValue: app.apimApi.api.value
    apiManagementApiPolicyFormat: app.apimApi.policy.format
    apiManagementApiPolicyValue: app.apimApi.policy.value
    apiManagementApiOperations: app.apimApi.operations
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
