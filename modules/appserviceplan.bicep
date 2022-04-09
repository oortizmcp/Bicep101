param aspName string
param location string
param appServicePlanSku object

//App Service Plan
resource appserviceplan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: aspName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
  }
}
