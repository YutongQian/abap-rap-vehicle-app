CLASS zcl_10_lkw DEFINITION
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
      get_cargo RETURNING VALUE(rv_cargo) TYPE zcl_10_vehicle=>mtys_vehicletypes-cargo.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_lkw IMPLEMENTATION.
METHOD constructor.
    super->constructor(
        i_manufacturer = i_manufacturer
        i_model = i_model
        i_chassisno = i_chassisno ).
    DATA(ls_vehicleattr) = mt_vehicletypes[  manufacturer = i_manufacturer model = i_model ].
    cargo = ls_vehicleattr-cargo.
    cargo_unit = ls_vehicleattr-cargo_unit.

    mv_class_name = 'LKW'.
  ENDMETHOD.
  METHOD display_attributes.
    rt_attributes = super->display_attributes(  ).
        APPEND |    Tankcapacity = { tank_cap } { tankcap_unit }                                    | TO rt_attributes.
    APPEND |    Cargo        = { cargo }  { cargo_unit }                                                      | TO rt_attributes.

    APPEND |------------------------------------------------------------------------------------| TO rt_attributes.
    APPEND |                                                                                    | TO rt_attributes.

  ENDMETHOD.

  METHOD get_cargo.
    rv_cargo = cargo.

  ENDMETHOD.
ENDCLASS.
