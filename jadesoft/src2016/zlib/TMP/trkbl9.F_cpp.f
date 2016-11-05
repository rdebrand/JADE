C   12/08/87 708131102  MEMBER NAME  TRKBL9   (S)           FORTRAN77
C   02/10/81 208051138  MEMBER NAME  TRKBLK   (SHOWS)       FORTRAN
      SUBROUTINE TRKBL9(IPN,IALGN,ITER1,ITER2,ILIPS)
C
C   COPIED FROM F11HEL.NEUFS(TRKBL9)
C
C
C   UEBERNOMMEN VON  F11MEI.SHOWS(TRKBLK)
C
C             CALCULATING PATHLENGTH IN LG-BLOCKS AFTER
C             OPTIMIZING THE BLOCK-TRACK CONNECTION
C
C             3 X 3 MATRIX
C             =====
C                                                 04/08/1982
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
C  VALUES ARE BLOCK DATA SET AT THE END OF THIS ROUTINE
      COMMON/CSHD/ PSHD(2),XSHD(2),YSHD(2),ZSHD(2)
      DIMENSION ALIST(3,50),BLIST(3,50),TSURF(3,12)
      DIMENSION POS1(25),POS2(25)
      DIMENSION X(3),V(3)
      EQUIVALENCE (XI,X(1)),(YI,X(2)),(ZI,X(3))
      EQUIVALENCE (UI,V(1)),(VI,V(2)),(WI,V(3))
      DATA PI/3.14159/, TWOPI/6.283185/
      DATA SIGX,SIGY,SIGZ,SIGP / 40., 40., 40.,.02/
      DATA POS1,POS2 /3*0.,3*1.,3*-1.,16*0.,0.,-1.,1.,0.,-1.,1.,0.,-1.,
     * 1.,16*0./
C
C                                           MOD 13/08/87 E E
      EXTERNAL JADEBD
C                                           END MOD
      DATA ICALL/0/
      ICALL=ICALL+1
      II=ILIPS
      IF(ICALL.LE.3) WRITE(6,1001) PSHD(II),XSHD(II),YSHD(II),ZSHD(II)
 1001 FORMAT(/,1X,' PSHD,XSHD,YSHD,ZSHD FROM NEUFS(TRKBL9)',4F11.4,/)
      IF(ICALL.GT.1) GO TO 9999
      ZLGEFM=ZLGMI+BLZ
      ZLGEFP=ZLGPL-BLZ
      RBARSQ=RLG**2
      OUTRSQ=OUTR2**2
      RMAG=RCOIL+0.5*DRCOIL
      RMAGSQ=RMAG**2
      DEPENH=0.5*DEPEND
      TSURF( 1, 1)=0.
      TSURF( 1, 2)=   BLXY
      TSURF( 1, 3)=2.*BLXY
      TSURF( 1, 4)=TSURF( 1, 3)+50.
      TSURF( 1, 5)=3.*BLXY
      TSURF( 1, 6)=TSURF( 1, 5)+50.
      TSURF( 1, 7)=4.*BLXY
      TSURF( 1, 8)=TSURF( 1, 7)+50.
      TSURF( 1, 9)=5.*BLXY
      TSURF( 1,10)=TSURF( 1, 9)+50.
      TSURF( 1,11)=6.*BLXY
      TSURF( 1,12)=TSURF( 1,11)+50.
      TSURF( 2, 1)=2.*BLXY+50.
      TSURF( 2, 2)=2.*BLXY
      TSURF( 2, 3)=   BLXY
      TSURF( 2, 4)=0.
      TSURF( 2, 5)=0.
      TSURF( 2, 6)=0.
      TSURF( 2, 7)=0.
      TSURF( 2, 8)=0.
      TSURF( 2, 9)=0.
      TSURF( 2,10)=0.
      TSURF( 2,11)=0.
      TSURF( 2,12)=0.
      TSURF( 3, 1)=6.*BLXY+50.
      TSURF( 3, 2)=6.*BLXY+50.
      TSURF( 3, 3)=6.*BLXY
      TSURF( 3, 4)=   BLXY
      TSURF( 3, 5)=5.*BLXY
      TSURF( 3, 6)=   BLXY
      TSURF( 3, 7)=5.*BLXY
      TSURF( 3, 8)=   BLXY
      TSURF( 3, 9)=4.*BLXY
      TSURF( 3,10)=   BLXY
      TSURF( 3,11)=2.*BLXY
      TSURF( 3,12)=   BLXY
