C   10/06/86 807251616  MEMBER NAME  SCANNR   (S)        M  FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE SCANNR(INDEX,IRFLG)
C-----------------------------------------------------------------------
C
C   AUTHOR:   J. OLSSON   19/06/79 :  GRAPHICS * OTHER COMMANDS
C
C        MOD: C. BOWDERY  16/03/84 :  COMMAND ND50 ADDED
C        MOD: C. BOWDERY  20/06/84 :  REVERSE JADISP AND EVDISP CALLS
C        MOD: C. BOWDERY   5/07/84 :  FOR DS CHANGING DURING SESSION
C        MOD: J. HAGEMANN 19/10/84 :  FOR NEW COMMAND VAC (130)
C        MOD: C. BOWDERY  17/07/85 :  COMMANDS REMOVED, TIDYING UP.
C        MOD: C. BOWDERY  18/07/85 :  CHANGES FOR NAMED MACROS
C        MOD: C. BOWDERY   3/08/85 :  IMPROVED TERMINATION, + EDITMAC
C        MOD: C. BOWDERY   5/08/85 :  RENAMAC AND DELMAC ADDED
C        MOD: C. BOWDERY   9/08/85 :  CSTV2 AND STANDARD VIEW BUG FIXED
C        MOD: C. BOWDERY  12/08/85 :  COMMAND LIM REMOVED
C        MOD: C. BOWDERY  10/06/86 :  NEW COMMON FOR STANDARD VIEW DATA
C        MOD: G. ECKERLIN 31/07/86 :  NEW COMMAND J68K (135) ADDED
C        MOD: J. HAGEMANN 08/09/86 :  FOR BDLS WITH ARGUMENTS
C   LAST MOD: G. ECKERLIN 15/05/87 :  NEW COMMAND ZFIT (136) ADDED
C
C        ROUTINE CALLED FROM USER TO REQUEST SCANNER GUIDANCE.
C
C-----------------------------------------------------------------------
C
C  INDEX CONTAINS CURRENT USER INDEX VALUE.
C  W A R N I N G :   INDEX IS INCREMENTED ON RETURN.
C
C  XMIN,XMAX,YMIN,YMAX   HOLD CURRENT VIEW DIMENSIONS
C  SXIN,SXAX,SYIN,SYAX   HOLD CURRENT STANDARD VIEW DIMENSIONS
C               (OBTAINED BY CALLING SETSCL(0), SET BY GPHMAIN)
C  XMINR,YMINR,XMAXR,YMAXR  HOLD CURRENT MAGNIFIED DIMENSIONS
C               (SET BY SUBROUTINE JOYS)
C
C  ISTVW: 1 IF CURRENT VIEW IS STANDARD VIEW, OTHERWISE 0
C  FL18  TRUE IF PROJECTION
C  FL22  TRUE IF MAGNIFICATION ON
C  FL24  TRUE IF STANDARD VIEW IS MAGNIFIED
C
C  HCSTV2 SET TO 1 IF AUTO DISPLAY IS ON (DEFAULT)
C  HDISPN IS SET = HCSTV2. USED SEPARATELY IN COMMAND FIND
C  HCSTV3 IS SET TO 1 IF AUTO DETECTOR DISPLAY IS ON (DEFAULT -1)
C
C  IRFLG IS CARRYING FLAG NUMBER IN COMMAND SETF
C
C  HREVT IS USED IN COMMAND FIND, IS SET TO 1 IF EVENT FOUND
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL SSTPSR(10)
      LOGICAL DSPDTM
      LOGICAL FL18,FL22,FL24,DSPREM
C
      COMMON / CPROJ / XMINR,XMAXR,YMINR,YMAXR,IPRJC,FL18,FL22,FL24
      COMMON / CVX   / NNPATR,ICRSTR,NNJETC
C
C                  NNPATR : FOR CHANGING PATR BANK NR
C                  NNJETC : FOR CHANGING JETC BANK NR
C                  ICRSTR STEERS RECORD FINDING IN COMMANDS WRIT N,
C                  WHERE SEVERAL EVENTS
C                  MAY BE READ BY SUPERV, BEFORE THE WANTED ONE APPEARS.
C                  SPECIAL CARE BY REWINDING UPON EOF ENCOUNTER.
C
C-----------------------------------------------------------------------
C                            MACRO CGRAPH .... GRAPHICS COMMON
C-----------------------------------------------------------------------
C
      LOGICAL DSPDTL,SSTPS,PSTPS,FREEZE
