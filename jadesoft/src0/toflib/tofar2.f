C   30/03/79 008181705  MEMBER NAME  TOFAR2                 FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
        SUBROUTINE TOFAR2(INLA,INTF,IFLG,*)
C
C          CONVERTS THE TOF DATA FROM CAMAC FORMAT
C       TO ANALYSIS FORMAT :
C                   IRAW(1,NCN)= NCN  ; COUNTER#
C      RAW(2,NCN)= TDC(-)-CM(NCN)-WM(NCN)*(1./SQRT(A0M)-1./SQRT(ADC(-)))
C      RAW(3,NCN)= TDC(+)-CP(NCN)-WP(NCN)*(1./SQRT(A0M)-1./SQRT(ADC(+)))
C       OR
C      RAW(2,NCN)= TDC(-) , IF IFLG= 1.
C      RAW(3,NCN)= TDC(+) , IF IFLG= 1.
C                   RAW(4,NCN) = ADC(-)
C                   RAW(5,NCN) = ADC(+)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CC
#include "ddata.for"
      INTEGER *2  HADC,HTDC,HB,HEADR(108)
      REAL *8 DYC1,DYC2
      COMMON/TFPRM/ NRNC1,NRNC2,DYC1,DYC2,IFLC(42),CM(42),CP(42),
     -DTAU(42),WM(42),WP(42),SV(42),DM(42),DP(42),PEDLM(42),PEDLP(42)
      COMMON/CWORK/NR,RAW(5,42),NC,ICRT1(5,42),NTRK,ICRT2(50),TRK(5,50)
     - ,ITRC(50),NTC,ITRK(5,42),INFM(4),IR(14,50)
      COMMON/TFPED/ HADC(2,42),HTDC(2,42),HB(42)
      COMMON /CHEADR/ IHEADR(54)
      EQUIVALENCE (IHEADR(1),HEADR(1))
      DIMENSION MASK(16)
      DIMENSION CORADC(20)
      DIMENSION IRAW(5,42)
      EQUIVALENCE (IRAW(1,1),RAW(1,1))
C
      DATA MASK/1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,
     1          16384,32768/
      DATA CORADC/1.9,2.45,2.8,3.0,3.15,3.3,3.35,3.45,3.5,3.55,3.55,
     1            3.6,8*3.6/
      DATA IENTRY/0/,LERR/0/,IBUG/ 0/,JBUG/10/
      IF(IENTRY.NE.0)  GOTO 320
      IENTRY = IENTRY + 1
C
 320  CONTINUE
C
C========= ADDRESSING
C
      IBUG = IBUG + 1
      JBUG = JBUG + 1
      NRUN = HEADR(18)
       IER= 0
       INLA2= INLA*2
       INTF2= INTF*2
       IL0= INLA2+6
       IA0= INTF2+3
       IT0= INTF2+94
C//////////
C
        NUM= 0
        DO 3000 NCN= 1,42
      IRAW(1,NCN) = 0
C
C========= ADDRESS OF ADC AND TDC FOR COUNTER# NCN
C
        NCN2= NCN*2
        IAA= (NCN-1)/6+NCN2+IA0-2
        IAT= (NCN-1)/4+NCN2+IT0-2
        IAA1= IAA+1
        IAT1= IAT+1
        HADC(1,NCN)= HDATA(IAA)
        HADC(2,NCN)= HDATA(IAA1)
      ADCM = HDATA(IAA) - PEDLM(NCN)
      ADCP = HDATA(IAA1) - PEDLP(NCN)
      IF(NRUN.LE.2306.OR.NCN.LE.38)  GOTO  75
      ADCM = ADCM*2
      ADCP = ADCP*2
   75 HTDC(1,NCN)= HDATA(IAT)
      HTDC(2,NCN)= HDATA(IAT1)
      TDCM = HTDC(1,NCN)
      TDCP = HTDC(2,NCN)
C
C========= CHECK OF LATCHED BIT
C
        NW= (NCN-1)/7+IL0
        MDATA= HDATA(NW)
        IF(MDATA) 100,3000, 100
 100    NORD= MOD(NCN,7)
      IF(NORD.EQ.0) NORD = 7
      IF(LAND(MDATA,MASK(NORD)).GT.0)  GOTO  1500
      GOTO  3000
C
C========= BIT WAS SET
C
 1500 CONTINUE
C
C  COMPUTE PULSEHEIGHT CORRECTION FOR TOF
C
      IF(ADCM.LE.0.) ADCM = 1.
      IF(ADCP.LE.0.) ADCP = 1.
      ADCMIV = 1000./ADCM
      ADCPIV = 1000./ADCP
      INDM = IFIX(ADCMIV/.5) + 1
      IF(INDM.LT.2) INDM = 2
      IF(INDM.GT.13) INDM= 13
      CORADM = (CORADC(INDM)-CORADC(INDM-1))/.5*(ADCMIV-(INDM-1)*.5)
     1         + CORADC(INDM-1)
      INDP = IFIX(ADCPIV/.5) +1
      IF(INDP.LT.2) INDP = 2
      IF(INDP.GT.13) INDP= 13
      CORADP = (CORADC(INDP)-CORADC(INDP-1))/.5*(ADCPIV-(INDP-1)*.5)
     1         + CORADC(INDP-1)
      CORADM = CORADM-3.
      CORADP = CORADP-3.
C     IF(IBUG.LE.10) PRINT 501,NCN,HTDC(1,NCN),HTDC(2,NCN),HADC(1,NCN)
C    1 ,HADC(2,NCN)
C 501 FORMAT(' TOFARD',10I10)
      IF(TDCM.LT.10..OR.TDCM.GT.2048.)  GOTO  2000
      TDCM0= TDCM
      IF(IFLG.EQ.1) GO TO 1600
 1510 TDCM0= TDCM0*DM(NCN)
      TDCM0= TDCM0-CM(NCN)-CORADM
C     IF(IBUG.LE.10) PRINT 502,TDCM0,DM(NCN),CM(NCN),CORADM
C 502 FORMAT(7X, 8F12.5)
 1600 IRAW(1,NCN)= NCN
      RAW(2,NCN)= TDCM0
      RAW(4,NCN)= ADCM
C
 2000 IAA1= IAA+1
      IAT1= IAT+1
      IF(TDCP.LT.10.OR.TDCP.GT.2048.)  GOTO  2100
      TDCP0= TDCP
      IF(IFLG.EQ.1) GO TO 2050
2010  TDCP0= TDCP0*DP(NCN)
      TDCP0= TDCP0-CP(NCN)-CORADP
C     IF(IBUG.LE.10) PRINT 502,TDCP0,DP(NCN),CP(NCN),CORADP
2050  IRAW(1,NCN)= NCN
      RAW(3,NCN)= TDCP0
      RAW(5,NCN)= ADCP
2100  CONTINUE
C
 3000 CONTINUE
C/////////
      RETURN
      END
