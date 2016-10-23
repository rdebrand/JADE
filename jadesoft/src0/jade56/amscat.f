C   25/06/78 C8082101   MEMBER NAME  AMSCAT   (LGSOURCE)    FORTRAN
      FUNCTION AMSCAT(ENE,T)
C
C-----MODIFIED BY S.YAMADA(SPEED UP PURPOSE ONLY)  21-08-78  17:20
C
      DIMENSION G2TBL(20),G3TBL(20)
      DIMENSION Z(NCMP),A(NCMP),FR(NCMP)
      DATA C00/.30054/
      DATA A20/4.1509/,A30/2.1946/
      DATA BM/5./
      DATA DFAI/20./
      DATA BP00/8.807/
C     C00 2.*PI*RE**2*N0
C           RE: CLASSICAL ELECTRON RADIUS
C           N0: AVOGADRO NUMBER
C
      DATA G2TBL/.1302, .2580, .3809, .4968, .6037,
     &           .6997, .7836, .8543, .9111, .9537,
     &           .9823, .9972, .9993, .9895, .9691,
     &           .9395, .9022, .9586, .8104, .7589/
      DATA G3TBL/.4603, .4748, .5014, .5455, .6205,
     &           .7529, .9117, .9950, .9876, .9528,
     &           .9356, .9400, .9514, .9556, .9452,
     &           .9191, .8795, .8303, .7753, .7177/
C
C
      BETA2=1.-1./ENE**2
      CIC2=CIC02*T/BETA2**2/ENE**2
      BP=BP0+ALOG(T/BETA2)
      B=0.700+(1.320-0.01451*BP)*BP
      IF(B.LT.BM) B=BM
      A1=1.-5./B
      A2=A20/B
      A3=A30/B
      RA123 = 1./(A1+A2+A3)
      PR1 = A1*RA123
      PR2 = A2*RA123
      PR3 = A3*RA123
C
   1  RND = RN(DUM)
      IF(RND.LE.PR3) GO TO 3000
      RND = RND-PR3
      IF(RND.LE.PR2) GO TO 2000
C
1000  X=-ALOG(RN(DUM))
      FAI=SQRT(X)
      GOTO 100
2000  FAI=RN(DUM)
      CFAI=FAI*DFAI
      IX=CFAI
      IF(IX.NE.0) GOTO 2001
      G2=G2TBL(IX)
      GOTO 2100
2001  G2=G2TBL(IX)+(G2TBL(IX+1)-G2TBL(IX))*(CFAI-FLOAT(IX))
2100  IF(RN(DUM).GT.G2) GOTO1
      GOTO 100
3000  FAI3=SQRT(RN(DUM))
      CFAI=FAI3*DFAI
      IX=CFAI
      IF(IX.NE.0) GOTO 3001
      G3=G3TBL(1)
      GOTO 3100
3001  G3=G3TBL(IX)+(G3TBL(IX+1)-G3TBL(IX))*(CFAI-FLOAT(IX))
3100  IF(RN(DUM).GT.G3) GOTO1
      FAI=1./FAI3
100   AMSCAT=SQRT(CIC2*B)*FAI
C
      IF(RN(DUM)**2*AMSCAT .GT. SIN(AMSCAT)) GOTO 1
C
      RETURN
C
C**************************************************************
C
      ENTRY AMINT(FR,NCMP,A,Z,XX0)
      CIC02=0.
      DO 10 I=1,NCMP
10    CIC02=XX0*C00*2.*Z(I)**2*FR(I)/A(I)+CIC02
      BP0=BP00+ALOG(XX0)
C
      RETURN
      END