C
      COMMON / CGRAPH / JUSCRN,NDDINN,NDDOUT,IDATSV(11),ICREC,MAXREC,
     +                  LSTCMD,ACMD,LASTVW,ISTANV,
     +                  SXIN,SXAX,SYIN,SYAX,XMIN,XMAX,YMIN,YMAX,
     +                  DSPDTL(30),SSTPS(10),PSTPS(10),FREEZE(30),
     +                  IREADM,LABEL,LSTPS(10),IPSVAR
C
C------- END OF MACRO CGRAPH -------------------------------------------
C
C-----------------------------------------------------------------------
C                            MACRO CJDRCH .... JET CHAMBER CONSTANTS.
C-----------------------------------------------------------------------
C
      COMMON / CJDRCH / RDEC(4),PSIIN(3),RINCR(3),FIRSTW(3),FSENSW(3),
     +                  RDEPTH,SWDEPL,YSUSPN,TIMDEL(2,3),ZMAX,ZOFFS,
     +                  ZRESOL,ZNORM,ZAL,ZSCAL,DRIDEV,DRICOS,DRISIN,
     +                  PEDES,TZERO(3),DRIROT(96,2),SINDRI(96,2),
     +                  COSDRI(96,2),DRIVEL(96,2),T0FIX(3),
     +                  ABERR(8), DUMJDC(20)
C
C      BLOCK DATA SET TO MC VALUES, KALIBR WILL SET REAL DATA VALUES
C--->  A CHANGE OF THIS COMMON MUST BE DONE SIMULTANEOUSLY WITH  <----
C--->  A CHANGE OF THE BLOCK DATA                                <----
C
C--------------------------- END OF MACRO CJDRCH -----------------------
C
C-----------------------------------------------------------------------
C                            MACRO CGEO1 .... JADE GEOMETRY
C-----------------------------------------------------------------------
C
      COMMON / CGEO1 / BKGAUS,
     +                 RPIP,DRPIP,XRLPIP,   RBPC,DRBPC,XRLBPC,
     +                 RITNK,DRITNK,XRLTKI, R0ROH,DR0ROH,XR0ROH,
     +                 R1ROH,DR1ROH,XR1ROH, R2ROH,DR2ROH,XR2ROH,
     +                 R3ROH,DR3ROH,XR3ROH, ROTNK,DROTNK,XRLTKO,
     +                 RTOF,DRTOF,XRTOF,    RCOIL,DRCOIL,XRCOIL,
     +                 ZJM,DZJM,XRZJM,ZJP,DZJP,XRZJP,ZTKM,DZTKM,XRZTKM,
     +                 ZTKP,DZTKP,XRZTKP,ZBPPL,ZBPMI,ZTOFPL,ZTOFMI,
     +                 XRJETC,RLG,ZLGPL,ZLGMI,OUTR2,CTLIMP,
     +                 CTLIMM,DELFI,BLXY,BLZ,BLDEP,ZENDPL,ZENDMI,DEPEND,
     +                 XHOL1,XHOL2,YHOL1,YHOL2,BLFI
C
C------------------------- END OF MACRO CGEO1 --------------------------
C
C------------------------------------------
C  MACRO CLBPGM ....
C------------------------------------------
      COMMON /CLBPGM/ LBPGM(30)
C--------- END OF MACRO CLBPGM ------------
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
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
      COMMON / CGRAP2 / BCMD,DSPDTM(30),ISTVW,JTVW
      COMMON / CSVCW1 / NDDSVE,NRWR
      COMMON / CHEADR / HEAD(108)
      COMMON / CSTANV / HDISPN, HCSTV2, HCSTV3
C
      EQUIVALENCE (NAME,A1)
C
      DATA  JETC/ 'JETC' /
      DATA  HREVT/ 0 /, IENTW/ 0 /
