C   03/04/79 406081642  MEMBER NAME  LINDIS   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE LINDIS(IPO,INDEX,XC,YC,ZC)
C-----------------------------------------------------------------------
C
C    AUTHOR:   J. OLSSON   25/02/79 :  DRAW A STRAIGHT LINE FOR TRACK
C
C       MOD:   J. OLSSON   17/02/84 :
C  LAST MOD:   C. BOWDERY   8/06/84 :  NEW COMMAND NUMBERS
C
C     STRAIGHT LINE FIT DISPLAY FOR THE JADE DETECTOR
C     IPO IS CURRENT TRACK POINTER
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL DSPDTM
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
C
      COMMON / CGRAP2 / BCMD,DSPDTM(30)
      COMMON / CJTRIG / PI,TWOPI
C
      DATA DUM1 /0./
C
C-----------------------------------------------------------------------
C
C  R-Z FIT          Z = A + B*R
C
C  SET VARIABLES
C
      ITR = IDATA(IPO+1)
C  LINE PARAMETERS
      A = ADATA(IPO+31)
      B = ADATA(IPO+30)
C  START POINT
      XB = ADATA(IPO+ 5)
      YB = ADATA(IPO+ 6)
      ZB = ADATA(IPO+ 7)
C  END POINT
      XE = ADATA(IPO+12)
      YE = ADATA(IPO+13)
      ZE = ADATA(IPO+14)
C  SIZE OF VIEW/TRACKLENGTH
      ZZPL = ZLGPL
      ZZPL1 = ZENDPL
      RTS = RLG
      IF(LASTVW.EQ.4.OR.LASTVW.EQ.8) RTS = RTOF
      IF(LASTVW.EQ.18.OR.LASTVW.EQ.19) RTS = .33*(XMAX-XMIN)
      IF(LASTVW.EQ.18.OR.LASTVW.EQ.19) ZZPL = RTS
      IF(LASTVW.EQ.18.OR.LASTVW.EQ.19) ZZPL1 = RTS
      IF(.NOT.DSPDTL(19).OR.LSTCMD.EQ.52) GO TO 1557
C ENTER HERE ONLY IF TRACKS ARE PROLONGED TO BEAM AXIS OR CLOSEST POINT
      APA = ADATA(IPO+19)
      BPA = ADATA(IPO+20)
      CPA = ADATA(IPO+21)
      DPA = ADATA(IPO+22)
      ITYPPA = IDATA(IPO+18)
C---
C---    FIND MINIMUM DISTANCE RP OF PARABOLA (A B C D) FROM ORIGIN
C---    THE PARAMETERS ARE: A = ANGLE BETWEEN LOCAL X-AXIS AND DETECTOR
C---                        B = X COORDINATE OF LOCAL MINIMUM POINT.
C---                        C = Y COORDINATE OF LOCAL MINIMUM POINT.
C---                        D = PARABOLA PARAMETER IN  Y = D * X*X
C---
C---
      IF(ITYPPA.NE.2) GO TO 1009
C--PARABOLA FIT
      COSA = COS(APA)
      SINA = SIN(APA)
C--
C-- FIND POINT OF CLOSEST APPROACH TO ORIGIN, BY SOLVING 3D DEGREE EQUA-
C-- TION ARISING FROM THE CONDITION D/DX (DIST)  =  0
C-- USE CARDAN'S FORMULA
C--
      RMIN = 10000.
      Q = -BPA*COSA - CPA*SINA
      P =  BPA*SINA - CPA*COSA
      P = (1. - 2.*DPA*P)/(6.*DPA*DPA)
      Q = - Q/(4.*DPA*DPA)
      DET = Q*Q + P*P*P
      IF(DET.GT.0) GO TO 5700
C DET < 0,  3 REAL SOLUTIONS
      BIGR = SQRT(ABS(P))
      IF(Q.LT.0.) BIGR = - BIGR
      COSFI = Q/(BIGR**3)
      FIHELP = ARCOS(COSFI)
      IF(FIHELP.LT.0.) FIHELP = FIHELP + TWOPI
      FIHELP = FIHELP/3.
      BIGR = -2.*BIGR
      Y1 = BIGR*COS(FIHELP)
      Y2 = BIGR*COS(FIHELP+TWOPI/3.)
      Y3 = BIGR*COS(FIHELP+2.*TWOPI/3.)
      XPB = AMIN1(Y1,Y2,Y3)
      GO TO 5701
5700  DET = SQRT(DET)
      SUGN = 1.
      IF(-Q+DET.LT.0.) SUGN = -1.
      U = (((-Q+DET)*SUGN)**.3333333)*SUGN
      SUGN = 1.
      IF(-Q-DET.LT.0.) SUGN = -1.
      V = (((-Q-DET)*SUGN)**.3333333)*SUGN
      XPB = U+V
5701  YPB = DPA*XPB*XPB
      X0 = (XPB)*COSA - (YPB)*SINA + BPA
      Y0 = (XPB)*SINA + (YPB)*COSA + CPA
      RMIN = SQRT(X0*X0 + Y0*Y0)
      GO TO 1011
1009  CONTINUE
C  CIRCLE FIT
      RMIN = ABS(BPA)
      X0 = RMIN*COS(CPA)
      Y0 = RMIN*SIN(CPA)
