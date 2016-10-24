C   14/09/79 911131438  MEMBER NAME  TRELTR   (JADEGS)      FORTRAN
      SUBROUTINE TRELTR(ITREL,MTR,MTR2)
      IMPLICIT INTEGER*2 (H)
C---
C---     FIND WHICH TRACKS MTR,MTR2 ARE ASSOCIATED TO TRACK ELEM. ITREL
C---
#include "cworkpr.for"
      DIMENSION MTRR(2)
C
      MTRR(1) = 0
      MTRR(2) = 0
      IF(ITREL.LT.0.OR.ITREL.GT.HNTR) GO TO 1001
      IAMB = 0
      IF(NTR.LE.0) GO TO 1002
      DO 2  ITR = 1,NTR
      KNREL = HNREL(ITR)
      IF(KNREL.LE.0.OR.KNREL.GT.9) GO TO 1003
      DO 2  INREL = 1,KNREL
      JNREL = HISTR(INREL,ITR)
      IF(ITREL.NE.IABS(JNREL)) GO TO 2
      IAMB = IAMB + 1
      IF(IAMB.GT.2) GO TO 1004
      MTRR(IAMB) = ITR*ISIGN(1,JNREL)
2     CONTINUE
2001  MTR = MTRR(1)
      MTR2 = MTRR(2)
      GO TO 2000
C * * *  ERROR MESSAGES
1001  WRITE(6,1101) ITREL
1101  FORMAT(' ERROR IN TRELTR:  ITREL = ',I10)
      GO TO 2001
1002  WRITE(6,1102) NTR
1102  FORMAT(' ERROR IN TRELTR:  NTR = ',I10)
      GO TO 2001
1003  WRITE(6,1103) KNREL
1103  FORMAT(' ERROR IN TRELTR:  KNREL = ',I10)
      GO TO 2001
C1004  WRITE(6,1104)
1104  FORMAT(' ERROR IN TRELTR:  MORE THAN TWO TRACKS ASSOCIATED WITH A
     $ TRACK ELEMENT')
1004  GO TO 2001
2000  RETURN
      END