C
C
C------------------  C O D E  ------------------------------------------
C
C                            LSTCMD=112 IS COMMAND WRIT.
C                            IF WRIT N WAS GIVEN, SCANNR WILL RETURN TO
C                            READ A NEW EVENT UNTIL ICREC
C                            AND ICRSTR AGREE.
C
 2000 IF( LSTCMD .EQ. 112  .AND.  ICREC .NE. ICRSTR ) GO TO 2001
      IF( HREVT .EQ. 0 ) GO TO 2002
      IF( HEAD(18) .EQ. NRREQU  .AND.  HEAD(19) .EQ. NEREQU ) GO TO 2003
      IF( ICREC .NE. ICRSTR ) GO TO 2001
      CALL TRMOUT(80,' Requested event NOT FOUND on file.^')
      CALL PROMPT
C
2003  DO 2004  I = 1,10
        SSTPS(I) = SSTPSR(I)
2004  CONTINUE
      HREVT = 0
      IF( .NOT. SSTPS(2) ) GO TO 108
      GO TO 2002
2001  INDEX = 0
C
C                            RETURN TO USER, READ NEXT EVENT
C
      RETURN
C
2002  IRFLG =  0
      ISTVW =  1
      JTVW  = 60
      CALL SETSCL(0)
C                            SET CURRENT VIEW TO STANDARD VIEW
      LASTVW = ISTANV
C
      IF( HDISPN .NE. 1 ) GO TO 1
      DSPREM = DSPDTL(9)
      IF( ISTANV .EQ.  6  .OR.  ISTANV .EQ.  7  .OR.
     +    ISTANV .EQ. 10  .OR.  ISTANV .EQ. 11     ) DSPDTL(9) = .FALSE.
      IF( ISTANV .EQ. 17)  CALL SETSCL(ISTANV)
      CALL ERASE
      CALL EVDISP(ISTANV)
      IF( HCSTV3 .EQ. 1 ) then
         call setcol('JADE')    ! PMF 23/11/99: set colour
         CALL JADISP(ISTANV)
         call setcol(' ')       ! PMF 23/11/99: reset colour
      endif
      IF( DSPDTL(16)    ) CALL RSDISP(ISTANV)
      DSPDTL(9) = DSPREM
      IF( DSPDTL(17)    ) CALL PROJEC(ISTANV)
      HDISPN = 0
C
C                            ASK FOR A COMMAND
C
   1  CALL KOMMAN
      A  = ACMD
      AB = BCMD
      N  = A
      NB = AB
C
C                            EXECUTE COMMAND
C
C                            COMMANDS 1 - 100 ARE HANDLED BY DISPLY
C                            SINCE THESE DO NOT CHANGE /CWORK/ AND CAN
C                            BE CALLED FROM THE EDIT SUBSYSTEM.
C                            COMMANDS 1 - 30 ARE VIEWS
C
      IF( LSTCMD .GT. 100 ) GO TO 2
C
        CALL DISPLY
        GO TO 1
C
   2  ICOMD1 = ( LSTCMD - 101 ) / 10  +  1
      ICOMD2 = MOD( LSTCMD - 100, 10 )
      IF( ICOMD2 .EQ. 0 ) ICOMD2 = 10
C
      GO TO ( 1110, 1120, 2130, 3140 ) , ICOMD1
C
   5  CALL TRMOUT(80,'Software Error!  Please contact graphics expert^')
      CALL TRMOUT(80,'Command interpreter overflow in SCANNR^')
      RETURN
C
 1110 GO TO ( 101, 102, 103, 104, 105, 106, 107, 108, 109, 110) , ICOMD2
 1120 GO TO ( 111, 112, 113, 114, 115, 116, 117, 118, 119, 120) , ICOMD2
 2130 GO TO ( 121, 122, 123, 124, 125, 126, 127, 128, 129, 130) , ICOMD2
 3140 GO TO ( 131, 132, 133, 134, 135, 136,   5,   5,   5,   5) , ICOMD2
C
C
C             COMMAND  SPVA  (SPARE VIEW)
C
 101  CALL SPARE
      GO TO 1
C
C             COMMAND CLUS   (LG CLUSTER RESULTS DISPLAY)
C
 102  CALL YAMADA(N)
      GO TO 1
