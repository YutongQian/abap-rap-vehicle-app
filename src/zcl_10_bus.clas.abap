CLASS zcl_10_bus DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC INHERITING FROM zcl_10_vehicle.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
                i_manufacturer TYPE mtys_vehicletypes-manufacturer
                i_model        TYPE mtys_vehicletypes-model
                i_chassisno    TYPE mtyv_chassisno
      RAISING   zcx_10_vehicle_invalid.
    METHODS:
      display_attributes  REDEFINITION,
      get_passanz RETURNING VALUE(rv_passany) TYPE mtys_vehicletypes-pass.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_bus IMPLEMENTATION.
  METHOD display_attributes.
    rt_attributes = super->display_attributes(  ).
    APPEND |    Tankcapacity = { tank_cap } { tankcap_unit }                                    | TO rt_attributes.
    APPEND |    Passagiere number      = { pass }                                                       | TO rt_attributes.

    APPEND |    TV       = { COND string( WHEN tv     = abap_true THEN `yes` ELSE `no` ) }| TO rt_attributes.
    APPEND |    Toilet        = { COND string( WHEN toilet     = abap_true THEN `yes` ELSE `no` ) }| TO rt_attributes.
    APPEND |------------------------------------------------------------------------------------| TO rt_attributes.
    APPEND |                                                                                    | TO rt_attributes.

  ENDMETHOD.

  METHOD get_passanz.
    rv_passany = pass.

  ENDMETHOD.

  METHOD constructor.

    super->constructor( i_manufacturer = i_manufacturer i_model = i_model i_chassisno = i_chassisno ).
    DATA(ls_vehicleattr) = mt_vehicletypes[  manufacturer = i_manufacturer model = i_model ].
    pass = ls_vehicleattr-pass.
    tv = ls_vehicleattr-tv.
    toilet = ls_vehicleattr-toilet.

    mv_class_name = 'Bus'.

  ENDMETHOD.

ENDCLASS.
