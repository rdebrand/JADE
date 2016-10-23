C   07/06/87 803091017  MEMBER NAME  FEHLER   (S)           FORTRAN77
      SUBROUTINE FEHLER( ICODE, *)
C-------------------------------------------------------------------
C
C GIVES ENTRY IN ERROR COUNTING HISTOGRAMM AND JUMPS BACK TO &****
C       VERSION WITHOUT GEP
C-------------------------------------------------------------------
      PARAMETER (MAXLNE=50)
      CHARACTER*40  TEXTAR( MAXLNE ),BLANC
      CHARACTER*(*) TEXT
      INTEGER*4 IERR(50)
      DATA BLANC/' '/
      IF( IABS(ICODE) .GT. MAXLNE ) GOTO 8000
      IERR(IABS(ICODE)) = IERR(IABS(ICODE)) + 1
 8000 IF ( ICODE .LT. 0 ) RETURN
      RETURN 1
C
      ENTRY FEHLTX( NLINE, TEXT )
C-----------------------------------------------------------------
C  FILLS TEXT ARRAY FOR PRINTOUT
C-----------------------------------------------------------------
C                                      CHECK PARAMETERS
      IF(NLINE .GT. MAXLNE .OR. NLINE .LT. 0) THEN
        WRITE(6,9001)  NLINE
 9001   FORMAT('------  FEHLTX : WRONG PARAMETER ----NLINE = ',I5)
        RETURN
      ENDIF
      IF(TEXTAR(NLINE) .NE. BLANC ) THEN
        WRITE(6,9000) NLINE
 9000   FORMAT(///10X,'!!!!!!!!! WARNING FROM FEHLTX !!!!!!!!!!'/
     &            10X,'ERROR NUMBER ',I5,'  DOUBLY DEFINED  '/)
        RETURN
      ENDIF
C                                      FILL ARRAY
      TEXTAR( NLINE ) = TEXT
      RETURN
      ENTRY FEHLIN
C-----------------------------------------------------------------
C  INIT ARRAYS
C-----------------------------------------------------------------
      DO 1002 I=1,MAXLNE
        TEXTAR(I) = BLANC
        IERR(I) = 0
 1002 CONTINUE
      RETURN
      ENTRY FEHLPR
C-----------------------------------------------------------------
C  PRINTOUT OF ERROR CODE
C-----------------------------------------------------------------
      WRITE(6,9011)
 9011 FORMAT(///,20X,'FINAL ERROR STATISTICS '/
     &          ,10X,'  #    NO.              TEXT')
      DO 1003 I=1,MAXLNE
        IF ( TEXTAR(I) .NE. BLANC ) WRITE(6,9002)IERR(I),I,TEXTAR(I)
 9002 FORMAT(10X,I5,2X,'(',I2,')',2X,A40)
 1003 CONTINUE
      WRITE(6,*)' '
      RETURN
      END
