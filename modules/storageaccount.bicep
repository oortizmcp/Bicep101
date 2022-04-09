param storageaccountName string
param location string
param sku string
param kind string

// Create Storage Account
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageaccountName
  location: location
  sku: {
    name: sku
  }
  kind: kind 
}
