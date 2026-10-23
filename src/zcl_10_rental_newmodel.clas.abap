CLASS zcl_10_rental_newmodel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    TYPES: mtyv_chassisno  TYPE n LENGTH 20. "Type for Chassisno
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_rental_newmodel IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA: car_count TYPE i,
          lkw_count TYPE i,
          bus_count TYPE i.
    DATA: mt_vehicles  TYPE STANDARD TABLE OF REF TO lcl_vehicle WITH NON-UNIQUE KEY table_line. "Table for Aggregaton-relationship...
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
* --- Trucks ------------------------------------------------------------
    TRY.
        APPEND NEW lcl_lkw( i_manufacturer = 'MAN' i_model = 'TX'
                              i_chassisno = CONV #( '00001000010000000004' ) ) TO mt_vehicles.
      CATCH zcx_10_vehicle_invalid INTO lo_excp.
        out->write( lo_excp->get_text( ) ).
    ENDTRY.
    TRY.
        APPEND NEW lcl_lkw( i_manufacturer = 'VOLVO' i_model = 'XX'
                              i_chassisno = CONV #( '00001000010000000005' ) ) TO mt_vehicles.
      CATCH zcx_10_vehicle_invalid INTO lo_excp.
        out->write( lo_excp->get_text( ) ).
    ENDTRY.
* --- Buses -------------------------------------------------------------
    TRY.
        APPEND NEW lcl_bus( i_manufacturer = 'SETRA' i_model = 'SE10'
                            i_chassisno = CONV #( '00001000010000000006' ) ) TO mt_vehicles.
      CATCH zcx_10_vehicle_invalid INTO lo_excp.
        out->write( lo_excp->get_text( ) ).
    ENDTRY.
* Display all Attributes of Rental-Company:
    out->write( |Rental-Company:  House of rusty vehicles | ).
    out->write( |List of our { lines( mt_vehicles ) } vehicles: | ).
    LOOP AT mt_vehicles INTO DATA(lo_vehicle_line1).
      out->write( lo_vehicle_line1->display_attributes( ) ).
    ENDLOOP.
* Display number of vehicles
    out->write( | | ).
    CLEAR car_count. CLEAR lkw_count . CLEAR bus_count.
    LOOP AT mt_vehicles INTO DATA(lo_vehicle_line2) .
      IF  lo_vehicle_line2 IS INSTANCE OF lcl_car.
        car_count += 1.
      ELSEIF  lo_vehicle_line2 IS INSTANCE OF lcl_lkw.
        lkw_count += 1.
      ELSEIF lo_vehicle_line2 IS INSTANCE OF lcl_bus.
        bus_count += 1.
      ENDIF.
    ENDLOOP.
    out->write( |Number of our Cars: { car_count } | ).
    out->write( |Number of our Truks: { lkw_count } | ).
    out->write( |Number of our Buses: { bus_count } | ).
  ENDMETHOD.
ENDCLASS.
