C   06/03/82 901162211  MEMBER NAME  DEDXBN   (JADEGS)      FORTRAN77
      SUBROUTINE DEDXBN
C-----------------------  LAST CHANGE: 16.01.89   C.B.      ---C
C-----------------------       CHANGE: 07.06.88   E.E.      ---C
C-----------------------       CHANGE: 05.04.88   E.E.      ---C
C-----------------------       CHANGE: 20.11.87   E.E.      ---C
C-----------------------       CHANGE: 16.11.87   J.O.      ---C
C-----------------------       CHANGE: 13.11.87   E.E       ---C
C-----------------------       CHANGE: 26.06.87   K.A. E.E. ---C
C-----------------------       CHANGE: 27.08.86   L.BECKER  ---C
C-----------------------       CHANGE: 28.08.86  J.A.J.SKARD --C
C-----------------------       CHANGE: 02.06.87   K.AMBRUS  ---C
C     REPLACE LAND/SHFTL BY IAND/ISHFT            C B          C
C
C     REMOVE COS(THETA) DEPENDENCE                E E          C
C
C     MORE REALISTIC HIT CLEANING FOR MC          E E          C
C                                                              C
C     CHANGES FOR MC GRAPHICS RESULTS                          C
C                                                              C
C     CHANGED TO GENERATE DEDX FOR MC AS WELL                  C
C                                                              C
C     DETERMINE NUMBER OF OVERFLOW-HITS (BOTH WIRE ENDS)
C     DETERMINE MOMENTUM PROJECTIONS PX,PY,PZ
C     REBUILD MISSING LEFT OR RIGHT OVERFLOW-AMPLITUDES
C            AL,AR FROM Z-FIT
C     PERFORM NEW Z-CALIBRATION (BUT DO NOT STORE FIT RESULTS)
C     INTRODUCED JHTQ BANK TO GET HIT QUALITY
C     CORRECT FOR NEGATIVE OVERFLOW-AMPLITUDES-   K.AMBRUS
C
C     CALCULATION OF DE/DX, SIGMA(DE/DX)      -   P.DITTMANN   C
C     COMPARISON WITH THE THEORETICAL VALUE   -   J.SKARD      C
C                                                              C
C     RESULTS ARE WRITTEN INTO COMMON /CWORK1/                 C
C     THE ARRAY TRES(14,60) HOLDS THE FOLLOWING RESULTS        C
C                                                              C
C     ITRES(1,ITR)  =  NHIT, QUALITY OF DEDX                   C
C      TRES(2,ITR)  =  DEDX                                    C
C      TRES(3,ITR)  =  SIGMA(DEDX)                             C
C      TRES(4,ITR)  =  CHISQ(ELECTRON)                         C
C      TRES(5,ITR)  =  CHISQ(PION)                             C
C      TRES(6,ITR)  =  CHISQ(KAON)                             C
C      TRES(7,ITR)  =  CHISQ(PROTON)                           C
C     ITRES(8,ITR)  =  JMIN, NUMBER FOR MINIMUM CHISQUARE      C
C                      1 = P, 2 = K, 3 = PI, 4 = E, 0=NO DEDX  C
C      TRES(9,ITR)  =  MOMENTUM (GEV)                          C
C      TRES(10,ITR) =  MOMENTUM ERROR FOR MOST PROB. MASS -> JMIN
C--------------------------------------------------------------C
C--------------------------------------------------------------C
      IMPLICIT INTEGER*2 (H)
C----------------DEDX RESULTS-----------------------
       COMMON /CWORK1/ IER,NTRR,TRES(10,60),EWIR(60),XWIR(60),YWIR(60),
     *                 RWIR(60),ZWIR(60)
       DIMENSION ITRES(10,60)
       EQUIVALENCE (TRES(1,1),ITRES(1,1))
C----------------END--------------------------------
      DIMENSION IJCR(100)
      COMMON /CZSCAL/ IDUM,ZALC
C                                           FLAG TO REQUEST DATA FOR
C                                           SINGLE TRACK
      COMMON /CDXSIN/ ISNGTR
C
#include "cdata.for"
#include "cgraph.for"
#include "cjdrch.for"
C
#include "cdededx.for"
C
      INTEGER  NPVECT(0:1)
      INTEGER ONE / 1 /, ZFLAG
      INTEGER RUN2PR(20) /
     *       0, 1400, 2600, 3730, 6000, 7592,10000,11021,13088,14605,
     *   15690,16803,17988,19068,21123,21705,22651,24201,25454,27938 /
      LOGICAL MC
      REAL CMASS(4)
      REAL*4 AMASS(0:7) / 2*.1396, .511E-3, .1057, .1396, .4937,
     *                     .9383, .1396 /
      REAL*4 VDDATA / .00592 /
C
      IPVERS=JPOINT(IPN+1)
      ICALL =ICALL+1
      IF(ICALL.LE.1) THEN
        IPJETC = IBLN('JETC')
        IPJETV = IBLN('JETV')
        IPJHTL = IBLN('JHTL')
        IPJHTQ = IBLN('JHTQ')
        IPPATR = IBLN('PATR')
        IPHEAD = IBLN('HEAD')
        CMASS(1) = PROTMA
        CMASS(2) = FKAMAS
        CMASS(3) = PIOMAS
        CMASS(4) = ELMASS
      ENDIF
C
      IJETC = IDATA( IPJETC )
      IJETV = IDATA( IPJETV )
      IJHTL = IDATA( IPJHTL )
      IPATR = IDATA( IPPATR )
      IX    = 2*IDATA( IPHEAD )
      IRUN=HDATA(IX+10)
      MC = IRUN .LT. 100
      NTRR=0
C                                           SELECT PERIOD...
      IF( .NOT. MC) THEN
C                                           ...FOR REAL DATA
        IPN = JPOINT(8)
        IPVERS=JPOINT(IPN+1)
      ELSE
        IPVERS = 0
        IRUN = IZT2RN( DUMMY )
      ENDIF
C-
      IF(ICALL.EQ.1 .AND. NDDINN .EQ. 0 ) PRINT 901, IPVERS,
     *                                               NHFCUT,PMCUT
  901 FORMAT(/' +++ DEDXBN   07/06/88   Calibration Version ',I8,
     *       '  n(dE/dx)  >=',I4,'  pmom/q  >=',F12.4)
C
      IF(IJETC.EQ.0 .OR.IJHTL.EQ.0 .OR.IPATR.EQ.0) GOTO 56
      IF( .NOT. MC) THEN
        IJETR = IDATA(IJETC-1)
        IF(IJETR.EQ.0) GOTO 56
        IJETR2 = IJETR*2
        IJETC2 = IJETC*2
        IJETV2 = IJETV*2 + 2
C                                           DATE FOR RUN-DEPENDENT COR.
        IPERD = 1
   8    CONTINUE
        IF( IPERD.LT.20 .AND. RUN2PR(IPERD+1).LT.IRUN ) THEN
          IPERD = IPERD + 1
          GO TO 8
        ENDIF
        VDFACT = 1.
      ELSE
C                                           ...FOR MC DATA
        VDMC = 0.
        DO 9 J=1,2
          DO 9 I=1,96
    9   VDMC = VDMC + DRIVEL(I,J)
        VDMC = VDMC / 192.
        VDFACT = VDMC/VDDATA
C                                           IPERD NOT EFFECTIVE FOR MC
        IPERD = 1
      ENDIF
C                                           DIFFERENT TIME BASE
      VDFACT = VDFACT/64.
C
      NT = IDATA(IPATR+2)
      IF(NT.LE.0 .OR. NT.GT.NTRTOT) GOTO 57
      IER=0
      NTRR=NT
C                                           Z RECALIBRATION
C                                           (IF NOT YET DONE)
      IHH=HDATA(IJETC2+2)
      MODE= 11
      CALL ZSFIT(MODE)
C                                           POINTERS MAY HAVE CHANGED
      IJETC = IDATA( IPJETC )
      IJETR = IDATA( IJETC-1 )
      IJETV = IDATA( IPJETV )
      IJHTL = IDATA( IPJHTL )
      IPATR = IDATA( IPPATR )
      IX    = 2*IDATA( IPHEAD )
      IJETR2 = IJETR*2
      IJETC2 = IJETC*2
      IJETV2 = IJETV*2 + 2
C
      FIELD = HDATA(IX+30)
C
      IF( .NOT. MC ) THEN
        NDAY=HDATA(IX+7)*30+HDATA(IX+6)-30
        MDAY=NDAY
