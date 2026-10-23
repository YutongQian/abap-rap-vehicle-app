@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'Z10FLIGHT_B6'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_10FLIGHT_B6
  provider contract transactional_query
  as projection on ZR_10FLIGHT_B6
  association [1..1] to ZR_10FLIGHT_B6 as _BaseEntity on $projection.CarrierID = _BaseEntity.CarrierID and $projection.ConnectionID = _BaseEntity.ConnectionID and $projection.FlightDate = _BaseEntity.FlightDate
{
  @Consumption.valueHelpDefinition: [
                                    { entity: {
                                        name: '/LRN/S4D400_I_CarrierVH',
                                        element: 'CarrierID' 
                                        }  } ]
  @UI.identification: [{ position: 10 }]
  @UI.lineItem: [{ position: 10 }]                                      
  key CarrierID,
  @UI.identification: [{ position: 20 }]
  @UI.lineItem: [{ position: 20 }]
  key ConnectionID,
  @UI.identification: [{ position: 30 }]
  @UI.lineItem: [{ position: 30 }]
  key FlightDate,
  @EndUserText.label: 'Previous updates'
  @UI.identification: [{ position: 90 }] 
  @UI.lineItem: [{ position: 50 }] 
  ChangeCount,
  @UI.identification: [{ position: 40 }]
  @UI.lineItem: [{ position: 40 }]
  PlaneTypeID,
  @Semantics: {
    user.createdBy: true
  }

  LocalCreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }

  LocalCreatedAt,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }

  LocalLastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  
  LocalLastChangedAt,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
 
  LastChangedAt,
  _BaseEntity
}
