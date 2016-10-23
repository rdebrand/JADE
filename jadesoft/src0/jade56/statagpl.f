C   23/08/85 903042127  MEMBER NAME  STATAGPL (S)           FORTRAN
C
C
      SUBROUTINE STATAG( LENGTH, ITAG )
C
C  TEST PLOT VERSION
C
C-----------------------------------------------------------
C
C   VERSION OF 27/01/84      LAST MOD    27/01/84       E.ELSEN
C   STORE FWD LEAD GLASS DATA IN ARRAR ITAG.
C   LENGTH IS TOTAL I*4 LENGTH OF ARRAY.
C   EXTRA ENTRY RETURNS LENGTH ONLY.
C                            LAST MOD    10/09/87       P.HILL,J.OLSSON
C-----------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
      DIMENSION ITAG(1), HP(4), IHP(2) ,HMARK(2) ,IMARK(1)
      EQUIVALENCE ( HP(1), IHP(1) )
      EQUIVALENCE ( HMARK(1), IMARK(1) )
      DIMENSION HELP(2)
      EQUIVALENCE ( HELP(1), IHELP )
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      COMMON / CWORK / IIMARK
C
C IIMARK IS REQUIRED TO CONTROL TAGS2H
C
C
C
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
#include "cmctag.for"

      COMMON / BCS / IW(1)
      COMMON / TODAY / HDATE(6)
C
C DEFAULT INMARK = 0
C
      IIMARK = INMARK
      ISTMZ  = 1
      ISTPZ  = 97
      IENDMZ = 96
      IENDPZ = 192

C
      IF(INMARK.LT.1)GOTO 10
      IF(INMARK.EQ.2)GOTO 5
C
C INMARK = 1
C
      ISTMZ = 1
      ISTPZ = 33
      IENDMZ = 32
      IENDPZ = 64
      GOTO 10
C
C
C INMARK = 2
C
5      ISTMZ = 1
      ISTPZ = 25
      IENDMZ = 24
      IENDPZ = 48
C
C ALL INMARKS
C
 10   CONTINUE
C                                           INITIALISE POINTERS
      HP(1) = 1
      HP(2) = 0
      HP(3) = 0
      HP(4) = 0
C
      NBLIM = IENDMZ
      LENGTH = 3
      INX = 1
C
C SET DATE IN HEAD BANKS WORDS 93 - 95, FROM COMON/TODAY/
C
       CALL BLOC(IND,'HEAD',0,&30)
         IW(IND+93) = HDATE(4)
         IW(IND+94) = HDATE(5)
         IW(IND+95) = HDATE(6)
30     CONTINUE
C
C LOOP TO FILL ARRAY ITAG - FROM ARRAY HGG
C

      DO 100 J = 1, IENDPZ
C
        IF( HGG(J) .LE. 0 ) GO TO 100
        LENGTH = LENGTH + 1
        IF(LENGTH.GT.195)GOTO 20
C
C SOFTWARE ADDRESS MUST BE CONVERTED TO HARDWARE ADDRESS
C FOR  OUTPUT - SAME SCHEME AS TP PROGRAMS
C
        JJ = J
C
C
C INMARK IS TAGAN MARK - 0 FOR 1979/80,1 FOR 1981,2 2 FOR 1983 ..
C
C FOR MARK 0 TAGGER HARDWARE ADDRESSES ARE USED THROUGHOUT SO
C  DONT CONVERT THEM !
C
        IF(INMARK.EQ.0)JHARD = JJ
        IF(INMARK.GT.0)JHARD = TAGS2H(JJ)
C
C CONVERT TO TWO HALF WORDS
C
C
C
        HELP(1) = JHARD
        HELP(2) = HGG(J)
C
C
C FILL ITAG
C
        ITAG(LENGTH) = IHELP
C
C       IF( J .LT. NBLIM ) GO TO 100
C
C  CHANGE 10.9.1987, AGE-OLD BUG!!!    J.O, P.H.
C
        IF( J .LE. NBLIM ) GO TO 100
          INX = INX + 1
          HP(INX) = LENGTH*2 - 7
          NBLIM = IENDPZ
  100 CONTINUE