C
 9999 DO 40 ICLR=1,50
      IRKL(1,ICLR)=-1
      TRKL(2,ICLR)=0.
   40 CONTINUE
C
      IPNH0=2*IALGN+5
      NWO=IDATA(IALGN)
      MXH=2*(IALGN+NWO)
C
C     DON'T EXTRAPOLATE PATHOLOGICAL TRACKS
C
      IF(IDATA(IPN+24).LT.6.OR.IDATA(IPN+33).LT.6) GOTO 1
C
C     GET R-Z FIT PARAMETERS.
C
      Z0=ADATA(IPN+31)
      ZSL=ADATA(IPN+30)
      OODEM=1./SQRT(1.+ZSL**2)
      WI=    ZSL*OODEM
C
C     FIND RADIUS AND CENTER OF GYRATION IN X,Y PLANE.
C
      ITYPE=IDATA(IPN+18)
      IF(ITYPE.NE.1) GO TO 2
C
C     CIRCLE FIT.
C     GET INITIAL POINT AND DIRECTION IN CASE WE USE THE STRAIGHT
C     LINE APPROXIMATION.
C

      AC=ADATA(IPN+21)
      X0=ADATA(IPN+20)*COS(AC)
      Y0=ADATA(IPN+20)*SIN(AC)
      R0SQ=X0**2+Y0**2
      R0=SQRT(R0SQ)
      A0=AC-PI/2.
      DOT=ADATA(IPN+8)*COS(A0)+ADATA(IPN+9)*SIN(A0)
      IF(DOT.LT.0.) A0=A0+PI
      CROSS=0.
C
      CURV=ADATA(IPN+19)
      IF(CURV.LT.1.E-6) GO TO 3
      R=1./CURV
      D0=R+ADATA(IPN+20)
      ALPHA=ADATA(IPN+21)
      XC=D0*COS(ALPHA)
      YC=D0*SIN(ALPHA)
      AL0=ATAN2((Y0-YC),(X0-XC))
      GO TO 4
    2 CONTINUE
      IF(ITYPE.NE.2) GO TO 1
C
C     PARABOLA FIT.
C
      A0=ADATA(IPN+19)
      X0=ADATA(IPN+20)
      Y0=ADATA(IPN+21)
      CURV=2.*ADATA(IPN+22)
      IF(ABS(CURV).GT.1.E-6) GO TO 76
      ANG=A0+PI/2.
      PERP=X0*COS(ANG)+Y0*SIN(ANG)
      X0=PERP*COS(ANG)
      Y0=PERP*SIN(ANG)
      R0SQ=X0**2+Y0**2
      R0=SQRT(R0SQ)
      GO TO 3
   76 CONTINUE
      R=1./CURV
      ANG=A0+PI/2.
      XC=X0+R*COS(ANG)
      YC=Y0+R*SIN(ANG)
      R=ABS(R)
      AL0=ATAN2(-YC,-XC)
      X0=XC+R*COS(AL0)
      Y0=YC+R*SIN(AL0)
      A0=AL0-PI/2.
      DOT=ADATA(IPN+8)*COS(A0)+ADATA(IPN+9)*SIN(A0)
      IF(DOT.LT.0.) A0=A0+PI
      GO TO 4
    3 CONTINUE
