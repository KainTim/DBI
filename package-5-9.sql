SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE supermarkt AS
    TYPE product_record IS RECORD (
        product_id NUMBER,
        price NUMBER,
        amount NUMBER,
        supplier_article_number VARCHAR2(50)
    );
    TYPE product_collection IS TABLE OF product_record INDEX BY BINARY_INTEGER;
    PROCEDURE new_delivery(supplier_id NUMBER, delivery_date DATE, products product_collection);
    PROCEDURE change_price(product_id NUMBER, price NUMBER, from_date DATE, special_offer SMALLINT);
    FUNCTION get_delivery_price(delivery_id NUMBER) RETURN Number;
    FUNCTION get_price_of_date(product_id NUMBER, p_date DATE) RETURN Number;
END supermarkt;
/
CREATE OR REPLACE PACKAGE BODY supermarkt AS
    PROCEDURE new_delivery(supplier_id NUMBER, delivery_date DATE, products product_collection)
        IS
        begin
            INSERT INTO LIEFERUNG (LieferantId, Lieferdatum)
            VALUES (supplier_id, delivery_date);

            FOR i IN 1 .. products.COUNT LOOP
                INSERT INTO lieferungsdetails (LIEFERUNGSID, ArtikelId, Kaufpreis, Menge, LieferantArtikelnummer)
                VALUES ((SELECT Max(Id) FROM LIEFERUNG), products(i).product_id, products(i).price, products(i).amount, products(i).supplier_article_number);
                UPDATE Artikel SET Vorrat = Vorrat + products(i).amount WHERE Id = products(i).product_id;
            END LOOP;
            COMMIT;
        end new_delivery;
    
    PROCEDURE change_price(product_id NUMBER, price NUMBER, from_date DATE, special_offer SMALLINT)
        IS
            v_price_at_date NUMBER;
            v_typ_at_date VARCHAR2(50);
            v_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_count FROM PREISHISTORIE WHERE ARTIKELID = product_id AND TRUNC(GueltigAb) = TRUNC(from_date);
            DBMS_OUTPUT.PUT_LINE('Anzahl der Einträge: ' || v_count);
            IF v_count > 0 THEN
                UPDATE PREISHISTORIE SET Preis = price, Typ = CASE WHEN special_offer = 1 THEN 'Aktionspreis' ELSE 'Normalpreis' END
                WHERE ArtikelId = product_id AND TRUNC(GueltigAb) = TRUNC(from_date);
            ELSE
                INSERT INTO Preishistorie (ArtikelId, GueltigAb, Preis, Typ)
                VALUES (product_id, from_date, price, CASE WHEN special_offer = 1 THEN 'Aktionspreis' ELSE 'Normalpreis' END);

                UPDATE Artikel SET Verkaufspreis = get_price_of_date(product_id, SYSDATE) WHERE Id = product_id;
            END If;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Artikel mit ID ' || product_id || ' nicht gefunden.');
        END change_price;
    FUNCTION get_delivery_price(delivery_id NUMBER) RETURN Number
        IS
            v_total_price Number;
        BEGIN
            SELECT SUM(Kaufpreis * Menge) INTO v_total_price
            FROM lieferungsdetails
            WHERE lieferungsid = delivery_id;
            RETURN v_total_price;
        END get_delivery_price;
    FUNCTION get_price_of_date(product_id NUMBER, p_date DATE) RETURN NUMBER
        IS
            v_price NUMBER;
        BEGIN
            SELECT Preis INTO v_price
            FROM Preishistorie
            WHERE ArtikelId = product_id AND GueltigAb <= p_date
            ORDER BY GueltigAb DESC
            FETCH FIRST 1 ROW ONLY;
            RETURN v_price;
        END get_price_of_date;

END supermarkt;
/
DECLARE
    products supermarkt.product_collection := supermarkt.product_collection();
BEGIN
    products(1):= supermarkt.product_record(1, 2.99, 10, 'A123');
    supermarkt.new_delivery(1, SYSDATE, products);
    supermarkt.change_price(1, 3.80, SYSDATE+10, 1);
    DBMS_OUTPUT.PUT_LINE(supermarkt.get_delivery_price(1));
    DBMS_OUTPUT.PUT_LINE('Aktueller Preis '||supermarkt.get_price_of_date(1,SYSDATE));
    DBMS_OUTPUT.PUT_LINE('Preis nach Änderung '||supermarkt.get_price_of_date(1,SYSDATE+11));
END;
/
SELECT * FROM Lieferung;
SELECT * FROM LIEFERUNGSDETAILS;
SELECT * FROM Artikel;
SELECT Preis, TO_CHAR(GUELTIGAB, 'dd.mm.yyyy.hh.ss') FROM PREISHISTORIE WHERE ARTIKELID = 1;