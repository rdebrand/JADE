C   16/12/81 112161851  MEMBER NAME  ENGLOSM  (SOURCE)      FORTRAN
C   19/02/80 111041559  MEMBER NAME  ENGLOS   (SOURCE)      FORTRAN
      SUBROUTINE ENGLOS(E,D,DE,*)
C     ENERGY LOSS IN AL. COIL AND OTHER MATERIAL.
C     INPUT   E   INPUT ENERGY IN GEV
C             D   THICKNESS OF ALUMINUM ABSORBER IN CENTI METER
C             DE  ENERGY LOSS IN GEV
C                        WRITTEN BY H.TAKEDA  16/12/81
C
C     ENERGY LOSS WAS CALCULATED BY MEAN VALUE
C                                OF THE OBSERVED ENERGY.
C     MONTE CARLO DATA WERE SUPPLIED BY MR. OLSSON.
C     MAX INCIDENT ENERGY IS 1 GEV.
      DIMENSION BENG(10),BTHK(11)
      INTEGER*2 HCOR(10,11)
      DATA BENG/0.0, 0.1, 0.2, 0.3, 0.5, 0.6, 0.7, 0.8, 1.0, 100.0/
      DATA BTHK/0., 8.68, 8.81, 9.05, 9.42, 9.97, 10.79, 12.09,
     * 13.05, 15.0, 100.0/
      DATA HCOR/10*0, 0,16,41,46,50,55,58,59,60,60,
     1 0,15,43,49,63,69,73,78,88,88,
     2 0,19,48,61,81,86,96,100,110,110,
     3 0,25,58,72,98,106,117,126,143,143,
     4 0,24,64,86,120,132,147,155,175,175,
     5 0,28,72,94,131,152,167,179,200,200,
     6 0,29,79,112,154,176,188,210,240,240,
     7 0,31,82,118,169,188,211,228,257,257,
     8 0,31,84,121,179,200,223,243,270,270,
     9 0,31,84,121,179,200,223,243,270,270/
      DATA IERR1,IERR2,IERCNT,IBTHK,IBENG/2*0,5,11,10/
      DE=0.
C
C       CHECK BAD INPUTS
2     IF(E.GE.0. .AND. E.LE.100.) GO TO 3
      IERR1=IERR1+1
      IF(IERR1.GT.IERCNT) RETURN1
      WRITE(6,600) E
600   FORMAT('0 **BAD  ENERGY INTO LGECOR(ENGLOSM) E=',F10.3)
      RETURN1
C
3     IF(D.GE.0. .AND. D.LE.100.) GO TO 4
      IERR2=IERR2+1
      IF(IERR2.GT.IERCNT) RETURN1
      WRITE(6,610) D
610   FORMAT('0 **BAD THICKNESS INTO LGECOR(ENGLOSM) D=',F10.3)
      RETURN1
C
4     DO 5 I=2,IBENG
      IF(E.LT.BENG(I)) GO TO 6
5     CONTINUE
6     DO 7 J=2,IBTHK
      IF(D.LT.BTHK(J)) GO TO 8
7     CONTINUE
C
8     EPORT=(E-BENG(I-1))/(BENG(I)-BENG(I-1))
      TPORT=(D-BTHK(J-1))/(BTHK(J)-BTHK(J-1))
C
      FACT1=HCOR(I-1,J-1)+EPORT*(HCOR(I,J-1)-HCOR(I-1,J-1))
      FACT2=HCOR(I-1,J  )+EPORT*(HCOR(I,J  )-HCOR(I-1,J  ))
C
      DE=FACT1+TPORT*(FACT2-FACT1)
      DE=DE/1000.
      IF(DE.GT.E) DE=E
      RETURN
      END
