DROP TABLE Abteilungen CASCADE CONSTRAINTS;
DROP TABLE Angestellte CASCADE CONSTRAINTS;
DROP TABLE Artikel CASCADE CONSTRAINTS;
DROP TABLE Preishistorie CASCADE CONSTRAINTS;
DROP TABLE Lieferanten CASCADE CONSTRAINTS;
DROP TABLE Lieferung CASCADE CONSTRAINTS;
DROP TABLE Lieferungsdetails CASCADE CONSTRAINTS;
DROP TABLE Adresse CASCADE CONSTRAINTS;

CREATE TABLE Adresse (
    Id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    Strasse VARCHAR2(60) NOT NULL,
    HausNr NUMBER(5) NOT NULL CHECK (HausNr > 0),
    Stadt VARCHAR2(60) NOT NULL,
    PLZ NUMBER(10) NOT NULL CHECK (PLZ > 0),
    Land VARCHAR2(60) NOT NULL
);

CREATE TABLE Abteilungen (
    Id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    AbteilungsleiterId NUMBER
);

CREATE TABLE Angestellte (
    Id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    Personalnummer NUMBER UNIQUE NOT NULL CHECK (Personalnummer > 0),
    Name VARCHAR2(50) NOT NULL,
    AdresseId NUMBER  NOT NULL,
    AbteilungsId NUMBER,
    CONSTRAINT fk_adresse FOREIGN KEY (AdresseId) REFERENCES Adresse(Id),
    CONSTRAINT fk_abteilung FOREIGN KEY (AbteilungsId) REFERENCES Abteilungen(Id)
);

CREATE TABLE Artikel (
    Id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    Bezeichnung VARCHAR2(50)  NOT NULL,
    Verkaufspreis NUMBER  NOT NULL CHECK (Verkaufspreis >= 0),
    SupermarktArtikelnummer VARCHAR2(50) UNIQUE  NOT NULL CHECK (LENGTH(SupermarktArtikelnummer) >= 4),
    AbteilungsId NUMBER  NOT NULL,
    Vorrat Number DEFAULT 0 CHECK (Vorrat >= 0) NOT NULL,
    CONSTRAINT fk_artikel_abteilung FOREIGN KEY (AbteilungsId) REFERENCES Abteilungen(Id)
);

CREATE TABLE Preishistorie (
    Id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    ArtikelId NUMBER  NOT NULL,
    GueltigAb DATE NOT NULL,
    Preis NUMBER NOT NULL,
    Typ VARCHAR2(50) NOT NULL CHECK (Typ IN ('Normalpreis', 'Aktionspreis')),
    CONSTRAINT fk_preishistorie_artikel FOREIGN KEY (ArtikelId) REFERENCES Artikel(Id)
);

CREATE TABLE Lieferanten (
    Id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    AdresseId NUMBER NOT NULL,
    CONSTRAINT fk_lieferanten_adresse FOREIGN KEY (AdresseId) REFERENCES Adresse(Id)
);

CREATE TABLE Lieferung (
    Id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    LieferantId NUMBER NOT NULL CHECK (LieferantId > 0),
    Lieferdatum DATE NOT NULL,
    CONSTRAINT fk_lieferung_lieferant FOREIGN KEY (LieferantId) REFERENCES Lieferanten(Id)
);

CREATE TABLE Lieferungsdetails (
    Id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    LieferungsId NUMBER NOT NULL,
    ArtikelId NUMBER NOT NULL,
    Kaufpreis NUMBER NOT NULL CHECK (Kaufpreis >= 0),
    Menge NUMBER NOT NULL CHECK (Menge > 0),
    LieferantArtikelnummer VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_lieferungsdetails_lieferung FOREIGN KEY (LieferungsId) REFERENCES Lieferung(Id),
    CONSTRAINT fk_lieferungsdetails_artikel FOREIGN KEY (ArtikelId) REFERENCES Artikel(Id)
);

--INSERTS

--Daten für die Tabelle Adresse
INSERT INTO Adresse (Strasse, HausNr, Stadt, PLZ, Land) VALUES ('Hauptstraße', 1, 'Wien', 1010, 'Österreich');
INSERT INTO Adresse (Strasse, HausNr, Stadt, PLZ, Land) VALUES ('Bahnhofstraße', 15, 'Linz', 4020, 'Österreich');
INSERT INTO Adresse (Strasse, HausNr, Stadt, PLZ, Land) VALUES ('Marktplatz', 3, 'Salzburg', 5020, 'Österreich');

--Daten für die Tabelle Abteilungen
INSERT INTO Abteilungen (Name) VALUES ('Milchprodukte');
INSERT INTO Abteilungen (Name) VALUES ('Backwaren');
INSERT INTO Abteilungen (Name) VALUES ('Süßes');

