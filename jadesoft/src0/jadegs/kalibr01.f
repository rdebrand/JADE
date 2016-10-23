C   26/10/82         8  MEMBER NAME  KALIBR01 (JADEGS)      FORTRAN
      SUBROUTINE KALIBR
      IMPLICIT INTEGER*2 (H)
C--- **************************************************************
C--- ******************* VERSION FOR NOZAKIS NEW JET CONSTANTS ****
C--- **************************************************************
C---
C---     TEMPORARY KLUGE TO PUT IN SOMEWHAT BETTER CALIBRATION DATA
C---     IN THE CASE OF REAL DATA THAN THE MONTE CARLO VALUES. THE
C---     "TWISTING ANGLE" IS LEFT AT 20 DEGREES FOR THE TIME BEING
C---     BUT ITS SIGN IS REVERSED COMPARED TO THE MONTE CARLO CONVEN-
C---     TION IN ORDER TO CONFORM TO THE DATA TAKEN SO FAR, FOR WHICH
C---     THE MAGNETIC FIELD POINTS ALONG THE MINUS Z AXIS. THE TIMING-
C---     BINS-TO-MILLIMETERS CONVERSION FACTORS ARE ALL SET TO 0.382
C---     AND THE EFFECTIVE LENGTH OF THE WIRES TO 2792.9, BOTH VALUES
C---     OBTAINED FROM MR. NOSAKI TODAY.
C---                                   TUESDAY, MARCH 27, 1979
C---                                   L.H. O'NEILL
C---     ADDED: BKGAUS = -4.9          J.OLSSON 2.4.79
C---     DIVIDED TIMDELS BY 64.        L.H. O'NEILL 11 JUNE, 1979.
C---     UPDATED SETTING OF BKGAUS, CALL TO INPATR OUT
C---                                   J.OLSSON 23.6.79
C---
C---     NEW VERSION SETS WIRE STAGGERING TO 200 MICRONS INSTEAD OF
C---     150 AND INCREASES WIRE RADII BY 0.5 MM.
C---
C---                                   L.O'NEILL 02.08.79 14.50
C---     BKGAUS IS TESTED UPON TO INSURE THAT IT IS NEGATIVE
C---                                   J OLSSON 18.08.79
C---     MANY CHANGES IN ALFA AND TZERO VALUES , NOZAKIS NEW CONSTANTS
C---     INTRODUCED 14.9.80                 J.OLSSON
C---     LORENTZ ANGLE VARIES WITH MAGNETC FIELD VALUE IF VARIATION
C---     IF VARIATION > 1%                  P.STEFFEN 81/05/12
C---     YEAR UPDATE FOR RUNS 7417-28       J.OLSSON 81/05/29
C---     29 FEBRUARY UPDATE                 J.OLSSON 81/06/05
C---  NEW 81 RUNS WITH YEAR 0 DISCOVERED, CORRECTED  J.OLSSON 81.06.22
C---
C---     T0 + LORENZ ANGLES FOR 1981              P. STEFFEN 81/10/09
C---
C---  NOZAKI POINTED OUT THAT THE STATEMENT GO TO 8 IS MISSING BETWEEN
C---  1981 AUTUMN AND 1982  T0 SETTING    THIS LEADS TO 1982 CONSTANTS
C---  BEING USED FOR 1981 AUTUMN DATA !!!!
C---  CHANGED THIS EVENING,  12.3.1982     J.OLSSON
C---
C---  E-BEAM SET TO 17300 MEV FOR RUN 11790       P. STEFFEN 82/09/21
C---
C---
C---  NEW TWANG, DRIVELS AND T0 ADDED FOR RUNS > 11036
C---  OLD VERSION RETAINED AS KALIBR0 !!!!
C---                                             G.F.PEARCE 18/05/82
C---
C---  RUNS > 10000 : YEAR FORCED TO 1982
C---                                             P. STEFFEN 82/06/15
C---
C---
C---     T0 FOR 1982 (CORRECTED)                 P. STEFFEN 82/06/21
C---
#include "cdata.for"
#include "cgeo1.for"
#include "cjdrch.for"
C------
      COMMON /CJTRIG/ PI,TWOPI
      COMMON /CALIBR/ IPOINT(100)
      DIMENSION XCAL(1000)
      EQUIVALENCE (IPOINT(1),XCAL(1))
C---
      DATA OKGAUS /9999999./
      DATA TWANG /9999999./
C
C2001 FORMAT('0KALIBR:',10F10.5)
C2901 FORMAT('KALIBR',/,(1X,12F8.5))
C
      IPHEAD=IDATA(IBLN('HEAD'))
      IHHEAD=IPHEAD*2
      NRUN=HDATA(IHHEAD+10)
