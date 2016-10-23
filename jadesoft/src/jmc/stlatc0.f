C   18/04/79 C9052901   MEMBER NAME  STLATC   (S)           FORTRAN
      SUBROUTINE STLATC( LENGTH, ILTC )
C-----------------------------------------------------------
C
C  VERSION OF 18/04/79  LAST MOD 29/05/79    E.ELSEN
C  PROVIDE DATA FOR BANK 'LATC' AS DESCRIBED IN
C  JADE NOTE 32.
C  ARRAY ILATCH CONTAINS DATA INCLUDING BANK DESCRIPTOR
C  EXTRA ENTRY LHLATC RETURNS LENGTH ONLY
C----------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
       COMMON/CTWRK/IADC(2,42),ITDC(2,42)
      COMMON / CBPC   / HBPCAR(24)
      COMMON / CLGAMP / LGLONG, HAMPL(2000)
C
      COMMON / CDLATC / LGBRT, LGQT, LGET(4)
C
      DIMENSION NLGBR(42), NLGQ(8)
      DIMENSION ILTC(11), HLATCH(22), ILATCH(11)
      EQUIVALENCE (HLATCH(1),ILATCH(1))
C
      INTEGER MASK(16)/Z1,Z2,Z4,Z8,Z10,Z20,Z40,Z80,Z100,Z200,Z400,Z800,
     *                 Z1000,Z2000,Z4000,Z8000/
C
      CALL VZERO( ILATCH , 11 )
C
CCC  LATCHES FOR BP COUNTERS
      DO 100 J =1,24
      IF( HBPCAR(J) .EQ. 0 ) GO TO 100
      NW = (J-1) / 8
      IBT = J - NW*8
      HLATCH(NW+3) = hLOR( HLATCH(NW+3), hint( MASK(IBT) ) ) ! PMF 10/06/99: hlor,hint
  100 CONTINUE
C
CCC  LATCHES FOR TOF COUNTERS
      DO 200 J =1,42
      IF( ITDC(1,J) + ITDC(2,J) .GE. 4096 ) GO TO 200
      NW = (J-1) / 7
      IBT = J - NW*7
      HLATCH(NW+6) = hLOR( HLATCH(NW+6), hint( MASK(IBT) ) )  ! PMF 10/06/99: hlor,hint
  200 CONTINUE
C
CCC  COMPUTE LATCHES FOR LG ROWS
      IF( LGLONG .EQ. 0 ) GO TO 2000
C
      CALL VZERO( NLGBR, 42 )
      CALL VZERO( NLGQ, 8 )
      NLGE = 0
C
      DO 1000 IBL = 1, LGLONG, 2
      NBLO = HAMPL(IBL)
      NAMP = HAMPL(IBL+1)
      NLGE = NLGE + NAMP
      IF( NBLO .GT. 2688 ) GO TO 600
      NBLO = NBLO - 33
      IF( NBLO .LT. 0 ) NBLO = NBLO + 2688
      KL1 = NBLO / 64 + 1
      KL2 = KL1 + 1
      KL3 = KL2 + 1
      IF( KL2 .GT. 42 ) KL2 = KL2 - 42
      IF( KL3 .GT. 42 ) KL3 = KL3 - 42
      NLGBR(KL1) = NLGBR(KL1) + NAMP
      NLGBR(KL2) = NLGBR(KL2) + NAMP
      NLGBR(KL3) = NLGBR(KL3) + NAMP
      GO TO 1000
C
CCC  END CAP PART
  600 KL = ( NBLO - 2689 ) / 24 + 1
      NLGQ(KL) = NLGQ(KL) + NAMP
 1000 CONTINUE
C
CCC  STORE LG ROW LATCHES
      DO 1100 J =1,42
      IF( NLGBR(J) .LE. LGBRT ) GO TO 1100
      NW = (J-1) / 7
      IBT = J - NW*7
      HLATCH(NW+12) = hLOR( HLATCH(NW+12), hint( MASK(IBT) ) )  ! PMF 10/06/99: hlor,hint
 1100 CONTINUE
C
CCC  STORE END CAP LATCHES
      DO 1200 J =1,8
 1200 IF( NLGQ(J) .GT. LGQT ) HLATCH(18)=hLOR(HLATCH(18),hint(MASK(J)))  ! PMF 10/06/99: hlor,hint
C
CCC  STORE TOTAL LG ENERGY SUM
      DO 1300 J =1,4
 1300 IF( NLGE .GT. LGET(J) ) HLATCH(22)=hLOR(HLATCH(22),hint(MASK(J))) ! PMF 10/06/99: hlor,hint
C
C
CCC  MOVE DATA TO OUTPUT ARRAY ILTC
 2000 CALL MVCL( ILTC, 0, HLATCH, 0, 44 )
C
C
C-----------------------------------------------------------
      ENTRY LHLATC( LENGTH )
C-----------------------------------------------------------
      LENGTH = 11
      RETURN
      END
