C   07/03/79 C9101501   MEMBER NAME  TRKNM    (JADEGS)      FORTRAN
      SUBROUTINE TRKNM(X0,Y0,X1,Y1,IPART)
      IMPLICIT INTEGER*2 (H)
      COMMON /CJTRIG/ PI,TWOPI
      DATA SIZE/20./
      THETA=ATAN2((Y1-Y0),(X1-X0))
      IFLIP=0
      IF(ABS(THETA).GT.(PI/2.)) IFLIP=1
      IF(THETA.GT.( PI/2.)) THETA=THETA-PI
      IF(THETA.LT.(-PI/2.)) THETA=THETA+PI
      NDIG=1
      IF(IPART.GE.10) NDIG=2
      IF(IPART.GE.100) NDIG=3
      X=X1+SIZE*(3-(NDIG+6)*IFLIP)*COS(THETA)
      Y=Y1+SIZE*(3-(NDIG+6)*IFLIP)*SIN(THETA)
      CALL DNUM(IPART,X,Y,SIZE,THETA)
      RETURN
      END