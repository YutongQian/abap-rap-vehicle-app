CLASS lhc_Vehicletype DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS ZZcheck_ext_specifications FOR VALIDATE ON SAVE
       keys FOR Vehicletype~ZZcheck_ext_specifications.

ENDCLASS.

CLASS lhc_Vehicletype IMPLEMENTATION.

  METHOD ZZcheck_ext_specifications.
     CONSTANTS lc_state_area TYPE string VALUE 'VALIDATE_EXT_SPECS'.
  READ ENTITIES OF z_r_10vehtype IN LOCAL MODE
  ENTITY Vehicletype
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_vehicles).
    TYPES: BEGIN OF ty_error,
             msg_no TYPE symsgno,
             msg_v1 TYPE symsgv,
             msg_v2 TYPE symsgv,
           END OF ty_error.
     DATA lt_errors TYPE STANDARD TABLE OF ty_error WITH EMPTY KEY.
   DATA: lv_capmax_chk TYPE abap_boolean,

          lv_capmin_chk    TYPE abap_boolean,
          lv_height_chk TYPE abap_boolean,
          lv_range_chk TYPE abap_boolean.
   LOOP AT lt_vehicles ASSIGNING FIELD-SYMBOL(<ls_vehicle>) .
    APPEND VALUE #( %tky        = <ls_vehicle>-%tky
                      %state_area = lc_state_area ) TO reported-vehicletype.
   CHECK <ls_vehicle>-VehicleKind = 'TCRANE'.
    CLEAR lt_errors.
"Value check
*    IF <ls_vehicle>-ZZLiftCapmaxZCA < <ls_vehicle>-ZZLiftCapminZCA.
*        APPEND VALUE #( msg_no = '001' ) TO lt_errors.
*      ENDIF.
    IF <ls_vehicle>-ZZLiftCapmaxZCA < 1.
        APPEND VALUE #( msg_no = '002' ) TO lt_errors.
      ENDIF.
    IF <ls_vehicle>-ZZLiftCapminZCA < 1.
       APPEND VALUE #( msg_no = '004' ) TO lt_errors.
    ENDIF.
    IF <ls_vehicle>-ZZMaxHeightZCA < 1.
       APPEND VALUE #( msg_no = '007' ) TO lt_errors.
    ENDIF.
   IF <ls_vehicle>-ZZMaxRangeZCA < 1.
      APPEND VALUE #( msg_no = '008' ) TO lt_errors.
    ENDIF.
"Unit check
"---------------------------------
DATA: lv_max_unit TYPE msehi,
      lv_min_unit TYPE msehi.
"Max. lift unit check
CLEAR lv_max_unit.
    SELECT SINGLE UnitOfMeasure FROM I_UnitOfMeasure WITH PRIVILEGED ACCESS
                      WHERE  UnitOfMeasure     = @<ls_vehicle>-ZZLiftMaxUnitZCA

                      AND UnitOfMeasureDimension = 'MASS'
                      INTO @lv_max_unit.
        IF sy-subrc <> 0.
              APPEND VALUE #( msg_no = '003' msg_v1 = <ls_vehicle>-ZZLiftMaxUnitZCA ) TO lt_errors.

        ENDIF.
"Min. lift unit check
        clear lv_min_unit.

            SELECT SINGLE UnitOfMeasure FROM I_UnitOfMeasure WITH PRIVILEGED ACCESS
                      WHERE  UnitOfMeasure     = @<ls_vehicle>-ZZLiftMinUnitZCA

                      AND UnitOfMeasureDimension = 'MASS'
                      INTO @lv_capmin_chk.

                    IF sy-subrc <> 0.
                       APPEND VALUE #( msg_no = '005' msg_v1 = <ls_vehicle>-ZZLiftMinUnitZCA ) TO lt_errors.
                        ENDIF.
"Max lift unit and min lift unit should be the same unit
 IF lv_max_unit IS NOT INITIAL
   AND lv_min_unit IS NOT INITIAL
   AND lv_max_unit <> lv_min_unit.
  APPEND VALUE #( msg_no = '010'
                  msg_v1 = <ls_vehicle>-ZZLiftMaxUnitZCA
                  msg_v2 = <ls_vehicle>-ZZLiftMinUnitZCA ) TO lt_errors.
ENDIF.
    IF <ls_vehicle>-ZZLiftCapmaxZCA < <ls_vehicle>-ZZLiftCapminZCA.
        APPEND VALUE #( msg_no = '001' ) TO lt_errors.
      ENDIF.
"Height unit Check
clear lv_height_chk.

            SELECT SINGLE @abap_true FROM I_UnitOfMeasure WITH PRIVILEGED ACCESS
                      WHERE ( UnitOfMeasure = @<ls_vehicle>-ZZHeightUnitZCA
                      OR UnitOfMeasureISOCode = @<ls_vehicle>-ZZHeightUnitZCA )
                      AND UnitOfMeasureDimension = 'LENGTH'
                      INTO @lv_height_chk.


           IF sy-subrc <> 0.
                 APPEND VALUE #( msg_no = '006' msg_v1 = <ls_vehicle>-ZZHeightUnitZCA ) TO lt_errors.

           ENDIF.
"Range Unit check
       clear lv_range_chk.
            SELECT SINGLE @abap_true FROM I_UnitOfMeasure WITH PRIVILEGED ACCESS
                      WHERE (   UnitOfMeasure = @<ls_vehicle>-ZZRangeUnitZCA
                      OR UnitOfMeasureISOCode = @<ls_vehicle>-ZZRangeUnitZCA )
                      AND UnitOfMeasureDimension = 'LENGTH'
                      INTO @lv_range_chk.

       IF sy-subrc <> 0.
            APPEND VALUE #( msg_no = '009' msg_v1 = <ls_vehicle>-ZZRangeUnitZCA ) TO lt_errors.
        ENDIF.

"---------------------------------
"output result
"----------------------------------
  if lt_errors is NOT INITIAL.
    APPEND VALUE #( %tky = <ls_vehicle>-%tky ) TO failed-vehicletype.
     LOOP AT lt_errors INTO DATA(ls_error).
    APPEND VALUE #( %tky = <ls_vehicle>-%tky
                    %state_area = lc_state_area
                    %msg = new_message( id = 'Z10CUS_CASENAKL'
                                        number = ls_error-msg_no
                                        severity = if_abap_behv_message=>severity-error
                                        v1 = ls_error-msg_v1
                                        v2 = ls_error-msg_v2 )
                    %element-ZZLiftCapmaxZCA = COND #( WHEN ls_error-msg_no = '001' or ls_error-msg_no = '002' then if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %element-ZZLiftCapminZCA = COND #( WHEN ls_error-msg_no = '001' or ls_error-msg_no = '004' THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %element-ZZMaxHeightZCA      = COND #( WHEN ls_error-msg_no = '007'  THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %element-ZZMaxRangeZCA   = COND #( WHEN ls_error-msg_no = '008' THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %element-ZZLiftMaxUnitZCA     = COND #( WHEN ls_error-msg_no = '003' OR ls_error-msg_no = '010' THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %element-ZZLiftMinUnitZCA    = COND #( WHEN ls_error-msg_no = '005' OR ls_error-msg_no = '010' THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %element-ZZHeightUnitZCA   = COND #( WHEN ls_error-msg_no = '006'  THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                    %element-ZZRangeUnitZCA   = COND #( WHEN ls_error-msg_no = '009'  THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )

                    ) to reported-vehicletype.
ENDLOOP.
   ENDIF.




   ENDLOOP.

  ENDMETHOD.

ENDCLASS.
