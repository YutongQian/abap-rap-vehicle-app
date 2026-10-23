@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'Z10VEHTYPE'
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AbapCatalog.extensibility.extensible: true  
@AbapCatalog.extensibility.elementSuffix: 'ZCA' 
define root view entity Z_R_10VEHTYPE
  as select from z10_vehtype as Vehicletype
{
  key manufacturer as Manufacturer,
  key model as Model,
  manu_name as ManuName,
  vehicle_kind as VehicleKind,
  seats as Seats,
  @Semantics.quantity.unitOfMeasure: 'CargoUnit'
  cargo as Cargo,
  @Semantics.quantity.unitOfMeasure: 'TankcapUnit'
  tank_cap as TankCap,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_UnitOfMeasureStdVH', 
    entity.element: 'UnitOfMeasure', 
    useForValidation: true
  } ]
  cargo_unit as CargoUnit,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_UnitOfMeasureStdVH', 
    entity.element: 'UnitOfMeasure', 
    useForValidation: true
  } ]
  tankcap_unit as TankcapUnit,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_UnitOfMeasureStdVH', 
    entity.element: 'UnitOfMeasure', 
    useForValidation: true
  } ]
  pass as Pass,
  tv as Tv,
  toilet as Toilet,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
