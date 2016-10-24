C   07/06/96 606071916  MEMBER NAME  ULIND    (S4)          FORTG1
      SUBROUTINE ULIND(NA,KA,Y,X)
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (RW(1),IW(1))
      REAL Q(10),QQ(10)
      CALL BLOC(IND,'LIN*',NA,&100)
      BN=32768.0*(Y-RW(IND+3))/(RW(IND+4)-RW(IND+3))
      IF(BN.LT.0.0) GOTO 100
      NY=BN
      IF(NY.GE.32768) GOTO 100
      BN=32768.0*(X-RW(IND+5))/(RW(IND+6)-RW(IND+5))
      IF(BN.LT.0.0) GOTO 100
      NX=BN
      IF(NX.GE.32768) GOTO 100
      CALL USSTO(NA,KA,NY*32768+NX)
      GOTO 100
C
      ENTRY DLIND(NA,KAMAX,IEN,YL,YH,XL,XH)
      CALL BLOC(IND,'LIN*',NA,&10)
      GOTO 100
   10 CALL BCRE(IND,'LIN*',NA,6,&100,IER)
      IW(IND+1)=KAMAX
      IW(IND+2)=IEN
      RW(IND+3)=YL
      RW(IND+4)=YH
      RW(IND+5)=XL
      RW(IND+6)=XH
      CALL DSSTO(NA,KAMAX,IEN)
      GOTO 100
C
      ENTRY PLIND(NA)
      CALL BLOC(IND,'LIN*',NA,&100)
      IEN=IW(IND+2)
      CALL BCRE(J,'++++',0,3*IEN,&100,IER)
      IPR=0
      KAM=IW(IND+1)
      LA=0
      IRT=0
      GOTO 30
      ENTRY QLIND(NA,KA,Q)
      DO 20 I=1,10
   20 Q(I)=0.0
      CALL BLOC(IND,'LIN*',NA,&100)
      IEN=IW(IND+2)
      CALL BCRE(J,'++++',0,3*IEN,&100,IER)
      LA=KA
      IRT=1
   30 CALL QSSTO(NA,LA,IW(J+IEN+IEN+1),NQ,NENT)
      DO 35 I=1,10
   35 QQ(I)=0.0
      QQ(10)=NENT
      IF(NQ.LE.0) GOTO 50
      DO 40 I=1,NQ
      IYX=IW(J+IEN+IEN+I)
      IY=IYX/32768
      IX=IYX-32768*IY
      RY=FLOAT(IY)+0.5
      RX=FLOAT(IX)+0.5
      RY=RW(IND+3)+(RW(IND+4)-RW(IND+3))*RY/32768.0
      RX=RW(IND+5)+(RW(IND+6)-RW(IND+5))*RX/32768.0
      RW(J+I    )=RY
   40 RW(J+I+IEN)=RX
      CALL LINSEL(RW(J+1),RW(J+IEN+1),RW(J+IEN+IEN+1),NQ,QQ)
   50 IF(IRT.EQ.0) GOTO 60
      DO 55 I=1,10
   55 Q(I)=QQ(I)
      GOTO 70
   60 IF(NQ.EQ.0) GOTO 65
      IF(IPR.NE.0) GOTO 64
      IPR=1
      WRITE(6,101) NA
   64 WRITE(6,102) LA,(QQ(I),I=1,9)
   65 IF(LA.GE.KAM) GOTO 70
      LA=LA+1
      GOTO 30
   70 CALL BDLS('++++',0)
  100 RETURN
  101 FORMAT(' ULIND',I8,' KA ENTRIES INTERCEPT',8X,'SLOPE',
     1 8X,'ERROR',7X,'MEAN X',7X,'MEAN Y',8X,'ERROR',8X,'SIGMA',
     2 8X,'OUT')
  102 FORMAT(14X,I3,F8.0,1X,7G13.5,F8.0)
      END