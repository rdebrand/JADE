C   16/07/81 312172001  MEMBER NAME  LGCUT    (JADESR)      FORTRAN
      SUBROUTINE LGCUT(IACC,ECYL,ECAMI,ECAPL,ETOT)
C
C     DETERMINES IF EVENT SHOULD BE KEPT OR REJECTED, BASED ON LG ENERGY
C     IACC=0 MEANS REJECT
C     IACC=1 MEANS ACCEPT
C
C          MODIFIED TO EXCLUDE EDGEBLOCKS IN ENDCAPS IN THE SPINNER TEST
C                     J.OLSSON   11.02.80
C
      IMPLICIT INTEGER*2 (H)
#include "cdata.for"
#include "cutsr1.for"
      EQUIVALENCE (ETOTLM,ELGLM(1)),(EMIN,ELGLM(2)),(EMNCYL,ELGLM(3))
      COMMON /CHEADR/ HEAD(108)
      COMMON /CIGG/ IPRN,IGG(80)
      INTEGER*2 HELP(2)/0,0/
      EQUIVALENCE (HELP(1),LABL)
      DATA MSK200 /Z200/
      LOGICAL*1 FIRST/.FALSE./
C-----
C SET IACC=0 DIRECTLY; ONLY WAY FOR IACC=1 IS TO FULFILL LIMITS BELOW
C-----
      IACC = 0
C-----
C INITIALIZE BOS-POINTERS
C-----
      IF(FIRST)GOTO100
      FIRST=.TRUE.
      IQTRIG = IBLN('TRIG')
      IQALGN = IBLN('ALGN')
  100 CONTINUE
C-----
C FIND ENERGY IN CYLINDER AND ENDCAPS
C-----
      CALL ERGTOT(ECYL,ECAMI,ECAPL)
      ETOT=ECYL+ECAMI+ECAPL
      ETOT95 = ETOT * .95
      CALL HF1(4,ETOT,1.)
      IPO = IDATA(IQTRIG)
      IF(IPO.LE.0 .OR. IDATA(IPO-2).NE.1) GO TO 7432
      IPO = IPO*2
      HELP(2) = HDATA(IPO+10)
      IVAR = LAND(LABL,MSK200)
      ECAPS = ECAMI + ECAPL
      IF(IVAR.EQ.0) GO TO 7431
      GO TO 7432
7431  CONTINUE
C
C     ETOT.LT.ETOTLM MEANS NO CHANCE OF BAD BLOCKS
C     LT 95% OF ENERGY IN ENDCAPS MEANS NO BAD BLOCKS
C
7432  IF(ETOT.LT.ETOTLM) GO TO 1400
      IF(ECAMI.LT.ETOT95 .AND. ECAPL.LT.ETOT95) GOTO 1400
C-----
C CHECK FOR BAD BLOCKS HERE
C-----
      IPJ=IDATA(IQALGN)
      IF(IPJ.LE.0) GO TO 99
      NWO=IDATA(IPJ)
      IF(NWO.LE.3) GO TO 99
      IPJ=2*IPJ + 8
      NWO=IPJ+2*NWO-8
      DO 5004 IJK=IPJ,NWO,2
      IAD=HDATA(IJK-1)
      IF(IAD.LE.2687) GO TO 5004
      ETEST = HDATA(IJK)
      IF(ETEST.LT.ETOT95) GOTO 5004
C TEST HERE TO EXCLUDE EDGE BLOCKS FROM THE CHECK
C     REDUCE TO NUMBERS 1 - 192
      NO = IAD - 2687
C     0 FOR -Z, 1 FOR +Z
      NE = (NO - 1)/96
C     REDUCE TO 1 - 96
      NO = NO - NE*96
C     GET QUADRANT NUMBER 0 - 3
      NQ = (NO - 1)/24
C     REDUCE TO 1 - 24
      NO = NO - NQ*24
      IF(NO.LT.5) GO TO 5004
      IF(NO.GT.15.AND.NO.NE.20) GO TO 5004
      GO TO 5005
5004  CONTINUE
C     COME HERE IF NO BAD BLOCKS
1400  IF(ETOT.GT.EMIN.OR.ECYL.GT.EMNCYL) IACC = 1
      GO TO 1010
 99   CONTINUE
      DATA IPRN1 /0/
      IPRN1 = IPRN1 + 1
      IF(IPRN1.LT.10) WRITE(6,36) IPJ,NWO,HEAD(18),HEAD(19)
 36   FORMAT('  ERROR IN LG BANK  ',4I10)
      GO TO 1010
 5005 IF(IPRN.GT.0) WRITE(6,29) IAD,ETEST
 29   FORMAT(' ADDRESS AND ENERGY OF BAD BLOCK: ',I10,F10.2)
      IGG(71)=IGG(71)+1
      CALL HF1(5,ECAPS,1.)
