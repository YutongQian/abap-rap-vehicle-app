CLASS zcl_10_base_5 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.


    CLASS-METHODS:
      "! <p class="shorttext synchronized" >Calculates the power of a number (base^exponent)</p>
      "! Universal high-precision power function optimized for business and financial arithmetic.
      "! Implements demand-driven arithmetic where the sum is only aggregated if requested by the caller.
      "! @parameter i_base | Input base of any numeric data type (e.g., INT, PACKED, FLOAT)
      "! @parameter i_exp | Input exponent, limited strictly to Integer values
      "! @parameter rv_result | Returning 34-digit high-precision calculation result
      "! @raising   cx_sy_arithmetic_error | Propagates any mathematical/arithmetic exception to the caller
      power IMPORTING i_base           TYPE numeric
                      i_exp            TYPE i
            RETURNING VALUE(rv_result) TYPE decfloat34
            RAISING   cx_sy_arithmetic_error,
      "! <p class="shorttext synchronized" > Generates Fibonacci sequence and optional sum</p>
      "! Calculates the Fibonacci sequence up to a specified number of elements.
      "! @parameter iv_anzahl | [Input] The number of Fibonacci elements to generate (must be >= 0)
      "! @parameter ev_sum | [Output/Optional] The aggregated sum of all generated numbers (accepts any numeric type)
      "! @parameter rv_result | [Returning] Space-separated string representation of the generated sequence
      "! @raising CX_ABAP_INVALID_VALUE | Thrown if iv_anzahl is invalid (e.g., negative)
      fibonacci IMPORTING iv_anzahl        TYPE i
                EXPORTING ev_sum           TYPE numeric
                RETURNING VALUE(rv_result) TYPE string
                RAISING   cx_abap_invalid_value.
ENDCLASS.



CLASS zcl_10_base_5 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 1 -------------------------------------------------------| ).
* Erstellen Sie einen ABAP SQL Join, und geben Sie die Ergebnismenge in der Console aus.
* Die Ergebnismenge soll in der internen Tabelle lt_result_a1 gespeichert werden.
* Die geforderte Ergebnismenge ist:
*AIRLINE                 CONNECTION  AIRPORTFROM                            AIRPORTTO                              CURRENCY_CODE
*American Airlines Inc.  0322        Miami International Airport            Newark Liberty International Airport   USD
*American Airlines Inc.  0017        Miami International Airport            José Martí International Airport       USD
*American Airlines Inc.  2678        José Martí International Airport       Miami International Airport            USD
*American Airlines Inc.  0015        John F. Kennedy International Airport  San Francisco International Airport    USD
*American Airlines Inc.  0018        San Francisco International Airport    John F. Kennedy International Airport  USD
* Datenbanktabellen sind: /dmo/carrier, /dmo/connection und /dmo/airport
    SELECT FROM ( (  /dmo/connection AS c
                    LEFT OUTER JOIN /dmo/carrier AS a
                    ON c~carrier_id = a~carrier_id )
                    LEFT OUTER JOIN /dmo/airport AS ap
                    ON c~airport_from_id = ap~airport_id )
                    LEFT OUTER JOIN /dmo/airport AS apo
                    ON c~airport_to_id = apo~airport_id
               FIELDS a~name AS airline,
                      c~connection_id AS connection,
                      ap~name AS airportfrom,
                      apo~name AS airportto,
                      a~currency_code AS currency_code
               WHERE c~carrier_id = 'AA'
               INTO TABLE @DATA(lt_result_a1) .

    out->write( lt_result_a1 ).

