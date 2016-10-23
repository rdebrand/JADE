C   02/07/79 406081620  MEMBER NAME  FAMPFT   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE FAMPFT(NN,RAD,RMIN,PHM,XB,YB,XE,YE,XCE,YCE)
C-----------------------------------------------------------------------
C
C    AUTHOR:   J. OLSSON    2/07/83 :  DRAW A CIRCLE SEGMENT FOR FAMP
C
C       MOD:   J. OLSSON    3/07/83 :
C  LAST MOD:   C. BOWDERY   8/06/84 :  NEW COMMAND NUMBERS
C
C     MODIFIED VERSION OF CIRDIS, TO DISPLAY CIRCLE APPROXIMATION OF
C     THE PARABOLA FIT IN PATREC OF "FAMP"
C
C        DRAWS A CIRCLE SEGMENT FROM XB,YB TO XE,YE OF THE CIRCLE WITH
C        PARAMETERS RAD,RMIN,PHM.    NN IS THE SEGMENTATION OF THE
C        POLYGON APPROXIMATION.
C        XCE,YCE IS THE POINT TO WHICH CLOSEST APPROACH IS FOUND
C          (I.E., THE POINT WHICH IS THE ORIGIN OF THE TRACK)
C        IF DSPDTL(19) = TRUE, TRACKS ARE PROLONGED TO CLOSEST APPROACH
C                              TO ORIGIN.
C        IF DSPDTL(23) = TRUE, TRACKS ARE PROLONGED TO TOF OR LEAD GLASS
C                              RADIUS LIMIT.
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
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
      COMMON / CJTRIG / PI,TWOPI
C
C------------------  C O D E  ------------------------------------------
C
      RRA = ABS(RAD)
      YC = RRA + RMIN
      XC = YC*COS(PHM)
      YC = YC*SIN(PHM)
C     WRITE(6,2311) RAD,XC,YC,RMIN,PHM
2311  FORMAT(' FT: RAD XYC RMN PHM ',5E14.6)
      RTS = RLG
      IF(LASTVW.EQ.1) RTS = RTOF
C--
      PHMIT = ATAN2(YC-YCE,XC-XCE)
      FI1 = PHMIT - PI
      IF(.NOT.DSPDTL(19).AND.LSTCMD.NE.52) FI1 = ATAN2(YB-YC,XB-XC)
      FI2 = ATAN2(YE-YC,XE-XC)
      IF(FI1.LT.-PI) FI1= FI1 + TWOPI
      FIB = FI1
      ARC = ARCMIN(FI2-FI1)
C     WRITE(6,2313) ARC,FI1,FI2
2313  FORMAT(' FT: ARC FI1 FI2 ',3E14.6)
      IF(ARC*RAD.GT.0.) ARC = SIGN(TWOPI-ABS(ARC),-ARC)
      DEFI = ARC/NN
      XP = - XC - RRA*COS(FI1)
      YP = YC + RRA*SIN(FI1)
C     WRITE(6,2312) PHMIT,XP,YP
2312  FORMAT(' FT: PHMIT XP YP ',3E14.6)
      CALL MOVEA(XP,YP)
      DO 501  I = 1,NN
      FI1 = FI1 + DEFI
      XP = - XC - RRA*COS(FI1)
      YP =   YC + RRA*SIN(FI1)
      IF(I.EQ.NN) RP = SQRT(XP**2+YP**2)
501   CALL DRAWA(XP,YP)
      IF(.NOT.DSPDTL(23))  RETURN
C---------- SECTION FOR EXTENSION TO TOF OR PBG LIMIT
      NNN = 0
551   FI1 = FI1 + DEFI
      NNN = NNN + 1
      IF(NNN.GT.200.OR.ABS(ARCMIN(FI1-PHM)).LT.ABS(DEFI)) RETURN
      XP = - XC - RRA*COS(FI1)
      YP =   YC + RRA*SIN(FI1)
      RP = SQRT(XP*XP + YP*YP)
      IF(RP.LT.RITNK) GO TO 559
      IF(RP.GT.RTS) GO TO 559
      CALL DRAWA(XP,YP)
      GO TO 551
559   RETURN
      END
C*****************************
      FUNCTION ARCMIN(A)
C
C THIS IS A ROUTINE USED IN PLUTO PATREC. IT FINDS THE SHORTEST ARC
C     BETWEEN TWO ANGLES.
C
      COMMON/CJTRIG/ PI,TWOPI
C
      ARCMIN=A
      IF (ABS(A).LE.PI) GOTO 2
      ARCMIN=AMOD (A+5.*PI,TWOPI)-PI
    2 RETURN
      END
      DOUBLE PRECISION FUNCTION DRCMIN(AA)
      COMMON/CJTRIG/ PI,ZWEIPI
      REAL*8 AA
      DRCMIN=AA
      IF (DABS(AA).LE.PI) GOTO 3
      ARGUM = AA + 2.*ZWEIPI + PI
      DRCMIN=AMOD (ARGUM,ZWEIPI)-PI
    3 RETURN
      END
