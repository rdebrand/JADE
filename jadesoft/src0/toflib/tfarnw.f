C   11/01/81 704021959  MEMBER NAME  TFARNW   (S)           FORTRAN
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
#include "tfprm.for"
#include "tfadc.for"
      COMMON/PRPOS/PRPLS,CPOS
      INTEGER *2  HADC,HTDC,HEADR(108),HTDC1,HON1,HTSPAR
      COMMON/CWORK/NR,RAW(5,42),NC,ICRT1(5,42),NTRK,ICRT2(50),TRK(5,50)
     - ,ITRC(50),NTC,ITRK(5,42),INFM(4),IR(14,50)
      COMMON/TFPED/ HADC(2,42),HTDC(2,42)
      COMMON/TFPED1/HTDC1(2,42),HON1(42),HTSPAR(16)
      COMMON /CHEADR/ IHEADR(54)
      EQUIVALENCE (IHEADR(1),HEADR(1))
      DIMENSION MASK(16)
      DIMENSION IRAW(5,42)
      EQUIVALENCE (IRAW(1,1),RAW(1,1))
C
      DATA MASK/1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,
     1          16384,32768/
      DATA IENTRY/0/,LERR/0/,IBUG/0/
      DATA ADCLIM/1./
      IF(IENTRY.NE.0)  GOTO 320
      IENTRY = IENTRY + 1
C
 320  CONTINUE
C
C========= ADDRESSING
C
C     CALL SETSL(RAW,0,20*42,0)
      NRUN = HEADR(18)
      CPOS = HEADR(31)/1000.
       INLA2= INLA*2
       INTF2= INTF*2
       IL0= INLA2+6
       IA0= INTF2+3
       IT0= INTF2+94
C//////////
C     IBUG = IBUG + 1
      BADC = TPARM(1)
      AADC = TPARM(2)
      CALL ATOFUN(INTF)
C
      DO 3000 NCN= 1,42
      IRAW(1,NCN) = 0
      ADCM = HADC(1,NCN)- PEDLM(NCN)
      ADCP = HADC(2,NCN)-PEDLP(NCN)
      IF(NRUN.LE.2306.OR.NCN.LE.38)  GOTO  75
      IF(NRUN.GE.3182)  GOTO  75
      ADCM = ADCM*2
      ADCP = ADCP*2
   75 CONTINUE
C
      IF(NCN.NE.25.AND.NCN.NE.26)  GOTO  76
      IF(NRUN.LT.3728.OR.NRUN.GT.4426)  GOTO  76
      ITDC25 = HTDC(1,25)
      ITDC26 = HTDC(1,26)
      IF(NCN.EQ.25) HTDC(1,25) = ITDC26
      IF(NCN.EQ.26) HTDC(1,25) = ITDC25
   76 CONTINUE
      TDCM = HTDC(1,NCN)
      TDCP = HTDC(2,NCN)
C NEW FOR 1986
      IF(NRUN.GE.24200)
     &TDCM = HTDC(1,NCN)-HTSPAR(3)+465.
      IF(NRUN.GE.24200)
     &TDCP = HTDC(2,NCN)-HTSPAR(3)+465.
C
C========= CHECK THAT BOTH TDC'S HAVE FIRED
C
      IF(HTDC(1,NCN).LT. 5.OR.HTDC(1,NCN).GE.2048)  GOTO  3000
      IF(HTDC(2,NCN).LT. 5.OR.HTDC(2,NCN).GE.2048)  GOTO  3000
C
C========= THEY HAVE
C
 1500 CONTINUE
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
      CORADM =  AADC + BADC*ADCMIV
      CORADP =  AADC + BADC*ADCPIV
      IF(NRUN.LT.3728)  GOTO  20
      CORADM =   CADCB(2*NCN-1)*SQRT(ADCMIV)
      CORADP =   CADCB(2*NCN  )*SQRT(ADCPIV)
   20 IF(ADCM.LT.1024.) CMS = CORNOR(2*NCN-1)
      IF(ADCP.LT.1024.) CPS = CORNOR(2*NCN)
      IF(ADCM.GE.1024.) CMS = COROVF(2*NCN-1)
      IF(ADCP.GE.1024.) CPS = COROVF(2*NCN)
C
C     IF(IBUG.LE.10) PRINT 106,NCN,CADCA(2*NCN-1),CADCB(2*NCN-1),
C    1 CADCA(2*NCN),CADCB(2*NCN)
C     IF(IBUG.LE.10) PRINT 106,NCN,ADCM,ADCP,CORADM,CORADP,CMS,CPS
C 106 FORMAT(' TOFARD',I5,10F10.3)
      IF(TDCM.LT.10..OR.TDCM.GT.2048.)  GOTO  2000
      IF(ADCM.LT.ADCLIM)  GOTO  2000
      TDCM0= TDCM
      IF(IFLG.EQ.1) GO TO 1600
      TDCM0= TDCM0*TCALM(NCN)
      TDCM0= TDCM0-CMS-CORADM
C     IF(IBUG.LE.10) PRINT 106,NCN,TDCM0
 1600 IRAW(1,NCN)= NCN
      RAW(2,NCN)= TDCM0
      RAW(4,NCN)= ADCM
C
 2000 CONTINUE
      IF(TDCP.LT.10..OR.TDCP.GT.2048.)  GOTO  2100
      IF(ADCP.LT.ADCLIM)  GOTO  2100
      TDCP0= TDCP
      IF(IFLG.EQ.1) GO TO 2050
2010  TDCP0= TDCP0*TCALP(NCN)
      TDCP0= TDCP0-CPS-CORADP
C     IF(IBUG.LE.10) PRINT 106,NCN,TDCP0
2050  IRAW(1,NCN)= NCN
      RAW(3,NCN)= TDCP0
      RAW(5,NCN)= ADCP
2100  CONTINUE
C
 3000 CONTINUE
C/////////
      RETURN
      END
