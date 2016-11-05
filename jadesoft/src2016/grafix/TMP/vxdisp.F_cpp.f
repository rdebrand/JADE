C   01/11/84 901191957  MEMBER NAME  VXDISP   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE VXDISP(INDEX) 
C-----------------------------------------------------------------------
C
C    AUTHOR:   J. OLSSON    1/02/80 :  VERTEX DISPLY FROM DITTMANN
C
C       MOD:   J. OLSSON    4/05/83 :
C       MOD:   C. BOWDERY   8/06/84 :  NEW COMMAND NUMBERS
C       MOD:   J. HAGEMANN 22/10/84 :  FOR COMMAND VC
C       MOD:   J. HAGEMANN 24/02/87 :  FOR CHANGED COMMON / CWORK1 /
C       MOD:   J. HAGEMANN 13/03/87 :  VRES LIMITED TO 50 TRACKS
C                                      OTHERWISE POINTER OUT OF RANGE
C                                      IN COMMON /CWORK1/
C       MOD:   J. O., J.S. 21/04/87 :  HELIX DISPLAY IN Z-VIEWS
C       MOD:   J. HAGEMANN 05/06/87 :  DUE TO UPDATE OF STANDARD VXDISP
C       MOD:   J. HAGEMANN 21/01/88 :  GENERAL UPDATE
C  LAST MOD:   J. O., D.P. 19/01/89 :  UNDEF. VAR. AH03 NOW SET
C
C     VERTEX DISPLAY FOR JADE, USING VERTEX PROGRAM FROM P.DITTMANN
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL TBIT
      LOGICAL FL18,FL22,FL24,DSPD14
      LOGICAL FLVCDO
C
      COMMON / CPROJ  / XMINR,XMAXR,YMINR,YMAXR,IPRJC,FL18,FL22,FL24
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
C
      COMMON / CJTRIG / PI,TWOPI
      COMMON / CHEADR / HEAD(108)
      COMMON/CWORK2/HWORK(40),JNDEX,NTR,LTR,ITR,IPO,ICNT,NBK,NCLST,NWPCL
     +             ,DUMMM(16),NTRRES,IW61
      COMMON / CVX    / NNPATR
      COMMON / CVCPV  / ICD, DFX, DFY, IRC, PTOTCT
      COMMON / CGVCDO / FLVCDO(20)
C
      DATA  ZDEEP / 5800.0 /, DER/ 20.0 /
*** PMF 17/11/99: add variables needed for emulation of DESYLIB routine 'CORE'  
      CHARACTER cHWORK*80
      EQUIVALENCE (cHWORK,HWORK(1))
*** PMF(end)
C
C------------------  C O D E  ------------------------------------------
C
      JNDEX=INDEX
      IF(JNDEX.GT.7) JNDEX=JNDEX-4
C-----
      IF(JNDEX.GT.0.AND.JNDEX.LT.11) GO TO 2801
      IF(INDEX.GE.17.AND.INDEX.LE.19) GO TO 2801
      IF(INDEX.EQ.20) GO TO 2801
      RETURN
2801  IF(NNPATR.LE.0) GO TO 2701
      CALL CLOC(IPPATR,'PATR',NNPATR)
      IF(IPPATR.GT.0) GO TO 2702
      WRITE(6,2703) NNPATR
2703  FORMAT(' PATR BANK NR',I3,' (GIVEN BY COMMAND PATR) NOT EXISTING')
2701  IPPATR = IDATA(IBLN('PATR'))
2702  IPHEAD = IDATA(IBLN('HEAD'))
      IF(IPPATR.LE.0.OR.IPHEAD.LE.0) RETURN
      IPHWDS = IDATA(IBLN('HWDS'))
      IF(.NOT.FLVCDO(15) .OR. IPHWDS.LE.0) GOTO 2704
         IPPATR = IPHWDS
2704  NN = ACMD
      IF( NN .LT. 0  .AND.  LSTCMD .NE. 52 ) RETURN
      IF( NN .GT. 4  .AND.  LSTCMD .NE. 52 ) RETURN
      IF( NN .EQ. 4  .AND.  LSTCMD .NE. 52 ) GO TO 101
C---
C---   CALL VERTEX PROGRAM HERE
      CALL VTXPRE(IPHEAD,IPPATR)
      CALL VTXSRC
      CALL VTXAFT
C---
      IF(NV.GT.0) GO TO 101
      WRITE(6,102)
102   FORMAT('  NO VERTEX FOUND, ERROR RETURN ')
      RETURN
