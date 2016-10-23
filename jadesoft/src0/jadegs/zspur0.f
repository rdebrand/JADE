C   12/08/81 311261724  MEMBER NAME  ZSPUR    (S)           FORTRAN
      SUBROUTINE ZSPUR(I,IPATR,MODE)
C*811215*DITTMANN****************************************************
C*                                                                  *
C*                C L E A N   Z   H I T S                           *
C*                        A N D                                     *
C*       C A L C U L A T E   X - Y   C O O R D I N A T E S          *
C*                                                                  *
C*       COLLECT TRACKS NEAR IN R/PHI,                              *
C*       REMOVE HITS FOR WHICH ANOTHER TRACK PASSES BY WITHIN       *
C*       A FRACTION OF THE ADC GATE (3 MM) FOR BOTH AMBIGUITIES.    *
C*       MODE = 1 OR 2 SWITCHES OFF THIS FEATURE.                   *
C*       CALCULATE X-Y COOERDINATES (ZSXY).                         *
C********************************************************************
#include "cdata.for"
      INTEGER*2 HDATA
      COMMON /CWORK/ NHIT,IZB(60),IJC(60),IJH(60),NW(60),LH(60),
     *                LRFL(60),ALU(60),ARU(60),X(60),Y(60),Z(60),S(60),
     *                G(60),DT(60),DL(60),DW(60),FCORR(60)
     *               ,IL(25),ARL(25),XML(25),YML(25)
C
      NTNA = 0
      IF(MODE.EQ.1 .OR. MODE.EQ.2) GOTO 10
C
      NT = IDATA(IPATR+2)
      L0 = IDATA(IPATR+1)
      LT = IDATA(IPATR+3)
      KT = IPATR + L0 + (I-1)*LT
      PT = SQRT(ADATA(KT+8)**2+ADATA(KT+9)**2)
      CPHI = ADATA(KT+8) / PT
      SPHI = ADATA(KT+9) / PT
C        FIND TRACKS NEAR IN R/PHI
      KKT = IPATR + L0
      DO 9 L=1,NT
      IF(L.EQ.I) GOTO 9
      IF(ADATA(KKT+25).EQ.0.) GOTO 9
      PTL = SQRT(ADATA(KKT+8)**2+ADATA(KKT+9)**2)
      CP2 = ADATA(KKT+8)/PTL
      SP2 = ADATA(KKT+9)/PTL
      IF(ABS(CPHI-CP2).GT.1. .OR. ABS(SPHI-SP2).GT.1.) GOTO 9
      IF(NTNA.EQ.25) GOTO 9
      NTNA = NTNA + 1
      IL(NTNA) = L
      RL = -1. / ADATA(KKT+25)
      ARL(NTNA) = ABS(RL)
      XML(NTNA) = ADATA(KKT+5) - RL*SP2
      YML(NTNA) = ADATA(KKT+6) + RL*CP2
    9 KKT = KKT + LT
C        LOOP OVER ALL HITS OF TRACK I
   10 CONTINUE
      DO 29 J=1,NHIT
      IF(IZB(J).EQ.0) GOTO 29
C        R/PHI COORDINATES
      NH1 = IJC(J)
      LRFLAG = LRFL(J)
      CALL ZSXY(NH1,LRFLAG,XJET1,YJET1,XJET2,YJET2)
      X(J) = XJET1
      Y(J) = YJET1
C        CHECK IF OTHER TRACKS WITHIN DOUBLE TRACK RESOLUTION
      IF(NTNA.EQ.0) GOTO 27
      DO 25 L=1,NTNA
      DIST = SQRT((XJET1-XML(L))**2+(YJET1-YML(L))**2) - ARL(L)
      IF(ABS(DIST).LT.3.) GOTO 26
      DIST = SQRT((XJET2-XML(L))**2+(YJET2-YML(L))**2) - ARL(L)
      IF(ABS(DIST).LT.3.) GOTO 26
   25 CONTINUE
      GOTO 27
   26 IZB(J) = 0
   27 CONTINUE
   29 CONTINUE
C
      RETURN
      END
