      PROGRAM FEHLTEST
      CALL FEHLTX( 1,'ERROR CREATING ZEHD-BANK')
      CALL FEHLTX( 2,'NO PATR / LGCL BANK ')
      CALL FEHLTX( 3, 'NUMBER OF CHARGED TRACKS <= 0 IN PATR')
      CALL FEHLTX( 4, 'ERROR WHILE CREATING ZIM1-BANK')
      CALL FEHLTX( 5, 'NO TRACKS IN ZE4V-BANK')
      CALL FEHLTX( 11,'NUMBER OF HITS IN R-PHI LT CUT')
      CALL FEHLTX( 12,'NUMBER OF HITS IN R-Z LT CUT')
      CALL FEHLTX( 13,'Z- CUT NOT PASSED')
      CALL FEHLTX( 14,'RMIN CUT NOT PASSED')
      CALL FEHLTX( 15,'MOMENTUM CUT NOT PASSED')
      CALL FEHLTX( 17,'NO CONNECTED LG-CLUSTER')
      CALL FEHLTX( 18,'JCLUS > 0 BUT NO LGCL-BANK')
      CALL FEHLTX( 19,'CORR. ECL < 0 (NO CL. IN LGANAL)')
      CALL FEHLTX( 19,'BLA')
      CALL FEHLER( 1, &1 )
 100  CALL FEHLER( 11, &11 )
 200  CALL FEHLER( 19, &19 )
      PRINT *,'ALLES OK'
      STOP
 1    PRINT *,'FEHLER=1'
      GOTO 100
 11   PRINT *,'FEHLER=11'
      GOTO 200
 19   PRINT *,'FEHLER=19'
      STOP
      END