C
C             COMMAND   ZV
C
 103  DSPREM = DSPDTL(9)
      IF( LASTVW .EQ.  6  .OR.  LASTVW .EQ.  7 ) DSPDTL(9) = .FALSE.
      IF( LASTVW .EQ. 10  .OR.  LASTVW .EQ. 11 ) DSPDTL(9) = .FALSE.
      IF( N .EQ. 0 ) GO TO 1032
      DO  1031  I=1,30
        LBPGM(I) = 0
 1031 CONTINUE
      CALL ZVERTF
 1032 CALL ZINTER
      DSPDTL(9) = DSPREM
      GO TO 1
C
C             COMMAND GVTX   (VERTEX FIT OF CHOSEN TRACKS)
C
 104  CALL GVTXFT
      GO TO 1
C
C             COMMAND MUPT   (MUON RESULTS DISPLAY)
C             COMMAND MUONS  (= MUPT 1000 UNLESS ARGUMENT GIVEN)
C
 106  IF( ACMD .EQ. 0.0 ) ACMD = 1000.0
 105  DSPREM = DSPDTL(9)
      IF( LASTVW .EQ.  6  .OR.  LASTVW .EQ.  7 ) DSPDTL(9) = .FALSE.
      IF( LASTVW .EQ. 10  .OR.  LASTVW .EQ. 11 ) DSPDTL(9) = .FALSE.
      CALL MULDSP
      DSPDTL(9) = DSPREM
      IF( DSPDTL(17) ) CALL PROJEC(LASTVW)
      GO TO 1
C
C             COMMAND BDLS   (DELETE SINGLE BANK)
C
 107  IF( A .EQ. 0.0 ) GO TO 10700
         A1 = A
         GO TO 10701
10700 CALL TRMOUT(80,'PLease enter name of bank to be deleted:^')
      CALL TRMIN(4,NAME)
10701 IPNAME = IDATA(IBLN(NAME))
      IF( IPNAME .LT. 1 ) GO TO 1071
      LIM1 = IPNAME - 2
      NBOS = IDATA(LIM1)
      IF( NAME .NE. JETC ) GO TO 1072
C
C                            SPECIAL FOR JETC BANK
C
      IPNNEX = IDATA(IPNAME-1)
      NBOS2  = IDATA(IPNNEX-2)
      CALL BDLS('JETC',NBOS)
      CALL BRNM(JETC,NBOS2,JETC,NBOS)
      GO TO 1079
 1071 CALL TRMOUT(80,'The specified bank does not exist.^')
      GO TO 1
C
C                            CHECK IF MORE THAN ONE BANK
C                            WITH SAME NAME. IF SO, REQUEST NUMBER.
C
 1072 IF(IDATA(LIM1+1).EQ.0) GO TO 1077
      IF( AB .EQ. -100.0 ) GO TO 1078
      IF( AB .LE. 0.0  .OR.  AB .GT. 99.0 ) GO TO 10703
         NBOS = IFIX(AB)
         GO TO 1075
10703 CALL TRMOUT(80,'The following BOS bank numbers are present:^')
      LM1 = LIM1
 1073 CALL DIAGIN('                    ',1,IDATA(LM1),N,N,N,N,N)
      IF(IDATA(LM1+1).EQ.0) GO TO 1074
      LM1 = IDATA(LM1+1)-2
      GO TO 1073
 1074 CALL TRMOUT(80,'Please enter desired BOS bank number.^')
      CALL TRMOUT(80,'Enter -100 to delete ALL banks of this name:^')
      NBOS = TERNUM(DUMMY)
      IF( NBOS .EQ. -100 ) GO TO 1078
 1075 IF( NBOS .EQ. IDATA(LIM1) ) GO TO 1077
      IF( IDATA(LIM1+1) .NE. 0 ) GO TO 1076
      GO TO 1071
 1076 LIM1 = IDATA(LIM1+1) - 2
      GO TO 1075
 1077 NAME = IDATA(LIM1-1)
      CALL BDLS(NAME,NBOS)
      GO TO 1079
 1078 CALL BMLT(1,NAME)
      CALL BDLM
 1079 CALL BGAR(IGA)
      GO TO 1
C
C        COMMANDS WHICH CONTROL FURTHER PROGRESS THROUGH THE STEPS IN
C        USER
C
C             COMMAND    C   (CONTINUE TO NEXT STOPPING LEVEL)
C
 108  HDISPN = HCSTV2
      FL22   = FL24
      IF( .NOT. FL24) RETURN
