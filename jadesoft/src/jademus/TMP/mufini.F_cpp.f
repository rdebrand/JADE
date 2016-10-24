C   13/01/84 401130954  MEMBER NAME  MUFINI   (JADEMUS)     FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE MUFINI
C-----------------------------------------------------------------------
C
C LAST CHANGE 16.30 11/01/84 CHRIS BOWDERY : PRINT NOTHING IF ALL ZEROS
C      CHANGE 09.49 12/09/79 JOHN ALLISON.
C
C     TO BE CALLED WHEN PROCESSING IS FINISHED.
C     PRINTS MUON STATISTICS IF MUPRIN.GE.2. (DEFAULT = 2)
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
C                           COMMONS
C
C----------- START OF MACRO CMUSTAT ------------------------------------
C   LAST CHANGE 12.47 15/06/79 JOHN ALLISON.
C      /CMUSTT/
C
      COMMON / CMUSTT / MUTIT(100),NMU(100)
      REAL*8 MUTIT, MUT1(50), MUT2(50)
      EQUIVALENCE(MUTIT(1),MUT1(1)),(MUTIT(51),MUT2(1))
C
C  NMU ARE USED FOR STATISTICS COUNTING IN THE MUON ROUTINES
C
C------------ END OF MACRO CMUSTAT -------------------------------------
C
      COMMON /CMUPRN/ MUPRIN
C
C-----------------  C O D E  -------------------------------------------
C
C                           IS STATISTICS PRINTOUT WANTED?
C
      IF( MUPRIN .LT. 2 ) RETURN
C
C                           ARE THERE ANY NON-ZERO STATISTICS TO PRINT?
C                           IF NOT PRINT NOTHING.
C
      J = 0
      DO  1  I = 1,100
        J = J + IABS( NMU(I) )
  1   CONTINUE
      IF( J .EQ. 0 ) RETURN
C
C                           PRINT MUON STATISTICS
C
      WRITE(6,2) ( ( MUTIT(I),NMU(I) ),I=1,100 )
   2  FORMAT(////'      *****  MUON ANALYSIS STATISTICS  *****'/
     +                    20( /1X,5(A8,1X,I5,9X) )//
     +           '      *****  END OF MUON STATISTICS  *****'/////  )
C
      RETURN
      END