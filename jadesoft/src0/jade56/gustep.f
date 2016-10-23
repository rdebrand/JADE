C   07/02/89 903051738  MEMBER NAME  GUSTEP   (S)           FORTRAN77
      SUBROUTINE GUSTEP
C
C---USER SUPPLIED ROUTINE FOR DEALING WITH HITS AT END OF EACH
C   TRACKING STEP.
C                     GEANT COMMONS :

      COMMON /GCVOLU/ NLEVEL, NAMES(15), NUMBER(15),
     + LVOLUM(15),LINDEX(15),GTRAN(3,15),GRMAT(10,15),
     + NGPAR(15),GPAR(50,15),GONLY(15),GLX(3),
     + NJNEXT(2),JNEXT(15),INEXT(15),NNEXT(15)
C
      COMMON/GCONST/PI,TWOPI ,PIBY2,DEGRAD,RADDEG,CLIGHT ,BIG,EMASS
C
      COMMON/GCFLAG/IDEBUG,IDEMIN,IDEMAX,ITEST,IDRUN,IDEVT,IEORUN
     +        ,IEOTRI,IEVENT,ISWIT(10),IFINIT(20),NEVENT,NRNDM(2)
C
      COMMON/GCKINE/IKINE,PKINE(10),ITRA,ISTAK,IVERT,IPART,ITRTYP
     +      ,NAPART(5),AMASS,CHARGE,TLIFE,VERT(3),PVERT(4),IPAOLD
C
      COMMON/GCTRAK/VECT(7),GETOT,GEKIN,VOUT(7),NMEC,LMEC(30),NAMEC(30)
     + ,NSTEP ,MAXNST,DESTEP,SAFETY,SLENG ,STEP  ,SNEXT ,SFIELD,SNPHYS
     + ,TOFG  ,GEKRAT,IGNEXT,INWVOL,ISTOP ,IDECAD,IEKBIN
C
      COMMON/GCSETS/IUSET,IUDET,ISET,IDET,IDTYPE,NVNAME,NUMBV(20)
C
      COMMON/GCKING/KCASE,NGKINE,GKIN(5,100),TOFD(100)
C
      COMMON/GCTMED/NUMED,NATMED(5),ISVOL,IFIELD,FIELDM,TMAXFD,DMAXMS
     +      ,DEEMAX,EPSIL,STMIN,CFIELD,CMULS,IUPD,ISTPAR,NUMOLD
C
      COMMON / CEBLOK / EBLOCK(16,3)
      COMMON / CRVECT / PRVECT(3)
C
      LOGICAL  LDEBUG
C
      COMMON / CDEBUG / LDEBUG
C
      DATA ICALL / 0 /
      DATA IPRINT / 0 /
      ICALL = ICALL + 1
C
C------------------------------------------------------------------
C
      IF ( .NOT. LDEBUG ) GOTO 8011
      ZPOS = VECT (3)
      IF ( ABS (ZPOS) .LT. 293 ) GOTO 8011
      IF ( IPRINT .GT. 500 )      GOTO 8011

C           FOLLOW SHOWER-HISTORY
      IPRINT = IPRINT + 1
      PRINT 8000, ICALL, NUMED,(NATMED(I),I=1,5), NLEVEL,
     +            NUMBER(NLEVEL), NAMES(NLEVEL)
 8000 FORMAT (
     + /T2, I6, ' MEDIUM: ',I4,TR2,5A4,'  VOLUME LEVEL: ',I4,
     +  ' ,REGION ',I4,A5)

      PRINT 8006, NUMBER(2), NAMES(2)
 8006 FORMAT (1X,'2ND LEVEL VOL ',I2,3X,A5)

      PRINT 8002, ITRA, ISTAK, IPART, ITRTYP,
     +            AMASS * 1000., INT (CHARGE), IPAOLD, NUMOLD
 8002 FORMAT (
     + T2, 'ITRA=',I4, ' ,ISTAK=',I4, ' ,IPART=',I4,
     +     ' ,ITRTYP=',I4, ' ,MASS=',F6.1, ' ,Q=',I3, ' ,PARENT=',I4,
     +     ' ,OLD MED=',I3)

      PRINT 8004, (VECT(I),I=1,6), GETOT * 1000., GEKIN * 1000.,
     +            NSTEP, STEP, DESTEP * 1000.,
     +            INWVOL, ISTOP
 8004 FORMAT (
     + T2,'X,Y,Z=',3F7.1,' ,CX,CY,CZ=',3F7.3,' ,E,EK=',2F7.1,
     + /  'STEP# ',I4, ' ,STEPL=',F6.3, ' ,ELOSS=',F7.3,
     +    ' ,NEWVOL=',I3, ' ,ISTOP=',I3)

      NMEC1 = MIN ( NMEC, 8 )
      PRINT 8005, NMEC,
     +            ( I, LMEC(I), NAMEC(LMEC(I)), I=1,NMEC1)
 8005 FORMAT ( T2, ' # OF MECANISM IN THIS STEP = ' ,I2,
     +         8 ( /T2, I4, ' LMEC(I), NAMEC (LEMEC (I)) = ',
     +            I4, A10 ))
