C   07/06/96 606071902  MEMBER NAME  PODA     (S4)          FORTG1
      SUBROUTINE PODA(IGOTO,LIST,IL)
C     BOS SUBPROGRAM   =4.4=
      COMMON/BCS/IW(1)
#include "ccs.for"
      INTEGER LIST(5,1),IBOS/'BOSS'/,DIRA/'DIRA'/
      JPAS=IPAS
      IPAS=0
      INDT=0
      CALL BLOC(INDA,'+DIR',IUND,&10)
      GOTO 12
   10 CALL BCRE(INDA,'+DIR',IUND,52,&60,IER)
      CALL BSPC(IA,LB,IDUM1,IDUM2)
      IF(LB.LT.1610) GOTO 60
      CALL RDDA(1,IW(INDA+1),IW(INDA+2))
      IW(INDA+9)=0
      IW(INDA+10)=0
      IW(INDA+51)=0
      IW(INDA+52)=0
      WRITE(6,101) IUND,IW(INDA+6),IW(INDA+7),(IW(INDA+J),J=21,35)
      IF(IW(INDA+19).EQ.0) GOTO 11
      IF(IW(INDA+19).EQ.JPAS) GOTO 11
      IF(JPAS.EQ.IBOS) GOTO 11
      IW(INDA+19)=0
      IW(INDA+20)=1
      WRITE(6,102) IUND
      GOTO 12
   11 IW(INDA+20)=0
   12 IF(IW(INDA+2).EQ.DIRA) GOTO 13
      IF(IW(INDA+2).NE.IW(INDA-3)) GOTO 60
   13 GOTO (14,14,24),IGOTO
C     SEARCH/DELETE
   14 NHASH=2+MOD(IABS(LIST(1,1)+LIST(2,1)),IW(INDA+8))
      CALL BSPC(IA,LB,IDUM1,IDUM2)
      IF(LB.LT.1610) GOTO 60
   16 CALL RDDA(NHASH,IW(IA),IW(IA+1))
      NHASHX=IW(IA+3)
      INDP=IA+4
      N=IW(INDP)/4
      IF(N.EQ.0) GOTO 20
      IF(N.LT.0.OR.N.GT.1610) GOTO 60
      K=INDP
      DO 18 I=1,N
      IF(LIST(1,1).NE.IW(K+1)) GOTO 18
      IF(LIST(2,1).NE.IW(K+2)) GOTO 18
      LIST(3,1)=IW(K+3)
      LIST(4,1)=IW(K+4)
      INDT=K
      GOTO (100,22),IGOTO
   18 K=K+4
   20 NHASH=NHASHX
      IF(NHASH.NE.0) GOTO 16
      GOTO 100
   22 NH=INDP+IW(INDP)-K-4
      IF(NH.NE.0) CALL UCOPY2(IW(K+5),IW(K+1),NH)
      IW(INDP)=IW(INDP)-4
      IW(IA)  =IW(IA)  -4
      CALL WRDA(NHASH,IW(IA),IW(IA+1))
      GOTO 100
C     INSERT
   24 NHASHF=0
      NHASHL=0
      CALL BSPC(IA,LB,IDUM1,IDUM2)
      IF(LB.LT.1610) GOTO 60
      I=0
   26 I=I+1
      IF(I.GT.IL) GOTO 34
      NHASH=2+MOD(IABS(LIST(1,I)+LIST(2,I)),IW(INDA+8))
      IF(NHASH.EQ.NHASHF) GOTO 31
      NHASHF=NHASH
   28 IF(NHASHL.EQ.0) GOTO 30
      CALL WRDA(NHASHL,IW(IA),IW(IA+1))
      NHASHL=0
   30 CALL RDDA(NHASH,IW(IA),IW(IA+1))
   31 INDP=IA+4
      N=IW(INDP)/4
      IF(N.GE.400) GOTO 32
      CALL UCOPY(LIST(1,I),IW(INDP+IW(INDP)+1),4)
      IW(INDP)=IW(INDP)+4
      IW(IA)  =IW(IA)  +4
      NHASHL=NHASH
      GOTO 26
   32 IF(IW(IA+3).EQ.0) GOTO 33
      NHASH=IW(IA+3)
      GOTO 28
   33 NHASHL=NHASH
      IW(INDA+7)=IW(INDA+7)+1
      NHASH=IW(INDA+7)
      NTOT=IW(IA)
      NWDR=IW(IA+4)
      IW(IA)=4
      IW(IA+4)=0
      CALL WRDA(NHASH,IW(IA),IW(IA+1))
      IW(INDA+7)=IW(INDA+7)+1
      IW(IA)=0
      CALL WRDA(NHASH+1,IW(IA),IW(IA+1))
      IW(IA)  =NTOT
      IW(IA+3)=NHASH
      IW(IA+4)=NWDR
      GOTO 28
   34 IF(NHASHL.EQ.0) GOTO 100
      CALL WRDA(NHASHL,IW(IA),IW(IA+1))
      GOTO 100
C
      ENTRY CHDIR
      CALL BSPC(IA,LB,IDUM1,IDUM2)
      IF(LB.LT.1610) GOTO 60
      DO 44 I=1,10
      CALL RDDA(1,IW(IA),IW(IA+1))
      IF(IW(IA+8).NE.0) GOTO 42
      IF(IW(IA+9).NE.0) GOTO 42
      IW(IA+8)=LISTE(1)
      IW(IA+9)=LISTE(2)
      CALL WRDA(1,IW(IA),IW(IA+1))
      CALL RDDA(2,IW(IA),IW(IA+1))
      CALL RDDA(1,IW(IA),IW(IA+1))
      IF(IW(IA+8).NE.LISTE(1)) GOTO 42
      IF(IW(IA+9).NE.LISTE(2)) GOTO 42
      GOTO 100
   42 CALL RDDA(2,IW(IA),IW(IA+1))
   44 CONTINUE
   50 WRITE(6,103) IUND
      STOP
   60 CALL BDMPA(15)
C
C
  100 RETURN
  101 FORMAT('0---- DA-UNIT',I3,10X,'TOTAL',I6,' RECORDS, USED',
     1   I6,' RECORDS'/'0',38X,'LAST LOAD',17X,'LAST UPDATE',17X,
     2   'LAST UNLOAD'/15X,' DATE',10X,3(2A4,2X,2A4,10X)/
     3   15X,' STORED BANKS',12X,3(I8,20X)/)
  102 FORMAT('0---- DA-UNIT',I3,10X,'PROTECTED DATA SET, NO BCREDA',
     1   ' OR BDLSDA POSSIBLE'/)
  103 FORMAT('0---- DA-UNIT',I3,' IN USE, NO CHANGE POSSIBLE - STOP'/)

      END