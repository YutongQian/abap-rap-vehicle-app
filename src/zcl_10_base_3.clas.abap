CLASS zcl_10_base_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_base_3 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  DATA xxxx type t.
xxxx = |AB02dd|.
out->write( xxxx ).

*DATA(xxxx) = CONV #( '20230101' ).
*DATA(lo_typedescr) = cl_abap_typedescr=>describe_by_data( xxxx ).
*out->write( xxxx ).
*out->write( |Der Typ von xxxx ist: { lo_typedescr->type_kind }| ).
DATA: var_pack       TYPE  p LENGTH 3 DECIMALS 2.
        DATA: var_char       TYPE c LENGTH 3.
        DATA: var_date       TYPE d.
*var_pack = EXACT #( 1 / 8 ).
*        var_pack = EXACT #( 1 / 4 ).
*        var_char = EXACT #( |abcdefg| ).
*        var_date = EXACT #( '20221232' ).
*        var_char = EXACT string( 'AB12C3D456' ).
*out->write( var_char ).





  ENDMETHOD.
ENDCLASS.