1010  RETURN
      END
      SUBROUTINE STATUS
      COMMON /CIGG/ IPRN,IGG(80)
C---------------------
C  DUMP RUN STATISTICS
C---------------------
      RNIDS=0.
      NWRT=IGG(79)
      IF(IGG(1).NE.0)PRINT1000,IGG(1)
      IF(IGG(1).EQ.0)PRINT1001
 1000 FORMAT(1H1/
     + 1X,116('=')/
     + 1X,45('='),' STATISTICS FOR RUN',I6,1X,45('=')/
     + 1X,116('='))
 1001 FORMAT(1H1/
     + 1X,113('=')/
     + 1X,40('='),' OVERALL STATISTICS FOR THIS JOB ',40('=')/
     + 1X,113('='))
C
C DUMP RAW COUNTERS
C
      PRINT1010,(IGG(I),I=1,80)
 1010 FORMAT(/' INTEGER CONTENTS',1X,10I8/
     +        ' ----------------',1X,10I8/6(18X,10I8/))
C
C EVENTS READ
C
      NPASS=IGG(4)-IGG(11)
      PRINT1020,IGG(4),IGG(11),NPASS
 1020 FORMAT(
     +          I10,' EVENTS READ          ',
     +          I10,' PULSER EVENTS        ',
     +          I10,' NON-PULSER EVENTS    ')
      IF(IGG(11).NE.13.AND.IGG(1).NE.0)PRINT1030
 1030 FORMAT(20X,'********** WRONG NO. OF PULSER EVENTS **********')
C
C OVERFLOW EVENTS,LGCALB ERRORS & LUMI EVENTS
C
      PRINT1050,IGG(77),IGG(78),IGG(80)
 1050 FORMAT(
     +          I10,' OVERFLOW EVENTS      ',
     +          I10,' LGCALB ERROR RETURNS ',
     +          I10,' LUMI EVENTS          ')
C
C MIPROC REJECTION
C
      PRINT1060,IGG(19),IGG(20)
 1060 FORMAT(
     +          I10,' EVENTS REJECTED BY MIPROC ZVTX CUT',
     +     19X, I10,' EVENTS REJECTED BY MIPROC T2 CUT  ')
C
      IF(NPASS.EQ.0)GOTO10000
      EVS=IGG( 4)*.01
C
C TRIGGER CHECK
C
      NPASS=NPASS - IGG(12)
      GPASS = NPASS   / EVS
      GFAIL = IGG(12) / EVS
      PRINT2000,IGG(12),GFAIL,NPASS,GPASS
 2000 FORMAT(//I10,' EVENTS (',F6.2,'%) FAILED TRIGGER CHECK '/
     +         I10,' EVENTS (',F6.2,'%) PASSED TRIGGER CHECK ')
C
C FWD MUON CHECK
C
      GFMU=IGG(2)/EVS
      PRINT5010,IGG(2),GFMU
 5010 FORMAT(
     + I10,' EVENTS (',F6.2,'%) PASSED FORWARD MUON CHECK             ',
     + 20X,'----- ACCEPTED -----')
C
C BAD BLOCKS
C
      GBAD  = IGG(71) / EVS
      PRINT5020,IGG(71),GBAD
 5020 FORMAT(
     + I10,' EVENTS (',F6.2,'%) HAD BAD LEAD GLASS BLOCKS             ')
C
C T1 ACCEPT BUT IWRT=0
C
      RNIDF = IGG(13) / EVS
      PRINT5030,IGG(13),RNIDF
 5030 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITH T1 ACCEPT BUT IWRT=0             ',
     + 20X,'===== REJECTED =====')
C
C EVENTS WITH WRITE FLAG
C
      NIWRT = 0
      DO 5 I=51,57
 5    NIWRT = IGG(I) + NIWRT
      GPASS = NIWRT   / EVS
      PRINT5040,NIWRT,GPASS,(IGG(I),I=51,57)
 5040 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITH IWRT=1->7 ',7I6)
C
C NO ID HITS OR WRITE FLAG
C
      NPASS = NPASS -IGG(13)-IGG(14)-IGG(15)
      RNIDF = IGG(14) / EVS
      PRINT5050,IGG(14),RNIDF
 5050 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITH NO ID HITS & WRITE FLAG OFF      ',
     + 20X,'===== REJECTED =====')
C
C NO ID HITS BUT WRITE FLAG ON
C
      RNIDS = 0.
      NIDS=IGG(15)
      RNIDS = NIDS / EVS
      PRINT5060,NIDS,RNIDS
 5060 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITH NO ID HITS & WRITE FLAG ON       ',
     + 20X,'----- ACCEPTED -----')
