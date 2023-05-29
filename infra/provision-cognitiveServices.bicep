param name string
param location string = resourceGroup().location

param aoaiModels array = [
  {
    name: 'gpt-35-turbo'
    deploymentName: 'model-gpt35turbo'
    version: '0301'
    apiVersion: '2023-05-15'
  }
//   {
//     name: 'gpt-4-32k'
//     deploymentName: 'model-gpt432k'
//     version: '0314'
//     apiVersion: '2023-05-15'
//   }
]

module aoai './openAI.bicep' = {
  name: 'OpenAI'
  params: {
    name: name
    location: location
    aoaiModels: aoaiModels
  }
}

output aoaiApiKey string = aoai.outputs.apiKey
output aoaiApiEndpoint string = aoai.outputs.endpoint
output aoaiApiVersion string = aoaiModels[0].apiVersion
output aoaiApiDeploymentId string = aoaiModels[0].deploymentName
