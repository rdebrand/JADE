C   07/06/96 606071847  MEMBER NAME  HISTPR   (S4)          FORTG1
      SUBROUTINE HISTPR(F,N,AW,ST)
C
C     PRINT AN ARRAY OF UP TO 100 REAL VALUES AS A HISTOGRAM
C                 - - -- --
C     CALL HISTPR(F,N,AW,ST)
C
C        WHERE F( ) = ARRAY OF N REAL VALUES
C              AW   = LOWEST CHANNEL LEFT EDGE
C              ST   = CHANNEL WIDTH
C
C
      REAL F(100)
      REAL*8 RPR(11)
      REAL*4 SP(11)
      COMMON/CCONVT/JM,PX(32,10)
      INTEGER PX,BLANK/'    '/
      character*1 LX(128,10),XCH/'X'/
      EQUIVALENCE (LX(1,1),PX(1,1))
      XM=0.0
      NN=MIN0(100,N)
      DO 10 I=1,NN
   10 XM=AMAX1(XM,F(I))
      IF(XM.LE.0.0) GOTO 23
      IF(XM.LE.10.0) GOTO 12
      FAC=10.0/XM
      JM=10
      GOTO 14
   12 FAC=1.0
      JM=XM+0.5
   14 DO 16 I=1,32
      DO 16 J=1,10
   16 PX(I,J)=BLANK
      DO 20 I=1,NN
      K=F(I)*FAC+0.5
      IF(K.EQ.0) GOTO 20
      JA=JM+1-K
      DO 18 J=JA,JM
   18 LX(I+8,J)=XCH
   20 CONTINUE
      WRITE(6,101)
      DO 22 J=1,JM
   22 WRITE(6,101) (PX(I,J),I=1,32)
   23 CALL PVERT(F(1),NN,5)
      DO 24 I=1,11
   24 SP(I)=AW+ST*10.0*FLOAT(I-1)
      CALL BFMT(SP,11,RPR,TA)
      WRITE(6,102) TA,RPR
  100 RETURN
  101 FORMAT(3X,32A4)
  102 FORMAT(1X,A4,1X,11(A8,2X)/)
      END
