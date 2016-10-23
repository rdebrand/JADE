C   23/02/79 C9062501   MEMBER NAME  DIAGRE   (JADEGS)      FORTRAN
      SUBROUTINE DIAGRE(HTEXT,N,R1,R2,R3,R4,R5)
C---
C---     PRINT HTEXT AND UP TO 5 REAL NUMBERS, FOR DIAGNOSTICS
C---
      IMPLICIT INTEGER*2 (H)
      DIMENSION R(5),HTEXT(10),HWORK(41)
*** PMF 17/11/99: add variables needed for emulation of DESYLIB routine 'CORE'  
      CHARACTER cHWORK*82
      EQUIVALENCE (cHWORK,HWORK(1))
*** PMF(end)
C---
      IF(N.LT.1.OR.N.GT.5) RETURN
      DO 1  I = 1,5
1     R(I) = 0.
      IF(N.GT.0) R(1) = R1
      IF(N.GT.1) R(2) = R2
      IF(N.GT.2) R(3) = R3
      IF(N.GT.3) R(4) = R4
      IF(N.GT.4) R(5) = R5
      ILIM = 20 + N*11
      CALL CORE(HWORK,ILIM)
      WRITE(cHWORK,100) (HTEXT(I),I=1,10),(R(I),I=1,N)! PMF 17/11/99: UNIT=10 changed to cHWORK
100   FORMAT(10A2,5E11.4)
      CALL TRMOUT(ILIM,HWORK)
      RETURN
      END
