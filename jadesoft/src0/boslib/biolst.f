C   07/06/96 606071822  MEMBER NAME  BIOLST   (S4)          FORTG1
      SUBROUTINE BIOLST(K)
C     BOS SUBPROGRAM =1.XX=
#include "acs.for"
      COMMON/BCS/IW(1)
C
      INTEGER LIST(200,2)/400*0/
C
      INS=0
      IF(K.EQ.1) INS=NS
      IF(K.EQ.2) INS=IN
      IF(INS.LE.0) GOTO 100
      IF(K.EQ.1) IST=ISLST
      IF(K.EQ.2) IST=NLST
      DO 10 I=1,INS
      J=IW(IST+I)
      IF(J.GT.200) GOTO 10
      LIST(J,K)=LIST(J,K)+1
   10 CONTINUE
      GOTO 100
C
      ENTRY BIOLSP
      WRITE(6,101)
      DO 20 J=1,200
      IF(LIST(J,1).EQ.0.AND.LIST(J,2).EQ.0) GOTO 20
      WRITE(6,102) J,IW(INAMV+J),LIST(J,1),LIST(J,2)
   20 CONTINUE
  100 RETURN
  101 FORMAT('0',10X,'STATISTIC ON BANK NAMES IN INPUT AND OUTPUT',
     1 ' RECORDS'//14X,'I',6X,'NAME',15X,'INPUT',14X,'OUTPUT'/)
  102 FORMAT(11X,I4,6X,A4,2I20)
      END