9865  XMINR = SXIN
      XMAXR = SXAX
      YMINR = SYIN
      YMAXR = SYAX
      RETURN
C
C             COMMAND JUMP   (JUMP TO SPECIFIED LEVEL)
C
 109  IF( N .NE. 0 ) GO TO 1093
 1091 WRITE(JUSCRN,1092) INDEX
 1092 FORMAT(' Currently at USER level ',I4/
     +       ' Please enter next USER level:')
      N=TERNUM(DUMMY)
 1093 IF( N .GE. 0  .AND.  N .LE. 10 ) GO TO 1095
      WRITE(JUSCRN,1094) N
 1094 FORMAT('Illegal level ',I4,' requested. Please try again.')
      GO TO 1091
 1095 INDEX  = N - 1
      HDISPN = HCSTV2
      FL22   = FL24
      IF( .NOT. FL24 ) RETURN
      XMINR = SXIN
      XMAXR = SXAX
      YMINR = SYIN
      YMAXR = SYAX
      RETURN
C
C             UNUSED COMMAND
C
 110  CONTINUE
      GO TO 1
C
C        COMMANDS WHICH STEER THE PROCESSING OF FURTHER EVENTS.
C
C             COMMAND    N   (GO TO NEXT EVENT)
C
 111  INDEX = 0
 1111 IF( N .EQ. 0 ) N = 1
      NDES = ICREC + N
      IF( NDES .GT. 0 ) GO TO 3202
      WRITE(6,1112) ICREC,N
 1112 FORMAT(' Error: Negative EVENT NUMBER requested.'/
     +  ' The current EVENT NUMBER and the INCREMENT requested = ',2I6/
     +  ' Please enter a new command.')
      GO TO 1
 3202 IF( N .GT. 0 ) GO TO 1113
        REWIND NDDINN
        ICREC = 0
        CALL BDLS('+BUF',NDDINN)
        GO TO 1114
 1113 NDES = NDES - ICREC
C
C                           GET THE SUPERVISOR TO READ THE REQUIRED
C                           EVENT. HERE JUST SKIP N-1 EVENTS
C
 1114 NDES = NDES - 1
      IF( NDES .EQ. 0 ) GO TO 3201
C
      DO  3203  I = 1,NDES
        CALL BSLT
        CALL BDLG
        CALL BREAD(NDDINN,*3204,*3205)
        IF( IDATA(IBLN('HEAD')) .LE. 0 ) GO TO 3206
3207    ICREC = ICREC + 1
        GO TO 3203
3206    IFLG = 100
        CALL EVREAD(NDDINN,IRETU)
        IFLG = 0
        GO TO 3207
 3204   CALL MESSAG(1)
        GO TO 3203
 3205   REWIND NDDINN
        CALL BDLS('+BUF',NDDINN)
        CALL TRMOUT(80,'No such event. End-of-file encountered.^')
      CALL TRMOUT(80,'Action: Return to beginning of input file.^')
      WRITE(JUSCRN,1946) ICREC
 1946 FORMAT(' Note: There are ',I6,' events on this file.')
      CALL PROMPT
      ICREC = 0
      N=0
      GO TO 1111
 3203 CONTINUE
 3201 HDISPN = HCSTV2
      FL22   = FL24
      IF( .NOT. FL24 ) RETURN
      XMINR  = SXIN
      XMAXR  = SXAX
      YMINR  = SYIN
      YMAXR  = SYAX
      RETURN
C
C             COMMAND WRIT   (WRITE OUT EVENT(S) AND GO TO NEXT)
C
 112  INDEX  = 10
      IENTW  = IENTW + 1
      IF( IENTW .EQ. 1 ) CALL WALLOC
      NRTOT  = NRWR + NRWRIT + 1
      NRWRIY = NRWRIT + 1
      WRITE(6,2705) NRWRIY,NRTOT
2705  FORMAT(' No. of events written: ',I4,3X,
     +       ' No. of events on output file: ',I4)
      ICRSTR = ICREC + 1
      IF( N .NE. 0 ) ICRSTR = ICREC + N
      HDISPN = HCSTV2
      FL22   = FL24
      IF( FL24 ) GO TO 9865
      RETURN
