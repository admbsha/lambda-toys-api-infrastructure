param location string
param prefix string
param vNetId string
param acaControl string = '${vNetId}/subnets/acaControlPlaneSubnet'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: '${prefix}-la-workspace'
  location: location
  properties: {
    sku: {
      name: 'pergb2018'
    }
  }
}

resource env 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: '${prefix}-container-env'
  location: location
  properties:{
    appLogsConfiguration:{
      destination: 'log-analytics'
      logAnalyticsConfiguration:{
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
   vnetConfiguration:{
      infrastructureSubnetId: acaControl  
    }
  }
}
