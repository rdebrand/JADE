C   20/03/79 C9062501   MEMBER NAME  DIAGHN   (JADEGS)      FORTRAN
      SUBROUTINE DIAGHN(HTEXT,N,H1,H2,H3,H4,H5,H6)
C---
C---     PRINT HTEXT AND UP TO 6 INTEGER*2 NUMBERS, FOR DIAGNOSTICS
C---
      IMPLICIT INTEGER*2 (H)
      DIMENSION H(6),HTEXT(10),HWORK(40)
*** PMF 17/11/99: add variables needed for emulation of DESYLIB routine 'CORE'  
      CHARACTER cHWORK*80
      EQUIVALENCE (cHWORK,HWORK(1))
*** PMF(end)
CC---
      IF(N.LT.1.OR.N.GT.6) RETURN
      DO 1  I = 1,6
1     H(I) = 0.
      IF(N.GT.0) H(1) = H1
      IF(N.GT.1) H(2) = H2
      IF(N.GT.2) H(3) = H3
      IF(N.GT.3) H(4) = H4
      IF(N.GT.4) H(5) = H5
      IF(N.GT.5) H(6) = H6
      ILIM = 20 + N*9
      CALL CORE(HWORK,ILIM)
      WRITE(cHWORK,100) (HTEXT(I),I=1,10),(H(I),I=1,N)! PMF 17/11/99: UNIT=10 changed to cHWORK
100   FORMAT(10A2,6I9)
      CALL TRMOUT(ILIM,HWORK)
      RETURN
      END
