C   24/04/87 712211517  MEMBER NAME  BBLEAK   (S)           FORTRAN
C
C    CORRECTION FOR LEAKAGE OF BHABHA-SHOWERS      D.PITZL  13.12.87
C
C    THIS IS NOT CONSIDERED IN THE LG-CALIBRATION WHEN THE 'EXPECTED'
C    ENERGY OF A BHABHA-SHOWER IS CALCULATED. SO THE CALIBRATION
C    CONSTANTS WHICH MULTIPLY THE MEASURED ENERGY TO AGREE WITH
C    THE EXPECTED ENERGY ARE SYSTEMATICALLY TOO HIGH.
C
C    MATERIAL IN FRONT OF LEAD GLASS IS INCLUDED AS 1.22 X0 ALU
C
C    DATA FROM EGS4
C
C    3 PERIODS:
C         -- YEARS 1979-82: ONLY SF5-BLOCKS
C                           BEAM ENERGY 17.5 GEV
C         -- YEARS 1983-86: SF5 AND SF6-BLOCKS
C                           BEAM ENERGY 17.5 OR 22 GEV
C
C    RADIATION LENGTH IN SF5 = 2.475 CM (EGS4-VALUE)
C                     IN SF6 = 1.66  CM (EGS4-VALUE)
C
C=======================================================================
      SUBROUTINE BBLEAK ( NRING, RLEAK )
C=======================================================================
C
C    INPUT  : NRING = NUMBER OF LG-RING IN BARREL ( 0-31 )
C    OUTPUT : RLEAK = FRACTION OF LEAKING BHABHA-ENERGY
      IMPLICIT INTEGER*2 (H)
*** include "'f11god.patrecsr.for"  PMF 27.10.98: does not exist; replaced by 'cdata.f'
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
C
      DATA ICALLS / 0 /
C
      DIMENSION R35SF6 (16)
      DIMENSION R44SF6 (16)
      DIMENSION R35SF5 (16)
C
C
C   RING# /
C
C           ECM = 35 GEV, LG WITH SF6 + SF6 ( 1986    ) :
C
      DATA R35SF6 /    .0634, .0634, .0634, .0123, .0143, .0196, .0265,
     +   .0346, .0451, .0572, .0697, .0829, .0951, .0172, .0194, .0204/
C
C           ECM = 44 GEV, LG WITH SF6 + SF6 ( 1983-85 ) :
C
      DATA R44SF6 /    .0659, .0659, .0659, .0148, .0169, .0223, .0292,
     +   .0375, .0479, .0598, .0722, .0856, .0978, .0203, .0226, .0237/
C
C           ECM = 35 GEV, LG ONLY SF5 ( 1979-82 ) :
C
      DATA R35SF5 /    .0634, .0634, .0634, .0123, .0143, .0196, .0265,
     +   .0346, .0451, .0572, .0697, .0829, .0951, .1062, .1138, .1177/
C
      IHEAD  = IDATA( IBLN('HEAD') )
      NRUN   = HDATA( 2*IHEAD + 10 )
      NREC   = HDATA( 2*IHEAD + 11 )
      NYEAR  = HDATA( IHEAD*2 +  8 )
      EBM    = EBEAM ( NRUN ) / 1000.
C
      NRINGW = NRING
C---                                              SYMMETRY AROUND Z=0
      IF ( NRINGW .GT. 15 ) NRINGW = 31 - NRINGW
      NRINGW = NRINGW + 1
C
C---              BRANCH ACCORDING TO YEAR AND ENERGY
C
      IF ( NYEAR .GT. 1982 ) GOTO 20
         RLEAK = R35SF5 ( NRINGW )
         IF ( ICALLS .EQ. 0 ) PRINT 1000, NYEAR
         ICALLS = 1
         GOTO 99
 20   CONTINUE
      IF ( EBM .LT. 19.75 ) GOTO 30
         RLEAK = R44SF6 ( NRINGW )
         IF ( ICALLS .EQ. 0 ) PRINT 1001, NYEAR, EBM
         ICALLS = 1
         GOTO 99
 30   CONTINUE
         RLEAK = R35SF6 ( NRINGW )
         IF ( ICALLS .EQ. 0 ) PRINT 1002, NYEAR, EBM
         ICALLS = 1
 99   CONTINUE

 1000 FORMAT ( /T2,' JADELG.LOAD (BBLEAK) CALLED:',
     +  ' ONLY SF5-BLOCKS IN YEAR ', I4 /)
 1001 FORMAT ( /T2,' JADELG.LOAD (BBLEAK) CALLED:',
     + ' SF5 AND SF6-BLOCKS IN YEAR ',I4,
     + ' ,EBEAM = ',F7.3,' GEV, VALUES FOR 22.0 GEV TAKEN'/)
 1002 FORMAT ( /T2,' JADELG.LOAD (BBLEAK) CALLED:',
     + ' SF5 AND SF6-BLOCKS IN YEAR ',I4,
     + ' ,EBEAM = ',F7.3,' GEV, VALUES FOR 17.5 GEV TAKEN'/)

      RETURN
      END
