C   16/07/79 708091557  MEMBER NAME  RUTRCK   (S)           FORTRAN
      SUBROUTINE RUTRCK(NN,ITP,A,B,C,D,XB,YB,XE,YE,AZ,BZ,XP,YP,ZP,
     * X2,Y2,Z2,IFLGX)
C---
C---    SUBROUTINE TO COMPUTE POINT OF IMPACT OF CHARGED TRACK FROM ID
C---    IN LEAD GLASS SYSTEM. ITP = 1 MEANS CIRCLE, ITP = 2 PARABOLA
C---    THE PARABOLA PARAMETERS ARE:
C---                        A = ANGLE BETWEEN LOCAL X-AXIS AND DETECTOR
C---                        B = X COORDINATE OF LOCAL MINIMUM POINT.
C---                        C = Y COORDINATE OF LOCAL MINIMUM POINT.
C---                        D = PARABOLA PARAMETER IN  Y = D * X*X
C---    THE CIRCLE PARAMETERS ARE:
C---                        A = CURVATURE
C---                        B = RMIN
C---                        C = PHIMIT
C---                        D = NOT USED
C---     THE Z-COORDINATE IS GOTTEN FROM THE R-Z FIT:  Z = AZ + BZ*R
C---
C---   OUTDATED:         OR FROM THE Z-FI(HELIX) FIT:  Z = AZ + BZ*FI
C---                     THE LATTER ONLY IN CASE OF CIRCLE FIT
C---
C---    RETURNED ARE IMPACT POINT XP,YP,XP
C---                 POINT OF EXIT X2,Y2,Z2 (ON BACK SIDE OF LEAD GLASS)
C---                 LABEL IFLGX:
C---    IFLGX = 0 FOR NO IMPACT POINT (CURLING ELECTRON)
C---    IFLGX = 1 FOR IMPACT POINT IN ENDCAPS (INCLUDING GAP ENDCAP-CYL)
C---    IFLGX = 2 FOR IMPACT POINT IN CYLINDER
C---   UPON ENTRY IFLGX GIVES TYPE OF Z-FIT
C---
C---     J.OLSSON         15.07.79        LAST CHANGE 13.05.81
C---     SPITZERS HELIX FIT MODIFICATION  LAST CHANGE 09.08.87
C---
      IMPLICIT INTEGER*2 (H)
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
      COMMON /CJTRIG/ PI,TWOPI
C---
      ITYP = IFLGX
      IF(ITP.NE.2) GO TO 100
C     IF(ITYP.NE.1) RETURN
C------------------------------- PARABOLAS
      COSA = COS(A)
      SINA = SIN(A)
      XPB = (XB-B)*COSA + (YB-C)*SINA
      XPE = (XE-B)*COSA + (YE-C)*SINA
      YPB = D*XPB*XPB
      DELX = (XPE - XPB)/NN
      XP = (XPB)*COSA - (YPB)*SINA + B
      YP = (XPB)*SINA + (YPB)*COSA + C
      RP = SQRT(XP*XP + YP*YP)
      ZP = AZ + BZ*RP
C DETERMINE IF TRACK HITS CYLINDER OR ENDCAPS
      ZP1 = AZ + BZ*RLG
      ZLIM = ZLGPL
      LIMTYP = 2
      IF(ABS(ZP1).GT.ZLGPL) ZLIM = ZENDPL
      IF(ABS(ZP1).GT.ZLGPL) LIMTYP = 1
C
      IFLGX = 0
      NNN = 0
      R2 = RP
      Z2 = ZP
551   XPB = XPB + DELX
555   YPB = D*XPB*XPB
      NNN = NNN + 1
      XP = (XPB)*COSA - (YPB)*SINA + B
      YP = (XPB)*SINA + (YPB)*COSA + C
      RP = SQRT(XP*XP + YP*YP)
      ZP = AZ + BZ*RP
      IF(IFLGX.NE.0) GO TO 561
CHECK LIMITS
      IF(ABS(ZP).LT.ZLIM) GO TO 554
      IFLGX = 1
      FAT = ABS((ABS(ZP) - ZLIM)/(ZP - Z2))
552   XPB = XPB - FAT*DELX
      GO TO 555
554   IF(RP.LT.RLG) GO TO 553
      IFLGX = 2
      FAT = (RP-RLG)/(RP-R2)
      GO TO 552
553   R2 = RP
      Z2 = ZP
      GO TO 551
561   X3 = XP
      Y3 = YP
      Z3 = ZP
      R3 = RP
      XPB = XPB + DELX
      YPB = D*XPB*XPB
      X2 = (XPB)*COSA - (YPB)*SINA + B
      Y2 = (XPB)*SINA + (YPB)*COSA + C
C  GET STRAIGHT LINE BETWEEN LAST TWO POINTS
      BLG = (Y2-Y3)/(X2-X3)
      ALG = Y3 - X3*BLG
      DELX = X2 - X3
      IFLGX = 0
      IF(LIMTYP.EQ.1) ZLIM = ZLIM + DEPEND
571   X2 = X2 + DELX
575   Y2 = ALG + BLG*X2
      NNN = NNN + 1
      R2 = SQRT(X2*X2 + Y2*Y2)
      Z2 = AZ + BZ*R2
      IF(IFLGX.NE.0) IFLGX = LIMTYP
      IF(IFLGX.NE.0) GO TO 557
CHECK LIMITS
      IF(ABS(Z2).LT.ZLIM) GO TO 574
      IFLGX = 1
      FAT = ABS((ABS(Z2) - ZLIM)/(Z2 - Z3))
572   X2 = X2 - FAT*DELX
      GO TO 575
