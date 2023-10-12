# p-agi_meldesystem_2_0

## Doku
- Es wird jeweils das erste Element von `buildingInformation`, `realestate` und `buildingEntranceInformation` berücksichtigt. Weitere werden ignoriert.
- Eigentümer (`policyholder`) werden "/"-separiert im XTF aufgelistet.
- Fehlt EGID? Gemäss SGV führen sie diesen nicht.



## Fragen
- Organisation Schemen: Nur auf Edit, da editiert wird von den Geometern? Zwei Schemen? "_import" --> "_work". Damit Trennung von Import der SGV-Meldungen klar?
  * Zwei Schema: Gibt auch besseren Schutz, wenn mal was schief läuft. Man könnte mit SQL (v.a. weil im gleichen Schema) besser steuern was ins "Work"-Schema kommt. Sonst wird alles ersetzt
  * Inhalte im "_import"-Schema könnte glaub so beliebig ersetzt werden oder gelöscht werden.
  * Usecase 1-Schema-Problem: Daten werden importiert aber beim Löschen geht was schief. Geometer verändertn Daten. Daten werden nochmals importiert (also GRETL-Jobs läuft nochmals).
- Modell umbenennen? Da nicht nur Meldungen von SGV.
- Berechtigungen? Wie geht das genau? Hängt auch ab von Schemaorganisation.
- Eigentümer: es wird eine Dummy-Eigentümer reingeschrieben, weil bei der Cancellation dieser fehlt. Ist nur dazu gedacht, dass man testeshalber importieren kann.
- Daten landen auf S3, notfalls könnte man sie wieder auf den SFTP kopieren
- SGV schickt auch Testdaten auf den Prod-SFTP. Unterscheidbar in "<testDeliveryFlag xmlns="http://www.ech.ch/xmlns/eCH-0058/5">1</testDeliveryFlag>":
  * Entweder mit Groovy-XML in einem doLast/First rausfiltern oder Modell erweitern und dann beim 2-Schema-Approach filtern.

Oktober 2023 (eindenken...):
- Import in das "_import" Schema mit Dataset (woher Dataset-Name?)
- Dann Abgleich mit Work-Schema.
- Oder kann ich ohne Dataset importieren? Dann kann es vorkommen, dass ich das gleiche mehrfach drin habe? Wird dann der Abgleich mit Work schwieriger? Und ist verwirrend wenn auf Import das gleiche mehrfach drin ist?
- Einiges macht einen Array-Index-Request "[1]". Falls das Element optinal ist, würde es schiessen, wenn es fehlt. Mal schauen.
- Gemeinde wird nicht geliefert. Dünkt mich. Wir könnten sie mit einem Update updaten (nache dem Import oder beim Transfer in Pub)


Fragen SGV:
- Gibt es Neuaufnahme=26 eventType? Scheint mir fast gleich zu sein (strukturell) zu "Value". Es gäbe noch dazu "eCH-0129:buildingIdentificationType". Ignoriere ich mal.



## Develop

```
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://edit-db/edit
export ORG_GRADLE_PROJECT_dbUserEditDdl=ddluser
export ORG_GRADLE_PROJECT_dbPwdEditDdl=ddluser
export ORG_GRADLE_PROJECT_dbUriPub=jdbc:postgresql://pub-db/pub
export ORG_GRADLE_PROJECT_dbUserPubDdl=ddluser
export ORG_GRADLE_PROJECT_dbPwdPubDdl=ddluser
export ORG_GRADLE_PROJECT_gretlEnvironment=test
export ORG_GRADLE_PROJECT_ftpServerSogis=xxxxx
export ORG_GRADLE_PROJECT_ftpUserSogisGemdat=yyyyy
export ORG_GRADLE_PROJECT_awsAccessKeyAgi=wwwww
export ORG_GRADLE_PROJECT_awsSecretAccessKeyAgi=zzzzz
```

### Schema
```
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --topic-name agi_av_meldewesen --schema-dirname schema createRolesDevelopment
./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_default --topic-name agi_av_meldewesen --schema-dirname schema dropSchema createSchema configureSchema grantPrivileges

```

### Gretl

```
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://localhost:54321/edit
export ORG_GRADLE_PROJECT_dbUserEdit=ddluser
export ORG_GRADLE_PROJECT_dbPwdEdit=ddluser

```

```

```


## fubar

```
find . -iname "*" | xargs grep event
```




Key muss für JSch umformatiert werden:
```
ssh-keygen -p -f id_rsa -m pem -P "" -N ""
```

Testrequest für Integration GRETL:

