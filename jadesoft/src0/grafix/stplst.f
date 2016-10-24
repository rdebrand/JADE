C   22/01/79 307041836  MEMBER NAME  STPLST   (JADEGS)      FORTRAN
      SUBROUTINE STPLST
      IMPLICIT INTEGER*2 (H)
#include "cgraph.for"
      COMMON/CGRAP2/BCMD,DSPDTM(30)
      DATA ICALL/0/
C---
C---     LETS SCANNER SPECIFY A LIST OF USER INDICES AT WHICH THE
C---     PROGRAM WILL STOP AND REQUEST USER GUIDANCE.
C---
C---    ARRAY PSTPS      PROGRAMMED STOP LEVELS; SET FALSE IN USER
C---    ARRAY SSTPS      STANDARDLY SET IN GRAPHICS
C---    ARRAY LSTPS      LABELLED STOP FLAGS
C---          COMMENTED OUT, SINCE NEVER USED      30.8.82  J.OLSSON
C---
      IF(ICALL.EQ.1) GO TO 1
      ICALL=1
      DO 2 I=1,10
      SSTPS(I)=.FALSE.
    2 LSTPS(I)=0
1     CONTINUE
CHECK TRAILING NUMBER
      N1 = ACMD
      N = N1
      IF(N.GT.0.AND.N.LT.11) GO TO 2400
      CALL TRMOUT(80,'PLEASE ENTER USER INDICES AT WHICH YOU WISH TO STO
     $P, SEPARATED BY ENTERS.^')
      CALL TRMOUT(80,'ENTER 0 TO GET OUT OF CHANGE LOOP, 100 TO SEE WHIC
     $H INDICES ARE CURRENTLY SET.^')
3     N=TERNUM(DUMMY)
      IF(N.EQ.100) GO TO 4
      IF(N.EQ.0) GO TO 7
      IF(N.LT.0.OR.N.GT.10) GO TO 5
2400  SSTPS(N)=.NOT.SSTPS(N)
      IF(N1.GT.0) GO TO 7
      GO TO 3
C ILLEGAL ENTRY
5     CALL DIAGIN('ILLEGAL NR ENTERED: ',1,N)
      CALL TRMOUT(80,'PLEASE TRY AGAIN.^')
      GO TO 3
C DISPLAY CURRENT SETTINGS
4     KNTR=0
      DO 6 I=1,10
      IF(.NOT.SSTPS(I)) GO TO 6
      KNTR=KNTR+1
      WRITE(JUSCRN,104) I
  104 FORMAT('FLAG',I4,' IS ON.')
    6 CONTINUE
      IF(KNTR.EQ.0) CALL TRMOUT(80,'NO INDICES ARE SET.^')
      CALL TRMOUT(80,'NOW RETURN TO CHANGE LOOP.^')
      GO TO 3
C LEVEL SETTING READY
    7 CONTINUE
C     CALL TRMOUT(80,'PLEASE NOW ENTER EVENT LABEL VALUES FOR WHICH THE
C    $SCANNER SHOULD BE CALLED.^')
C     CALL TRMOUT(80,'YOU CAN ENTER AS MANY AS TEN. ZERO OR RETURN TERMI
C    $NATES ENTRIES.^')
C     KNTR=0
C   8 CONTINUE
C     KNTR=KNTR+1
C     IF(KNTR.LE.10) GO TO 9
C     CALL TRMOUT(80,'TEN ENTRIES MADE. NO MORE ARE POSSIBLE.^')
C     GO TO 10
C   9 CONTINUE
C     NSET=TERNUM(DUMMY)
C     IF(NSET.EQ.0) GO TO 10
C     LSTPS(KNTR)=NSET
C     GO TO 8
C  10 CONTINUE
C     KNTR=0
C     DO 11 I=1,10
C     NSET=LSTPS(I)
C     IF(NSET.EQ.0) GO TO 11
C     DO 16 J=1,I
C     IF(J.EQ.I) GO TO 16
C     IF(NSET.EQ.LSTPS(J)) GO TO 11
C  16 CONTINUE
C     KNTR=KNTR+1
C     LSTPS(KNTR)=NSET
C  11 CONTINUE
C     CALL TRMOUT(80,'SCANNER WILL BE CALLED WHEN THE FOLLOWING EVENT LA
C    $BEL VALUES OCCUR:^')
C     IF(KNTR.GE.1) GO TO 12
C     CALL TRMOUT(80,'NONE^')
C     GO TO 14
C  12 CONTINUE
C     WRITE(JUSCRN,105) (LSTPS(I),I=1,KNTR)
C 105 FORMAT(' ',10I5)
   14 CONTINUE
      DO 17 ISAFE=1,10
      IF(SSTPS(ISAFE)) GO TO 18
C     IF(LSTPS(ISAFE).NE.0) GO TO 18
   17 CONTINUE
      CALL TRMOUT(80,'THERE ARE NO USER LEVELS SET!^')
      CALL TRMOUT(80,'DO YOU REALLY WISH TO PROCEED THROUGH THE ENTIRE I
     $NPUT FILE WITHOUT STOPPING?^')
      CALL TRMOUT(80,'IF NOT, YOU WILL GET ANOTHER CHANCE TO SET INDICES
     $ AND FLAGS^')
      CALL DECIDE(IANSWR)
      IF(IANSWR.EQ.2) GO TO 1
   18 CONTINUE
      RETURN
      END