CLASS zcl_10_rental DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    TYPES: mtyv_chassisno  TYPE n LENGTH 20. "Type for Chassisno
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_rental IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  data: car_count    type i.
    DATA: mt_vehicles  TYPE STANDARD TABLE OF REF TO lcl_car WITH NON-UNIQUE KEY table_line. "Table for Aggregaton-relationship...
    DATA: lo_excp  TYPE REF TO cx_root.
    TRY.  "By a new car
        APPEND NEW lcl_car( i_manufacturer = 'AUDI' i_model = 'A6' i_chassisno = CONV #( '00001000010000000001' ) )  TO mt_vehicles.
      CATCH zcx_10_vehicle_invalid INTO lo_excp.
        out->write( lo_excp->get_text(  ) ).
    ENDTRY.
    TRY.  "By a new car
        APPEND NEW lcl_car( i_manufacturer = 'BMW' i_model = 'X3' i_chassisno = CONV #( '00001000010000000002' ) )   TO mt_vehicles.
      CATCH zcx_10_vehicle_invalid INTO lo_excp.
        out->write( lo_excp->get_text(  ) ).
    ENDTRY.
    TRY.  "By a new car
        APPEND NEW lcl_car( i_manufacturer = 'AUDI' i_model = 'A3' i_chassisno = CONV #( '00001000010000000003' ) )  TO mt_vehicles.
      CATCH zcx_10_vehicle_invalid INTO lo_excp.
        out->write( lo_excp->get_text(  ) ).
    ENDTRY.

* Display all Attributes of Rental-Company:
    out->write( |Rental-Company:  House of rusty vehicles | ).
    out->write( |List of our { lines( mt_vehicles ) } vehicles: | ).
    LOOP AT mt_vehicles INTO DATA(lo_vehicle_line1).
      out->write( lo_vehicle_line1->display_attributes( ) ).
    ENDLOOP.
* Display number of vehicles
    out->write( | | ).
    clear car_count.
    LOOP AT mt_vehicles INTO DATA(lo_vehicle_line2) WHERE TABLE_LINE is INSTANCE OF lcl_car.
      car_count += 1.
    ENDLOOP.
    out->write( |Number of our Cars: { car_count } | ).
  ENDMETHOD.
ENDCLASS.
