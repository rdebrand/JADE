C   28/10/77 708302136  MEMBER NAME  TRKGAM   (S)           FORTRAN
      SUBROUTINE TRKGAM(PV,R0,R,P1,P2,*,*)
C
C  ******************************************************************
C           ERRORS IN RADIATOR THICKNESSES CORRECTED   15.02.1986
C                                                       J. OLSSON
C           CORRECT VALUE FOR BP-COUNTERS PUT IN       11.06.1986
C                                                       J. HAGEMANN
C  ******************************************************************
C     ADAPTED FOR USE WITH TOKYO SHOWER PROGRAM FOR LEAD GLASS
C                                       5.12.1986       J. OLSSON
C  ******************************************************************
C     CORRECT FOR LOW ENERGY BACKWARD PHOTONS CAUSING NEG. SQRT
C                                      30.08.1987       J. OLSSON
C
C      THIS ROUTINE TRACKS PHOTONS THROUGH THE DETECTOR
C      UP TO THE LEAD GLASS SURFACES OF BARREL COUNTERS AND END CAPS
C      HODOSCOPES ARE SET BY CONVERTING GAMMAS
C
C      PV = USUAL PARTICLE VECTOR OF DIMENSION 10
C           FIRST FOUR ARE FOURVECTOR COMPONENTS SEE TRCDET
C      R  = THREE DIMENSIONAL RADIUS VECTOR
C      PV AND R ARE OVER WRITTEN UPON RETURN
C      P1 AND P2 CONTAIN THE E+/E- VECTORS IF A CONVERSION HAS
C      TAKEN PLACE BEFORE THE END OF THE CENTRAL DETECTOR
C
C     RETURN 1 IS USED IF THERE IS NO CONVERSION OR A CONVERSION
C              IN THE COIL. IN THIS CASE PV IS CONVERTED INTO AN
C              ELECTRON VECTOR.
C     RETURN 2 IS USED IF THE PHOTON LEAVES THE DETECTOR WITHOUT
C              ANY INTERACTION I.E. THROUGH THE BEAM PIPE OR THROUGH
C              GAPS,
C              OR IF PHOTON HAS LESS THAN PMIN ENERGY.
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
C
C  SHOWER MC COMMON
C
      COMMON /CLGD56/ RADIUS(6),ZEND(2),ZWID,ZGAP,PHWID,
     2                ECXLST(24), ECYLST(24),ZECAP(4),ZPV(4),TPV,
     3                TH(4),THECP
C
C     RADIUS(1,2) = DISTANCE TO THE COIL SURFACES(INNER AND OUTER)
C       THESE VALUES ARE AVERAGES, SINCE THE TOTAL RADIATION LENGTH IS
C       IS ASSUMED TO COME FROM PURE AL. IN REALITY PLASTIC AND H20 IS
C       ALSO CONSIDERED:
C
C  1979-1983: 97.85 % X0 = 0.9785*88.947 MM = 87.03 MM
C        DATA RADIUS/ 900.0, 987.0, 1100.0, 1400.0, 1150.0, 1400.0/
C
C  1984-1986: 104.10 % X0 = 1.0410*88.947 MM = 92.59 MM
C        DATA RADIUS/ 900.0, 992.6, 1100.0, 1400.0, 1150.0, 1400.0/
C
C     RADIUS(3,4) = DISTANCE TO THE LEAD GLASS SURFACES(TYPE A)
C     RADIUS(5,6) = DISTANCE TO THE LEAD GLASS SURFACES(TYPE A-PR)
C
      DIMENSION PV(10),R0(3),R(3),P1(10),P2(10),RYAM(3)
C
      LOGICAL * 1 LFLAG
      COMMON/CFLAG/LFLAG(10)
C
      REAL ME/0.5E-03/
      DATA PMIN / .005 /
