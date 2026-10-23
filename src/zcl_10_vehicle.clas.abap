CLASS zcl_10_vehicle DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
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
           END OF   mtys_vehicletypes,
           mtyv_chassisno  TYPE n LENGTH 20,
           mtyt_string TYPE STANDARD TABLE OF string WITH NON-UNIQUE KEY table_line.
    CLASS-METHODS class_constructor.
    METHODS: get_make RETURNING VALUE(rv_make) TYPE mtys_vehicletypes-manufacturer,
             get_model RETURNING VALUE(rv_model) TYPE mtys_vehicletypes-model,
             display_attributes RETURNING VALUE(rt_attributes) TYPE mtyt_string,
             get_chassisno RETURNING VALUE(rv_chassisno) TYPE mtyv_chassisno.
    METHODS constructor
      IMPORTING
                i_manufacturer TYPE mtys_vehicletypes-manufacturer
                i_model        TYPE mtys_vehicletypes-model
                i_chassisno    TYPE mtyv_chassisno
      RAISING   zcx_10_vehicle_invalid.
  PROTECTED SECTION.
   CLASS-DATA: mt_vehicletypes  TYPE SORTED TABLE OF mtys_vehicletypes WITH UNIQUE KEY manufacturer model.
    DATA: manufacturer  TYPE mtys_vehicletypes-manufacturer,
          model         TYPE mtys_vehicletypes-model,
          tank_cap      TYPE mtys_vehicletypes-tank_cap,
          tankcap_unit  TYPE mtys_vehicletypes-tankcap_unit,
          chassis_no    TYPE mtyv_chassisno,
          mv_class_name TYPE string,
          seats         TYPE mtys_vehicletypes-seats,
          cargo         TYPE mtys_vehicletypes-cargo,
          cargo_unit    TYPE mtys_vehicletypes-cargo_unit,
          pass          TYPE mtys_vehicletypes-pass,
          tv            TYPE mtys_vehicletypes-tv,
          toilet        TYPE mtys_vehicletypes-toilet.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_vehicle IMPLEMENTATION.

  METHOD get_chassisno.
    rv_chassisno = chassis_no.
  ENDMETHOD.

  METHOD display_attributes.
 APPEND |------------------------------------------------------------------------------------| TO rt_attributes.
    APPEND |{ mv_class_name } ( Manufacturer = { manufacturer } Model = { model } Cassis-No = { chassis_no } )| TO rt_attributes.



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
  METHOD constructor.
*   Check imported values
    READ TABLE mt_vehicletypes WITH KEY manufacturer = i_manufacturer TRANSPORTING NO FIELDS.
    IF sy-subrc IS NOT INITIAL. RAISE EXCEPTION TYPE zcx_10_vehicle_invalid EXPORTING iv_manufacturer = i_manufacturer. ENDIF.
    READ TABLE mt_vehicletypes WITH KEY manufacturer = i_manufacturer model = i_model TRANSPORTING NO FIELDS.
    IF sy-subrc IS NOT INITIAL. RAISE EXCEPTION TYPE zcx_10_vehicle_invalid EXPORTING iv_model = i_model. ENDIF.
    IF i_chassisno IS INITIAL. RAISE EXCEPTION TYPE zcx_10_vehicle_invalid. ENDIF.

    me->manufacturer = i_manufacturer.
    me->model = i_model.
    me->chassis_no = i_chassisno.

*   Fill attributes
    DATA(ls_vehicleattr) = mt_vehicletypes[  manufacturer = i_manufacturer model = i_model ].
    seats = ls_vehicleattr-seats.
    tank_cap = ls_vehicleattr-tank_cap.
    tankcap_unit = ls_vehicleattr-tankcap_unit.

  ENDMETHOD.

  METHOD get_model.
    rv_model = model.
  ENDMETHOD.

  METHOD get_make.
    rv_make = manufacturer.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.
ENDCLASS.
