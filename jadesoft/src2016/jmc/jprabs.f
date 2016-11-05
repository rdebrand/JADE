C   29/11/77 606101228  MEMBER NAME  JPRABS9  (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE JPRABS( R, P, PENETR, PENETZ, RDOWN, RUP,
     *                   ZDOWN, ZUP, POT, ZARO, XRAD, DRMAX,*, *, *, * )
C-----------------------------------------------------------------------
C
C   AUTHOR:   E. ELSEN    02/10/78 :  PROPAGATES PARTICLE IN ABSORBING
C                                     MEDIUM DEFINED BY RDOWN, RUP,
C                                     ZDOWN, ZUP.
C        MOD  E. ELSEN    01/10/81 :
C        MOD  W. BARTEL   25/10/83 :  STRAC IS SET FOR STEPPING OUT OF
C                                     THE MATERIAL
C        MOD  J. HAGEMANN 30/01/84 :  NEW FORMULA USED. GENERAL TIDY-UP
C   LAST MOD  J. HAGEMANN 21/09/84 :  NEW VERSION OF SUBROUTINE JSTEP
C
C
C     UPON ENTRY PENET((R) OR (Z)) IS PENETRATION LENGTH
C     IN THIS ELEMENT IN R OR Z DIRECTION.
C
C     THE ENTRIES JPRTOF AND JPRBPC SET CORRESPONDING COUNTER.
C
C     RETURN  : NEXT ELEMENT, INCREASING R
C     RETURN1 : NEXT ELEMENT, DECREASING R
C     RETURN2 : NEXT ELEMENT, INCREASING Z
C     RETURN3 : NEXT ELEMENT, DECREASING Z
C     RETURN4 : PARTICLE STOPPED IN SYSTEM
C
C-----------------------------------------------------------------------
C
      LOGICAL  ELOSS, MULSC
      LOGICAL  LBPC, LTOF
C
      COMMON / CJTRLE / TOTLEN, STPLEN, TRCOFS
      COMMON / CJSWLO / ITIMOD, MULSC, ELOSS
C
      DIMENSION R(5), P(7)
C
      DATA PMIN / .01 /
C
C------------------  C O D E  ------------------------------------------
C
      LTOF = .FALSE.
      LBPC = .FALSE.
      GO TO 1000
C
C
      ENTRY JPRBPC( R, P, PENETR, PENETZ, RDOWN, RUP,
     *                   ZDOWN, ZUP, POT, ZARO, XRAD, DRMAX,*, *, *, * )
      LBPC = .TRUE.
      LTOF = .FALSE.
      GO TO 1000
C
C
      ENTRY JPRTOF( R, P, PENETR, PENETZ, RDOWN, RUP,
     *                   ZDOWN, ZUP, POT, ZARO, XRAD, DRMAX,*, *, *, * )
      LBPC = .FALSE.
      LTOF = .TRUE.
C
C
C
 1000 IF( R(4) .GT. RUP ) RETURN
      IF( R(4) .LT. RDOWN ) RETURN1
      IF( R(3) .GT. ZUP ) RETURN2
      IF( R(3) .LT. ZDOWN ) RETURN3
C
C
C SET COUNTERS
            IF( LBPC ) CALL SETBPC( R )
            IF( LTOF ) CALL SETTOF( R )
            IF( LTOF ) CALL ACTOF(P,R,TOTLEN+TRCOFS)
C
C
      ADZDS = ABS( P(3))/ P(6)
      ADRDS = ABS( P(1)*R(1) + P(2)*R(2) ) / ( R(4)*P(6) )
      STRAC = 0.
      IF( PENETR .GT. 0. ) STRAC = PENETR / ADRDS
      IF( PENETZ .GT. 0. ) STRAC = PENETZ / ADZDS
      IF( MULSC ) CALL JMULSC( P, STRAC / XRAD )
      IF( ELOSS ) CALL JELOSS( P, STRAC, POT, ZARO, XRAD, R, 1., 0. )
C
      IF( P(6) .LT. PMIN ) RETURN 4
C
      PENETZ = 0.
      PENETR = 0.
C
      DO 100 ITERAT = 1,300
C
      R4OLD = R(4)
      R3OLD =  R(3)
C
      CALL JSTEP( R, P, DRTOT, DRMAX )
C
        R(4) = SQRT( R(1)*R(1) + R(2)* R(2) )
C        TOTAL TRACK LENGTH BIGGER THAN MAXIMUM VALUE?
            TOTLEN = TOTLEN  + DRTOT
            IF( TOTLEN .GT. STPLEN ) RETURN4
C
      IF( R(4) .LE. RUP  ) GO TO 20
      PENETR = R(4) - RUP
C  CHANGED:  STRAC MUST BE SET!
      STRAC = ABS( (RUP - R4OLD) / (P(1)*R(1)+P(2)*R(2)) * R(4)*P(6) )
C
      IF( MULSC ) CALL JMULSC( P, STRAC / XRAD )
      IF( ELOSS ) CALL JELOSS( P, STRAC, POT, ZARO, XRAD, R, 1., 0. )
      IF( P(6) .LT. PMIN ) RETURN4
      RETURN
C
   20 IF( R(4) .GE. RDOWN ) GO TO 30
      PENETR = RDOWN - R(4)
      STRAC = ABS( (R4OLD-RDOWN) / (P(1)*R(1)+P(2)*R(2)) * R(4)*P(6) )
      IF( MULSC ) CALL JMULSC( P, STRAC / XRAD )
      IF( ELOSS ) CALL JELOSS( P, STRAC, POT, ZARO, XRAD, R, 1., 0. )
      IF( P(6) .LT. PMIN ) RETURN4
      RETURN1
C
   30 IF( R(3) .LE. ZUP  ) GO TO 40
      PENETZ = R(3) - ZUP
      STRAC = ABS( ( ZUP - R3OLD ) / P(3) * P(6) )
      IF( MULSC ) CALL JMULSC( P, STRAC / XRAD )
      IF( ELOSS ) CALL JELOSS( P, STRAC, POT, ZARO, XRAD, R, 1., 0. )
      IF( P(6) .LT. PMIN ) RETURN4
      RETURN2
C
   40 IF( R(3) .GE. ZDOWN ) GO TO 50
      PENETZ = ZDOWN - R(3)
      STRAC = ABS( ( R3OLD - ZDOWN ) / P(3) * P(6) )
      IF( MULSC ) CALL JMULSC( P, STRAC / XRAD )
      IF( ELOSS ) CALL JELOSS( P, STRAC, POT, ZARO, XRAD, R, 1., 0. )
      IF( P(6) .LT. PMIN ) RETURN4
      RETURN3
C
   50 CONTINUE
      IF( MULSC ) CALL JMULSC( P, DRTOT / XRAD )
      IF( ELOSS ) CALL JELOSS( P, DRTOT, POT, ZARO, XRAD, R, 1., 0. )
      IF( P(6) .LT. PMIN ) RETURN4
  100 CONTINUE
C
      RETURN4
      END