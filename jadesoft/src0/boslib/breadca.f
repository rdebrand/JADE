C   07/06/96 606071830  MEMBER NAME  BREADCA  (S4)          FORTRAN
      SUBROUTINE BREADC
C     BOS SUBPROGRAM =2.1=
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (IW(1),RW(1))
#include "acs.for"
      LOGICAL*1 LL(8)
      EQUIVALENCE (LABEL,LL(1)),(NH,LL(5))
      INTEGER NH/0/
      INTEGER ENDQ/'ENDQ'/
   10 NW=NLST-NEXT-100
      IF(NW.LE.0) GOTO 90
      CALL READFC(LABEL,NF,IW(NEXT+4),MODE,NW,&100)
      IF(LABEL.EQ.ENDQ) GOTO 100
      IF(MODE) 90,15,30
   15 INC=-1
   20 INC=INC+1
      CALL BLOC(IND,LABEL,INC,&25)
      GOTO 20
   25 CALL BCRE(IND,LABEL,INC,0,&90,IER)
      CALL BCHM(IND,NF,IER)
      GOTO 10
   30 INC=IW(NEXT+4)
      NF=NF-1
      DO 40 I=1,NF
   40 IW(NEXT+3+I)=IW(NEXT+4+I)
      CALL BLOC(IND,LABEL,INC,&25)
      WRITE(6,101)
      GOTO 10
   90 ICOND=9
      CALL BDMP
  100 RETURN
  101 FORMAT(' -------- LAST BANK DOUBLY DEFINED')
      END