C
C  XRL10 GIVES THICKNESS OF CONVERTER UP TO SETTING OF BEAM PIPE COUNTER
C       BEAMPIPE   0.0503  X0   (INCLUDES WATER COOLING PIPES..)
C       1/2 BEAMPIPECOUNTERS     0.0119 X0
C  XRL20 GIVES THICKNESS OF REMAINING CONVERTER UP TO INNER DETECTOR
C       1/2 BEAMPIPECOUNTERS     0.0119 X0
C       INNER TANKWALL           0.0787 X0
C       ZEROTH ROHACELL LAYER    0.0076 X0
C       1/3 OF I.D. GAS          0.0069 X0
C  XRL30 GIVES THICKNESS OF FIRST MIDDLE ROHACELL + I.D. GAS
C       FIRST MIDDLE ROHACELL    0.0109 X0
C       1/3 OF I.D. GAS          0.0069 X0
C  XRL40 GIVES THICKNESS OF FIRST MIDDLE ROHACELL + I.D. GAS
C       SECOND MIDDLE ROHACELL   0.0109 X0
C       1/6 OF I.D. GAS          0.0035 X0
C  XRL50 GIVES THICKNESS OF CONVERTER UP TO SETTING OF TOF COUNTERS
C       1/6 OF I.D. GAS          0.0035 X0
C       LAST ROHACELL LAYER      0.0147 X0
C       OUTER TANKWALL           0.1348 X0
C       INNER DET. CABLING       0.0252 X0
C       1/2 TOF-COUNTERS         0.0238 X0
C  XRL60 GIVES THICKNESS OF CONVERTER AFTER MIDDLE OF TOF COUNTERS
C       1/2 TOF-COUNTERS         0.0238 X0
C       COIL AND HEATSHIELDS     0.7562 X0
C
      DATA XRL10 /0.0622/, XRL20 /0.1051/, XRL30 /0.0178/
      DATA XRL40 /0.0144/, XRL50 /0.2020/, XRL60 /0.7800/
      DATA ICLTRG /0/
C
      ICLTRG = ICLTRG + 1
      IF(ICLTRG.EQ.1) WRITE(6,3855)
3855  FORMAT('   * * *   NEW, CORRECTED TRKGAM VERSION, FROM 15.2.1986'/
     $       '   * * *   VERSION FOR TOKYO SHOWER PROGRAM    5.12.1986')
C
C      FOLLOW PHOTON FROM THE IA POINT TO THE BEAM PIPE (+VESSEL)
C
      DO 2 I10=1,10
      P1(I10)=0.
    2 P2(I10)=0.
      R(1)=R0(1)
      R(2)=R0(2)
      R(3)=R0(3)
C *** TEST PHOTON ENERGY
      IF( PV(6) .LT. PMIN ) RETURN2
      PVX=PV(1)/PV(6)
      PVY=PV(2)/PV(6)
      PVZ=PV(3)/PV(6)
C *** TEST ON GAMMA ANGLE  AND TRANSVERSE MOMENTUM
      IF(ABS(PVZ).GT.0.968) RETURN 2
      PVXY=PVX**2+PVY**2
      IF(PVXY.LT.1.E-5) RETURN 2
C
C      CALCULATE GEOMETRICAL CONST., TRACK TO THE BEAM PIPE
C
      STH=SQRT(1.-PVZ**2)
C
C     XRL1=XRLPIP/STH
C     XRL2=XRLTKI/STH
C     XRL3=XR1ROH/STH
C     XRL4=XR2ROH/STH
C     XRL5=XRLTKO/STH
C     XRL6=XRCOIL/STH
      XRL1=XRL10/STH
      XRL2=XRL20/STH
      XRL3=XRL30/STH
      XRL4=XRL40/STH
      XRL5=XRL50/STH
      XRL6=XRL60/STH
C
      R1=R(1)**2+R(2)**2
      DR2=(RPIP**2-R1)/PVXY
C        ALREADY BEYOND THE BEAMPIPE?
      IF( DR2 .LE. 0. ) GO TO 10
      PVR=R(1)*PVX+R(2)*PVY
      PVR=PVR/PVXY
      XL=-PVR+SQRT(PVR**2+DR2)
C
      R(1)=R(1)+XL*PVX
      R(2)=R(2)+XL*PVY
      R(3)=R(3)+XL*PVZ
C
C        OUTSIDE IN Z ?       THEN CONTINUE WITH THE ENDCAPS
      IF(R(3).GT.ZTKP) GO TO 1000
      IF(R(3).LT.ZTKM) GO TO 1000
C
C     IF THERE IS A CONVERSION RETURN TO THE CALLING PROGRAM
C     WITH THE ELECTRON MOMENTA IN P1 AND P2
C     WHEN SETTING THE BEAM PIPE COUNTERS ,THE SMALL DIFFERENCE
C     IN RADIUS BETWEEN PIPE AND COUNTER IS IGNORED
C
      CALL EEPAIR(PV,P1,P2,XRL1,&10)
      IF( R(3) .GE. ZBPMI .AND. R(3) .LE. ZBPPL )
     *           CALL SETBPC(R)
C ******                 CALCULATE ACTUAL CONVERSION POINT
      DCONV = DRPIP * RN(DUM) / STH
      R(1)  = R(1) + DCONV*PVX
      R(2)  = R(2) + DCONV*PVY
      R(3)  = R(3) + DCONV*PVZ
      RETURN
