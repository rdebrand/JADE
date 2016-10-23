C   11/01/81 310281843  MEMBER NAME  TFSUB    (S)           FORTRAN
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
#include "tfprm.for"
#include "tfadc.for"
      COMMON/TFPED/ HADC(2,42),HTDC(2,42),HSTAT(42),HON(42)
      COMMON/PRPOS/PRPLS,CPOS
      COMMON/CWORK/NR,RAW(5,42),NC,ICRT1(5,42),NTRK,ICRT2(50),TRK(5,50)
     - ,ITRC(50),NTC,ITRK(5,42),INFM(4),IR(14,50)
      COMMON /CHEADR/ IHEADR(54)
      EQUIVALENCE (IHEADR(1),HEADR(1))
      DIMENSION IRAW(5,42),HEADR(108),LIST1(2),LIST(19)
      EQUIVALENCE (IRAW(1,1),RAW(1,1))
      DIMENSION A(214),B(214)
C
      DATA MBAD/20/
      DATA LIST/5,7,8,32,34,35,36,42,40,11,27,28,29,30,31,33,37,38,39,
     1          41/
C
      DATA IENTRY/0/,IBUG/10/
      DATA ADCLIM/1./,IRUN/0/
C
      IF(IENTRY.NE.0)  GOTO 320
      IENTRY = IENTRY + 1
 320  CONTINUE
C
      NRUN = HEADR(18)
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
      BADC = TPARM(1)
      AADC = TPARM(2)
      CALL ATOFUN(INTF)
      IF(IBUG.LE.10) CALL ATOFPR(INTF)
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
C
      MONE = 0
      IF(NRUN.LT.7588.OR.NRUN.GT.8711)  GOTO  77
      IF(NRUN.LT.7900)  GOTO  78
      IF(NCN.EQ.40) HTDC(1,NCN)=2050
      IF(NCN.EQ.40) MONE = 2
   78 CONTINUE
      DO   31   L=1,MBAD
      IF(NRUN.GE.8256.AND.L.GT.4)  GOTO  77
      IF(NRUN.GE.7900.AND.L.GT.8)  GOTO  77
C     IF(NRUN.GE.8256.AND.L.GT.3)  GOTO  77
C     IF(NRUN.GE.7897.AND.L.GT.7)  GOTO  77
      IF(NCN.NE.LIST(L))  GOTO  31
      HTDC(2,NCN) = 2050
      MONE = 1
   31 CONTINUE
   77 CONTINUE
C
      IF(NRUN.LT.8712.OR.NRUN.GT.10000)  GOTO  87
      IF(NCN.NE.8)  GOTO  88
      HTDC(1,NCN) = 2050
      MONE = 2
   88 CONTINUE
      IF(NCN.NE.11)  GOTO  87
      HTDC(2,NCN) = 2050
      MONE = 1
   87 CONTINUE
C
      IF(NRUN.GT.12518)  GOTO  89
      IF(NCN.NE.31)  GOTO  89
      HTDC(2,NCN) = 2050
      MONE = 1
   89 CONTINUE
C
      IF(NRUN.GT.14605)  GOTO  91
      IF(NRUN.LT.13900)  GOTO  91
      IF(NCN.NE.36)  GOTO  93
      HTDC(2,NCN) = 2050
      MONE = 1
      GOTO  91
   93 IF(NCN.NE.40)  GOTO  91
      HTDC(1,NCN) = 2050
      MONE = 2
   91 CONTINUE
C
      IF(NRUN.LT.14500.OR.NRUN.GT.14687)  GOTO  94
      IF(NCN.NE.36)  GOTO  94
      HTDC(1,NCN) = 2050
      MONE = 2
   94 CONTINUE
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
      IBUG = IBUG + 1
      IF(IBUG.LE.10) PRINT 420,HSTAT
  420 FORMAT(' HSTAT',42I3)
      TDCM = HTDC(1,NCN)
      TDCP = HTDC(2,NCN)
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
      IF(ADCM.LE.  25.) CORADM = 0.
      IF(ADCP.LE.  25.) CORADP = 0.
C     CORADM = 0.
C     CORADP = 0.
C
      IF(IBUG.LE.10) PRINT 106,NCN,CADCA(2*NCN-1),CADCB(2*NCN-1),
     1 CADCA(2*NCN),CADCB(2*NCN)
      IF(IBUG.LE.10) PRINT 106,NCN,ADCM,ADCP,CORADM,CORADP,CMS,CPS
  106 FORMAT(' TOFARD',I5,10F10.3)
      IF(TDCM.LT.10..OR.TDCM.GT.2048.)  GOTO  2000
      IF(ADCM.LT.ADCLIM)  GOTO  2000
      TDCM0= TDCM
      IF(IFLG.EQ.1) GO TO 1600
      TDCM0= TDCM0*TCALM(NCN)
      TDCM0= TDCM0-CMS-CORADM
C     CALL HFILL(701,CORADM,FLOAT(NCN))
      IF(IBUG.LE.10) PRINT 106,NCN,TDCM0
 1600 IRAW(1,NCN)= NCN
      RAW(2,NCN)= TDCM0
      RAW(4,NCN)= ADCM
C
 2000 CONTINUE
      IF(TDCP.LT.10..OR.TDCP.GT.2048.)  GOTO  2050
      IF(ADCP.LT.ADCLIM)  GOTO  2100
      TDCP0= TDCP
      IF(IFLG.EQ.1) GO TO 2050
2010  TDCP0= TDCP0*TCALP(NCN)
      TDCP0= TDCP0-CPS-CORADP
CC    CALL HFILL(702,CORADP,FLOAT(NCN))
      IF(IBUG.LE.10) PRINT 106,NCN,TDCP0
2050  IRAW(1,NCN)= NCN
      RAW(3,NCN)= TDCP0
      RAW(5,NCN)= ADCP
2100  CONTINUE
C
 3000 CONTINUE
C/////////
      RETURN
      END
