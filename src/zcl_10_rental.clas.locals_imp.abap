*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_car definition create public.

  public section.
  TYPES: BEGIN OF mtys_vehicletypes,
             manufacturer TYPE c LENGTH 10,
             model        TYPE c LENGTH 10,
             chassisno    TYPE n LENGTH 20,
             vehicle_kind TYPE c LENGTH 10,
             seats        TYPE i,
             cargo        TYPE p LENGTH 4 DECIMALS 0,
             tank_cap     TYPE p LENGTH 3 DECIMALS 0,
             cargo_unit   TYPE c LENGTH 3,
             tankcap_unit TYPE c LENGTH 3,
             pass         TYPE i,
             tv           TYPE abap_bool,
             toilet       TYPE abap_bool,
           END OF   mtys_vehicletypes.
    TYPES: mtyv_chassisno  TYPE n LENGTH 20.
    TYPES: mtyt_string TYPE STANDARD TABLE OF string WITH NON-UNIQUE KEY table_line.
    CLASS-METHODS class_constructor.
    METHODS: display_attributes RETURNING VALUE(rt_attributes) TYPE mtyt_string,
      get_make RETURNING VALUE(rv_make) TYPE mtys_vehicletypes-manufacturer,
      get_model RETURNING VALUE(rv_model) TYPE mtys_vehicletypes-model,
      get_chassisno RETURNING VALUE(rv_chassisno) TYPE mtyv_chassisno,
      get_seats  RETURNING VALUE(rv_seats) TYPE mtys_vehicletypes-seats.
    METHODS constructor
      IMPORTING
                i_manufacturer TYPE lcl_car=>mtys_vehicletypes-manufacturer
                i_model        TYPE lcl_car=>mtys_vehicletypes-model
                i_chassisno    TYPE lcl_car=>mtyv_chassisno
      RAISING   zcx_10_vehicle_invalid.
  protected section.
  private section.
  DATA:
      manufacturer TYPE mtys_vehicletypes-manufacturer,
      model        TYPE mtys_vehicletypes-model,
      chassis_no   TYPE mtyv_chassisno,
      seats        TYPE mtys_vehicletypes-seats,
      tank_cap     TYPE mtys_vehicletypes-tank_cap,
      tankcap_unit TYPE mtys_vehicletypes-tankcap_unit.
    CLASS-DATA:
        mt_vehicletypes  TYPE SORTED TABLE OF mtys_vehicletypes WITH UNIQUE KEY manufacturer model.

endclass.

class lcl_car implementation.
 METHOD display_attributes.
    APPEND |------------------------------------------------------------------------------------| TO rt_attributes.
    APPEND |Car ( Manufacturer = { manufacturer } Model = { model } Cassis-No = { chassis_no } )| TO rt_attributes.
    APPEND |    Seats        = { seats }                                                        | TO rt_attributes.
    APPEND |    Tankcapacity = { tank_cap } { tankcap_unit }                                    | TO rt_attributes.
    APPEND |------------------------------------------------------------------------------------| TO rt_attributes.
    APPEND |                                                                                    | TO rt_attributes.

  ENDMETHOD.
  METHOD constructor.
*   Check imported values
    READ TABLE mt_vehicletypes WITH KEY manufacturer = i_manufacturer TRANSPORTING NO FIELDS.
    IF sy-subrc IS NOT INITIAL. RAISE EXCEPTION TYPE zcx_10_vehicle_invalid EXPORTING iv_manufacturer = i_manufacturer. ENDIF.
    READ TABLE mt_vehicletypes WITH KEY manufacturer = i_manufacturer model = i_model TRANSPORTING NO FIELDS.
    IF sy-subrc IS NOT INITIAL. RAISE EXCEPTION TYPE zcx_10_vehicle_invalid EXPORTING iv_model = i_model. ENDIF.
    IF i_chassisno IS INITIAL. RAISE EXCEPTION TYPE zcx_10_vehicle_invalid. ENDIF.
*   Fill attributes
    me->manufacturer = i_manufacturer.
    me->model = i_model.
    me->chassis_no = i_chassisno.
*   Get Values for other Attributes from Vehicletypetable
    DATA(ls_vehicleattr) = mt_vehicletypes[  manufacturer = i_manufacturer model = i_model ].
    seats = ls_vehicleattr-seats.
    tank_cap = ls_vehicleattr-tank_cap.
    tankcap_unit = ls_vehicleattr-tankcap_unit.
  ENDMETHOD.
  METHOD class_constructor.
    mt_vehicletypes
      = VALUE #( ( manufacturer = 'AUDI' model = 'A3' vehicle_kind = 'CAR' seats = 5 cargo = 0 cargo_unit = space tank_cap = 80 tankcap_unit = 'LTR' pass = 0 tv = abap_false  toilet = abap_false  )        "Car
                 ( manufacturer = 'AUDI' model = 'A6' vehicle_kind = 'CAR' seats = 5 cargo = 0 cargo_unit = space tank_cap = 1000 tankcap_unit = 'LTR' pass = 0 tv = abap_false  toilet = abap_false )       "Car
                 ( manufacturer = 'BMW' model = 'X3' vehicle_kind = 'CAR' seats = 5 cargo = 0 cargo_unit = space tank_cap = 80 tankcap_unit = 'LTR' pass = 0 tv = abap_false  toilet = abap_false )          "Car
                 ( manufacturer = 'MAN' model = 'TX' vehicle_kind = 'TRUCK' seats = 3 cargo = 30000 cargo_unit = 'KG' tank_cap = 300 tankcap_unit = 'LTR' pass = 0 tv = abap_false  toilet = abap_true )     "truck
                 ( manufacturer = 'VOLVO' model = 'XX' vehicle_kind = 'TRUCK' seats = 3 cargo = 30000 cargo_unit = 'KG' tank_cap = 300 tankcap_unit = 'LTR'  pass = 0 tv = abap_false  toilet = abap_false ) "truck
                 ( manufacturer = 'SETRA' model = 'SE10' vehicle_kind = 'BUS' seats = 1 cargo = 0 cargo_unit = space tank_cap = 300 tankcap_unit = 'LTR'  pass = 45 tv = abap_true  toilet = abap_true )     "Bus
    ).
  ENDMETHOD.
  METHOD get_chassisno.
    rv_chassisno = chassis_no.
  ENDMETHOD.
  METHOD get_make.
    rv_make = manufacturer.
  ENDMETHOD.
  METHOD get_model.
    rv_model = model.
  ENDMETHOD.
  METHOD get_seats.
    rv_seats = seats.
  ENDMETHOD.

endclass.

