C   29/06/79 704291023  MEMBER NAME  MOMENT   (JADEGS)      FORTRAN
      SUBROUTINE MOMENT(IP,PX,PY,PZ,PTRANS,PTOT,PHI,THE)
      IMPLICIT INTEGER*2 (H)
C---
C---     GIVEN:  POINTER TO TRACK BANK IP
C---     RETURN: THREE COMPONENTS OF THE MOMENTUM
C---          J.OLSSON  29.06.79        LAST CHANGE  29.04.87
C---
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
C-----------------------------------------------------------------------
C                            MACRO CGRAPH .... GRAPHICS COMMON
C-----------------------------------------------------------------------
C
      LOGICAL DSPDTL,SSTPS,PSTPS,FREEZE
C
      COMMON / CGRAPH / JUSCRN,NDDINN,NDDOUT,IDATSV(11),ICREC,MAXREC,
     +                  LSTCMD,ACMD,LASTVW,ISTANV,
     +                  SXIN,SXAX,SYIN,SYAX,XMIN,XMAX,YMIN,YMAX,
     +                  DSPDTL(30),SSTPS(10),PSTPS(10),FREEZE(30),
     +                  IREADM,LABEL,LSTPS(10),IPSVAR
C
C------- END OF MACRO CGRAPH -------------------------------------------
C
      COMMON /CJTRIG/ PI,TWOPI
      DATA VELH /.2998E-4/
C----------------------------------------
      IPHEAD=IDATA(IBLN('HEAD'))
      IHHEAD=IPHEAD*2
      VELHB = ABS(VELH*.001*HDATA(IHHEAD+30))
C
      PZ = 0.
      PTRANS = 0.
      RAD = ADATA(IP+25)
      RAD = ABS(RAD)
      IF(RAD.LT.1.E-09) GO TO 7300
      PTRANS = VELHB/RAD
7300  CONTINUE
C  PLONG AND PTOT COMPUTED FROM STRAIGHT LINE FIT INVOLVING Z
C     IF(IDATA(IP+29).NE.1) GO TO 7301
C  Z-R FIT
C    NOTE: THE CORRECT FITTING IS ALWAYS A Z-S FIT, THE Z-R FIT IS ONLY
C    AN APPROXIMATION, VALID AT HIGH MOMENTA FOR TRACKS IN RADIAL FLIGHT
C    DIRECTION (I.E., NOT FOR V0 TRACKS!). TYPE 2 CORRESPONDS TO SPITZER
C    HELIX-FIT, 'THE' FROM THE PARAMETER P1 (DR/DZ OR DR/DS) IS THE SAME
C    (FORMALLY) AS IN THE OLD Z-R FIT CASE.
C
      THE = ATAN(ADATA(IP+30))
      PTOT = PTRANS/COS(THE)
      PZ = SQRT(PTOT*PTOT - PTRANS*PTRANS)
      IF(THE.LT.0.) PZ = - PZ
      THE = PI*.5 - THE
      GO TO 7302
C  Z-S  FIT  CODE STILL TO BE IMPLEMENTED, IF NEEDED AT ALL
C7301  IF(IDATA(IP+29).NE.2) GO TO 7302
C      PZ = VELHB*ADATA(IP + 30)
7302  THE = ACOS(ADATA(IP+10))
      PFIX = ADATA(IP+8)
      PFIY = ADATA(IP+9)
      IF(PFIX.NE.0..OR.PFIY.NE.0.) GO TO 3633
      WRITE(6,3367) HDATA(IHHEAD+10),HDATA(IHHEAD+11)
3367  FORMAT(' MOMENT ### WARNING ##  RUN EV.',2I8,' WITH 0,0 DIR.COSINE
     $S !!')
      PHI = 0.
      GO TO 3670
3633  PHI = ATAN2(ADATA(IP+9),ADATA(IP+8))
      IF(PHI.LT.0.) PHI = PHI + TWOPI
3670  PX = PTRANS * COS(PHI)
      PY = PTRANS * SIN(PHI)
      PTOT = SQRT(PTRANS*PTRANS + PZ*PZ + .00000000001)
C     IF(DSPDTL(30)) WRITE(JUSCRN,1234) IP,RAD,VELHB,PTRANS,PTOT,PX,PY,
C    $PZ,PHI,THE
C1234  FORMAT(' MOMENT ',I5,9E11.3)
      RETURN
      END