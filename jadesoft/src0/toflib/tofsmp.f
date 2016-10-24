C   25/02/80 206211807  MEMBER NAME  TOFSMP   (S)           FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       SUBROUTINE TOFSMP(NRUN)
C
C      COMPUTES TOF WITHOUT CHECKING AGREEMENT OF THE 2 PHOTOTUBES
C  OUTPUT TTOF(I) : TIME OF FLIGHT IN COUNTER I(ONLY COMPUTED IF LATCH
C                   HAS FIRED) OTHERWISE SET TO -100
C  HTOF(I) = 0 IF LATCH OF COUNTER I HAS NOT FIRED
C          = 1 IF IT HAS
C  NTOF = NUMBER OF TOF LATCHES THAT HAVE FIRED
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      IMPLICIT INTEGER*2 (H)
#include "tfprm.for"
#include "tfadc.for"
#include "chead.for"
C
      COMMON/SMPTOF/MTOF,TTOF(42),NTOF,HTOF(42)
      COMMON/BCS/IDATA(1)
      DIMENSION HDATA(2)
      EQUIVALENCE  (HDATA(1),IDATA(1))
      DIMENSION MASK(7),LIST(19)
      DATA MASK/1,2,4,8,16,32,64/
      DATA ITOFST/93/
      DATA IRUN/0/
      DATA MBAD/19/
      DATA LIST/5,7,11,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42/
C
      HEADR(18) = NRUN
      NTOF = 0
      CALL SETSL(TTOF,0,42*4,0.)
      CALL SETSL(HTOF,0,42*2,0.)
      IF(NRUN.EQ.IRUN) GOTO  10
      IF(NRUN.LE.1659) CALL CORCST(NRUN)
      IF(NRUN.GE.1660) CALL RD0880(NRUN)
      IF(IRUN.NE.0)  GOTO  10
      PRINT 110,NRUN
  110 FORMAT(50X,'CALLED RD0880',I6)
   10 IRUN = NRUN
      IF(NRUN.LE.1660) CALL TOFSM2
      IF(NRUN.LE.1660) RETURN
      IF(NRUN.GE.8712) CALL TOFSM3(NRUN)
      IF(NRUN.GE.8712) RETURN
      IPLTC  = IDATA(IBLN('LATC'))
      IF(IPLTC.LE.0)  RETURN
      IPTOF  = IDATA(IBLN('ATOF'))
      IF(IPTOF.LE.0)  RETURN
      IF(IDATA(IPTOF).LT.94) RETURN
      JPTOF = IPTOF*2
      JPLTC = IPLTC*2
C
C  FILL ARRAY OF TOF-LATCHES
C
      IF(NRUN.LT.3728.OR.NRUN.GT.4426)  GOTO   8
C IN THESE RUNS TOF 25- AND 26- WERE INTERCHANGED
      IT25L = HDATA(JPTOF+150)
      IT26L = HDATA(JPTOF+149)
      IT25R = HDATA(JPTOF+148)
      IT26R = HDATA(JPTOF+151)
    8 CONTINUE
      DO   5   N=4,9
      ID = HDATA(JPLTC+N+2)
      IF(NRUN.LT.3728.OR.NRUN.GT.4426)  GOTO   9
      IF(N.NE.7)  GOTO  9
      IF(LAND(ID,8).NE.0) ID = ID-8
      IF(LAND(ID,16).NE.0) ID = ID-16
      IF(IT25L.LT.2048.AND.IT25R.LT.2048) ID = ID+8
      IF(IT26L.LT.2048.AND.IT26R.LT.2048) ID = ID+16
    9 IF(ID.EQ.0)  GOTO  5
      DO   6   M=1,7
      IF(LAND(ID,MASK(M)).LE.0)  GOTO  6
      KTOF = (N-4)*7 + M
      NTOF = NTOF + 1
      IF(NTOF.GT.42)  GOTO  6
      HTOF(KTOF) = 1
    6 CONTINUE
    5 CONTINUE
