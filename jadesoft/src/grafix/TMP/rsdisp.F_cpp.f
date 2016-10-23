C   01/11/84 807251624  MEMBER NAME  RSDISP   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE RSDISP(INDEX)
C-----------------------------------------------------------------------
C
C   AUTHOR: J. OLSSON        ?    : RESULTS DISPLAY
C
C      MOD: J. OLSSON    19/12/83 :
C      MOD: C. BOWDERY   13/03/84 : CDTL 13 REVERSED MEANING
C      MOD: C. BOWDERY   28/04/84 : VERTEX CHAMBER CODE FROM HAGEMANN
C      MOD: J. HAGEMANN  10/10/84 : FOR VERTEX CHAMBER VIEW (INDEX=20)
C      MOD: C. BOWDERY   20/12/85 : BANKLS ET AL, NOW IN OWN MEMBERS
C      MOD: J. HAGEMANN  07/01/86 : FOR OPTIONS 54,56
C      MOD: J. HAGEMANN  12/02/86 : EXTENDED COMMON CVX
C      MOD: J. HAGEMANN  04/07/86 : DISPLAY PHOTONS BEGINNING AT RUN
C                                   VERTEX IF REQUESTED
C      MOD: J. OLSSON    12/03/87 : FWDISP: RESULT DISPLAY IN FW VIEW
C      MOD: J. SPITZER   21/04/87 : HELDIS: HELIX DISPLAY IN Z-VIEWS
C      MOD: J. HAGEMANN  05/06/87 : DUE TO UPDATE OF STANDARD RSDISP
C LAST MOD: J. HAGEMANN  20/01/88 : FOR HWDS-BANK AND VCDO 9
C
C       RESULTS DISPLAY FOR JADE GRAPHICS PROGRAM
C       THIRD INDEPENDENT LINK IN THE CHAIN JADISP - EVDISP - RSDISP
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL REMEMB,REMEMC
      LOGICAL FL18,FL22,FL24
      LOGICAL FLVCDO
      LOGICAL TBIT
C
      COMMON / CPROJ  / XMINR,XMAXR,YMINR,YMAXR,IPRJC,FL18,FL22,FL24
      COMMON / CWORK2 / HWORK(40),JNDEX,NTR,LTR,ITR,IPO,ICNT,NBK,
     +                  NCLST,NWPCL,DUMMM(16),NTRRES,IW52
      COMMON / CJTRIG / PI,TWOPI
      COMMON / CVX    / NNPATR,ICRSTR,NNJETC,NNVTXC
      COMMON / CHEADR / HEAD(108)
      COMMON / CVCPV  / ICD, DFX, DFY, IRC, PTOTCT
      COMMON / CGVCDO / FLVCDO(20)
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
C-----------------------------------------------------------------------        
C                                                                               
C   COMMON-DEFINITION FOR                 14.04.86  R.RAMCKE                    
C   COMFIT PARAMETER COMMON               09.02.87  C.KLEINWORT                 
C                                                                               
      COMMON / CCOMF / SCF1, SCF2, SCF3, SCF4,                                  
     &                 DCF1, DCF2, ITMX, IVHMN, IPRBN, CFPMIN, MODECF,          
     &                 CFSFAC             , VCWGHT  !!!   VCWGHT added 02.02.98  
C                                                                               
C----------------------------------------------------------------------- 

C
      DATA INAME  / 'PATR' /
C
C-----------------------------------------------------------------------
C
      IALGN = IBLN('ALGN')
      ILGCL = IBLN('LGCL')
      IZVTX = IBLN('ZVTX')
      JNDEX = INDEX
      IF( INDEX .GT. 7 ) JNDEX = INDEX - 4
C
      IF( INDEX .GT. 0  .AND.  INDEX .LT. 21 ) GO TO 4900
      RETURN
C
4900  LASTVW = INDEX
      IF(INDEX.EQ.12) GO TO 5
C                            SEARCH BANK PATR
      NBK    = 0
      NTRRES = 0
