C   07/06/96 606071917  MEMBER NAME  USSTO    (S4)          FORTG1
      SUBROUTINE USSTO(NA,KA,X)
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (RW(1),IW(1))
      IF(KA.LT.0) GOTO 100
      CALL BLOC(IND,'SST*',NA,&20)
   10 NEN=IW(IND+1)
      INDK=IND+2+KA*(NEN+1)
      IF(IW(INDK).GT.IND+IW(IND)) GOTO 100
      IW(INDK)=IW(INDK)+1
      N=IW(INDK)
      IF(N.GT.NEN) GOTO 100
      RW(INDK+N)=X
      GOTO 100
   20 IF(KA.NE.0) GOTO 100
      CALL BCRE(IND,'SST*',NA,102,&100,IER)
      IW(IND+1)=100
      GOTO 10
C
      ENTRY DSSTO(NA,KA,IEN)
      CALL BLOC(IND,'SST*',NA,&30)
      GOTO 100
   30 KAK=0
      IF(KA.GT.0) KAK=KA
      NW=IEN
      IF(NW.LE.0) NW=0
      NWW=NW
      NW=(KAK+1)*(NW+1)+1
      CALL BCRE(IND,'SST*',NA,NW,&100,IER)
      IW(IND+1)=NWW
      GOTO 100
C
      ENTRY QSSTO(NA,KA,Q,NQ,NTOT)
      REAL Q(1)
      NQ=0
      NTOT=0
      IF(KA.LT.0) GOTO 100
      CALL BLOC(IND,'SST*',NA,&100)
      NEN=IW(IND+1)
      INDK=IND+KA*(NEN+1)+2
      IF(INDK.GT.IND+IW(IND)) GOTO 100
      NTOT=IW(INDK)
      NQ=MIN0(NTOT,NEN)
      IF(NQ.EQ.0) GOTO 100
      DO 40 I=1,NQ
   40 Q(I)=RW(INDK+I)
C
  100 RETURN
      END
