C   07/06/96 606071823  MEMBER NAME  BLST     (S4)          FORTG1
      SUBROUTINE BLST(NL,LIST,MK)
C     BOS SUBPROGRAM =0.5=
#include "acs.for"
      COMMON/BCS/IW(1)
C
      INTEGER LIST(1)
C
      IF(MK.LT.0) GOTO 40
      IF(MK.GE.1) GOTO 20
C     STORE NAMES OF CURRENT LIST IN ARGUMENT LIST
      NL=0
      IF(IN.LE.0) GOTO 100
      DO 10 I=1,IN
      IF(NL.GE.MK) GOTO 100
      NL=NL+1
      J=IW(NLST+I)
   10 LIST(NL)=IW(INAMV+J)
      GOTO 100
C     ADD NAMES OF ARGUMENT LIST INTO SPECIAL LIST
   20 IF(NL.LE.0) GOTO 100
      MARK=0
      IF(MK.EQ.1) MARK=1
      DO 30 LN=1,NL
      IB=IBLN(LIST(LN))
      IF(NS.EQ.0) GOTO 26
      DO 24 I=1,NS
      IF(IB.EQ.IW(ISLST+I)) GOTO 28
   24 CONTINUE
      IF(NS.GE.NLIST) CALL BDMPA(30)
   26 NS=NS+1
      I =NS
      IW(ISLST+I)=IB
   28 IW(IMLST+I)=MARK
   30 CONTINUE
      GOTO 100
C
C
   40 IF(NL.GT.0) GOTO 50
C     CLEAR SPECIAL LIST
      NS=0
      GOTO 100
C     DELETE NAMES FROM THE SPECIAL LIST
   50 DO 60 LN=1,NL
      IB=IBLN(LIST(LN))
      IF(NS.EQ.0) GOTO 100
      DO 52 I=1,NS
      IF(IB.EQ.IW(ISLST+I)) GOTO 54
   52 CONTINUE
      GOTO 60
   54 IS=I+1
      IF(IS.GT.NS) GOTO 58
      DO 56 I=IS,NS
      IW(ISLST+I-1)=IW(ISLST+I)
   56 IW(IMLST+I-1)=IW(IMLST+I)
   58 NS=NS-1
   60 CONTINUE
C
  100 RETURN
      END