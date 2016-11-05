C   29/06/79 807251746  MEMBER NAME  GVTXFT   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE GVTXFT 
C-----------------------------------------------------------------------
C
C    AUTHOR:   J. OLSSON   28/05/82 :  VERTEX FIT FOR TRACKS
C
C       MOD:   J. OLSSON   27/02/84 :
C       MOD:   C. BOWDERY   8/06/84 :  NEW COMMAND NUMBERS
C       MOD:   J. HAGEMANN 26/06/86 :  ALLOW AXIS CONSTAINT AND DRAW
C                                      VERTEX WITH ITS ERRORS IN
C                                      VRX-VIEW
C       MOD:   J. HAGEMANN 26/07/86 :  BIT INFORMATION UPDATED
C       MOD:   J. HAGEMANN 09/01/87 :  FOR DAVIDON-ALGORITHM AND ERROR
C                                      ELLIPSE
C       MOD:   J. HAGEMANN 25/03/87 :  BIT 24 INTRODUCED FOR MODE-FLAG
C       MOD:   J. HAGEMANN 21/10/87 :  FOR CONVERSION SEARCH
C       MOD:   J. HAGEMANN 30/11/87 :  FOR PROBABILITY CALCULATION
C  LAST MOD:   J. HAGEMANN 21/01/88 :  FOR HWDS-BANK
C
C        PERFORMS THE DITTMANN FIT FOR GIVEN INPUT TRACKS
C        INPUT GIVEN FROM SCREEN : TRACK NUMBER.
C        ADAPTED FROM SUBROUTINE EFMASS
C        COMMAND GVTX WITH TRAILING NUMBER 1    : WITH AXIS CONTRAINT
C        COMMAND GVTX WITH TRAILING NUMBER 1024 : PHOTON CONVERSION FIT
C
C        T(1500) --> T(2000) KLE
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL TBIT
      LOGICAL LVTXC, LNHARD, NEWDET
      LOGICAL FLVCDO
C
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
      COMMON / CJTRIG / PI,TWOPI
      COMMON / CVCEX  / LVTXC
      COMMON / CGVCDO / FLVCDO(20)
      COMMON / CHEADR / HEAD(108)
      COMMON / CVX    / NNPATR
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C   23/03/97 703231948  MEMBER NAME  MVERTEX0 (PATRECSR)    SHELTRAN
C**HEADER*** MEMBER  MVERTEX0       SAVED BY F22HAG  ON 88/05/24  AT 17:56
C     PARAMETER MACRO FOR VERTEX-FIT ROUTINES
      COMMON /CVTXC/ XB,YB,ZB,RTANK,DTANK,X0INN,SIGX0,SIGZ0,PNTMIN,
     *               DISTB,COLL2,MITER,DSCONV,PRCUT,IREJTR,EEDPMN,
     *               EEDPMX,EEDTMX,EEDRMX,SEMAX,SIMAX,SIGFAC,EEXYMN,
     *               EEXYMX,PHEMAX,SIG1,SIG2,SIG3,CSECV,
     *               ITDLEN,IVDLEN,SP0,SP1,DFMASS,SFMUSC, SIGFCZ
C     MACRO FOR VERTEX-FIT ROUTINES
      COMMON /CWORK1/ NT,T(2000),NV,V(200),A(300),B(24),NTIND(20),S(20),
     *                CHITR(20),
     *                JTGOD(50),JTBAD(50),VSAVE(10),V2(20,20)
C
C  NOTE (JEO 23.3.97) THAT ORIGINAL MVERTEX1 HAS SOME DIFFERENCE
C    SEE F22KLE.VERTEX.S  LIBRARY
      DIMENSION IT(2),IV(8)     ! PMF 26/08/99 IV(2) changed to IV(8)
      EQUIVALENCE (T(1),IT(1)),(V(1),IV(1))
