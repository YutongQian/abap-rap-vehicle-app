CLASS lhc_zr_10flight_b6 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES ty_date_char TYPE c LENGTH 8.

    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Zr10flightB6
        RESULT result,
      set_changecount FOR DETERMINE ON SAVE
       keys FOR Zr10flightB6~set_changecount.

    METHODS check_flightdate FOR VALIDATE ON SAVE
       keys FOR Zr10flightB6~check_flightdate.
ENDCLASS.

CLASS lhc_zr_10flight_b6 IMPLEMENTATION.
  METHOD get_global_authorizations.

  ENDMETHOD.
  METHOD set_changecount.
    DATA lt_update_records TYPE TABLE FOR UPDATE zr_10flight_b6.
    READ ENTITIES OF zr_10flight_b6 IN LOCAL MODE
        ENTITY Zr10flightB6
        FIELDS ( ChangeCount ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_flights).

    LOOP AT lt_flights ASSIGNING FIELD-SYMBOL(<ls_flight>).
      DATA lv_new_count LIKE <ls_flight>-ChangeCount.
      SELECT SINGLE change_count
        FROM z10_flight_b6
        WHERE carrier_id    = @<ls_flight>-CarrierID
          AND connection_id = @<ls_flight>-ConnectionID
          AND flight_date   = @<ls_flight>-FlightDate
        INTO @DATA(lv_db_count).

      lv_new_count = COND #( WHEN sy-subrc = 0 THEN lv_db_count + 1
                                ELSE 0 ).

      CHECK lv_new_count <> <ls_flight>-ChangeCount.

      APPEND VALUE #( %tky        = <ls_flight>-%tky
                      ChangeCount = lv_new_count ) TO lt_update_records.
    ENDLOOP.

    IF lt_update_records IS NOT INITIAL.
      MODIFY ENTITIES OF zr_10flight_b6 IN LOCAL MODE
        ENTITY Zr10flightB6
        UPDATE FIELDS ( ChangeCount ) WITH lt_update_records.
    ENDIF.


  ENDMETHOD.

  METHOD check_flightdate.
    READ ENTITIES OF zr_10flight_b6 IN LOCAL MODE
      ENTITY Zr10flightB6
          FIELDS ( FlightDate )
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_flights).
    LOOP AT lt_flights ASSIGNING FIELD-SYMBOL(<ls_flight>).
      APPEND VALUE #( %tky        = <ls_flight>-%tky
                        %state_area = 'VALIDATE_FLIGHTDATE' ) TO reported-zr10flightb6.
      DATA(lv_date_invalid) = abap_false.

      IF <ls_flight>-FlightDate IS INITIAL .
        lv_date_invalid = abap_true.
      ELSE.
        TRY.
            DATA(lv_test_date) = EXACT d( CONV ty_date_char( <ls_flight>-FlightDate ) ) ##NEEDED.
          CATCH cx_sy_conversion_error.
            lv_date_invalid = abap_true.
        ENDTRY.

      ENDIF.
      IF lv_date_invalid = abap_true.
        APPEND VALUE #( %tky = <ls_flight>-%tky ) TO failed-zr10flightb6.
        APPEND VALUE #( %tky        = <ls_flight>-%tky
                        %state_area = 'VALIDATE_FLIGHTDATE'
                        %msg        = new_message( id       = 'Z10P2RAP'
                                                   number   = '001'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-flightdate = if_abap_behv=>mk-on
                      ) TO reported-zr10flightb6.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