C
C     STRAIGHT LINE CASE.
C
      UI=COS(A0)*OODEM
      VI=SIN(A0)*OODEM
      AR0=0.
      IF(R0.GT.0.1) AR0=ATAN2(Y0,X0)
      CSD=COS(A0-AR0)
      SDSQ=1.-CSD**2
      RADIA=RBARSQ-SDSQ*R0SQ
      IF(RADIA.LT.0.0) GOTO 351
      XYPATH=SQRT(RADIA)-R0*CSD
      PATH=XYPATH/OODEM
      ZBIMPC=Z0+WI*PATH
      IF(ZBIMPC.LT.ZLGEFM) GO TO 5
      IF(ZBIMPC.GT.ZLGEFP) GO TO 7
C
C     HITS BARREL.
C
      IREG=0
      XI=X0+UI*PATH
      YI=Y0+VI*PATH
      ZI=ZBIMPC
      GO TO 6
    5 CONTINUE
      IREG=-1
      ZPATH=ZENDMI-Z0
      ZI=ZENDMI
      GO TO 75
    7 CONTINUE
      IREG=1
      ZPATH=ZENDPL-Z0
      ZI=ZENDPL
   75 CONTINUE
      PATH=ZPATH/WI
      XI=X0+UI*PATH
      YI=Y0+VI*PATH
      GO TO 6
    4 CONTINUE
C
C     CIRCULAR ORBITS.
C
      CROSS=(X0-XC)*ADATA(IPN+9)-(Y0-YC)*ADATA(IPN+8)
      RCSQ=XC**2+YC**2
      RC=SQRT(RCSQ)
      RMAX=RC+R
      IF(RMAX.LT.(RMAG+100.)) GO TO 8
      DEL=R-RC
      IF(ABS(DEL).LT.1.E-1) DEL=0.
      COSL=(2.*RC*DEL+DEL**2-RMAGSQ)/(2.*RC*RMAG)
      AL=ARCOS(COSL)
      IF(CROSS.LT.0.) AL=-AL
      AIN=AL0+AL
      XI=RMAG*COS(AIN)
      YI=RMAG*SIN(AIN)
      XYPATH=SQRT((XI-X0)**2+(YI-Y0)**2)
      APATH=2.*ARSIN(0.5*XYPATH/R)
      IF(CROSS.LT.0.) APATH=-APATH
      ZPATH=ZSL*R*ABS(APATH)
      ZI=Z0+ZPATH
      IF((ZI.LT.ZLGEFM).OR.(ZI.GT.ZLGEFP)) GO TO 8
C
C     INTERSECTS COIL.
C
      IREG=0
      AI=A0+APATH
      UI=COS(AI)*OODEM
      VI=SIN(AI)*OODEM
C
C     TRANSPORT FROM COIL TO BARREL.
C
      BTERM=(UI*XI+VI*YI)/OODEM
      XYPATH=SQRT(RBARSQ-RMAGSQ+BTERM**2)-BTERM
      PATH=XYPATH/OODEM
      XI=XI+UI*PATH
      YI=YI+VI*PATH
      ZI=ZI+WI*PATH
      GO TO 6
    8 CONTINUE
      IF(ABS(WI).LT.0.1) GO TO 29
      IF(WI.GT.0.) GO TO 9
      IREG=-1
      ZI=ZENDMI
      GO TO 10
    9 CONTINUE
      IREG=1
      ZI=ZENDPL
   10 CONTINUE
      ZPATH=ZI-Z0
      APATH=ZPATH/(ZSL*R)
      IF(CROSS.LT.0.) APATH=-APATH
      AIN=AL0+APATH
      XI=XC+R*COS(AIN)
      YI=YC+R*SIN(AIN)
      AI=A0+APATH
      UI=COS(AI)*OODEM
      VI=SIN(AI)*OODEM
C
    6 CONTINUE
      PTRANS=ABS(0.0299792458*BKGAUS/CURV)
      PLONGI=PTRANS*ZSL
      ECHPRT=SQRT(PTRANS**2+PLONGI**2+139.57**2)
      IF(ECHPRT.GT.15000.) ECHPRT=6000.
      PMAG=SQRT(ECHPRT**2-139.57**2)
      PTRANS=PMAG/SQRT(1.+ZSL**2)
      PLONGI=PTRANS*ZSL
