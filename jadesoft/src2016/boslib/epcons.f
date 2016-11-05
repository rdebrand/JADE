C   07/06/96 606071843  MEMBER NAME  EPCONS   (S4)          FORTG1
C   11/07/79 C9071201   MEMBER NAME  EPCONS   (QLIBS)       FORTRAN
      SUBROUTINE EPCONS(LPART,NPT,LBAEC,NBC,RELE,*)
C
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (IW(1),RW(1))
C     INPUT ARRAYS WITH NRS OF PART-BANKS AND NRS OF BAEC BANKS
      INTEGER LPART(32),LBAEC(32)
C     INTERNAL ARRAYS
      INTEGER LP(100),ICHARG(100)
      COMMON/HBLO/
     1     EP(64),VS(6),QU(3,12),QF(3,12),VR(6),VH(6),RSUM(4),R(4),D(12)
     2     ,DYM(24)
C
      EXTERNAL VECSUB
      COMMON/CONF1/NY,NF,V(1275),DELY(50),F(20),B(1000),PL(50),
     1   IEF,ND,CHSQ,PR,IDIAG,IUNPH
      COMMON P(10,200)
      INTEGER IP(10,100)
      EQUIVALENCE (IP(1,1),P(1,1))
C
C
C     PLEASE READ ALL COMMENT CARDS BEFORE USING
C
C     PLEASE CALL AT BEGIN . . .
C
C     CALL CONDIA(10,3,3)       IF OUTPUT OF 3 EVENTS FROM FITPGMWANTED
C
C     CALL CONDEF(10,30,10,10,0.0,0.1,0.1,1.0)  FOR ADJUSTMENT OF
C                                               CONSTANTS
C
C     . . . AND AT JOB END
C     CALL CONSTA               FOR FINAL STAISTIC PRINTOUT
C
C     IMEYER = 0    NO ANGLE CORRECTION
C     IMEYER = 1    Z AVERAGING AND ANGLE CORRECTION
C     GEM WUNSCH HJD AM 19.07.79 13.23 IMEYER AUF 1 GESETZT
      IMEYER = 1
      CALL VZERO(EP,200)
      CALL BLOC(IVT,'VERT',1,&101)
      CALL BLOC(IRN,'RUN ',0,&101)
      CALL BSAW(1,'PART')
      ECMS=RW(IRN+19)
      ZAV=RW(IVT+6)
C
C     SIGMA OF Z OF INTERACTION POINT ABOUT 30 MM
C     WILL BE NEGLEGLIBLE IF MANY TRACKS ARE PRESENT
      SUMW=1.E-3
      SUMZ=ZAV*SUMW
C
C     DETERMINE AVERAGE Z FROM ALL CHARGED
C     MAKE LIST OF ALL PARTICLE ENERGIES AND
C     SORT THIS LIST
C
      NP=0
C     CHARGED
      IF(NPT.LE.0) GOTO 8
      DO 6 I=1,NPT
      CALL BLOC(IND,'PART',LPART(I),&2)
      GOTO 4
    2 CALL BLOC(IND,'TRAC',LPART(I),&101)
      CALL TRPART(IND,&101)
      CALL BLOC(IND,'PART',LPART(I),&101)
    4 XMS=0.0
      IF(IW(IND+8).EQ.0) GOTO 5
      WZ=1.0/RW(IND+20)
      SUMZ=SUMZ+RW(IND+4)*WZ
      SUMW=SUMW+WZ
      XMS=0.0194789
    5 NP=NP+1
      LP(NP)=NP
      ICHARG(NP)=IW(IND+8)
      EP(NP)=-SQRT(XMS+1.0/RW(IND+1)**2)
    6 CONTINUE
      ZAV=SUMZ/SUMW
C     NEUTRAL
    8 IF(NBC.LE.0) GOTO 12
      DO 10 I=1,NBC
      CALL BLOC(IND,'BAEC',LBAEC(I),&101)
      NP=NP+1
      LP(NP)=NP
      ICHARG(NP)=0
   10 EP(NP)=-1.0E-3*RW(IND+1)