***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 2 -------------------------------------------------------| ).
* Ausgehend von unten gegebenen Coding (keine Änderungen vornehmen!) sorgen Sie dafür, das in der
* Konsole folgendes Ergebnis ausgegeben wird:
*CARRIER_ID  CONNECTION_ID  AIRPORT_FROM_ID  AIRPORT_TO_ID  NAME
*AA          0322           MIA              EWR            American Airlines Inc.
*AA          0017           MIA              HAV            American Airlines Inc.
*AA          2678           HAV              MIA            American Airlines Inc.
*AA          0015           JFK              SFO            American Airlines Inc.
*AA          0018           SFO              JFK            American Airlines Inc.
*LH          0400           FRA              JFK            Deutsche Lufthansa AG
*LH          0401           JFK              FRA            Deutsche Lufthansa AG
*LH          0402           FRA              EWR            Deutsche Lufthansa AG
*LH          0403           EWR              FRA            Deutsche Lufthansa AG
* Vorgegebenes Coding - Anfang --------------------------------------------------------------------------------------------
    TYPES: BEGIN OF ltys_connection_a2,
             carrier_id      TYPE /dmo/carrier_id,
             connection_id   TYPE /dmo/connection_id,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             name            TYPE /dmo/carrier_name,
           END OF   ltys_connection_a2.
    TYPES ltty_carriers_a2  TYPE STANDARD TABLE OF /dmo/carrier WITH NON-UNIQUE DEFAULT KEY.
    TYPES ltty_conections_a2 TYPE STANDARD TABLE OF ltys_connection_a2 WITH NON-UNIQUE DEFAULT KEY.
    DATA: lt_carriers_a2 TYPE ltty_carriers_a2.
    DATA: lt_connections_a2 TYPE ltty_conections_a2.
    SELECT  FROM /dmo/carrier  FIELDS *  WHERE carrier_id IN ('AA', 'LH') INTO TABLE @lt_carriers_a2 .
    SELECT  FROM /dmo/connection FIELDS * WHERE carrier_id IN ('AA', 'LH') INTO CORRESPONDING FIELDS OF TABLE @lt_connections_a2 .
* Vorgegebenes Coding - Ende ------------------------------------------------------------------------------------------------
    out->write( |Case: Base_5 Aufgabe 2.a :| ).
* a) Implementieren Sie ab hier Ihre Lösung mittels einer LOOP-Schleife. Beachten Sie, das unnötige Kopieroperationen
*    für das Laufzeitsystem zu vermeiden sind!
    FIELD-SYMBOLS <connection> LIKE LINE OF lt_connections_a2.
    LOOP AT lt_connections_a2 ASSIGNING <connection>.         "<- vervollständigen Sie die Loop-Schleife
      READ TABLE lt_carriers_a2 WITH KEY carrier_id = <connection>-carrier_id ASSIGNING FIELD-SYMBOL(<fs_carrier>).                            "<- Achtung, hier ist nur genau eine Anweisung notwendig!
      IF sy-subrc = 0.
        <connection>-name = <fs_carrier>-name.
      ENDIF.

    ENDLOOP.
    out->write( lt_connections_a2  ).


* b) Implementieren Sie ab hier Ihre Lösung ohne Loop-Schleife und geben Sie das Ergebnis sofort auf
*    der Konsole aus (m.a.W., die Lösung soll eine einzige Anweisung umfassen - vervollständigen Sie also
*    die unten stehende Ausgabeanweisung)!
*    Beachten Sie auch hier, das unnötige Kopieroperationen für das Laufzeitsysem zu vermeiden sind!
    CLEAR lt_carriers_a2.
    CLEAR lt_connections_a2.
    out->write( |Case: Base_5 Aufgabe 2.b :| ).
    SELECT  FROM /dmo/carrier  FIELDS *  WHERE carrier_id IN ('AA', 'LH') INTO TABLE @lt_carriers_a2 .
    SELECT  FROM /dmo/connection FIELDS * WHERE carrier_id IN ('AA', 'LH') INTO CORRESPONDING FIELDS OF TABLE @lt_connections_a2 .
    lt_connections_a2 = VALUE #(
    LET lt_temp = lt_connections_a2 IN
  FOR <conn> IN lt_temp
  (
    carrier_id      = <conn>-carrier_id
    connection_id   = <conn>-connection_id
    airport_from_id = <conn>-airport_from_id
    airport_to_id   = <conn>-airport_to_id
    name = VALUE #( lt_carriers_a2[ carrier_id = <conn>-carrier_id ]-name  )
  )
).
    out->write( lt_connections_a2  ).

***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 3 -------------------------------------------------------| ).
* Ausgehend von der SELECT-Anweisung soll in der Konsole Folgendes ausgegeben werden:
*AIRLINEID  NAME                    CURRENCYCODE  LASTCHANGEDAT     LOCALCREATEDAT    LOCALCREATEDBY  LOCALLASTCHANGEDAT  LOCALLASTCHANGEDBY
*AA         American Airlines Inc.  USD           20251118151536.0  20251118151536.0  GENERATOR       20251118151536.0    GENERATOR
*LH         Deutsche Lufthansa AG   EUR           20251118151536.0  20251118151536.0  GENERATOR       20251118151536.0    GENERATOR
    TYPES ltyt_carriersa3 TYPE STANDARD TABLE OF /dmo/I_carrier WITH NON-UNIQUE DEFAULT KEY.
    DATA: lt_carriers_a3  TYPE ltyt_carriersa3,
          lt_carriers_a3a LIKE lt_carriers_a3,
          lt_carriers_a3b LIKE lt_carriers_a3.
    SELECT FROM /dmo/i_carrier FIELDS * INTO TABLE @lt_carriers_a3.

