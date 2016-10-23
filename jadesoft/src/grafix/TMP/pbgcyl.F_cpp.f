C   01/11/84            MEMBER NAME  PBGCYL   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE PBGCYL(DEFIX)
C-----------------------------------------------------------------------
C
C    AUTHOR:   J. OLSSON        ?     :  LG END CAPS ENERGIES (CYL-V.)
C
C  LAST MOD:   J. HAGEMANN   10/10/84 :  NOW OWN MEMBER (FROM EVDISP)
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
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
C
      COMMON / CWORK1 / R,FI,R1,FI1,X1,Y1,R2,FI2,X2,Y2,ZET,X3,Y3,X4,Y4,
     +                  IMW(132)
C
      COMMON /CJTRIG/ PI,TWOPI
C
      DATA HCALL /0/
C
C-----------------  C O D E  -------------------------------------------
C
      call setcol('ECAL') ! PMF 26/11/99: set color
      HCALL = HCALL + 1
      IF(HCALL.GT.1) GO TO 3551
      ZDEEP = 5800.
      ZETMX = ZLGPL + ZDEEP
C     LEAD GLASS AMPLITUDES IN RZ VIEWS
3551  IPJ = IDATA(IBLN('ALGN'))
      IF(IPJ.LE.0) RETURN
      NWO = IDATA(IPJ)
      IF(NWO.LE.3) RETURN
      IPJ = 2*IPJ
      IPJH = HDATA(IPJ+3)
      IF(IPJH.LE.0) RETURN
      IF(IPJH.GE.HDATA(IPJ+4)) RETURN
      NI = IPJ + IPJH + 6
C     REGISTER LEAD GLASS HITS
   97 CONTINUE
      NO = HDATA(NI)
      IF(NO.GT.2687) GO TO 17
      IF(HDATA(NI+1).LT.1) GO TO 18
C     BLOCK NUMBER, COLUMN AND ROW
      NFI = NO/32
      NZET = NO - NFI*32
      FB1 = NFI*DEFIX
      FB2 = FB1 + DEFIX
      ZB1 = NZET*BLZ
      ZB2 = ZB1 + BLZ
C     PERSPECTIVE FACTORS
      RB1 = RLG*(ZETMX-ZB1)/ZETMX
      RB2 = RLG*(ZETMX-ZB2)/ZETMX
      CSFB1 = COS(FB1)
      SNFB1 = SIN(FB1)
      CSFB2 = COS(FB2)
      SNFB2 = SIN(FB2)
C     MARK OUT BLOCK WITH HIT
      X1 = - RB1*CSFB1
      Y1 = RB1*SNFB1
      X2 = - RB2*CSFB1
      Y2 = RB2*SNFB1
      X3 = - RB2*CSFB2
      Y3 = RB2*SNFB2
      X4 = - RB1*CSFB2
      Y4 = RB1*SNFB2
      CALL CRICRO(0.,0.)
   18 NI = NI + 2
   17 CONTINUE
      IF((NI.LE.(IPJ + 2*NWO)).AND.(NO.LE.2687)) GO TO 97
      call setcol(' ') ! PMF 26/11/99: reset color
      RETURN
      END
