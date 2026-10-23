@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Volume Units'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI10_VolumeunitVH as select from I_UnitOfMeasure
{
    @ObjectModel.text.element: [ 'UnitDescription' ]
  key UnitOfMeasure,
  _Text[ 1: Language = $session.system_language ].UnitOfMeasureName as UnitDescription
}where UnitOfMeasureDimension = 'VOLUME'