C
C             COMMAND  STOP, END, EXIT, QUIT
C
 113  INDEX = 11
      CALL CLRCON
      RETURN
C
C        COMMANDS WHICH PERMANENTLY ALTER PARAMETERS, I.E. FOR CURRENT
C        AND SUBSEQUENT EVENTS.
C
C
C             COMMAND  CSTL  (CHANGE STANDARD STOPPING LEVELS)
C
 114  CALL STPLST
      GO TO 1
C
C             COMMAND  CSTV  (CHANGE STANDARD DEFAULT VIEW)
C
 115  IF( N .NE. 0 ) GO TO 3603
 3604 CALL TRMOUT(80,'List of options:^')
      CALL TRMOUT(80,' 1 Make the current view the  Standard View.^')
      CALL TRMOUT(80,' 2 Turn ON/OFF automatic display of new event.^')
      CALL TRMOUT(80,' 3 Turn ON/OFF detector with Standard View.^')
      CALL TRMOUT(80,'Please enter option number:^')
      N=TERNUM(DUMMY)
      IF(N.GE.1.AND.N.LE.3) GO TO 3603
      CALL TRMOUT(80,'No such option exists. Please try again.^')
      GO TO 3604
3603  IF(N.EQ.2) HCSTV2=-HCSTV2
      IF(N.EQ.3) HCSTV3=-HCSTV3
      IF(N.NE.1) GO TO 1
      ISTANV=LASTVW
      SXIN=XMIN
      SXAX=XMAX
      SYIN=YMIN
      SYAX=YMAX
      FL24 = FL22
      GO TO 1
C
C             UNUSED COMMAND
C
 116  CONTINUE
      GO TO 1
C
C             UNUSED COMMAND
C
 117  CONTINUE
      GO TO 1
C
C             COMMAND  EDIT  (EDIT PATTERN RECOGNITION RESULTS)
C
C
C             BEFORE CALLING PREDIT DO GARBAGE COLLECTION TO ASSURE THAT
C             JETC WILL NOT MOVE DURING EDITING. THIS WOULD DESTROY THE
C             VALIDITY OF THE PATTERN RECOGNITION'S CYCLIC POINTERS.
C
 118  CALL BGAR(IGARBA)
      CALL PREDIT
      GO TO 1
C
C             COMMAND  DEDX  (DISPLAY DEDX RESULTS ON SCREEN)
C
 119  call setcol('TEXT') ! PMF 25/11/99: set color
      CALL DEDXDS
      call setcol(' ') ! PMF 25/11/99: reset color
      GO TO 1
C
C             COMMAND  QP    (DISPLAY Q-PLOT * OTHER Q-OPTIONS)
C
 120  call setcol('TEXT') ! PMF 25/11/99: set color
      CALL QPLOTS
      call setcol(' ') ! PMF 25/11/99: reset color
      GO TO 1
C
C             COMMAND  TOF   (DISPLAY TOF RESULTS ON SCREEN )
C
 121  call setcol('TEXT') ! PMF 25/11/99: set color
      CALL TOFDS
      call setcol(' ') ! PMF 25/11/99: reset color
      GO TO 1
C
C             COMMAND  FIND  (DISPLAY TOF RESULTS ON SCREEN )
C
 122  IF( NB .NE. 0 ) GO TO 6203
 622  CALL TRMOUT(80,'Please enter desired RUN and EVENT numbers.^')
      CALL FYRINT(N,NB,IDM3,IDM4)
 6203 WRITE(JUSCRN,6201) N,NB
 6201 FORMAT(' Search will begin for RUN, EVENT',2I8)
      CALL TRMOUT(80,'Is this correct?^')
      CALL DECIDE(IANSW)
      IF(IANSW.EQ.2) GO TO 622
      DO 6221  I = 1,10
      SSTPSR(I) = SSTPS(I)
6221  SSTPS(I) = .FALSE.
      SSTPS(2) = .TRUE.
      NRREQU = N
      NEREQU = NB
      HDISPN=1
      HREVT=1
      ICRSTR=ICREC
      GO TO 2001