C
C                  LSTCMD = 45,118  MEANS  COMMANDS  RES,EDIT
C
      IF(LSTCMD.NE.118.AND.LSTCMD.NE.45) GO TO 2222
      NBK = ACMD
      IF(NBK.NE.0.AND.NBK.NE.99) GO TO 2225
      GO TO 2222
2225  IF(DSPDTL(14)) GO TO 2222
      CALL CLOC(IPO,INAME,NBK)
      IF(IPO.NE.0) GO TO 2223
2224  CALL DIAGIN('NOT EXISTING,BANK NR',1,NBK,IPO,IPO,IPO,IPO,IPO)
      RETURN
2222  IF(NNPATR.LE.0) GO TO 2701
      CALL CLOC(IPPATR,'PATR',NNPATR)
      IPO = IPPATR
      IF(IPPATR.GT.0) GO TO 2702
      WRITE(6,2703) NNPATR
2703  FORMAT(' PATR BANK NR',I3,' (GIVEN BY COMMAND PATR) NOT EXISTING')
2701  IPO = IDATA(IBLN('PATR'))
      IPPATR = IPO
2702  IF(DSPDTL(14)) NTRRES = NBK
      IF(IPO.EQ.0) GO TO 2224
2223  CALL CLOC(IPHWDS,'HWDS',IPRBN)
      IF(IPHWDS .GT. 0) GO TO 2221
         IPHWDS = IDATA(IBLN('HWDS'))
2221  IF(.NOT.FLVCDO(15) .OR. IPHWDS.LE.0) GOTO 2704
         IPO = IPHWDS
         IPPATR = IPO
2704  LO = IDATA(IPO+1)
      NBK = IDATA(IPO-2)
      IPPTR1 = IPO
      NTR = IDATA(IPO+2)
      LTR = IDATA(IPO+3)
      IPO = IPO + LO - LTR
      IFIELD  = HEAD(38)
      AH03 = 3.000E-8*FLOAT(IABS(IFIELD))
C                INDEX=16    Z CHAMBER ROLLED OUT VIEW
      IF( INDEX .EQ. 16 ) GO TO 61
      IF(JNDEX.GT.3.AND.JNDEX.LT.10) GO TO 2
      IF( INDEX .EQ. 18  .OR.  INDEX .EQ. 19 ) GO TO 2
C
C                           RFI-VIEW OF INNER DETECTOR
C                           **************************
      IF(IPO.EQ.0) RETURN
      IF(.NOT.FL18) CALL BANKLS(INDEX,IPPTR1)
      ICNT = 0
      XRV  = 0.0
      YRV  = 0.0
      IF(DSPDTL(29)) GO TO 21
      IF( .NOT. FLVCDO(11) ) GO TO 200
         CALL VTXCRV( INT(HEAD(18)), XRV, YRV, DXR, DYR ) !PMF 09/11/99: add run argument HEAD(18)
200   ICNT = ICNT + 1
      IF(ICNT.GT.NTR) GO TO 21
      IPO = IPO+LTR
      IF(ICNT.NE.NTRRES.AND.DSPDTL(14).AND.NTRRES.NE.0) GO TO 200
      ITR  = IDATA(IPO + 1)
      ICD  = IDATA(IPO + 2)
      DFX  = ADATA(IPO + 8)
      DFY  = ADATA(IPO + 9)
      IRC  = -100
      IF( ICD .EQ. 301 ) ICD = 65536
      VERVAL = -100.0
      IF( LTR .GT. 62 ) VERVAL = ABS(ADATA(IPO+51))
      IF(TBIT(ICD,19) .AND. LTR.EQ.64 .AND. VERVAL.GT.0.01)
     *                  ICD = IBITON(ICD,15)
      IF( TBIT(ICD,15) .AND. LTR .GE. 64 ) IRC = IDATA(IPO + 62)
      PARAM1 = ADATA(IPO+20)
      PARAM2 = ADATA(IPO+21)
      IF( .NOT.FLVCDO(14) .OR. IRC.NE.0) GOTO 202
         PARAM1 = ADATA(IPO+49)
         PARAM2 = ADATA(IPO+50)
 202  CRV  = ADATA(IPO + 25)
      CST  = 1./SQRT(1.+ADATA(IPO+30)**2)
      PTOT = ABS(AH03/(CRV*CST))
      IF( FLVCDO(9) .AND. PTOT.LT.PTOTCT ) GOTO 200
      IF( FLVCDO(9) .AND. PTOTCT.LT.0.0 .AND.
     *    ((TBIT(ICD,15) .AND. IRC.NE.0 ).OR.
     *     .NOT.TBIT(ICD,15)) ) GOTO 200
