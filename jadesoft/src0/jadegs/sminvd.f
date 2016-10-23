C   20/05/79 C9070401   MEMBER NAME  SMINVD   (JADEGS)      FORTRAN
      SUBROUTINE SMINVD(A,B,N,MV,DET)
      REAL*8 A(1),B(1),DET,AM,C,D,E,EPS
      LOGICAL*1 LR(400)
C
C     PURPOSE
C        OBTAIN SOLUTION OF A SYSTEM OF LINEAR EQUTIONS A * X = B WITH
C        SYMMETRIC MATRIX A AND INVERSE (FOR MV = 1) OR MATRIX
C        INVERSION ONLY (FOR MV = 0)
C        ALL REAL ARGUMENTS ARE IN DOUBLE PRECISION
C
C     USAGE
C                    - - - --
C        CALL SMINVD(A,B,N,MV,DET)
C                    - -      ---
C
C           A = SYMMETRIC N-BY-N MATRIX IN SYMMETRIC STORAGE MODE
C               A(1) = A11, A(2) = A12, A(3) = A22, A(4) = A13, . . .
C               REPLACED BY INVERSE MATRIX
C           B = N-VECTOR   (FOR MV = 0 USE A DUMMY ARGUMENT)
C               REPLACED BY SOLUTION VECTOR
C          MV = SEE ABOVE
C         DET = DETERMINANT OF A
C
C     RESTRICTION   N LE 400
C     METHOD OF SOLUTION IS BY ELIMINATION USING THE LARGEST PIVOTAL
C     DIVISOR AT EACH STAGE. A DETERMINANT OF ZERO INDICATES
C     A SINGULAR MATRIX. IN THIS CASE ALL REMAINING ROWS AND COLS OF
C     MATRIX A ARE SET TO ZERO.
C
      EPS=1.0D-12
      DET=1.0D0
C          CONSTRUCT TABLE
      DO 10 I=1,N
   10 LR(I)=.FALSE.
C          LOOP BEGIN
      DO 60 I=1,N
C          SEARCH FOR PIVOT
      K=0
      M=0
      AM=0.0
      DO 20 J=1,N
      M=M+J
      IF(LR(J)) GOTO 20
      IF(DABS(A(M)).LE.AM) GOTO 20
      AM=DABS(A(M))
      K=J
      KK=M
   20 CONTINUE
C          TEST FOR ZERO MATRIX
      IF(K.EQ.0) GOTO 90
C          TEST FOR LINEARITY
      IF(I.EQ.1) C=A(KK)
      IF(DABS(A(KK)/C).LT.EPS) GOTO 90
C          PREPARATION FOR ELIMINATION
      LR(K)=.TRUE.
      DET=DET*A(KK)
      D=1.0/A(KK)
      A(KK)=-D
      IF(MV.EQ.1) B(K)=B(K)*D
      JK=KK-K
      JL=0
C          ELIMINATION
      DO 50 J=1,N
      IF(J-K) 24,22,26
   22 JK=KK
      JL=JL+J
      GOTO 50
   24 JK=JK+1
      GOTO 28
   26 JK=JK+J-1
   28 E=A(JK)
      A(JK)=D*E
      IF(MV.EQ.1) B(J)=B(J)-B(K)*E
      LK=KK-K
      DO 40 L=1,J
      JL=JL+1
      IF(L-K) 34,32,36
   32 LK=KK
      GOTO 40
   34 LK=LK+1
      GOTO 38
   36 LK=LK+L-1
   38 A(JL)=A(JL)-A(LK)*E
   40 CONTINUE
   50 CONTINUE
C          LOOP END
   60 CONTINUE
C          CHANGE SIGN
      M=0
      DO 80 I=1,N
      DO 70 J=1,I
      M=M+1
   70 A(M)=-A(M)
   80 CONTINUE
      GOTO 100
   90 DET=0.0
C          CLEAR REST OF MATRIX
      M=0
      DO 95 I=1,N
      DO 95 J=1,I
      M=M+1
      IF(.NOT.LR(I)) A(M)=0.0
      IF(.NOT.LR(J)) A(M)=0.0
   95 A(M)=-A(M)
  100 RETURN
      END