574   IF(R2.LT.OUTR2) GO TO 573
      IFLGX = 2
      FAT = (R2-OUTR2)/(R2-R3)
      GO TO 572
573   R3 = R2
      Z3 = Z2
      GO TO 571
100   IF(ITP.NE.1) GO TO 557
C------------------------------- CIRCLES
C---
      IF(ABS(A).GT.1.E-08) GO TO 700
      CALL TRMOUT(44,'CURVATURE ZERO ENCOUNTERED IN SUBR. RUTRCK^')
      RETURN
700   RAD = ABS(1./A)
      YC = RAD + B
      XC = YC*COS(C)
      YC = YC*SIN(C)
C--
      FI1 = ATAN2(YB-YC,XB-XC)
      FI2 = ATAN2(YE-YC,XE-XC)
      IF(ITYP.EQ.1) GO TO 755
C     FISTRT = FI1
C     IF(FISTRT.LT.0.) FISTRT = FISTRT + TWOPI
C     FIHEL1 = C + PI
C     IF(FIHEL1.GT.TWOPI) FIHEL1 = FIHEL1 - TWOPI
C     FISTRT = ABS(FISTRT - FIHEL1)
755   FIB = FI1
      ARC = ARCMIN(FI2-FI1)
      DEFI = ARC/NN
      XP = XC + RAD*COS(FI2)
      YP = YC + RAD*SIN(FI2)
      RP = SQRT(XP*XP + YP*YP)
      IF(ITYP.EQ.1) GO TO 233
C     FIHEL = FI2
C     IF(FIHEL.LT.0.) FIHEL = FIHEL + TWOPI
C     FIHEL = ABS(FIHEL - FIHEL1) - FISTRT
C     ZP = BZ*FIHEL + AZ
C     ZDEL = BZ*ABS(DEFI)
C     ZDELR = ZDEL
C     GO TO 235
233   ZP = AZ + BZ*RP
235   IFLGX = 0
      NNN = 0
      R2 = RP
      Z2 = ZP
C DETERMINE IF TRACK HITS CYLINDER OR ENDCAPS
      ZP1 = AZ + BZ*RLG
      ZLIM = ZLGPL
      LIMTYP = 2
      IF(ABS(ZP1).GT.ZLGPL) ZLIM = ZENDPL
      IF(ABS(ZP1).GT.ZLGPL) LIMTYP = 1
751   FI2 = FI2 + DEFI
      NNN = NNN + 1
      IF(NNN.GT.200.OR.(ABS(FI2-FIB).LT.TWOPI+2.*DEFI.AND.ABS(FI2-FIB)
     $.GT.TWOPI-2.*DEFI)) RETURN
759   XP =   XC + RAD*COS(FI2)
      YP =   YC + RAD*SIN(FI2)
      RP = SQRT(XP*XP + YP*YP)
      IF(ITYP.EQ.1) GO TO 238
C     ZP = ZP + ZDEL
C     GO TO 239
238   ZP = AZ + BZ*RP
239   IF(RP.LT.RITNK) RETURN
      IF(IFLGX.NE.0) GO TO 753
CHECK LIMITS
      IF(ABS(ZP).LT.ZLIM) GO TO 754
      IFLGX = 1
      FAT = ABS((ABS(ZP) - ZLIM)/(ZP - Z2))
752   FI2 = FI2 - FAT*DEFI
C     IF(ITYP.EQ.2) ZDEL = -FAT*ZDEL
      GO TO 759
754   IF(RP.LT.RLG) GO TO 753
      IFLGX = 2
      FAT = (RP-RLG)/(RP-R2)
      GO TO 752
753   R2 = RP
      Z2 = ZP
      IF(IFLGX.EQ.0) GO TO 751
      IFLGX = 0
      X3 = XP
      Y3 = YP
      Z3 = ZP
      R3 = RP
C     IF(ITYP.EQ.2) ZDEL = ZDELR
      FI2 = FI2 + DEFI
      X2 =   XC + RAD*COS(FI2)
      Y2 =   YC + RAD*SIN(FI2)
      R2 = SQRT(X2*X2 + Y2*Y2)
      IF(ITYP.EQ.1) GO TO 738
C     Z2 = Z2 + ZDEL
C     GO TO 739
738   Z2 = AZ + BZ*R2
C  GET STRAIGHT LINE BETWEEN LAST TWO POINTS
739   BLG = (Y2-Y3)/(X2-X3)
      ALG = Y3 - X3*BLG
      DELX = X2 - X3
      IF(LIMTYP.EQ.1) ZLIM = ZLIM + DEPEND
771   X2 = X2 + DELX
775   Y2 = ALG + BLG*X2
      NNN = NNN + 1
      R2 = SQRT(X2*X2 + Y2*Y2)
      IF(ITYP.EQ.1) GO TO 783
C     Z2 = Z2 + ZDEL
C     GO TO 784
783   Z2 = AZ + BZ*R2
C  GET STRAIGHT LINE BETWEEN LAST TWO POINTS
784   CONTINUE
      IF(IFLGX.NE.0) IFLGX = LIMTYP
      IF(IFLGX.NE.0) GO TO 557
CHECK LIMITS
      IF(ABS(Z2).LT.ZLIM) GO TO 774
      IFLGX = 1
      FAT = ABS((ABS(Z2) - ZLIM)/(Z2 - Z3))
772   X2 = X2 - FAT*DELX
      GO TO 775
774   IF(R2.LT.OUTR2) GO TO 773
      IFLGX = 2
      FAT = (R2-OUTR2)/(R2-R3)
      GO TO 772
773   R3 = R2
      Z3 = Z2
      GO TO 771
557   CONTINUE
      RETURN
      END