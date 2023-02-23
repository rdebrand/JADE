C   07/06/96 606071902  MEMBER NAME  PCORR    (S4)          FORTG1
      SUBROUTINE PCORR(KA)
      REAL S(5),T(5)
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (RW(1),IW(1))
      EQUIVALENCE (JW,WJ),(K,RK)
      CHARACTER*1 LL(100),LCH(2)/1H ,1HX/
      INTEGER*8 IP2(32)
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
      INTEGER EINS/1/
      REAL BLK/4H    /,RS(11),TA
      REAL*8 TS(11),TH
      CHARACTER*1 VP,CHI/1HI/,CHT/1HT/
      REAL AND
      EXTERNAL AND
      IF(KA.NE.0) GOTO 11
      CALL BPOS('COR*')
   10 CALL BNXT(IND,*100)
      GOTO 12
   11 CALL BLOC(IND,'COR*',KA,*100)
   12 IF(IW(IND+10).EQ.1) GOTO 80
      N=IW(IND+1)
      IF(N.GT.175) GOTO 20
      CALL CCOR(IND)
   20 LTY=6
      NS=0
      DO 22 I=1,100
      NS=NS+IW(IND+80+I)
   22 RW(IND+80+I)=IW(IND+80+I)
      WRITE(6,101) IW(IND-2)
      CALL PVERT(RW(IND+81),100,-6)
      WRITE(6,102)
      DO 24 I=1,6
   24 RS(I)=RW(IND+2)+10.0*RW(IND+3)*FLOAT(I-1)
      CALL BFMT(RS,6,TS,TA)
      WRITE(6,102) TA
      DO 40 LY=1,50
      CALL ITODA(IW(IND+81-LY),TH,6)
      JND=IND+380-4*LY
      L=0
      DO 30 LJ=1,4
      JW=IW(JND+LJ)
      DO 30 N=1,32
      IF(L.EQ.100) GOTO 32
      L=L+1
      LL(L)=LCH(1)
      RK=AND(WJ,RP2(N))
      IF(K.NE.0) LL(L)=LCH(2)
   30 CONTINUE
   32 CONTINUE
      IF(MOD(51-LY,10).EQ.0) GOTO 35
      VP=CHI
      IF(MOD(51-LY,10).EQ.5) VP=CHT
      WRITE(6,103) VP,LL,VP,TH
      GOTO 40
   35 WRITE(6,104) TS(LTY),LL,TH
      LTY=LTY-1
   40 CONTINUE
      WRITE(6,102) BLK
      DO 50 I=1,11
   50 RS(I)=RW(IND+4)+10.0*RW(IND+5)*FLOAT(I-1)
      CALL BFMT(RS,11,TS,TA)
      WRITE(6,105) (TS(I),I=1,11)
      WRITE(6,106) (TA,I=1,11)
   55 CONTINUE
      DO 60 I=1,5
   60 S(I)=RW(IND+16+I)
      XN=IW(IND+6)
      XN=1.0/XN
      XR=IW(IND+6)-1
      IF(XR.NE.0) XR=1.0/XR
      XT=IW(IND+6)-2
      IF(XT.NE.0.0) XT=1.0/XT
      T(1)=S(1)*XN
      T(2)=S(2)*XN
      T(3)=S(3)-S(1)*S(1)*XN
      T(4)=S(4)-S(2)*S(2)*XN
      T(5)=S(5)-S(1)*S(2)*XN
      DO 70 I=3,5
      IF(T(I).LT.0.0) T(I)=0.0
   70 CONTINUE
      RW(IND+17)=T(1)+RW(IND+13)
      RW(IND+18)=SQRT(T(3)*XR)
      ST=T(3)*T(4)-T(5)*T(5)
      IF(ST.LT.0.0) ST=0.0
      RW(IND+25)=T(2)+RW(IND+14)
      RW(IND+26)=SQRT(T(4)*XR)
      RXY=ABS(T(3)*T(4))
      IF(RXY.NE.0.0) RXY=1.0/RXY
      RW(IND+12)=T(5)*SQRT(RXY)
      IF(T(3).NE.0.0) T(3)=1.0/T(3)
      IF(T(4).NE.0.0) T(4)=1.0/T(4)
      RW(IND+19)=T(5)*T(4)
      RW(IND+20)=SQRT(XT*ST*T(4))
      RW(IND+27)=T(5)*T(3)
      RW(IND+28)=SQRT(XT*ST*T(3))
      IW(IND+7)=IW(IND+1)-IW(IND+6)
      IW(IND+10)=1
      IW(IND+14)=IW(IND+29)
      IW(IND+13)=IW(IND+1)-IW(IND+14)
      IW(IND+22)=IW(IND+30)
      IW(IND+21)=IW(IND+1)-IW(IND+22)
      WRITE(6,107) IW(IND+1)
      WRITE(6,108) IW(IND+6),(RW(IND+J),J=13,18),RW(IND+12)
      WRITE(6,109) IW(IND+7),(RW(IND+J),J=21,26)
      CALL BDLS('COR*',IW(IND-2))
   80 IF(KA.EQ.0) GOTO 10
  100 RETURN
  101 FORMAT('1---',3('----')/' UCORR',I10)
  102 FORMAT(5X,A4,' +',10('L----L----'),'+')
  103 FORMAT(10X,A1,100A1,A1,A6)
  104 FORMAT(1X,A8,' T',100A1,'T',A6)
  105 FORMAT(6X,11(A8,2X))
  106 FORMAT(3X,11(6X,A4))
  107 FORMAT('0TOTAL',I10,14X,'INSIDE OUTSIDE',3X,'MIN',7X,'MAX',
     1   12X,'ONLY',4X,'MEAN',5X,'SIGMA',5X,'CORR-COFF')
  108 FORMAT(' INSIDE',I9,8X,'Y',3X,2I8,2G10.3,8X,'FROM  ',2G10.3,
     1   F10.3)
  109 FORMAT(' OUTSIDE',I8,8X,'X',3X,2I8,2G10.3,8X,'INSIDE',2G10.3)
      END
