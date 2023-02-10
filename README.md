# p-agi_meldesystem_2_0

Key muss für JSch umformatiert werden:
```
ssh-keygen -p -f id_rsa -m pem -P "" -N ""
```



Testrequest für Integration GRETL:

```
java -jar /Users/stefan/apps/SaxonHE10-6J/saxon-he-10.6.jar -s:meldungen/MeldungAnGeometer_G-0111102_20221103_145001.xml -xsl:ech0132_to_xtf.xsl -o:MeldungAnGeometer_G-0111102_20221103_145001.xtf
```


```
java -jar /Users/stefan/apps/ili2gpkg-4.8.0/ili2gpkg-4.8.0.jar --dbfile fubar.gpkg --modeldir ".;https://models.geo.admin.ch" --models SO_AGI_SGV_Meldungen_20221109 --defaultSrsCode 2056 --strokeArcs --schemaimport


java -jar /Users/stefan/apps/ili2gpkg-4.8.0/ili2gpkg-4.8.0.jar --dbfile fubar.gpkg --modeldir ".;https://models.geo.admin.ch" --models SO_AGI_SGV_Meldungen_20221109 --defaultSrsCode 2056 --strokeArcs --export fubar.xtf
```

Links:

- http://www.ech.ch/de/xmlns/eCH-0129/6/eCH-0129-6-0.xsd
- http://www.ech.ch/de/xmlns/eCH-0132/3/eCH-0132-3-0.xsd 