CLASS zcx_10_vehicle_invalid DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .
    DATA: manufacturer TYPE c LENGTH 10,
          model        TYPE c LENGTH 10.
    METHODS get_text REDEFINITION.

    METHODS constructor
      IMPORTING
        iv_manufacturer LIKE manufacturer  OPTIONAL
        iv_model        LIKE model         OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_10_vehicle_invalid IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
        CALL METHOD super->constructor.
    manufacturer = iv_manufacturer.
    model        = iv_model.
  ENDMETHOD.
  METHOD get_text.
    result = COND #( WHEN manufacturer IS INITIAL AND model IS INITIAL THEN |Chassis number is invalid!|
                     WHEN manufacturer IS NOT INITIAL AND model IS INITIAL THEN |Manufacturer { manufacturer }  is invalid!|
                     WHEN manufacturer IS INITIAL AND model IS NOT INITIAL THEN |Model { model }  is invalid!|
                     ELSE |Manufacturer { manufacturer } and Model { model } is invalid!|
                    ) .
  ENDMETHOD.
ENDCLASS.
