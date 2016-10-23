C   26/09/81 404191120  MEMBER NAME  TOFMAS3  (S)           FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       SUBROUTINE TOFMAS
C
C  THIS IS THE CALIBRATION VERSION      ********************
C
C  DETERMINES TOF FOR EACH TRACK AND ITS QUALITY
C  CREATES BANK TOFR
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
#include "tcalcm1.for"
#include "tfprm.for"
#include "ddata.for"
#include "chead.for"
      COMMON/PRPOS/PRPLS,CPOS
      DIMENSION IAGREE(3),ZT(2),TMNUS(2),TPLUS(2),DELT(2)
      DIMENSION CORM(84),CM1(84)
C
      DATA IENTRY/0/,IBUG/0/,NEXIST/0/
      DATA CVEL/ 2.9979246E2/,DTAU1/1./
      DATA RADTOF/920./
      DATA IRUN/0/,CORM/84*0./
C
      IF(IENTRY.NE.0)  GOTO 66
      IENTRY = IENTRY + 1
      ZA = 10000
      ZB = 11000
C     CALL CNTFIT(1,I,TM,TP,T)
C     READ(16) CM1
C     DO   19   I=1,84
C  19 CORM(I) = CM1(I)
C     PRINT 232,CM1
C 232 FORMAT(' CM1  '/(1X,10F10.3))
C     PRINT 232,CORM
      ID = 2500
      CALL HTABLE(ID,' TOF CNTR FLAG $',42,0.,42.,3,-1.,1.,511.)
      CALL HBOOK1(ID+54,' TAUM1         $',100,-7.,13.)
      CALL HBOOK1(ID+55,' TAUP1         $',100,-7.,13.)
      CALL HBOOK1(ID+52,' TOF1         $',100,-2.,8.)
      CALL HBOOK2(ID+50,' TAUM1 ITOF $',100,-10.,10.,42,0.,42.)
      CALL HBOOK2(ID+51,' TAUP1 ITOF $',100,-10.,10.,42,0.,42.)
      CALL HBOOK2(ID+53,' TAUM1-TAUP1 ITOF $',100,-10.,10.,42,0.,42.)
      CALL HBPROX(ID+53)
      CALL HBOOK2(ID+60,' NRUN TM    $',100,ZA,ZB,40,0.,10.)
      CALL HBOOK2(ID+90,' NRUN TP    $',100,ZA,ZB,40,0.,10.)
   66 ZTOF = 0.
C
      NRUN = HEADR(18)
   10 IRUN = NRUN
C
      ZTOF1 = 0.
      NNG= 0
      NOK= 0
      CALL SETSL(IW,0,704*4,0)
      CALL SETSL(TAUM,0,84*4,0.)
      IBUG = IBUG + 1
      NTRR = 0
      IRESET = 0
C
      DO 1000 I=1,42
      MTPY= ICRT1(2,I)
      IF(MTPY.EQ.0) GO TO 1000
      IF(MTPY.GE.4) MTPY = 3
C
      DO   1001   M=1,MTPY
      NTR1= ICRT1(M+2,I)
C
      ZTOF1 = -2000.
      ADCM = HADC(1,I) - PEDLM(I)
      ADCP = HADC(2,I) - PEDLP(I)
      IF(ADCM.LE.0.) ADCM = 1.
      IF(ADCP.LE.0.) ADCP = 1.
      IF(HADC(1,I).GT.1024) ADCM = 1024.
      IF(HADC(2,I).GT.1024) ADCP = 1024.
      Z1= TRK(1,NTR1)
      PATH1= TRK(3,NTR1)
      PMEV1= TRK(4,NTR1)
      TAUP1= RAW(3,I)+Z1/VELSC
      TAUM1= RAW(2,I)-Z1/VELSC
      TAUM1 = TAUM1 - (TPARM(7)*PATH1+TPARM(8))
      TAUP1 = TAUP1 - (TPARM(7)*PATH1+TPARM(8))
C     PCOR = (PATH1-RADTOF)/CVEL
C     TAUM1 = TAUM1 - PCOR
C     TAUP1 = TAUP1 - PCOR
      TAUM1 = TAUM1 - TPARM(25)
      TAUP1 = TAUP1 - TPARM(25)