C     SORT
   12 CALL SORTXY(EP(1),LP(1),NP)
C
C     INITIALIZE FIT PROGRAM, USE ALL PARTICLES, IF LESS EQUAL 12
C     OTHERWISE USE THE 8 HIGH ENERGY PARTICLES AND THE REMAINING
C     AS ONE PARTICLE
C
      CALL CONPAR(10)
      NY=3*NP
      IF(NP.GT.12) NY=27
      NY=NY+3
      IF(RELE.NE.0.0) NY=NY+1
      NF=4
      CALL CONLES(1)
      CALL VZERO(B,NY*NF)
C
C
C
C
      CALL VZERO(QU,36)
      CALL VZERO(RSUM,4)
      CALL VZERO(VR,6)
      DO 20 I=1,NP
      J=LP(I)
      II=I
      IF(NP.GT.12.AND.I.GT.8) II=11
      IF(J.GT.NPT) GOTO 13
C     PART BANKS
      CALL BLOC(IND,'PART',LPART(J),&101)
      QU(1,II)=ABS(RW(IND+1))
           QU(2,II)=RW(IND+2)
      IF(IMEYER.NE.0.AND.ICHARG(I).NE.0)
     1     QU(2,II)=RW(IND+2)+(ZAV-RW(IND+4))*RW(IND+18)/RW(IND+20)
      QU(3,II)=RW(IND+3)
      XMS=0.0194789
      IF(ICHARG(I).EQ.0) XMS=0.0
      FAC=1.0-RW(IND+18)**2/(RW(IND+13)*RW(IND+20))
      CALL UCOPY(RW(IND+11),VS,6)
      IF(IMEYER.EQ.0.OR.ICHARG(I).EQ.0) GOTO 14
      VS(3)=VS(3)*FAC
      FAC=SQRT(FAC)
      VS(2)=VS(2)*FAC
      VS(5)=VS(5)*FAC
      GOTO 14
C     NEUTRALS (BAEC BANKS)
   13 J=J-NPT
      CALL BLOC(IND,'BAEC',LBAEC(J),&101)
      EN=1.0E-3*RW(IND+1)
      IF(IW(IND+5).EQ.0) GOTO 113
C
C     CORRECTION OF NEUTRAL ENERGY - SUBTRACT MIN IONIZATION
C                                    (MEYER/DEVENISH)
C
      FAC=ABS(RW(IND+10))
      IF(FAC.LT.1.0) FAC=1
      CEN=0.080*FAC
      IF(EN-CEN.LT.0.050) GOTO 113
      EN=EN-CEN
  113 ZB=RW(IND+3)-ZAV
      RB=RW(IND+4)
      QU(1,II)=1.0/EN
      QU(2,II)=ATAN(ZB/RB)
      QU(3,II)=RW(IND+2)
      CALL VZERO(VS,6)
      DEN=0.5*SQRT(EN)
      IF(EN.LE.1.0) DEN=0.5*EN
      VS(1)=DEN/(EN*EN)
      VS(3)=(0.020)**2/(1.0+(ZB/RB)**2)
      VS(6)=(0.015)**2
      XMS=0.0
C
   14 IF(NP.LE.12.OR.I.LE.8) GOTO 18
C     SUM UP PARTICLES
      CALL TADER(QU(1,II),XMS,R,D)
      CALL SMAVAT(VS,D(4),VH,3,3)
      DO 15 K=1,4
   15 RSUM(K)=RSUM(K)+R(K)
      DO 16 K=1,6
   16 VR(K)=VR(K)+VH(K)
      GOTO 20
C
   18 CALL SSVW(V,3*I-2,VS,3)
C
   20 CONTINUE
      IF(RELE.NE.0.0) V((NY*NY+NY)/2)=(RELE*ECMS)**2
C
      IF(NP.LE.12) GOTO 24
      XMSQ=RSUM(1)**2-RSUM(2)**2-RSUM(3)**2-RSUM(4)**2
      DO 22 K=1,3
   22 QU(K,9)=RSUM(K+1)
      CALL SSVW(V,25,VR,3)
C
   24 CALL CONLES(2)
