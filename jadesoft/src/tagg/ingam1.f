C   14/03/84 403191509  MEMBER NAME  INGAM1   (S)           FORTRAN
C   11/03/80 211191721  MEMBER NAME  INGAM1   (S)           FORTRAN
      SUBROUTINE INGAM1(IER,*,*)
C---  READ AND UNPACK DATA (REDUCED DATA !)
C---  GENERAL PURPOSE ROUTINE FOR ALL RUNS(MACRO- & MINI-BETA)
C---  (PEDESTAL SUBTRACTION IF NECESSARY, LATCHES REORDERED MAY 79,
C---   CALLED BY "@ANALYS1" (1979/80) OR "@ANALY81" (1981 F) )
C---  TREATS CHANNELS WITH & WITHOUT VARIING PEDESTALS
C
C
C     H.WRIEDT       12.03.79       11:15
C     LAST MODIFICATION       19.11.82      17:20
C     COPIED BY A.J.FINCH FROM SERVICE.S
C     BREAD TAKEN OUT
C
      IMPLICIT INTEGER*2 (H)
C
      EXTERNAL BDLM
C

      COMMON /BCS/ IDATA(30000)
      INTEGER*2 HDATA(60000)
      REAL RDATA(30000)
      EQUIVALENCE (IDATA(1),HDATA(1),RDATA(1))
C
      COMMON /CWORK/ HCOINC(16),HLUMON(16),HGGLAT(16),HSCALE(36),
     &               LNG,HPOINT(4),HGGADC(2,240),IWORK1(221),HCORR,
     &               HPBLAT,IWORK2,HSCAL(36),IWORK3(762),HACC,HIL,
     &               HLULAT,HWORK2,IWORK4(618),HRUNEX,HEVENT
      DIMENSION LAT(2),HLAT(4)
      INTEGER GGADC(242)
      EQUIVALENCE (GGADC(3),HGGADC(1,1)), (HLAT(1),LAT(1))
C
      COMMON /CRUNCO/ HRUN,HOLDRN,IUN
C
      COMMON /CPHASE/ LIMEVT
C
      DATA ICOUNT/0/
      DATA ILERR/0/
C
      IER = 0
C DELETED BY A.J.FINCH
C---  READ EVENT
C     CALL BREAD(IUN,&2,&3)
C     CALL BSLT
C     GOTO 4
C   2 RETURN 1
C   3 RETURN 2
C
C---  FETCH HEAD-POINTER
    4 IHEAD = IDATA(IBLN('HEAD'))
      IF (IHEAD.GT.0) GOTO 5
      WRITE(6,602)
  602 FORMAT(' ***** BANK HEAD MISSING *****')
C***  RESPONSE HAS TO BE DEVELOPPED
    5 INDEX = 2*IHEAD + 10
      HRUNEX = HDATA(INDEX)
      HEVENT = HDATA(INDEX+1)
C---  COMPARE RUN-NO. WITH RUN-NO. OF PREVIOUS EVENT
      IF (HRUNEX.EQ.HOLDRN) GOTO 6
C---  CALIBRATION FOR 1981 (OR LATER) - DATA  WILL BE CALLED
C        IN @ANALY81
      IF (HRUNEX.GT.6000) GOTO 11
C---  NEW LEAD-GLASS CALIBRATION AFTER RUN 1056
      IF (HOLDRN.LE.1056 .AND. HRUNEX.GT.1056) CALL GGFAC2
C---  NEW LEAD-GLASS CALIBRATION FROM RUN 2751 ONWARDS
C     (1980 DATA AFTER INSTALLATION OF FILTERS)
      IF (HOLDRN.LT.2751 .AND. HRUNEX.GE.2751) CALL GGFAC3
C---  CORRECTIONS FOR LEAD-GLASS-ADCS FROM RUN 2751 ONWARDS
C     (1980 DATA AFTER INSTALLATION OF FILTERS)
      IF (HOLDRN.LT.2751 .AND. HRUNEX.GE.2751) CALL GGFAC4
C---  NEW LEAD-GLASS CALIBRATION FROM RUN 4511 ONWARDS
C     (COPES WITH CHANGES OF EHTS BEGINNING OF AUGUST 1980)
      IF (HOLDRN.LT.4511 .AND. HRUNEX.GE.4511) CALL GGFAC5
