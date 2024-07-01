C   23/06/78 704180009  MEMBER NAME  NPECR6   (S)           FORTRAN
      SUBROUTINE NPECR6(Z,COST,PENUM)
C
C    UPDATED WITH RESULTS FROM FITTING WITH #CERSF6E (NR21)
C    FOR BARREL SF6.   INTERPOLATION IS USED FOR THE COEFFICIENTS A1-2
C      J.OLSSON   17.4.87
C
C---- CALCULATE NUMBER OF PHOTOELECTRONS BY CERENKOV LIGHT.
C
C INPUT:
C     Z=DEPTH OF THE SOURCE TRACK IN THE LEAD GLASS( RAD.LENGTH )
C
C     COST=COS(THETA) OF THE SOURCE TRACK W.R.TO THE NORMAL OF
C          THE CATHODE SURFACE.
C
C OUTPUT:
C     PENUM=NO.OF PHOTOELECTRONS/1RAD.LENGTH LONG TRACK.
C
C---- PHOTOMULTIPLIER AREA IS ASSUMED TO COVER THE WHOLE SURFACE.
C---- TO GET THE REAL PHOTOELECTRON NUMBER PENUM SHOULD BE MULTIPLIED
C---  BY THE RATIO (CATHODE AREA/LEAD GLASS CROSS SECTION).
C
      DIMENSION A(2),AFIT(21,2)
      DATA MESS/0/
C
C FIT RESULTS FROM #CERSF6E, WITH BASI=10.,AESS=1.,AEXPA = 0.34
C                                 A4-7 = 0.6,-0.7,0.6,-2.
C                                 CC=0. FOR COST < -.3
C
C   21 STEPS IN COST FROM +1. TO -1., STEP WIDTH 0.1
C
      DATA AFIT/
     $ 32.059, 22.325, 21.580, 20.559, 19.738, 18.651, 17.730, 22.524,
     $ 24.521, 25.250, 25.229, 25.052, 24.215, 22.473, 17.757, 18.732,
     $ 19.544, 20.352, 21.093, 21.775, 31.930,
     $  0.668,  0.292,  0.323,  0.362,  0.360,  0.367,  0.359,  0.269,
     $  0.232,  0.196,  0.175,  0.143,  0.068, -0.002, -0.160, -0.177,
     $ -0.180, -0.189, -0.200, -0.222, -0.331/
C
C ///////////////////////////////////////////////////////////
C
      PENUM = 0.
C---- CHECK POSITION
      IF(Z.LT.0. .OR. Z.GT.19.6 ) GO TO 90
      IF(ABS(COST).GT.1.0) GO TO 90
C
C---- DETERMINE A1-2
C
        COSS = -1.
        DO 2  I = 1,20
        COSL = COSS
        COSS = COSS + .1
        IF(COST.GT.COSS) GO TO 2
C
        FRAC = (COST - COSL) / .10
        J = 22 - I - 1
        K = 22 - I
C
        A(1) = AFIT(K,1) + FRAC*( AFIT(J,1) - AFIT(K,1) )
        A(2) = AFIT(K,2) + FRAC*( AFIT(J,2) - AFIT(K,2) )
C
       GO TO 3
C
    2   CONTINUE
C
C---- FUNCTN=A(1)+CC(COST)*EXP(0.34*Z)+A(2)*Z
C
3     CONTINUE
      CC = ((0.6*COST-0.7)*COST+0.6)*COST-2.0
      CC = 10.**CC
      IF(COST.LT.-.3) CC = 0.
      EXPARG = EXP(0.34*Z)
      PENUM = A(1)+CC*EXPARG+A(2)*Z
      RETURN
C
   90 IF(MESS.EQ.0) WRITE(6,600) Z,COST
  600 FORMAT(' ***** WRONG INPUT FOR NPECR6 ***** Z COST ',2E12.3)
      MESS = 1
      RETURN
      END