C
C     COPY P-VECTORS 1 . . . 100 TO  101 . . . 200
C
      CALL PCOP(1,100,101)
      CALL PZER(1,NP+1)
C
C     ADD CORRECTIONS TO UNFITTED VALUES
C
      ITER=0
      ECMF=ECMS
   30 ITER=ITER+1
      N=0
      NPY=NY/3
      DO 33 K=1,NPY
      DO 32 L=1,3
      N=N+1
   32 QF(L,K)=QU(L,K)+DELY(N)
      IF(K.EQ.NPY) GOTO 33
      IF(NP.GT.12.AND.K.GT.8) GOTO 33
      IF(QF(1,K).LE.0.0) IUNPH=1
   33 CONTINUE
      IF(RELE.NE.0.0) ECMF=ECMS+DELY(NY)
C
C     COMPUTE CONSTRAINTS
C
      CALL VZERO(F,4)
      F(1)=-ECMF
      DO 50 I=1,NPY
      J=LP(I)
      XMS=0.0194789
      IF(ICHARG(I).EQ.0) XMS=0.0
      IF(J.GT.NPT) XMS=0.0
      IF(I.EQ.NPY) GOTO 40
      IF(NP.GT.12.AND.I.GT.8) GOTO 40
C     VARIABLES 1/0, L, PHI - TRANSFROM TO E, PX, PY, PZ
      CALL TADER(QF(1,I),XMS,R,D)
      DO 34 K=1,4
   34 F(K)=F(K)+R(K)
C     FILL COVARIANCE MATRIX B( )
      ID=0
      IB=3*I-3
      DO 38 K=1,4
      DO 36 L=1,3
      ID=ID+1
      IB=IB+1
   36 B(IB)=D(ID)
   38 IB=IB+NY-3
      GOTO 50
C
C     VARIABLES PX, PY, PZ
   40 IF(ITER.NE.1.OR.I.NE.NPY) GOTO 41
C     START VALUES FOR MISSING VECTOR
      QU(1,I)=-F(2)
      QU(2,I)=-F(3)
      QU(3,I)=-F(4)
      QF(1,I)=-F(2)
      QF(2,I)=-F(3)
      QF(3,I)=-F(4)
      XMISQ=F(1)**2-F(2)**2-F(3)**2-F(4)**2
      P(1,NP+1)=-F(2)
      P(2,NP+1)=-F(3)
      P(3,NP+1)=-F(4)
      P(4,NP+1)=-F(1)
      P(5,NP+1)=SQRT(ABS(XMISQ))
      IF(XMISQ.LT.0.0) P(5,NP+1)=-P(5,NP+1)
      CALL PCOP(NP+1,NP+1,NP+2)
      P(9,NP+1)=F(1)+ECMF
      CALL UCORR(4711,XMISQ,-F(1))
C
C     IF MISSING ENERGY NEGATIVE OR MISSING MASS SQUARED NEGATIVE,
C     THAN THE FIT USES MISSING MASS SQUARED = 0
C
      IF(F(1).GT.0.0.OR.XMISQ.LT.0.0) XMISQ=0.0
C
   41 XMS=0.0
      IF(I.EQ.9)   XMS=XMSQ
      IF(I.EQ.NPY) XMS=XMISQ
      EN=XMS
      DO 42 K=1,3
      F(K+1)=F(K+1)+QF(K,I)
   42 EN=EN+QF(K,I)**2
      EN=SQRT(EN)
      F(1)=F(1)+EN
C     FILL COVARIANCE MATRIX
      IB=3*I-3
      B(IB+1)=QF(1,I)/EN
      B(IB+2)=QF(2,I)/EN
      B(IB+3)=QF(3,I)/EN
      IB=IB+NY
      DO 46 K=1,3
      DO 44 L=1,3
      IB=IB+1
      B(IB)=0.0
      IF(L.EQ.K) B(IB)=1.0
   44 CONTINUE
   46 IB=IB+NY-3
C
   50 CONTINUE
      IF(RELE.NE.0.0) B(NY)=-1.0
C
C
      XMSTOT=F(1)**2-F(2)**2-F(3)**3-F(4)**2
