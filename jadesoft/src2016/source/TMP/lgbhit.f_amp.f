C   25/07/79 C9073101   MEMBER NAME  LGBHIT   (SOURCE)      FORTRAN
      SUBROUTINE LGBHIT(XY,*)
C     WRITTEN BY WATANABE. 29/7/79, 00:50
C     LAST MODIFICATION ON  31/7/79,03:50
      DIMENSION XY(2,4),IXY(2,4),SLP(2)
C     XY(1-2,I); (PHI,Z) OF THE DIAMOND SHAPED REGION I=1,4
C     ALL UNITS ARE THAT OF THE LG COUNTER
C     THE FOLLOWING IS A STATEMENT FUNCTION
      YF(J,I)=SLP(J)*(II-XY(1,I))+XY(2,I)
C
      DO 10 I=1,4
      DO 10 J=1,2
10    IXY(J,I)=XY(J,I)
C     WRITE(6,600) IXY
C600  FORMAT(' LGBHIT; IXY',10I10)
      II=IXY(1,1)
      IF(IXY(1,1).NE.IXY(1,2).OR.IXY(1,3).NE.IXY(1,4)) GO TO 20
      IF(IXY(2,1).NE.IXY(2,3).OR.IXY(2,2).NE.IXY(2,4)) GO TO 20
      GO TO 200
20    IF(IXY(1,1).NE.IXY(1,3).OR.IXY(1,2).NE.IXY(1,4)) GO TO 30
      IF(IXY(2,1).NE.IXY(2,2).OR.IXY(2,3).NE.IXY(2,4)) GO TO 30
      GO TO 200
C
30    SLP(1)=XY(1,3)-XY(1,1)
      IF(ABS(SLP(1)).LT.1.E-10) SLP(1)=1.E-10
      SLP(1)=(XY(2,3)-XY(2,1))/SLP(1)
      SLP(2)=XY(1,2)-XY(1,1)
      IF(ABS(SLP(2)).LT.1.E-10) SLP(2)=1.E-10
      SLP(2)=(XY(2,2)-XY(2,1))/SLP(2)
      J1O=IXY(2,1)
      J2O=J1O
      Y1=YF(1,1)
      Y2=YF(2,1)
      II=II-1
      IF1=1
      IF2=2
C
C     SCAN OVER X, FINDING THE UPPER AND LOWER Y VALUES
C     WITHIN THE DIAMOND
40    II=II+1
      IF(II-IXY(1,4)) 44,42,250
42    Y1S=XY(2,4)
      Y2S=Y1S
C     THE END VALUES
      GO TO 80
44    IF(II.NE.IXY(1,3)) GO TO 50
      Y1=YF(2,3)
      IF1=2
50    Y1=Y1+SLP(IF1)
      IF(II.NE.IXY(1,2)) GO TO 60
      Y2=YF(1,2)
      IF2=1
60    Y2=Y2+SLP(IF2)
      J1N=MIN1(Y1,Y2)
      J2N=MAX1(Y1,Y2)
      Y1S=Y1
      Y2S=Y2
      IF(II.EQ.IXY(1,3)) Y1S=XY(2,3)
      IF(II.EQ.IXY(1,2)) Y2S=XY(2,2)
80    IF(Y2S.GT.Y1S) GO TO 90
      J1=Y2S
      J2=Y1S
      GO TO 100
90    J1=Y1S
      J2=Y2S
100   CONTINUE
      IF(J1.GT.J1O) J1=J1O
      IF(J2.LT.J2O) J2=J2O
C     WRITE(6,610)II,J1,J2,J1N,J2N,J1O,J2O,IF1,IF2
C610  FORMAT(' II,J1..',12I10)
C     WRITE(6,620) Y1,Y2,Y1S,Y2S,SLP
C620  FORMAT(' Y1,Y2..',10F10.4)
      J1O=J1N
      J2O=J2N
      IF(J1.GT.31) GO TO 40
      IF(J2.LT.0) GO TO 40
      IF(J1.LT.0) J1=0
      IF(J2.GT.31) J2=31
      CALL LGBFIL(II,J1,J2,*300)
      GO TO 40
C
C     SIMPLE CASES
200   CONTINUE
      I2=IXY(1,3)
      I2=IXY(1,4)
      J1=IXY(2,3)
      J2=IXY(2,2)
      IF(J2.GT.J1) GO TO 230
      I=J2
      J2=J1
      J1=I
230   CONTINUE
      IF(J1.GT.31) RETURN
      IF(J2.LT. 0) RETURN
      IF(J1.LT. 0) J1=0
      IF(J2.GT.31) J2=31
C     WRITE(6,630) II,I2,J1,J2
C630  FORMAT(' SIMPLE',12I10)
      DO 240 I=II,I2
240   CALL LGBFIL(I,J1,J2,*300)
250   RETURN
C
300   RETURN1
      END