C
C      FOLLOW GAMMA FROM PIPE TO INNER RADIUS OF THE TANK
C
   10 CONTINUE
      R1=R(1)**2+R(2)**2
      DR2=(RITNK**2-R1)/PVXY
C        ALREADY BEYOND THE INNER TANK WALL ?
      IF( DR2 .LE. 0. ) GO TO 11
      PVR=R(1)*PVX+R(2)*PVY
      PVR=PVR/PVXY
      XL=-PVR+SQRT(PVR**2+DR2)
C
      R(1)=R(1)+XL*PVX
      R(2)=R(2)+XL*PVY
      R(3)=R(3)+XL*PVZ
C        OUTSIDE IN Z ?       THEN CONTINUE WITH THE ENDCAPS
      IF(R(3).GT.ZTKP) GO TO 1000
      IF(R(3).LT.ZTKM) GO TO 1000
C
C      TEST FOR CONVERSION IN THE TANK WALL
C
      CALL EEPAIR(PV,P1,P2,XRL2,&11)
C ******                 CALCULATE ACTUAL CONVERSION POINT
      DCONV = DRITNK * RN(DUM) / STH
      R(1)  = R(1) + DCONV*PVX
      R(2)  = R(2) + DCONV*PVY
      R(3)  = R(3) + DCONV*PVZ
      RETURN
C
C      FOLLOW GAMMA FROM INNER TANK TO FIRST ROHACELL
C
   11 CONTINUE
      R1=R(1)**2+R(2)**2
      DR2=(R1ROH**2-R1)/PVXY
C        ALREADY BEYOND THE FIRST ROHACELL LAYER ?
      IF( DR2 .LE. 0. ) GO TO 12
      PVR=R(1)*PVX+R(2)*PVY
      PVR=PVR/PVXY
      XL=-PVR+SQRT(PVR**2+DR2)
C
      R(1)=R(1)+XL*PVX
      R(2)=R(2)+XL*PVY
      R(3)=R(3)+XL*PVZ
C        OUTSIDE IN Z ?       THEN CONTINUE WITH THE ENDCAPS
      IF(R(3).GT.ZTKP) GO TO 1000
      IF(R(3).LT.ZTKM) GO TO 1000
C
C      TEST FOR CONVERSION IN THE ROHACELL
C
      CALL EEPAIR(PV,P1,P2,XRL3,&12)
C ******                 CALCULATE ACTUAL CONVERSION POINT
      DCONV = DR1ROH * RN(DUM) / STH
      R(1)  = R(1) + DCONV*PVX
      R(2)  = R(2) + DCONV*PVY
      R(3)  = R(3) + DCONV*PVZ
      RETURN
C
C      FOLLOW GAMMA FROM FIRST ROHACELL TO SECOND ROHACELL
C
   12 CONTINUE
      R1=R(1)**2+R(2)**2
      DR2=(R2ROH**2-R1)/PVXY
C        ALREADY BEYOND THE SECOND ROHACELL LAYER ?
      IF( DR2 .LE. 0. ) GO TO 13
      PVR=R(1)*PVX+R(2)*PVY
      PVR=PVR/PVXY
      XL=-PVR+SQRT(PVR**2+DR2)
C
      R(1)=R(1)+XL*PVX
      R(2)=R(2)+XL*PVY
      R(3)=R(3)+XL*PVZ
C        OUTSIDE IN Z ?       THEN CONTINUE WITH THE ENDCAPS
      IF(R(3).GT.ZTKP) GO TO 1000
      IF(R(3).LT.ZTKM) GO TO 1000
C
C      TEST FOR CONVERSION IN THE ROHACELL LAYER
C
      CALL EEPAIR(PV,P1,P2,XRL4,&13)
C ******                 CALCULATE ACTUAL CONVERSION POINT
      DCONV = DR2ROH * RN(DUM) / STH
      R(1)  = R(1) + DCONV*PVX
      R(2)  = R(2) + DCONV*PVY
      R(3)  = R(3) + DCONV*PVZ
      RETURN
C
C      FOLLOW GAMMA FROM SECOND ROHACELL TO TANK
C
   13 CONTINUE
      R1=R(1)**2+R(2)**2
      DR2=(ROTNK**2-R1)/PVXY
C
C --------------------  START OF NEW CODE FOR TOKYO SHOWER PROGRAM
C
C
C  IN OUTER TANK WALL NOT YET REACHED, CONTINUE AT 1515 (NORMAL CASE)
C  OTHERWISE SCALE 3-VECTOR TO RADIUS(1) AND SKIP CONVERSION TESTS
C
      IF( DR2 .GT. 0. ) GO TO 1515
      RY=R(1)**2+R(2)**2
      DRY=(RADIUS(1)**2-RY)/PVXY
      PVR=R(1)*PVX+R(2)*PVY
      PVR=PVR/PVXY
