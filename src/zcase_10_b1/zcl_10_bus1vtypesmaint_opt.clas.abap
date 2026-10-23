CLASS zcl_10_bus1vtypesmaint_opt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    CLASS-METHODS class_constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: mt_web_stream TYPE STANDARD TABLE OF z_r_10vehtype WITH  NON-UNIQUE DEFAULT KEY.

ENDCLASS.

CLASS zcl_10_bus1vtypesmaint_opt IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    TYPES: BEGIN OF ty_key,
             manufacturer TYPE z10_vehtype-manufacturer,
             model        TYPE z10_vehtype-model,
           END OF ty_key.
    DATA: lt_db_keys TYPE HASHED TABLE OF ty_key WITH UNIQUE KEY manufacturer model.
    DATA lt_create TYPE TABLE FOR CREATE z_r_10vehtype\\Vehicletype.
    DATA lt_update TYPE TABLE FOR UPDATE z_r_10vehtype\\Vehicletype.
    DATA ls_mod_failed    TYPE RESPONSE FOR FAILED EARLY z_r_10vehtype.
    DATA ls_mod_reported  TYPE RESPONSE FOR REPORTED EARLY z_r_10vehtype.
    DATA ls_cmt_failed    TYPE RESPONSE FOR FAILED LATE z_r_10vehtype.
    DATA ls_cmt_reported  TYPE RESPONSE FOR REPORTED LATE z_r_10vehtype.
    DATA lv_op_text TYPE  string .
    SELECT manufacturer, model FROM z10_vehtype INTO TABLE @lt_db_keys.
    LOOP AT mt_web_stream ASSIGNING FIELD-SYMBOL(<ls_stream>).
      CLEAR: ls_mod_failed, ls_mod_reported, ls_cmt_failed, ls_cmt_reported.
      IF line_exists( lt_db_keys[ manufacturer = <ls_stream>-manufacturer
                                  model        = <ls_stream>-model ] ).

        lv_op_text = 'Update'.
        lt_update  = VALUE #( ( CORRESPONDING #( <ls_stream> ) ) ).
        MODIFY ENTITIES OF z_r_10vehtype
            ENTITY Vehicletype
            UPDATE FIELDS ( ManuName VehicleKind Seats Cargo CargoUnit TankCap TankcapUnit Pass Tv Toilet )
            WITH lt_update
            FAILED ls_mod_failed
            REPORTED ls_mod_reported.

      ELSE.
        lv_op_text = 'Create'.
        lt_create = VALUE #( ( CORRESPONDING #( <ls_stream> ) ) ).
        lt_create[ 1 ]-%cid = 'CID_NEW_VEH'.
        MODIFY ENTITIES OF z_r_10vehtype
            ENTITY Vehicletype
            CREATE FIELDS ( manufacturer model ManuName VehicleKind Seats Cargo CargoUnit TankCap TankcapUnit Pass Tv Toilet )
            WITH lt_create
            FAILED ls_mod_failed
            REPORTED ls_mod_reported.

      ENDIF.

      IF ls_mod_failed IS NOT INITIAL.
        ROLLBACK ENTITIES.
        LOOP AT ls_mod_reported-vehicletype INTO DATA(ls_mod_rep) WHERE %msg IS BOUND.
          out->write( |Manufacturer/Model:{ <ls_stream>-manufacturer } / { <ls_stream>-model }| ).
          out->write( | Error: { ls_mod_rep-%msg->if_message~get_text( ) }| ).
        ENDLOOP.
        CONTINUE.

      ENDIF.
      COMMIT ENTITIES
         RESPONSE OF z_r_10vehtype
         FAILED ls_cmt_failed
         REPORTED ls_cmt_reported.
      IF ls_cmt_failed IS NOT INITIAL.
        ROLLBACK ENTITIES.

        LOOP AT ls_cmt_reported-vehicletype INTO DATA(ls_cmt_rep) WHERE %msg IS BOUND.

          out->write( |Manufacturer/Model:{ <ls_stream>-manufacturer } / { <ls_stream>-model }| ).
          out->write( | Error:  { ls_cmt_rep-%msg->if_message~get_text( ) }| ).


        ENDLOOP.
      ENDIF.


    ENDLOOP.
  ENDMETHOD.
  METHOD class_constructor.
    mt_web_stream = VALUE #(
    ( manufacturer = 'AUDI'  model = 'A3'        ManuName = 'Audi'                                       vehiclekind = 'CAR'        "0 Fehler
        seats = 5 cargo = 0 cargounit = space tankcap = 60 tankcapunit = 'L' pass = 0 tv = abap_false  toilet = abap_false )
      ( manufacturer = 'AUDI'  model = 'A6'        ManuName = 'Audi'                                       vehiclekind = 'CAR'        "1 Fehler
        seats = 5 cargo = 0 cargounit = space tankcap = 60 tankcapunit = 'LTR' pass = 0 tv = abap_false  toilet = abap_false )
      ( manufacturer = 'VW'    model = 'Passat 6'  ManuName = 'Volkswagen'                                 vehiclekind = 'CAR'        "2 Fehler
        seats = 5 cargo = 0 cargounit = space tankcap = 180 tankcapunit = 'LTR' pass = 0 tv = abap_false  toilet = abap_false )
      ( manufacturer = 'BMW'   model = 'X3'        ManuName = 'Bayrische Motorenwerke'                     vehiclekind = 'CAR'        "0 Fehler
        seats = 5 cargo = 0 cargounit = space tankcap = 80 tankcapunit = 'L' pass = 0 tv = abap_false  toilet = abap_false )
      ( manufacturer = 'MAN'   model = 'TX'        ManuName = 'Maschinenfabrik Augsburg-Nürnberg AG'       vehiclekind = 'TRUCK'      "0 Fehler
        seats = 3 cargo = 30000 cargounit = 'KG' tankcap = 300 tankcapunit = 'L' pass = 0 tv = abap_false  toilet = abap_true )
      ( manufacturer = 'VOLVO' model = 'XX'        ManuName = 'Volvo'                                      vehiclekind = 'TRUCK'      "1 Fehler
        seats = 3 cargo = 0 cargounit = 'KG' tankcap = 300 tankcapunit = 'L'  pass = 0 tv = abap_false  toilet = abap_false )
      ( manufacturer = 'SETRA' model = 'SE10'      ManuName = 'Daimler Truck'                              vehiclekind = 'BUS'        "0 Fehler
        seats = 1 cargo = 0 cargounit = space tankcap = 300 tankcapunit = 'L'  pass = 45 tv = abap_true  toilet = abap_true )
      ( manufacturer = 'LIEBHERR' model = '125 EC-B 6' ManuName = 'Liebherr-International Deutschland GmbH' vehiclekind = 'DEMO&TEST' "1 Fehler
        seats = 1 cargo = 0 cargounit = space tankcap = 300 tankcapunit = 'L'  pass = 0 tv = abap_false  toilet = abap_false )

     ).

  ENDMETHOD.

ENDCLASS.