1011  RMINN = RMIN
      IF((INDEX.LT.8.OR.INDEX.EQ.80).AND.X0*XB.LT.0.) RMINN = -RMINN
      IF(INDEX.GT.7.AND.INDEX.NE.80.AND.Y0*YB.LT.0.) RMINN = - RMINN
      Z0 = A + B*RMINN
      GO TO 1558
1557  CONTINUE
      X0 = XC
      Y0 = YC
      Z0 = ZC
1558  CONTINUE
C                    START POINT
      ZETS = ZB
      IF(DSPDTL(19)) ZETS = Z0
      IF(LSTCMD.EQ.52) ZETS = ZC
      IF(DSPDTL(19).AND.LSTCMD.NE.52) GO TO 22
      XXX = XB
      YYY = YB
      IF(LSTCMD.NE.52) GO TO 1774
      XXX = XC
      YYY = YC
1774  IF(DSPDTL(9)) GO TO 1
C  PROJECT MODE
      XYS = XXX
      IF(INDEX.GT.7.AND.INDEX.NE.80) XYS = YYY
      GO TO 2
C  ROTATE MODE
1     XYS = SQRT(XXX*XXX+YYY*YYY)
      IF(INDEX.GT.7.AND.INDEX.NE.80) XYS = SIGN(XYS,YYY)
      IF(INDEX.LT.8.OR.INDEX.EQ.80) XYS = SIGN(XYS,XXX)
C     IF(YYY.LT.0..AND.INDEX.GT.7) XYS = - XYS
C     IF(XXX.LT.0..AND.INDEX.LT.8) XYS = - XYS
      GO TO 2
C ENTER HERE FOR DSPDTL(19) ON, TRACK PROLONGATION
22    IF(DSPDTL(9)) GO TO 9701
C  PROJECT MODE
      XYS = X0
      IF(INDEX.GT.7.AND.INDEX.NE.80) XYS = Y0
      GO TO 2
C  ROTATE MODE
9701  XYS = RMIN
      IF((INDEX.LT.8..OR.INDEX.EQ.80).AND.X0.LT.0.) XYS = - XYS
      IF(INDEX.GT.7.AND.INDEX.NE.80.AND.Y0.LT.0.) XYS = - XYS
C     IF(INDEX.LT.8.AND.X0*XB.LT.0.) XYS = - XYS
C     IF(INDEX.GT.7.AND.Y0*YB.LT.0.) XYS = - XYS
C
 2    CONTINUE
C      IF(DSPDTM(30)) WRITE(6,1202) INDEX,DSPDTL(9),X0,Y0,Z0
C1202  FORMAT(' INDX DSP9 XYZ0 ',2I3,3E12.4)
C      IF(DSPDTM(30)) WRITE(6,1203) RMIN,XYS,XB,YB
C1203  FORMAT(' RMN XYS X-YB ',4E12.4)
C
C                    END POINT
C
      ZETE = ZE
      IF(DSPDTL(9)) GO TO 3
C PROJECT MODE
      XYE = XE
      IF(INDEX.GT.7.AND.INDEX.NE.80) XYE = YE
      IF(.NOT.DSPDTL(23).AND.LASTVW.NE.18.AND.LASTVW.NE.19) GO TO 4
      XYRR = SQRT(XYE**2+ZETE**2)
      IF(XYRR.LE.RTS) GO TO 4
      GO TO 44
C  ROTATE MODE
3     XYE = SQRT(XE*XE+YE*YE)
      IF(YE.LT.0..AND.INDEX.GT.7.AND.INDEX.NE.80) XYE = - XYE
      IF(XE.LT.0..AND.(INDEX.LT.8.OR.INDEX.EQ.80)) XYE = - XYE
      IF(.NOT.DSPDTL(23).AND.LASTVW.NE.18.AND.LASTVW.NE.19) GO TO 4
      XYRR = SQRT(XYE**2+ZETE**2)
      IF(XYRR.LE.RTS) GO TO 4
44    ZETE = A + B*RTS
      IF(LSTCMD.NE.52) GO TO 670
      RCC = SQRT(XC*XC+YC*YC+0.00001)
      REE = SQRT(XE*XE+YE*YE+0.00001)
      ACC = (ZE*RCC - ZC*REE)/(RCC - REE)
      BCC = (ZC - ZE)/(RCC-REE)
      ZETE=ACC + BCC*RTS
670   XYE = RTS
      IF(ABS(ZETE).LT.ZZPL) GO TO 33
      ZETE = SIGN(ZZPL1,ZETE)
      IF(ABS(B).LT..00000001) GO TO 33
      XYE = ABS((ZETE-A)/B)
      IF(LSTCMD.EQ.52) XYE = ABS((ZETE-ACC)/BCC)
33    IF(YE.LT.0..AND.INDEX.GT.7.AND.INDEX.NE.80) XYE = - XYE
      IF(XE.LT.0..AND.(INDEX.LT.8.OR.INDEX.EQ.80)) XYE = - XYE
4     CALL MOVEA(ZETS,XYS)
      CALL DRAWA(ZETE,XYE)
C  -ZETE IN TRNUMB CALL, COMPENSATES INTRINSIC -SIGN, HISTORICAL REASONS
      CALL TRNUMB(ITR,0,-ZETE,XYE,DUM1)
      RETURN
      END