* a) Implementieren Sie die Lösung unter Verwendung einer LOOP-Schleife und verwenden Sie ein Feldsymbol.
*    Die auszugebende Ergebnismenge soll in der internen Tabelle lt_result_a3a gespeichert werden!
    out->write( |Case: Base_5 Aufgabe 3.a :| ).
    DATA: lt_result_a3a LIKE lt_carriers_a3.
    LOOP AT lt_carriers_a3 INTO DATA(lv_carriers_a3).
      IF lv_carriers_a3-AirlineID = 'AA' OR lv_carriers_a3-AirlineID = 'LH'.
        APPEND lv_carriers_a3 TO lt_result_a3a.
      ENDIF.
    ENDLOOP.

    out->write( lt_result_a3a ).

* b) Implementieren Sie die Lösung ohne Verwendung einer LOOP-Schleife. Das Ergebnis ist in der int. Tabelle
*    lt_result_a3b abzulegen!
    out->write( |Case: Base_5 Aufgabe 3.b :| ).
    DATA: lt_result_a3b LIKE lt_carriers_a3.
    lt_result_a3b = VALUE #( FOR <line> IN lt_carriers_a3
    WHERE ( AirlineID = 'AA' OR  AirlineID = 'LH' )  (
    CORRESPONDING #( <line> )
                    )
     ).
    out->write( lt_result_a3b ).
***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 4 -------------------------------------------------------| ).
    DATA: lt_conncections_a4 TYPE TABLE OF /dmo/connection.
    SELECT FROM /dmo/connection FIELDS * INTO TABLE @lt_conncections_a4.
* Sorgen Sie dafür, daß in der interne Tabelle ein Abflughafen jeweils nur noch genau einmal
* vorkommt. Geben Sie anschließend die Anzahl der Zeilen der internen Tabelle und danach den
* Inhalt der int. Tabelle in der Konsole aus!
    SORT lt_conncections_a4 BY airport_from_id.
    DELETE ADJACENT DUPLICATES FROM lt_conncections_a4 COMPARING airport_from_id.
    DATA(lines) = lines( lt_conncections_a4 ).

    out->write( |Anzahl Zeilen: { lines } | ). "<- ergänzen Sie diese Anweisung!
    out->write( lt_conncections_a4 ).



***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 5 -------------------------------------------------------| ).
    SELECT FROM /dmo/connection  FIELDS *  INTO TABLE @DATA(lt_conncections_a5) UP TO 3 ROWS.
* Erstellen Sie eine Select-anweisung, die die gleiche Ergebnismenge, wie die oben stehende Select-
* Anweisung, der internen Tabelle lt_connections_an hinzufügt! Anschließend lassen
* Sie den Inhalt der internen Tabelle nach Abflughäfen absteigend sortieren.
* Geben Sie dann den Tabelleninhalt in der Konsole aus!
    SELECT FROM /dmo/connection FIELDS * APPENDING TABLE @lt_conncections_a5 UP TO 3 ROWS.
    SORT lt_conncections_a5 BY airport_from_id DESCENDING.

    out->write( lt_conncections_a5 ).


***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 6 -------------------------------------------------------| ).
    SELECT FROM /dmo/flight FIELDS * INTO TABLE @DATA(lt_flights_a6).
