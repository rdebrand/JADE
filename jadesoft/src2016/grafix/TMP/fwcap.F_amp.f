C   18/05/84 405181805  MEMBER NAME  FWCAP    (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE FWCAP(ADX,ADY,LLL,FC,ITXT)
C-----------------------------------------------------------------------
C
C
C   AUTHOR:    J. OLSSON        ?    :  DRAW FORWARD DETECTOR FRONT VIEW
C
C   LAST MOD:  J. NYE       18/05/84 :  USE TAGMRK - WORKS FOR MC TOO
C
C
C     DRAW THE FORWARD DETECTOR FOR THE FW VIEW (CALLED BY DRAWFD)
C     FC IS A MAGNIFICATION FACTOR, SOMETIMES NEEDED FOR VISIBILITY.
C     ITXT NONZERO MEANS TEXT AND BEAM CROSS WILL BE ADDED TO PICTURE.
C     CALL TAGMRK TO FIND OUT VERSION NUMBER OF APPARATUS.
C
C     THE COMPLETE 1979-80 SETUP, WITH CHAMBERS AND SCINTILLATORS, CAN
C     BE FOUND IN THE MEMBER TAGDS0. IT IS NO LONGER BEING USED.
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
#include "cgeo2.for"
#include "cwktag.for"
C
      DIMENSION XYHOL(2)
      EQUIVALENCE (XYHOL(1),XYHOL1)
C
C------------------  C O D E  ------------------------------------------
C
C                            TAGMRK PUTS VERSION NUMBER IN COMMON
C
      CALL TAGMRK(*1)
   1  IF( MARK .EQ. 0 ) GO TO 3
      IF( MARK .EQ. 1 ) GO TO 2
C
C                            1983 SET UP OF FORWARD COUNTERS
C
      CALL FWC83(ADX,ADY,LLL,FC,ITXT)
      RETURN
C
C                            1981-2 SET UP OF FORWARD COUNTERS
C
  2   CALL NEWCAP(ADX,ADY,LLL,ITXT)
      RETURN
C
C                            1979-80 SET UP OF FORWARD COUNTERS
C
  3   Y1   = - FENDC * 0.5
      X1   =   XYHOL1
      DO  17  I = 1,6
        Y1 = Y1 + FENDC
        Y2 = Y1
        IF( I .EQ. 1  .OR.  I .EQ. 3 ) X2 = X1 + 4.0 * FENDC
        IF( I .EQ. 2 ) X1 = FENDC
        IF( I .GT. 4 ) X2 = X2 - FENDC
        CALL DRACAP(ADX+X1,ADY+Y1,ADX+X2,ADY+Y2,ADX-X1,ADY-Y1,ADX-X2,
     +              ADY-Y2,LLL)
   17 CONTINUE
C
      X1 = - FENDC
      Y1 =   XYHOL2
      DO  18  I = 1,6
        X1 = X1 + FENDC
        X2 = X1
        IF( I .EQ. 1  .OR.  I .EQ. 3 ) Y2 = Y1 + 4.0 * FENDC
        IF( I .EQ. 2 ) Y1 = 1.5 * FENDC
        IF( I .GT. 4 ) Y2 = Y2 - FENDC
        CALL DRACAP(ADX+X1,ADY+Y1,ADX+X2,ADY+Y2,ADX-X1,ADY-Y1,ADX-X2,
     +              ADY-Y2,LLL)
   18 CONTINUE
C
      X1 = - FENDC
      X2 =   FENDC
      Y1 =   XYHOL2 - FENDC
      DO  19  I = 1,5
        Y1 = Y1 + FENDC
        Y2 = Y1
        CALL DRACAP(ADX+X1,ADY+Y1,ADX+X2,ADY+Y2,ADX-X1,ADY-Y1,ADX-X2,
     +              ADY-Y2,LLL)
   19 CONTINUE
C
      X1 =   XYHOL1 - FENDC
      Y1 = - 1.5 * FENDC
      Y2 = - Y1
      DO  20  I = 1,5
        X1 = X1 + FENDC
        X2 = X1
        CALL DRACAP(ADX+X1,ADY+Y1,ADX+X2,ADY+Y2,ADX-X1,ADY-Y1,ADX-X2,
     +              ADY-Y2,LLL)
   20 CONTINUE
C
      IF( ITXT .EQ. 0 ) RETURN
C
C                            WRITE TEXT
C                            WRITE +- Z   BELOW
C
      SH3 = 0.6 * FENDC
      Y1  = ADY - 7.0 * FENDC
      I   = 1
      IF( ADX .GT. 0.0 ) I = 2
      LABT = 101 + (I - 1) * 2
      X1   = ADX - 0.5 * FENDC
      CALL RUTEXT(LABT,X1,Y1,SH3)
C
C                            DRAW BEAM CROSS INSIDE CAP
C
      CALL MOVEA(ADX,ADY-20.)
      CALL DRAWA(ADX,ADY+20.)
      CALL MOVEA(ADX+20.,ADY)
      CALL DRAWA(ADX-30.,ADY)
      CALL DRAWA(ADX-30.,ADY+15.)
      CALL DRAWA(ADX-45.,ADY)
      CALL DRAWA(ADX-30.,ADY-15.)
      CALL DRAWA(ADX-30.,ADY)
C
      RETURN
C
C-----------------------------------------------------------------------
      ENTRY FWCAP1(ADX,ADY,INDX,K)
C-----------------------------------------------------------------------
C
C        DRAW FORWARD DETECTOR CAPS IN Z-X VIEW (K=1), Z-Y VIEW (K=2)
C        ADX,ADY IS POSITION OF CENTER OF FRONT FACE(CLOSEST WWP)
C        INDX IS 1 FOR -Z CAP, 2 FOR +Z CAP
C
      Y2  = 4.0 * FENDC + XYHOL(K)
      Y1  = ADY - Y2
      Y2  = ADY + Y2
      CALL DRAMOV(ADX,Y1,ADX,Y2,0)
      FCT = 1.0
      IF( INDX .EQ. 2 ) FCT = -1.0
      X2 = ADX + FCT * BLDPFW
      CALL DRAMOV(X2,Y1,X2,Y2,0)
      Y1 = -0.5 * FENDC
      IF( K .EQ. 1 ) Y1 = - FENDC
      DO  101  I = 1,6
        Y1 = Y1 + FENDC
        CALL DRAMOV(ADX,ADY+Y1,X2,ADY+Y1,0)
        CALL DRAMOV(ADX,ADY-Y1,X2,ADY-Y1,0)
101   CONTINUE
      Y1 = 4.0 * FENDC + XYHOL(K)
      CALL DRAMOV(ADX,ADY+Y1,X2,ADY+Y1,0)
      CALL DRAMOV(ADX,ADY-Y1,X2,ADY-Y1,0)
      RETURN
      END