C
C-------------------------------------------------------------------
C
 8011 CONTINUE
C                  STORE PARTICLE POSITION FOR DRAWING TRACKS
CC    CALL GSXYZ
C
C-------------------------------------------------------------------
C
C
C              SECONDARIES GENERATED ?

      IF(NGKINE.GT.0) THEN
C       PRINT 9102, NGKINE, KCASE,
C    +             ( INT ( GKIN(5,I) ) , GKIN(4,I) * 1000. ,I=1,NGKINE)
C9102   FORMAT (
C    +   T2, I4, ' SECONDARIES BY ',A5, ' : TYP, E=',
C    +       20 ( 5 ( I5, F7.1 ) /) )
        DO 30 I=1,NGKINE
        ITYPA  = GKIN(5,I)
C                         PUT SECONDARIES ONTO STACK
CC      CALL GSKING(I)
   30   CONTINUE
      ENDIF
      IF(NGKINE.GT.0) CALL GSKING(0)
C
C---CHECK TO SEE THAT PARTICLE IS IN A SCINTILLATOR
      IF(NUMED.NE.26.OR.NUMBER(2).GT.16) GOTO 999
C
C---FIND MIDPOINT OF LAST TRACKING STEP
C
CC    WRITE(6,8007) PRVECT(1),PRVECT(2),PRVECT(3),VECT(1),VECT(2),
CC   &              VECT(3)
 8007 FORMAT(1X,'PRVECT : ',3F8.2,/T2,'VECT : ',3F8.2)
C
      X=(PRVECT(1)+VECT(1))/2
      Y=(PRVECT(2)+VECT(2))/2
      Z=(PRVECT(3)+VECT(3))/2
C
CC    WRITE(6,8008) X,Y,Z
 8008 FORMAT(1X,'MEAN COORDS : ',3F8.2)
C
C---DETERMINE WHICH OCTANT WAS HIT
C
      IF (NUMBER(2).GT.8) THEN
         NOCT=NUMBER(2)-8
      ELSE
         NOCT=NUMBER(2)
      ENDIF
C
CC    WRITE(6,8009) NUMBER(2),NOCT
 8009 FORMAT(1X,'HIT OCTANT ',2I4)
C
C---TRANSLATE AND ROTATE MIDPOINT ACCORDING TO SEGMENT
C
      CALL TRANS(X,Y,NOCT,XTRANS,YTRANS)
C
CC    WRITE(6,8010) XTRANS,YTRANS
 8010 FORMAT(1X,' XTRANS ',F8.2,' YTRANS ',F8.2)
C
C---MODIFY DEPOSITED ENERGY ACCORDING TO RADIAL PARAMETRISATION
C
      CALL EMOD(XTRANS,YTRANS,NOCT,DESTEP,ENMOD,IBLOCK)
C
CC    WRITE(6,8012) DESTEP,ENMOD
 8012 FORMAT(1X,' DESTEP ',F8.4,' ENMOD ',F8.4)
C
C
C---STORE POSITION COORDINATES
C
      PRVECT(1)=VECT(1)
      PRVECT(2)=VECT(2)
      PRVECT(3)=VECT(3)
C
CC    WRITE(6,8013) PRVECT(1),PRVECT(2),PRVECT(3)
 8013 FORMAT(1X,'PRVECT : ',3F8.2)
C
C---SUM THE BLOCK ENERGY
C
      EBLOCK(NUMBER(2),IBLOCK)=EBLOCK(NUMBER(2),IBLOCK)+ENMOD
C
CC    WRITE(6,8014) NUMBER(2),IBLOCK,EBLOCK(NUMBER(2),IBLOCK)
 8014 FORMAT(1X,' HIT OCTANT ',I4,' HIT BLOCK ',I4,' TOT ENERGY ',F8.4)
C
 999  RETURN
      END
