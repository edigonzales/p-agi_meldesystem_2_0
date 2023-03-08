# p-agi_meldesystem_2_0

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
```


```
java -jar /Users/stefan/apps/ili2gpkg-4.8.0/ili2gpkg-4.8.0.jar --dbfile fubar.gpkg --modeldir ".;https://models.geo.admin.ch" --models SO_AGI_SGV_Meldungen_20221109 --defaultSrsCode 2056 --strokeArcs --schemaimport


java -jar /Users/stefan/apps/ili2gpkg-4.8.0/ili2gpkg-4.8.0.jar --dbfile fubar.gpkg --modeldir ".;https://models.geo.admin.ch" --models SO_AGI_SGV_Meldungen_20221109 --defaultSrsCode 2056 --strokeArcs --export fubar.xtf
```

Links:

- http://www.ech.ch/de/xmlns/eCH-0129/6/eCH-0129-6-0.xsd
- http://www.ech.ch/de/xmlns/eCH-0132/3/eCH-0132-3-0.xsd 
- https://www.ech.ch/sites/default/files/dosvers/hauptdokument/STAN_d_DEF_2022-06-14_eCH-0132_V2.1.0_Objektwesen%20%E2%80%93%20Dom%C3%A4ne%20Versicherung.pdf