﻿#language: de-DE
Funktionalität: Validation

Szenario: Korrekt befüllt
	Angenommen eine Meldung ist korrekt befüllt
	Dann enthält das Validierungsergebnis keine Fehler
	Und es enthält keine Warnungen

Szenariogrundriss: Eine Eigenschaft ist nicht gesetzt
	Angenommen die Eigenschaft '<Name>' von '<Art>' ist nicht gesetzt
	Dann enthält das Validierungsergebnis genau einen Fehler
	Und die Fehlermeldung lautet: ''<Bezeichnung>' darf nicht leer sein.'
Beispiele:
	| Name        | Bezeichnung         | Art          |
	| from        | Von                 | HkpvReport   |
	| to          | Bis                 | HkpvReport   |
	| institution | Einrichtung         | HkpvReport   |
	| ssn         | Versicherungsnummer | PersonalData |
	| birthday    | Geburtsdatum        | PersonalData |
	| family_name | Familienname        | PersonalData |
	| given_name  | Vorname             | PersonalData |
	| street      | Anschrift           | PersonalData |
	| religion    | Religion            | Person       |
	| insurance   | Versicherung        | Person       |
	| nationality | Staatsangehörigkeit | Person       |
	| postcode    | Plz                 | Person       |
	| city        | Ort                 | Person       |
	| gender      | Geschlecht          | Person       |
	| family_name | Familienname        | Staff        |
	| given_name  | Vorname             | Staff        |
	| date        | Datum               | Activity     |
	| date        | Datum               | Consultation |

Szenariogrundriss: Eine Eigenschaft vom Typ Datum hat ein falsches Format
	Angenommen die Eigenschaft '<Name>' von '<Art>' ist auf 'xxx' gesetzt
	Dann enthält das Validierungsergebnis den Fehler ''<Bezeichnung>': 'xxx' ist kein gültiges Datum.'	
Beispiele:
	| Name        | Bezeichnung         | Art          |
	| from        | Von                 | HkpvReport   |
	| to          | Bis                 | HkpvReport   |
	| birthday    | Geburtsdatum        | PersonalData |
	| date        | Datum               | Activity     |
	| date        | Datum               | Consultation |

Szenariogrundriss: Eine Eigenschaft vom HkpvReport mit einem ungültigen Wert gesetzt.
	Angenommen die Eigenschaft '<Name>' von '<Art>' ist auf '<Wert>' gesetzt
	Dann enthält das Validierungsergebnis genau einen Fehler
	Und die Fehlermeldung lautet: 'Für '<Bezeichnung>' ist '<Wert>' kein gültiger Code.'
Beispiele: 
	| Name        | Bezeichnung         | Art    | Wert |
	| religion    | Religion            | Person | test |
	| insurance   | Versicherung        | Person | test |
	| nationality | Staatsangehörigkeit | Person | test |

Szenario: Es wurde ein ungültiger Ort angegeben.
	Angenommen die Eigenschaft 'postcode' von 'Person' ist auf '6900' gesetzt
	Und die Eigenschaft 'city' von 'Person' ist auf 'Dornbirn' gesetzt
	Dann enthält das Validierungsergebnis genau einen Fehler
	Und die Fehlermeldung lautet: ''6900 Dornbirn' ist kein gültiger Ort.'

Szenario: Von-Datum muss der erste Tag des Monats sein.
	Angenommen die Eigenschaft 'from' von 'HkpvReport' ist auf '2018-04-04' gesetzt
	Dann enthält das Validierungsergebnis den Fehler ''Von' muss der erste Tag des Monats sein.'

Szenario: Bis-Datum muss der letzte Tag des Monats sein.
	Angenommen die Eigenschaft 'to' von 'HkpvReport' ist auf '2018-04-04' gesetzt
	Dann enthält das Validierungsergebnis den Fehler ''Bis' muss der letzte Tag des Monats sein.'