C
C EVENTS PASSED
C
      RZVT  = NPASS   / EVS
      PRINT5070,NPASS,RZVT
 5070 FORMAT(
     + I10,' EVENTS (',F6.2,'%)                                       ',
     + 20X,'-----  PASSED  -----')
C
C ENTERED ZVERTEX ROUTINE
C
      RZVT  = IGG( 6) / EVS
      PRINT6000,IGG( 6),RZVT
 6000 FORMAT(/
     + I10,' EVENTS (',F6.2,'%) ENTERED ZVERTEX ROUTINE               ',
     + 20X,'----- ACCEPTED -----')
C
C EVENTS WITH WRITE FLAG ON
C
      RNIDS = IGG(21) / EVS
      PRINT6010,IGG(21),RNIDS
 6010 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITH WRITE FLAG ON                    ',
     + 20X,'----- ACCEPTED -----')
C
C EVENTS WITH NO ZVTX BANK
C
      IZVT=IGG(24)
      RZVT  = IZVT    / EVS
      PRINT6020,IZVT,RZVT
 6020 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITHOUT "ZVTX" BANK                   ',
     + 20X,'===== REJECTED =====')
C
C ZVTX FLAGS
C
      RZ    = IGG(26) / EVS
      RZ1   = IGG(27) / EVS
      RZ2   = IGG(28) / EVS
      RZ3   = IGG(29) / EVS
      PRINT6030,RZ,RZ1,RZ2,RZ3,IGG(4)
 6030 FORMAT(28X,'ZVTX FLAGS',4(F6.2,'% '),' OF',I9)
C
C FAILED TO FIND ZVERTEX
C
      IZVT=IGG(22)
      RZVT  = IZVT    / EVS
      PRINT6040,IZVT,RZVT
 6040 FORMAT(
     + I10,' EVENTS (',F6.2,'%) FAILED TO FIND Z-VERTEX               ',
     + 20X,'===== REJECTED =====')
C
C Z-VERTEX > 300 MMS
C
      IZVT=IGG(23)
      RZVT  = IZVT    / EVS
      PRINT6050,IZVT,RZVT
 6050 FORMAT(
     + I10,' EVENTS (',F6.2,'%) HAD Z-VERTEX > 300 MMS                ',
     + 20X,'===== REJECTED =====')
C
C Z-VERTEX < 300 MMS
C
      NPASS = IGG( 6) - IGG(21)-IGG(22)-IGG(23)-IGG(24)
      RZVT  = NPASS   / EVS
      PRINT6060,NPASS,RZVT
 6060 FORMAT(
     + I10,' EVENTS (',F6.2,'%) HAD Z-VERTEX < 300 MMS                ',
     + 20X,'-----  PASSED  -----')
C
C EVENTS THROUGH PATREC
C
      NPASS = IGG( 7)
      RZVT  = NPASS   / EVS
      PRINT7000,NPASS,RZVT
 7000 FORMAT(/
     + I10,' EVENTS (',F6.2,'%) THROUGH PATTERN RECOGNITION           ')
C
C EVENTS WITHOUT PATREC BANK
C
      IZVT=IGG(31)
      RZVT  = IZVT    / EVS
      PRINT7010,IZVT,RZVT
 7010 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITHOUT "PATR" BANK                   ',
     + 20X,'----- ACCEPTED -----')
C
C EVENTS WITH NO TRACKS AND NO WRITE FLAG
C
      IZVT=IGG(32)
      RZVT  = IZVT    / EVS
      PRINT7020,IZVT,RZVT
 7020 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITH NO TRACKS AND NO WRITE FLAG      ',
     + 20X,'===== REJECTED =====')
C
C EVENTS WITH TRACKS
C
      NPASS = NPASS - IGG(31) - IGG(32)
      RZVT  = NPASS / EVS
      PRINT7030,NPASS,RZVT
 7030 FORMAT(
     + I10,' EVENTS (',F6.2,'%) HAD AT LEAST ONE TRACK                ')
C
C EVENTS WITH TRACKS AND TAG FLAG
C
      NTAG = IGG(33) + IGG(34)
      RZVT  = NTAG / EVS
      PRINT8000,NTAG,RZVT
 8000 FORMAT(/
     + I10,' EVENTS (',F6.2,'%) HAD AT LEAST ONE TRACK AND TAG FLAG   ')
C
C TAG EVENTS WITH TRACKS BELOW MOMENTUM CUT
C
      RZVT  = IGG(33) / EVS
      PRINT8010,IGG(33),RZVT
 8010 FORMAT(
     + I10,' EVENTS (',F6.2,'%) TAG EVENTS WITH LOW MOMENTUM TRACKS   ',
     + 20X,'===== REJECTED =====')
