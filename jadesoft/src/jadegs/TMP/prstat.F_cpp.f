C   17/09/84 803181509  MEMBER NAME  PRSTAT   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE PRSTAT(IFLAG1,IFLAG2,IFLAG3)
C-----------------------------------------------------------------------
C
C   AUTHOR    E. ELSEN    10/05/82 :  PRINT TRIGGER CONDITIONS
C
C   MOD  C. BOWDERY  17/09/84 :  S/R MOVED TO THIS MEMBER
C        MOD  J.OLSSON    24/07/86 :  EXTENSION AND COMPRESSION OF PRINT
C        MOD  E ELSEN     11/12/87 :  PRINT JITTER CONSTANTS FOR ID
C             J.HAGEMANN              AND VTXC
C   LAST MOD  E ELSEN     18/03/88 :  AND Z  (ID)
C
C
C     PRINT SMEARING CONDITIONS, I.E. COMMONS /CBIN/ AND /CBINV/
C          AS WELL AS /CBINMC/, /CJDRCH/ AND /CJVTXC/
C      FOR THIS PRINT, THE FLAGS IFLAG1,IFLAG2 AND IFLAG3 ARE USED, THEY
C      ARE SET AND DETERMINED IN RDMTCO.
C
C     PRINT STATUS OF COMMON /CTRIGG/ AND COMMON/CRDSTA/
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
C
C                        --- MACRO CADMIN ---
C
      LOGICAL*1 LBREAD
C
      COMMON / CADMIN / IEVTP,NRREAD,NRWRIT,NRERR,LBREAD(4),IFLG,IERCAL,
     +                  ISMEAR,IJETCI,NFLAGS(10)
C
C                                 NFLAGS IS AN ARRAY OF GENERAL FLAGS
C                                   (1) : USED BY RDDATE
C                                   (2) : USED BY RDTRIG
C                                   (3) : USED BY RDTRIG
C                                   (4) : USED BY RDTRIG / PRSTAT
C                                   (5) : USED BY EVREAD -COUNTS RECORDS
C                                   (6) : USED BY SUPERV -COUNTS ERRORS
C                                   (7) : USED BY EVWRIT -'HEAD'LESS EVS
C                                   (8) : USED BY EVREAD/RDMTCO (EVWRIT)
C                                   (9) : USED BY RDMTCO/EVWRIT
C                                  (10) : FREE
C
C                                  BLOCK DATA SET IN MEMBER JADEBD
C
C
      LOGICAL  LVTXC
      COMMON / CVCEX  / LVTXC
C
      COMMON / CJDRCH / DRCH(34),
     +                  PEDES, TZERO(3),
     +                  DRIROT(96,2), SINDRI(96,2), COSDRI(96,2),
     +                  DRIVEL(96,2)
C
      COMMON / CJVTXC / VXCC(15),
     +                  DRILOR(24), SNLORA(24), CSLORA(24),
     +                  DRVELO(24)
C
      COMMON / CBINV /  DTRSVV, ZRSVV, EFFVV(2), DOUBVV(3), IRNHVV,
     +                  SMPRMV(3)
C
      COMMON / CBIN   / TIME(6),ZOF,ZRS,ZL,ZSC,EPSI(3),DOUB(3),IRN(3),
     +                BINDL8(6),RJITT, DLRSLN(3), DLZSLN(3)
C
      COMMON / CBINMC / BINMC(6)
C
      COMMON /CTRIGG/ IHIST(3),NBPTFW,TAGADC,IDUM1(4),HDUM1,
     *  HLGBRT,HLGBST,HLGQT,HLGTOT(4,2),HECAPT(4),HLGTL,HLGTH,HTGTRG,
     *                HDUM2(9),IWIDBS,NRNBSL,NRNBSH,NTOFBS,IDUM2(10),
     *                NTOFC,NTOFC1,NTOFC2,NTBGC,NTBGC1,NTBGC2,
     *                IWCOLL,IWCOLN,IWMPRG,HFMPRL,HFMPRH,HWCOLN,HMPRON,
     *                IWCTBG,NTFCOL,NTFCLN,NTFBS2,IDUM3(9),
     *  HITCLL(3),HITWLL(3),HITSUM(3),HCHAMB(3),HMASK(16,3),HDEADC(10),
     *  HACC1,HACC2,HACC3,HACC4,HACCM,HDUM6,IWIDT2,HACCB1,HACCB2,
     *  HT1ACC,HT1PSP,IDUM4(8)