Szenario: Die Meldung muss genau einen Monat beinhalten.
	Angenommen die Eigenschaft 'from' von 'HkpvReport' ist auf '2018-03-01' gesetzt
		Und die Eigenschaft 'to' von 'HkpvReport' ist auf '2018-04-30' gesetzt
	Dann enthält das Validierungsergebnis den Fehler 'Die Meldung muss genau einen Monat beinhalten.'

Szenario: Die Meldung darf nicht die Zukunft betreffen.
	Angenommen die Eigenschaft 'to' von 'HkpvReport' ist auf '2058-04-30' gesetzt
	Dann enthält das Validierungsergebnis den Fehler 'Der Wert von 'Bis' muss kleiner oder gleich .*'

Szenario: Das Geburtsdatum darf nicht in der Zukunft liegen.
	Angenommen die Eigenschaft 'birthday' von 'PersonalData' ist auf '2058-04-30' gesetzt
	Dann enthält das Validierungsergebnis den Fehler ''Geburtsdatum' darf nicht in der Zukunft liegen.'

Szenario: Das Geburtsdatum darf nicht vor 1900 liegen.
	Angenommen die Eigenschaft 'birthday' von 'PersonalData' ist auf '1899-12-31' gesetzt
	Dann enthält das Validierungsergebnis den Fehler 'Der Wert von 'Geburtsdatum' muss grösser oder gleich .*'

Szenario: Geburtsdatum und Datum aus der Sozialversicherungsnummer sollten übereinstimmen.
	Angenommen die Eigenschaft 'birthday' von 'PersonalData' ist auf '1966-01-03' gesetzt
		Und die Eigenschaft 'ssn' von 'PersonalData' ist auf '9778-01.03.66' gesetzt
	Dann enthält das Validierungsergebnis die Warnung 'Das Geburtsdatum 03.01.1966 unterscheidet sich vom Wert in der Versicherungsnummer 01.03.66.'
		Und es enthält keine Fehler

Szenario: Die Versicherungsnummer ist nicht korrekt.
	Angenommen die Eigenschaft 'ssn' von 'PersonalData' ist auf '9999-23.10.54' gesetzt
	Dann enthält das Validierungsergebnis den Fehler 'Die Versicherungsnummer 9999-23.10.54 ist nicht korrekt.'

Szenario: Eine Aktivität ist nach dem Meldungszeitraum.
	Angenommen die Meldung enthält am '2058-04-30' die Aktivitäten '02,15'
	Dann enthält das Validierungsergebnis den Fehler 'Der Wert von 'Datum' muss kleiner oder gleich (.*) sein'

Szenario: Eine Aktivität ist vor dem Meldungszeitraum.
	Angenommen die Meldung enthält am '2008-04-30' die Aktivitäten '02,15'
	Dann enthält das Validierungsergebnis den Fehler 'Der Wert von 'Datum' muss grösser oder gleich (.*) sein.'

Szenariogrundriss: Eine Aktivität 1,2 oder 3 aber keinen 15er an diesem Tag.
	Angenommen die Meldung enthält die Aktivitäten '<Art>'
	Dann enthält das Validierungsergebnis den Fehler 'Kein Eintrag '15' vorhanden.'
Beispiele:
	| Art      |
	| 1        | 
	| 2        |
	| 3        |

Szenariogrundriss: Eine Aktivität 4-17 aber keine 1,2 oder 3.
	Angenommen die Meldung enthält die Aktivitäten '<Art>'
	Dann enthält das Validierungsergebnis den Fehler 'Kein Eintrag '1,2,3''
Beispiele:
	| Art      | 
	| 4        | 
	| 5        |
	| 6        |
	| 7        |
	| 8        |
	| 9        |
	| 10       |
	| 11       |
	| 12       |
	| 13       |
	| 14       |
	| 15       |
    | 16       |
	| 17       |

Szenario: Eine Mitarbeiter hat eine Aktivität öfter als 5 Mal an einem Tag bei einem Klienten.
	Angenommen die Meldung enthält die Aktivitäten '2,15,15,15,15,15,15'
	Dann enthält das Validierungsergebnis die Warnung 'Es wurden mehr als 5 gemeldet.'

