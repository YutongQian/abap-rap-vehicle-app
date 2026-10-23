CLASS zcl_10_base_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    CLASS-METHODS: replace_placeholder IMPORTING VALUE(lv_input)        TYPE string
                                                 VALUE(lV_id)           TYPE /dmo/carrier_id
                                                 VALUE(lV_connection)   TYPE /dmo/connection_id
                                                 VALUE(lV_currencycode) TYPE /dmo/currency_code
                                                 VALUE(lV_price_avg)    TYPE p
                                       RETURNING VALUE(lv_output)       TYPE String.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_base_2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    out->write( |Projekt 2| ).
    out->write( | Teilnehmer: { cl_abap_context_info=>get_user_alias(  ) }| ).
    out->write( | Datum:      { cl_abap_context_info=>get_system_date(  ) DATE = USER }| ).
    out->write( | | ).
* Aufgabe 1:
* Im unten aufgeführten Coding ersetzen Sie die move-corresponding Anweisung - verwenden Sie hierfür den
* corresponding - Konstruktoroperator, so daß das gleiche Ergebnis erziehlt wird!
    DATA:
      BEGIN OF gs_src,
        a TYPE i VALUE 1,
        b TYPE i VALUE 2,
      END OF gs_src,
      BEGIN OF gs_target1,
        b TYPE i VALUE 11,
        c TYPE i VALUE 12,
        d TYPE i VALUE 13,
      END OF gs_target1,
      gs_target2 LIKE gs_target1.
    gs_target2 = gs_target1.
    MOVE-CORRESPONDING gs_src TO gs_target2.
    out->write( |Aufgabe 1: ------------------------------------------------------------------------| ).
    out->write( |- Ergebnis nach MOVE-CORRESPONDING| ).
    out->write( gs_target2 ).
* Implementieren Sie hier das geforderte Coding

    gs_target2 = CORRESPONDING #( BASE ( gs_target2 ) gs_src ).
    out->write( |- Ergebnis nach CORRESPONDING| ).
    out->write( gs_target2 ).
* Aufgabe 2:
* Verwenden Sie die folgende Zeichenfolge: ABAPabapABAP   bei den Aufgaben.
*  a) Ermitteln Sie die Position des ersten Vorkommens von B
*  b) Untersuchen Sie die Zeichenfolge, ob das vierte bis achte Zeichen dem Zeichen A entspricht!
*  c) Untersuchen Sie die Zeichenfolge, an welcher Position (beginnend von links) das Zeichen a zu finden ist1
*  d) Untersuchen Sie die Zeichenfolge, ob eines der Zeichen A oder B in der Zeichenfolge vorkommt
*  e) Ermitteln Sie das zweite Vorkommen des Zeichens A von rechts beginnend.
*  f) Ermitteln Sie, wie häufig die Zeichenfolge  BA  vorkommt!
*  g) Ermitteln Sie, wieviele Zeichen vorkommen, die nicht das Zeichen A oder B sind!
    DATA result TYPE string.
    out->write( | | ).
    out->write( |Aufgabe 2: ------------------------------------------------------------------------| ).
* Implementieren Sie hier das geforderte Coding
* Verwenden Sie hierfür folgende Vorlage:
* result = <hier der geforderte Ausdruck>.      out->write( |a) { result }| ).
    DATA(lv_text) = `ABAPabapABAP`.
    result = find( val = lv_text sub = 'B' occ = 1 ).out->write( |a) { result }| ).
    result = find( val = lv_text sub = 'A' off = 3 len = 5 ).out->write( |b) { result }| ).
    result = find( val = lv_text sub = 'a' occ = 1 case = abap_true ).   out->write( |c) { result }| ).
    result = find_any_of( val = lv_text sub = 'AB'  ).   out->write( |d) { result }| ).
    result = find( val = lv_text sub = 'A' occ = -2 case = abap_true ). .   out->write( |e) { result }| ).
    result = count( val = lv_text sub = 'BA' case = abap_true ) .   out->write( |f) { result }| ).
    result = count_any_not_of( val = lv_text sub = 'AB' ).   out->write( |g) { result }| ).
