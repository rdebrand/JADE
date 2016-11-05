C   01/11/84            MEMBER NAME  FICOOR   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE FICOOR( IFLG, NI, NWE )
C-----------------------------------------------------------------------
C
C    AUTHOR:   J. OLSSON        ?     :  CALCULATE COORDINATES OF
C                                        INNER DETECTOR HITS
C
C  LAST MOD:   J. HAGEMANN   10/10/84 :  NOW OWN MEMBER (FROM EVDISP)
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL TBIT, FL18, FL22, FL24
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
C
      COMMON / CJCELL / NCELL(3),NWIRES(3)
      COMMON/CWORK1/R,FI,R1,FI1,X1,Y1,R2,FI2,X2,Y2,ZET,EX,EY,COSPH,SINPH
     +             ,KZAMP
C
      COMMON /CJTRIG/ PI,TWOPI
      COMMON/CPROJ/XMINR,XMAXR,YMINR,YMAXR,IPRJC,FL18,FL22,FL24
C
      DATA HCALL /0/
C
C-----------------  C O D E  -------------------------------------------
C
      HCALL = HCALL + 1
      IPRJC = 0
      IF(HCALL.GT.1) GO TO 3551
      ZDEEP = 5800.
      ZETMX = ZLGPL + ZDEEP
C COMPUTE FI OF WIRE, RADIUS ETC.
3551  NIW = HDATA(NI)
      NIW = ISHFTR(NIW,3) + 1
      IF(NIW.LE.1536.AND.NIW.GT.0) GO TO 3559
      CALL DIAGIN('ILLEGAL WIRE NO.    ',2,NIW,NI)
      CALL TRMOUT(80,'THIS CAN HAVE SEVERAL REASONS, E.G. WRONG POINTERS
     $, WRONG BANK LENGTH OR^')
      CALL TRMOUT(80,'(LESS LIKELY), CORRUPT DATA. THE DISPLAY OF INNER
     $DETECTOR HITS STOPS HERE.^')
      NWE = -1000
      RETURN
3559  NRING = (NIW-1)/384 + 1
      IF(NRING.GT.3) NRING = 3
      RADD = RINCR(NRING)
      NCL = NCELL(NRING)
      R = FSENSW(NRING) - RADD
      NEW = NIW - (NRING-1)*384
      SHIFI = PSIIN(NRING)
      NCE = ISHFTR(NEW-1,4)
      NWE = NEW - NCE*16
      IF(DSPDTL(26).AND.TBIT(NWE,31)) GO TO 4000
      R = R + NWE*RADD
      NUMCLO = 2
      IF(NWE.LT.9) NUMCLO = 1
      FACT = -SWDEPL
      IF(TBIT(NWE,31)) FACT = -FACT
      FI = SHIFI + NCE*TWOPI/FLOAT(NCL)
      IF(FI.LT.0.)FI = FI + TWOPI
      IF(FI.GT.TWOPI) FI = FI - TWOPI
      IF(IFLG.NE.1) GO TO 1003
C  DECIDE POS/NEG X OR Y
      IF(DSPDTL(9)) R=R*WRAP(FI)
C  COORDINATE CALCULATIONS
 1003 CONTINUE
      NI = NI + 1
C  GET Z-COORDINATE
      IA1 = HDATA(NI)
      NI = NI + 1
      IA2 = HDATA(NI)
      IF(IA1+IA2.GT.0) GO TO 1013
      KZAMP = KZAMP + 1
      ZET = 0.
      GO TO 1014
C1013  ZET = ZAL*.5*(IA2 - IA1)/(IA1+IA2) + ZOFFS
1013  ZET = ZAL*.5*(IA2 - IA1)/(IA1+IA2)
1014  NI = NI + 1
      IF(FL18.AND.FL22) GO TO 3338
      IF((IFLG.EQ.1).AND.DSPDTL(9).AND.(.NOT.DSPDTL(10))) GO TO 3339
3338  NDT = HDATA(NI)
C  DRIFT TIME
      FIDR = (FLOAT(NDT) + 0.5)*TIMDEL(NUMCLO,NRING)
      COSPH = COS(FI)
      SINPH = SIN(FI)
      EX = - (SINPH*DRICOS + COSPH*DRISIN)
      EY =    COSPH*DRICOS - SINPH*DRISIN
      XXX = ABS(R)*COSPH - FACT*SINPH
      YYY = ABS(R)*SINPH + FACT*COSPH
      AAA = FIDR*EX
      BBB = FIDR*EY
      X1 = XXX+AAA
      Y1 = YYY+BBB
      R1 = SQRT(X1*X1 + Y1*Y1)
      FI1 = ATAN2(Y1,X1)
      X2 = XXX-AAA
      Y2 = YYY-BBB
      R2 = SQRT(X2*X2 + Y2*Y2)
      FI2 = ATAN2(Y2,X2)
      IF(FI1.LT.0.) FI1 = FI1 + TWOPI
      IF(FI2.LT.0.) FI2 = FI2 + TWOPI
      IF(DSPDTL(9)) R1=R1*WRAP(FI1)
      IF(DSPDTL(9)) R2=R2*WRAP(FI2)
      IF(.NOT.FL22.OR..NOT.FL18) GO TO 3337
      IF(-X1.LT.XMINR.OR.-X1.GT.XMAXR) IPRJC = 1
      IF(-X2.LT.XMINR.OR.-X2.GT.XMAXR) IPRJC = 1
      IF(Y1.LT.YMINR.OR.Y1.GT.YMAXR) IPRJC = 1
      IF(Y2.LT.YMINR.OR.Y2.GT.YMAXR) IPRJC = 1
3337  CONTINUE
      IF(IFLG.NE.2) GO TO 3339
C     PERSPECTIVE FACTOR
      R1 = R1*(ZDEEP - ZET)/ZETMX
      X1 = R1*COS(FI1)
      Y1 = R1*SIN(FI1)
      R2 = R2*(ZDEEP - ZET)/ZETMX
      X2 = R2*COS(FI2)
      Y2 = R2*SIN(FI2)
3339  NI = NI + 1
      RETURN
4000  NWE = 0
C ENTER HERE FOR MISSING EVEN WIRE HITS
      NI = NI + 4
      RETURN
      END
      FUNCTION WRAP(FI)
C---
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
C---     RETURNS WITH VALUE +1 OR -1 DEPENDING ON WHETHER HITS IN
C---     THE "WRAP AROUND" VIEW SHOULD BE DISPLAYED WITH POSITIVE
C---     OR NEGATIVE Y COORDINATE ON THE SCREEN.
C---
      COMMON /CJTRIG/ PI,TWOPI,PIHALF,PI3HAF
      WRAP=1.
      IF(LASTVW.LT.4) RETURN
      IF(LASTVW.GT.11.AND.LASTVW.NE.76.AND.LASTVW.NE.77) RETURN
      IF(LASTVW.GT.7.AND.LASTVW.NE.76) GO TO 1
      IF(FI.GT.PIHALF.AND.FI.LT.PI3HAF) WRAP=-1.
      RETURN
    1 CONTINUE
      IF(FI.GT.PI) WRAP=-1.
      RETURN
      END
