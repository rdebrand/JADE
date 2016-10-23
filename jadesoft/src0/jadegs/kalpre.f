C   14/09/81 202270914  MEMBER NAME  KALPRE   (JADEGS)      FORTRAN
      SUBROUTINE KALPRE
      IMPLICIT INTEGER*2 (H)
C---
C---    14.9.81 MODIFIED IN ORDER TO COPE WITH CHANGED CALIBR.FILES
C---            ONLY AUPDAT0 + AUPDAT1/KALWRK0 ARE NEEDED
C---            ASTART0 + ASTART1 ARE REDUNDANT   P. ST.
C---
C---     COPIES CALIBRATION DATA FROM THE BEGINNING OF THE RUTHERFORD
C---     REFORMATTED TAPES ONTO THE RUTHERFORD CALIBRATION DISK FILES.
C---                                   L.H. O'NEILL 14.03.81
C---
      DIMENSION JBUF(5000)
      DIMENSION LTIMES(10)
#include "ciouni.for"
      DATA LTIMES/
     1   14688000,
     1   66787200,
     1   14688000,
     1   66787200,
     1   6*0/
C---
      NUINI=NCALI
      DO 3 JUNITN=1,NUINI
      IUNITN=LUNITA(JUNITN)
      NREC=0
    1 CONTINUE
      CALL EVREA1(2,NWORD,JBUF,IRET)
      IF(IRET.EQ.1) GO TO 1000
      IF(IRET.EQ.2) GO TO 2000
      NREC=NREC+1
      IF(NREC.GT.1) GO TO 4
      IF(NWORD.NE.1) GO TO 1001
      IF(JBUF(1).NE.LTIMES(JUNITN)) GO TO 1001
    4 CONTINUE
      CALL KALBNK(IUNITN,NWORD,JBUF)
      GO TO 1
 1000 CONTINUE
      WRITE(6,101) JUNITN
  101 FORMAT(' *** KALPRE .. READ ERROR ON FILE',I2,' AFTER',I6,'RECS.')
      STOP
 1001 CONTINUE
      WRITE(6,102) JUNITN,NWORD,JBUF(1)
  102 FORMAT(' *** KALPRE .. INCORRECT 1ST RECORD IN',
     +           ' CALIBRATION DATA SET',I2,2I10)
      STOP
 2000 CONTINUE
      WRITE(6,103) NREC,IUNITN
  103 FORMAT(1X,10('-'),
     +             I6,' RECORDS COPIED BY KALPRE FROM FT02 TO UNIT',I3)
      END FILE IUNITN
      REWIND IUNITN
    3 CONTINUE
      RETURN
      END