* Aufgabe 3:
* Erstellen Sie dieser Klasse eine Methode  replace_placeholder   entsprechend folgender Vorgaben:
*  - Die Methode soll alle Platzhalter (z.B. in der Form &abc&), die in einer Zeichenfolge enthalten sind,
*    durch Surrogatwerte ersetzen.
*  - Definieren Sie die Methode als statische Methode
*  - Beim Aufruf der Methode soll eine Zeichenfolge übergeben werden. Die Zeichenfolge
*     - soll hierbei beliebig viele Platzhalter enthalten können und
*     - die Platzhalter sollen beliebig definiert sein können
*       (Hinweis: - der Methode muss hierfür also immer die Definitionsform des Platzhalters und der Surrogatwert
*                   für jeden vorkommenden Platzhalter übergeben werden! )
*  - Die Methode soll als funktionale Methode definiert werden, die im Ergebnis eine Zeichenfolge liefert.
* Als Zeichenfolge mit Platzhaltern soll folgende Verwendung finden:
*  - 'Average price of all flights of connection &1 &2 amounts to &3 &4'
*  - &1 = ID der Airline; &2 = ID der Verbindung; &3 = Durchschnittspreis;  &3 = Währungseinheit
*  - Beispiel-Ergebnis:  Average price of all flights of connection AA 0015 amounts to 2514.00  USD.
    DATA: lt_outstring  TYPE TABLE OF string.
    DATA: text_with_placehoders TYPE string.
    out->write( | | ).
    out->write( |Aufgabe 3: ------------------------------------------------------------------------| )."
    text_with_placehoders = 'Average price of all flights of connection &1 &2 amounts to &3 &4.'.

* Ein paar Beispieldatensätze aus der DB passend für die Aufgabe
    SELECT FROM /dmo/flight
    FIELDS carrier_id AS carrier, connection_id AS connection, currency_code AS currcode,
                                   CAST( AVG( price AS FLTP ) AS DEC( 7,2 ) ) AS price_avg
           WHERE carrier_id IN ( 'AA', 'LH' )
           GROUP BY carrier_id, connection_id, currency_code
           ORDER BY carrier, connection
           INTO TABLE @DATA(it_Price_avg).
    LOOP AT it_price_avg INTO DATA(line_avgprice).
*      Implementieren Sie hier das geforderte Coding
*       1. Bereitstellen der PlatzhalterID - Surrogatwert Wertepaare für jeden Platzhalter

*       2. Aufruf der Methode replace_placeholder( ) und Ausgabe des Strings in der Konsole
      DATA(lv_result_text) = zcl_10_base_2=>replace_placeholder(
                             lv_input = text_with_placehoders
                             lv_id = line_avgprice-carrier
                             lv_connection = line_avgprice-connection
                             lv_currencycode = line_avgprice-currcode
                             lv_price_avg = line_avgprice-price_avg
                                              ).
      out->write( lv_result_text ).
    ENDLOOP.
* Aufgabe 4: -------------------------------------------------------------------------------------------
* Sie möchten den Durchschnittswert der Werte der Variablen gv_val1 (Wert: nnnn) und gv_val2 (Wert: mmmm) berechnen
* und das Ergebnis xxxx als Zeichenfolge wie folgt ausgeben:      Durchschnittsbetrag von nnnn und mmmm ist gleich: xxx EUR
* Hierbei soll folgendes gelten:
*  - Die Ausgabe erfolgt mittels  out->write(  eeee  ) erfolgen, wobei eeee als Zeichenkettentemplate realisiert werden soll.
*  - Die Variablen sollen von Typ P(8,4) sein.
*  - Aus Gründen der Lesbarkeit / Übersichtlichkeit oder technischer Umstände könnte es zweckmäßig oder notwendig sein,
*    eeee über mehrere Quelltextzeilen zu verteilen.
*  - Alle numerischen Werte sollen so formatiert ausgegeben werden, das die Einstellungen des Benutzer im Benutzerstamm
*    berücksichtigt werden und ein Vorzeichen (+ oder -) immer rechts vom Wert ausgegeben wird.
    DATA: gv_val1 TYPE p LENGTH 8 DECIMALS 2 VALUE '12345.50',
          gv_val2 TYPE p LENGTH 8 DECIMALS 2 VALUE '54321.50'.
    out->write( | | ).
    out->write( |Aufgabe 4: ------------------------------------------------------------------------| ).
