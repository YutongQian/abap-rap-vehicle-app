CLASS lhc_z_r_10vehtype DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Vehicletype
        RESULT result,
      check_specifications FOR VALIDATE ON SAVE
       keys FOR Vehicletype~check_specifications.
ENDCLASS.

CLASS lhc_z_r_10vehtype IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD check_specifications.

    READ ENTITIES OF z_r_10vehtype IN LOCAL MODE
    ENTITY Vehicletype
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_vehicles).
    TYPES:BEGIN OF ty_error,
            msg_no TYPE symsgno,
            msg_v1 TYPE symsgv,
          END OF ty_error.
    DATA lt_errors TYPE STANDARD TABLE OF ty_error WITH EMPTY KEY.
    DATA: lr_seats    TYPE RANGE OF z_r_10vehtype-Seats,
          lr_pass     TYPE RANGE OF z_r_10vehtype-Pass,
          lr_cargo    TYPE RANGE OF z_r_10vehtype-Cargo,
          lr_tank_cap TYPE RANGE OF z_r_10vehtype-TankCap.
    lr_seats = VALUE #( ( sign = 'I' option = 'BT' low = 1 high = 200 ) ).
    lr_pass = VALUE #( ( sign = 'I' option = 'BT' low = 1 high = 200 ) ).
    lr_cargo = VALUE #( ( sign = 'I' option = 'BT' low = 1 high = 9999999 ) ).
    lr_tank_cap = VALUE #( ( sign = 'I' option = 'BT' low = 1 high = 99999 ) ).
    DATA: lv_vol_chk  TYPE abap_boolean,
          lv_mass_chk TYPE abap_boolean.
    LOOP AT  lt_vehicles ASSIGNING FIELD-SYMBOL(<ls_vehicle>).
      CLEAR lt_errors.
      APPEND VALUE #( %tky        = <ls_vehicle>-%tky
                        %state_area = 'VALIDATE_SPECS' ) TO reported-vehicletype.
      "--------------------------------------------
      "General check
      "--------------------------------------------
      "Vehicle kind check
      SELECT SINGLE FROM ddcds_customer_domain_value(
                        p_domain_name = 'ZDO10_VEHICLE_KIND' )
                        WITH PRIVILEGED ACCESS
       FIELDS value_low
       WHERE value_low = @<ls_vehicle>-VehicleKind
       INTO @DATA(lv_value).

      IF sy-subrc <> 0.
        APPEND VALUE #( msg_no = '007' msg_v1 = <ls_vehicle>-VehicleKind ) TO lt_errors.
      ENDIF.
      "Seats check.
      IF <ls_vehicle>-Seats NOT IN lr_seats.

        APPEND VALUE #( msg_no = '001'  ) TO lt_errors.
      ENDIF.
      "Tank capacity check
      IF <ls_vehicle>-TankCap < 0 OR <ls_vehicle>-TankCap NOT IN lr_tank_cap.

        APPEND VALUE #( msg_no = '008'  ) TO lt_errors.
      ENDIF.
      "Unit if Tank capacity check
      IF <ls_vehicle>-TankcapUnit IS INITIAL .
        APPEND VALUE #( msg_no = '003' msg_v1 = <ls_vehicle>-TankCapUnit ) TO lt_errors.
      ELSE.
        CLEAR lv_vol_chk.
        SELECT SINGLE @abap_true FROM I_UnitOfMeasure WITH PRIVILEGED ACCESS
                         WHERE UnitOfMeasure = @<ls_vehicle>-TankcapUnit AND UnitOfMeasureDimension = 'VOLUME'
                         INTO @lv_vol_chk.

        IF sy-subrc <> 0.
          APPEND VALUE #( msg_no = '003' msg_v1 = <ls_vehicle>-TankCapUnit ) TO lt_errors.

        ENDIF.
      ENDIF.

      "-----------------------------------
      "Check by vehicle type
      "------------------------------------
      "Car check
      CASE <ls_vehicle>-VehicleKind.
        WHEN 'CAR'.

          IF  <ls_vehicle>-Cargo > 0.
            APPEND VALUE #( msg_no = '009' ) TO lt_errors.
          ENDIF.
          IF <ls_vehicle>-Pass > 0.
            APPEND VALUE #( msg_no = '010' ) TO lt_errors.
          ENDIF.
          IF <ls_vehicle>-TankCap > 100 AND NOT line_exists( lt_errors[ msg_no = '008' ] ).
            APPEND VALUE #( msg_no = '005' ) TO lt_errors.
          ENDIF.
          "Truck check
        WHEN 'TRUCK'.
          IF <ls_vehicle>-Cargo <= 0 OR <ls_vehicle>-Cargo NOT IN lr_cargo.
            APPEND VALUE #( msg_no = '002' ) TO lt_errors.
          ENDIF.

          IF <ls_vehicle>-Pass > 0.
            APPEND VALUE #( msg_no = '010' ) TO lt_errors.
          ENDIF.
          IF <ls_vehicle>-CargoUnit IS INITIAL .
            APPEND VALUE #( msg_no = '006' msg_v1 = <ls_vehicle>-CargoUnit ) TO lt_errors.
          ELSE.
            CLEAR lv_mass_chk.
            SELECT SINGLE @abap_true FROM I_UnitOfMeasure WITH PRIVILEGED ACCESS
                      WHERE UnitOfMeasure = @<ls_vehicle>-CargoUnit AND UnitOfMeasureDimension = 'MASS'
                      INTO @lv_mass_chk.

            IF sy-subrc <> 0.
              APPEND VALUE #( msg_no = '006' msg_v1 = <ls_vehicle>-CargoUnit ) TO lt_errors.
            ENDIF.
          ENDIF.
          "Bus check
        WHEN 'BUS'.
          IF <ls_vehicle>-Pass <= 0 OR <ls_vehicle>-Pass NOT IN lr_pass.
            APPEND VALUE #( msg_no = '004' ) TO lt_errors.
          ENDIF.
          IF <ls_vehicle>-Cargo > 0.
            APPEND VALUE #( msg_no = '009' ) TO lt_errors.

          ENDIF.

      ENDCASE.
      "-------------------------------
      "Output all results
      IF lt_errors IS NOT INITIAL.
        APPEND VALUE #( %tky = <ls_vehicle>-%tky ) TO failed-vehicletype.
        LOOP AT lt_errors INTO DATA(ls_error).
          APPEND VALUE #( %tky = <ls_vehicle>-%tky
                          %state_area = 'VALIDATE_SPECS'
                          %msg = new_message( id = 'Z10CASENAKL'
                                              number = ls_error-msg_no
                                              severity = if_abap_behv_message=>severity-error
                                              v1 = ls_error-msg_v1 )
                          %element-Seats = COND #( WHEN ls_error-msg_no = '001' THEN if_abap_behv=>mk-on )
                          %element-cargo         = COND #( WHEN ls_error-msg_no = '002' OR ls_error-msg_no = '009' THEN if_abap_behv=>mk-on  )
                          %element-tankcap       = COND #( WHEN ls_error-msg_no = '008' OR ls_error-msg_no = '005' THEN if_abap_behv=>mk-on  )
                          %element-tankcapunit   = COND #( WHEN ls_error-msg_no = '003' THEN if_abap_behv=>mk-on )
                          %element-cargounit     = COND #( WHEN ls_error-msg_no = '006' THEN if_abap_behv=>mk-on )
                          %element-pass    = COND #( WHEN ls_error-msg_no = '004' OR ls_error-msg_no = '010' THEN if_abap_behv=>mk-on )
                          %element-vehiclekind   = COND #( WHEN ls_error-msg_no = '007'  THEN if_abap_behv=>mk-on )


                          ) TO reported-vehicletype.
        ENDLOOP.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