C
C              --- SPECIAL CORRECTIONS:
        IF (IRUN.GT.12644) CA(8)=0.248
C
        NDAY = NDAY - ID0(IPERD)
        DAY = NDAY
C --------------------------------------- GAS PRESSURE
        PREFAC = 1. / (1.+CP(IPERD)*BP(IPERD)*DAY/AP(IPERD))
C --------------------------------------- SUBPERIODS
        DO 5 L=1,3
          IF(NDAY.LT.LSP(L,IPERD)) GOTO 6
    5   CONTINUE
        L = 1
    6   SUBFAC = SPF(L,IPERD)
C --------------------------------------- ELECTRON ATTACHMENT
        ICLBIN = DAY/10. + 1.5
        IF(ICLBIN.LE.0) ICLBIN=1
        IF(ICLBIN.GT.19) ICLBIN=19
        FRACT = DAY/10. - ICLBIN + 1
        TIMCOR = CA(IPERD)* (CL(ICLBIN)+FRACT*(CL(ICLBIN+1)-CL(ICLBIN)))
        TIMCOR = TIMCOR/1000.
      ENDIF
C --------------------------------------- QUALITY OF HITS IN JHTQ
      IJHTQ = IDATA( IPJHTQ )
      IF( IJHTQ.GT.0 ) THEN
        JHTQBT = IDATA(IJHTQ+1)
        NHPW = 32/JHTQBT
      ENDIF
C --------------------------------------- LOOP OVER ALL TRACKS
      L0 = IDATA(IPATR+1)
      LT = IDATA(IPATR+3)
      KT = IPATR + L0
      DO 59 I=1,NT
C--------
        CALL MOMENP(KT,PX,PY,PZ,PTRANS,PMOM,PHI,THE)
C--------
        COST = PZ/PMOM
        PZ1 = ADATA(KT+30)
        PZ0 = ADATA(KT+31)
        NHRZ= IDATA(KT+33)
        IF(ADATA(KT+25).NE.0.) THEN
          R = -1. / ADATA(KT+25)
          SR = SIGN(1.,R)
          CTH = SQRT(ADATA(KT+8)**2+ADATA(KT+9)**2)
          STH = ADATA(KT+10)
          TTH = ABS(STH/CTH)
        ELSE
          PMOM = 0.
        ENDIF
        IF (PMOM.GE.PMCUT .AND. TTH.LE.6.) THEN
          NHIT = 0
          CALL VZERO(IZB,60)
C
          CPHI = ADATA(KT+8) / CTH
          SPHI = ADATA(KT+9) / CTH
          X0 = ADATA(KT+5)
          Y0 = ADATA(KT+6)
          XM = X0 - R*SPHI
          YM = Y0 + R*CPHI
          R0 = SQRT(X0**2+Y0**2)
          XE = ADATA(KT+12)
          YE = ADATA(KT+13)
          SE = R * ATAN2(SR*(CPHI*(XE-X0)+SPHI*(YE-Y0)),
     *                   SR*(SPHI*(XE-X0)-CPHI*(YE-Y0)+R))
          IF(ABS(R).GT.1.E5) SE=SQRT((XE-X0)**2+(YE-Y0)**2)
C
C --------------------------------------- ORDER CELLS
          NC = 0
          DO 12 J=1,6
            KC = IDATA(KT+40-J)
            IF(KC.LE.0 .OR. KC.GT.96) GOTO 12
            IF(NC.EQ.0) GOTO 11
            IF(KC.GT.IC(NC)) GOTO 11
            DO 10 K=1,NC
               IF(KC.GT.IC(K)) GOTO 10
               IF(KC.EQ.IC(K)) GOTO 12
               JC = IC(K)
               IC(K) = KC
               KC = JC
   10       CONTINUE
   11       NC = NC + 1
            IC(NC) = KC
   12     CONTINUE
C --------------------------------------- LOOP OVER CELLS
          IM2 = I*2
          IM1 = IM2*65536
          DO 19 J=1,NC
            NCP = IJETC2 + IC(J) + 2
            NHCELL = (HDATA(NCP+1)-HDATA(NCP))/4
            KHCELL = (HDATA(NCP)-1)/4
            DO 14 L=1,16
   14       IHDT(L) = 0
C --------------------------------------- LOOP OVER HITS
            DO 18 K=1,NHCELL
              KA = IJHTL + KHCELL + K + 1
              IF(IDATA(KA).EQ.0) GOTO 18
              LRFLAG = 0
              ZFLAG = 0
              IMH=IAND(IDATA(KA),MTRNO1)
              IF(IMH.EQ.IM1) THEN
                IF(TBIT(IDATA(KA),15)) ZFLAG=1
                IF(TBIT(IDATA(KA), 7)) LRFLAG=1
                KABIT = 15
              ELSE
                IMH=IAND(IDATA(KA),MTRNO2)
                IF(IMH.NE.IM2) GOTO 18
                IF(TBIT(IDATA(KA),31)) ZFLAG=1
                IF(TBIT(IDATA(KA),23)) LRFLAG=1
                KABIT = 31
              ENDIF
C ------------------------------------- HIT FOUND IN CELL IC(J), TRACK I
              IF (NHIT.EQ.60) GOTO 20
C                                             TAKE HIT QUALITY FROM JHTQ
              IF( IJHTQ .GT. 0 ) THEN
                KS = KHCELL + K
                NRW = (KS-1)/NHPW + 1
                NQW = IJHTQ + 1 + NRW
                NSHIFT = MOD(KS-1,NHPW)*JHTQBT
                IF( KABIT .EQ. 15 ) NSHIFT = NSHIFT + 1
                ZFLAG = 0
                IF( IAND(IDATA(NQW),ISHFT(ONE,NSHIFT)).NE.0 ) ZFLAG = 1
              ENDIF
C
              NHIT = NHIT + 1
              NH1 = IJETC2 + (KHCELL+K-1)*4 + 101
              IJC(NHIT) = NH1
C                                             RAW BANK
              NH1R = IJETR2 + (KHCELL+K-1)*4 + 101
              IJCR(NHIT) = NH1R
C
              IJH(NHIT) = KA
              IF(KABIT.EQ.15) IJH(NHIT)=-IJH(NHIT)
              LRFL(NHIT) = LRFLAG
              MHIT = HDATA(NH1)
              NW(NHIT) = MHIT / 8
              LH(NHIT) = IAND(MHIT,7) + 1
              ILAY = IAND(NW(NHIT),15) + 1
              IHDT(ILAY) = NHIT
              IZB(NHIT) = 0
              IF(ZFLAG.NE.0) IZB(NHIT) = LH(NHIT)
C                                           REMOVE HITS IN CORNERS
              IF( IZB(NHIT).NE.0 ) THEN
                NR = MIN(NW(NHIT)/384+1,3)
                T = HDATA(NH1+3)*VDFACT
                ILR = LRFLAG + 1
                TM = VDREL(IPERD)*(TMAX(ILR,NR)+TSLP(ILR,NR)*(ILAY-1))
                XT = T/TM
                IF( ILAY.LE.1 .OR. ILAY.GT.14 ) THEN
                  IF( T.GT.90. ) THEN
                    IF( ( ILAY.EQ.16 .AND. LRFLAG.EQ.1 ) .OR.
     *                  ( ILAY.EQ. 1 .AND. LRFLAG.EQ.0 ) .OR.
     *                  ( ILAY.EQ.15 .AND. LRFLAG.EQ.1 .AND.
     *                    T.GT.180. .AND. NR.EQ.2 ) ) THEN
                      IZB(NHIT) = 0
                    ENDIF
                  ENDIF
                ENDIF
                IF( XT.GT. 0.97 .OR. T.LT.4. ) IZB(NHIT) = 0
              ENDIF
   18       CONTINUE
C
C --------------------------------------- X-TALK MATRIX
            DO 119 L=1,16
              K = IHDT(L)
              IF(K.GT.0 .AND. K.LE.60) THEN
                DO 114 M=1,4
                  IXL(K,M) = 0
                  IXH(K,M) = 0
                  IF(L.GT.M .AND. IHDT(L-M).NE.0) IXL(K,M) = IHDT(L-M)
                 IF(L.LT.17-M .AND. IHDT(L+M).NE.0) IXH(K,M) = IHDT(L+M)
  114           CONTINUE
              ENDIF
  119       CONTINUE
   19     CONTINUE