* Implementieren Sie hier das geforderte Coding
    DATA gv_avg TYPE p LENGTH 8 DECIMALS 4.
    gv_avg = ( gv_val1 + gv_val2 ) / 2.
    out->write( | Durchschnittsbetrag von { gv_val1 NUMBER = USER SIGN = RIGHTPLUS } und { gv_val2 NUMBER = USER SIGN = RIGHTPLUS } ist gleich: { gv_avg NUMBER = USER SIGN = RIGHTPLUS } EUR | ).
* Aufgabe 5:
* Mittels einer gegebenen SELECT-Anweisung werden Flugdatensätze per Array-Fetch abgerufen.
* Je Fluggesellschaft sollen für die zugehörigen Flüge die Anzahl der Flüge, die Gesamtanzahl der beförderten Passagiere,
* die Summe aller Einnahmen und der Durchschnittspreis ermittelt werden.
* Implementieren Sie die Forderungen entsprechend folgender Vorgaben:
*   Variante I
*   - Lösen Sie das Probem mittels ABAP SQL (Anm.: dient der Verifikation Ihrer Lösung von Variante II)
*   Variante II
*   - Verarbeiten Sie die Daten der gegebenen internen Tabelle lt_flights!
*   - Geben Sie die verdichtete Ergebnismenge (sortiert nach Fluggesellschaft) in der Konsole aus!
*   - Vermeiden Sie unnötigen Kopieraufwand für das Laufzeitsystem bei der Verarbeitung der Datenmenge in lt_flights!
* Tipps:
*   - für die Lösung der Aufgabe sind die Anweisungen  TYPES..., DATA ..., SORT...,  DELETE ADJACENT DUPLICATES und
*     die Konstruktoroperatoren VALUE..., REDUCE..., COND evtl. nützlich (bzw. notwendig).
*   - Zur Verifikation Ihrer Lösung, können Sie Konsolenausgabe der mittels ABAP SQL realisierte Lösung verwenden
* Beispiel der Konsolenausgabe für Variante I:
*   Ergebnis Variante I (ABAP SQL)
*   AIRLINE     FLIGHTS_TOTAL  PASSENGER_TOTAL  PRICE_TOTAL  PRICE_AVG  CURRENCY_CODE
*   AA          10             1794             17232.0      1723.2     USD
*   LH          8              1844             30123.0      3765.38    EUR
    SELECT FROM /dmo/flight FIELDS * WHERE carrier_id IN ( 'AA', 'LH' ) INTO TABLE @DATA(lt_flights).
    out->write( | | ).
    out->write( |Aufgabe 5: ------------------------------------------------------------------------| ).
* Implementieren Sie hier das geforderte Coding
* Variante I
    SELECT FROM /dmo/flight
      FIELDS carrier_id AS  airline,
             COUNT(*) AS flights_total,
             SUM( seats_occupied ) AS passenger_total,
             SUM( price ) AS price_total,
             CAST( AVG( price ) AS CURR( 15,2 ) )  AS price_avg,
             currency_code
       WHERE carrier_id IN ( 'AA', 'LH' )
       GROUP BY carrier_id,currency_code
       ORDER BY carrier_id ASCENDING
     INTO TABLE @DATA(lt_result_v1).
    out->write( |Ergebnis Variante I (ABAP SQL)| ).
    out->write( lt_result_v1 ).            "Dekommentieren Sie diese Anweisung!
    out->write( | | ).
*Variante II
    out->write( |Ergebnis Variante II (Internal Table)| ).
    TYPES: BEGIN OF t_result,
             airline         TYPE /dmo/carrier_id,
             flights_total   TYPE i,
             passenger_total TYPE i,
             price_total     TYPE  /dmo/flight_price,
             price_avg       TYPE /dmo/flight_price,
             currency_code   TYPE /dmo/currency_code,
           END OF t_result.
    TYPES tt_result TYPE STANDARD TABLE OF t_result WITH EMPTY KEY.
    DATA lt_result_v2 TYPE tt_result.
    lt_result_v2 = REDUCE tt_result(
      INIT lt_res TYPE tt_result
      FOR GROUPS ls_group OF <line> IN lt_flights
      GROUP BY (
        airline  = <line>-carrier_id
        currency = <line>-currency_code
      )
      ASCENDING
      NEXT lt_res = VALUE #(
        BASE lt_res
        (
          airline       = ls_group-airline
          currency_code = ls_group-currency
          flights_total = REDUCE i(
            INIT c = 0
            FOR <m> IN GROUP ls_group
            NEXT c = c + 1
          )
          passenger_total = REDUCE i(
            INIT p = 0
            FOR <m> IN GROUP ls_group
            NEXT p = p + <m>-seats_occupied
          )
          price_total = REDUCE /dmo/flight_price(
            INIT p = 0
            FOR <m> IN GROUP ls_group
            NEXT p = p + <m>-price
          )
          price_avg = REDUCE /dmo/flight_price(
            INIT p = 0
            FOR <m> IN GROUP ls_group
            NEXT p = p + <m>-price
          )
            /
            REDUCE i(
              INIT c = 0
              FOR <m> IN GROUP ls_group
              NEXT c = c + 1
            )
        )
      )
    ).

    out->write( lt_result_v2 ).            "Dekommentieren Sie diese Anweisung!
    out->write( | | ).
