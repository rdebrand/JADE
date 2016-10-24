C   08/06/82 206091807  MEMBER NAME  TFAR82F  (S)           FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
        SUBROUTINE TFARNW(INLA,INTF,IFLG,*)
C==================================================
C  MODIFIED TO CHECK ON TDCS INSTEAD OF LATCHES
C==================================================
C          CONVERTS THE TOF DATA FROM CAMAC FORMAT
C       TO ANALYSIS FORMAT :
C                   IRAW(1,NCN)= NCN  ; COUNTER#
C      RAW(2,NCN)= TDC(-)-CM(NCN)
C      RAW(3,NCN)= TDC(+)-CP(NCN)
C       OR
C      RAW(2,NCN)= TDC(-) , IF IFLG= 1.
C      RAW(3,NCN)= TDC(+) , IF IFLG= 1.
C                   RAW(4,NCN) = ADC(-)
C                   RAW(5,NCN) = ADC(+)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CC
      IMPLICIT INTEGER*2 (H)
#include "tfadc.for"
#include "tfprm1.for"
#include "tcalcm1.for"
      COMMON/PRPOS/PRPLS,CPOS
      COMMON /CHEADR/ IHEADR(54)
      EQUIVALENCE (IHEADR(1),HEADR(1))
      DIMENSION HEADR(108),LIST1(2),LIST(19)
C
C
      DATA IENTRY/ 0/,IBUG/ 0/
      DATA ADCLIM/1./
      NRUN = HEADR(18)
      IF(IENTRY.NE.0)  GOTO 320
      IENTRY = IENTRY + 1
C     PRINT 101,NRUN
C     PRINT 102,TCALM2
C     PRINT 102,TCALP2
C     PRINT 102,TCPDM
C     PRINT 102,TCPDP
C     PRINT 102,TCPDM2
C     PRINT 102,TCPDP2
C 102 FORMAT(/(1X,10F10.3))
C 101 FORMAT(' ADDITIONAL CALIBRATION CONSTANTS FOR RUN ',I5)
C
 320  CONTINUE
C
C========= ADDRESSING
C
C     CALL SETSL(RAW,0,20*42,0)
      CPOS = HEADR(31)/1000.
       INLA2= INLA*2
       INTF2= INTF*2
       IL0= INLA2+6
       IA0= INTF2+3
       IT0= INTF2+94
C//////////
      IBUG = IBUG + 1
      BADC = TPARM(1)
      AADC = TPARM(2)
      CALL ATOFUN(INTF)
C     IF(IBUG.LE.10) CALL ATOFPR(INTF)
C
      DO 3000 NCN= 1,42
      IRAW(1,NCN) = 0
      MONE = 0
      ADCM = HADC(1,NCN)- PEDLM(NCN)
      ADCP = HADC(2,NCN)-PEDLP(NCN)
C
C========= CHECK THAT BOTH TDC'S HAVE FIRED
C          UNLESS ONE IS BROKEN
      HSTAT(NCN) = MONE
      IF(MONE.EQ.2)  GOTO  32
      IF(HTDC(1,NCN).LT. 5.OR.HTDC(1,NCN).GE.2048)  GOTO  3000
      IF(MONE.EQ.1)  GOTO  1500
   32 IF(HTDC(2,NCN).LT. 5.OR.HTDC(2,NCN).GE.2048)  GOTO  3000
C
C
C========= THEY HAVE
C
 1500 CONTINUE
      TDCM = HTDC(1,NCN)
      TDCP = HTDC(2,NCN)
      TDCM2 = HTDC1(1,NCN)
      TDCP2 = HTDC1(2,NCN)
C
C  COMPUTE PULSEHEIGHT CORRECTION FOR TOF
C
      CORADM = 0.
      CORADP = 0.
      IF(HADC(1,NCN).GE.1024) ADCM = 1024.
      IF(HADC(2,NCN).GE.1024) ADCP = 1024.
      IF(ADCM.LE.1.) ADCM = 1.
      IF(ADCP.LE.1.) ADCP = 1.
      ADCMIV = 1000./ADCM
      ADCPIV = 1000./ADCP
      CORADM =   CADCB(2*NCN-1)*SQRT(ADCMIV)
      CORADP =   CADCB(2*NCN  )*SQRT(ADCPIV)
      IF(CORADM.GT.5.) CORADM = 5.
      IF(CORADP.GT.5.) CORADP = 5.
   20 CONTINUE
      CMS = CORNOR(2*NCN-1)
      CPS = CORNOR(2*NCN)
C
      IF(IBUG.LE.10)PRINT106,NCN,TDCM,TDCP,CMS,CPS,TCALM(NCN),TCALP(NCN)
      IF(IBUG.LE.10) PRINT 106,NCN,ADCM,ADCP,PEDLM(NCN),PEDLP(NCN),
     1 CADCB(2*NCN-1),CADCB(2*NCN),ADCMIV,ADCPIV
  106 FORMAT(' TOFARD',I5,10F10.3)
      IF(TDCM.LT.5..OR.TDCM.GE.2048.)  GOTO  2000
      TDCM0= TDCM
      TDCM20= TDCM2
      IF(IFLG.EQ.1) GO TO 1600
      TDCM0= TDCM0*TCALM(NCN)
      TDCM0= TDCM0-CMS-CORADM
C     IF(TDCM2.GE.5.AND.TDCM2.LT.2048.)
C    *TDCM20= TDCM2*TCALM2(NCN)-TCPDM2(NCN)-42.5
      IF(IBUG.LE.10) PRINT 106,NCN,TDCM,TDCM0,TDCM2,TDCM20
 1600 IRAW(1,NCN)= NCN
      RAW(2,NCN)= TDCM0
      RAW(4,NCN)= ADCM
C     IF(TDCM2.GE.5.AND.TDCM2.LT.2048.)RAW2(1,NCN) = TDCM20
C
 2000 CONTINUE
      IF(TDCP.LT.5..OR.TDCP.GE.2048.)  GOTO  2050
C     IF(ADCP.LT.ADCLIM)  GOTO  2100
      TDCP0= TDCP
      TDCP20= TDCP2
      IF(IFLG.EQ.1) GO TO 2050
2010  TDCP0= TDCP0*TCALP(NCN)
      TDCP0= TDCP0-CPS-CORADP
C     IF(TDCP2.GE.5.AND.TDCP2.LT.2048.)
C    *TDCP20= TDCP2*TCALP2(NCN)-TCPDP2(NCN)-42.5
      IF(IBUG.LE.10) PRINT 106,NCN,TDCP,TDCP0,TDCP2,TDCP20
2050  IRAW(1,NCN)= NCN
      RAW(3,NCN)= TDCP0
      RAW(5,NCN)= ADCP
C     IF(TDCP2.GE.5.AND.TDCP2.LT.2048.) RAW2(2,NCN) = TDCP20
2100  CONTINUE
C
 3000 CONTINUE
C/////////
      RETURN
      END