C
   20     CONTINUE
C ---- ----------------------------------- LOOP OVER ALL HITS OF TRACK I
          NHF = 0
          NOV = 0
          NFT = 0
          NCL = -1
C
          IF( .NOT. MC ) THEN
            DO 29 J=1,NHIT
              IF(IZB(J).NE.0) THEN
                NC = NW(J) / 16
                NR = NC / 24
                IF(NR.LT.3) NR=NR+1
                INR = (NR-1)*2
                NL = IAND(NW(J),15)
                NH1 = IJC(J)
                AR = HDATA(NH1+1)
                AL = HDATA(NH1+2)
C-------                                    FIND OVERFLOW-HITS
                NH1R = IJCR(J)
                ARR = HDATA(NH1R+1)
                ALR = HDATA(NH1R+2)
                IF(ALR.GE.4095.) AL = 32400.
                IF(ARR.GE.4095.) AR = 32400.
                AMP = AL + AR
                T = HDATA(NH1+3) / 64.
C
C------- RECONSTRUCT SINGLE SIDE OVERFLOW AMPLITUDES
C------- FROM FITTED ZR-TRACK-PARAMETERS
                IF(NHRZ.GE.10 .AND.
     *             .NOT. (ALR.LT.4095. .AND. ARR.LT.4095.) .AND.
     *             .NOT. (ARR.GE.4095. .AND. ALR.GE.4095.) ) THEN
                  LRFLAG = LRFL(J)
                  CALL ZSXY(NH1,LRFLAG,XJET1,YJET1,XJET2,YJET2)
                  ZTH = PZ0 + PZ1*SQRT(XJET1**2+YJET1**2)
                  IF(ZALC.LE.0.) ZALC = 1400.
                  FAK = (ZALC - ZTH)/(ZALC + ZTH)
                  ARN = 0.
                  ALN = 0.
                  IF(ARR.GE.4095.) ARN= AL*FAK
                  IF(ALR.GE.4095.) ALN= AR/FAK
                  IF(ARN.GT.AR) AR = ARN
                  IF(ALN.GT.AL) AL = ALN
                  AMP= AR + AL
                ENDIF
C
                AMP = AMP / 8.
C ------------------------------------------ REMOVE HITS IN CELL CORNERS
                IF(IPERD.EQ.1 .AND. NC.EQ.9) GOTO 26
C --------------------------------------- X - TALK
                DW(J) = 0
                DO 124 M=1,4
                  JXT = 1
                  K = IXL(J,M)
                  IF(K.LE.0 .OR. K.GT.60) GOTO 122
  121             NHX = IJC(K)
                    AMPX = (HDATA(NHX+1)+HDATA(NHX+2))/8.
                    TX = HDATA(NHX+3)/64.
                    GATE = T - TX - 1.0
                    IF(GATE.GE.0.) THEN
                      IF(GATE.GT. 9.) GOTO 122
                      BT = GATE
                    ELSE
                      BT = 10. + GATE
                      IF(BT.LE.0.) GOTO 122
                    ENDIF
                    FXT = 1.-BT/5.*(1.-BT/20.)
                    IF(GATE.LT.0.) FXT=1.-FXT
                    AMP = AMP + AMPX*CTALK(M)*FXT
                    DW(J) = DW(J) + AMPX*CTALK(M)
  122               JXT = JXT + 1
                    IF(JXT.GT.2) GOTO 124
                      K = IXH(J,M)
                  IF(K.NE.0) GOTO 121
  124           CONTINUE
                DL(J) = AMP
C --------------------------------------- GAIN
                GAIN=ACALIB(IPN+6+NW(J))
                AMP = AMP * GAIN
C --------------------------------------- WIRE STAGGERING
                IMH=IAND(NL,1)
                IF(IMH.NE.LRFL(J)) AMP=AMP*0.92
C -------------------- COMPUTE TRACK LENGTH IN DRIFTSPACE, ANODE CURRENT
                IF(NC.NE.NCL) THEN
                  NCL = NC
                  CURR = 0.
                  IF(IJETV.NE.0) THEN
                    NS = NC - (NR-1)*24
                    IF(NR.EQ.3) NS=NS/2
                    KR = NR
                    IMH=IAND(NC,1)
                    IF(NR.EQ.3 .AND. IMH.EQ.1) KR=4
                    ICURR = HDATA(IJETV2+NS*4+KR)
                    CURR = IAND(ICURR,2047)
                    IF (CURR.GT.80.) CURR=0.
                  ENDIF
                  PHIW = 0.1309 + 0.2618*NC
                  IF(NC.GE.48) PHIW=PHIW/2.
                  CPHW = COS(PHIW)
                  SPHW = SIN(PHIW)
                  CPHD =  SPHW*DRICOS + CPHW*DRISIN
                  SPHD = -CPHW*DRICOS + SPHW*DRISIN
                ENDIF
                RW = 211.*NR + 10.*NL
                XW = RW * CPHW
                YW = RW * SPHW
                SGAM = ((XW-XM)*SPHD-(YW-YM)*CPHD)/R
                IF(ABS(SGAM).GT..87) GOTO 26
                CGAM = SQRT(1.-SGAM**2)
                TGAM = SGAM/CGAM
C --------------------------------------- TRACK LENGTH
                AMP = AMP * CGAM*CTH
                DT(J) = TGAM
C --------------------------------------- ANODE CURRENT
                AMP = AMP / (1.-0.00011*CURR**2)
C --------------------------------------- FINITE GATE LENGTH
                AMP = AMP / (1.-0.25*TGAM-0.60*TGAM**2)
C --------------------------------------- SATURATION
                AMP = AMP/(1.-SATTO(INR+1,IPERD)*
     *                     EXP(-SATTO(INR+2,IPERD)*SQRT(T)))
                AMP = AMP/(1.-SATQUA(NR,IPERD)*T**2/1000.)
                AMP = AMP*9.67/SATFAC(NR,IPERD)
C --------------------------------------- GAS PRESSURE
                AMP = AMP * PREFAC
C --------------------------------------- SUBPERIODS
                AMP = AMP * SUBFAC
C --------------------------------------- DAY/4 CORRECTION
                IDAY4=MDAY/4 + (NR-1)*100 + 1
                ADAY4=ACALIB(IPN+1541+IDAY4)
                AMP = AMP * ADAY4
C --------------------------------------- ATTACHMENT
                AMP = AMP * EXP(TIMCOR*T)
C --------------------------------------- GAIN SATURATION
               AMP = AMP/(1.-SATSO(INR+1,IPERD)*EXP(-SATSO(INR+2,IPERD)*
     *                                   SQRT(TTH**2+SATSO(7,IPERD)*T)))
C --------------------------------------- EDGE FIELD DISTORTIONS
                IF(NL.LE.3 .OR. NL.GE.12) THEN
                  IL = NL
                  IF(NL.GT.8) IL=15-NL
                  ICORN = 0
                  IF(NL.LT.8 .AND. LRFL(J).EQ.1) ICORN=1
                  IF(NL.GT.8 .AND. LRFL(J).EQ.0) ICORN=1
                  ICORN = ICORN*4 + IL + 1
                  XTORT = XT - 0.5
                  IF(XTORT.LT.0.) XTORT=0.
                  AMP = AMP * FTORT(1,ICORN)*(1.+FTORT(2,ICORN)*XTORT)
                ENDIF
C --------------------------------------- COS( THETA ) DEPENDENCE
                AMP = AMP * DEDXCS( NW(J), COST, IPERD )
C
                IF (NHF.EQ.60) GO TO 30
                  NHF = NHF + 1
C------- MARK OVERFLOW-HITS
                  IF(AMP.LT.0.) AMP = 0.
                  IF(ARR.GE.4095. .AND. ALR.GE.4095.) AMP = 10000. + AMP
                  IF(ARR.GE.4095. .AND. ALR.GE.4095.) NOV = NOV + 1
                  IF(ARR.GE.4095. .AND. ALR.LT.4095.) NFT = NFT + 1
                  IF(ARR.LT.4095. .AND. ALR.GE.4095.) NFT = NFT + 1
                  G(NHF) = AMP
                  S(J) = AMP