C
      COMMON / CRDSTA / NDEAD, NCDEAD, HITD(10), HCELLD(10), IPHALG
C
C------------------  C O D E  ------------------------------------------
C
C     IF( NFLAGS(4) .NE. 1 ) GO TO 8000
      WRITE(6,5810) IFLAG1,IFLAG2,IFLAG3,NFLAGS(4)
5810  FORMAT('  IFLAG1-3, NFLAGS(4) ',3I3,I4)
C
C
C PRINT SMEARING CONDITIONS
C
      IF( IFLAG1 .EQ. 0) WRITE(6,200)
200   FORMAT(' =======  UNSMEARED DATA ====, THE FOLLOWING SMEARING WILL
     $ BE USED =====')
      IF( IFLAG1 .NE. 0) WRITE(6,201)
201   FORMAT(' =======  SMEARED DATA ====, THE FOLLOWING SMEARING WAS ST
     $ORED IN MTCO =====')
C
      WRITE(6,100) (BINDL8(I),I=1,6),(DRCH(I),I=26,28), DLZSLN,
     *   (DRCH(I),I=29,32),RJITT, DLRSLN, DOUB,IRN,EPSI
  100 FORMAT(20X,'  CONSTANTS FOR CENTRAL DETECTOR',/,
     * 3X,'TIMING BINS IN MM ',6(1X,F7.3),/,
     * 3X,'ZMAX ',F9.3,/,
     * 3X,'ZOF  ',F9.3,/,
     * 3X,'ZRS  ',F9.3,' Fraction of this Gaussian:',F7.4/
     * 3X,' 2nd Gaussian Shift (ZRS units)',F7.3,
     *    ' sigma (ZRS units)',F7.3/
     * 3X,'ZNORM',F9.3,/,
     * 3X,'ZL   ',F9.3,/,
     * 3X,'ZSC  ',F9.3,/,
     * 3X,'TILT ANGLE',F9.3,/,
     * 3X,'SMEAR JITTER CONSTANT ',F7.3,
     *    ' Fraction of this Gaussian:',F7.4/
     * 3X,' 2nd Gaussian Shift (JITTER units)',F7.3,
     *    ' sigma (JITTER units)',F7.3/
     * 3X,'DOUB HIT RES IN MM',3(1X,F5.2),/,
     * 3X,'NR OF RDM HITS ',3(1X,I4),/,
     * 3X,'EFFICIENCY ',3(1X,F6.3))
      WRITE(6,101) (BINMC(I),I=1,6)
  101 FORMAT(3X,'  ORIGINAL TIMING BINS IN MM FROM SIMULATION ',/,
     * 3X,6(1X,F7.3),//)
C
C
      IF( LVTXC )
     *    WRITE(6,1038) DTRSVV,(SMPRMV(I),I=1,3),ZRSVV,(EFFVV(I),I=1,2),
     *              (DOUBVV(I),I=1,3),IRNHVV
 1038 FORMAT(5X,' CONSTANTS FOR VERTEX CHAMBER FROM COMMON CBINV'/
     * 5X,'SMEAR JITTER CONSTANT ',F7.3,
     *    ' Fraction of this Gaussian:',F7.4/
     * 5X,' 2nd Gaussian Shift (JITTER units)',F7.3,
     *    ' sigma (JITTER units)',F7.3/
     * 5X,'ZRSVV                ',F9.3,/,
     * 5X,'EFFVV(1),EFFVV(2)    ',2F9.3,/,
     * 5X,'DOUBVV(1)            ',F9.3,/,
     * 5X,'DOUBVV(2)            ',F9.3,/,
     * 5X,'DOUBVV(3)            ',F9.3,/,
     * 5X,'IRNHVV               ',I9  ,/)
C
C
      IF( IFLAG1 .NE. 0 .AND. IFLAG2 .EQ. 0) WRITE(6,202)
202   FORMAT(' =======  SMEARED DATA ====, DOUBLE HIT RESO., RNDM HITS A
     $ND EFFI. NOT AVAILABLE IN MTCO')
      IF( IFLAG1 .NE. 0 .AND. IFLAG3 .EQ. 0) WRITE(6,203)
203   FORMAT(' =======  SMEARED DATA ====, OLD SCHEME HAS BEEN USED, RJI
     $TT VALUE NOT APPLICABLE')
      IF( IFLAG1 .EQ. 0) GO TO 3000
      WRITE(6,204)
204   FORMAT(' ',60('-'))
      IF( IFLAG2 .EQ. 0) WRITE(6,205)
205   FORMAT(' =======  SMEARED DATA ====, THE DETECTOR STATUS AND TRIGG
     $ER CONDITIONS WERE NOT STORED IN MTCO')
      IF( IFLAG2 .EQ. 0) GO TO 8000
      WRITE(6,206)
206   FORMAT(' =======  SMEARED DATA ====, THE DETECTOR STATUS AND TRIGG
     $ER CONDITIONS AS STORED IN MTCO FOLLOW:')
C
3000  CONTINUE
C
      JJSUM = 0
      DO 93  I = 1,16
      DO 93  J = 1,3
93    JJSUM = JJSUM + HMASK(I,J)
      KKSUM = 0
      DO 94  I = 1,10
94    KKSUM = KKSUM + HDEADC(I)
C
      WRITE(6,9104) IHIST
 9104 FORMAT(' *** DETECTOR STATUS * TRIGGER CONDITIONS ***',
     *           '  FOR ',I2,'-',I2,'-',I4,/,
     *' ==============================================================')
      IF( NDEAD .GT. 0 ) WRITE(6,9101) (HITD(I),I=1,NDEAD)
 9101 FORMAT(' LIST OF DEAD WIRES',15I5,(25X,15I5))
      IF( NCDEAD .GT. 0 ) WRITE(6,9102) (HCELLD(I),I=1,NCDEAD)
 9102 FORMAT(' LIST OF DEAD CELLS',15I5,(25X,15I5))
      IF(IPHALG.NE.0) WRITE(6,611)
  611 FORMAT('   STANDARD READOUT THRESHOLD IN LG-BLOCKS:  ENABLED')
      IF(IPHALG.EQ.0) WRITE(6,641)
  641 FORMAT('   STANDARD READOUT THRESHOLD IN LG-BLOCKS:  NOT ENABLED')
C
      IF(IHIST(3).GT.1981) GO TO 1561
C
C   1979 - 1981  TRIGGER CONDITIONS
C
      WRITE(6,601) (HLGTOT(I,1),I=1,4),HLGTL,HLGTH
 601  FORMAT(/,' ***** LATCH THRESHOLDS  *****'/
     *           ' ============================='/
     *  ' TOTAL ENERGY THRESHOLDS ',4I6/
     *  ' TAGGING AND LUMINOSITY ENERGY THRESHOLDS ',2I7)
C
      WRITE(6,602)
 602  FORMAT(/,' ***** T1 ACCEPT TRIGGER CONDITIONS  *****'/
     *           ' ========================================='/
     *  ' T1 BIT  9:  LUMINOSITY CONDITION IN COINCIDENCE ',/
     *  ' T1 BIT 10:  TOTAL LG ENERGY > THRESHOLD 1   ',/
     *  ' T1 BIT 11:  TOTAL LG ENERGY > THRESHOLD 2 AND TAG  ')
C
      WRITE(6,603) NTOFC,IWCOLL,NTFCOL
 603  FORMAT(/,' ***** T1 POSTPONE TRIGGER CONDITIONS  *****'/
     *           ' ==========================================='/
     *  ' T1 BIT  1:  TOTAL ENERGY > THRESHOLD 3, TOF GE ',I3/
     *  ' T1 BIT  2:  TAGGING CONDITION '/
     *  ' T1 BIT  5:  WIDE COPL. TOF WIDTH .LE.',I2,'  AND TOF < ',I2)
C
      IF( HWCOLN .EQ. 1) WRITE(6,606) IWCOLN, NTFCLN
  606 FORMAT(
     *  ' T1 BIT  6:  NARROW COPL. TOF WIDTH .LE.',I2,'  AND TOF < ',I2)
C
      IF( HMPRON .EQ. 1) WRITE(6,604) IWMPRG,HFMPRL,HFMPRH
  604 FORMAT(
     *  ' T1 BIT  7:  MULTIPR. COPL. TOF WIDTH .LE.',I2,' .AND.TOF.GE.',
     * I2,' .AND.TOF.LE.',I2)
C
C
C
      WRITE(6,612) HITCLL,HITWLL,HITSUM
  612 FORMAT(/   ' ***** PARAMETERS FOR TRIGGER T2 *****'/
     *           ' ==================================================='/
     *  ' HIT CELL= NO.OF HITS/CELL GT          ',3I5/
     *  ' HIT WALL= NO.OF HITS/CELL GT          ',3I5/
     *  '           AND SUM IN ADJACENT CELLS GT',3I5)
C
      IF(JJSUM.NE.48.OR.KKSUM.NE.0) WRITE(6,613) HMASK,HDEADC
  613 FORMAT(
     *  ' JETC WIRE DISABLE (=0) MASK     ',3(16I1,4X)/
     *  ' DEAD CELLS (16 WIRES SET)       ',10I4)
C
      WRITE(6,614) HACC1,HACC2,HACC3
  614 FORMAT(
     *  ' T2 ACCEPT1 (T1 POSTPONE BIT  1):   NO. ALL  TRACKS GE ',I4/
     *  ' T2 ACCEPT2 (T1 POSTPONE BIT  5):   NO. FAST TRACKS GE ',I4/
     *  ' T2 ACCEPT3 (T1 POSTPONE BIT  2):   NO. ALL  TRACKS GE ',I4)
      IF( HWCOLN .EQ. 1) WRITE(6,615) HACC4
  615 FORMAT(
     *  ' T2 ACCEPT4 (T1 POSTPONE BIT  6):   NO. FAST TRACKS GE ',I4)
      IF( HMPRON .EQ. 1) WRITE(6,616) HACCM
  616 FORMAT(
     *  ' T2 ACCEPT  (T1 POSTPONE BIT  7):   NO. ALL  TRACKS GE ',I4)
C
      IF( HWCOLN .EQ. 1) WRITE(6,617) IWIDT2
  617 FORMAT(' T2 ACCEPT2 AND 4:   TRACK COPLANARITY WIDTH ',I2)
      IF( HWCOLN .NE. 1) WRITE(6,619)
  619 FORMAT(' T2 ACCEPT2 :     NO TRACK COPLANARITY REQUIRED')
C
      WRITE(6,610)
  610 FORMAT(' ==================================================')
C
      GO TO 8000
C
C   1982 - 1986 TRIGGER CONDITIONS
C
1561  CONTINUE
C
      WRITE(6,701) HLGBRT,HLGBST,HLGQT,HLGTOT,HECAPT,HLGTL,HLGTH
 701  FORMAT(/,' ***** LATCH THRESHOLDS  *****'/
     *           ' ============================='/
     *  ' THRESHOLDS FOR BARREL GROUPS',I4,',  BARREL SEPTANTS',I4,
     *  ',  ENDCAP QUADRANTS',I4/
     *  ' THRESHOLDS FOR TOTAL ENERGY  ',4I5,/,
     *  '                BARREL ENERGY ',4I5,/,
     *  '                ENDCAP ENERGY ',4I5,/,
     *  ' THRESHOLDS FOR TAGGING AND LUMINOSITY ENERGY ',2I6)
C
      IF(IHIST(3).EQ.1982) GO TO 1562
      IF(HTGTRG.EQ.0) WRITE(6,699)
699   FORMAT('    INNER RING INCLUDED IN TAGGING CONDITION')
      IF(HTGTRG.EQ.1) WRITE(6,698)
698   FORMAT('    INNER RING NOT INCLUDED IN TAGGING CONDITION')
C
1562  CONTINUE
      WRITE(6,702)
 702  FORMAT(/,' ***** T1 ACCEPT TRIGGER CONDITIONS  *****'/
     *           ' ========================================='/
     *  ' T1ACC BIT  1:  LUMINOSITY CONDITION IN COINCIDENCE ',/
     *  ' T1ACC BIT  2:  TOTAL ENERGY > THRESHOLD 1   ',/
     *  ' T1ACC BIT  3:  TOTAL ENERGY > THRESHOLD 3 AND TAG  ')
      IF (IHIST(3).GT.1985) WRITE(6,703)
 703  FORMAT(
     *  ' T1ACC BIT  5:  SEPTANT - ECAP QUADRANT COPLANARITY, TOF < 1')
      WRITE(6,704)
 704  FORMAT(
     *  ' T1ACC BIT  9:  BOTH ENDCAP ENERGIES > THRESHOLD 2  ',/
     *  ' T1ACC BIT 10:  SUM OF ECAP ENERGIES > THRESH. 3 AND',
     *  ' BARREL ENERGY > THRESH. 4',/
     *  ' T1ACC BIT 11:  TAG AND BARREL > THRESHOLD 4',/
     *  ' T1ACC BIT 12:  BARREL > THRESHOLD 2',/
     *  ' T1ACC BIT 13:  BOTH ECAP ENERGIES > THRESH. 4  AND ',
     *  ' TOTAL ENERGY > THRESH. 2')
      WRITE(6,705) NRNBSL,NRNBSH,IWIDBS,NTOFBS
 705  FORMAT(
     *  ' T1ACC BIT 14:  NR OF BARREL SEPTANTS GE',I3,', LE',I3,
     *  ',  WIDTH = ',I3,', TOF <',I3)
      IF (IHIST(3).GT.1982) WRITE(6,706) NTOFBS
 706  FORMAT(
     *  ' T1ACC BIT 15:  TAGGING CONDITION AND >= 1 SEPTANT, TOF <',I3)
C
C
C
      WRITE(6,709) NTOFC,NTOFC1,NTOFC2,NTBGC2,NTBGC1,NTBGC
 709  FORMAT(/,' ***** T1 POSTPONE TRIGGER CONDITIONS  *****'/
     *           ' ==========================================='/
     *  ' T1PSP BIT  1:  TOTAL ENERGY > THRESHOLD 4, TOF GE ',I3/
     *  ' T1PSP BIT  3:  SUM OF ECAP ENERGIES > THRESHOLD 2, TOF GE',I2/
     *  ' T1PSP BIT  4:  TOF < ',I2,' TBG NEIGHBOR SUPRESSED GE ',I3/
     *  ' T1PSP BIT  9:  TBG > ',I3,',  BARREL ENERGY > THRESHOLD 4',/
     *  ' T1PSP BIT 10:  TAGGING CONDITION AND TBG > ',I2)
      IF (IHIST(3).GT.1984) WRITE(6,710) NTFBS2
 710  FORMAT(
     *  ' T1PSP BIT 11:  SEPTANT COPLANARITY LIKE T1ACC BIT 14,',
     *  ' TOF > 0 AND TOF < ',I2)
      IF (IHIST(3).GT.1985) WRITE(6,711)
 711  FORMAT(
     *  ' T1PSP BIT 12:  TAGGING CONDITION, TOF > 0, >= 1 SEPTANT')
      WRITE(6,712) IWCOLL,NTFCOL,IWCOLN,NTFCLN,IWCTBG
 712  FORMAT(
     *  ' T1PSP BIT 13:  WIDE COPL. TOF WIDTH .LE.',I2,
     *  '  AND TOF <',I2,/
     *  ' T1PSP BIT 14:  NARROW COPL. TOF WIDTH .LE.',I2,
     *  '  AND TOF <',I2,/
     *  ' T1PSP BIT 15:  COPL. TBG WIDTH .LE.',I2)
      IF (IHIST(3).GT.1984) WRITE(6,717) HT1ACC,HT1PSP
 717  FORMAT(
     *  ' T1 ACCEPT AND ENABLE WORDS (HEAD 37-38), ',Z4,2X,Z4,' (HEX.)')
C
C  T2 ACCEPT
C
      WRITE(6,612) HITCLL,HITWLL,HITSUM
C
      IF(JJSUM.NE.48.OR.KKSUM.NE.0) WRITE(6,613) HMASK,HDEADC
C
      WRITE(6,713) HACC1,HACC2,HACC3,HACC4
 713  FORMAT(
     *  ' T2 ACCEPT1 (T1 POSTPONE BIT  1):   NO. ALL  TRACKS GE ',I4/
     *  ' T2 ACCEPT1 (T1 POSTPONE BIT  4):   NO. ALL  TRACKS GE ',I4/
     *  ' T2 ACCEPT3 (T1 POSTPONE BIT  9):   NO. FAST TRACKS GE ',I4/
     *  ' T2 ACCEPT3 (T1 POSTPONE BIT 10):   NO. FAST TRACKS GE ',I4)
C
      IF (IHIST(3).GT.1984) WRITE(6,714) HACCB1
 714  FORMAT(
     *  ' T2 ACCEPT3 (T1 POSTPONE BIT 11):   NO. ALL  TRACKS GE ',I4)
C
      IF (IHIST(3).GT.1985) WRITE(6,715) HACCB2
 715  FORMAT(
     *  ' T2 ACCEPT3 (T1 POSTPONE BIT 12):   NO. ALL  TRACKS GE ',I4)
C
      WRITE(6,716) IWIDT2
 716  FORMAT(
     *  ' T2 ACCEPT4 (T1 POSTPONE BIT 13-15):   NO. FAST TRACKS GE 2 ',
     *  ', COLLINEAR TRACKS, WIDTH <= ',I4)
      WRITE(6,630)
  630 FORMAT(' =================================================='/)
C
 8000 CONTINUE
      RETURN
      END
