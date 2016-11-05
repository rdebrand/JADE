C   11/11/77 C9030201   MEMBER NAME  SETTOF   (S)           FORTRAN
      SUBROUTINE SETTOF(R)
C
C      THIS ROUTINE SETS THE TIME OF FLIGHT COUNTERS
C      IF A TOF COUNTER IS SET, THE CORRESPONDING POSITION IN THE
C      ARRAY HTOFAR IS SET TO 1, OTHERWISE IT IS 0
C
      COMMON/CGEO1/BKGAUS, RPIP,DRPIP,XRLPIP, RBPC,DRBPC,XRLBPC,
     +             RITNK,DRITNK,XRLTKI, R0ROH,DR0ROH,XR0ROH,
     +             R1ROH,DR1ROH,XR1ROH, R2ROH,DR2ROH,XR2ROH,
     +             R3ROH,DR3ROH,XR3ROH, ROTNK,DROTNK,XRLTKO,
     +             RTOF,DRTOF,XRTOF, RCOIL, DRCOIL, XRCOIL,
     +             ZJM,DZJM,XRZJM, ZJP,DZJP,XRZJP,
     +             ZTKM,DZTKM,XRZTKM, ZTKP,DZTKP,XRZTKP,
     +             ZBPPL,ZBPMI,ZTOFPL,ZTOFMI,
     +             XRJETC,
     +             RLG,ZLGPL,ZLGMI,OUTR2,CTLIMP,CTLIMM,DELFI,
     +             BLXY,BLZ,BLDEP,ZENDPL,ZENDMI,DEPEND,
     +             XHOL1,XHOL2,YHOL1,YHOL2
      COMMON/CTOFF/HTOFAR(42)
*** PMF 15/10/99      DIMENSION R(1)
      DIMENSION R(*)
*** PMF (end)
      INTEGER*2 HTOFAR
      REAL PI/3.14159/,DFITOF/0.0748/
C
C      CHECK WHETHER TOF COUNTERS ARE HIT AT ALL
C
      IF(R(3).GT.ZTOFPL) RETURN
      IF(R(3).LT.ZTOFMI) RETURN
C
C      SET TOF COUNTER
C
      PHI=ATAN2(R(2),R(1))
      IF(PHI.LT.0.) PHI=2.*PI+PHI
      NTOF=(PHI+DFITOF)/(2*DFITOF)+1
      IF(NTOF.GT.42) NTOF=1
      HTOFAR(NTOF)=1
      RETURN
      END
