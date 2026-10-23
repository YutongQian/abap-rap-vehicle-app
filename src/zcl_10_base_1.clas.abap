"! <p class="shorttext synchronized" lang="en">Base 1</p>
"! Base class for the flight connection exercise.
"! Provides methods to read connections and their flights.
CLASS zcl_10_base_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.


    TYPES ttyt_flights TYPE SORTED TABLE OF /dmo/flight
              WITH NON-UNIQUE KEY carrier_id connection_id.
    TYPES: BEGIN OF ttys_conns,
             carrier_id    TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
           END OF ttys_conns.
    TYPES: BEGIN OF ttys_connflights,
             carrier_id    TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
             flights       TYPE ttyt_flights,
           END OF ttys_connflights.

    TYPES: ttyt_conns TYPE STANDARD TABLE OF ttys_conns WITH EMPTY  KEY.
    TYPES ttyt_connflights TYPE SORTED TABLE OF ttys_connflights
          WITH UNIQUE KEY carrier_id connection_id.
    TYPES: ttyt_carrier_range TYPE RANGE OF /dmo/carrier_id.
    DATA: mv_carrier     TYPE /dmo/carrier_id,
          mv_connection  TYPE /dmo/connection_id,
          mt_connflights TYPE ttyt_connflights.
    "! Gets connection flights for the given airline carriers
    "! @parameter it_carriers | Range table of airline carriers
    "! @parameter rt_connflights | Table of connection flights
    METHODS get_connflights IMPORTING it_carriers           TYPE ttyt_carrier_range
                            RETURNING VALUE(rt_connflights) TYPE ttyt_connflights.
    "! Gets the flights of a single connection from the given source table
    "! @parameter iv_carrier | Airline carrier ID
    "! @parameter iv_connection | Connection ID
    "! @parameter it_source | Table of connection flights to search in
    "! @parameter rs_flights | Flights of the requested connection
    METHODS get_flights_of_connection IMPORTING iv_carrier        TYPE ttys_conns-carrier_id
                                                iv_connection     TYPE ttys_conns-connection_id
                                                it_source         TYPE ttyt_connflights
                                      RETURNING VALUE(rs_flights) TYPE ttys_connflights.
ENDCLASS.



CLASS zcl_10_base_1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*     Simulation of User's input


    DATA(lt_user_input) = VALUE ttyt_carrier_range( ( sign = 'I' option = 'EQ' low = 'AA' )
                                                   ( sign = 'I' option = 'EQ' low = 'AZ' )
                                                   ( sign = 'I' option = 'EQ' low = 'LH' )
                                                 ).
*   Data retrieval according to user input
    mt_connflights = get_connflights( lt_user_input ).

*   Selective output of data
    mv_carrier = 'AA'. mv_connection = '0018'.

    DATA(ls_output) = get_flights_of_connection( iv_carrier = mv_carrier iv_connection = mv_connection it_source = mt_connflights ).
    out->write( |Flights of selected connection (  { ls_output-carrier_id } { ls_output-connection_id } ): | ) ##NO_TEXT.

    out->write( ls_output-flights ).
  ENDMETHOD.

  METHOD get_connflights.
    DATA: lt_conns TYPE  ttyt_conns.

    DATA: lt_flights TYPE ttyt_flights.



    SELECT FROM /dmo/connection FIELDS carrier_id, connection_id WHERE carrier_id IN @it_carriers
              INTO TABLE @lt_conns.

    SELECT FROM /dmo/flight     FIELDS * WHERE carrier_id IN @it_carriers
    INTO TABLE @lt_flights.

    LOOP AT lt_conns ASSIGNING FIELD-SYMBOL(<ls_conn>).
      INSERT VALUE #( carrier_id    = <ls_conn>-carrier_id
                      connection_id = <ls_conn>-connection_id
                      flights       = FILTER #( lt_flights
                                                WHERE carrier_id    = <ls_conn>-carrier_id
                                                  AND connection_id = <ls_conn>-connection_id ) )
             INTO TABLE rt_connflights.
    ENDLOOP.

  ENDMETHOD.
  METHOD get_flights_of_connection.
    rs_flights = VALUE #( it_source[ KEY primary_key
                                         carrier_id    = iv_carrier
                                         connection_id = iv_connection ] OPTIONAL ).
  ENDMETHOD.

ENDCLASS.
