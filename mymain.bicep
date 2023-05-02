param location string = 'westus2'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'myResourceGroup'
  location: location
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-04-01' = {
  name: 'myVirtualNetwork'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}