* Ausgehend von der Ergebnismenge in lt_flights_a6 soll folgende Ergebnismenge ermittelt werden:
* CARRIER_ID  CURRENCY_CODE  PRICE_TOTAL  FLIGHTS_COUNT
* AA          USD            17232.0      10
* AZ          EUR            30030.0      4
* JL          JPY            24008.0      4
* LH          EUR            30123.0      8
* SQ          SGD            53964.0      8
* UA          USD            23507.0      6
* a) Implementieren Sie die Lösung mittels Konstruktoroperatoren!
*    Die Ergebnismenge soll in der internen Tabelle lt_result_a6a gespeichert werden!
    TYPES:BEGIN OF t_result_a6,
            carrier_id    TYPE /dmo/carrier_id,
            currency_code TYPE /dmo/currency_code,
            price_total   TYPE /dmo/flight_price,
            flights_count TYPE i,
          END OF t_result_a6.
    TYPES tt_result_a6 TYPE STANDARD TABLE OF t_result_a6 WITH NON-UNIQUE DEFAULT KEY .
    DATA(lt_result_a6a) = VALUE tt_result_a6(
FOR GROUPS group OF flight IN lt_flights_a6
GROUP BY ( carrier_id    = flight-carrier_id
       currency_code = flight-currency_code )
       ASCENDING
(
carrier_id    = group-carrier_id
currency_code = group-currency_code

price_total = REDUCE /dmo/flight-price(
INIT total = CONV /dmo/flight-price( 0 )
FOR member IN GROUP group
NEXT total = total + member-price )

flights_count = REDUCE i(
INIT count = 0
FOR member IN GROUP group
NEXT count = count + 1 )
)
).

    out->write( |Case: Base_5 Aufgabe 6.a :| ).

    out->write( lt_result_a6a ).

* b) Implementieren Sie ab hier die Lösung unter Verwendung der Collect-Anweisung!
*    Die Ergebnismenge soll in der internen Tabelle lt_result_a6b gespeichert werden!
    DATA ls_result_line TYPE t_result_a6 .
    DATA lt_result_a6b TYPE STANDARD TABLE OF t_result_a6 WITH NON-UNIQUE DEFAULT KEY .
    LOOP AT lt_flights_a6 ASSIGNING FIELD-SYMBOL(<fs_flight>).
      ls_result_line-carrier_id = <fs_flight>-carrier_id.
      ls_result_line-currency_code = <fs_flight>-currency_code.
      ls_result_line-price_total   = <fs_flight>-price.
      ls_result_line-flights_count = 1.
      COLLECT ls_result_line INTO lt_result_a6b.
    ENDLOOP.
    SORT lt_result_a6b BY carrier_id ASCENDING.
    out->write( |Case: Base_5 Aufgabe 6.b :| ).
    out->write( lt_result_a6b ).

***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 7 -------------------------------------------------------| ).
* Aus den Daten der DB-Tabelle /dmo/flight soll folgende Ergebnismenge ermittelt werden:
* AIRLINEID  CURRENCY  PRICE_TOTAL  NUMBEROFFLIGHTS
* AA         USD       17232.0      10
* AZ         EUR       30030.0      4
* JL         JPY       24008.0      4
* LH         EUR       30123.0      8
* SQ         SGD       53964.0      8
* UA         USD       23507.0      6
* Programmieren Sie eine SELECT-Anweisung, und geben Sie das Ergebnis in der Konsole aus!
    SELECT FROM /dmo/flight
        FIELDS
                carrier_id AS airlineid,
                currency_code AS currency,
                SUM( price ) AS price,
                COUNT( * ) AS numberofflights
        GROUP BY carrier_id,currency_code
        ORDER BY carrier_id ASCENDING
        INTO TABLE @DATA(lt_result_7).

    out->write( lt_result_7 ).


***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 8 -------------------------------------------------------| ).
* Programmieren Sie eine SELECT-Anweisung, die Daten aus der DB-Tabelle /lrn/passflight anfordert. Es sollen nur Datensätze
* verarbeitet werden, die der Fluggesellschaft "American Airlines" zugeordnet sind und von diesen sollen nur 5 der
* vorhandenen Datensätze von der Datenbank ausgewählt werden.
* Geben Sie die Ergebnismenge in der Konsole aus - die Ausgabe sollte wie unten angeführt aussehen!
* Geforderte Ausgabe in der Konsole:
* FLIGHTID          FLIGHTPRICE  UTILIZATION  FREESEATS
* AA 2678 20141003  473.00 USD   96.62 [%]    13
* AA 2678 20141025  473.00 USD   12.21 [%]    338
* AA 2678 20141102  473.00 USD   48.83 [%]    197
* AA 2678 20141112  473.00 USD   86.75 [%]    51
* AA 2678 20141116  473.00 USD   24.29 [%]    106

