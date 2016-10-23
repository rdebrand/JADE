C   07/06/96 606071910  MEMBER NAME  SMPTEQ   (S4)          FORTG1
      SUBROUTINE SMPTEQ(Y,N)
      REAL Y(N)
C
C     TRANSFORM POISSON DISTRIBUTED DATA TO DATA OF VARIANCE 1.0
C
      IA=0
      IB=0
      DO 10 I=1,N
      IF(Y(I).EQ.0.0) GOTO 10
      IF(IA.EQ.0) IA=I
      IB=I
   10 CONTINUE
      IF(IB.EQ.0) GOTO 100
      DO 30 I=IA,IB
      IF(Y(I).GT.0.0) GOTO 20
      Y(I)=1.0
      GOTO 30
   20 Y(I)=SQRT(Y(I))+SQRT(Y(I)+1.0)
   30 CONTINUE
      GOTO 100
C
      ENTRY SMEQTP(Y,N)
C
C     TRANSFORM BACK TO POISSON DISTRIBUTED DATA
C
      DO 50 I=1,N
      IF(Y(I).GT.1.0) GOTO 40
      Y(I)=0.0
      GOTO 50
   40 SY=(0.5*(Y(I)-1.0/Y(I)))**2
      NY=100.0*SY+0.5
      Y(I)=0.01*FLOAT(NY)
   50 CONTINUE
  100 RETURN
      END