```
java -jar /Users/stefan/apps/SaxonHE10-6J/saxon-he-10.6.jar -s:meldungen/MeldungAnGeometer_G-0111102_20221103_145001.xml -xsl:ech0132_to_xtf.xsl -o:MeldungAnGeometer_G-0111102_20221103_145001.xtf

java -jar /Users/stefan/apps/SaxonHE11-5J/saxon-he-11.5.jar -s:meldungen/MeldungAnGeometer_mehrere_gebaeude_mehrere_grundstuecke.xml -xsl:eCH0132_to_SO_AGI_SGV_Meldungen_20221109.xsl -o:MeldungAnGeometer_mehrere_gebaeude_mehrere_grundstuecke.xtf

java -jar /Users/stefan/apps/SaxonHE11-5J/saxon-he-11.5.jar -s:meldungen/Spezialfaelle/MeldungAnGeometer_G-0098981_20230214_104054_Koordinaten.xml -xsl:eCH0132_to_SO_AGI_SGV_Meldungen_20221109.xsl -o:MeldungAnGeometer_G-0098981_20230214_104054_Koordinaten.xtf


java -jar /Users/stefan/apps/SaxonHE11-5J/saxon-he-11.5.jar -s:meldungen/Spezialfaelle/MeldungAnGeometer_G-0046901_20230213_081935_Wiederaufnahme_eines_Abbruchs.xml -xsl:eCH0132_to_SO_AGI_SGV_Meldungen_20221109.xsl -o:MeldungAnGeometer_G-0046901_20230213_081935_Wiederaufnahme_eines_Abbruchs.xtf


java -jar /Users/stefan/apps/SaxonHE11-5J/saxon-he-11.5.jar -s:meldungen/Spezialfaelle/MeldungAnGeometer_G-0013648_20230210_220000_Abbruch.xml -xsl:eCH0132_to_SO_AGI_SGV_Meldungen_20221109.xsl -o:MeldungAnGeometer_G-0013648_20230210_220000_Abbruch.xtf



EventType 5=Umbau
java -jar /Users/stefan/apps/SaxonHE11-6J/saxon-he-11.6.jar -s:meldungen_2023-10/MeldungAnGeometer_G-0018922_20231011_110335.xml -xsl:eCH0132_xml2xtf_V0_1.xsl -o:MeldungAnGeometer_G-0018922_20231011_110335.xtf

EventType 4=Anbau
java -jar /Users/stefan/apps/SaxonHE11-6J/saxon-he-11.6.jar -s:meldungen_2023-10/MeldungAnGeometer_G-0057648_20231011_110336.xml -xsl:eCH0132_xml2xtf_V0_1.xsl -o:MeldungAnGeometer_G-0057648_20231011_110336.xtf

EventType 16=Trennung
java -jar /Users/stefan/apps/SaxonHE11-6J/saxon-he-11.6.jar -s:meldungen_2023-10/MeldungAnGeometer_G-0040475_20231011_110334.xml -xsl:eCH0132_xml2xtf_V0_1.xsl -o:MeldungAnGeometer_G-0040475_20231011_110334.xtf

EventType 16=Trennung
java -jar /Users/stefan/apps/SaxonHE11-6J/saxon-he-11.6.jar -s:meldungen_2023-10/MeldungAnGeometer_G-0040475_20231011_110334.xml -xsl:eCH0132_xml2xtf_V0_1.xsl -o:MeldungAnGeometer_G-0040475_20231011_110334.xtf

EventType 18=Entlassung
java -jar /Users/stefan/apps/SaxonHE11-6J/saxon-he-11.6.jar -s:meldungen_2023-10/MeldungAnGeometer_G-0039899_20231011_110332.xml -xsl:eCH0132_xml2xtf_V0_1.xsl -o:MeldungAnGeometer_G-0039899_20231011_110332.xtf

EventType 19=Löschung: Abbruch
java -jar /Users/stefan/apps/SaxonHE11-6J/saxon-he-11.6.jar -s:meldungen_2023-10/MeldungAnGeometer_G-0039881_20231011_110333.xml -xsl:eCH0132_xml2xtf_V0_1.xsl -o:MeldungAnGeometer_G-0039881_20231011_110333.xtf

EventType 19=Löschung: Schaden
java -jar /Users/stefan/apps/SaxonHE11-6J/saxon-he-11.6.jar -s:meldungen_2023-10/MeldungAnGeometer_G-0041377_20231011_110333.xml -xsl:eCH0132_xml2xtf_V0_1.xsl -o:MeldungAnGeometer_G-0041377_20231011_110333.xtf


```





```
java -jar /Users/stefan/apps/ili2gpkg-4.8.0/ili2gpkg-4.8.0.jar --dbfile fubar.gpkg --modeldir ".;https://models.geo.admin.ch" --models SO_AGI_SGV_Meldungen_20221109 --defaultSrsCode 2056 --strokeArcs --schemaimport


java -jar /Users/stefan/apps/ili2gpkg-4.8.0/ili2gpkg-4.8.0.jar --dbfile fubar.gpkg --modeldir ".;https://models.geo.admin.ch" --models SO_AGI_SGV_Meldungen_20221109 --defaultSrsCode 2056 --strokeArcs --export fubar.xtf
```

Links:

- http://www.ech.ch/de/xmlns/eCH-0129/6/eCH-0129-6-0.xsd
- http://www.ech.ch/de/xmlns/eCH-0132/3/eCH-0132-3-0.xsd 
- https://www.ech.ch/sites/default/files/dosvers/hauptdokument/STAN_d_DEF_2022-06-14_eCH-0132_V2.1.0_Objektwesen%20%E2%80%93%20Dom%C3%A4ne%20Versicherung.pdf