* Implementieren Sie ab hier die Lösung!
    SELECT FROM /lrn/passflight
        FIELDS  concat_with_space( carrier_id,
                                concat_with_space( connection_id, CAST( flight_date AS CHAR( 8 ) ) , 1 ), 1  )   AS flightid,
                concat_with_space( CAST( price AS CHAR( 18 ) ), currency_code ,1 ) AS flightprice,
                concat_with_space( CAST(  division( seats_occupied * 100 , seats_max,2 )  AS CHAR( 25 ) ), '[%]',1 ) AS utilization,
                ( seats_max - seats_occupied ) AS freeseats
        WHERE  carrier_id = 'AA' AND connection_id = 2678
        ORDER BY flight_date ASCENDING
        INTO TABLE @DATA(lt_result_8) UP TO 5 ROWS.


    out->write( lt_result_8 ).



***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 9 -------------------------------------------------------| ).
* Die Gesamtheit der Flüge ist in der DB-Tabelle /lrn/passflight abgelegt. Für alle Fluggesellschaften sollen Sie
* die Flugverbindungen ermitteln, die eine kritische prozentuale Auslastung von weniger als 53.00 % erreicht
* worden ist. Es sollen hierbei nur die Flüge berücksichtigt werden, die im Jahr 2025 durchgeführt wurden!
* Geforderte Ausgabe in der Konsole (Beispiel entspr. Datenbestand Dez. 2025):
* CARRIER_ID  CONNECTION_ID  PERCENTAGE  COUNT
* UA          0059           51.23       182
* SQ          0002           49.26       182
* SQ          0011           52.91       182
* LH          0402           52.48       183
* AA          0015           50.23       183
* AA          0017           52.08       183
* AA          0018           52.24       182
* AA          2678           52.2        182
* Hinweis: Die Daten im Schulungssystem hängen vom Zeitraum der Schulung ab - die geforderte Konsolenausgabe
*          basiert also auf dem Datenbestand von Dez. 2025. Die Forderung bzgl. der zu berücksichtigenden
*          Flüge bzw. der kritischen prozentualen Auslastung ist bei Bedarf anzupassen!
* Implementieren Sie ab hier Ihre Lösung:
    SELECT FROM /lrn/passflight
        FIELDS  carrier_id,
                connection_id,
                AVG( division( seats_occupied * 100 , seats_max,2 )  AS DEC( 10,2 ) ) AS percentage,
                COUNT( * ) AS count
        WHERE flight_date LIKE '2025%'
        GROUP BY carrier_id,connection_id
        HAVING AVG( division( seats_occupied * 100, seats_max, 2 ) ) < 53
        ORDER BY carrier_id DESCENDING
        INTO TABLE @DATA(lt_result_9).
    out->write( lt_result_9 ).




***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 10 -------------------------------------------------------| ).
* Für Benutzer wurde eine Anwendung erstellt, die ermöglicht, daß der Benutzer beliebig komplexe Einschränkungen
* bzgl. der Auswahl von Daten interaktiv erfassen kann.
* Simulieren Sie die Benutzereingaben für folgendes Beispiel:
*   Es sollen alle Flugverbindungen der Fluggesellschaften ausgewählt werden, dessen IDs in dem Bereich AA bis UZ
*   liegen, aber nicht die ID  AZ oder LH haben
* Die Daten sind in der DB-Tabelle /dmo/connection enthalten.
* Geben Sie Folgendes in der Konsole aus:
*   1. Die festgelegten Eingrenzungen
*   2. Die Ergebnismenge der Select-Anweisung
*   3. Die Anzahl der ermittelten Flugverbindunen
    DATA lt_range_carrier TYPE  RANGE OF /dmo/connection-carrier_id.
    lt_range_carrier = VALUE #( ( sign = 'I' option = 'BT' low = 'AA' high = 'UZ' )
                                ( sign = 'E' option = 'EQ' low = 'AZ' )
                                ( sign = 'E' option = 'EQ' low = 'LH' ) ).
    SELECT FROM /dmo/connection
        FIELDS *
        WHERE carrier_id IN @lt_range_carrier
        ORDER BY carrier_id ASCENDING
        INTO TABLE @DATA(lt_result_10).
    DATA(sum) = lines( lt_result_10 ).
    out->write( |Suchkriterien: alle Flüge aller Fluggesellschaften aus, dessen ID im Bereich von AA bis UZ liegen, aber nicht die ID  AZ oder LH. | ).