C                                           WRITE COORDINATES FOR
C                                           REQUESTED TRACK
                  IF( I .EQ. ISNGTR ) THEN
                    CALL ZSXY( NH1, LRFL(J),XWIR(NHF),YWIR(NHF),
     *                                       XJET2,YJET2)
                    RWIR(NHF) = SQRT( XWIR(NHF)**2+YWIR(NHF)**2)
                    EWIR(NHF) = AMP
                    CALL AMPS2Z( NH1, IJETC, ZWIR(NHF), WWW, IZGOOD )
                  ENDIF
                  GOTO 29
   26             IZB(J) = 0
              ENDIF
   29       CONTINUE
   30       CONTINUE
          ELSE
C                                 MC
C                                           POINTERS TO "TRUE"
C                                           INFORMATION
            NPHIT2 = IDATA(IBLN('HITL'))*2
            NPHTSL = IDATA(IBLN('HTSL'))
            NPHTS2 = NPHTSL*2
            NPVECT(0) = IDATA(IBLN('VECT'))
            IF( NPVECT(0).GT.0 ) THEN
              NPVECT(1) = IDATA(NPVECT(0)-1)
            ELSE
              NPVECT(1) = 0
            ENDIF
C                                           CREATE HTII, INVERT HTSL,
C                                           IF NOT YET DONE
            NPHTI2 = IDATA(IBLN('HTII'))*2
            IF( NPHTI2.LE.0 .AND. NPHTS2.GT.0 ) THEN
              CALL CCRE( NPHTII, 'HTII', IDATA(NPHTSL-2),
     *                   IDATA(NPHTSL), IER )
              NPHTI2 = NPHTII*2
              IF( NPHTI2.GT.0 ) THEN
                HDATA(NPHTI2+1) = HDATA(NPHTS2+1)
                NHHTSL = HDATA(NPHTS2+1)
                DO 41 K=1,NHHTSL
                  NEWHIT = HDATA(NPHTS2+K+1)
                  IF( NEWHIT.GT.0 ) THEN
                    HDATA(NPHTI2+1+NEWHIT) = K
                  ELSEIF( NEWHIT.LT.0 ) THEN
                    HDATA(NPHTI2+1-NEWHIT) = K
                  ENDIF
   41           CONTINUE
              ENDIF
            ENDIF
            IVECOL = -1
            DO 42 J=1,NHIT
              IF( IZB(J) .NE. 0 ) THEN
                ITYPE = 0
                PTOT = 3*AMASS(ITYPE)
                IVECT = 0
C                                           TRY TO CORRELATE HIT
C                                           WITH GENERATING TRACK
                IJCHNR = (IJC(J)-IJETC2-97)/4
                IF( NPHTI2.GT.0 ) THEN
                  HLINK = HDATA(NPHTI2+1+IJCHNR)
                  IF( HLINK.LT.0 ) HLINK = -HLINK
                  IF( HLINK.GT.0 .AND. NPHIT2.GT.0 ) THEN
                    IVECT = HDATA(NPHIT2+1+HLINK)
                    IF( IVECT .NE. IVECOL ) THEN
                      IPART = IVECT/2
                      NRVECT = IVECT-IPART*2
                      NPV = NPVECT(NRVECT)
                      IF( NPV.GT.0 ) THEN
                        NPV = IDATA(NPV+1)+(IPART-1)*IDATA(NPV+2)+NPV
                        ITYPE = IDATA(NPV+7)
                        PTOT = SQRT(ADATA(NPV+1)**2+ADATA(NPV+2)**2
     *                                          +ADATA(NPV+3)**2)
                      ENDIF
                    ENDIF
                  ENDIF
                ENDIF
                NHF = NHF + 1
C                                           FILL ARRAY OF THEOR. VALUES
                IF( IVECT .NE. IVECOL ) THEN
C                                           RECOMPUTE SINCE NEW
C                                           PARTICLE FOUND
                  XM = AMASS(MAX(0,MIN(ITYPE,7)))
                  G(NHF) = DEDXTP( PTOT, XM, 1. )
                  IVECOL = IVECT
                ELSE
C                                           SAME PARTICLE AS FOR PREV
                  G(NHF) = G(NHF-1)
                ENDIF
C                                           WRITE COORDINATES FOR
C                                           REQUESTED TRACK
                IF( I .EQ. ISNGTR ) THEN
                  NH1 = IJC(J)
                  CALL ZSXY( NH1, LRFL(J),XWIR(NHF),YWIR(NHF),
     *                                    XJET2,YJET2)
                  RWIR(NHF) = SQRT( XWIR(NHF)**2+YWIR(NHF)**2)
                  EWIR(NHF) = G(NHF)
                  CALL AMPS2Z( NH1, IJETC, ZWIR(NHF), WWW, IZGOOD )
                ENDIF
              ENDIF
   42       CONTINUE
C                                           ADD SYST CONTRIBUTION
C                                           GENERATE SPECTRUM
            CALL DXMCSS( NHF, G, IRUN )
          ENDIF
C
C
          IF(NHF.GT.NHFCUT) THEN
            CALL DSORTO(NHF,G,TRCM,DTRCM)
            IF(TRCM.GE.0.1) THEN
              IF( MC ) THEN
                CAL = 1.
              ELSE
                CAL = CALEX(IRUN,PMOM,COST,SR,TRCM)
              ENDIF
              TRCM  = TRCM*CAL
              DTRCM = DTRCM*CAL
              DTRCM = ERDEDX(TRCM,DTRCM,IRUN,NHF)
            ENDIF
C
C
            IF(TRCM.GE.0.1) THEN
C
C--------------  RESULTS  ----------------------------------------------
C
              ITRES(1,I)=NHF
              TRES(2,I)=TRCM
              TRES(3,I)=DTRCM
              TRES(9,I)=PMOM
C
              PP2=TRCM
              SIGDE=TRES(3,I)
C
              CHMIN=1000000.
              SIGPP=1000000.
              JMIN=0
              DO 51 J=4,1,-1
                CALL ERRMOM(KT,PMOM,CMASS(J),SIGMP)
CCC             CALL DECHIF(PMOM,SIGMP,PP2,SIGDE,CMASS(J),PDE,DEDE,CHIC)
                CALL AECHIL(PMOM,SIGMP,PP2,SIGDE,CMASS(J),PDE,DEDE,CHIC)
                IF(CHMIN .GE. CHIC) THEN
                  CHMIN=CHIC
                  SIGPP=SIGMP
                  JMIN=J
                ENDIF
                TRES(8-J,I)=CHIC
   51         CONTINUE
              ITRES(8,I)=JMIN
              TRES(10,I)=SIGPP
            ENDIF
          ELSE
            ITRES(1,I)=-1
            TRES(2,I)=0.
            TRES(3,I)=0.
            TRES(4,I)=-1.
            TRES(5,I)=-1.
            TRES(6,I)=-1.
            TRES(7,I)=-1.
            ITRES(8,I)=0
            TRES(9,I)=PMOM
            TRES(10,I)=1000000.
          ENDIF
        ELSE
C
          ITRES(1,I)=-1
          TRES(2,I)=0.
          TRES(3,I)=0.
          TRES(4,I)=-1.
          TRES(5,I)=-1.
          TRES(6,I)=-1.
          TRES(7,I)=-1.
          ITRES(8,I)=0
          TRES(9,I)=PMOM
          TRES(10,I)=1000000.
        ENDIF
C
C-------------  END OF RESULTS  ---------------------------------------
C
   59 KT = KT + LT
C                                           DELETE JHTQ, HTII BANKS
      CALL BMLT( 2, 'JHTQHTII' )
      CALL BDLM
C
      GO TO 8000
C
   56 PRINT 561
  561 FORMAT ('  ***** ERROR IN DEDXBN: BANK POINTER = 0')
      IER=1000
      GO TO 8000
C
   57 PRINT 571
  571 FORMAT ('  ***** ERROR IN DEDXBN: # OF TRACKS < 0 OR > 60')
      IER=4000
 8000 CONTINUE
      ISNGTR = 0
C
      END
      BLOCK DATA
C                                           FLAG TO REQUEST DATA FOR
C                                           SINGLE TRACK
      COMMON /CDXSIN/ ISNGTR
      DATA ISNGTR / 0 /
      END
C   02/09/86 609061900  MEMBER NAME  DSORTO   (S)           FORTRAN
C     **********************************
      SUBROUTINE DSORTO(N,PH,TRCM,DTRCM)
