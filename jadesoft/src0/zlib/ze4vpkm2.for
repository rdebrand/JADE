C   22/04/87 805100912  MEMBER NAME  ZE4VPKM2 (S)           FORTRAN77
C
C   VERSION OF 04/02/85    E. ELSEN
C   MODIFIED   12/01/87    M. ZIMMER
C   MODIFIED   31/03/87    G. ECKERLIN
C   MODIFIED   16/04/87    G. ECKERLIN   EVENT SCIP AND SELECTION
C   LAST MOD   22/04/87    G. ECKERLIN   PACK MURESULTS IN TP-BANK
C                                        FOR LUND MC FILES
C              19/08/87    M. ZIMMER    GUENTHERS PRIVATE STUFF REMOVED
C   LAST MOD   22/04/88    E E           DUMP ELECTRON STATISTICS
C
C   COMPRESS EVENTBANKS INTO ZE4V FORMAT
C   WITH ZE4VPK FROM PART AND LGCL BANK
C-----------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
      COMMON / BCS / IW(80000)
      DIMENSION HW(1),RW(1)
      EQUIVALENCE (HW(1),IW(1),RW(1))
C
C
      INTEGER ILIST(21)/68,  71, 100, 248, 254, 332, 360, 366, 449, 456,
     *                 548, 555, 569, 576, 615, 740, 744, 871, 906, 908,
     *                 946 /, ICUR / 1 /
C
C
      DIMENSION HDSN(22), HVOL(3),HRUNEV(2)
      REAL*8 DDIN / 'FT02F001' /
      REAL*8 DDOU / 'FT03F001' /
      REAL*8 DDZE / 'FT51F001' /
      INTEGER IDDIN(2) ,IRE
      EQUIVALENCE(HRUNEV(1),IRE)
      EQUIVALENCE(IDDIN(1),DDIN)
C                                      INPUT/OUTPUT FTXX..
C          INPUT   (2)   EVT-OUT (3)   ZE4V-OUT (51)
      DATA IRUNIT / 2 /, IWUNIT / 0 /, IUNZE4 /  51 /
C                                   READ IN DD* CARDS
      READ(5,9001) IEVLIM,IFILMX,IWRMAX,IWZMAX,IDULIM,ISCIP
 9001 FORMAT(20X,I10)
      WRITE(6,9002) IEVLIM,IFILMX,IWRMAX,IWZMAX,IDULIM,ISCIP
 9002 FORMAT(/' MAX # OF EVENTS TO READ   :',I8/
     &         ' MAX # OF INPUTFILES       :',I8/
     &         ' MAX # OF EVENTS ON UNIT 3 :',I8/
     &         ' MAX # OF EVENTS ON UNIT51 :',I8/
     &         ' MAX # OF ZE4V-BANK PRINTS :',I8/
     &         ' INITIAL EVENT SCIP        :',I8/)
C                                          INIT BOS
      CALL BINT( 80000, 40000, 10000, 0 )
C                                           I/O UNIT SPECIFICATION
      CALL DDCHA( DDIN, HDSN, HERR, HVOL )
      WRITE(6,9111) HDSN, HVOL
 9111 FORMAT(/'      INPUT IS FROM DSN=',22A2,' VOL=',3A2)
      IF( IWUNIT.LE.0 ) GO TO 10
         CALL DDCHA( DDOU, HDSN, HERR, HVOL )
         WRITE(6,9112) HDSN, HVOL
 9112    FORMAT(/'      OUTPUT IS TO  DSN=',22A2,' VOL=',3A2)
   10 CONTINUE
C
      IF( IUNZE4.LE.0 ) GO TO 20
         CALL DDCHA( DDZE, HDSN, HERR, HVOL )
         WRITE(6,9122) HDSN, HVOL
 9122    FORMAT(/' ZE4V OUTPUT IS TO  DSN=',22A2,' VOL=',3A2/)
   20 CONTINUE
C
      IFIL = 1
      IEOF = 0
      IWRITE = 0
      IEV = 0
      IZE4V = 0
      IWZE4V = 0
C                                      INITIALISE FEHLER
      CALL FEHLIN
