C   12/12/83 501241436  MEMBER NAME  LUDECYSP (S)           FORTRAN77
      SUBROUTINE LUDECY(IP)
C-----------------------------------------------------------
C   LAST MOD 24/01/85  E ELSEN
C   VERSION TO FORCE SEMILEPTONIC DECAYS OF ONE QUARK BRANCH
C-----------------------------------------------------------
C
C
C     ROUTINE CHANGED BY A. PETERSEN TO INCLUED DECAY VERTEX AND CODING
C     CH:310,12310,16120,16130,16140,16160,16170,16810
C     11710-11750
C
      COMMON /LUJETS/ N,K(250,2),P(250,5)
       COMMON /LUJET1/ JB(250),VERTX(250,4)
      COMMON /LUDAT1/ MST(20),PAR(20),FPAR(40)
      COMMON /LUDAT2/ KTYP(120),PMAS(120),PWID(60),KFR(80),CFR(40)
      COMMON /LUDAT3/ DPAR(20),IDB(120),CBR(300),KDP(1200)
      DIMENSION IFLO(4),IFL1(4),PV(10,5),RORD(10),U(3),BE(3)
C
      COMMON / CRDLUD / LDPRM(8)
      LOGICAL FIRST /.TRUE./

C...FUNCTIONS : MOMENTUM IN TWO-PARTICLE DECAYS AND FOUR-PRODUCT
      PAWT(A,B,C)=SQRT((A**2-(B+C)**2)*(A**2-(B-C)**2))/(2.*A)
      FOUR(I,J)=P(I,4)*P(J,4)-P(I,1)*P(J,1)-P(I,2)*P(J,2)-P(I,3)*P(J,3)

      IF( FIRST ) THEN
         FIRST = .FALSE.
         READ(5,9101) LDPRM
 9101    FORMAT(20X,8I3)
         DO 10 I=1,8
            IF( IABS(LDPRM(I)).GT.1 ) LDPRM(I)=LDPRM(I)/IABS(LDPRM(I))
   10    CONTINUE
         WRITE(6,9102) LDPRM
 9102    FORMAT(' -----------------------------------------------'/
     *          ' | LUDECY: SPECIAL VERSION                     |'/
     *          ' |         FORCING SEMIELECTRONIC DECAY OF     |'/
     *          ' |         PRIMARY QUARKS                      |'/
     *          ' |         LDPRM:',8I3,6X,'|'/
     *          ' -----------------------------------------------')
      ENDIF
      IDLOOP = 0
C
C
C...CHOOSE DECAY CHANNEL
      KFA=IABS(K(IP,2))
      KFS=ISIGN(1,K(IP,2))
  100 RBR=RANF(0)
      IF(KFA.LE.100) THEN
      IDC=IDB(KFA)-1
      ELSE
      CALL LUIFLV(KFA,IFLA,IFLB,IFLC,KSP)
      IDC=IDB(76+5*IFLA+KSP)-1
      ENDIF
  110 IDC=IDC+1
      IF(RBR.GT.CBR(IDC)) GOTO 110


C
C                                 Modification for semielectronic decays
      KFF = K(IP,2)*LDPRM(5)
      IF( LDPRM(5).EQ.0  .OR.
     *    ( (101 .GT. KFF .OR. KFF .GT. 104) .AND.
     *      (145 .GT. KFF .OR. KFF .GT. 158) .AND.
     *      (241 .GT. KFF .OR. KFF .GT. 246) .AND.
     *      (293 .GT. KFF .OR. KFF .GT. 307)
     *  ) )  GOTO 10021
         IDLOOP = IDLOOP + 1
         IF(IDLOOP .GT. 2) THEN
            WRITE(6,4774) IDLOOP, IP, KFA, IDB(KFA)
4774        FORMAT(' LOOP CONDITION IN LUDECY'/  ' IDLOOP=',I3,
     *             ' IP=',I4,'KFA=',I4,'IDB(KFA)=',I4)
         ELSE
            IDC=IDB(76+5*IFLA+KSP)
         ENDIF
      GOTO10011
C
10021 KFF = K(IP,2)*LDPRM(4)
      IF( LDPRM(4).EQ.0  .OR.
     *    ( ( 20 .GT. KFF .OR. KFF .GT.  22) .AND.
     *      ( 53 .GT. KFF .OR. KFF .GT.  56) .AND.
     *      ( 58 .GT. KFF .OR. KFF .GT.  60) .AND.
     *      ( 80 .NE. KFF)
     *  ) )    GOTO 10061
         IDLOOP = IDLOOP + 1
         IF(IDLOOP .GT. 2) THEN
            WRITE(6,4774) IDLOOP, IP, KFA, IDB(KFA)
         ELSE
            IDC = IDB(KFA)
         ENDIF