Szenario: Eine Aktivität sind nicht kummuliert.
	Angenommen die Meldung enthält die Aktivitäten '2,15'
		Und die Meldung enthält die Aktivitäten '15'
	Dann enthält das Validierungsergebnis den Fehler 'Die Einträge sind nicht kumuliert.'

Szenario: Eine Aktivität ohne entsprechenden Eintrag in Persons.
	Angenommen die Meldung enthält bei der Person 'unbekannteId' die Aktivitäten '02,15'
	Dann enthält das Validierungsergebnis den Fehler 'Der Id 'unbekannteId' fehlt'

Szenario: Eine Aktivität ohne entsprechenden Eintrag in Staffs.
	Angenommen die Meldung enthält von der Mitarbeiterin 'unbekannteId' die Aktivitäten '02,15'
	Dann enthält das Validierungsergebnis den Fehler 'Der Id 'unbekannteId' fehlt'

Szenario: Versicherungsnummer ist nicht eindeutig.
	Angenommen eine Versicherungsnummer ist nicht eindeutig
	Dann enthält das Validierungsergebnis den Fehler 'Mehrere Personen haben die selbe Versicherungsnummer'

Szenario: StaffId ist nicht eindeutig.
	Angenommen der Id einer Mitarbeiterin ist nicht eindeutig
	Dann enthält das Validierungsergebnis den Fehler 'Der Id ist nicht eindeutig.'

Szenario: PersonId ist nicht eindeutig.
	Angenommen der Id einer Person ist nicht eindeutig
	Dann enthält das Validierungsergebnis den Fehler 'Der Id ist nicht eindeutig.'

Szenariogrundriss: Eine Auszubildende hat medizinische Leistungen dokumentiert.
	Angenommen eine Auszubildende hat die Aktivitäten '<Art>' dokumentiert
	Dann enthält das Validierungsergebnis den Fehler 'darf als Auszubildende/r keine medizinischen Leistungen'
Beispiele:
	| Art |
	| 6   |
	| 7   |
	| 8   |
	| 9   |
	| 10  |	

Szenario: Eine Person ohne Aktivität.
	Angenommen zu einer Person sind keine Aktivitäten dokumentiert
	Dann enthält das Validierungsergebnis den Fehler 'Keine Aktivitäten'

Szenario: Eine Mitarbeiterin ohne Aktivität.
	Angenommen zu einer Mitarbeiterin sind keine Aktivitäten dokumentiert
	Dann enthält das Validierungsergebnis den Fehler 'Keine Aktivitäten'

Szenario: Eine Beratung ist nach dem Meldungszeitraum.
	Angenommen die Meldung enthält am '2058-04-30' die Beratungen '31,32'
	Dann enthält das Validierungsergebnis den Fehler 'Der Wert von 'Datum' muss kleiner oder gleich (.*) sein'

Szenario: Eine Beratung ist vor dem Meldungszeitraum.
	Angenommen die Meldung enthält am '2008-04-30' die Beratungen '31,32'
	Dann enthält das Validierungsergebnis den Fehler 'Der Wert von 'Datum' muss grösser oder gleich (.*) sein.'

Szenario: Eine Beratung 31 ohne 32.
	Angenommen die Meldung enthält die Beratungen '31'
	Dann enthält das Validierungsergebnis den Fehler 'Kein Eintrag 'Lv32' vorhanden.'

Szenario: Eine Beratung 32 ohne 31.
	Angenommen die Meldung enthält die Beratungen '32'
	Dann enthält das Validierungsergebnis den Fehler 'Kein Eintrag 'Lv31' vorhanden.'

Szenario: Eine Beratung 33 ohne 34.
	Angenommen die Meldung enthält die Beratungen '33'
	Dann enthält das Validierungsergebnis den Fehler 'Kein Eintrag 'Lv34' vorhanden.'

Szenario: Eine Beratung 34 ohne 33.
	Angenommen die Meldung enthält die Beratungen '34'
	Dann enthält das Validierungsergebnis den Fehler 'Kein Eintrag 'Lv33' vorhanden.'
