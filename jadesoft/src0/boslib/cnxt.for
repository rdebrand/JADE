C   07/06/96 606071839  MEMBER NAME  CNXT     (S4)          FORTG1
      SUBROUTINE CNXT(IND,IER)
C     BOS SUBPROGRAM =1.11=
#include "acs.for"
      COMMON/BCS/IW(1)
      EXTERNAL BPOS
      IF(KPOS.EQ.0) GOTO 10
      IND=IW(KPOS)
      KPOS=0
      GOTO 100
   10 IND=IW(IND-1)
  100 RETURN
      END