C
  100 IF( JUHR(2) .EQ. 2 ) GO TO 4000
      CALL BREAD( IRUNIT, &1000, &3000 )
      IEOF = 0
      IEV = IEV + 1
      IRV = IRNEVT( DUMMY )
      WRITE(6,9301) HRUNEV(2), IEV
 9301 FORMAT(' +++++++++ NEXT EVENT # ',I5,' IEV = ',I6,' ++++++++++')
C                                      LOOK FOR HEAD BANK
      NPHEAD = IW(IBLN('HEAD'))
      IF( NPHEAD.LE.0 ) GO TO 200
C                                      INITIAL EVENT SCIP
      IF (IEV.LE.ISCIP) GOTO 2000
C                                      FILL CALIBRATION CONSTANTS
      CALL KLREAD
C
      IF (IZE4V.EQ.0) THEN
        CALL ZE4VIN( 1 )
        IZE4V = 1
      ELSE
        CALL ZE4VPK( 1 )
      ENDIF
C
      NPZE4V = IW( IBLN ( 'ZE4V' ))
      NUMEVT = HW(NPZE4V*2 + 14)
      IF ( NUMEVT .EQ. ILIST(ICUR) ) THEN
        CALL ZE4VDP
      ELSEIF( NUMEVT .GT. ILIST(ICUR)) THEN
        ICUR = ICUR + 1
        IF ( NUMEVT .EQ. ILIST(ICUR) ) CALL ZE4VDP
      ENDIF
      IF (IDUMP.LT.IDULIM) THEN
        CALL ZE4VDP
        IDUMP = IDUMP + 1
      ENDIF
  200 CONTINUE
C
C                                          WRITE WHOLE EVENT
      IF( IWUNIT .GT. 0 .AND. IWRITE .LT. IWRMAX ) THEN
        IF ( NPHEAD .GT. 0 ) IWRITE = IWRITE + 1
        CALL BSLW
        CALL BWRITE( IWUNIT )
      ENDIF
C
C                                          SCIP ZE4V WRITE IF MC RECORD
      IF( NPHEAD.LE.0 ) GO TO 2000
C                                          WRITE ZE4V BANK
      IF( IUNZE4 .GT. 0 .AND. IWZE4V .LT. IWZMAX ) THEN
        IWZE4V = IWZE4V + 1
        CALL BMLT( 3, 'ZEHDZE4VPALL' )
        CALL BWRITE( IUNZE4 )
      ENDIF
      GO TO 2000
C
C
C                                           ERRORS
 1000 CONTINUE
      CALL JOBFIN( 3, IEV, &1100 )
 1100 IF( IEOF .NE. 0 ) GO TO 8000
C
C
 2000 CONTINUE
      CALL BSLT
      CALL BDLG
      IF( IEV .LT. IEVLIM ) GO TO 100
      CALL JOBFIN( 4, IEV, &8100 )
C
C                                           EOF ON IRUNIT
 3000 IF( IFIL .GE. IFILMX .OR. IEOF.NE.0 )  GO TO 8000
      IFIL = IFIL + 1
      IEOF = 1
      IDDIN(2) = IDDIN(2) + 1
      CALL DDCHA( DDIN, HDSN, HERR, HVOL )
      IF( HERR .NE. 0 ) GO TO 8000
      CALL BDLS( '+BUF', IRUNIT )
      WRITE(6,9104) IEV, IFIL
 9104 FORMAT(' +++++ AFTER',I6,' EVENTS FILE NUMBER CHANGED TO',I4,' +++
     *++')
      WRITE(6,9113) HDSN, HVOL
 9113 FORMAT(/' +++++ INPUT CONTINUES FROM DSN=',22A2,' VOL=',3A2)
      GO TO 100
C
C                                        TIME OUT
 4000 CALL JOBFIN( 2, IEV, &8100 )
C
C                                           END OF JOB
 8000 CONTINUE
      CALL JOBFIN( 1, IEV, &8100 )
 8100 CONTINUE
C                                      MCREDU STATISTICS
      CALL FEHLPR
      CALL EAFLDP
      CALL MCRDFL
      CALL BSTA
C
      STOP
      END