C   05/07/84 407111925  MEMBER NAME  MORE     (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE MORE( IRETN )
C-----------------------------------------------------------------------
C
C   AUTHOR:   C. BOWDERY   7/07/84 :  CHANGE INPUT DATASET ALLOCATION
C
C
C     COMMAND MORE  - CALLS GETDS TO LINK TO NEW INPUT DATASET.
C        IRETN = 0    IF NEW DATASET LINKED
C        IRETN = 1    OTHERWISE
C
C-----------------------------------------------------------------------
C
      IMPLICIT  INTEGER*2 (H)
C
#include "cgraph.for"
C
C------------------  C O D E  ------------------------------------------
C
      LUNREM = NDDINN
      NDDINN = 0
      IRETN  = 1
      CALL TRMOUT(80,'Do you really want to change to another input data
     +set?^')
      CALL DECIDE( IANSW )
      IF( IANSW .EQ. 2 ) GO TO 1
      CALL GETDS(NDDINN,'Please enter FULL NAME of the Dataset with the
     +Events  (without apostrophes)^',IDATSV,HERR)
C
      IF( HERR .NE. 0 ) GO TO 1
        ICREC = 0
        IRETN = 0
        RETURN
C
  1   NDDINN = LUNREM
      CALL TRMOUT(80,'This session will continue with the old input data
     +set. Command?^')
      RETURN
C
      END
