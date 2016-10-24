C   24/11/78 106161822  MEMBER NAME  DECIDE   (JADEGS)      FORTRAN
      SUBROUTINE DECIDE(IANSW)
C---
C---     REQUESTS A ''YES'' OR ''NO'' DECISION FROM THE TERMINAL
C---     AND ACCORDINGLY RETURNS A 1 OR 2 RESPECTIVELY IN THE
C---     ARGUMENT FIELD.
C---
      IMPLICIT INTEGER*2 (H)
      DATA HYES/'YE'/,HY/'Y '/,HY1/' Y'/
      DATA HJA/'JA'/,HJ/'J '/,HJ1/' J'/
      DATA HHA/'HA'/,HH/'H '/,HH1/' H'/
C     DATA HNO/'NO'/
C   1 CONTINUE
      CALL TRMIN(2,HTEXT)
      IANSW=2
      IF(HTEXT.EQ.HYES.OR.HTEXT.EQ.HJA.OR.HTEXT.EQ.HHA) IANSW=1
      IF(HTEXT.EQ.HY.OR.HTEXT.EQ.HJ.OR.HTEXT.EQ.HH) IANSW=1
      IF(HTEXT.EQ.HY1.OR.HTEXT.EQ.HJ1.OR.HTEXT.EQ.HH1) IANSW=1
C     IF(HTEXT.EQ.HNO) IANSW=2
C     IF(IANSW.NE.0) GO TO 2
C     CALL TRMOUT(80,'ERROR. PLEASE ENTER EITHER YES OR NO.^')
C     GO TO 1
C   2 CONTINUE
      RETURN
      END