C***********************************************************************
C ROUTINE TO MAP THE GLOBAL COORDINATES OF AN OCTANT ONTO A SINGLE
C REFERENCE OCTANT.
C
C   INPUT    X,Y,NOCT
C   OUTPUT   XTRANS,YTRANS
C
C  X,Y           = GLOBAL COORDINATES
C  NOCT          = OCTANT NUMBER
C  XTRANS,YTRANS = COORDINATES WITHIN REFERENCE OCTANT
C  P(I,J)        = PARAMETERS OF TRANSLATION
C                  J = OCTANT NUMBER
C                  I = 1 X TRANSLATION, 2 Y TRANSLATION,3 ROTATION ANGLE
C
      SUBROUTINE TRANS(X,Y,NOCT,XTRANS,YTRANS)
C
      COMMON / CTRANS / P(3,8)
      COMMON/GCONST/PI,TWOPI ,PIBY2,DEGRAD,RADDEG,CLIGHT ,BIG,EMASS
C
C---CONVERT ANGLE TO RADIANS
C
      PHI=TWOPI*P(3,NOCT)/360.0
C
      XTRANS=(X-P(1,NOCT))*COS(PHI) + (Y-P(2,NOCT))*SIN(PHI)
      YTRANS=(Y-P(2,NOCT))*COS(PHI) - (X-P(1,NOCT))*SIN(PHI) + 7.39
C
      RETURN
      END
C***********************************************************************
C MODIFICATION OF ENERGY ACCORDING TO RADIAL PARAMETRISATION
C
      SUBROUTINE EMOD(XTRANS,YTRANS,NOCT,DESTEP,ENMOD,IBLOCK)
C
C---DETERMINE WHICH YBIN OF REFERENCE FRAME ENERGY IS DEPOSITED
C
      DO 10 I1=1,2
         YCOORD=I1*0.5
         IF(YTRANS.LT.YCOORD) THEN
            IYVAL=I1
            IBLOCK=1
            GOTO 20
         ENDIF
 10   CONTINUE
      IF(YTRANS.LT.1.48) THEN
         IYVAL=3
         IBLOCK=1
         GOTO 20
      ENDIF
      DO 30 I1=4,8
         YCOORD=I1*0.5
         IF(YTRANS.LT.YCOORD) THEN
            IYVAL=I1
            IBLOCK=2
            GOTO 20
         ENDIF
 30   CONTINUE
      IF(YTRANS.LT.4.44) THEN
         IYVAL=9
         IBLOCK=2
         GOTO 20
      ENDIF
      DO 40 I1=10,30
         YCOORD=I1*0.5
         IF(YTRANS.LT.YCOORD) THEN
            IYVAL=I1
            IBLOCK=3
            GOTO 20
         ENDIF
 40   CONTINUE
C
C---NOW THE X BIN
C
 20   DO 50 I1=-19,20
         XCOORD=I1*0.5
         IF(XTRANS.LT.XCOORD) THEN
            IXVAL=I1+20
            GOTO 60
         ENDIF
 50   CONTINUE
 60   CONTINUE
C
CC    WRITE(6,8001) IXVAL,IYVAL
 8001 FORMAT(1X,'IXVAL ',I4,' IYVAL ',I4)
C
C---NOW ADD RADIAL CORRECTION
C
      CALL RADRES(NOCT,IXVAL,IYVAL,DESTEP,ENMOD)
C
      RETURN
      END
C***********************************************************************
C---Subroutine to increase the response of the outer block as seen in
C   the beam test data
C
      SUBROUTINE RADRES(NOCT,IXVAL,IYVAL,DESTEP,ENMOD)
C
      COMMON / RADPAR / RMIN(8),RADFIT(8)
C
C---CALCULATE THETA VALUE FROM IYVAL COORDINATE
C
      THETA=ATAN((RMIN(NOCT)+IYVAL*5.0)/(2950.+156.))
C---convert to mrads
      THETA=THETA*1000.
C
C     WRITE(6,8001) THETA
 8001 FORMAT(1X,' THETA (MRAD) ',F8.2)
C
C---Calculate response factor for this value of theta
C
      RESP=0.0
      IF(THETA.GT.55.AND.THETA.LT.63) THEN
         RESP=RADFIT(1)*THETA**2 + RADFIT(2)*THETA + RADFIT(3)
C
C---Correct the energy accordingly
C
         ENMOD=RESP*DESTEP
      ELSE
         ENMOD=DESTEP
C
C        WRITE(6,8002) DESTEP,RESP,ENMOD
 8002    FORMAT(1X,' DESTEP ',F8.4,'RESP ',F7.4,'ENMOD ',F8.4)
C
      ENDIF
C
      RETURN
      END