10061 CONTINUE
10011 CONTINUE

C...START READOUT OF DECAY CHANNEL: MATRIX ELEMENT, RESET COUNTERS
      MMAT=IABS(KDP(4*IDC-3))/1000
  120 I=N
      NP=0
      NQ=0
      PS=0.
      PSQ=0.

      DO 130 I1=4*IDC-3,4*IDC
C...READ OUT DECAY PRODUCT, CONVERT TO STANDARD FLAVOUR CODE
      KP=MOD(KDP(I1),1000)
      IF(KP.EQ.0) GOTO 130
      IF(IABS(KP).LE.100) THEN
      KFP=KFS*KP
      IF(KTYP(IABS(KP)).EQ.0) KFP=KP
      ELSEIF(IABS(KP).LT.590) THEN
      KFP=KFS*KP
      IF(KP.EQ.500) KFP=KP
      ELSEIF(IABS(KP).EQ.590) THEN
      IF(KSP.LE.1) KFP=KFS*(-500+IFLB)
      IF(KSP.EQ.3) KFP=KFS*(500+10*IFLC+IFLB)
      IF(KSP.EQ.2.OR.KSP.EQ.4) KFP=KFS*(500+10*IFLB+IFLC)
      ELSEIF(IABS(KP).EQ.591) THEN
      CALL LUIFLD(-KFS*INT(1.+(2.+PAR(2))*RANF(0)),0,0,KFP,KDUMP)
      IF(FPAR(2)+2.*ULMASS(2,KFP).GT.P(IP,5)) GOTO 120
      KFP=KFP+ISIGN(500,KFP)
      ELSEIF(IABS(KP).EQ.592) THEN
      KFP=-KFP
      ENDIF

C...ADD DECAY PRODUCT TO EVENT RECORD OR TO IFLO LIST
      IF(IABS(KFP).LT.500.OR.MMAT.EQ.0.OR.MMAT.EQ.4) THEN
      I=I+1
      NP=NP+1
      IF(IABS(KFP).GE.500) NQ=NQ+1
      K(I,1)=IP+1000*(NQ-2*(NQ/2))
      K(I,2)=KFP
      P(I,5)=ULMASS(1,KFP)
      PS=PS+P(I,5)
      ELSE
      NQ=NQ+1
      IFLO(NQ)=MOD(KFP,500)
      PSQ=PSQ+ULMASS(3,IFLO(NQ))
      ENDIF
  130 CONTINUE

      IF(NQ.NE.0.AND.(MMAT.EQ.2.OR.MMAT.EQ.3)) THEN
C...CHOOSE DECAY MULTIPLICITY IN PHASE SPACE MODEL
      PSP=PS
      CNDE=DPAR(11)*ALOG(MAX((P(IP,5)-PS-PSQ)/DPAR(12),1.03))
      IF(KFA.EQ.26.OR.KFA.EQ.36.OR.(KFA.GE.83.AND.KFA.LE.90))
     &CNDE=CNDE+DPAR(13)
  140 GAUSS=SQRT(-2.*CNDE*ALOG(RANF(0)))*SIN(2.*PAR(20)*RANF(0))
      ND=0.5+0.5*NP+0.25*NQ+CNDE+GAUSS
      IF(MMAT.EQ.3) ND=3
      IF(ND.LT.NP+NQ/2.OR.ND.LT.2.OR.ND.GT.10) GOTO 140

C...FORM HADRONS FROM FLAVOUR CONTENT
      DO 150 JT=1,4
  150 IFL1(JT)=IFLO(JT)
      IF(ND.EQ.NP+NQ/2) GOTO 170
      DO 160 I=N+NP+1,N+ND-NQ/2
      JT=1+INT((NQ-1)*RANF(0))
      CALL LUIFLD(IFL1(JT),0,0,IFL2,K(I,2))
  160 IFL1(JT)=-IFL2
  170 JT=2+2*(NQ/4)*INT(RANF(0)+0.5)
      IF(MIN(IABS(IFL1(1)),IABS(IFL1(JT))).GT.10.OR.(NQ.EQ.4.AND.
     &MIN(IABS(IFL1(3)),IABS(IFL1(6-JT))).GT.10)) GOTO 140
      CALL LUIFLD(IFL1(1),0,IFL1(JT),IFLDMP,K(N+ND-NQ/2+1,2))
      IF(NQ.EQ.4) CALL LUIFLD(IFL1(3),0,IFL1(6-JT),IFLDMP,K(N+ND,2))

