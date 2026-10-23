@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Valuehelp (fixed values vehiclekind)'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi10_vehkindVH as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name : 'ZDO10_VEHICLE_KIND' ) as VehkindValue
  association [0..1] to DDCDS_CUSTOMER_DOMAIN_VALUE_T as _text on  VehkindValue.domain_name    = _text.domain_name
                                                               and VehkindValue.value_position = _text.value_position
                                                               and _text.language              = $session.system_language
{
  @UI.textArrangement: #TEXT_ONLY
  @ObjectModel.text.element: [ 'Description' ]
  key domain_name                                  as DomName,
  key value_position                               as ValuePosition,
      value_low                                    as VehicleKind,
      //    ,value_high
      _text( p_domain_name : 'ZDO10_VEHICLE_KIND').text as Description
      }
