C   19/03/79 C9083001   MEMBER NAME  LGDECD   (JADENS)      FORTRAN
      SUBROUTINE LGDECD
      IMPLICIT INTEGER*2 (H)
C---
C---     ROUTINE TO CREATE CALIBRATED LEAD GLASS ENERGY BANK.
C---
C---                                   TUESDAY, MARCH 20, 1979
C---                                   L.H. 0'NEILL
C---
#include "cgraph.for"
#include "cdata.for"
      COMMON/CALIBR/JPOINT(16)
      DIMENSION HCALIB(2)
      EQUIVALENCE (HCALIB(1),JPOINT(1))
      IF(IDATA(IBLN('ALGN')).NE.0) RETURN
      IPHALF=2*JPOINT(1)
      IPJ0=IDATA(IBLN('ALGL'))
      IF(IPJ0.LT.1) RETURN
      NW=IDATA(IPJ0)
      IF(NW.LT.4) RETURN
      CALL CLOC(IHEAD,'HEAD',0)
      IF(HDATA(2*IHEAD+10).EQ.0) GO TO 10
      CALL CCRE(IPJ1,'ALGN',1,NW,IER)
      IF(IER.NE.0) GO TO 4
      CALL BSAW(1,'ALGN')
      DO 1 I=1,3
      IDATA(IPJ1+I)=IDATA(IPJ0+I)
    1 CONTINUE
      IPH0=2*IPJ0
      IPH1=2*IPJ1
C---
C---     SET SECOND HALF-WORD OF BANK DESCRIPTOR TO ONE TO INDICATE
C---     THAT CALIBRATION HAS BEEN DONE.
C---
      HDATA(IPH1+2)=1
      LOC0=IPH0+5
      LOC1=IPH1+5
      LIM=IPH0+2*NW
    3 CONTINUE
      LOC0=LOC0+2
      LOC1=LOC1+2
      IF(LOC0.GE.LIM) GO TO 2
      IADD=HDATA(LOC0)
      HDATA(LOC1)=IADD
      IADD=IPHALF+IADD*2
      IPEDL=HCALIB(IADD+1)
      IGAIN=HCALIB(IADD+2)
      ICHAN=HDATA(LOC0+1)
      ICHAN=SHFTL(ICHAN,4)
C---
C---     THE ADDITION OF 8192 (2*13) BELOW CAUSES THE SUBSEQUENT RIGHT
C---     SHIFT BY 14 BITS TO RESULT IN A ROUND OFF RATHER THAN A TRUN-
C---     CATION.
C---
      ICHAN=IGAIN*(ICHAN-IPEDL)+8192
      MEV  =SHFTR(ICHAN,14)
      HDATA(LOC1+1)=MEV
      GO TO 3
    2 CONTINUE
      RETURN
   10 CONTINUE
      CALL CCRE(IPJ1,'ALGN',1,NW,IER)
      IF(IER.NE.0) GO TO 4
      CALL BSAW(1,'ALGN')
      CALL BSTR(IPJ1,IDATA(IPJ0),NW)
      RETURN
    4 CONTINUE
      IF(IER.GT.1) WRITE(JUSCRN,100) IER
  100 FORMAT(' ERROR NUMBER',I4,' IN ATTEMPT TO CREATE ALGN.')
      RETURN
      END
