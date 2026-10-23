CLASS zcl_10_car DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC INHERITING FROM zcl_10_vehicle.

  PUBLIC SECTION.






    METHODS:
     display_attributes  REDEFINITION,
    get_seats  RETURNING VALUE(rv_seats) TYPE zcl_10_vehicle=>mtys_vehicletypes-seats.

    METHODS constructor
      IMPORTING
                i_manufacturer TYPE mtys_vehicletypes-manufacturer
                i_model        TYPE mtys_vehicletypes-model
                i_chassisno    TYPE mtyv_chassisno
      RAISING   zcx_10_vehicle_invalid.
  PROTECTED SECTION.
  PRIVATE SECTION.
*  DATA:
*      manufacturer TYPE mtys_vehicletypes-manufacturer,
*      model        TYPE mtys_vehicletypes-model,
*      chassis_no   TYPE mtyv_chassisno,
*      seats        TYPE mtys_vehicletypes-seats,
*      tank_cap     TYPE mtys_vehicletypes-tank_cap,
*      tankcap_unit TYPE mtys_vehicletypes-tankcap_unit.
*    CLASS-DATA:
*        mt_vehicletypes  TYPE SORTED TABLE OF mtys_vehicletypes WITH UNIQUE KEY manufacturer model.
ENDCLASS.



CLASS zcl_10_car IMPLEMENTATION.




  METHOD constructor.
super->constructor(
              i_manufacturer = i_manufacturer
              i_model = i_model
              i_chassisno = i_chassisno ).
              DATA(ls_vehicleattr) = mt_vehicletypes[  manufacturer = i_manufacturer model = i_model ].
    seats = ls_vehicleattr-seats.
    mv_class_name = 'Car'.
  ENDMETHOD.
  METHOD display_attributes.
    rt_attributes = super->display_attributes(  ).
*    APPEND |------------------------------------------------------------------------------------| TO rt_attributes.
*    APPEND |Car ( Manufacturer = { manufacturer } Model = { model } Cassis-No = { chassis_no } )| TO rt_attributes.
    APPEND |    Seats        = { seats }                                                        | TO rt_attributes.
    APPEND |    Tankcapacity = { tank_cap } { tankcap_unit }                                    | TO rt_attributes.
    APPEND |------------------------------------------------------------------------------------| TO rt_attributes.
    APPEND |                                                                                    | TO rt_attributes.

  ENDMETHOD.




  METHOD get_seats.
    rv_seats = seats.
  ENDMETHOD.
ENDCLASS.
