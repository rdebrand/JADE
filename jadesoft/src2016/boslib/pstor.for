C   07/06/96 606071903  MEMBER NAME  PSTOR    (S4)          FORTG1
      SUBROUTINE PSTOR(N)
      COMMON/BCS/IW(1)
      INTEGER H(10)
      IF(N.EQ.0)GOTO 10
      CALL BLOC(IND,'STO*',N,*100)
      GOTO 30
  10  CALL BPOS('STO*')
  20  CALL BNXT(IND,*100)
  30  NV=IW(IND+1)
       M=IW(IND+2)
      IF(NV.EQ.0) GOTO 60
      WRITE(6,101) IW(IND-2)
      DO 50 K=1,NV,10
      LA=K
      LB=MIN0(NV,LA+9)
      LL=LB+1-LA
      WRITE(6,102)
       DO 40 I=1,M
      J=0
      DO 35 L=LA,LB
      J=J+1
      H(J)=IW(3+I-M+L*M+IND)
  35  CONTINUE
  40  CALL UWP(H,1,LL)
  50  CONTINUE
  60  IF(N.EQ.0) GOTO 20
 100  RETURN
 101  FORMAT('0',5('----')/' USTOS/USTOR',I9)
 102  FORMAT(1X)
      END
