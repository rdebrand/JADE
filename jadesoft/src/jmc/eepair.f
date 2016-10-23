C   18/10/77 311301710  MEMBER NAME  EEPAIR   (S)           FORTRAN
      SUBROUTINE EEPAIR (PGAM,P1,P2,XRAD,*)
C
C     THIS ROUTINE CONVERTS PHOTONS INTO E+E-PAIRS IN A RADIATOR OF
C      THICKNESS XRAD IN RADIATION LENGTH
C     (ENERGIES IN GEV)
C
      DIMENSION PGAM(4),P(2,3),TH(2),PHI(2) ,P1(10),P2(10),
     *          PN1(3),PN2(3)
      REAL ME/.511E-03/ , PI/3.14159/
C
      IF(PGAM(4).LE.0) RETURN 1
C
C     THE PROBABILITY FOR PAIR PRODUCTION IS FITTED TO ROSSI DATA
C
      PPROB=EXP(-XRAD*7./9.*(1.-6.2E-02/SQRT(PGAM(4))))
      IF (PGAM(4).GE.5) PPROB=EXP(-XRAD*7./9.)
   13 IF(PPROB.GT.RN(DUM)) RETURN 1
C
C     DETERMINE THE ENRGIE OF EACH PARTICLE. THE HIGH ENERGY LIMIT IS
C     EXTRAPOLATED FROM LOWER ENERGIES (ROSSI P.83.)
C
    1 V=RN(DUM)
      IF((V-.5)) 8,8,9
    8 Y=V
      GOTO 11
    9 Y=(1.-V)
   11 VPROB=(V**2+(1.-V)**2+.6382*V*(1.-V))*(1.-3.2E-03/(PGAM(4)**.7*Y))
      IF (VPROB.LT.RN(DUM)) GOTO 1
C
C     DETERMINE THE MEAN SQUARE ANGLE BETWEEN THE ELKTRON AND
C     THE PRIMARY PHOTON.(ROSSI P.83/85)
C
      TH(1)=.56*V**(-.8)*ME/PGAM(4)*ALOG(PGAM(4)/ME)
      TH(2)=.56*(1.-V)**(-.8)*ME/PGAM(4)*ALOG(PGAM(4)/ME)
C
C     CALCULATE THE FOUR MOMENTUM VECTORS OF ELEKTRON AND POSITRON
C
      A=SQRT(PGAM(1)**2+PGAM(2)**2)
      DO 3 I=1,2
      PHI(I)=RN(DUM)*2*PI
      E1=PGAM(4)*V
      E2=PGAM(4)*(1.-V)
      IF(A) 4,4,5
    4 P(I,1)=TH(I)*COS(PHI(I))
      P(I,2)=TH(I)*SIN(PHI(I))
      P(I,3)=PGAM(3)/PGAM(4)
      GO TO 7
    5 P(I,1)=(TH(I)*(PGAM(3)*PGAM(1)*COS(PHI(I))/(PGAM(4)*A)+PGAM(2)*
     *SIN(PHI(I))/A)+PGAM(1)/PGAM(4))
      P(I,2)=(TH(I)*(PGAM(I)*SIN(PHI(I))/A-PGAM(3)*PGAM(2)*COS(PHI(I))/
     *A)+PGAM(2)/PGAM(4))
      P(I,3)=(PGAM(3)/PGAM(4)-TH(I)*COS(PHI(I))*A/PGAM(4))
    7 CONTINUE
    3 CONTINUE
      DO6 I=1,3
      PN1(I)=P(1,I)/SQRT(P(1,1)**2+P(1,2)**2+P(1,3)**2)
    6 PN2(I)=P(2,I)/SQRT(P(2,1)**2+P(2,2)**2+P(2,3)**2)
      DO15  I=1,3
      P1(I)=E1*PN1(I)
   15 P2(I)=E2*PN2(I)
      P1(4)=E1
      P2(4)=E2
      P1(5)=ME
      P2(5)=ME
      P1(6)=SQRT(P1(1)**2+P1(2)**2+P1(3)**2)
      P2(6)=SQRT(P2(1)**2+P2(2)**2+P2(3)**2)
      P1(7)=1.
      P2(7)=-1.
      RETURN
      END