C
C
C     TRANSPORT PARTICLES THROUGH LEAD GLASS.
C
C
      XSHIFT = XSHD(ILIPS)
      YSHIFT = YSHD(ILIPS)
      ZSHIFT = ZSHD(ILIPS)
      PSHIFT = PSHD(ILIPS)
      XSTART = XI
      YSTART = YI
      ZSTART = ZI
      PSTART = ATAN2(XI,YI)
      IF(PSTART.LT.0) PSTART = PSTART + TWOPI
      IFINE = 0
      ITER1 = 0
      ITER2 = 0
C
   37 QUAMAX = 0.
      ITMAX = 1
      ITER = 1
      ITSEL = 0
      X1=XI
      Y1=YI
      Z1=ZI
      PH1 = ATAN2(XI,YI)
      IF(PH1.LT.0) PH1=PH1+TWOPI
   34 CONTINUE
      NSURF=0
      IF(IREG.NE.0) GO TO 11
C
C     HITS BARREL.
C
      XI=RLG*SIN(PH1 + POS2(ITER)*PSHIFT)
      YI=RLG*COS(PH1 + POS2(ITER)*PSHIFT)
      ZI=Z1 + POS1(ITER)*ZSHIFT
      PHI=ATAN2(XI,YI)
      IF(PHI.LT.0.) PHI=PHI+TWOPI
      WEIGHT = DGAUS2(ZI,PHI,ZSTART,PSTART,SIGZ,SIGP)
      BTERM=(UI*XI+VI*YI)/OODEM
      XYPATH=SQRT(OUTRSQ-RBARSQ+BTERM**2)-BTERM
      PATH=XYPATH/OODEM
      XF=XI+UI*PATH
      YF=YI+VI*PATH
      ZF=ZI+WI*PATH
      DPHI=ARSIN((XI*YF-XF*YI)/(RLG*OUTR2))
      IF(ABS(DPHI).LT.1.E-3) GO TO 20
      PHII=TWOPI+ATAN2(YI,XI)
      PHIF=PHII+DPHI
      IBI=84.*PHII/TWOPI
      IBF=84.*PHIF/TWOPI
      NSURF=0
      NBCR=IABS(IBF-IBI)
      IF(NBCR.LT.1) GO TO 20
      PHIMI=TWOPI*(IBI+0.5)/84.
      PHIMF=TWOPI*(IBF+0.5)/84.
      STEP=(PHIMF-PHIMI)/NBCR
      PHIN=PHIMI+0.5*STEP-PI/2.
   21 CONTINUE
      UN=COS(PHIN)
      VN=SIN(PHIN)
      DRIFTN=-(UN*XI+VN*YI)
      DOT=UN*UI+VN*VI
      DRIFT=DRIFTN/DOT
      IF(NSURF.GE.48) GOTO 20
      NSURF=NSURF+1
      ALIST(1,NSURF)=XI+UI*DRIFT
      ALIST(2,NSURF)=YI+VI*DRIFT
      ALIST(3,NSURF)=ZI+WI*DRIFT
      IF(NSURF.GE.NBCR) GO TO 20
      PHIN=PHIN+STEP
      GO TO 21
   20 CONTINUE
      IF(ABS(WI).LT.1.E-3) GO TO 22
      IBI=(ZI+50.*BLZ)/BLZ
      IBF=(ZF+50.*BLZ)/BLZ
      NBCR=IABS(IBF-IBI)
      IF(NBCR.LT.1) GO TO 22
      ZMI=(IBI+0.5)*BLZ-50.*BLZ
      ZMF=(IBF+0.5)*BLZ-50.*BLZ
      STEP=(ZMF-ZMI)/NBCR
      ZS=ZMI+0.5*STEP
      ISTEP=0
   23 CONTINUE
      DRIFTN=ZS-ZI
      DRIFT=DRIFTN/WI
      ISTEP=ISTEP+1
      IF(NSURF.GE.48) GOTO 22
      NSURF=NSURF+1
      ALIST(1,NSURF)=XI+UI*DRIFT
      ALIST(2,NSURF)=YI+VI*DRIFT
      ALIST(3,NSURF)=ZS
      IF(ISTEP.GE.NBCR) GO TO 22
      ZS=ZS+STEP
      GO TO 23
   22 CONTINUE
      IF(NSURF.GE.49) GOTO 18
      NSURF=NSURF+1
      ALIST(1,NSURF)=XI
      ALIST(2,NSURF)=YI
      ALIST(3,NSURF)=ZI
      IF(NSURF.GE.50) GOTO 18
      NSURF=NSURF+1
      ALIST(1,NSURF)=XF
      ALIST(2,NSURF)=YF
      ALIST(3,NSURF)=ZF
      GO TO 18
   11 CONTINUE
