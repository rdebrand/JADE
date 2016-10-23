C   19/08/76 C9051801   MEMBER NAME  PIKMUF   (S)           FORTRAN
      SUBROUTINE PIKMUF(PV,PV2,XLDK)
C
      COMMON/CGEO1/BKGAUS, RPIP,DRPIP,XRLPIP, RBPC,DRBPC,XRLBPC,
     *             RITNK,DRITNK,XRLTKI, R0ROH,DR0ROH,XR0ROH,
     *             R1ROH,DR1ROH,XR1ROH, R2ROH,DR2ROH,XR2ROH,
     *             R3ROH,DR3ROH,XR3ROH, ROTNK,DROTNK,XRLTKO,
     *             RTOF,DRTOF,XRTOF, RCOIL, DRCOIL, XRCOIL,
     *             ZJM,DZJM,XRZJM, ZJP,DZJP,XRZJP,
     *             ZTKM,DZTKM,XRZTKM, ZTKP,DZTKP,XRZTKP,
     *             ZBPPL,ZBPMI,ZTOFPL,ZTOFMI,
     *             XRJETC,
     *             RLG,ZLGPL,ZLGMI,OUTR2,CTLIMP,CTLIMM,DELFI,
     *             BLXY,BLZ,BLDEP,ZENDPL,ZENDMI,DEPEND,
     *             XHOL1,XHOL2,YHOL1,YHOL2
      REAL MPI/0.1396/,MK/0.4937/,MMU/0.1057/
      REAL CTPI/7804./,CTK/3709./
      REAL NCH
      DIMENSION PV(10),PV2(10)
C
C      PV(1) TO PV(4) FOUR VECTOR COMPONENTS
C      PV(5)  MASS IN GEV
C      PV(6)  3 MOMENTUM
C      PV(7)  CHARGE (REAL)
C      PV(8)  PARTICLE TYPE (INTEGER)
C             3 FOR MUON
C             4 FOR PION
C             5 FOR KAON
C
      DO 5 I=1,10
    5 PV2(I)=PV(I)
      XTYP=PV(8)
      XLDK = 1.E20
      IF(XTYP.NE.4. .AND. XTYP.NE.5.) RETURN
C
C      COMPUTE DECAY PATH UP TO THE LEAD GLASS SURFACES
C
      COSTH=ABS(PV(3))/PV(6)
      SINTH=SQRT( 1. - COSTH*COSTH )
C
      IF(ABS(COSTH).GT.CTLIMP) GO TO 1
      DKLTH=RLG/SINTH
      GO TO 3
    1 DKLTH=ZENDPL/COSTH
    3 CT=CTPI
      IF(XTYP.EQ.5.) CT=CTK
      AMAS=PV(5)
      GAM=PV(4)/PV(5)
      ETA=PV(6)/PV(5)
C
C      CHECK WHETHER PI OR K DECAYS AT ALL
C
      DK =DKLTH/ETA/CT
      IF(DK.GT.80.)DK=80.
      DK=1./EXP(DK)
      IF(RN(Q).GE.DK) GO TO 2
      RETURN
C
C      PI OR K DECAYS TO MU
C      CHOOSE DECAY POINT
C
    2 T=RN(QQ)*DKLTH
      XLDK=T
      DKAY=T/ETA/CT
      FACT=1./(ETA*CT)
      PROB=FACT*(1./EXP(DKAY))
      IF(FACT*RN(RR).GT.PROB)GO TO 2
      RETURN
C
C      DECAY PI OR K
C
      ENTRY PIKDEC(PV,PV2,XLDK)
C
      COSTH=PV(3)/PV(6)
      TH=ARCOS(COSTH)
      SINTH=SIN(TH)
      PHI=ATAN2(PV(2),PV(1))
      SINFI=SIN(PHI)
      COSFI=COS(PHI)
C
C      CHOSE DECAY ANGLES
C
      PCM=(AMAS**2-MMU*MMU)/(2.*AMAS)
      CTH=1.-2.*RN(DUM)
      PPCM=PCM*CTH
      PN=PCM*SIN(ARCOS(CTH))
      ECM=SQRT(PCM*PCM+MMU*MMU)
      XP=GAM*PPCM+ETA*ECM
      PHI=RN(Q)*6.283184
      YP=PN*COS(PHI)
      ZP=PN*SIN(PHI)
      P=SQRT(XP*XP+PN*PN)
C
C      ROTATE EVENT
C
      X=XP*SINTH*COSFI-YP*SINFI-ZP*COSTH*COSFI
      Y=XP*SINTH*SINFI+YP*COSFI-ZP*COSTH*SINFI
      Z=XP*COSTH+ZP*SINTH
      PXY=SQRT(X*X+Y*Y)
      SINTH=PXY/P
      COSTH=Z/P
      COSFI=X/PXY
      SINFI=Y/PXY
C
C      SET UP OUTPUT VECTOR PV2
C
      PV2(1)=P*SINTH*COSFI
      PV2(2)=P*SINTH*SINFI
      PV2(3)=P*COSTH
      PV2(4)=SQRT(P*P+MMU*MMU)
      PV2(5)=MMU
      PV2(6)=P
      PV2(8)=3
      RETURN
      END