C     **********************************
C-------------------------------------- CHANGED: 29/08/86 K.AMBRUS
C
C   SUBROUTINE TO TAKE AVERAGE OF 5% - 70% LOWEST PULSE HEIGHTS
C     PUSE HEIGHTS IN PH(L) ,L=L'TH PULSE HEIGHT (INCL. OVERFLOWHITS)
C   OVERFLOW - HITS ARE USED
C   CORRECTION FOR FRACTIONAL HITS
C
C-----------------------------------------------------------------------
      DIMENSION PH(60)
C                            SET TRUNCATED MEAN FRACTION
      DATA TRMFLO /0.05/, TRMFHI /0.70/
      DATA NMIN   / 3  /
      IF (N.LT.NMIN) GOTO 99
C                            SORT PULSEHEIGHTS IN INCREASING ORDER
C=====
          XN = FLOAT(N)
        XNL = TRMFLO*XN
        XNH = TRMFHI*XN
      NTRMLO = XNL + 1
      NTRMHI = XNH + 1
      WL = XNL + 1. - NTRMLO
      WH = NTRMHI - XNH
C                            USE SHELL ALGORITHM
      M=N
   10 M=M/2
      IF (M.EQ.0) GO TO 40
      K=N-M
      DO 30 J=1,K
      I=J
   20 IF (I.LT.1) GO TO 30
      IF (PH(I+M).GE.PH(I)) GO TO 30
      W=PH(I)
      PH(I)=PH(I+M)
      PH(I+M)=W
      I=I-M
      GO TO 20
   30 CONTINUE
      GO TO 10
   40 CONTINUE
C                            SHELLS ARE SORTED NOW
        TRM = 0.
        SUM=0.
        SUM2=0.
          IO = 0
      DO 60 I=NTRMLO,NTRMHI
C                            ESTIMATION FOR OVERFLOW-HITS
          IF(PH(I).GE.10000.) IO = IO + 1
          IF(IO.EQ.1) PH(I) = PH(I) - 10000.
          IF(IO.EQ.1 .AND. I.GT.1 .AND. PH(I).LT.PH(I-1)) PH(I)=PH(I-1)
          IF(IO.GT.1) PH(I) = PH(I-1)*1.05
        IH = I
        TRM = TRM + 1.
        SUM=SUM+PH(I)
        SUM2=SUM2+PH(I)**2
  60  CONTINUE
C                                     CORRECT FOR FRACTIONAL HITS
        TRM = TRM  - WL - WH
        SUM = SUM  - WL*PH(NTRMLO) - WH*PH(IH)
        SUM2= SUM2 - WL*PH(NTRMLO)**2 - WH*PH(IH)**2
C                            CALCULATE MEAN AND SIGMA MEAN
      IF(TRM.LT.2) GO TO 99
      TRCM = SUM/TRM
        RMS = (SUM2 - TRM*TRCM**2)/(TRM-1.)
        RMS = RMS/TRM
        DTRC2 = ABS(RMS)
      DTRCM = SQRT(DTRC2)
      RETURN
C
   99 TRCM = 0.
      DTRCM = 0.
  100 CONTINUE
      RETURN
      END
C   20/05/87 702061751  MEMBER NAME  IPCALF   (S)           FORTRAN
C     *********************
      FUNCTION IPCALF(NRUN)
C     *********************
      DIMENSION JNA(39)
      DATA JNA/ 2600, 3730, 6000, 6850, 7170, 7592, 7840, 8120, 8375,
     #    8850, 9188, 9464,10000,10391,10578,10761,11021,11331,11634,
     #   12004,12341,13088,14605,15690,16803,17989,19068,21123,21705,
     #   22651,23443,23798,24201,25454,26217,27000,27938,28444,99999/
      DATA IPRINT/1/
C***** FADC - DATEN FROM RUN 24201 (IP>33) *****
C---
      IPCALF = 1
      DO 1000 I=1,39
        IF(NRUN.GE.JNA(I)) IPCALF=I+1