C
      NFLG= -1
      IF(HTDC(1,I).GT.10.AND.HTDC(1,I).LT.2048) GO TO 320
      TOF1= TAUP1
      TAUM1= -20.
      GO TO 360
C
  320 CONTINUE
      IF(HTDC(2,I).GT.10.AND.HTDC(2,I).LT.2048) GO TO 330
      TOF1= TAUM1
      TAUP1= -20.
      GO TO 360
C
  330 CONTINUE
C     CALL HFILL(ID+53,TAUM1-TAUP1,FLOAT(I))
      IF(ABS(TAUM1-TAUP1).LE.3.*DTAU1) GO TO 350
      IF(Z1.LT.0.) GO TO 340
      TOF1= TAUP1
      GO TO 360
 340  TOF1= TAUM1
      GO TO 360
C
 350  NFLG= 1
C
      VWM = TPARM(9)/ADCM+TPARM(10)
      VWP = TPARM(9)/ADCP+TPARM(10)
      VWM = 1./(VWM*VWM)
      VWP = 1./(VWP*VWP)
      TOF1 = (VWM*TAUM1+VWP*TAUP1)/(VWM+VWP)
      ZTOF1 =  (RAW(2,I)-RAW(3,I))/2.*VELSC
 360  CONTINUE
      CALL HFILL(ID,FLOAT(I),FLOAT(NFLG))
      IF(HSTAT(I).NE.2) CALL HFILL(ID+50,TAUM1,FLOAT(I))
      IF(HSTAT(I).NE.1) CALL HFILL(ID+51,TAUP1,FLOAT(I))
      IF(HSTAT(I).NE.2) CALL HFILL(ID+54,TAUM1,1.)
      IF(HSTAT(I).NE.1) CALL HFILL(ID+55,TAUP1,1.)
      IF(HSTAT(I).NE.2) CALL HFILL(ID+60,FLOAT(NRUN),TAUM1)
      IF(HSTAT(I).NE.1) CALL HFILL(ID+90,FLOAT(NRUN),TAUP1)
      IF(HSTAT(I).NE.2) CALL HFILL(ID+60+I,FLOAT(NRUN),TAUM1)
      IF(HSTAT(I).NE.1) CALL HFILL(ID+70+I,FLOAT(NRUN),TAUP1)
      TMFIT = TAUM1 - 3.07
      TPFIT = TAUP1 - 3.07
      TFIT = TOF1 - 3.07
C     CALL CNTFIT(2,I,TAUM1,TAUP1,TOF1)
      CALL HF1(ID+52,TOF1,1.)
      NTRR = NTRR + 1
      IF(NTRR.GT.50)  GOTO  1001
      TAUM(I) = TAUM1
      TAUP(I) = TAUP1
      TDCM = HTDC(1,I)
      TDCP = HTDC(2,I)
      CALL TFSTOR(NTRR,NTR1,NFLG,I,TOF1,PATH1,TDCM,TDCP,ADCM,ADCP,
     -            TAUM1,TAUP1,ITRC(NTR1),0.,ZTOF1)
      NOK= NOK+1
C
 1001 CONTINUE
 1000 CONTINUE
C
C=========   HEADER PART
C
                 NXX= 0
                 DO 2000 I=1,NTRR
                 IF(IRELT(1,I).NE.0) GO TO 2000
                 CALL TFSTOR(I,10,0,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.)
                 NXX= NXX+1
 2000            CONTINUE
            INFM(1)= NTRR
            INFM(2)= NOK
            INFM(3)= NNG
            INFM(4)= NXX
            LTFR= 14*NTRK+4
C
C=========   STORE RESULT INTO CURRENT BUFFER
C
      CALL BCRE(INTR,'TOFR',0,LTFR,&3000,IER)
      IF(INTR.EQ.0.AND.IER.EQ.2) GO TO 3000
      IF(IER.NE.0) NEXIST = NEXIST + 1
      IF(IER.NE.0.AND. NEXIST.LE.5) PRINT 301,NEXIST
  301 FORMAT('  &*&*&*&*&   TOFR BANK ALREADY EXISTS ,OVERWRITTEN',I5)
      CALL BSTR(INTR,IW,LTFR)
      CALL BSAT(1,'TOFR')
      RETURN
 3000 CONTINUE
C/////////
             WRITE(6,9300)
9300         FORMAT(1X,'BOS ERROR IN TOFMAS')
       RETURN
       END
