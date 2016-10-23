C   12/09/79 007081308  MEMBER NAME  NUMBWR   (JADEGS)      FORTRAN
      SUBROUTINE NUMBWR(IOPT,NR,XX,YY,SIZE)
C---
C---     WRITE THE NUMBER NR AT POSITION X,Y, WITH SIZE 'SIZE'
C---     THE NUMBER NR IS PRECEDED BY THE SYMBOL HSYM(IOPT)
C---     E.G.  T16 IS GIVEN BY IOPT = 30
C---     E.G.  B16 IS GIVEN BY IOPT = 12
C---     E.G.  C16 IS GIVEN BY IOPT = 13
C    IOPT LE 0 OR GT 36 WILL CAUSE THE NUMBER TO BE PRECEDED BY A BLANK
C---
      IMPLICIT INTEGER*2 (H)
#include "cgraph.for"
      DIMENSION HMW(10)
#include "chsym.for"
      DATA HBLANK /'  '/,HMINUS/'- '/
C---
      KCNT = 1
      IF(IOPT.GT.0.AND.IOPT.LE.36) GO TO 1
      HMW(KCNT) = HBLANK
      GO TO 2
1     HMW(KCNT) = HSYM(IOPT)
2     NUMCAP = NR
      IF(NUMCAP.LT.0) KCNT=KCNT+1
      IF(NUMCAP.LT.0) HMW(KCNT)=HMINUS
      NUMCAP=IABS(NUMCAP)
      NDIG=1
      ACAP=NUMCAP
      IF(NUMCAP.GT.0) NDIG=1+ALOG10(ACAP+0.001)
      IF(NDIG.GT.8) NDIG=8
      DO 5002 JJJ=1,NDIG
      KKK=KCNT+NDIG-JJJ+1
      NTEN=NUMCAP/10
      IDIG=NUMCAP-10*NTEN
      HMW(KKK)=HSYM(IDIG+1)
 5002 NUMCAP=NTEN
      KCNT=KCNT+NDIG
      CALL HEMSYM(XX,YY,SIZE,HMW,KCNT,0.)
      RETURN
      END
