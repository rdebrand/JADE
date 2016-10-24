C   18/07/79 308301506  MEMBER NAME  TRKROL   (JADEGS)      FORTRAN
      SUBROUTINE TRKROL
C---
C---   DISPLAY IN THE ROLLED OUT VIEW IMPACT POINTS OF CHARGED TRACKS
C---       J.OLSSON  18.07.79    LAST CHANGE 30.08.83
C---
      IMPLICIT INTEGER*2 (H)
      COMMON/CWORK2/HWORK(40),JNDEX,NTR,LTR,ITR,IPO,ICNT,NBK,NCLST,NWPCL
     $,DUMMM(16),NTRRES,IW61
      COMMON /CJTRIG/ PI,TWOPI
#include "cgeo1.for"
#include "cgraph.for"
#include "cdata.for"
      DIMENSION AXD(2)
C
      IF(IPO.EQ.0) RETURN
      ADDEND = 84.*BLFI
      ADDRAD = ADDEND/TWOPI
      AXD(1) = .13*ADDEND
      AXD(2) = .87*ADDEND
      ICNT = 0
200   ICNT = ICNT + 1
      IF(ICNT.GT.NTR) GO TO 21
      IPO = IPO + LTR
      IF(ICNT.NE.NTRRES.AND.DSPDTL(14).AND.NTRRES.NE.0) GO TO 200
      ITR = IDATA(IPO + 1)
C** DISPLAY TRACKS
      IFLGX = IDATA(IPO+29)
      CALL RUTRCK(25,IDATA(IPO+18),ADATA(IPO+19),ADATA(IPO+20),
     $ ADATA(IPO+21),ADATA(IPO+22),ADATA(IPO+5),ADATA(IPO+6),
     $ ADATA(IPO+12),ADATA(IPO+13),ADATA(IPO+31),ADATA(IPO+30),
     $ XP,YP,ZP,XP2,YP2,ZP2,IFLGX)
      IF(IFLGX.NE.2) GO TO 198
      FIP = ATAN2(YP,XP)
      IF(FIP.LT.0.) FIP = FIP + TWOPI
      X1 = 0.
      X2 = X1 + FIP*ADDRAD
      Y1 = 2800.
      Y2 = Y1 + 16.*BLZ + ZP
201   CALL PLYGON(9,.7*BLZ,X2,Y2,0)
      SIZE = 60.
      CALL NUMBWR(30,ITR,X2+.8*BLZ,Y2,SIZE)
C     CALL TRNUMB(ITR,2,X2+.8*BLZ,Y2,DUM)
      CALL MOVEA(X2,Y2)
      IF(IFLGX.NE.2) GO TO 310
      FIP = ATAN2(YP2,XP2)
      IF(FIP.LT.0.) FIP = FIP + TWOPI
      X1 = 0.
      X2 = X1 + FIP*ADDRAD
      Y1 = 2800.
      Y2 = Y1 + 16.*BLZ + ZP2
      CALL DRAWA(X2,Y2)
      GO TO 200
198   IF(IFLGX.EQ.0) GO TO 200
      X1 = AXD(1)
      IF(ZP.GT.0.) X1 = AXD(2)
      Y1 = 900.
      X2 = X1 - XP
      Y2 = Y1 + YP
      GO TO 201
310   X2 = X1 - XP2
      Y2 = Y1 + YP2
      CALL DRAWA(X2,Y2)
      GO TO 200
21    CONTINUE
      RETURN
      END