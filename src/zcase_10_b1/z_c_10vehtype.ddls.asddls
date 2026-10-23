@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'Z10VEHTYPE'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity Z_C_10VEHTYPE
  provider contract transactional_query
  as projection on Z_R_10VEHTYPE
  association [1..1] to Z_R_10VEHTYPE as _BaseEntity on $projection.Manufacturer = _BaseEntity.Manufacturer and $projection.Model = _BaseEntity.Model
{
  key Manufacturer,
  key Model,
  ManuName,
  VehicleKind,
  Seats,
  @Semantics: {
    quantity.unitOfMeasure: 'CargoUnit'
  }
  Cargo,
  @Semantics: {
    quantity.unitOfMeasure: 'TankcapUnit'
  }
  TankCap,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'UnitOfMeasure', 
      entity.name: 'I_UnitOfMeasureStdVH', 
      useForValidation: true
    } ]
  }
  CargoUnit,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'UnitOfMeasure', 
      entity.name: 'I_UnitOfMeasureStdVH', 
      useForValidation: true
    } ]
  }
  TankcapUnit,
 @EndUserText.label: 'Passengers'
  Pass,
  Tv,
  Toilet,
  @Semantics: {
    user.createdBy: true
  }
  CreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  CreatedAt,
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
