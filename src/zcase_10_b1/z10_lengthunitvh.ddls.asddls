@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Length Units'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity Z10_LENGTHUNITVH as select from I_UnitOfMeasure
{
  @ObjectModel.text.element: [ 'UnitDescription' ]
  key UnitOfMeasure,
  _Text[ 1: Language = $session.system_language ].UnitOfMeasureName as UnitDescription   
}where UnitOfMeasureDimension = 'LENGTH'