* out->write( lt_range_carrier ).
    out->write( lt_result_10 ).
    out->write( |Insgesamt { sum } Flugverbingdung.| ).

***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 11 -------------------------------------------------------| ).
* Erstellen Sie in dieser Klasse eine private statische Methode power, die die Potenz einer
* Zahl (Basis) ermittelt.
* Als Aktualparameter für Basis und Ergebnis sollen alle Datenobjekte mit numerischen Typ akzeptabel
* sein, für die Potenz sind nur Integerwerte sinnvoll.
* Jede bei der Berechnung auftretende Systemausnahme soll durch den Aufrufer behandelbar sein!
* Weiterhin soll sichergestellt werden, daß immer eine für betriebswirtschaftliche Berechnungen
* akzeptable Arithmetik vom Laufzeitsystem gewählt wird!
* Zum Nachweis der korrekten Funktion geben Sie in der Konsole das Rechenergebnis aus!
*  a) für Basewert 2  und die Potenzen 0, 1, 2, 3
*  b) für Basewert 2  und die Potenzen 0, -1, -2, -3
*  c) für Basewert -2 und die Potenzen 0, 1, 2, 3
*  d) für Basewert -2 und die Potenzen 0, -1, -2, -3
* Dokumentieren Sie die Methode mittels ABAP Doc! (Hinweis: Der Aufwand hierfür sollte angemessen sein,
* d.h. die zusätzliche Dokumentation sollte erkennbar hilfreich für einen Entwickler sein!)

* Implementieren Sie die Lösung ab hier!
    out->write( |a) -----| ).
    DATA base TYPE i .
    DATA exp TYPE i .
    base = 2.
    exp = 0.
    DO 4 TIMES.
      TRY.
          DATA(lv_result_a) = zcl_10_base_5=>power( i_base = base i_exp = exp  ).
          out->write( |Die { exp } Potenz von { base } ist gleich { lv_result_a }.| ).
          exp += 1.
        CATCH cx_sy_arithmetic_error INTO DATA(lx_call_err).
          out->write( |Fehler bei { base } ^ { exp }: { lx_call_err->get_text( ) }| ).
      ENDTRY.
    ENDDO.

*      Rufen Sie hier die Methode in einer DO-Schleife auf!
    out->write( |b)v| ).
    base = 2.
    exp = 0.
    DO 4 TIMES.
      TRY.
          DATA(lv_result_b) = zcl_10_base_5=>power( i_base = base i_exp = exp  ).
          out->write( |Die { exp } Potenz von { base } ist gleich { lv_result_b }.| ).
          exp -= 1.
        CATCH cx_sy_arithmetic_error INTO DATA(lx_call_err_b).
          out->write( |Fehler bei { base } ^ { exp }: { lx_call_err_b->get_text( ) }| ).
      ENDTRY.
    ENDDO.

*      Rufen Sie hier die Methode in einer DO-Schleife auf!
    out->write( |c) -----| ).
    base = -2.
    exp = 0.
    DO 4 TIMES.
      TRY.
          DATA(lv_result_c) = zcl_10_base_5=>power( i_base = base i_exp = exp  ).
          out->write( |Die { exp } Potenz von { base } ist gleich { lv_result_c }.| ).
          exp += 1.
        CATCH cx_sy_arithmetic_error INTO DATA(lx_call_err_c).
          out->write( |Fehler bei { base } ^ { exp }: { lx_call_err_c->get_text( ) }| ).
      ENDTRY.
    ENDDO.
*      Rufen Sie hier die Methode in einer DO-Schleife auf!
    out->write( |d) -----| ).

*      Rufen Sie hier die Methode in einer DO-Schleife auf!
    base = -2.
    exp = 0.
    DO 4 TIMES.
      TRY.
          DATA(lv_result_d) = zcl_10_base_5=>power( i_base = base i_exp = exp  ).
          out->write( |Die { exp } Potenz von { base } ist gleich { lv_result_d }.| ).
          exp -= 1.
        CATCH cx_sy_arithmetic_error INTO DATA(lx_call_err_d).
          out->write( |Fehler bei { base } ^ { exp }: { lx_call_err_d->get_text( ) }| ).
      ENDTRY.
    ENDDO.


***********************************************************************************************************************************
    out->write( | | ).
    out->write( |Case: Base_5 Aufgabe 12 -------------------------------------------------------| ).