--Daten für die Tabelle Angestellte
INSERT INTO Angestellte (Personalnummer, Name, AdresseId, AbteilungsId) VALUES (1001, 'Matthias Watzinger', 1, 1);
INSERT INTO Angestellte (Personalnummer, Name, AdresseId, AbteilungsId) VALUES (1002, 'Anna Schmidt', 2, 2);
INSERT INTO Angestellte (Personalnummer, Name, AdresseId, AbteilungsId) VALUES (1003, 'Felix Huber', 3, 3);

--Daten für die Tabelle Artikel
INSERT INTO Artikel (Bezeichnung, Verkaufspreis, SupermarktArtikelnummer, AbteilungsId, Vorrat) VALUES ('Milch', 1.29, 'A1001', 1, 10);
INSERT INTO Artikel (Bezeichnung, Verkaufspreis, SupermarktArtikelnummer, AbteilungsId, Vorrat) VALUES ('Brot', 2.49, 'A1002', 1, 5);
INSERT INTO Artikel (Bezeichnung, Verkaufspreis, SupermarktArtikelnummer, AbteilungsId, Vorrat) VALUES ('Haribo Gummibärchen', 2.99, 'A1003', 1, 100);

--Daten für die Tabelle Preishistorie
INSERT INTO Preishistorie (ArtikelId, GueltigAb, Preis, Typ) VALUES (1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 1.19, 'Aktionspreis');
INSERT INTO Preishistorie (ArtikelId, GueltigAb, Preis, Typ) VALUES (2, TO_DATE('2024-02-01', 'YYYY-MM-DD'), 2.39, 'Normalpreis');
INSERT INTO Preishistorie (ArtikelId, GueltigAb, Preis, Typ) VALUES (3, TO_DATE('2024-03-01', 'YYYY-MM-DD'), 2.79, 'Aktionspreis');

--Daten für die Tabelle Lieferanten
INSERT INTO Lieferanten (Name, AdresseId) VALUES ('Frisch & Gut GmbH', 1);
INSERT INTO Lieferanten (Name, AdresseId) VALUES ('Bäckerei Sonnenschein', 2);
INSERT INTO Lieferanten (Name, AdresseId) VALUES ('Dairy Fresh AG', 3);

--Daten für die Tabelle Lieferung
INSERT INTO Lieferung (LieferantId, Lieferdatum) VALUES (1, TO_DATE('2024-03-15', 'YYYY-MM-DD'));
INSERT INTO Lieferung (LieferantId, Lieferdatum) VALUES (2, TO_DATE('2024-03-16', 'YYYY-MM-DD'));
INSERT INTO Lieferung (LieferantId, Lieferdatum) VALUES (3, TO_DATE('2024-03-17', 'YYYY-MM-DD'));

--Daten für die Tabelle Lieferungsdetails
INSERT INTO Lieferungsdetails (LieferungsId, ArtikelId, Kaufpreis, Menge, LieferantArtikelnummer) VALUES (1, 1, 0.99, 100, 'L1001');
INSERT INTO Lieferungsdetails (LieferungsId, ArtikelId, Kaufpreis, Menge, LieferantArtikelnummer) VALUES (1, 2, 3, 50, 'L1001');
INSERT INTO Lieferungsdetails (LieferungsId, ArtikelId, Kaufpreis, Menge, LieferantArtikelnummer) VALUES (2, 2, 1.99, 50, 'L1002');
INSERT INTO Lieferungsdetails (LieferungsId, ArtikelId, Kaufpreis, Menge, LieferantArtikelnummer) VALUES (3, 3, 2.49, 75, 'L1003');

--ALTER und UPDATEs
UPDATE Abteilungen SET AbteilungsleiterId = 1 WHERE Id = 1; -- Matthias Watzinger as Leiter of Milchprodukte
UPDATE Abteilungen SET AbteilungsleiterId = 2 WHERE Id = 2; -- Anna Schmidt as Leiter of Backwaren
UPDATE Abteilungen SET AbteilungsleiterId = 3 WHERE Id = 3; -- Felix Huber as Leiter of Süßes;

ALTER TABLE Abteilungen
ADD CONSTRAINT fk_abteilungsleiter FOREIGN KEY (AbteilungsleiterId) REFERENCES Angestellte(Id);

--SELECT (Grundlegend)
SELECT * FROM Adresse;
SELECT * FROM Abteilungen;
SELECT * FROM Angestellte;
SELECT * FROM Artikel;
SELECT * FROM Preishistorie;
SELECT * FROM Lieferanten;
SELECT * FROM Lieferung;
SELECT * FROM Lieferungsdetails;