C
      IF(NTOF.LE.0) RETURN
      DO   1   I=1,42
      IF(HTOF(I).LE.0)  GOTO  1
      IF1 = 2*I-1
      IAD = ITOFST + IF1 + (IF1-1)/8
      ITDCL = HDATA(JPTOF+IAD)
      ITDCR = HDATA(JPTOF+IAD+1)
      IF(NRUN.LT.3728.OR.NRUN.GT.4426)  GOTO  7
      IF(I.NE.25.AND.I.NE.26)  GOTO 7
      IF(I.EQ.25) ITDCL = HDATA(JPTOF+IAD+2)
      IF(I.EQ.26) ITDCL = HDATA(JPTOF+IAD-2)
    7 CONTINUE
      IF(NRUN.LT.7588.OR.NRUN.GT.8712)  GOTO 12
      IF(NRUN.LT.7900)  GOTO  78
      IF(I.EQ.40) TTOF(I) = -20.
      IF(I.EQ.40) GOTO  1
   78 CONTINUE
      DO  19   ML=1,MBAD
      IF(I.NE.LIST(ML))  GOTO 19
      IF(NRUN.GE.8256.AND.ML.GT.4)  GOTO  19
      IF(NRUN.GE.7897.AND.ML.GT.7)  GOTO  19
      TTOF(I) = -20.
      GOTO  1
   19 CONTINUE
C
   12 IF(ITDCL.LT. 5.OR.ITDCL.GE.2048)  GOTO  1
      IF(ITDCR.LT. 5.OR.ITDCR.GE.2048)  GOTO  1
      CORADM = 0.
      CORADP = 0.
      ITIF = IABS(ITDCL-ITDCR)
      IF(NRUN.GT.6600.AND.ITIF.LE.1)  GOTO  20
      IADC =  IF1 + (IF1-1)/12
      ADCM = HDATA(JPTOF+2+IADC)
      ADCP = HDATA(JPTOF+3+IADC)
      IF(ADCM.LT.1024.) CMS = CORNOR(IF1)
      IF(ADCP.LT.1024.) CPS = CORNOR(IF1+1)
      IF(ADCM.GE.1024.) CMS = COROVF(IF1)
      IF(ADCP.GE.1024.) CPS = COROVF(IF1+1)
      ADCM = ADCM - PEDLM(I)
      ADCP = ADCP - PEDLP(I)
      IF(ADCM.LE.0.) ADCM = 1.
      IF(ADCP.LE.0.) ADCP = 1.
      ADCMIV = 1000./ADCM
      ADCPIV = 1000./ADCP
      CORADM =  TPARM(2) + TPARM(1)*ADCMIV
      CORADP =  TPARM(2) + TPARM(1)*ADCPIV
      IF(NRUN.LT.3728)  GOTO  20
      SQADM = SQRT(ADCMIV)
      SQADP = SQRT(ADCPIV)
      BADCM= CADCB(2*I-1)
      BADCP= CADCB(2*I)
      CORADM =  BADCM*SQADM
      CORADP =  BADCP*SQADP
  20  TDCL = ITDCL*TCALM(I)-CMS-CORADM
      TDCR = ITDCR*TCALP(I)-CPS-CORADP
      IF(NRUN.LT.4993) GOTO  321
      TDCL = TDCL -TPARM(25)
      TDCR = TDCR -TPARM(25)
 321  IF(NRUN.GT.6000.AND.NRUN.LT.7592) TDCL = TDCL +3.07
      IF(NRUN.GT.6000.AND.NRUN.LT.7592) TDCR = TDCR +3.07
      IF(NRUN.GT.10000) TDCL = TDCL +3.07
      IF(NRUN.GT.10000) TDCR = TDCR +3.07
      TTOF(I) = .5*(TDCL+TDCR)
    1 CONTINUE
C/////////
      RETURN
      END