C
C     HITS ENDCAP.
C
      XI=X1+POS1(ITER)*XSHIFT
      YI=Y1+POS2(ITER)*YSHIFT
      ZI=Z1
      WEIGHT = DGAUS2(XI,YI,XSTART,YSTART,SIGX,SIGY)
      ZF=ZI+IREG*DEPEND
      ZM=0.5*(ZI+ZF)
      IDIM=0
      NSURF=0
   12 CONTINUE
      IDIM=IDIM+1
      JDIM=3-IDIM
      TRANS=V(IDIM)
      IF(ABS(TRANS).LT.1.0E-3) GO TO 13
      KTR=0
   14 CONTINUE
      KTR=KTR+1
      IF(KTR.GT.23) GO TO 13
      JTR=13-KTR
      IF(KTR.GE.12) JTR=KTR-11
      SIGN=-1.
      IF(KTR.GE.12) SIGN=1.
      TDRIFT=SIGN*TSURF(1,JTR)-X(IDIM)
      DRIFT=TDRIFT/TRANS
      ZS=ZI+WI*DRIFT
      IF(ABS(ZS-ZM).GT.DEPENH) GO TO 14
      YS=X(JDIM)+V(JDIM)*DRIFT
      AYS=ABS(YS)
      IF((AYS.LT.TSURF(2,JTR)).OR.(AYS.GT.TSURF(3,JTR))) GOTO 14
      NSURF=NSURF+1
      ALIST(IDIM,NSURF)=SIGN*TSURF(1,JTR)
      ALIST(JDIM,NSURF)=YS
      ALIST(   3,NSURF)=ZS
      GO TO 14
   13 CONTINUE
      IF(IDIM.LT.2) GO TO 12
      NSURF=NSURF+1
      ALIST(1,NSURF)=XI
      ALIST(2,NSURF)=YI
      ALIST(3,NSURF)=ZI
      DRIFT=(ZF-ZI)/WI
      XF=XI+UI*DRIFT
      YF=YI+VI*DRIFT
      NSURF=NSURF+1
      ALIST(1,NSURF)=XF
      ALIST(2,NSURF)=YF
      ALIST(3,NSURF)=ZF
C
C     BARREL AND END CAP TRACKS MERGE HERE.
C
   18 CONTINUE
C
C     ORDER.
C
      DO 15 I=1,NSURF
      AMINW=1.0E8
      DO 16 J=1,NSURF
      IF(IREG.EQ.0) CW=ALIST(1,J)**2+ALIST(2,J)**2
      IF(IREG.NE.0) CW=ABS(ALIST(3,J))
      IF(CW.GT.AMINW) GO TO 16
      AMINW=CW
      K=J
   16 CONTINUE
      DO 17 J=1,3
      BLIST(J,I)=ALIST(J,K)
      ALIST(J,K)=2.0E8
   17 CONTINUE
   15 CONTINUE
