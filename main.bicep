@description('The name of the environment')
@allowed([
  'dev'
  'prod'
])
param environmentType string

@description('Name of the Resource Group')
param resourcegroupName string

@description('Name of the Storage Account')
param storageaccountName string

@description('Name of the Blob Container')
param blobcontainerName string

@description('Name of App Service Plan')
param appservicePlanName string

@description('Location of resources')
param location string = resourceGroup().location

@description('The unique name of a solution')
@minLength(5)
@maxLength(24)
param solutionName string = 'sol${uniqueString(resourceGroup().id)}'

var sasolutionexample = 'sa${solutionName}${environmentType}'

// Define Skus for each component based on the environmentType
var environmentConfigurationMap = {
  dev: {
    appServicePlan: {
      sku: {
        name: 'B1'
        tier: 'Basic'
        capacity: 1
      }
    }
  }
  prod: {
    appServicePlan: {
      sku: {
        name: 'S1'
        tier: 'Standard'
        capacity: 1
      }
    }

  }
}


// Create Storage Account
module storage 'modules/storageaccount.bicep' = {
  name: 'storage'
  scope: resourceGroup(resourcegroupName)
  params: {
    kind: 'StorageV2'
    location: location
    sku: 'Standard_LRS'
    storageaccountName: storageaccountName
  }
}

// Create Blob Container
module blobcontainer 'modules/blobcontainer.bicep' = {
  name: 'blobcontainer'
  params: {
    blobcontainerName: blobcontainerName
    storageaccountName: storageaccountName
  }
  dependsOn: [
    storage
  ]
}

// Create Storage Account using loop
module storageaccountloop 'modules/storageaccountloops.bicep' = {
  name: 'storageloops'
  params: {
    kind: 'StorageV2'
    location: location
    sku: 'Standard_LRS'
    storageaccountName: sasolutionexample 
  }
}

module appserviceplan 'modules/appserviceplan.bicep' = {
  name: 'asp'
  params: {
    aspName: appservicePlanName 
    location: location
    appServicePlanSku: environmentConfigurationMap[environmentType].appServicePlan.sku
  }
}

output storageaccounts array = storageaccountloop.outputs.storageaccount