C---     FIX YEAR SCREW UP.
         IYEAR = HDATA(IHHEAD+8)
         IF(NRUN.LT.  100.AND.IYEAR.EQ.1982) HDATA(IHHEAD+8)=1981
         IF(NRUN.LT.  100.AND.IYEAR.EQ.1982) HDATA(IHHEAD+7)=1
         IF(NRUN.GE. 2570.AND.NRUN.LE.2802) HDATA(IHHEAD+8)=1980
         IF(NRUN.GT. 6000.AND. IYEAR.LT.1981) HDATA(IHHEAD+8)=1981
         IF(NRUN.GT.10000.AND. IYEAR.LT.1982) HDATA(IHHEAD+8)=1982
         IF(HDATA(IHHEAD+8).EQ.1984) GO TO 5410
C FIX 29 FEBRUARY 1981 SCREW UP
         IF(HDATA(IHHEAD+7).NE.2) GO TO 5410
         IF(HDATA(IHHEAD+6).EQ.29) HDATA(IHHEAD+7) = 3
         IF(HDATA(IHHEAD+6).EQ.29) HDATA(IHHEAD+6) = 1
5410     IF(NRUN.EQ.11908) HDATA(IHHEAD+30) = -4848
         IF(NRUN.LT.12255.OR.NRUN.GT.12270) GO TO 5411
C    RESET MAGNETIC FIELD FOR PERIOD WHEN READ OUT SET IT TO 0
         HDATA(IHHEAD+30) = -4847
5411     IF(NRUN.LT.10000.OR.NRUN.GT.12500) GO TO 5408
C        SET BEAM ENERGY FOR RUN 11790
         IF(NRUN.EQ.11790) HDATA(IHHEAD+29) = 17300
      IFIELD = HDATA(IHHEAD+30)
      IF(IABS(IFIELD).LT.100) WRITE(6,5407) NRUN,HDATA(IHHEAD+30)