C...CHECK THAT SUM OF DECAY PRODUCT MASSES NOT TOO LARGE
      PS=PSP
      DO 180 I=N+NP+1,N+ND
      K(I,1)=IP
      P(I,5)=ULMASS(1,K(I,2))
  180 PS=PS+P(I,5)
      IF(PS+DPAR(14).GT.P(IP,5)) GOTO 140

      ELSEIF(MMAT.EQ.4.AND.NP.EQ.4) THEN
C...RESCALE ENERGY TO SUBTRACT OFF SPECTATOR QUARK MASS
      ND=3
      PS=PS-P(N+4,5)
      PQT=(P(N+4,5)+DPAR(15))/P(IP,5)
      DO 190 J=1,5
      P(N+4,J)=PQT*P(IP,J)
  190 P(IP,J)=(1.-PQT)*P(IP,J)

      ELSE
C...FULLY SPECIFIED FINAL STATES, CHECK MASS BROADENING EFFECTS
      IF(NP.GE.2.AND.PS+DPAR(14).GT.P(IP,5)) GOTO 120
      ND=NP
C
C                       PI0 AND ETA DALITZ DECAY
C FINAL STATE PARTICLES ARE FILLED INTO P(I,J) AND JB(I) IN PI0DK
        IF(MMAT.EQ.7) CALL PI0DK(IP,*380)
C
      ENDIF

      IF(ND.EQ.1) THEN
C...KINEMATICS OF ONE-PARTICLE DECAYS
      DO 200 J=1,4
C                                           MOD 23/1/85 E ELSEN
         VERTX(N+1,J) = VERTX(IP,J)
C                                           END MOD
  200 P(N+1,J)=P(IP,J)
        JB(N+1)=JB(IP)
      GOTO 380
      ENDIF

C...CALCULATE MAXIMUM WEIGHT ND-PARTICLE DECAY
      DO 210 J=1,5
  210 PV(1,J)=P(IP,J)
      PV(ND,5)=P(N+ND,5)
      IF(ND.EQ.2) GOTO 270
      WTMAX=1./DPAR(ND-2)
      PMAX=PV(1,5)-PS+P(N+ND,5)
      PMIN=0.
      DO 220 IL=ND-1,1,-1
      PMAX=PMAX+P(N+IL,5)
      PMIN=PMIN+P(N+IL+1,5)
  220 WTMAX=WTMAX*PAWT(PMAX,PMIN,P(N+IL,5))

C...M-GENERATOR GIVES WEIGHT, IF REJECTED TRY AGAIN
  230 RORD(1)=1.
      DO 250 IL1=2,ND-1
      RSAV=RANF(0)
      DO 240 IL2=IL1-1,1,-1
      IF(RSAV.LE.RORD(IL2)) GOTO 250
  240 RORD(IL2+1)=RORD(IL2)
  250 RORD(IL2+1)=RSAV
      RORD(ND)=0.
      WT=1.
      DO 260 IL=ND-1,1,-1
      PV(IL,5)=PV(IL+1,5)+P(N+IL,5)+(RORD(IL)-RORD(IL+1))*(P(IP,5)-PS)
  260 WT=WT*PAWT(PV(IL,5),PV(IL+1,5),P(N+IL,5))
      IF(WT.LT.RANF(0)*WTMAX) GOTO 230

C...PERFORM TWO-PARTICLE DECAYS IN RESPECTIVE CM FRAME
  270 DO 290 IL=1,ND-1
      PA=PAWT(PV(IL,5),PV(IL+1,5),P(N+IL,5))
      U(3)=2.*RANF(0)-1.
      PHI=2.*PAR(20)*RANF(0)
      U(1)=SQRT(1.-U(3)**2)*COS(PHI)
      U(2)=SQRT(1.-U(3)**2)*SIN(PHI)
        JB(N+IL)=JB(IP)
        VERTX(N+IL,4)=VERTX(IP,4)
        VERTX(N+IL+1,4)=VERTX(IP,4)
      DO 280 J=1,3
        VERTX(N+IL,J)=VERTX(IP,J)
        VERTX(N+IL+1,J)=VERTX(IP,J)
      P(N+IL,J)=PA*U(J)
  280 PV(IL+1,J)=-PA*U(J)
      P(N+IL,4)=SQRT(PA**2+P(N+IL,5)**2)
  290 PV(IL+1,4)=SQRT(PA**2+PV(IL+1,5)**2)

C...LORENTZ TRANSFORM DECAY PRODUCTS TO LAB FRAME
        JB(N+ND)=JB(IP)
      DO 300 J=1,4
  300 P(N+ND,J)=PV(ND,J)
      DO 330 IL=ND-1,1,-1
      DO 310 J=1,3
  310 BE(J)=PV(IL,J)/PV(IL,4)
      GA=PV(IL,4)/PV(IL,5)
      DO 330 I=N+IL,N+ND
      BEP=BE(1)*P(I,1)+BE(2)*P(I,2)+BE(3)*P(I,3)
      DO 320 J=1,3
  320 P(I,J)=P(I,J)+GA*(GA*BEP/(1.+GA)+P(I,4))*BE(J)
  330 P(I,4)=GA*(P(I,4)+BEP)

      IF(MMAT.EQ.1) THEN