101   IF( LSTCMD .EQ. 52 ) GO TO 1000
C                                                       ************
C ENTER HERE FOR COMMAND VX, VERTEX POSITION DISPLAY    ***  VX  ***
C                                                       ************
      IF(NN.EQ.3) CALL VTXBNK(IPPATR)
      IF(NN.EQ.3) RETURN
      IF(NN.EQ.4) GO TO 4710
C  SET PRINT POSITION, IF NN.EQ.1
      call setcol('VTX ')  ! PMF 04/12/99: set color
      IF(NN.NE.1.OR.FL18) GO TO 110
      XXX = XMIN
      YYY = YMIN+.76*(YMAX-YMIN)
      CALL XXXYYY(XXX,YYY,SSS,0)
      YYY = YYY - 9.*SSS
      CALL CORE(HWORK,80)
      WRITE(cHWORK,220)! PMF 17/11/99: UNIT=10 changed to cHWORK
220   FORMAT(' VERTICES')
      CALL SYSSYM(XXX,YYY,SSS,HWORK,9,0.)
110   CONTINUE
C  ADJUST THE DEVIATION DER
      DERV = DER
      IF( LASTVW .GE. 17  .AND.  LASTVW .LE. 19 ) DERV = .01*DER
C---   LOOP OVER VERTICES
      DO 111  INV = 1,NV
      INVP = (INV-1)*IVDLEN
      IF(INV.GT.1.AND.NN.EQ.0) GO TO 112
      IVFLAG = IV(INVP+1)
      IF(NN.EQ.2.AND.IVFLAG.NE.4) GO TO 111
      XV = V(INVP+2)
      YV = V(INVP+3)
      ZV = V(INVP+4)
      VX = -XV
      VY = YV
      IF(INDEX.GT.3.AND.INDEX.LT.8) VY = XV
      IF(INDEX.EQ.18) VY = XV
      IF(INDEX.GT.3.AND.INDEX.LT.14) VX = ZV
      IF(INDEX.EQ.18.OR.INDEX.EQ.19) VX = ZV
      IF(JNDEX.LT.4.OR.INDEX.EQ.17.OR.INDEX.EQ.20) GO TO 113
      RV = SQRT(XV*XV + YV*YV)
      FIV = 0.
      IF(RV.GT..001) FIV = ATAN2(YV,XV)
      IF(RV.GT..001.AND.FIV.LT.0.) FIV = FIV + TWOPI
      IF((.NOT.DSPDTL(9)).OR.DSPDTL(10)) GO TO 113
      IF(JNDEX.EQ.10) GO TO 113
      IF(RV.GT..001) RV=RV*WRAP(FIV)
      VY = RV
113   IF(JNDEX.NE.10) GO TO 114
CYLINDER VIEW, Z CORRECTION FOR PERSPECTIVE FACTOR
      ZETMX = ZLGPL + ZDEEP
      RV = RV*(ZDEEP - ZV)/ZETMX
      VX = -RV*COS(FIV)
      VY = RV*SIN(FIV)
114   CONTINUE
      CALL MOVEA(VX-DERV,VY-DERV)
      CALL DRAWA(VX+DERV,VY+DERV)
      CALL MOVEA(VX+DERV,VY-DERV)
      CALL DRAWA(VX-DERV,VY+DERV)
      IF(INV.GT.1) CALL TRNUMB(INV,0,-VX,VY,VZ)
C  TEXT SECTION
112   IF(NN.NE.1.OR.FL18) GO TO 111
      YYY = YYY - 2.*SSS
      NDF = 2*IV(INVP+8) - 3
      CALL CORE(HWORK,80)
      WRITE(cHWORK,219) INV,IV(INVP+1),IV(INVP+10),V(INVP+9),NDF! PMF 17/11/99: UNIT=10 changed to cHWORK
219   FORMAT(' ',I2,' FLAG',I2,' NTR ',I2,' CHI/NDF ',F6.2,'/',I2)
      CALL SYSSYM(XXX,YYY,SSS,HWORK,35,0.)
      YYY = YYY - 1.5*SSS
      CALL CORE(HWORK,80)
      WRITE(cHWORK,218) V(INVP+2),V(INVP+3),V(INVP+4)! PMF 17/11/99: UNIT=10 changed to cHWORK
218   FORMAT(' XYZ ',3F7.1)
      CALL SYSSYM(XXX,YYY,SSS,HWORK,26,0.)
111   CONTINUE
      call setcol(' ') ! PMF 04/12/99: reset color
      RETURN
