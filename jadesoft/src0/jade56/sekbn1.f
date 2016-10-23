C   25/06/78 C9011701   MEMBER NAME  SEKBN1   (LGSOURCE)    FORTRAN
      FUNCTION SEKBN1(FUNC,A,B,N)
C     THIS SUBPROGRAM GIVES THE INTEGRATED VALUE OF FUNCTION FUNC(X),IN
C     INTERVAL (A,B).FUNC(X) MUST BE GIVEN IN THE FORM OF FUNCTION SUBPR
C     OGRAM.N IS THE NUMBER OF STEPS AND MUST BE INTEGER.
      DOUBLE PRECISION DS
      IF(N-1) 800,200,200
  200 M=N+1
      H=(B-A)/FLOAT(N)
      IF(M-2) 10,10,20
   10 SEKBN1=0.5*(FUNC(A)+FUNC(B))*H
      GO TO 6
   20 IF(M-4) 40,30,40
   30 SEKBN1=0.0
      GO TO 5
   40 IF(M/2-(M-1)/2) 1,1,2
    1 NN=M
      GO TO 3
    2 NN=M-3
    3 BB=A+FLOAT(NN-1)*H
1000  QFA=FUNC(A)
      QFBB=FUNC(BB)
      DS =QFA-QFBB
      DO 4 I=2,NN,2
      X=A+FLOAT(I-1)*H
    4 DS = DS + 4.0*FUNC(X)+2.0*FUNC(X+H)
      SEKBN1=DS*H/3.0
      IF(M-NN) 6,6,5
    5 SEKBN1=SEKBN1+0.375*H*(FUNC(B-3.0*H)+3.0*FUNC(B-2.0*H)+3.0*FUNC(B-
     1H)+FUNC(B))
      GO TO 6
  800 WRITE(6,900) N
  900 FORMAT(1H0,'(SUBR. SEKBN1) N=',I4,', N MUST BE LARGER THAN 0.')
    6 RETURN
      END
C
C    DEFAULT VALUE
C
      BLOCK DATA
      COMMON/M0PAR/CUTM
      COMMON /RUNMOD/ IRNMD
      COMMON /SFCPA/SF,SFE
      DATA IRNMD/0/
      DATA CUTM/.5/
      DATA SF,SFE/1.,2./
      END