C...MATRIX ELEMENTS FOR OMEGA AND PHI DECAYS
      WT=(P(N+1,5)*P(N+2,5)*P(N+3,5))**2-(P(N+1,5)*FOUR(N+2,N+3))**2
     &-(P(N+2,5)*FOUR(N+1,N+3))**2-(P(N+3,5)*FOUR(N+1,N+2))**2
     &+2.*FOUR(N+1,N+2)*FOUR(N+1,N+3)*FOUR(N+2,N+3)
      IF(MAX(WT*DPAR(9)/P(IP,5)**6,0.001).LT.RANF(0)) GOTO 230

      ELSEIF(MMAT.EQ.3.OR.MMAT.EQ.4) THEN
C...MATRIX ELEMENTS FOR WEAK DECAYS (ONLY SEMILEPTONIC FOR C AND B)
      WT=FOUR(IP,N+1)*FOUR(N+2,N+3)
      IF(WT.LT.RANF(0)*P(IP,5)**4/DPAR(10)) GOTO 230
      ENDIF

      IF(MMAT.EQ.4.AND.NP.EQ.4) THEN
C...SCALE BACK ENERGY, COLOUR REARRANGEMENT POSSIBLE FOR FOUR JETS
      DO 340 J=1,5
  340 P(IP,J)=P(IP,J)/(1.-PQT)
      IF(NQ.EQ.4.AND.RANF(0).LT.DPAR(16)) THEN
      KSAV=K(N+2,2)
      K(N+2,2)=K(N+3,2)
      K(N+3,2)=KSAV
      DO 350 J=1,5
      PSAV=P(N+2,J)
      P(N+2,J)=P(N+3,J)
  350 P(N+3,J)=PSAV
      ENDIF

C...LOW INVARIANT MASS FOR SYSTEM WITH SPECTATOR QUARK GIVES PARTICLE,
C...NOT TWO JETS, READJUST MOMENTA ACCORDINGLY
      IF(P(N+3,5)**2+P(N+4,5)**2+2.*FOUR(N+3,N+4).LE.(FPAR(2)+P(N+3,5)+
     &P(N+4,5)-DPAR(15))**2) THEN
      CALL LUIFLD(MOD(K(N+3,2),500),0,MOD(K(N+4,2),500),IFLDMP,K(N+3,2))
      P(N+3,5)=ULMASS(1,K(N+3,2))
      DO 360 J=1,3
  360 P(N+3,J)=P(N+3,J)+P(N+4,J)
      P(N+3,4)=SQRT(P(N+3,1)**2+P(N+3,2)**2+P(N+3,3)**2+P(N+3,5)**2)
      HA=P(N+1,4)**2-P(N+2,4)**2
      HB=HA-(P(N+1,5)**2-P(N+2,5)**2)
      HC=(P(N+1,1)-P(N+2,1))**2+(P(N+1,2)-P(N+2,2))**2+
     &(P(N+1,3)-P(N+2,3))**2
      HD=(P(IP,4)-P(N+3,4))**2
      HE=HA**2-2.*HD*(P(N+1,4)**2+P(N+2,4)**2)+HD**2
      HF=HD*HC-HB**2
      HG=HD*HC-HA*HB
      HH=(SQRT(HG**2+HE*HF)-HG)/(2.*HF)
      DO 370 J=1,3
      PCOR=HH*(P(N+1,J)-P(N+2,J))
      P(N+1,J)=P(N+1,J)+PCOR
  370 P(N+2,J)=P(N+2,J)-PCOR
      P(N+1,4)=SQRT(P(N+1,1)**2+P(N+1,2)**2+P(N+1,3)**2+P(N+1,5)**2)
      P(N+2,4)=SQRT(P(N+2,1)**2+P(N+2,2)**2+P(N+2,3)**2+P(N+2,5)**2)
      ELSE
      ND=4
      ENDIF
      ENDIF

C...ALSO CHECK INVARIANT MASS OF OTHER TWO JETS, START OVER IF TOO SMALL
      IF(MMAT.EQ.4.AND.IABS(K(N+1,2)).GE.500.AND.P(N+1,5)**2+P(N+2,5)
     &**2+2.*FOUR(N+1,N+2).LE.(FPAR(2)+P(N+1,5)+P(N+2,5))**2) GOTO 120
  380 N=N+ND

      K(IP,1)=K(IP,1)+2000
      RETURN
      END
