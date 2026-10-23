CLASS zcl_10_vehicletypes_maint DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_vehicletypes_maint IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
* Achtung!
*  - für die gewünschte Funktion dekommentieren Sie die entsprechende Deklaration der Konstanten lco_activity
*  - ersetzen Sie z##_vehtype durch den Bezeichner Ihrer DB-Tabelle


*    CONSTANTS: lco_activity   TYPE c LENGTH 10 VALUE 'DELETE'.  "Daten aus DB-Tabelle löschen
    CONSTANTS: lco_activity   TYPE c LENGTH 10 VALUE 'FILL'.    "Daten in DB-Tabelle erzeugen / aktualisieren

    DATA: lt_vehicletypes TYPE STANDARD TABLE OF z10_vehtype  "Zeilentyp = Bezeichner Ihrer DB-Tabelle!
                               WITH NON-UNIQUE DEFAULT KEY.
    IF lco_activity EQ 'DELETE'.
      DELETE FROM z10_vehtype.
      out->write( |Delete: SY-SUBRC = { sy-subrc } SY-DBCNT = { sy-dbcnt }| ).
      COMMIT WORK.
    ENDIF.

    IF lco_activity EQ 'FILL'.
      lt_vehicletypes = VALUE #(
( manufacturer = 'AUDI'  model = 'A3'        manu_name = 'Audi'                                 vehicle_kind = 'CAR'
  seats = 5 cargo = 0 cargo_unit = space tank_cap = 60 tankcap_unit = 'L' pass = 0 tv = abap_false  toilet = abap_false )
( manufacturer = 'VW'    model = 'Passat 6'  manu_name = 'Volkswagen'                           vehicle_kind = 'CAR'
  seats = 5 cargo = 0 cargo_unit = space tank_cap = 60 tankcap_unit = 'L' pass = 0 tv = abap_false  toilet = abap_false )
( manufacturer = 'MAN'   model = 'TX'        manu_name = 'Maschinenfabrik Augsburg-Nürnberg AG' vehicle_kind = 'TRUCK'
  seats = 3 cargo = 30000 cargo_unit = 'KG' tank_cap = 300 tankcap_unit = 'L' pass = 0 tv = abap_false  toilet = abap_true )
( manufacturer = 'SETRA' model = 'SE10'      manu_name = 'Daimler Truck'                        vehicle_kind = 'BUS'
  seats = 1 cargo = 0 cargo_unit = space tank_cap = 300 tankcap_unit = 'L'  pass = 45 tv = abap_true  toilet = abap_true )
                               ).
      GET TIME STAMP FIELD DATA(lv_timestamp).
      LOOP AT lt_vehicletypes ASSIGNING FIELD-SYMBOL(<ls_admin_stamp>).
        <ls_admin_stamp>-created_by      = sy-uname.
        <ls_admin_stamp>-created_at      = lv_timestamp.
        <ls_admin_stamp>-local_last_changed_by = sy-uname.
        <ls_admin_stamp>-local_last_changed_at = lv_timestamp.
        <ls_admin_stamp>-last_changed_at       = lv_timestamp.
      ENDLOOP.
      MODIFY z10_vehtype FROM TABLE @lt_vehicletypes.
      out->write( |Fill:   SY-SUBRC = { sy-subrc } SY-DBCNT = { sy-dbcnt }| ).
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