C** DISPLAY TRACKS
      call setcol('TRCK') ! PMF 23/11/99: set colour
      ITYPLI = IDATA(IPO+29)
C                     PARABOLA FITS
      IF(ICNT.NE.NTRRES.AND.DSPDTL(14).AND.NTRRES.NE.0) GO TO 200
      IF(IDATA(IPO+18).EQ.2.AND.(ITYPLI.EQ.1.OR.ITYPLI.EQ.2))
     $ CALL PARDIS(25,ADATA(IPO+19),PARAM1,PARAM2,
     $ ADATA(IPO+22),ADATA(IPO+5),ADATA(IPO+6),ADATA(IPO+12),
     $ ADATA(IPO+13),ADATA(IPO+31),ADATA(IPO+30),XRV,YRV)
C                     CIRCLE FITS
      IF(IDATA(IPO+18).EQ.1.AND.(ITYPLI.EQ.1.OR.ITYPLI.EQ.2))
     $ CALL CIRDIS(25,SIGN(ADATA(IPO+19),ADATA(IPO+25)),
     $ PARAM1,PARAM2,
     $ ADATA(IPO+5),ADATA(IPO+6),ADATA(IPO+12),ADATA(IPO+13),
     $ ADATA(IPO+31),ADATA(IPO+30),ITYPLI,XRV,YRV)
      GO TO 200
C
C
C
  21  IF((DSPDTL(28).OR.DSPDTL(29)).AND.NTRRES.EQ.0)
     $ CALL GAMDIS(INDEX,XRV,YRV,0.)
      IF(.NOT.DSPDTL(27)) GO TO 211
      ACMDR = ACMD
      ACMD = 0.
      CALL VXDISP(INDEX)
      ACMD = ACMDR
211   continue
      call setcol(' ')
      IF(JNDEX.EQ.3) GO TO 3
      RETURN
2     IF( JNDEX .GT. 7  .AND.  INDEX .NE. 18  .AND. INDEX.NE.19) GO TO 5
C--                         XZ OR YZ-VIEW OF INNER DETECTOR
C--                         *******************************
      IF(IPO.EQ.0) GO TO 321
      IF(.NOT.FL18) CALL BANKLS(INDEX,IPPTR1)
      IF(DSPDTL(29)) GO TO 321
      ICNT = 0
300   ICNT = ICNT + 1
      IF(ICNT.GT.NTR) GO TO 321
      IPO = IPO + LTR
      IF(ICNT.NE.NTRRES.AND.DSPDTL(14).AND.NTRRES.NE.0) GO TO 300
      ITR = IDATA(IPO + 1)
C** DISPLAY TRACKS
C                     LINE FITS
      ITYPLI = IDATA(IPO+29)
C **MODIFY TO DRAW HELIX FIT RESULT    J.S. 16/4/87
      ACURXY=ABS(ADATA(IPO+25))
      LLLL=0
      IF(ACURXY.GT.1.E-4) LLLL=1
      call setcol('TRCK') ! PMF 23/11/99: set colour
      IF(ITYPLI.EQ.2.AND.LLLL.EQ.1)
     +CALL HELDIS(ITR,INDEX,ADATA(IPO+5),ADATA(IPO+6),ADATA(IPO+7),
     +ADATA(IPO+12),ADATA(IPO+13),ADATA(IPO+14),ADATA(IPO+25))
      IF(ITYPLI.EQ.1.OR.ITYPLI.EQ.2.AND.LLLL.EQ.0)
     +CALL LINDIS(IPO,INDEX,0.,0.,0.)
