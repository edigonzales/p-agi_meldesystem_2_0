# p-agi_meldesystem_2_0

Key muss für JSch umformatiert werden:
```
ssh-keygen -p -f id_rsa -m pem -P "" -N ""
```



Testrequest für Integration GRETL:

```
java -jar /Users/stefan/apps/SaxonHE10-6J/saxon-he-10.6.jar -s:meldungen/MeldungAnGeometer_G-0111102_20221103_145001.xml -xsl:ech0132_to_xtf.xsl -o:MeldungAnGeometer_G-0111102_20221103_145001.xtf

java -jar /Users/stefan/apps/SaxonHE11-5J/saxon-he-11.5.jar -s:meldungen/MeldungAnGeometer_mehrere_gebaeude_mehrere_grundstuecke.xml -xsl:eCH0132_to_SO_AGI_SGV_Meldungen_20221109.xsl -o:MeldungAnGeometer_mehrere_gebaeude_mehrere_grundstuecke.xtf

java -jar /Users/stefan/apps/SaxonHE11-5J/saxon-he-11.5.jar -s:meldungen/Spezialfaelle/MeldungAnGeometer_G-0098981_20230214_104054_Koordinaten.xml -xsl:eCH0132_to_SO_AGI_SGV_Meldungen_20221109.xsl -o:MeldungAnGeometer_G-0098981_20230214_104054_Koordinaten.xtf

```


```
java -jar /Users/stefan/apps/ili2gpkg-4.8.0/ili2gpkg-4.8.0.jar --dbfile fubar.gpkg --modeldir ".;https://models.geo.admin.ch" --models SO_AGI_SGV_Meldungen_20221109 --defaultSrsCode 2056 --strokeArcs --schemaimport


java -jar /Users/stefan/apps/ili2gpkg-4.8.0/ili2gpkg-4.8.0.jar --dbfile fubar.gpkg --modeldir ".;https://models.geo.admin.ch" --models SO_AGI_SGV_Meldungen_20221109 --defaultSrsCode 2056 --strokeArcs --export fubar.xtf
```

Links:

- http://www.ech.ch/de/xmlns/eCH-0129/6/eCH-0129-6-0.xsd
- http://www.ech.ch/de/xmlns/eCH-0132/3/eCH-0132-3-0.xsd 
- https://www.ech.ch/sites/default/files/dosvers/hauptdokument/STAN_d_DEF_2022-06-14_eCH-0132_V2.1.0_Objektwesen%20%E2%80%93%20Dom%C3%A4ne%20Versicherung.pdf