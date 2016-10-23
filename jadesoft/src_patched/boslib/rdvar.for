C   07/06/96 606071906  MEMBER NAME  RDVAR    (S4)          FORTG1
      SUBROUTINE RDVAR(IUN,NTOT,ARRAY,NDIM)
      INTEGER ARRAY(1),INI/0/,NRD/0/,NWR/0/
      COMMON/CIBCOM/IRFLG
***PMF      REAL*8 TEXTA(4)/' IBCOMR ',' IBWRD  ',' IBARR  '/
      character*8 TEXTA(4)/' IBCOMR ',' IBWRD  ',' IBARR  ','        '/
      character*8 TEXTB(3)/'        ',' IHN213 ',' IHN218 '/
C
      IF(INI.EQ.0) CALL IBCERR
C
      NRD=NRD+1
      IRFLG=1
      IRCDE=0
      CALL IBCOMR(IUN,&8,&4)
      CALL IBWORD(NTOT,&7,&3)
      IF(NTOT.LE.0.OR.NTOT.GT.NDIM) GOTO 1
      CALL IBARR(ARRAY,NTOT,&6,&2)
      CALL IBCOMF
      GOTO 100
C     RECORD TO LARGE OF FIRST WORD WRONG
    1 CALL IBCOMF
      WRITE(6,101) IUN,NRD,NDIM,NTOT,NTOT,NTOT
      NTOT=0
      GOTO 100
C     READ ERRORS
    2 IRCDE=IRCDE+1
    3 IRCDE=IRCDE+1
    4 IRCDE=IRCDE+1
      READ(IUN,ERR=5,END=9)
    5 WRITE(6,102) IUN,NRD,TEXTA(IRCDE),TEXTB(IRFLG)
      NTOT=0
      GOTO 100
C     END EXITS
    6 IRCDE=IRCDE+1
    7 IRCDE=IRCDE+1
    8 IRCDE=IRCDE+1
    9 WRITE(6,103) IUN,NRD,TEXTA(IRCDE)
      NTOT=-1
      GOTO 100
C
      ENTRY WRVAR(IUN,NTOT,ARRAY)
C
      IF(INI.EQ.0) CALL IBCERR
C
      NWR=NWR+1
      IRFLG=1
      CALL IBCOMW(IUN)
      IF(IRFLG.NE.1) GOTO 20
      CALL IBWORD(NTOT)
      IF(IRFLG.NE.1) GOTO 20
   10 CALL IBARR(ARRAY,NTOT)
      IF(IRFLG.NE.1) GOTO 20
      CALL IBCOMF
      GOTO 100
C
      ENTRY WRFIX(IUN,NTOT,ARRAY)
C
      IF(INI.EQ.0) CALL IBCERR
C
      NWR=NWR+1
      IRFLG=1
      CALL IBCOMW(IUN)
      IF(IRFLG.EQ.1) GOTO 10
   20 WRITE(6,104) IUN,NWR
      CALL ABEND
C
  100 INI=1
      RETURN
C
  101 FORMAT('0---- UNIT',I3,'   READ  ',I8,'.TH CALL',5X,'NDIM=',I6,
     1   ', FIRST WORD IN RECORD =',I12,' (I)   ',A4,' (A)',G15.5,
     2   ' (F)')
  102 FORMAT('0---- UNIT',I3,'   READ  ',I8,'.TH CALL',5X,'IO-ERROR IN',
     1   A8,4X,A8)
  103 FORMAT('0---- UNIT',I3,'   READ  ',I8,'.TH CALL',5X,'END EXIT IN',
     1   A8)
  104 FORMAT('0---- UNIT',I3,'   WRITE ',I8,'.TH CALL',5X,'IO-ERROR',
     1   ' ---- ABEND'/)
      END
      SUBROUTINE IBCERR
      INTEGER INI/0/
      EXTERNAL ERR213,ERR218
      IF(INI.NE.0) GOTO 100
      CALL ERRSET(213,256,0,0,ERR213)
      CALL ERRSET(218,256,0,0,ERR218)
      INI=1
  100 RETURN
      END
      SUBROUTINE ERR213(IRETCD,IERNO,A,B,D)
      COMMON/CIBCOM/IRFLG
      IRFLG=2
      RETURN
      END
      SUBROUTINE ERR218(IRETCD,IERNO,A,B,D,F)
      COMMON/CIBCOM/IRFLG
      IRFLG=3
      RETURN
      END
