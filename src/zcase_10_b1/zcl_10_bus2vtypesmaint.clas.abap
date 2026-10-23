CLASS zcl_10_bus2vtypesmaint DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    CLASS-METHODS class_constructor.

    CLASS-DATA: mt_web_stream TYPE STANDARD TABLE OF z_r_10vehtype WITH  NON-UNIQUE DEFAULT KEY.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_bus2vtypesmaint IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TYPES: BEGIN OF ty_key,
             manufacturer TYPE z10_vehtype-manufacturer,
             model        TYPE z10_vehtype-model,
           END OF ty_key.
    DATA: lt_db_keys TYPE HASHED TABLE OF ty_key WITH UNIQUE KEY manufacturer model.
    DATA lt_create TYPE TABLE FOR CREATE z_r_10vehtype\\Vehicletype.
    DATA lt_update TYPE TABLE FOR UPDATE z_r_10vehtype\\Vehicletype.
    DATA lv_op_text TYPE  string .
    SELECT manufacturer, model FROM z10_vehtype INTO TABLE @lt_db_keys.

    LOOP AT mt_web_stream ASSIGNING FIELD-SYMBOL(<ls_stream>).
      IF line_exists( lt_db_keys[ manufacturer = <ls_stream>-manufacturer
                                   model        = <ls_stream>-model ] ).
        lv_op_text = 'Update'.
        lt_update  = VALUE #( ( CORRESPONDING #( <ls_stream> ) ) ).

        MODIFY ENTITIES OF z_r_10vehtype
            ENTITY Vehicletype
            UPDATE FIELDS ( ManuName VehicleKind Seats Cargo CargoUnit TankCap TankcapUnit Pass Tv Toilet ZZLiftCapmaxZCA
                            ZZLiftMaxUnitZCA ZZLiftCapminZCA ZZLiftMinUnitZCA ZZMaxHeightZCA ZZHeightUnitZCA ZZMaxRangeZCA ZZRangeUnitZCA )
            WITH lt_update
            FAILED DATA(ls_mod_failed)
            REPORTED DATA(ls_mod_reported).
      ELSE.
        lv_op_text = 'Create'.
        lt_create = VALUE #( ( CORRESPONDING #( <ls_stream> ) ) ).
        lt_create[ 1 ]-%cid = 'CID_NEW_VEH'.
        MODIFY ENTITIES OF z_r_10vehtype
            ENTITY Vehicletype
            CREATE FIELDS ( manufacturer model ManuName VehicleKind Seats Cargo CargoUnit TankCap TankcapUnit Pass Tv Toilet
            ZZLiftCapmaxZCA ZZLiftMaxUnitZCA ZZLiftCapminZCA ZZLiftMinUnitZCA ZZMaxHeightZCA ZZHeightUnitZCA ZZMaxRangeZCA ZZRangeUnitZCA )
            WITH lt_create
            FAILED ls_mod_failed
            REPORTED ls_mod_reported.

      ENDIF.
      DATA(lv_ok) = abap_false.
      IF ls_mod_failed IS INITIAL.
        COMMIT ENTITIES
            RESPONSE OF z_r_10vehtype
            FAILED DATA(ls_cmt_failed)
            REPORTED DATA(ls_cmt_reported).
        IF ls_cmt_failed IS INITIAL.
          lv_ok = abap_true.

        ENDIF.
      ENDIF.
      IF lv_ok = abap_true.
        out->write( |{ lv_op_text }-OK:{ <ls_stream>-manufacturer } / { <ls_stream>-model }| ).
      ELSE.
        ROLLBACK ENTITIES.
        out->write( |{ lv_op_text }-Fail:{ <ls_stream>-manufacturer } / { <ls_stream>-model }| ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
  METHOD class_constructor.
    mt_web_stream = VALUE #(
    ( manufacturer = 'AUDI'  model = 'A3'        ManuName = 'Audi'                                       vehiclekind = 'CAR'        "0 Fehler                 -
        seats = 5 cargo = 0 cargounit = space tankcap = 60 tankcapunit = 'L' pass = 0 tv = abap_false  toilet = abap_false
        zzliftcapmaxzca = 0 zzliftmaxunitzca = space zzliftcapminzca = 0 zzliftminunitzca = space
        zzmaxheightzca = 0 zzheightunitzca = space zzmaxrangezca = 0 zzrangeunitzca = space
      )
      ( manufacturer = 'AUDI'  model = 'A6'        ManuName = 'Audi'                                       vehiclekind = 'CAR'        "1 Fehler (tankcapunit)     x
        seats = 5 cargo = 0 cargounit = space tankcap = 60 tankcapunit = 'LTR' pass = 0 tv = abap_false  toilet = abap_false
        zzliftcapmaxzca = 0 zzliftmaxunitzca = space zzliftcapminzca = 0 zzliftminunitzca = space
        zzmaxheightzca = 0 zzheightunitzca = space zzmaxrangezca = 0 zzrangeunitzca = space
      )
      ( manufacturer = 'VW'    model = 'Passat 6'  ManuName = 'Volkswagen'                                 vehiclekind = 'CAR'        "2 Fehler (tankcapunit, tankcap)    -
        seats = 5 cargo = 0 cargounit = space tankcap = 180 tankcapunit = 'LTR' pass = 0 tv = abap_false  toilet = abap_false
        zzliftcapmaxzca = 0 zzliftmaxunitzca = space zzliftcapminzca = 0 zzliftminunitzca = space
        zzmaxheightzca = 0 zzheightunitzca = space zzmaxrangezca = 0 zzrangeunitzca = space
      )
      ( manufacturer = 'BMW'   model = 'X3'        ManuName = 'Bayrische Motorenwerke'                     vehiclekind = 'CAR'        "0 Fehler               x
        seats = 5 cargo = 0 cargounit = space tankcap = 80 tankcapunit = 'L' pass = 0 tv = abap_false  toilet = abap_false
        zzliftcapmaxzca = 0 zzliftmaxunitzca = space zzliftcapminzca = 0 zzliftminunitzca = space
        zzmaxheightzca = 0 zzheightunitzca = space zzmaxrangezca = 0 zzrangeunitzca = space
      )
      ( manufacturer = 'MAN'   model = 'TX'        ManuName = 'Maschinenfabrik Augsburg-Nürnberg AG'       vehiclekind = 'TRUCK'      "0 Fehler               -
        seats = 3 cargo = 30000 cargounit = 'KG' tankcap = 300 tankcapunit = 'L' pass = 0 tv = abap_false  toilet = abap_true
        zzliftcapmaxzca = 0 zzliftmaxunitzca = space zzliftcapminzca = 0 zzliftminunitzca = space
        zzmaxheightzca = 0 zzheightunitzca = space zzmaxrangezca = 0 zzrangeunitzca = space
      )
      ( manufacturer = 'VOLVO' model = 'XX'        ManuName = 'Volvo'                                      vehiclekind = 'TRUCK'      "1 Fehler (cargo)           x
        seats = 3 cargo = 0 cargounit = 'KG' tankcap = 300 tankcapunit = 'L'  pass = 0 tv = abap_false  toilet = abap_false
        zzliftcapmaxzca = 0 zzliftmaxunitzca = space zzliftcapminzca = 0 zzliftminunitzca = space
        zzmaxheightzca = 0 zzheightunitzca = space zzmaxrangezca = 0 zzrangeunitzca = space
      )
      ( manufacturer = 'SETRA' model = 'SE10'      ManuName = 'Daimler Truck'                              vehiclekind = 'BUS'        "0 Fehler               -
        seats = 1 cargo = 0 cargounit = space tankcap = 300 tankcapunit = 'L'  pass = 45 tv = abap_true  toilet = abap_true
        zzliftcapmaxzca = 0 zzliftmaxunitzca = space zzliftcapminzca = 0 zzliftminunitzca = space
        zzmaxheightzca = 0 zzheightunitzca = space zzmaxrangezca = 0 zzrangeunitzca = space
      )
      ( manufacturer = 'LIEBFRAU' model = '125 EC-B 6' ManuName = 'Liebherr-International Deutschland GmbH' vehiclekind = 'TCRANE'    "4 Fehler (...)     x
        seats = 1 cargo = 0 cargounit = space tankcap = 300 tankcapunit = 'L'  pass = 0 tv = abap_false  toilet = abap_false
        zzliftcapmaxzca = 0 zzliftmaxunitzca = 'KGR' zzliftcapminzca = 1600 zzliftminunitzca = 'KG'
        zzmaxheightzca = -59 zzheightunitzca = 'MTR' zzmaxrangezca = 45 zzrangeunitzca = 'M'
      )
      ( manufacturer = 'LIEBHERR' model = '125 EC-B 6' ManuName = 'Liebherr-International Deutschland GmbH' vehiclekind = 'TCRANE'    "0 Fehler       x
        seats = 1 cargo = 0 cargounit = space tankcap = 300 tankcapunit = 'L'  pass = 0 tv = abap_false  toilet = abap_false
        zzliftcapmaxzca = 6000 zzliftmaxunitzca = 'KG' zzliftcapminzca = 1600 zzliftminunitzca = 'KG'
        zzmaxheightzca = 59 zzheightunitzca = 'M' zzmaxrangezca = 45 zzrangeunitzca = 'M'
      )

     ).

  ENDMETHOD.

ENDCLASS.
