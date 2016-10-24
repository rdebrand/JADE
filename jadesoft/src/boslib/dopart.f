C   07/06/96 606071842  MEMBER NAME  DOPART   (S4)          FORTG1
C   05/12/76 C8050101   MEMBER NAME  DEFIND   (QLIBS)       FORTRAN
      SUBROUTINE DOPART
      COMMON/BCS/IW(1)
      COMMON/BNKIND/ISTAT,IRN,IHD,IVT
C
C     DOPART - NEW VERSION OF DEFIND
C              MAKES PART-BANKS FROM TRAC-BANKS ACC. TO
C              LIST IN BANK ('VERT',1)
C              BUT NO PREPARATION FOR KINEMATICAL FIT
C                  --------------
C              DELETES OLD BANK ('PART',32), IF EXISTING
      CALL VZERO(ISTAT,4)
      CALL BLOC(IRN,'RUN ',0,&1)
    1 CALL BLOC(IVT,'VERT',1,&100)
    2 CALL BLOC(IHD,'HEAD',0,&3)
    3 CONTINUE
      NTR=IW(IVT+2)
      CALL BLOC(IND,'PART',32,&5)
      IF(IW(IND+6).NE.3.OR.IW(IND+7).NE.1) GOTO 5
      CALL BDLS('PART',32)
    5 CALL BSAW(1,'PART')
      IF(NTR.EQ.0) GOTO 15
      DO 10 I=1,NTR
      N=IW(IVT+10+I)
      CALL BLOC(IND,'PART',N,&6)
      GOTO 7
    6 CALL BLOC(IND,'TRAC',N,&10)
      CALL TRPART(IND,&10)
      CALL BLOC(IND,'PART',N,&10)
    7 CONTINUE
   10 CONTINUE
   15 CONTINUE
  100 RETURN
      END