C
C     COUNT REAL BLOCKS HIT AND COMPUTE PATH LENGTHS.
C
      NBLK=0
      DO 19 I=2,NSURF
      XB=0.5*(BLIST(1,(I-1))+BLIST(1,I))
      YB=0.5*(BLIST(2,(I-1))+BLIST(2,I))
      ZB=0.5*(BLIST(3,(I-1))+BLIST(3,I))
      IBLK=NUMBLC(XB,YB,ZB,IREG)
      IF(IBLK.LT.0) GO TO 19
      NBLK=NBLK+1
      DX=BLIST(1,I)-BLIST(1,(I-1))
      DY=BLIST(2,I)-BLIST(2,(I-1))
      DZ=BLIST(3,I)-BLIST(3,(I-1))
      IF(ABS(DX).LT.1.0E-3) DX=1.0E-3
      IF(ABS(DY).LT.1.0E-3) DY=1.0E-3
      IF(ABS(DZ).LT.1.0E-3) DZ=1.0E-3
      DL=SQRT(DX**2+DY**2+DZ**2)
      IRKL(1,NBLK)=IBLK
      TRKL(2,NBLK)=DL
   19 CONTINUE
   29 CONTINUE
C
      QUANT = 0.
      TRITER = 0.
      EBITER = 0.
      NBLE = 0
      IF(NBLK.LT.1) GOTO 32
C
C     TOTAL TRACKLENGTH FOR THIS ITERATION
C
      DO 88 ILOP=1,NBLK
      TRITER = TRITER + TRKL(2,ILOP)
   88 CONTINUE
      IF(TRITER.LT..00001) GOTO 32
C
C     CALCULATE QUANT
C
      KBLK=0
   25 CONTINUE
      KBLK=KBLK+1
      IF(KBLK.GT.NBLK) GO TO 26
      IBLK=IRKL(1,KBLK)
      EBL=0.
      IPNH=IPNH0
   27 CONTINUE
      IPNH=IPNH+2
      IF(IPNH.GT.MXH) GO TO 28
      JBLK=HDATA(IPNH)
      IF(JBLK.NE.IBLK) GO TO 27
      NBLE = NBLE + 1
      EBL=HDATA(IPNH+1)
      EBITER = EBITER + EBL
      IF(ITER1.GT.1) GOTO 28
      ITER1=ITER1+2
      EBLO1=EBL
      NBL1=JBLK
   28 QUANT = QUANT + (EBL/ECHPRT)*(TRKL(2,KBLK)/TRITER)
      GOTO 25
   26 QUANT = WEIGHT*QUANT*FLOAT(NBLE)/FLOAT(NBLK)
      IF(ITSEL.EQ.1) GOTO 36
      IF(ITER2.GT.1) GOTO 31
      ITER2=ITER2+2
      EBIT1=EBITER
      NBN1=NBLE
C
   31 IF(QUANT.LE.QUAMAX) GOTO 32
      QUAMAX = QUANT
      ITMAX = ITER
   32 CONTINUE
      IF(ITSEL.EQ.1) GOTO 36
C
      ITER = ITER + 1
      IF(ITER.LE.9) GOTO 34
C
C     AGAIN FOR BEST ITERATION.
C
      ITSEL = 1
      ITER = ITMAX
      GOTO 34
C
C     NEW GRID
C
   36 CONTINUE
      IF(IFINE.EQ.1) GOTO 35
      XSHIFT = XSHIFT/3.
      YSHIFT = YSHIFT/3.
      ZSHIFT = ZSHIFT/3.
      PSHIFT = PSHIFT/3.
      IFINE = 1
      GOTO 37
C
   35 IBLCHK = 0
      IF(NBLK.LT.1) IBLCHK = 1
      IF(NBLK.GE.1.AND.EBITER.LT.1.) IBLCHK = 2
      RETURN
C                                           MOD 13/08/87 E E
C 351 IBLCSE=4
  351 IBLCHK=4
C                                           END MOD
      RETURN
    1 IBLCHK = 3
      RETURN
      END
C=======================================================================
      BLOCK DATA BLZ1           !PMF 09/12/99: add name
C
      COMMON/CSHD/ PSHD(2),XSHD(2),YSHD(2),ZSHD(2)
      DATA PSHD/0.0075,0.0225/, XSHD/15.0,45.0/
      DATA YSHD/15.0,45.0/, ZSHD/30.0,75.0/
      END