C     MACRO FOR VERTEX-FIT ROUTINES ( AXIS AND STATISTICS )
      COMMON /CVTX2/ MODE,TAXIS(12),SVR,HVTXST(120)
C
C   NOTE (JEO 23.3.97)  THAT HVTXST HAS DIM. 140 ON F22KLE.VERTEX.S LIB
      DIMENSION IVTXST(1)
C
C
      DIMENSION HTEXT(5,7),RLIMS(2,6),HNNN(50),ITR(4)
C
      DIMENSION HMW(5) ! PMF 26/10/99 DIMENSION statement added
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      DATA ZDEEP /5800./,DER/20./
      DATA HTEXT /'  ','  ','  ','  ','  ','BE','AM','-P','IP','E ',
     +            'BP','-C','OU','NT','ER','ID','-T','AN','K ','  ',
     +            'RO','HA','CE','LL',' 1','RO','HA','CE','LL',' 2',
     +            'RO','HA','CE','LL',' 3'/
      DATA RLIMS /115.,127.,127.,167.,167.,174.,174.,195.,370.,410.,
     +            580.,625./
C
C-----------------------------------------------------------------------
C
      NACMD = ACMD
      IF( NACMD .NE. -1 ) GO TO 100
         CONTINUE !CALL CLRCON 03/12/99
         WRITE(6,9001)
 9001    FORMAT(' VERTEX FIT MODES:',/,
     *  ' BIT31(=  1) : START AT RUN VERTEX',/,
     *  ' BIT30(=  2) : RUN VERTEX CONSTRAINT',/,
     *  ' BIT29(=  4) : AXIS CONSTRAINT',/,
     *  ' BIT28(=  8) : FITS IN R-PHI AND Z INDEPENDENT',/,
     *  ' BIT27(= 16) : LOCAL STATISTICS FOR EACH TRACK',/,
     *  ' BIT26(= 32) : OVERWRITE PATR-BANK FOR TYPE-2-TRACKS WITH HELIX
     *-PARAMETERS',/,
     *  ' BIT25(= 64) : MESSAGE FROM VTXEE IF CONVERSION SEARCH FAILED',
     */,' BIT24(=128) : SWITCH ON PENALTY FUNCTION FOR DAVIDON-ALGORITHM
     *')
 101     CALL TRMOUT(80,'ENTER MODE: ( > -1)^')
         CALL FYRINT(NACMD,ID2,ID3,ID4)
         IF( NACMD .LT. 0 ) GO TO 101
  100 CONTINUE
C
      LNHARD = (HEAD(15) .GE. 5  .AND.  HEAD(16) .EQ. 1984)
     *         .OR.   HEAD(16) .GE. 1985
      NEWDET = LVTXC .OR. (IEVTP.EQ.0 .AND. LNHARD)
      IF( .NOT. NEWDET ) GO TO 600
         RLIMS(1,1) = 99.0
         RLIMS(2,1) = 133.0
         RLIMS(1,2) = 50000.0
         RLIMS(2,2) = 60000.0
         RLIMS(1,3) = 133.0
         RLIMS(2,3) = 174.0
 600  CONTINUE
      IH = IDATA(IBLN('HEAD'))
      IF( NNPATR .LE. 0 ) GO TO 2701
      CALL CLOC(IPO,'PATR',NNPATR)
      IF( IPO .GT. 0 ) GO TO 2702
      WRITE(6,2703) NNPATR
2703  FORMAT(' PATR BANK NR',I3,' (GIVEN BY COMMAND PATR) NOT EXISTING')
2701  IPO = IDATA(IBLN('PATR'))
2702  IH  = IDATA(IBLN('HEAD'))
      IF( IPO .NE. 0 ) GO TO 2224
         CALL TRMOUT(80,'PATR BANK DOES NOT EXIST^')
         RETURN
2224  CONTINUE
      IPHWDS = IDATA(IBLN('HWDS'))
      IF(.NOT.FLVCDO(15) .OR. IPHWDS.LE.0) GOTO 2704
         IPO = IPHWDS
2704  LO  = IDATA(IPO+1)
      NTR = IDATA(IPO+2)
      LTR = IDATA(IPO+3)
      NN  = 0
      JJ  = 0
1000  CALL TRMOUT(80,' ENTER TRACK NUMBERS, UP TO 4 AT A TIME;  A BLANK
     $OR 0 WILL FINISH INPUT^')
      CALL FYRINT(ITR(1),ITR(2),ITR(3),ITR(4))
      DO 1  I = 1,4
      IF(ITR(I).EQ.0) GO TO 2
      IF(ITR(I).LE.NTR.AND.ITR(I).GT.0) GO TO 1002
      CALL TRMOUT(80,' ILLEGAL TRACKNUMBER ENCOUNTERED, IS IGNORED.')
      GO TO 1
1002  NN = NN + 1
      HNNN(NN) = ITR(I)
      IF(NN.LT.50) GO TO 1
      CALL TRMOUT(80,'MAXIMUM NR OF TRACKS (50) REACHED, GO TO FIT.^')
      GO TO 2
1     CONTINUE
      GO TO 1000
2     CONTINUE
      IF(NN.GT.1) GO TO 3
      CALL TRMOUT(80,'LESS THAN TWO TRACKS ENTERED...^')
      RETURN
C*************************
C   PERFORM VERTEX FIT   *
C*************************
C     CALL ERASE
3     CALL VTXINI
      IF( NACMD .GT. 0 .AND. NACMD .LT. 1024 ) MODE = NACMD
      CALL VTXPRE(IH,IPO)
      N = 0
      J = 0
      DO 320 M = 1, NT
         IF( IT(J+1) .EQ. 0 ) GOTO 320
            IT(J+1) = 1
            IF( NACMD .GE. 1024 ) IT(J+1) = 0
            DO 315 MM = 1, NN
               IF( M .EQ. HNNN(MM) ) GOTO 317
 315        CONTINUE
            GOTO 320
 317           N = N+1
               IT(J+1) = 2
 320  J  = J + ITDLEN
      NV = 1
      IF( N .NE. NN ) WRITE(JUSCRN,5000) N
5000  FORMAT(' ONLY',I4,' TRACKS ACCEPTED')
      IF( NACMD .GE. 1024 .AND. N .NE. 2 )
     *CALL TRMOUT(80,'CONVERSION FIT IGNORED, NOT TWO TRACKS.^')
      IF( N .NE. 2) GOTO 350
      IF( NACMD .LT. 1024 ) GO TO 350
         NV=0
         MODE = NACMD - 1024
         CALL VTXEE
         GOTO 360
 350  IF( .NOT.FLVCDO(16) ) CALL VERTEX
      IF( FLVCDO(16) ) CALL VTXDAV(IRET)
      IF( FLVCDO(16) .AND. IRET .LT. 0 ) GO TO 111
 360  CALL VTXAFT
C*****************************
C  GET RESULT OF VERTEX FIT  *
C*****************************
      IF( NV .GT. 0 ) GO TO 112
 111     CALL TRMOUT(80,' GVTXFT: NO VERTEX FOUND !^')
         RETURN
 112  R   = V(2)**2 + V(3)**2
      RL  = SQRT(R + V(4)**2)
      R   = SQRT(R)
      XVT = V(2)
      YVT = V(3)
      ZVT = V(4)
C
C DISPLAY VERTEX POSITION WITH CROSS
C
      VX = -XVT
      VY =  YVT
      IF( (LASTVW.GT.3 .AND. LASTVW.LT.8) .OR. LASTVW.EQ.18) VY = XVT
      IF( LASTVW .GT.3  .AND. LASTVW .LT. 14 ) VX = ZVT
      IF( LASTVW .EQ.18 .OR.  LASTVW .EQ. 19 ) VX = ZVT
      IF( LASTVW.LT.4 .OR.  LASTVW.EQ.17 .OR. LASTVW.EQ.20) GO TO 114
         RV  = SQRT(XVT*XVT + YVT*YVT)
         FIV = 0.
         IF( RV .GT. 0.001 ) FIV = ATAN2(YVT,XVT)
         IF( RV .GT. 0.001 .AND. FIV .LT. 0.0 ) FIV = FIV + TWOPI
         IF( .NOT.DSPDTL(9) .OR. DSPDTL(10) ) GO TO 113
         IF( LASTVW .EQ. 14 ) GO TO 113
            IF( RV .GT. 0.001 ) RV = RV*WRAP(FIV)
            VY = RV
113      IF( LASTVW .NE. 14 ) GO TO 114
CYLINDER VIEW, Z CORRECTION FOR PERSPECTIVE FACTOR
            ZETMX = ZLGPL + ZDEEP
            RV    =  RV*(ZDEEP - ZVT)/ZETMX
            VX    = -RV*COS(FIV)
            VY    =  RV*SIN(FIV)
114   CONTINUE
C  ADJUST THE DEVIATION DER
      DERV = DER
      IF( LASTVW.EQ.18 .OR. LASTVW.EQ.19 ) DERV = .01*DER
      IF( LASTVW .NE. 17 ) GO TO 115
         IF( FLVCDO(17) ) GO TO 214
            DRVX = V(5)
            DRVY = V(6)
            CALL MOVEA( -XVT-DRVX,     YVT )
            CALL DRAWA( -XVT+DRVX,     YVT )
            CALL MOVEA(      -XVT, YVT-DRVY )
            CALL DRAWA(      -XVT, YVT+DRVY )
            GO TO 116
 214     AV   = V(5)**2
         BV   = V(6)**2
         ROOT = SQRT(0.25*(AV-BV)**2 + V(11)**2)
         EIG1 = 0.5*(AV+BV) + ROOT
         EIG2 = 0.5*(AV+BV) - ROOT
         PHIW = ATAN2(EIG1-AV,V(11))
         CALL ELLIPS( 0, LASTVW, 1, XVT, YVT, EIG1, EIG2, -PHIW )
         GO TO 116
 115  CONTINUE
      CALL MOVEA(VX-DERV,VY-DERV)
      CALL DRAWA(VX+DERV,VY+DERV)
      CALL MOVEA(VX+DERV,VY-DERV)
      CALL DRAWA(VX-DERV,VY+DERV)
 116  CONTINUE
      IDIM = 3
      IF( TBIT(MODE,28) ) IDIM = 2
      NDF = 2*IV(8) - IDIM
      IF( FLVCDO(16) ) NDF = IV(8)*(IDIM-1) - IDIM
      CORXY = V(11)/(V(5)*V(6))
      PRFIT = PROB(V(9),NDF)
      WRITE(6,1292) V(9),NDF,PRFIT,IV(1),IV(8),CORXY
1292  FORMAT(' CHISQ/NDF ',F9.3,'/',I2,' PROB',F6.3,
     $' QUALITY FLAG',I3,' NR OF USED TRACKS ',I2,' CORXY ',F7.3)
      WRITE(6,1294) XVT,V(5),YVT,V(6),ZVT,V(7)
1294  FORMAT(' --->  X Y Z   OF VERTEX: ',/,1X,2(F9.3,' +-',F6.3,3X),
     *3X,F6.1,' +-',F5.1)
      IRAD = 1
      DO 1296  KL = 1,6
      IF(R.GE.RLIMS(1,KL).AND.R.LT.RLIMS(2,KL)) IRAD = KL + 1
1296  CONTINUE
      DO 1297  KJ = 1,5
1297  HMW(KJ) = HTEXT(KJ,IRAD)
      WRITE(6,1298) R,(HMW(KL),KL=1,5),RL
1298  FORMAT(' RADIUS IN RFI :',E12.4,3X,5A2,'   TOTAL LENGTH: ',E12.4)
      RETURN
      END