4710  CONTINUE
C
C RUN VERTEX DISPLAY
C
      IF(JNDEX.LT.4.OR.JNDEX.EQ.10) GO TO 1001
      IF(INDEX.EQ.17) GO TO 1001
      IF(INDEX.EQ.20) GO TO 1001
      CALL TRMOUT(80,' NOT AVAILABLE IN THIS VIEW...^')
      RETURN
1001  NRUN = HEAD(18)
      CALL VRTPOS(NRUN,VX,VY,rdummy) ! PMF 06/12/99: add dummy argument
      IF(JNDEX.NE.10) GO TO 1002
CYLINDER VIEW, Z CORRECTION FOR PERSPECTIVE FACTOR
      RV = SQRT(VX*VX + VY*VY)
      FIV = 0.
      IF(RV.GT..001) FIV = ATAN2(VY,VX)
      ZETMX = ZLGPL + ZDEEP
      ZV = 0.
      RV = RV*(ZDEEP - ZV)/ZETMX
      VX = RV*COS(FIV)
      VY = RV*SIN(FIV)
1002  CALL MOVEA(-VX-DERV,VY-DERV)
      CALL DRAWA(-VX+DERV,VY+DERV)
      CALL MOVEA(-VX+DERV,VY-DERV)
      CALL DRAWA(-VX-DERV,VY+DERV)
      RETURN
1000  CONTINUE
C                                                       ************
C ENTER HERE FOR COMMAND VRES, VERTEX RESULTS DISPLAY   *** VRES ***
C                                                       ************
      IPO = IPPATR
      LO = IDATA(IPO+1)
      NBK = IDATA(IPO-2)
      NTR = IDATA(IPO+2)
      IF(NTR.LE.0) GO TO 1161
      IF(NTR.LE.50) GO TO 1010
         CALL TRMOUT(80,' MORE THAN 50 TRACKS! "VRES" NOT POSSIBLE.^')
         GOTO 1161
 1010 LTR = IDATA(IPO+3)
      call setcol('TRCK') ! PMF 04/12/99: set color
      IPO = IPO + LO - LTR
      IQO = IPO
      IFIELD  = HEAD(38)
      AH03 = 3.000E-8*FLOAT(IABS(IFIELD))
      DSPD14 = DSPDTL(14)
      DSPDTL(14) = .TRUE.
      IW61 = 0
      IF(ACMD.EQ.0) IW61 = 1
      IF(DSPDTL(29)) GO TO 2100
C---------------------------------- LOOP OVER TRACKS -----
      DO 2102  J = 1,NTR
      IPNOT = (J-1)*ITDLEN
      IQO = IQO+LTR
      ITR = IDATA(IQO + 1)
      IF(NN.GT.0.AND.NN.NE.ITR) GO TO 2102
      IF(NN.LT.0.AND.IABS(NN).NE.IT(IPNOT+14)) GO TO 2102
      IF(IT(IPNOT+1).LE.0) GO TO 2102
      NRV = IT(IPNOT+14)
      IPNRV = (NRV-1)*IVDLEN
      VXE = V(IPNRV+2)
      VYE = V(IPNRV+3)
      VZE = V(IPNRV+4)
      IF(JNDEX.GT.3.AND.JNDEX.LT.10) GO TO 2002
      IF(INDEX.EQ.18.OR.INDEX.EQ.19) GO TO 2002
C--                         RFI-VIEW OF INNER DETECTOR
C---                        **************************
      ICD  = IDATA(IQO + 2)
      DFX  = ADATA(IQO + 8)
      DFY  = ADATA(IQO + 9)
      IRC  = -100
      IF( ICD .EQ. 301 ) ICD = 65536
      IF( TBIT(ICD,19) .AND. LTR .EQ. 64 ) ICD = IBITON(ICD,15)
      IF( TBIT(ICD,15) .AND. LTR .GE. 64 ) IRC = IDATA(IQO + 62)
      CRV  = ADATA(IQO + 25)
      CST  = 1./SQRT(1.+ADATA(IQO+30)**2)
      PTOT = ABS(AH03/(CRV*CST))
      IF( FLVCDO(9) .AND. PTOT.LT.PTOTCT ) GOTO 2102
      IF( FLVCDO(9) .AND. PTOTCT.LT.0.0 .AND.
     *    ((TBIT(ICD,15) .AND. IRC.NE.0 ).OR.
     *     .NOT.TBIT(ICD,15)) ) GOTO 2102
