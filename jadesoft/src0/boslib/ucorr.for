C   30/04/96 604301848  MEMBER NAME  UCORR    (BOSLIB.S)    FORTRAN
      SUBROUTINE UCORR(KA,Y,X)
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (RW(1),IW(1))
      EQUIVALENCE (R,K),(S,L)
      INTEGER IP2(32)
     1  /Z00000001,Z00000002,Z00000004,Z00000008,
     2   Z00000010,Z00000020,Z00000040,Z00000080,
     3   Z00000100,Z00000200,Z00000400,Z00000800,
     4   Z00001000,Z00002000,Z00004000,Z00008000,
     5   Z00010000,Z00020000,Z00040000,Z00080000,
     6   Z00100000,Z00200000,Z00400000,Z00800000,
     7   Z01000000,Z02000000,Z04000000,Z08000000,
     8   Z10000000,Z20000000,Z40000000,Z80000000/
      REAL RP2(32)
      EQUIVALENCE (IP2(1),RP2(1))
   10 CALL BLOC(IND,'COR*',KA,&200)
      N=IW(IND+1)
      N=N+1
      IF(N-176) 20,30,40
   20 RW(IND+30+N+N-1)=Y
      RW(IND+30+N+N)=X
      GOTO 90
   30 CALL CCOR(IND)
   40 CONTINUE
      NY=(Y-RW(IND+2))/RW(IND+3)
      NX=(X-RW(IND+4))/RW(IND+5)
      IF(NX.LT.0.OR.NX.GT.99) NX=-51
      IF(NY.LT.0.OR.NY.GT.49) NY=-2
      IW(IND+NX+81)=IW(IND+NX+81)+1
      IW(IND+NY+31)=IW(IND+NY+31)+1
      IF(NX+51.EQ.0.OR.NY+2.EQ.0) GOTO 90
      YR=Y-RW(IND+13)
      XR=X-RW(IND+14)
      RW(IND+17)=RW(IND+17)+YR
      RW(IND+18)=RW(IND+18)+XR
      RW(IND+19)=RW(IND+19)+YR*YR
      RW(IND+20)=RW(IND+20)+XR*XR
      RW(IND+21)=RW(IND+21)+XR*YR
      RW(IND+15)=AMIN1(RW(IND+15),Y)
      RW(IND+16)=AMAX1(RW(IND+16),Y)
      RW(IND+23)=AMIN1(RW(IND+23),X)
      RW(IND+24)=AMAX1(RW(IND+24),X)
      I=NX/32
      J=NX-I*32
      IJ=IND+181+NY*4+I
      RW(IJ)=OR(RW(IJ),RP2(J+1))
      IW(IND+6)=IW(IND+6)+1
   90 IW(IND+1)=N
  100 RETURN
  200 CALL BCRE(IND,'COR*',KA,380,&100,IER)
      GOTO 10
      END
