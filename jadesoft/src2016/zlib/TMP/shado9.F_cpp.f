C   26/08/86 608261112  MEMBER NAME  SHADO9   (S)           FORTRAN77
      SUBROUTINE SHADO9(WIDTH,ILIPS)
C
C     LOOK FOR LG ENERGY AROUND CALCULATED PARTICLE PATH
C     PROFILE IS DEFINED IN ARRAY WIDTH
C
C                                         06/07/82
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
C
      COMMON /LINK/   IBLCHK,IREG,NBLK,NBLE,XI,YI,ZI,XF,YF,ZF,XSTART,
     *                YSTART,ZSTART,PSTART,TRKL(2,50),TRITER,EBITER,
     *                PMAG,NNEW,NENEW,NLIST(40),ENEW,ICHARG(40,20),
     +                NBLO,MEICL(50),NEICL(50),EBIT1,NBN1,EBLO1,NBL1
      DIMENSION IRKL(2,50)
      EQUIVALENCE(IRKL(1,1),TRKL(1,1))
      DIMENSION WIDTH(5)
CC    DATA WIDTH / 0.5 , 0.5 , 0.5 ,0.5 , 0.5 /
      DATA PI4 /.7854/, TWOPI/6.283185/
C
C     WRITE(6,123)
C 123 FORMAT(1X,'  ***  SHADOW  05  ***')
      ENEW = 0.
      NNEW = 0
      NENEW = 0
      DO 60 I=1,40
      NLIST(I) = -1
   60 CONTINUE
C
      IALGN = IDATA(IBLN('ALGN'))
      IF(IALGN.EQ.0) RETURN
      IPNH0=2*IALGN+5
      NWO=IDATA(IALGN)
      MXH=2*(IALGN+NWO)
C
C     SCAN ALONG PARTICLE PATH
C
      THLG = (ZF-ZI)/SQRT((XF-XI)**2+(YF-YI)**2+(ZF-ZI)**2)
      STHLG = SIN(THLG)
      CTHLG = COS(THLG)
C
C     WRITE(6,111) IREG,THLG
C 111 FORMAT(/,X,'PRINTOUT FROM SHADOW,LG-PART ',I2,' LG-THETA ',F6.3,
C    *       /,X,'  DIST   ','  XSCAN  ','  YSCAN  ','  ZSCAN  ',
C    *         X,'  PSCAN  ','  ELIPSP ','  ELIPS1 ','  ELIPS2 ',
C    *         X,'  ELIPS3 ','  ELIPS4 ','  XSCAN1 ','  YSCAN1 ',
C    *         X,'  XSCAN1 ','  PSCAN1 ')
C
      DO 10 ISCAN=1,5
      DIST = FLOAT(ISCAN-1)/4.
      XSCAN=(DIST*(XF-XI))+XI
      YSCAN=(DIST*(YF-YI))+YI
      ZSCAN=(DIST*(ZF-ZI))+ZI
      RSCAN=SQRT(XSCAN**2+YSCAN**2)
      PSCAN = ATAN2(XSCAN,YSCAN)
      IF(PSCAN.LT.0) PSCAN=PSCAN+TWOPI
C
      ELIPSP = 0.
      IF(IREG.NE.0) ELIPSP = ATAN2(XSCAN,YSCAN)
      DO 20 K=1,8
      ELIPSP = ELIPSP + PI4
C
      IF(IREG.NE.0) GOTO 1
CC    ELIPS1 = STHLG*COS(ELIPSP)
      ELIPS1 = COS(ELIPSP)
       ATHLG=1.4*ABS(THLG)
       IF(ATHLG.GT.1.) ATHLG=1.
       IF(ILIPS.EQ.2) GOTO 25
       IF((ELIPS1*ZSCAN).LT.0.) ELIPS1=ELIPS1*(1.-ATHLG)
   25 ELIPS2 = SIN(ELIPSP)
      ZSCAN1 = ZSCAN+ELIPS1*WIDTH(ISCAN)*BLZ
      PSCAN1 = PSCAN+ELIPS2*WIDTH(ISCAN)*DELFI
      XSCAN1 = RSCAN*SIN(PSCAN1)
      YSCAN1 = RSCAN*COS(PSCAN1)
      GOTO 2
C
    1 ELIPS3 = CTHLG*COS(ELIPSP)
      ELIPS4 = CTHLG*SIN(ELIPSP)
      XSCAN1 = XSCAN+ELIPS3*WIDTH(ISCAN)*BLXY
      YSCAN1 = YSCAN+ELIPS4*WIDTH(ISCAN)*BLXY
      ZSCAN1 = ZSCAN
C
    2 IBL = NUMBLC(XSCAN1,YSCAN1,ZSCAN1,IREG)
C
C     WRITE(6,222) DIST,XSCAN,YSCAN,ZSCAN,PSCAN,ELIPSP,ELIPS1,ELIPS2,
C    *             ELIPS3,ELIPS4,XSCAN1,YSCAN1,ZSCAN1,PSCAN1
C 222 FORMAT(X,14F9.3)
C
      IDEC = 1
      IF(IBL.EQ.-1) IDEC = 0
      DO 30 L=1,NBLK
      IF(IRKL(1,L).EQ.IBL) IDEC = 0
   30 CONTINUE
      IF(IDEC.EQ.0) GOTO 20
      IF(NNEW.EQ.0) GOTO 3
      IDEC = 1
      DO 40 M=1,NNEW
      IF(IBL.EQ.NLIST(M)) IDEC = 0
   40 CONTINUE
      IF(IDEC.EQ.0) GOTO 20
    3 NNEW = NNEW + 1
      NLIST(NNEW) = IBL
   20 CONTINUE
C
   10 CONTINUE
C
C     LOOK FOR ENERGY IN NEW BLOCKS
C
      IF(NNEW.EQ.0) RETURN
      DO 50 N=1,NNEW
      IPNH = IPNH0
    4 IPNH=IPNH+2
      IF(IPNH.GT.MXH) GOTO 50
      IF(HDATA(IPNH).NE.NLIST(N)) GOTO 4
      EBL = HDATA(IPNH+1)
      ENEW = ENEW + EBL
      NENEW = NENEW + 1
   50 CONTINUE
C
      RETURN
      END