* Aufgabe 6:
* Gefordert: Liste von Flugverbindungen ab Flughafen 'SFO'
*            Die Liste sollte
*              - alle Direktflüge vom Flughafen sowie
*              - alle Ziele enthalten, die mit nur einem Zwischenstopp erreicht werden können (es soll hier
*                durchgängig mit der gleichen Fluggesellschaft geflogen werden) !
*                Rückflüge (also von  SFO -> NRT -> SFO) zählen nicht .
*            Geben Sie die ermittelten Flugverbindungen, wie unten dargestellt in der Konsole aus!
* Bei den gegebenen (standardmäßigen) Daten in der DB-Tabelle /dmo/connection sollte das Ergebnis wie folgt
* aussehen:
*  CARRIER_ID  AIRPORT_FROM_ID  AIRPORT_TO_ID  AIRPORT_VIA_ID
*  AA          SFO              JFK            -
*  SQ          SFO              SIN            -
*  SQ          SFO              NRT            SIN
*  UA          SFO              FRA            -
* Überprüfen Sie aber dennoch Ihr Ergebnis z.B. für die Fluggesellschaft SQ auf Plausibilität anhand der
* Daten, die in der genannten DB-Tabelle vorhanden sind!

* Implementieren Sie ab hier das geforderte Coding

    SELECT FROM /dmo/connection AS f1
      FIELDS
        f1~carrier_id,
        f1~airport_from_id,
        f1~airport_to_id,
        CAST( '-' AS CHAR( 3 ) ) AS airport_via_id
      WHERE f1~airport_from_id = 'SFO'

    UNION

    SELECT FROM /dmo/connection AS f1
      INNER JOIN /dmo/connection AS f2
        ON  f1~airport_to_id = f2~airport_from_id
        AND f1~carrier_id    = f2~carrier_id
      FIELDS
        f1~carrier_id,
        f1~airport_from_id,
        f2~airport_to_id,
        f1~airport_to_id AS airport_via_id
      WHERE f1~airport_from_id = 'SFO'
      AND f1~airport_to_id <> f2~airport_to_id
      AND f2~airport_to_id <> f1~airport_from_id
      ORDER BY carrier_id, airport_via_id, airport_to_id
    INTO TABLE @DATA(lt_result_connection).
    out->write( |Aufgabe 6: ------------------------------------------------------------------------| ).
    out->write( lt_result_connection ).

* Aufgabe 7: --------------------------------------------------------------------------------------------------------
* Dokumentation Ihrer Arbeit
*  - Speichern Sie den Quelltext in einer Notepad-Textdatei zcl_##_Base_2_Source.txt
*  - Speichern Sie die Konsolenausgabe des Programmes in einer Notepad-Textdatei zcl_##_Base_2_consoleoutput.txt


  ENDMETHOD.


  METHOD replace_placeholder.

    lv_output = lv_input.
    DATA lt_input TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    lt_input = VALUE #(
    ( |{ lv_id }| )
    ( |{ lv_connection }| )
    ( |{ lV_price_avg }| )
    ( |{ lv_currencycode }| )
                   ).
    LOOP AT lt_input INTO DATA(ls_value).
      DATA(lv_placeholder) = |&{ sy-tabix }|.
      lv_output = replace( val = lv_output
                         sub = lv_placeholder
                         with = ls_value ).
    ENDLOOP.



  ENDMETHOD.

ENDCLASS.