C** DISPLAY TRACKS
      ITYPLI = IDATA(IQO+29)
C                     PARABOLA FITS
C     IF(IDATA(IQO+18).NE.1.AND.ITYPLI.EQ.1)
      IF(IDATA(IQO+18).NE.1)
     $ CALL PARDIS(25,ADATA(IQO+19),ADATA(IQO+20),ADATA(IQO+21),
     $ ADATA(IQO+22),ADATA(IQO+5),ADATA(IQO+6),ADATA(IQO+12),
     $ ADATA(IQO+13),ADATA(IQO+31),ADATA(IQO+30),VXE,VYE)
C                     CIRCLE FITS
      IF(IDATA(IQO+18).EQ.1.AND.(ITYPLI.EQ.1.OR.ITYPLI.EQ.2))
     $ CALL CIRDIS(25,SIGN(ADATA(IQO+19),ADATA(IQO+25)),
     $ ADATA(IQO+20),ADATA(IQO+21),
     $ ADATA(IQO+5),ADATA(IQO+6),ADATA(IQO+12),ADATA(IQO+13),
     $ ADATA(IQO+31),ADATA(IQO+30),ITYPLI,VXE,VYE)
C** WRITE TRACK NUMBER
C     CALL TRNUMB(ITR,0,ADATA(IQO+12),ADATA(IQO+13),ADATA(IQO+14))
      IF(JNDEX.NE.3) GO TO 2172
C--                         RFI-VIEW OF MU-CHAMBERS
C--                         ***********************
      REMEMB = DSPDTL(8)
      REMEMC = DSPDTL(9)
      DSPDTL(8) = .FALSE.
      DSPDTL(9) = .FALSE.
C MUON RESULTS TO BE CALLED HERE
      DSPDTL(8) = REMEMB
      DSPDTL(9) = REMEMC
      GO TO 2172
2002  IF(JNDEX.GT.7.AND.INDEX.NE.18.AND.INDEX.NE.19) GO TO 2102
C--                         XZ OR YZ-VIEW OF INNER DETECTOR
C--                         *******************************
C** DISPLAY TRACKS
C                     LINE FITS
      ITYPLI = IDATA(IQO+29)
C **MODIFY TO DRAW HELIX FIT RESULT    J.S. 16/4/87
      ACURXY=ABS(ADATA(IQO+25))
      LLLL=0
      IF(ACURXY.GT.1.E-4) LLLL=1
      IF(ITYPLI.EQ.2.AND.LLLL.EQ.1)
     +CALL HELDIS(ITR,INDEX,ADATA(IQO+5),ADATA(IQO+6),ADATA(IQO+7),
     +ADATA(IQO+12),ADATA(IQO+13),ADATA(IQO+14),ADATA(IQO+25))
      IF(ITYPLI.EQ.1.OR.ITYPLI.EQ.2.AND.LLLL.EQ.0)
     +CALL LINDIS(IQO,INDEX,VXE,VYE,VZE)
C ** END MODIFICATION
      IF(JNDEX.GT.5.AND.INDEX.NE.18.AND.INDEX.NE.19) GO TO 2004
      GO TO 2172
2004  CONTINUE
C                           YZ-VIEW OF MU-CHAMBERS
C                           **********************
C MUON RESULTS TO BE CALLED HERE
2172  IF(ACMD.EQ.0.) GO TO 2102
      ACMDR = ACMD
      ACMD = FLOAT(ITR)
      NTRRES = ITR
      IF(.NOT.FL18) CALL BANKLS(INDEX,IPPATR)
      ACMD = ACMDR
2102  CONTINUE
2100  CONTINUE
      NTRRES = 0
      IF(.NOT.FL18.AND.ACMD.EQ.0.) CALL BANKLS(INDEX,IPPATR)
1161  VXG = 0.
      VYG = 0.
      VZG = 0.
      IF(NTR.LE.0 .OR. NTR.GT.50 .OR. IV(1).EQ.4) GO TO 1920
C IF TRACKS EXIST, USE MAIN VERTEX FOR PHOTON ORIGEN
      VXG = V(2)
      VYG = V(3)
      VZG = V(4)
1920  IF((DSPDTL(28).OR.DSPDTL(29)).AND.(NN.EQ.0.OR.NN.EQ.-1))
     $ CALL GAMDIS(INDEX,VXG,VYG,VZG)
      DSPDTL(14) = DSPD14
      RETURN
      call setcol(' ') ! PMF 04/12/99: reset color
      END
