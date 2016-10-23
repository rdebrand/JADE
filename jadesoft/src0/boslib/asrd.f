C   07/06/96 606071922  MEMBER NAME  ASRD     (S4)          FORTG1
      SUBROUTINE ASRD(BUF,NBT,NBL)
      LOGICAL*1 BUF(1)
      INTEGER IPAR(8)/1,3,6*0/
      INTEGER*2 NCC,NS
      INTEGER TEXT,TEXTL(3)/' VB ',' VBS',' VBS'/
C
C    USAGE
C    =====
C
C    INITIALIZATION
C                        ---
C             CALL ASVB (IUN)        VB-RECORDS
C                        ---
C             CALL ASVBS(IUN)       VBS-RECORDS
C
C             WHERE IUN    =  UNIT NUMBER
C             (DEFAULT IS IUN = 1 AND VBS)
C
C     READ ONE RECORD
C                               ---
C             CALL ASRD(BUF,NBT,NBL)
C                       --- ---
C             WHERE   BUFF( ) =  ARRAY FOR RECORD
C                     NBT     =  RECORD LENGTH (BYTES) *)
C                     NBL     =  LENGTH OF ARRAY (BYTES)
C
C     IF THE TRUE RECORD LENGTH IS LARGER THAN THE ARRAY LENGTH NBL,
C     THIS IS CONSIDERED AS AN ERRROR AND NBT IS SET ZERO. IN ANY
C     CASE NO MORE THAN NBL BYTES ARE FILLED INTO THE ARRAY BUF( ).
C     RESTRICTION. RECORDS IN VB-MODE OR SEGMENTS IN VBS-MODE MUST HAVE
C     A LENGTH LESS THAN 8192 WORDS OR 32768 BYTES.
C
C     *)   NBT =  0   IO-ERROR OR SEGMENT ERROR OR RECORD LENGTH ERROR
C          NBT = -1   END-OF-DATA
C
C          RECORDS WITH IO-ERRORS ARE IGNORED, IF THE DCB=EROPT=SKIP
C          IS SPECIFIED, OTHERWISE THE PROGRAM ABENDS.
C
C
C     CLOSE DATA SET
C                    CALL ASCL
C     NECESSARY ONLY, IF A FURTHER DATA SET SHOULD BE READ. NOT
C     NECESSARY, IF END EXIT OF VREAD IS TAKEN.
C
C
C
      ILOOP=0
   10 ILOOP=ILOOP+1
      IF(ILOOP.GT.10) GOTO 70
      IER=0
      NBT=0
      NB =NBL
      IF(IPAR(7).NE.0) GOTO 20
C     OPEN DATA SET
      TEXT=TEXTL(IPAR(2))
      WRITE(6,101) IPAR(1),TEXT
      CALL RVOPEN(IPAR(1),&74)
      DO 15 I=3,8
   15 IPAR(I)=0
      IPAR(7)=1
C
   20 IF(IPAR(2).NE.1) GOTO 40
C     VB=RECORDS
   30 NCC=NB
      IF(NB.GE.32768) NCC=32767
      CALL RV(NCC,BUF(1),&80,&71,&74)
      IF(NCC.GT.NB) GOTO 73
      NBT=NCC
      GOTO 60
C     VBS-RECORDS
   40 NCC=NB
      IF(NB.GE.32768) NCC=32767
      CALL RVS(NCC,BUF(1),NS,&80,&71,&74)
      IF(NCC.GT.NB) GOTO 73
      NBT=NCC
      MJ=NS+1
      GOTO (60,50,72,72),MJ
   50 NB =NB-NCC
      NCC=NB
      IF(NB.GE.32768) NCC=32767
      CALL RVS(NCC,BUF(1+NBT),NS,&80,&71,&74)
      IF(NCC.GT.NB) GOTO 73
      NBT=NCC+NBT
      MJ=NS+1
      GOTO (72,72,60,50),MJ
C
   60 IPAR(3)=IPAR(3)+1
      IPAR(8)=0
      GOTO 100
C     ERRORS
   73 IER=IER+1
   72 IER=IER+1
   71 IER=IER+1
      IF(IER.NE.2) GOTO 70
      IF(IPAR(8).NE.0) GOTO 10
   70 NBT=0
      IPAR(2+IER)=IPAR(2+IER)+1
      IPAR(8)=IER
      GOTO 100
C     OPEN ERROR
   74 WRITE(6,102)
      NBT=-1
      GOTO 84
C
      ENTRY ASCL
      IF(IPAR(7).EQ.0) GOTO 100
      GOTO 82
C     END-OF-DATA
   80 NBT=-1
      WRITE(6,104)
   82 CALL RVCLOS
   84 WRITE(6,103) (IPAR(I),I=3,6)
      DO 86 I=3,8
   86 IPAR(I)=0
      IPAR(1)=1
      IPAR(2)=3
      GOTO 100
C
      ENTRY ASVB(IUN)
      MARK=1
      GOTO 90
      ENTRY ASVBS(IUN)
      MARK=2
   90 IF(IPAR(7).NE.0) GOTO 100
      IPAR(1)=IUN
      IPAR(2)=MARK
      GOTO 100
C
      ENTRY ASMD(IUN)
      IUN=0
      IF(IPAR(2).NE.3) IUN=IPAR(1)
  100 RETURN
  101 FORMAT('0++++ ASRD OPEN',12X,'-  UNIT',I3,',',A4/)
  102 FORMAT('0++++ ASRD OPEN ERROR'/)
  103 FORMAT('0++++ ASRD CLOSE',11X,'-',I12,'  RECORDS ACCEPTED'/
     1   I40,'  IO-ERRORS'/
     2   I40,'  SEGMENT-ERRORS'/
     3   I40,'  INPUT-ARRAY TOO SMALL'/)
  104 FORMAT('0++++ ASRD END-OF-DATA')
      END