* Erstellen Sie in dieser Klasse eine private statische Methode fibonacci, die eine Zahlenfolge
* erstellt und zusätzlich die Summe aller ermittelten Zahlen errechnet!
*  - der Methode ist die gewünschte Anzahl der Zahlen der Zahlenreihe zu übergeben
*    Wenn die Anzahl = 0 ist, soll eine leere Zeichnfolge und als Summe der Wert 0 zurückgegeben werden!
*  - Verwendet man die Methode in einem Ausdruck, soll die Zahlenreihe als String zurückgegeben
*    werden. Die Zahlen sollen jeweils von einem Komma gefolgt von einem Leerzeiche voneinander
*    getrennt sein
*  - Die Summe aller ermittelten Zahlen soll nur dann berechnet werden, wenn der Aufrufer der
*    Methode diesem Ergebnisparameter einen Aktualparameter zugeordnet hat, also dieses Ergebnis
*    wirklich benötigt. (Tipp: ermitteln Sie mittels der Key-word-doku einen geeigneten Vergleichswert)
*    Beachten Sie weiterhin, daß der Aufrufer sich für einen Aktualparameter mit einem geeigneten
*    numerischen Typ entscheiden können muß.
*  - Der Aufrufer sollte jede auftretende Ausnahme abfangen (behandeln) können.
*  Angaben zu Bildung der Zahlenreihe:
*  - die ersten beide Zahlen sind generell 0 und 1
*  - jede weitere Zahl ergibt sich aus der Summe ihrer beiden Vorgänger
*  - jede Zahl dieser Reihe ist ganzzahlig (und größer Null), und die Zahlenreihe ist prinipiell
*    unendlich lang

*  Weisen Sie die korrekte Funktion Ihrer Methode wie folgt nach:
*  1) Aufruf der Methode (Wert für Anzahl = 10) als Argument der out->write( ) Methode

*  2) Aufruf der Methode (Wert für Anzahl = 10) so, daß die Gesamtsumme anschließend in der Konsole
*     ausgegeben wird - Ausgabetext:  Quersumme = ...  !
    TRY.
        DATA(lv_result_12_1) = zcl_10_base_5=>fibonacci( iv_anzahl = 10 ).
        out->write( lv_result_12_1 ).
      CATCH cx_abap_invalid_value INTO DATA(lx_err1).
        out->write( lx_err1->get_text(  ) ).

    ENDTRY.
    TRY.
        DATA lv_my_total TYPE i.
        DATA(lv_result_12_2) = zcl_10_base_5=>fibonacci( EXPORTING iv_anzahl = 10
                                                       IMPORTING ev_sum = lv_my_total ).
        out->write( lv_result_12_1 ).
        out->write( |Total Sum: { lv_my_total }| ).
      CATCH cx_abap_invalid_value INTO DATA(lx_err2).
        out->write( lx_err2->get_text(  ) ).

    ENDTRY.


  ENDMETHOD.
  METHOD power.
    TRY.
        DATA(lv_base_dec) = CONV decfloat34( i_base ).
        rv_result = lv_base_dec ** i_exp.
      CATCH cx_sy_arithmetic_error INTO DATA(lx_err).
        RAISE EXCEPTION lx_err.
    ENDTRY.
  ENDMETHOD.

  METHOD fibonacci.
    DATA numbers TYPE TABLE OF  i.
    DATA number TYPE i .
    CLEAR rv_result.
    IF ev_sum IS SUPPLIED.
      CLEAR ev_sum.
    ENDIF.
    IF iv_anzahl < 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ELSE.
      DO iv_anzahl TIMES.
        CASE sy-index.
          WHEN 1.
            number = 0.
            IF ev_sum IS SUPPLIED.
              ev_sum = 0.
            ENDIF.
            APPEND number TO numbers.
            rv_result = |{ rv_result } { number }|.
          WHEN 2.
            number = 1.
            IF ev_sum IS SUPPLIED.
              ev_sum = ev_sum + number.
            ENDIF.
            APPEND number  TO numbers.
            rv_result = |{ rv_result } , { number }|.
          WHEN OTHERS.
            number = numbers[ sy-index - 2 ] + numbers[ sy-index - 1 ].
            IF ev_sum IS SUPPLIED.
              ev_sum = ev_sum + number.
            ENDIF.
            rv_result = |{ rv_result } , { number }|.
            APPEND number TO numbers.
        ENDCASE.
      ENDDO.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