1000  CONTINUE
C---
      IPRINT = IPRINT + 1
      IF(IPRINT.LE.1) PRINT 900
      IF(IPCALF.GT.33 .AND. IPRINT.LE.1) PRINT 902,IPCALF
 900  FORMAT(1X,'########## IPCALF   05/05/1987   F11AMB.ANAL.L')
 902  FORMAT(1X,'********** IPCALF:  PER=',I2
     #         ,': FADC - DATA')
C---
      RETURN
      END
C   26/09/83 704081242  MEMBER NAME  AHIFTL   (S)           FORTRAN
C     **********************************************************
      SUBROUTINE AHIFTL(X0,SIGX,Y0,SIGY,FITFCN,EPS,XB,YB,CHISQR)
C     **********************************************************
C  LAST CHANGE: 18.10.86   K.AMBRUS
C-----------------------------------------------------------------------
C
C        FINDS THE 'BEST' POINT (XB,YB) ON THE CURVE
C        Y=FITFCN(X), GIVEN THE INDEPENDENTLY MEASURED VALUES
C        X0 AND Y0, WITH STANDARD DEVIATIONS SIGX AND SIGY.
C
C        THE 'BEST' POINT IS THE POINT WHICH MINIMIZES CISQUARE,
C        GIVEN BY  CHISQ = ((X0-XB)/SIGX)**2 + ((Y0-YB)/SIGY)**2 .
C
C        THE ITERATION STOPS WHEN THE VALUES OF CHISQ FROM TWO CON-
C        SECUTIVE ITERATIONS DIFFER BY LESS THAN CHISQ*EPS,
C        OR WHEN THE NUMBER OF ITERATIONS REACHES ITRMAX (SET IN
C        DATA STATEMENT).
C
C        IF INPUT PARAMETERS ARE HOPELESS, NO FIT IS ATTEMPTED, AND
C        CHISQR IS SET TO 1.0E30.
C                                                  J.A.J.SKARD, 14/8/83
C-----------------------------------------------------------------------
C        COMMON FOR FITFCN
      COMMON /CODEDX/PAR(15),NPAR
      EXTERNAL FITFCN
C        MAX ITERATIONS
      DATA ITRMAX/10/
C        STEP SIZE IN X (FRACTION OF SIGX)
      DATA FACSTP/1.0/
C        STEP SIZE REDUCTION FACTOR FOR SUCCESSIVE ITERATIONS
      DATA FACRED/0.1/
C        LIMIT FOR PRINTOUT OF DIAGNOSTICS
      DATA IPRMAX/10/,IPR/0/
C        DEFINE CISQUARE AS AN INTERNAL STATEMENT FUNCTION
C****    NOTE: LOGARITHMIC X-SCALE IS USED
CH 18/10/86      CHISQ(X)=(X0-EXP(X))**2*HX+(Y0-FITFCN(EXP(X)))**2*HY
      CHISQ(X)=(X0-X)**2*HX+(Y0-FITFCN(X))**2*HY
C        GUARD AGAINST SOME OBVIOUS DISASTERS...
CH 18/10/86      IF(X0.LE.1.E-15)GO TO 10
      IF(Y0-FITFCN(X0).LT.SIGY*1.E15.AND.SIGX.GT.1.E-15)GO TO 1
   10 IPR=IPR+1
      IF(IPR-IPRMAX)2,3,4
    2 CONTINUE
CCC 2 WRITE(6,997)X0,SIGX,Y0,SIGY
  997 FORMAT(' *** AHIFTL: HOPELESS PARAMETERS. NO FIT ***',/,
     * 13X,'X0,SIGX,Y0,SIGY:',4E12.4)
      GO TO 4
    3 CONTINUE
CCC 3 WRITE(6,998)
    4 XB=X0
      YB=Y0
      CHISQR=1.E30
      GO TO 100
C        PARAMETERS ARE NOT UTTERLY HOPELESS - TRY FITTING
    1 HX=1./(SIGX*SIGX)
      HY=1./(SIGY*SIGY)
CH 18/10/86        CHANGE TO LOGARITHMIC X-SCALE
CH 18/10/86      X=ALOG(X0)
       X= X0
C     DELX=AMIN1(FACSTP*SIGX/X0,10.)   MOD 26/11/87  E ELSEN
      DELX=AMIN1(FACSTP*SIGX,10.)
      CHIM1=CHISQ(X)
      ITER=0
   11 CHI1=CHIM1
   41 ITER=ITER+1
      IF(ITER.LT.ITRMAX)GO TO 4141
      GO TO 8383
4141  X=X+DELX
      CHI2=CHISQ(X)
C        CHECK IF WE STARTED OUT IN THE RIGHT DIRECTION
      IF(CHI1-CHI2)51,41,61
C        WE DID NOT. REVERSE DIRECTION.
   51 DELX=-DELX
      X=X+DELX
      SAVE=CHI1
      CHI1=CHI2
      CHI2=SAVE
C        KEEP STEPPING ALONG...
   61 X=X+DELX
      CHI3=CHISQ(X)
C        CHECK NEW CHISQUARE
      IF(CHI3-CHI2)71,81,81
C        STILL DECREASING, ONE MORE STEP..
   71 CHI1=CHI2
      CHI2=CHI3
      GO TO 61
C        FIND MINIMUM OF PARABOLA DEFINED BY LAST THREE POINTS
   81 X=X-DELX*((CHI3-CHI2)/(CHI3-2.*CHI2+CHI1)+0.5)
      CHIM2=CHISQ(X)
C        ARE WE NEAR ENOUGH?
      IF(ABS(CHIM2-CHIM1).LT.CHIM1*EPS)GO TO 91
C        NOT YET - CHECK LIMIT OF ITERATIONS
      IF(ITER.LT.ITRMAX)GO TO 85
C        LIMIT OF ITERATIONS REACHED
 8383 IPR=IPR+1
      IF(IPR-IPRMAX)82,83,91
   82 CONTINUE
CCC82 WRITE(6,999)ITRMAX
  999 FORMAT(' *** AHIFTL: LIMIT OF',I4,' ITERATIONS REACHED, FIT STOPPE
     *D ***')
      GO TO 91
   83 CONTINUE
CCC83 WRITE(6,998)
  998 FORMAT(' *** AHIFTL: DIAGNOSTICS TURNED OFF, LIMIT REACHED ***')
      GO TO 91
C        RESET PARAMETERS AND DO IT AGAIN
   85 CHIM1=CHIM2
C        REDUCE STEP SIZE
      DELX=DELX*FACRED
      GO TO 11
C        GOOD ENOUGH - TIDY UP AND QUIT
   91 CHISQR=CHISQ(X)
CH 18/10/86      XB=EXP(X)
      XB=X
      YB=FITFCN(XB)
  100 RETURN
      END
C   05/11/82 501111759  MEMBER NAME  DECHIF   (S)           FORTRAN
C     ************************************************************
      SUBROUTINE AECHIL(P,SIGP,DE,SIGDE,FMASS,PBEST,DEBEST,CHISQR)
C     ************************************************************
C
C        CALCULATES CHI SQUARE AND BEST POINT (PBEST,DEBEST) ON
C        THEORETICAL DE/DX-CURVE, DEFINED BY THE FUNCTION AETHRL.
C        THUS DEBEST=AETHRL(PBEST). THE BEST POINT IS CHOSEN TO MINIMIZE
C        THE CHI SQUARE DEVIATION FOR THE POINT (LN(P),LN(DE)),
C        MEASURED WITH
C        ACCURACIES GIVEN BY THE STANDARD DEVIATIONS SIGP AND SIGDE.
C        THE THEORETICAL CURVE IS FOR PIONS, OTHER PARTICLES GET THEIR
C        MOMENTA SCALED TO THE SAME BETA BEFORE THE FIT
C
C                                                 J.A.J.SKARD, 14/8/83
C                                           COPIED:  K.AMBRUS, 24/1/84
C
       EXTERNAL AETHRL
C       REQUIRED ACCURACY OF MINIMUM CHI SQUARE IS AMAX1(CHISQR*EPS,EPS)
       DATA EPS/0.01/
       DATA IPRINT/5/
       SCAFAC=0.1395669/FMASS
       PP=P*SCAFAC
       SIGPP=SIGP*SCAFAC
C-----
        PBEST = 0.
        DEBEST = 0.
        CHISQR = 1.E20
        IF(P.LE.0. .OR. DE.LE.0.) GO TO 9999
        IF(SIGP.LE.0. .AND. SIGDE.LE.0.)  GO TO 9999
C-----                     LOGARITHMIC SCALE
          PL  = ALOG(PP)
          SPL = SIGPP/PP
          EL  = ALOG(DE)
          SEL = SIGDE/DE
C-----
        CALL AHIFTL(PL,SPL,EL,SEL,AETHRL,EPS,PLB,ELB,CHISQR)
C-----                    LINEAR SCALE
            IF(PLB.GT.170.) PLB = 170.
            IF(ELB.GT.170.) ELB = 170.
          PBEST  =  EXP(PLB)/SCAFAC
          DEBEST =  EXP(ELB)
 9999  CONTINUE
C########## TEST
       IF(IPRINT.LT.5) PRINT 910,P,SIGP,DE,SIGDE,FMASS
       IF(IPRINT.LT.5) PRINT 920,PBEST,DEBEST,CHISQR
       IPRINT = IPRINT + 1
  910 FORMAT(1X,'###TEST### AECHIL:',2F10.4,2X,2F10.4,2X,2F10.4)
  920 FORMAT(1X,'--RESULT-- AECHIL:',F10.4,12X,F10.4,12X,F10.4)
C###############
       RETURN
       END
C      *********************
       FUNCTION AETHRL(PL0)
C      *********************
C
C           RETURNS 'THEORETICAL' VALUE OF JADE DEDX FOR GIVEN
C        MOMENTUM BASED ON EMPIRICAL ADJUSTMENT TO THE DATA
C
      DATA  PIMAS,CHARGE / 0.1395669,1.000 /
          PL = PL0
          IF(PL.LT.-7.) PL =  -7.
          IF(PL.GT. 7.) PL =   7.
        P = EXP(PL)
      AETHRL=DEDXTP(P,PIMAS,CHARGE)
      AETHRL=ALOG(AETHRL)
      RETURN
       END
C   06/04/86 611231616  MEMBER NAME  DEDXTP   (S)           FORTRAN
C     ***********************************
      FUNCTION DEDXTP(PTOT,XMASS,CHARGE)
C     ***********************************
C ---------------------------------------------------------------------
C
C        CALCULATE THEORETICAL VALUE FOR DEDX
C
C        AEDXTP = DEDXTP( P , M , Q )
C
C        1/B**2- AND RERISE-REGION  ADJUSTED TO OBSERVATION
C        STERNHEIMER PARAMETERISATION OF DE/DX AS FUNCTION OF BETA
C
C        INPUT : PTOT  = P
C                XMASS  = M
C                CHARGE = Q
C
C        OUTPUT: AEDXTP = DE/DX  AT GIVEN VALUE OF P , M , Q
C
C        CHANGED: K. AMBRUS  07.04.1986
C ---------------------------------------------------------------------
C     BHABHAS ARE SET TO 10 KEV/CM
C     DEMIN  = EXPERIMENTAL VALUE FOR DE/DX IN MINIMUM
C     PARK   = ADJUST 1/B**2 - REGION
C     AA     = ADJUST RERISE - REGION
C
C ---------------------------------------------------------------------
      DATA IPRINT/0/
      DATA   DEMIN ,  PARK  ,   AA    , BGMIN
     #    / 6.9754 , 13.848 , 0.25981 , 3.96  /
      DATA ALFAT,X0,XA,X1,CC/5*0./
C---------------------------- CALCULATE PARAMETER
C                             INPUT: DEMIN,PARK,AA,BGMIN
      IF(IPRINT.LE.0) CALL AARSET(DEMIN,ALFAT,PARK,X0,XA,X1,AA,CC,BGMIN)
      IPRINT = IPRINT + 1
      IF(IPRINT.EQ.0) PRINT 910
 910  FORMAT(' ########## DEDXTP:  04/05/1986  F11AMB.ANAL.L')
C---------------------------
      CHARG2 = CHARGE*CHARGE
         IF(CHARG2.LE.0.) CHARG2 = 1.
      IF(PTOT.LE.0.) GO TO 9999
       BETAG = 0.
       IF(XMASS.GT.0.) BETAG=PTOT/XMASS
       IF(BETAG.LE.0.01) GO TO 9999
       IF(BETAG.GT.1.E6) BETAG = 1.E6
      BG2 = BETAG*BETAG
      BB = BG2/(1.+BG2)
C-
        X=PARK+ALOG(CHARG2)+ALOG(BG2+1.)-BB-AENSC(BETAG,X0,XA,X1,AA,CC)
       DEDXTP=X*CHARG2*ALFAT/BB
      RETURN
C-
9999  CONTINUE
      DEDXTP = 1.E10
      RETURN
      END
C
C     *********************
      FUNCTION AENSC(BETAG,X0,XA,X1,AA,CC)
C     *********************
      COMMON /COMFIT/APCCO,PQCO,PPCO,P1CO,P2CO,P3CO,X1CO,XFCO
C
        X=ALOG10(BETAG)
        AENSC=0.
      IF(X.LE.X0) RETURN
        AENSC=CC*(X-XA)
      IF(X.GE.X1) RETURN
        AENSC=AENSC+AA*(X1-X)**3.
      RETURN
      END
C     ******************************************
      SUBROUTINE AARSET(EXMI,AL,AK,X0,XA,X1,AA,CC,BGMIN)
C     ******************************************
C     SET PARAMETER - VALUES: AL,X0,XA,X1,CC
C                      INPUT: EXMI,AK,AA,BGMIN
      DATA EXPL / 10. /
        CC  = 2.*ALOG(10.)
        BG2 = BGMIN*BGMIN
        BB = BG2/(BG2+1.)
C=====                                        CALCULATION OF AL
          FM = AK + ALOG(BG2+1.) - BB
      AL = EXMI*BB/FM
C-----                                         CALCULATION OF XA,X0,X1
      XA = (EXPL*FM/(BB*EXMI) - AK + 1.)/CC
          X10 = CC/(3.*AA)
          X10 = SQRT(X10)
      X0  = XA  -  X10**3 * AA/CC
      X1  = X10 +  X0
C=====
C     RE  = EXPL/EXMI
C     PRINT 900,EXMI,RE,AL,AK,BGMIN,AA,X0,XA,X1
  900 FORMAT(3X,'********* DEDXTP  - PARAMETER (04/05/86) **********'/
     #       3X,'        INPUT: EXMIN,AK,AA (BGM ADJUSTED)  '/
     #       3X,'  EXMI=',F10.5,'   RE=',F10.5,' ALFA=',F10.5/
     #       3X,'     K=',F10.5,'  BGM=',F10.5,'   AA=',F10.5/
     #       3X,'    X0=',F10.5,'   XA=',F10.5,'   X1=',F10.5/
     #       3X,'**************************************************'//)
C
      RETURN
      END
C   07/12/85 706032030  MEMBER NAME  ERDEDX   (S)           FORTRAN
C   07/12/85 609221253  MEMBER NAME  ERDEDX   (S)           FORTRAN
C     *****************************
      FUNCTION ERDEDX(E,SE,NRUN,NHITEX)
C     *****************************
C     CALCULATES SYSTEMATIC DE/DX-ERROR
C     KONSTANTS FOR DIFFERENT RUN-PERIODES AND EVENT-CLASSES ARE
C       ARE ADJUSTED TO MULTIHADRON DATA.
C
C     INPUT :  E      DEDX
C              SE     VARIANCE OF TRUNCATED MEAN E (5%-70%)
C              NRUN   RUN
C              NHITEX NUMBER OF DE/DX-HITS
C     OUTPUT:  ERDEDX DE/DX-ERROR
C-----
      DIMENSION ASYS(39)
      DATA ERRFAC/1.564/
CC-----
C     DATA ASMC / 0.320 /
      DATA IPRINT/1/
      DATA ASYS/0.346,0.344,0.344,0.330,0.312,0.326,0.296,0.326,0.322,
     #    0.304,0.326,0.312,0.315,0.309,0.327,0.299,0.311,0.324,0.327,
     #    0.302,0.319,0.340,0.328,0.343,0.388,0.341,0.354,0.369,0.385,
     #    0.365,0.391,0.373,0.384,0.398,0.393,0.374,0.376,0.377,0.385/
C-----
      IPRINT = IPRINT + 1
      IF(IPRINT.EQ.1) PRINT 901
 901  FORMAT(' ########## ERDEDX:  03/06/1987  F11AMB.ANAL.L ')
C-----
      ERDEDX = 0.
CHANGED:      IF(SE.LE.0. .OR. NHITEX.LE.0) GO TO 9999
      IF(NHITEX.LE.0) GO TO 9999
C-----                                                   GET RUN-PERIODE
      IPER = IPCALF(NRUN)
C-----
      IF(IPRINT.EQ.1) PRINT 902,IPER,ASYS(IPER)
 902  FORMAT(' ########## ERDEDX: IPER =',I5,3X,' ASYS =',F7.3)
C-----
CHANGED:        STA  =  E * ASMC/SQRT(XN)
        STA  =  SE*ERRFAC
        SYS1  =  E * ASYS(IPER)
      ERDEDX = SQRT(STA*STA + SYS1*SYS1/NHITEX)
C
 9999 CONTINUE
      RETURN
      END
C   04/06/87 706040241  MEMBER NAME  CALEX    (S)           FORTRAN
C   04/06/87 706040235  MEMBER NAME  CADEDX   (S)           FORTRAN
C     *********************************
      FUNCTION CALEX(NR,PTOT0,C0,Q0,EX0)
C     *********************************
C ----------------------------------- LAST CHANGE: 21/02/86  K.AMBRUS
C     BHABHA - DE/DX - CALIBRATION - FUNCTION
C ---------------------------------------------------------------------
         DIMENSION AA(5,39)
         DIMENSION APPQ(39),APP1(39),APP2(39)
         DIMENSION AP2(39),AP4(39),AP5(39)
      DATA IPRINT/ 1 /
C----- BHABHA - COS(THETA) - CORRECTION (03/06/87)
      DATA AA/ 1.0071,-0.052, 0.305,0.36,-0.84,
     2 0.9876,-0.063,0.437,1.59, 0.96,  0.9925,-0.050,0.451,1.27, 0.46,
     4 0.9896,-0.066,0.432,0.93, 0.07,  0.9810,-0.030,0.515,1.15, 0.31,
     6 0.9944,-0.059,0.257,0.42,-0.29,  0.9845, 0.008,0.420,0.66,-0.04,
     8 0.9856,-0.002,0.417,1.10, 0.70,  0.9878, 0.015,0.413,0.62,-0.12,
     * 0.9828, 0.021,0.391,0.61, 0.01,  0.9851, 0.036,0.416,0.99, 0.54,
     2 0.9845, 0.026,0.456,1.41, 1.03,  0.9855, 0.044,0.490,1.02, 0.21,
     4 0.9836, 0.020,0.474,0.87, 0.25,  0.9849, 0.008,0.492,1.07, 0.44,
     6 0.9837, 0.031,0.510,0.71,-0.25,  0.9823, 0.027,0.490,0.65,-0.31,
     8 0.9824,-0.040,0.262,0.68, 0.10,  0.9948,-0.025,0.347,0.44,-0.46,
     * 0.9974,-0.099,0.426,1.96, 1.71,  0.9934,-0.074,0.369,1.18, 0.56,
     2 0.9876,-0.072,0.477,0.97, 0.08,  0.9794,-0.031,0.539,0.99,-0.11,
     4 0.9722, 0.004,0.628,1.18, 0.39,  0.9767,-0.025,0.468,0.96, 0.25,
     6 0.9745,-0.061,0.580,1.50, 0.70,  0.9896,-0.044,0.283,0.34,-0.63,
     8 0.9465,-0.105,0.577,2.05, 1.26,  0.9527,-0.035,0.425,0.80, 0.07,
     * 0.9331,-0.003,0.565,1.71, 1.27,  0.9432,-0.081,0.756,2.36, 1.53,
     2 0.9537,-0.085,0.607,1.80, 1.02,  0.9543,-0.108,0.704,2.21, 1.24,
     3 0.9672,-0.079,0.463,1.64, 1.16,  0.9563,-0.015,0.533,1.18, 0.38,
     4 0.9589,-0.011,0.480,0.77,-0.15,  0.9589,-0.030,0.503,1.39, 0.75,
     8 0.9585,-0.051,0.537,1.41, 0.61,  0.9611,-0.038,0.385,0.97, 0.31/
C----- CHARGE- MOMENTUM - CORRECTION (03/06/87)
      DATA APPQ/ 0.00410,  0.00535,  0.00517,  0.00319,
     * 0.00561,  0.00393,  0.00364,  0.00327,  0.00369,
     1 0.00200,  0.00284,  0.00339,  0.00389,  0.00554,
     1 0.00387,  0.00291,  0.00407,  0.00638,  0.00599,
     2 0.00320,  0.00501,  0.00638,  0.00539,  0.00510,
     2 0.00597,  0.00937,  0.00134,  0.00836,  0.00781,
     3 0.00918,  0.00554,  0.00865,  0.00792,  0.01319,
     3 0.01216,  0.00773,  0.00787,  0.01058,  0.01143/
C-
      DATA APP1/-0.00082, -0.00509, -0.00552,  0.00127,
     * 0.00384,  0.00270,  0.00227,  0.00062,  0.00327,
     1 0.00020,  0.00267,  0.00267,  0.00316,  0.00317,
     1 0.00261,  0.00246,  0.00143,  0.00228,  0.00285,
     2 0.00426,  0.00534,  0.00645,  0.00515,  0.00366,
     2 0.00211,  0.00613, -0.00281,  0.00515,  0.00607,
     3 0.00387,  0.00319,  0.00425,  0.00579,  0.00706,
     3 0.00831,  0.00711,  0.00779,  0.00703,  0.00827/
C-
      DATA APP2/  0.000033, 0.000158, 0.000396,-0.000192,
     * -0.000240,-0.000201,-0.000115, 0.000075,-0.000133,
     1  0.000024,-0.000042,-0.000148,-0.000103,-0.000237,
     1 -0.000128,-0.000195,-0.000173,-0.000108,-0.000167,
     2 -0.000236,-0.000278,-0.000391,-0.000322,-0.000087,
     2 -0.000042,-0.000282, 0.000259,-0.000274,-0.000323,
     3 -0.000218,-0.000142,-0.000049,-0.000333,-0.000418,
     3 -0.000389,-0.000361,-0.000451,-0.000404,-0.000466/
C----- SATURATION (03/06/87)
      DATA AP1/ 8.11/
C-
      DATA AP2/ .138, .114, .118, .117, .115, .126, .114, .093, .104,
     1    .115, .110, .118, .134, .102, .103, .108, .099, .105, .095,
     2    .087, .074, .084, .092, .078, .061, .073, .056, .077, .071,
     3    .088, .089, .086, .055, .031, .058, .032, .034, .026, .052/
C-
      DATA AP3/ 55.0/
C-
      DATA AP4/4.765,5.691,6.139,1.802,1.146,1.450,1.947,2.581,2.212,
     1   2.336,2.935,3.665,3.303,1.730,2.045,1.482,1.972,2.742,2.220,
     2   2.493,2.185,1.481,1.149,1.000,1.134,1.140,1.116,0.914,1.080,
     3   1.048,0.711,1.146,1.251,4.816,3.591,3.754,4.758,4.865,3.696/
C-
      DATA AP5/ 33*0.961,6*0.890 /
C===== RUN - PERIODE
      IP = IPCALF(NR)
      IPRINT = IPRINT + 1
      IF(IPRINT.EQ.1) PRINT 900
 900  FORMAT(' ########## CALEX:  03/06/1987 ')
C ---------------------------------------------------------------------
      CALEX = 1.
      IF(NR.LE.0) GO TO 9999
       PTOT = PTOT0
       C = ABS(C0)
       C1= C
       IF(C.GT.1. .OR. PTOT.LE.1.E-10 .OR. EX0.LE.0.01)   GO TO 9999
       IF(C1.GT.0.99) C1 = 0.99
       IF(C.GT.0.83) C = 0.83
       IF(PTOT.LT.0.04) PTOT = 0.04
       CEX = 1.
C----- BHABHA - COS(THETA) - DEPENDANCE
         X = C - 0.6
        Z = 1.+AA(2,IP)*X+AA(3,IP)*X*X+AA(4,IP)*X**3+AA(5,IP)*X**4
        Z = Z*AA(1,IP)
      CEX =CEX / Z
C----- Q - DEPENDANCE (ONLY POS. PARTICLES)
         P = 0.
         IF(Q0.GT.0.) P = APPQ(IP)
      CEX = CEX / ( 1. + P/PTOT )
C----- P - CALIBRATION FOR LOW MOMENTA (ALL. PARTICLES)
      CEX = CEX * (1. + APP1(IP)/PTOT + APP2(IP)/PTOT**2)
C----- SATURATION
         EX = EX0*CEX
       CEX = CEX*(1. + AP2(IP)*(SQRT(EX)-SQRT(10.))*EXP(-AP1*C))
         EX = EX0*CEX
       CEX=CEX * (  1.
     #         + AP4(IP) * (EXP(0.01*AP5(IP)*EX)-1.)
     #         * EXP(-AP3/EX) )
       CEX=CEX / (  1.
     #         + AP4(IP) * (0.1*EXP(AP5(IP))-1.)
     #         * EXP(-AP3*0.1) )
C----- LN(D) - DEPENDANCE (ASSUMING BETA = Q = 1)
         EX = EX0*CEX
         D  = 1./SQRT(1.-C1*C1)
       CEX = CEX*(1. - 0.417*ALOG(D)/EX)
C-----
      CALEX = CEX
C-----
 9999 CONTINUE
      IF(IPRINT.LE.1) PRINT 901,IP,(AA(K,IP),K=1,5)
     #   ,APPQ(IP),APP1(IP),APP2(IP),AP1,AP2(IP),AP3,AP4(IP)
     #   ,AP5(IP)
 912  FORMAT(5X,6F10.3)
  901 FORMAT(3X,'**********  CALEX  - PARAMETER (03/06/87) ********'/
     #       3X,'                 PERIODE  ',I3/
     #       3X,'  AA =',5F10.5/
     #       3X,'  PQ =',F10.5,' PP1 =',F10.5,' PP2 =',F10.5/
     #       3X,'  P1 =',F10.5,'  P2 =',F10.5/
     #       3X,'  P3 =',F10.5,'  P4 =',F10.5/
     #       3X,'  P5 =',F10.5,'  P6 =',F10.5/
     #       3X,'**************************************************'//)
C     IF(IPRINT.LE.1) PRINT 902,EX,CEX
      RETURN
      END
C   09/06/88 806091351  MEMBER NAME  DEDXCS   (S)        M  FORTRAN77
      FUNCTION DEDXCS( WIRE, COSTH, PERIOD )
C-----------------------------------------------------------
C  Version of 09/06/88     E Elsen
C  Last Mod   09/06/88
C  Correction factors for slope effect.
C  Input:    WIRE      0<wire<1535
C            COSTH     cos(theta) of track
C            PERIOD    dE/dx Calibration period
C-----------------------------------------------------------
      INTEGER WIRE, PERIOD
C                  Cell wise correction factors.
C                  Values < -0.02 have been set to cell averages:
C                   0.0899, 0.0878, 0.0106, 0.0299
      REAL DEXCOS(0:95) /
     * 0.1179, 0.0982, 0.0899, 0.1322, 0.0863, 0.0582, 0.1261, 0.1272,
     * 0.0958, 0.1541, 0.1205, 0.1279, 0.1228, 0.0776, 0.1258, 0.1148,
     * 0.0173, 0.0241, 0.0429, 0.0896, 0.0657, 0.1041, 0.0971, 0.0767,
     * 0.1097, 0.1140, 0.1763, 0.1864, 0.1879, 0.1019, 0.2336, 0.1177,
     * 0.1074, 0.1890, 0.0979, 0.1314, 0.0680, 0.0861, 0.0460,-0.0016,
     * 0.0878,-0.0001,-0.0055, 0.0005, 0.0127, 0.0714, 0.0277, 0.0848,
     * 0.0858, 0.0618, 0.0781, 0.0041, 0.0229, 0.0883, 0.1102, 0.0863,
     * 0.0739, 0.0248, 0.0229, 0.0034, 0.0746, 0.0326, 0.0158, 0.0551,
     *-0.0090,-0.0106, 0.0661, 0.0274, 0.0164, 0.0565, 0.0615, 0.0236,
     * 0.0138, 0.0151, 0.0096, 0.0106, 0.0175,-0.0091, 0.0229, 0.0034,
     * 0.0229,-0.0066, 0.0734, 0.0106,-0.0159, 0.0106, 0.0336,-0.0102,
     * 0.0236,-0.0117,-0.0095, 0.0076, 0.0892, 0.0106, 0.0286, 0.0445/
C
      IF( PERIOD.GT.11 .AND. PERIOD.LT.21 ) THEN
        IF( PERIOD.GT.14 ) THEN
          DEDXCS = 1./ ( 1. + DEXCOS(WIRE/16)*COSTH )
        ELSE
          DEDXCS = 1./ ( 1. + DEXCOS(WIRE/16)*COSTH*(PERIOD-11)/4.)
        ENDIF
      ELSE
        DEDXCS = 1.
      ENDIF
      END