C
C THIS CASE IS ABNORMAL AND COULD COME FROM LOW ENERGY BREMSSTRAHLUN
C ON THE WAY BACK INTO THE INNER DETECTOR (AS SEEN FROM PRINT)
C NEGLECT THIS PARTICLE, SINCE SOFTWARE NOT CAPABLE OF FOLLOWING IT!
C
      IF(PVR**2 + DRY.LT.0.) RETURN2
C
      XL=-PVR+SQRT(PVR**2+DRY)
C SCALE TO RADIUS(1), REMEMBER THIS IN RYAM
      RYAM(1)=R(1)+XL*PVX
      RYAM(2)=R(2)+XL*PVY
      RYAM(3)=R(3)+XL*PVZ
      IREGFL = -1
      IF(RYAM(3).GT.0.) IREGFL = 1
      GO TO 15
C
1515  PVR=R(1)*PVX+R(2)*PVY
      PVR=PVR/PVXY
      XL=-PVR+SQRT(PVR**2+DR2)
C                         SCALE TO OUTER TANK WALL RADIUS
      R(1)=R(1)+XL*PVX
      R(2)=R(2)+XL*PVY
      R(3)=R(3)+XL*PVZ
C        OUTSIDE IN Z ?       THEN CONTINUE WITH THE ENDCAPS
      IF(R(3).GT.ZTKP) GO TO 1000
      IF(R(3).LT.ZTKM) GO TO 1000
C
C      TEST FOR CONVERSION IN THE TANK WALL
C
      PPROB=EXP(-XRL5*7./9.)
      IF(PV(4).LT.0.5) PPROB=EXP(-XRL5*7./9.*(1.-6.2E-02/SQRT(PV(4))))
      RY=R(1)**2+R(2)**2
C SCALE TO RADIUS(1), REMEMBER THIS IN RYAM
      DRY=(RADIUS(1)**2-RY)/PVXY
      PVR=R(1)*PVX+R(2)*PVY
      PVR=PVR/PVXY
      XL=-PVR+SQRT(PVR**2+DRY)
C
      RYAM(1)=R(1)+XL*PVX
      RYAM(2)=R(2)+XL*PVY
      RYAM(3)=R(3)+XL*PVZ
      IREGFL = 0
C GO TO 15 MEANS NO CONVERSION
      IF(PPROB.GT.RN(DUM)) GO TO 15
C
C      FOLLOW ELECTRON FROM TANK TO TOF COUNTERS. IT IS ASSUMED THAT
C      THE PHOTON CONVERTS INTO ONE ELECTRON WHICH CONTINUES WITH
C      DIRECTION AS THE PHOTON AS ENERGY LOSS ONLY SHOWER LOSSES ARE
C      CONSIDERED
C
C   THE ABOVE IS STANDARD TREATMENT. HERE THE CHANGE TO ELECTRON IS
C   NOT DONE, BUT THE TOF COUNTER IS SET, AND THEN CONTINUE WITH
C   THE SHOWER TREATMENT.
C
C     POLD = PV(6)
C     PNEW = POLD
C     IF(LFLAG(2)) PNEW=PV(6)-0.02*(1.+0.3*RN(DUM))*(0.5*XRL5+XRL6)
C     IF(PNEW.LT.0.) PNEW=0.001
C     PV(1) = PNEW/POLD*PV(1)
C     PV(2) = PNEW/POLD*PV(2)
C     PV(3) = PNEW/POLD*PV(3)
C     PV(6) = SQRT( PV(1)**2+PV(2)**2+PV(3)**2 )
C     PV(4)=SQRT(PV(6)**2+ME**2)
C     PV(5)=ME
C     PV(7)=1.
C     LFLAG(10) = .FALSE.
C
C
      R1=R(1)**2+R(2)**2
      DR2=(RTOF**2-R1)/PVXY
      PVR=R(1)*PVX+R(2)*PVY
      PVR=PVR/PVXY
      XL=-PVR+SQRT(PVR**2+DR2)

      R(1)=R(1)+XL*PVX
      R(2)=R(2)+XL*PVY
      R(3)=R(3)+XL*PVZ
C
C        OUTSIDE IN Z ?       THEN CONTINUE WITH THE ENDCAPS
      IF(R(3).GT.ZTOFPL) GO TO 1000
      IF(R(3).LT.ZTOFMI) GO TO 1000
C
C      SET TOF COUNTER
C
      CALL SETTOF(R)
