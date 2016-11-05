C   07/06/96 606071829  MEMBER NAME  BREADC   (S4)          FORTRAN
      SUBROUTINE BREADC
C     BOS SUBPROGRAM =3.1=
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (IW(1),RW(1))
      COMMON/CONTEX/LABL,NSL,NF,FR(36),NB,LBT(72)
      REAL*8 LCD(10)
      LOGICAL*1 LC(80),LBT,PAL/'('/,PAR/')'/,DOLL/'$'/,LH(4)
      INTEGER NFR(36),LIST(4)/'ENDQ','POFF','PON ','UNIT'/,BLK/'    '/
      EQUIVALENCE (LCD(1),LC(1)),(NFR(1),FR(1)),(LABL,LH(1))
      IUN=5
      IPR=1
      IND=0
      WRITE(6,104)
   10 I=1
      READ(IUN,101,END=61) LCD
      CALL READHL(LC)
      DO 20 I=1,4
      IF(LABL.EQ.LIST(I)) GOTO 60
   20 CONTINUE
C     NO SPECIAL CARD
      IF(IND) 22,26,24
   22 IF(LABL.NE.BLK) GOTO 26
      IF(IPR.EQ.1) WRITE(6,104) LCD
      GOTO 10
   24 IF(LABL.EQ.BLK) GOTO 50
C     NEW BANK, DETERMINE TYPE
   26 IND=0
      IF(LABL.EQ.BLK.AND.NF.EQ.0) GOTO 10
      IF(NB.EQ.0) GOTO 40
      IF(LBT(1).NE.PAL.OR.LBT(NB).NE.PAR) GOTO 40
      IF(NF.EQ.2) GOTO 28
      WRITE(6,102) LCD
      CALL BDMPA(41)
   28 CALL BLOC(IND,LABL,NFR(1),*30)
      WRITE(6,103) LCD
      NW=NFR(2)
      CALL BSPC(IUC,NUS,IDUN1,IDUM2)
      IF(NUS.LT.NW) GOTO 90
      READ(IUN,LBT) (IW(IUC+I),I=1,NW)
      IF(IPR.EQ.1) WRITE(6,LBT) (IW(IUC+I),I=1,NW)
      IND=0
      GOTO 10
C     FORMATED INPUT
   30 IF(IPR.EQ.1) WRITE(6,102) LCD,LABL,NFR(1)
      CALL BCRE(IND,LABL,NFR(1),NFR(2),*90,IER)
      NW=NFR(2)
      READ(IUN,LBT) (IW(IND+I),I=1,NW)
      IF(IPR.EQ.1) WRITE(6,LBT) (IW(IND+I),I=1,NW)
      IND=0
      GOTO 10
C     FREE FORMAT INPUT
   40 IF(LH(1).EQ.DOLL.OR.NSL.EQ.1) GOTO 44
      NW=NF
      NR=0
   42 CALL BLOC(IND,LABL,NR,*46)
      NR=NR+1
      GOTO 42
   44 NW=NF-1
      NR=NFR(1)
      CALL BLOC(IND,LABL,NR,*46)
      WRITE(6,103) LCD
      IND=-1
      GOTO 10
   46 IF(IPR.EQ.1) WRITE(6,102) LCD,LABL,NR
      CALL BCRE(IND,LABL,NR,NW,*90,IER)
      IF(NW.EQ.NF) CALL BSTR(IND,FR(1),NW)
      IF(NW.NE.NF) CALL BSTR(IND,FR(2),NW)
      GOTO 10
   50 IF(IPR.EQ.1) WRITE(6,104) LCD
      IF(NF.EQ.0) GOTO 10
      CALL BCHM(IND,NF,IER)
      IF(IER.NE.0) GOTO 90
      INDH=IND+IW(IND)-NF
      CALL BSTR(INDH,FR,NF)
      GOTO 10
C     SPECIAL CARD
   60 WRITE(6,102) LCD
   61 IND=0
      GOTO (62,64,66,68),I
C     END-OF-DATA OR ENDQ-CARD
   62 IF(IUN.EQ.5) GOTO 100
      IUN=5
      GOTO 10
C     POFF-CARD
   64 IPR=0
      GOTO 10
C     PON-CARD
   66 IPR=1
      GOTO 10
C     UNIT-CARD
   68 IUN=NFR(1)
      GOTO 10
C     ERROR, NO SPACE LEFT
   90 WRITE(6,105)
      WRITE(6,104) LCD
      CALL BDMPA(11)
  100 WRITE(6,104)
      RETURN
  101 FORMAT(10A8)
  102 FORMAT(' -------- ',10A8,10X,A4,I10)
  103 FORMAT(' -------- ',10A8,' DOUBLY DEFINED - IGNORED')
  104 FORMAT(10X,10A8)
  105 FORMAT(' --ERROR- INSUFFICIENT SPACE AFTER CARD . . .')
      END