C
C             COMMAND  AX    (DISPLAY JET AXES AND RELATED RESULTS)
C
 123  DSPREM = DSPDTL(9)
      IF(LASTVW.EQ.6.OR.LASTVW.EQ.7) DSPDTL(9) = .FALSE.
      IF(LASTVW.EQ.10.OR.LASTVW.EQ.11) DSPDTL(9) = .FALSE.
      CALL AXSHOW
      DSPDTL(9) = DSPREM
      IF(.NOT.DSPDTL(17)) GO TO 1
      IF(LASTVW.GT.3.AND.LASTVW.NE.14) GO TO 1
      FL18 = .TRUE.
      LAST = LASTVW
      JVIEW = LASTVW + 3
      IF(LASTVW.EQ.14) JVIEW = 4
      ISTX = 3095
      IADD = 1000
      ISTY = 2250
      IF(JVIEW.NE.5) GO TO 1621
      ISTX = 3195
      IADD = 900
1621  CALL TWINDO (ISTX,ISTX+IADD,0,IADD)
      CALL SETSCL(JVIEW)
      DSPDTL(9) = .NOT.DSPDTL(9)
      CALL JADISP(JVIEW)
      LASTVW = JVIEW
      CALL AXSHOW
      CALL TWINDO (ISTX,ISTX+IADD,ISTY,ISTY+IADD)
      JVIEW = JVIEW + 4
      CALL SETSCL(JVIEW)
      CALL JADISP(JVIEW)
      LASTVW = JVIEW
      CALL AXSHOW
      DSPDTL(9) = .NOT.DSPDTL(9)
      CALL TWINDO (0,4095,0,4095)
      LASTVW = LAST
      CALL SETSCL(LAST)
      FL18 = .FALSE.
      IF(.NOT.FL22) GO TO 1
      XMIN = XMINR
      XMAX = XMAXR
      YMIN = YMINR
      YMAX = YMAXR
      CALL DWINDO (XMIN,XMAX,YMIN,YMAX)
      GO TO 1
C
C             COMMAND  FADC  (DISPLAY FLASH ADC RESULTS FOR TEST WIRES)
C
 124  CALL DSFADC
      GO TO 1
C
C             COMMAND  ZTRG  (DISPLAY FLASH ADC RESULTS FOR Z-TRIGGER)
C
 125  CALL ZTRGVW
      GO TO 1
C
C             COMMAND  NWCL  (RECAL. OF LG AND JETC DATA + REANALYSIS)
C
 126  CALL NEWCAL
      GO TO 1
C
C             COMMAND  FAMP  (DISPLAY OF FAMP RESULT (PATREC RESULTS..))
C
 127  CALL FAMPDS
      GO TO 1
C
C             COMMAND  ND50  (DISPLAY OF NORD 50 FOUND TRACKS)
C
 128  CALL N50SDS
      GO TO 1
C
C             COMMAND  MORE  (ALLOCATE ANOTHER INPUT DATASET)
C
 129  CALL MORE( IRETU )
      IF( IRETU .NE. 0 ) GO TO 1
        INDEX  = 0
        HDISPN = HCSTV2
        FL22   = FL24
        IF( .NOT. FL24 ) RETURN
        XMINR  = SXIN
        XMAXR  = SXAX
        YMINR  = SYIN
        YMAXR  = SYAX
        RETURN
C
C             COMMAND  VAC   (DRAW SIGNAL AMPLITUDES FOR SELECTED
C                             VERTEX CHAMBER CELL)
C
 130  CALL DSVAC
      GO TO 1
C
C
C        COMMANDS WHICH DEAL WITH MACROS
C
C             COMMAND  MACRO (DEFINE A SEQUENCE OF COMMANDS = MACRO)
C
 131  CALL DEFMAC
      GO TO 1
C
C             COMMAND  EDITMAC (EDIT A MACRO)
C
 132  CALL EDIMAC
      GO TO 1
C
C             COMMAND  DELMAC (DELETE A MACRO)
C
 133  CALL DELMAC
      GO TO 1
C
C             COMMAND  RENAMAC (RENAME A MACRO)
C
 134  CALL RENMAC
      GO TO 1
C
C             COMMAND  J68KDS (DISPLAY JET-CHAMBER RAWDATA)
C
 135  CALL J68KDS
      GO TO 1
C
C             COMMAND  ZFIT (DISPLAY Z-FIT WITH REJECTED/ACCEPTED HITS)
C
 136  CALL ZFIT
      GO TO 1
C
      END