C                                           MOD E.ELSEN 22/08/80
      TRL=RTOF/ABS(PVZ)
      CALL ACTOF(PV,R,TRL)
C
C  SHOWER TREATMENT FOLLOWS IMMEDIATELY, USING POSITION IN RYAM
C
C
C      FOLLOW GAMMA FROM TANK TO COIL
C
C  15 R1=R(1)**2+R(2)**2
C     DR2=(RCOIL**2-R1)/PVXY
C     IF( DR2 .LE. 0. ) GO TO 20
C     PVR=R(1)*PVX+R(2)*PVY
C     PVR=PVR/PVXY
C     XL=-PVR+SQRT(PVR**2+DR2)
C
C     R(1)=R(1)+XL*PVX
C     R(2)=R(2)+XL*PVY
C     R(3)=R(3)+XL*PVZ
C
C     IF(R(3).GT.ZLGPL) GO TO 1000
C     IF(R(3).LT.ZLGMI) GO TO 1000
C
C      TEST FOR CONVERSION IN THE COIL
C
C     IF(PV(5).GT.1.E-5) GO TO 20
C     PPROB=EXP(-XRL6*7./9.)
C     IF(PV(4).LT.0.5) PPROB=EXP(-XRL6*7./9.*(1.-6.2E-02/SQRT(PV(4))))
C     IF(PPROB.LT.RN(DUM)) GO TO 20
C     POLD = PV(6)
C     PNEW = POLD
C     IF(LFLAG(2)) PNEW=PV(6)-0.02*(1.+0.3*RN(DUM))*0.5*XRL6
C     IF(PNEW.LT.0.) PNEW=0.001
C     PV(1) = PNEW/POLD*PV(1)
C     PV(2) = PNEW/POLD*PV(2)
C     PV(3) = PNEW/POLD*PV(3)
C     PV(6) = SQRT( PV(1)**2+PV(2)**2+PV(3)**2 )
C     PV(4)=SQRT(PV(6)**2+ME**2)
C     PV(5)=ME
C     PV(7)=1.
C     PV(4)=SQRT(PV(6)**2+ME**2)
C     PV(5)=ME
C     PV(7)=1.
C     LFLAG(10) = .FALSE.
C
C      FOLLOW ELECTRON OR GAMMA FROM TOF TO LEAD GLASS
C
C  20 R1=R(1)**2+R(2)**2
C     DR2=(RLG**2-R1)/PVXY
C     IF( DR2 .LE. 0. ) GO TO 9000
C     PVR=R(1)*PVX+R(2)*PVY
C     PVR=PVR/PVXY
C     XL=-PVR+SQRT(PVR**2+DR2)
C
C     R(1)=R(1)+XL*PVX
C     R(2)=R(2)+XL*PVY
C     R(3)=R(3)+XL*PVZ
C
C     IF(R(3).GT.ZLGPL) GO TO 1000
C     IF(R(3).LT.ZLGMI) GO TO 1000
15    CALL LGMC56(0,PV(1),RYAM(1),IREGFL,0)
      RETURN 2
C
C      FOLLOW PHOTON TO THE FACE OF THE END CAP COUNTERS
C
C FOR SHOWER TREATMENT, SCALE POSITION TO ZPV:
C
C
 1000 CONTINUE
      RABS=0.
      DO 1001 I3=1,3
 1001 RABS=RABS+R(I3)**2
      RABS=SQRT(RABS)
      DO 1002 I3=1,3
 1002 R(I3)=R(I3)/RABS
      ZLAM=ZPV(1)/R(3)
      IREGFL = -1
      IF( R(3) .GT. 0. ) ZLAM=ZPV(3)/R(3)
      IF( R(3) .GT. 0. ) IREGFL = 1
C  STORE POSITION IN RYAM, THEN CONTINEU WITH SHOWER IN ENDCAP
      DO 1003 I3=1,3
 1003 RYAM(I3)=ZLAM*R(I3)
      IF(IREGFL.NE.0) GO TO 15
C
C
C      WRITE(6,6682) ZLAM,ZPV(1),ZPV(3),(R(I3),I3=1,3)
C6682  FORMAT(' ZLAM ZPV1,3 R1-3 RYAM1-3 ',9E12.4)
C      CALL ENDCLG(RYAM(1),NCL,&9000)
C9000  WRITE(6,6681) IREGFL,NCL,(RYAM(I3),I3=1,3),(PV(I3),I3=1,4)
C6681  FORMAT(' IREGFL NCL RYAM PV ',I3,I5,3E12.4,2X,4E12.4)
C
      RETURN 2
      END
