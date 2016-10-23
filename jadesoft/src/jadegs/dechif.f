C   05/11/82 503042126  MEMBER NAME  DECHIF   (JADEGS)      FORTRAN
      SUBROUTINE DECHIF(P,SIGP,DE,SIGDE,FMASS,PBEST,DEBEST,CHISQR)
C
C        CALCULATES CHI SQUARE AND BEST POINT (PBEST,DEBEST) ON
C        THEORETICAL DE/DX-CURVE, DEFINED BY THE FUNCTION DETHRY.
C        THUS DEBEST=DETHRY(PBEST). THE BEST POINT IS CHOSEN TO MINIMIZE
C        THE CHI SQUARE DEVIATION FOR THE POINT (P,DE), MEASURED WITH
C        ACCURACIES GIVEN BY THE STANDARD DEVIATIONS SIGP AND SIGDE.
C        THE THEORETICAL CURVE IS FOR PIONS, OTHER PARTICLES GET THEIR
C        MOMENTA SCALED TO THE SAME BETA BEFORE THE FIT
C
C                                                 J.A.J.SKARD, 14/8/83
C        PBEST RESCALED TO CORRECT VALUE FOR PARTICLE OF MASS FMASS,
C        BEFORE RETURN TO CALLING ROUTINE.
C                                                 J.A.J.SKARD,  4/3/85
C
       EXTERNAL DETHRY
C       REQUIRED ACCURACY OF MINIMUM CHI SQUARE IS AMAX1(CHISQR*EPS,EPS)
       DATA EPS/0.01/
       SCAFAC=0.139/FMASS
       PP=P*SCAFAC
       SIGPP=SIGP*SCAFAC
       CALL CHIFT1(PP,SIGPP,DE,SIGDE,DETHRY,EPS,PPBEST,DEBEST,CHISQR)
       PBEST=PPBEST/SCAFAC
       RETURN
       END
