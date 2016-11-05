C   23/02/79 C9062501   MEMBER NAME  DIAGIN   (JADEGS)      FORTRAN
      SUBROUTINE DIAGIN(HTEXT,N,K1,K2,K3,K4,K5,K6)
C---
C---     PRINT HTEXT AND UP TO 6 INTEGER NUMBERS, FOR DIAGNOSTICS
C---
      IMPLICIT INTEGER*2 (H)
      DIMENSION K(6),HTEXT(10),HWORK(40)
*** PMF 17/11/99: add variables needed for emulation of DESYLIB routine 'CORE'  
      CHARACTER cHWORK*80
      EQUIVALENCE (cHWORK,HWORK(1))
*** PMF(end)
C---
      IF(N.LT.1.OR.N.GT.6) RETURN
      DO 1  I = 1,6
1     K(I) = 0.
      IF(N.GT.0) K(1) = K1
      IF(N.GT.1) K(2) = K2
      IF(N.GT.2) K(3) = K3
      IF(N.GT.3) K(4) = K4
      IF(N.GT.4) K(5) = K5
      IF(N.GT.5) K(6) = K6
      ILIM = 20 + N*9
      CALL CORE(HWORK,ILIM)
      WRITE(cHWORK,100) (HTEXT(I),I=1,10),(K(I),I=1,N)! PMF 17/11/99: UNIT=10 changed to cHWORK
100   FORMAT(10A2,6I9)
      CALL TRMOUT(ILIM,HWORK)
      RETURN
      END