5407  FORMAT(' * ## ## ## ## *   WARNING: RUN ',I6,' HAS MAGNETIC FIELD
     $ = ',I6,' GAUSS ')
5408  CALL KLREAD(KALRET)
      IF(KALRET.NE.0) STOP
C---
      CALL MUREG(0)
      IF(NRUN.LE.0) RETURN
      BKGAUS = .001*HDATA(IHHEAD+30)
      IF(BKGAUS.GT.0.) BKGAUS = - BKGAUS
      MAGON=1
      IF(ABS(BKGAUS).LT.1.) MAGON=0
C ---
C ---
C ---     SET TZERO PER RING
C ---
C ---
      TZERO(1)=-3.9
      TZERO(2)=-3.9
      TZERO(3)=-3.0
      IF(NRUN.LT.1497) GO TO 1000
      TZERO(1)= 2.4
      TZERO(2)= 2.4
      TZERO(3)= 2.4
      IF(NRUN.LT.1967) GO TO 1000
      TZERO(1)=0.2
      TZERO(2)=0.2
      TZERO(3)=0.2
      IF(NRUN.LT.2521) GO TO 1000
      TZERO(1)=-2.5
      TZERO(2)=-2.5
      TZERO(3)=-2.5
      IF(NRUN.LT.3730) GO TO 1000
      TZERO(1)=-6.1
      TZERO(2)=-6.1
      TZERO(3)=-6.1
      IF(NRUN.LT.6185) GO TO 1000
      TZERO(1)=1.20
      TZERO(2)=1.20
      TZERO(3)=1.20
      IF(NRUN.LT.7592) GO TO 1000
      TZERO(1)=1.45
      TZERO(2)=1.45
      TZERO(3)=1.45
      IF(NRUN.LT.10000) GO TO 1000
      TZERO(1)=3.60
      TZERO(2)=3.60
      TZERO(3)=3.60
      IF(NRUN.LT.10267) GO TO 1000
      TZERO(1)=1.60
      TZERO(2)=1.60
      TZERO(3)=1.60
      IF(NRUN.LT.11038) GOTO 1000
      TZERO(1)=1.80
      TZERO(2)=1.80
      TZERO(3)=1.80
 1000 CONTINUE
C ---
C ---
C ---     SET DRIFT VELOCITIES
C ---
C ---
      DO 2000 I=1,3
      IF(NRUN.GE.6185) GO TO 1100
      RNGTM1=0.3769/64.
      RNGTM2=0.3753/64.
      RNGTM3=0.3826/64.
      GO TO 1200
 1100 IF(NRUN.GE.7592) GO TO 1101
      RNGTM1=0.3784/64.
      RNGTM2=0.3773/64.
      RNGTM3=0.3827/64.
      GOTO 1200
 1101 IF(HDATA(IHHEAD+8).GE.1982) GOTO 1102
      RNGTM1=0.3817/64.
      RNGTM2=0.3799/64.
      RNGTM3=0.3856/64.
      GOTO 1200
 1102 IF(NRUN.GE.11037) GOTO 1103
      RNGTM1=0.3845/64.
      RNGTM2=0.3825/64.
      RNGTM3=0.3882/64.
      GOTO 1200
 1103 CONTINUE
      RNGTM1=0.3813/64.
      RNGTM2=0.3791/64.
      RNGTM3=0.3858/64.
 1200 CONTINUE
      ICLMIN=1+24*(I-1)
      ICLMAX=24*I
      IF(I.EQ.3) ICLMAX=96
C
      TIMDEL(1,1)=RNGTM1
      TIMDEL(2,1)=RNGTM1
      TIMDEL(1,2)=RNGTM2
      TIMDEL(2,2)=RNGTM2
      TIMDEL(1,3)=RNGTM3
      TIMDEL(2,3)=RNGTM3
      DO 2000 K=1,24
         DRIVEL(K   ,1)=RNGTM1
         DRIVEL(K   ,2)=RNGTM1
         DRIVEL(K+24,1)=RNGTM2
         DRIVEL(K+24,2)=RNGTM2
         DRIVEL(K+48,1)=RNGTM3
         DRIVEL(K+48,2)=RNGTM3
         DRIVEL(K+72,1)=RNGTM3
         DRIVEL(K+72,2)=RNGTM3
 2000 CONTINUE
C ---
C ---
C ---  SET NOMINAL LORENTZ ANGLE + MAGNETIC FIELD
C ---
C ---
C
      IF(NRUN.GE.3730)GOTO2100
      TWANG=18.5
      AKGAUS =-4.50
      IF(NRUN.GE.2521) TWANG=19.5
      GOTO 3000
C
 2100    AKGAUS =-4.82
         TWANG=21.0
         IF(NRUN.LT.6185) GOTO 3000
         IF(NRUN.GE.6185) TWANG=20.5
         IF(NRUN.GE.7592) TWANG=19.5
         IF(HDATA(IHHEAD+8).GE.1982) TWANG = 20.5
      IF(NRUN.GE.11037) TWANG=21.25
 3000 CONTINUE
      DRIDEV=-MAGON*TWANG*PI/180.

C
C     CHECK IF CHANGE OF MAG. FIELD
      DALF = 0.
      IF(BKGAUS.EQ.OKGAUS) GOTO 10
         OKGAUS = BKGAUS
         IF(ABS((BKGAUS-AKGAUS)/AKGAUS).LT..01) GOTO 10
         DALF = ASIN(SIN(DRIDEV)*BKGAUS/AKGAUS) - DRIDEV
   10 CONTINUE
C     PRINT 2001, OKGAUS,BKGAUS,AKGAUS,DRIDEV,TWANG,TWANG0,DALF
C
C     CHECK IF ANY CHANGE IN LORENTZ ANGLE
      IF(TWANG.EQ.TWANG0 .AND. DALF.EQ.0.) GOTO 20
      TWANG0 = TWANG
C
         DRIDEV=-MAGON*TWANG*PI/180. + DALF
         DRISIN=SIN(DRIDEV)
         DRICOS=COS(DRIDEV)
         ANGLOR = TWANG*PI/180. - DALF
C        PRINT 2001, DRIDEV,DRISIN,DRICOS,TWANG,DALF
C
         IPCAL = IPOINT(5)
         IPCAL = IPCAL + 960
         DO 2 J=1,96
            ALFCOR = XCAL(IPCAL+J)
            ANGLR1 = ANGLOR + ALFCOR
            ANGLR1= - MAGON*ANGLR1
            SINLOR=SIN(ANGLR1)
            COSLOR=COS(ANGLR1)
            DRIROT(J,1)=ANGLR1
            SINDRI(J,1)=SINLOR
            COSDRI(J,1)=COSLOR
            DRIROT(J,2)=ANGLR1
            SINDRI(J,2)=SINLOR
            COSDRI(J,2)=COSLOR
    2    CONTINUE
   20 CONTINUE
C
      ZAL=2792.9
      FIRSTW(1)=206.50
      FIRSTW(2)=416.50
      FIRSTW(3)=627.83
      FSENSW(1)=211.50
      FSENSW(2)=421.50
      FSENSW(3)=632.83
      ABERR(1) = 0.000217
      ABERR(2) = 4.0
      ABERR(3) = 6.8
      ABERR(5) = .048
      ABERR(6) = .000167
      ABERR(7) = 15.0
      ABERR(8) = 1.0
      IF(MAGON.EQ.0) ABERR(2) = 5.
      IF(MAGON.EQ.0) ABERR(3) = 5.
C
C     PRINT 2901,TIMDEL,DRIDEV,DRISIN,DRICOS
C     PRINT 2901,DRIVEL
C     PRINT 2901,DRIROT,SINDRI,COSDRI
C
      RETURN
      END