C
      IF( LENGTH .LE. 3 ) GO TO 8000
 20   HP(3) = LENGTH*2 - 5
      IF( HP(2) .EQ. 0 ) HP(2) = HP(3)
C
C                                           SET DESCRIPTOR AND POINTERS
C
      HMARK(1)=0.0
      HMARK(2)=INMARK
      ITAG(1) = IMARK(1)
      ITAG(2) = IHP(1)
      ITAG(3) = IHP(2)
C
      RETURN
C000  LENGTH = 0
C     RETURN
C     END
C
C                                           LENGTH OF DATA STORED
C-----------------------------------------------------------
      ENTRY      LHATAG( LENGTH )
C-----------------------------------------------------------
C
C LHATAG RETURNS LENGTH OF BOS BANK REQUIRED, HAVING FIRST
C
C  1) ADDED RANDOM HITS  USING MCTAGR
C  2) SMEARED ALL BLOCKS USING MCTAGS
C
C NOTE: IN ORDER TO AVOID WRITING PEDESTAL ONLY BANKS, THE ABOVE
C       IS ONLY DONE IF THERE ARE 'REAL' HITS ALREADY
C------------------------------------------------------------
C
C     IMPLICIT INTEGER*2 (H)
CMACRO CMCTAG
      DATA  ICALLP/0/
C
      IF(ICALLP.NE.0) GO TO 1
C
      CALL HBOOK1(2001,'STATAG: ETOT BEFORE MCTAGR$',100,0.,50.)
      CALL HBOOK1(2002,'STATAG: ETOT BEFORE MCTAGS$',100,0.,50.)
      CALL HBOOK1(2003,'STATAG: ETOT AFTER MCTAGS$',100,0.,50.)
      ICALLP = 1
1     CONTINUE
C
C    WRITE(6,600)(HGG(I),I=1,192)
  600 FORMAT(' ARRAY IN LHATAG ',16(/,12I6))
C IF NO HITS - SKIP IT
      IF(IHIT.LE.0)GOTO 8000
C
C
         SUMPLO = 0.
         LENGTH = 3
C
C WORK OUT LENGTH - TO SEE IF THERE ARE REALLY ANY HITS
C
         DO 2000 J=1,192
         IF(HGG(J).GT.0) SUMPLO = SUMPLO + .001*HGG(J)
 2000    IF( HGG(J) .GT. 0.0 ) LENGTH = LENGTH + 1
          IF(LENGTH.LE.3)GOTO 8000
C
C          MCTAGR ADDS RANDOM HITS AND PEDESTAL FLUCTUATIONS
C
         CALL HFILL(2001,SUMPLO,0,1.)
            CALL MCTAGR
C    WRITE(6,602)(HGG(I),I=1,192)
  602 FORMAT(' ARRAY IN LHATAG AFTER MCTAGR',16(/,12I6))
C      MCTAGS- SMEARS ALL DEPOSITED ENERGIES,BY SIGMA,AND CONVERTS FROM
C            ENERGY TO ADC CHANNEL NUMBER USING CALIB
         SUMPLO = 0.
         DO 2001 J=1,192
         IF(HGG(J).GT.0) SUMPLO = SUMPLO + .001*HGG(J)
 2001    CONTINUE
         CALL HFILL(2002,SUMPLO,0,1.)
             CALL MCTAGS
C    WRITE(6,601)(HGG(I),I=1,192)
  601 FORMAT(' ARRAY IN LHATAG AFTER SMEAR',16(/,12I6))
         SUMPLO = 0.
         DO 2002 J=1,192
         IF(HGG(J).GT.0) SUMPLO = SUMPLO + .001*HGG(J)
 2002    CONTINUE
         CALL HFILL(2003,SUMPLO,0,1.)
C
C NOW WORK OUT LENGTH AGAIN
C
            LENGTH = 3
            DO 3000 J=1,192
 3000       IF( HGG(J) .GT. 0.0 ) LENGTH = LENGTH + 1
C
            IF( LENGTH .GT. 3 ) RETURN
8000  LENGTH = 0
      RETURN
      END