C
C TAG EVENTS WITH TRACKS ABOVE MOMENTUM CUT
C
      RZVT = IGG(34) / EVS
      PRINT8020,IGG(34),RZVT
 8020 FORMAT(
     + I10,' EVENTS (',F6.2,'%) TAG EVENTS WITH HIGH MOMENTUM TRACKS  ',
     + 20X,'----- ACCEPTED -----')
C
C SHORT TRACK IN R-Z AND R-PHI
C
      RZVT  = IGG(35) / EVS
      PRINT8050,IGG(35),RZVT
 8050 FORMAT(/
     + I10,' EVENTS (',F6.2,'%) WITH SHORT TRACK IN R-Z AND R-PHI     ',
     + 20X,'===== REJECTED =====')
C
C SHORT TRACK IN R-Z BUT LONG TRACK IN R-PHI
C
      RZVT = IGG(36) / EVS
      PRINT8060,IGG(36),RZVT
 8060 FORMAT(
     + I10,' EVENTS (',F6.2,'%) SHORT TRACK IN R-Z,LONG TRACK IN R-PHI',
     + 20X,'----- ACCEPTED -----')
C
C ONLY LOW MOMENTUM LONG TRACKS
C
      NPASS = IGG(37) + IGG(38) + IGG(39) + IGG(40)
      IZVT=IGG(37)
      RZVT  = IZVT    / EVS
      PRINT9000,IZVT,RZVT
 9000 FORMAT(/
     + I10,' EVENTS (',F6.2,'%) WITH LONG TRACK OF LOW MOMENTUM ONLY  ',
     + 20X,'===== REJECTED =====')
C
C HIGH MOMENTUM LONG TRACKS
C
      NPASS = NPASS - IGG(37)
      RZVT  = NPASS   / EVS
      PRINT9010,NPASS,RZVT
 9010 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITH LONG TRACK OF HIGH MOMENTUM      ')
C
C ZMIN > 300 MMS
C
      IZVT=IGG(38)
      RZVT  = IZVT    / EVS
      PRINT9020,IZVT,RZVT
 9020 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WITH ZMIN > 300 MMS                   ',
     + 20X,'===== REJECTED =====')
C
C EVENTS INTO RMIN CUT
C
      NPASS = NPASS - IGG(38)
      RZVT  = NPASS   / EVS
      PRINT9030,NPASS,RZVT
 9030 FORMAT(
     + I10,' EVENTS (',F6.2,'%) WENT INTO RMIN CUT                    ')
C
C EVENTS REJECTED BY RMIN CUT
C
      IZVT=IGG(39)
      RZVT  = IZVT    / EVS
      PRINT9040,IZVT,RZVT
 9040 FORMAT(
     + I10,' EVENTS (',F6.2,'%) REJECTED BY RMIN CUT                  ',
     + 20X,'===== REJECTED =====')
C
C EVENTS PASSED RMIN AND ZMIN CUTS
C
      RZVT = IGG(40) / EVS
      PRINT9050,IGG(40),RZVT
 9050 FORMAT(
     + I10,' EVENTS (',F6.2,'%) PASSED RMIN AND ZMIN CUTS             ',
     + 20X,'----- ACCEPTED -----')
C
C OVERALL REDUCTION FACTOR
C
      RZVT  = IGG(79)    / EVS
      PRINT9090,IGG(4),IGG(79),RZVT
 9090 FORMAT(///
     +      1X,I10,' EVENTS WERE READ',6X,
     +      1X,I10,' EVENTS WERE WRITTEN',6X,
     +      1X,10X,' ACCEPTED FRACTION = ',F6.2,'%'/
     +      1X, 5X,22('='),6X,
     +      1X, 6X,24('='),6X,
     +      1X,10X,' ===========================')
10000 IF(IPRN.GT.1) WRITE(7,10010) IGG
10010 FORMAT(10I8)
      RETURN
      END
      BLOCK DATA
#include "cutsr1.for"
      EQUIVALENCE (ETOTLM,ELGLM(1)),(EMIN,ELGLM(2)),(EMNCYL,ELGLM(3))
      DATA NRUNST/0/,NEVTST/0/,NOTTOT/0/,NOTRUN/10*0/,NVRSN/1981/
C
C SET FOR  7 ON  7 GEV RUNNING
C
CC-CC DATA ETOTLM /3000./,EMIN /3000./,EMNCYL/1500./
C
C SET FOR 15 ON 15 GEV RUNNING
C
      DATA ETOTLM /6000./,EMIN /7000./,EMNCYL/3500./
      END