C---  NEW LEAD-GLASS CALIBRATION FROM RUN 4993 ONWARDS
C     (COPES WITH CHANGES IN ELECTRONICS DURING 1980 SUMMER SHUT-DOWN)
      IF (HOLDRN.LT.4993 .AND. HRUNEX.GE.4993) CALL GGFAC6
C
   11 HOLDRN = HRUNEX
      HRUN = HRUNEX
C---  IF NEW RUN, NEW PEDESTAL CORRECTIONS NECESSARY
      INIT = 0
      IF (HRUN.LT.2700) CALL ANOMAL
C-OFF WRITE(6,605) HRUN
C 605 FORMAT(/' *** READY FOR RUN',I5,' ***')
C
C---  GET FLAG FOR LUMI- OR TAGG-EVENTS
C---      FOR 1979 - 1981 TRIGGER SCHEME
    6 IF (HRUN.LT.10000) CALL TAGFLG(IFLAG)
C---      FOR 1982 - .... TRIGGER SCHEME
      IF (HRUN.GT.10000) CALL TAGF82(IFLAG)
      IF (IFLAG.GT.0) HACC = 1
C---  TRANSFER DATA FROM 'LATC'
C---  FETCH LATC-POINTER
    9 IND = IDATA(IBLN('LATC'))
      IF (IND.GT.0) GOTO 1
C---  LATC IS MISSING
      WRITE(6,600)
  600 FORMAT(' ***** BANK LATC MISSING *****')
      IER = 4
      GOTO 50
C---  FETCH LATC-DATA
C---  FETCH TAGGING SYSTEM LATCHES
C***  STAND MAI 1979
    1 LAT(1) = IDATA(IND+13)
      LAT(2) = IDATA(IND+14)
      HLULAT = HLAT(3)
      HPBLAT = HLAT(4)
      HIL = HLULAT
C---  UNPACK LATCHES INFORMATION
        DO 10 I1 = 1,16
        I2 = I1 + 16
        HCOINC(I1) = JBIT(LAT(1),I1)
        HLUMON(I1) = JBIT(LAT(2),I2)
   10   HGGLAT(I1) = JBIT(LAT(2),I1)
C
C---  CORRECT INITIALIZATION OF LNG
   50 LNG = 2
C---  TRANSFER DATA FROM 'ATAG'
C---  FETCH ATAG-POINTER
      IND = IDATA(IBLN('ATAG'))
      IF (IND.GT.0) GOTO 51
C---  ATAG IS MISSING
C***  WRITE(6,601)
C*601 FORMAT(' ***** BANK ATAG MISSING *****')
      IER = IER + 2
C***  CALL BDLG
      RETURN
C---  FETCH ATAG-DATA
C---  LNG:  NUMBER OF ADC-DATA + 2
   51 NDATA = IDATA(IND)
      LNG = NDATA - 1
C---  CHECK WHETHER THERE IS ANY LG-INFORMATION AVAILABLE
      LADC = HDATA(2*IND+5) - HDATA(2*IND+3)
      IF (HACC.EQ.0 .AND. LADC.GE.1) HACC = 2
      IF (HACC.EQ.1 .AND. LADC.LT.1) HACC = -1
C
      IF (LNG.LE.242) GOTO 53
       ILERR=ILERR + 1
       IF(ILERR.GT.10)GOTO 522
      WRITE(6,6004)
6004  FORMAT('  ATAG BANK DUMPED BY INGAM1 BECAUSE ATAG LENGTH =',I10)
      CALL HPRS('ATAG',0)
522   CONTINUE
      RETURN 1
   53 CALL UCOPY(IDATA(IND+2),GGADC(1),LNG)
C
      IF (HRUN.GT.6000) GOTO 52
      ICOUNT = ICOUNT+1
      IF (LIMEVT.LT.ICOUNT) GOTO 52
      CALL BDLG
      RETURN
C
   52 INIT = INIT + 1
C---  SUBTRACT PEDESTALS
      IF (HRUN.LT.2700) CALL SUBNEW
      IF (HRUN.GT.2700 .AND. HRUN.LT.2872) CALL SUBOLD(INIT)
      IF (HRUN.GE.2872 .AND. HRUN.LT.6000) CALL CUTPED
      IF (HRUN.GE.6000) CALL CUTP81
C
C***  CALL BDLG
   54 RETURN
      END
      BLOCK DATA
      COMMON /CRUNCO/ I,IUN
      DATA IUN/3/
      END
