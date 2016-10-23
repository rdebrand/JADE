C   10/09/79 612121325  MEMBER NAME  RD0880   (S)           FORTRAN
      SUBROUTINE RD0880(NRUN)
#include "tfprm.for"
#include "tfadc.for"
C
      COMMON/CALIBR/JPOINT(8)
      DIMENSION ACALIB(8)
      EQUIVALENCE (ACALIB(1),JPOINT(1))
C
      DATA IENTRY/0/
C
      IENTRY = IENTRY + 1
      IND = JPOINT(6)
      NC = 378
      CALL UCOPY(ACALIB(IND+1),CORNOR(1),378)
      IF(NRUN.GE.3728) CALL UCOPY(ACALIB(IND+379),CADCA(1),168)
      IF(NRUN.GE.10000) CALL UCOPY(CORNOR(1),COROVF(1),84)
      IF(IENTRY.NE.1)  RETURN
      LRUN = IFIX(TPARM(20) - 900000.)
  101 FORMAT(' RD0880: CONSTANTS FILE RUN ',I5)
      PRINT 101,LRUN
      RETURN
      PRINT 102,VELSC
      PRINT 102,CORNOR
      PRINT 102,COROVF
      PRINT 102,TPARM
      PRINT 102,TCALM
      PRINT 102,TCALP
      PRINT 102,PEDLM
      PRINT 102,PEDLP
      IF(NRUN.GE.3728) PRINT 102,CADCA
      IF(NRUN.GE.3728) PRINT 102,CADCB
  102 FORMAT(/(1X,10F10.3))
C
      RETURN
      END