C ** END MODIFICATION
      GO TO 300
321   IF((DSPDTL(28).OR.DSPDTL(29)).AND.NTRRES.EQ.0)
     $ CALL GAMDIS(INDEX,0.,0.,0.)
      call setcol(' ') ! PMF 23/11/99: reset colour
      IF(.NOT.DSPDTL(27)) GO TO 322
      ACMDR = ACMD
      ACMD = 0.
      CALL VXDISP(INDEX)
      ACMD = ACMDR
322   IPO = IDATA(IZVTX)
      IF(IPO.EQ.0) GO TO 399
      IFLG = IDATA(IPO+6)
C     WRITE(JUSCRN,946) IFLG
C946   FORMAT(' FLAG IN ZV BANK ',I6)
      IF(IFLG.LT.0) GO TO 399
      ZVTX = ADATA(IPO+1)
      DZV1 = ADATA(IPO+2)
      DZV2 = ADATA(IPO+3)
C                                       DRAW ZVERTEX WITH ERRORS
      X1  = ZVTX - DZV1
      X11 = ZVTX - DZV2
      X2  = ZVTX + DZV1
      X22 = ZVTX + DZV2
      Y0  = - 70.
      Y1  = - 90.
      Y2  = - 50.
      CALL MOVEA(X1  , Y1)
      CALL DRAWA(X1  , Y2)
      CALL MOVEA(X1  , Y0)
      CALL DRAWA(X2  , Y0)
      CALL MOVEA(X2  , Y1)
      CALL DRAWA(X2  , Y2)
      CALL MOVEA(X22 , Y2)
      CALL DRAWA(X22 , Y1)
      CALL MOVEA(ZVTX, Y1)
      CALL DRAWA(ZVTX, Y2)
      CALL MOVEA(X11 , Y2)
      CALL DRAWA(X11 , Y1)
399   IF(JNDEX.GT.5) GO TO 3
      RETURN
    3 CONTINUE
      IF( JNDEX .LT. 7  .OR.  INDEX .EQ. 18
     +                  .OR.  INDEX .EQ. 19 ) RETURN
C--
C                            FORWARD DETECTOR
C--
      RETURN
5     IF(JNDEX.EQ.9) GO TO 6
      IF(JNDEX.EQ.12) GO TO 61
C                           FORWARD DETECTOR DISPLAY
C                           ************************
C                           (RESULTS OF TAGAN, CONTENTS OF VECT:0)
      CALL FWDISP
      RETURN
6     IPLGCL=IDATA(ILGCL)
      IF(IPLGCL.EQ.0) RETURN
C                           ROLLED OUT VIEW OF LEADGLASS SYSTEMS
C                           ************************************
      NBK = IDATA(IPLGCL-2)
      NWPCL = IDATA(IPLGCL+25)
      IPO = IDATA(IPLGCL+3) + IPLGCL - 1 - NWPCL
      NCLST = IDATA(IPLGCL+7)
      ISTEP = IDATA(IPLGCL+21)
      IPALGN=IDATA(IALGN)
      call setcol('ECAL') ! PMF 29/11/99: set color
      IF(ISTEP.NE.2) CALL LGCDIR(IPPATR,IPALGN,IPLGCL)
      CALL LGCLST
      IPO = IPPATR + LO - LTR
      call setcol('TRCK') ! PMF 29/11/99: set color
      CALL TRKROL
      call setcol('ECAL') ! PMF 29/11/99: set color
      CALL YAMADA(0)
      call setcol(' ') ! PMF 29/11/99: reset color
      RETURN
61    CONTINUE
C
C  RESULT DISPLAY FOR RZ CHAMBER ROLLED OUT VIEW
C
      IF(IPO.EQ.0) RETURN
      CALL RZROLL
      CALL BANKLS(INDEX,IPPTR1)
      RETURN
      END