C     CHECK CONVERGENCE
      CALL CONCHK(IBR)
      IF(IBR.NE.0) GOTO (30,60,160),IBR
C     CALCULATE CORRECTIONS
      CALL CONLES(3)
      GOTO 30
C     CALCULATE COVARIANCE MATRIX
   60 CALL CONLES(4)
C     FILL P-VECTORS 1, 4 . . . (NPT+NBC+1)
  160 DO 70 I=1,NP
      J=LP(I)
      IF(NP.GT.12.AND.I.GT.8) GOTO 63
      II=I
C     PARTICLE WAS USED IN THE FIT, USE FITTED VALUES
      IF(J.GT.NPT) GOTO 61
C     PART BANK
      CALL BLOC(IND,'PART',LPART(J),&101)
      P(7,J)=3-IW(IND+8)
      IF(IW(IND+8).EQ.0) P(7,J)=0.0
      P(9,J)=LPART(J)
      P(6,J)=QF(3,II)
      XMS=0.0194789
      IF(ICHARG(I).EQ.0) XMS=0.0
      GOTO 62
C     NEUTRAL (BAEC)
   61 XMS=0.0
      P(9,J)=LBAEC(J-NPT)
C     BOTH
   62 P(6,2)=QF(3,II)
      CALL TADER(QF(1,II),XMS,R,D)
      GOTO 69
C     PARTICLE WAS NOT DIRECTLY USED IN THE FIT, USE UNFITTED VALUES
   63 II=11
      IF(J.GT.NPT) GOTO 64
C     PART BANK
      CALL BLOC(IND,'PART',LPART(J),&101)
      QU(1,II)=ABS(RW(IND+1))
           QU(2,II)=RW(IND+2)
      IF(IMEYER.NE.0.AND.ICHARG(I).NE.0)
     1     QU(2,II)=RW(IND+2)+(ZAV-RW(IND+4))*RW(IND+18)/RW(IND+20)
      QU(3,II)=RW(IND+3)
      XMS=0.0194789
      P(7,J)=3-2*IW(IND+8)
      IF(ICHARG(I).EQ.0) P(7,J)=0.0
      IF(ICHARG(I).EQ.0) XMS=0.0
      P(9,J)=LPART(J)
      P(6,J)=QU(3,II)
      GOTO 65
C     NEUTRALS (BAEC)
   64 CALL BLOC(IND,'BAEC',LBAEC(J-NPT),&101)
      EN=1.0E-3*RW(IND+1)
      IF(IW(IND+5).EQ.0) GOTO 164
      FAC=ABS(RW(IND+10))
      IF(FAC.LT.1.0) FAC=1
      CEN=0.080*FAC
      IF(EN-CEN.LT.0.050) GOTO 164
      EN=EN-CEN
  164 ZB=RW(IND+3)-ZAV
      RB=RW(IND+4)
      QU(1,II)=1.0/EN
      QU(2,II)=ATAN(ZB/RB)
      QU(3,II)=RW(IND+2)
      XMS=0.0
      P(6,J)=QU(3,II)
      P(9,J)=LBAEC(J-NPT)
C
   65 CALL TADER(QU(1,II),XMS,R,D)
C
   69 P(1,J)=R(2)
      P(2,J)=R(3)
      P(3,J)=R(4)
      P(4,J)=R(1)
      P(5,J)=SQRT(XMS)
      CALL LENGTH(J,XL)
      P(8,J)=XL
   70 CONTINUE
      P(1,NP+1)=QF(1,NPY)
      P(2,NP+1)=QF(2,NPY)
      P(3,NP+1)=QF(3,NPY)
      P(5,NP+1)=SQRT(XMISQ)
      CALL LENGTH(NP+1,XL)
      P(4,NP+1)=SQRT(XL*XL+XMISQ)
      ESEEN=0.0
      DO 80 I=1,NP
   80 ESEEN=ESEEN+P(4,I)
      P(10,NP+1)=ESEEN
      CALL UCORR(4712,P(9,NP+1),P(10,NP+1))
  100 RETURN
  101 RETURN 1
      END