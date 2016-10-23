C   17/01/79 205191819  MEMBER NAME  TOFIN2   (S)           FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       SUBROUTINE TOFIN2(NRUN,INTF,INPA,*)
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C   12/03/79 007281422  MEMBER NAME  DDATA    (S)           FORTRAN
C
      COMMON /BCS/ IDATA(10000)
      DIMENSION DATA(10000)
      INTEGER *2 HDATA(20000)
      EQUIVALENCE (IDATA(1),DATA(1)), (HDATA(1),IDATA(1))
C
      COMMON/CTPCNS/BENGEV,BKGAUS
      COMMON /CHEADR/ IHEADR(54)
       COMMON/CWORK/NR,RAW(5,42),NC,ICRT1(5,42),NTRK,ICRT2(50),TRK(5,50)
     - ,ITRC(50),NTC,ITRK(5,42),INFM(4),IR(14,50)
       DATA IFLG/0/,IENTRY/0/
       DATA IRUN/0/
      DATA IERL,IERP,IERH,IERA/4*0/
C
C========= LOAD CALIBRATION DATA
C
      IF(NRUN.EQ.0.AND.IENTRY.EQ.0) GOTO  101
      IF(NRUN.EQ.IRUN) GOTO  100
  101 IENTRY = 1
      IRUN = NRUN
      CALL CORCST(NRUN)
C========= CONVERT TOF DATA FROM CAMAC TO ANALYSIS FORMAT
C
C
C========= CONVERSION OF PATT. REC. DATA
C
  100 CALL BLOC(INLA,'LATC',0,*3000)
      IPHEAD = IDATA(IBLN('HEAD'))
      IF(IPHEAD.LE.0)  GOTO  3001
      CALL UCOPY(IDATA(IPHEAD-3),IHEADR,54)
      IGAUS = HDATA(IPHEAD*2+30)
      BKGAUS = FLOAT(IGAUS)/1000.
      CALL TFCTD1(INPA)
      IF(NTRK.LT.1) GO TO 4500
C
C========= CONVERSION OF TOF DATA
C
       IF(NRUN.NE.0)CALL TOFAR2(INLA,INTF,IFLG,*4000)
       IF(NRUN.EQ.0)CALL MOCARD(INLA,INTF,IFLG,*4000)
C
C========= MAKE CORRESPONDENCE BETW. TRACKS AND COUNTERS
C
       CALL TOFCOR
       CALL TOFMA2
C
       RETURN
C
 3000 CONTINUE
      IERL = IERL + 1
      IF(IERL.LE.10) PRINT 9300,IERL
 9300 FORMAT(1X,'RAW DATA ERROR FROM TOF PROG: NO LATCHED DATA',I5)
      RETURN1
 4000 IERA = IERA + 1
      IF(IERA.LE.10) PRINT 9400
 9400 FORMAT(' ERROR RETURN FROM TOFARD')
      RETURN1
 4500 IERP = IERP + 1
      IF(IERP.LE.10) PRINT 9450,IERP
 9450 FORMAT(1X,'**** MESSAGE FROM TOF PROG NO TRACK IN PATR BANK',I5)
      RETURN1
 3001 IERH = IERH + 1
      IF(IERH.LE.10) PRINT 3002,IERH
 3002 FORMAT(' MESSAGE FROM TOF PROG NO HEADER ',I5)
      RETURN1
      END
