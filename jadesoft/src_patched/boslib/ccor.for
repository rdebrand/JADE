C   07/06/96 606071838  MEMBER NAME  CCOR     (S4)          FORTG1
      SUBROUTINE CCOR(IND)
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (RW(1),IW(1))
      EQUIVALENCE (R,K),(S,L)
      INTEGER IP2(32)
     1  /Z'00000001',Z'00000002',Z'00000004',Z'00000008',
     2   Z'00000010',Z'00000020',Z'00000040',Z'00000080',
     3   Z'00000100',Z'00000200',Z'00000400',Z'00000800',
     4   Z'00001000',Z'00002000',Z'00004000',Z'00008000',
     5   Z'00010000',Z'00020000',Z'00040000',Z'00080000',
     6   Z'00100000',Z'00200000',Z'00400000',Z'00800000',
     7   Z'01000000',Z'02000000',Z'04000000',Z'08000000',
     8   Z'10000000',Z'20000000',Z'40000000',Z'80000000'/
      REAL RP2(32)
      EQUIVALENCE (IP2(1),RP2(1))
      REAL Y(175),X(175)
      REAL OR
      EXTERNAL OR
      N=IW(IND+1)
      K=IND+30
      DO 10 I=1,N
      Y(I)=RW(K+1)
      X(I)=RW(K+2)
      IW(K+1)=0
      IW(K+2)=0
   10 K=K+2
      CALL VALL(Y,N,RW(IND+2),RW(IND+3),50)
      CALL VALL(X,N,RW(IND+4),RW(IND+5),100)
      RW(IND+13)=RW(IND+2)+25.0*RW(IND+3)
      RW(IND+14)=RW(IND+4)+50.0*RW(IND+5)
      RW(IND+15)=Y(1)
      RW(IND+16)=Y(1)
      RW(IND+23)=X(1)
      RW(IND+24)=X(1)
      DO 20 I=1,N
      NY=(Y(I)-RW(IND+2))/RW(IND+3)
      NX=(X(I)-RW(IND+4))/RW(IND+5)
      IF(NX.LT.0.OR.NX.GT.99) NX=-51
      IF(NY.LT.0.OR.NY.GT.49) NY=-2
      IW(IND+NX+81)=IW(IND+NX+81)+1
      IW(IND+NY+31)=IW(IND+NY+31)+1
      IF(NX+51.EQ.0.OR.NY+2.EQ.0) GOTO 20
      YR=Y(I)-RW(IND+13)
      XR=X(I)-RW(IND+14)
      RW(IND+17)=RW(IND+17)+YR
      RW(IND+18)=RW(IND+18)+XR
      RW(IND+19)=RW(IND+19)+YR*YR
      RW(IND+20)=RW(IND+20)+XR*XR
      RW(IND+21)=RW(IND+21)+XR*YR
      RW(IND+15)=AMIN1(RW(IND+15),Y(I))
      RW(IND+16)=AMAX1(RW(IND+16),Y(I))
      RW(IND+23)=AMIN1(RW(IND+23),X(I))
      RW(IND+24)=AMAX1(RW(IND+24),X(I))
      II=NX/32
      J=NX-II*32
      IJ=IND+181+NY*4+II
      RW(IJ)=OR(RW(IJ),RP2(J+1))
      IW(IND+6)=IW(IND+6)+1
   20 CONTINUE
      RETURN
      END