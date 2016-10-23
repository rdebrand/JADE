C   12/03/84 406221906  MEMBER NAME  CLSPS    (S)           FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       SUBROUTINE CLSPS(SUM,ISHALL)
C
C
C ROUTINE TO FIND POSITION OF CENTRE OF CLUSTER
C
C SUM - INPUT - SUM OF ENERGY IN CLUSTER
C ISHALL - INPUT - FLAG TO SAY TURN ON THE DEBUGG INFO
C                  (1 = YES 0 = NO )
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
#include "cwktag.for"
C
       OSUM = SUM
       IWRITE = ISHALL
       IF ( MARK .EQ. 1 ) CALL CLSPS1(OSUM,ISHALL)
       IF ( MARK .EQ. 2 ) CALL CLSPS2(SUM,ISHALL)
       RETURN
       END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
        SUBROUTINE CLSPS1(SUM)
C
C WORK OUT CENTRE OF CLUSTER FOR 1981/2 TAGGER
C
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C
C
#include "cwktag.for"
C
#include "comtag.for"
  11    TEST = SUM * 0.999
       TEST2 = SUM * 0.025
      XCORR = 0
      YCORR = 0
      SIGX = 20
      SIGY = 20
C
C  DEBUG INFO - WRITE OUT CLUS
C
      IF ( IWRITE .NE. 1 ) GOTO 701
      DO 1  I = 1,8
      WRITE (6,600 ) CLUS(I,1 ) ,CLUS(I,2)
 600  FORMAT(2X,F10.2,2X,F10.2)
C
C
 1    CONTINUE
 701    I = 1
        CAND(1) = CLUS(1,2)
        IF ( CAND(1) .LT. 0 ) ISHALL = 1
        IF ( CAND(1) .LT. 0 ) GOTO 11
        ADDRES = CLUS(1,1)
        CAND(2) = XMAP (ADDRES)
        CAND(3) = YMAP (ADDRES)
 5      IF ( CAND(1) .GT. TEST ) GOTO 10
CC
C
C FIT TO RATIO OF ENERGIES FOR HIT BLOCK
C AND NEXT LARGEST HIT BLOCK
C
      CALL FIT(2,XFIT,YFIT,ISHALL,&10)
C
 12   XCORR = XFIT
      YCORR = YFIT
C
C SOPHISTICATED CALCULATION OF ERROR ON X
C
      IF ( XCORR .GT. 5 ) SIGX = 5
      IF ( YCORR .GT. 5 ) SIGY = 5
C
C ALSO FIT TO 3RD BLOCK ,IF IT HAS SIGNIFICANT FRACTION OF ENERGY
C
      IF ( CLUS(3,2) .LT. TEST2 ) GOTO 10
      CALL FIT(3,XFIT,YFIT,ISHALL,&10)
C
C CHOOSE ONE OF THE TWO FIT RESULTS - WHICHEVER IS THE LARGEST
C
 13   IF ( ABS(XFIT) .GT. ABS(XCORR) ) XCORR = XFIT
      IF ( ABS(YFIT) .GT. ABS(YCORR) ) YCORR = YFIT
C SOPHISTICATED CALCULATION OF ERROR ON X
      IF ( XCORR .GT. 5 ) SIGX = 5
      IF ( YCORR .GT. 5 ) SIGY = 5
C
C NOW ADD XCORR (CORRECTION ON X) TO X
C AND SIMILARLY Y
C
   10  CAND(2) = CAND(2) + XCORR
      CAND(3) = CAND(3) + YCORR
C
C CAND(1) = ENERGY OF CLUSTER - ONLY FIRST 4 MEMBERS
C
      CAND(1) = CLUS(1,2) + CLUS(2,2) + CLUS(3,2) + CLUS(4,2 )
C
C DEBUG - WRITE OUT RESULT
C
      IF ( IWRITE .NE. 1 ) GOTO 702
      WRITE(6,601) CAND(1 ) ,CAND(2 ) ,CAND(3)
 702  SIGEN = 0.20 * SQRT(CAND(1) )
 601  FORMAT(' CLUSTER INFO ENERGY X Y ',3(2X,F12.2) )
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      SUBROUTINE FIT(J,XFIT,YFIT, * )
C
C FIT PERFORMS THE FIT TO FIND THE DISTANCE OF THE CENTRE OF THE
CSHOWER FROM A BOUNDARY BETWEEN TWO BLOCK BY COMPARING THE RATIO
C OF THE ENERGY IN EACH
C
C J - INPUT - POINTER TO WHICH BLOCK IS TO BE COMPARED TO NUMBER 1
C                (IN CLUS)
C XFIT,YFIT - OUTPUT - X AND Y FIT RESULT
C
C RETURN 1 ERROR CONDITION DETECTED
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
#include "cwktag.for"
C
C
#include "comtag.for"
C
      XFIT = 0
      YFIT = 0
      SIGMA = 10
C
      E1 = CLUS(1,2)
      ADDRES = CLUS(1,1)
      X1 = XMAP(ADDRES)
      Y1 = YMAP(ADDRES)
      E2 = CLUS(J,2)
      IF ( (E2 + E1) .NE. 0) GOTO 10
C
      WRITE(6,60)
 60   FORMAT('  ERROR DETECTED IN FIT E2 + E1 IS ZERO ')
      RETURN  1
C
 10   ADDRES = CLUS(J,1)
      X2 = XMAP(ADDRES)
      Y2 = YMAP(ADDRES)
      IF ( IDEBUG .NE. 1 ) GOTO 703
      WRITE(6,601) E1,E2
 601  FORMAT('  E1 E2 ',2X,F10.2,2X,F10.2)
 703  RATIO = E2/(E2 + E1)
C
C THIS IS THE CRITICAL FORMULA
C
      A = RATIO/0.5
      R = LOG(A ) /( - 0.079)
C
C WORK OUT THE X AND Y CORRECTIONS REQUIRED
C
      YDIFF = Y2 - Y1
      XDIFF = X2 - X1
      YSIGN = MSIGN(YDIFF)
      XSIGN = MSIGN(XDIFF)
      THETA = 1.5708 * YSIGN
      IF ( (X2 - X1) .EQ. 0 ) GOTO 50
      THETA = ATAN((Y2 - Y1 ) /(X2 - X1) )
  50  CONTINUE
      XDIFF = X2 - X1
      YDIFF = Y2 - Y1
      ARG = YDIFF * * 2 + XDIFF * * 2
      AL = (SQRT(ARG) ) /2
      XFIT = ((AL - R) * COS(THETA) )
      YFIT = ((AL - R) * SIN(THETA) )
      XFIT = XSIGN * ABS(XFIT)
      YFIT = YSIGN * ABS(YFIT)
      IF ( IDEBUG .NE. 1 ) GOTO 704
      WRITE(6,603) XFIT,YFIT,XDIFF,YDIFF,THETA
      WRITE(6,604) AL,R,RATIO,E1,E2
  603    FORMAT(' XFIT,YFIT,YDIFF,XDIFF,THETA,AL,R,RATIO,E1,E2',5(2X,F1200018700
     1.2) )
 604  FORMAT('  ',5(2X,F12.2) )
 704  RETURN
C     DEBUG SUBCHK
      END
      FUNCTION MSIGN(X)
      MSIGN = - 1
      IF ( X .GE. 0 ) MSIGN = 1
      RETURN
      END
C   05/03/84            MEMBER NAME  NYECLS   (S)           FORTRAN
C   20/02/84            MEMBER NAME  CLSPS2   (TAGGS)       FORTRAN
C
C***HEADER*** MEMBER  CLSPS4         SAVED BY F22FIN  AT 16/10/83   23:400020100
C   10/10/83 310162342  MEMBER NAME  CLSPS4   (S)           FORTRAN
C   05/10/83 310091839  MEMBER NAME  CLSPS3   (S)           FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C CLSPS2 - DOES THE WORK OF CLSPOS FOR 1983 TAGGER
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
         SUBROUTINE CLSPS2(SUM,IWRITE)
#include "cwktag.for"
      LOGICAL FIRST
      INTEGER ONE
      INTEGER OUTER
      INTEGER ONEONE
      INTEGER ADC
      COMMON/CRAT/RATDAT(100)
      COMMON/CRAT3/RA3DAT(100)
      DIMENSION FATDAT(100)
      DIMENSION USEDAT(100)
      DIMENSION FUDGE(3)
      DIMENSION FITYPE(9)
      DIMENSION RTYPE(9)
      DATA PIBY8/0.392699081/
      DATA FUDGE/0.68,0.80,0.95/
      DATA FATDAT/
     10.38,0.30,0.26,0.23,0.20,0.19,0.18,0.17,0.16,0.152,
     10.144,0.137,0.131,0.124,0.118,0.112,0.107,0.102,0.097,0.092,
     10.087,0.083,0.079,0.075,0.072,0.068,0.065,0.062,0.059,0.056,
     10.053,0.050,0.048,0.046,0.043,0.041,0.039,0.037,0.036,0.034,
     10.032,0.030,0.029,0.028,0.026,0.025,0.024,0.023,0.022,0.021,
     10.019,0.019,0.018,0.017,0.016,0.015,0.014,0.014,0.013,0.012,
     10.012,0.011,0.011,0.010,0.009,0.009,0.009,0.008,0.008,0.008,
     10.007,0.007,0.007,0.006,0.006,0.006,0.005,0.005,0.005,0.005,
     15 * 0.004                      ,5 * 0.003,
     10.003,0.003,8 * 0.003/
      DATA FIRST/.TRUE./

C
      DATA R1/96.0/,R2/110.0/,R23/125.0/,R3/140.0/,R4/225.0/
C ONE IS THE ADC SOFTWARE ADDRESS OF THE HIT BLOCK (TOP OF SORTED
C CLUSTER MAP)
      IF ( FIRST ) WRITE(6,60 ) FUDGE
  60  FORMAT('  FUDGE FACTORS ARE ',3(2X,F4.2) )

      ONE = CLUS(1,1)
      FLAG = FRTYPE(ONE)
C     IF ( FLAG .EQ. 2 ) IWRITE =  1
      INOFIL = 0
      ILOOP = 1
   1  ONESUM = 0.0
      TWOSUM = 0.0
      THRSUM = 0.0
      TEST2 = SUM * 0.000
      ILOOP = ILOOP + 1
C  WAS GOTO 2 - JMN
      IF ( IWRITE .NE. 1 ) GOTO 3
      DO 2  I = 1,9
      WRITE (6,600 ) CLUS(I,1 ) ,CLUS(I,2)
 600  FORMAT(2X,F10.2,2X,F10.2)
 2    CONTINUE
 3    CONTINUE
C
C
C FIRST FIND THE NUMBER OF 'BIG' BLOCKS,WITH LARGE AMMOUNTS
C OF ENERGY IN THEM,AND FOR THESE ,SET UP THE LIST R - TYPE
C  AND FI - TYPE
C R - TYPE = 1 FOR INNER BLOCKS
C          2     MIDDLE
C          3     OUTER
C
C FI - TYPE = 1 FOR BLOCKS IN THE - FI DIRECTION FROM THE BLOCK
C            WITH THE LARGEST AMMOUNT OF ENERGY( = 'ONE')
C         = 2 FOR BLOCKS WITH THE SAME FI AS  ONE
C         = 3 FOR BLOCKS IN THE + FI DIRN.
C
         DO 10 I = 1,9
           IF ( CLUS(I,2) .LT. TEST2 ) GOTO 11
            NBIG = I
            ADC = CLUS(I,1)
            RTYPE(I) = FRTYPE(ADC)
            FITYPE(I) = FFITYP(ADC,ONE)
C NOW IT IS NECCESSARY TO CORRECT THE ENERGIES IN THE CLUSTER
C SO THAT THEY REPRESENT THE ACTUAL ENERGY DEPOSITED,RATHER
C THAN THE ENERGY SUCH THAT ALL CLUSTERS (SUMMED OVER MANY
C BLOCKS ) HAVE THE CORRECT ENERGY.THESE ARE DIFFERENT
C FOR INNER AND MIDDLE BLOCKS DUE TO EDGE EFFECTS,I.E.
C ALL SHOWERS IN THESE BLOCKS LOSE SOME PORTION INTO
C INSIDE EDGE OF DETECTOR.
C ACKNOWLEDGMENTS TO JOHN NYE FOR POINTING THIS OUT!
C
             IF ( ILOOP .EQ. 1)CLUS(I,2) = CLUS(I,2) * FUDGE(FITYPE(I))
C
C WHILE WE ARE AT IT CALCULATE SUM OF ENERGIES IN RESPECTIVELY
C ALL BLOCKS OF FITYPE 1,DITTO 2,AND 3,USED IN RATIO
C CALCULATIONS LATER
C     IF ( IWRITE .EQ. 1 ) WRITE(6,601 ) I,ADC,RTYPE(I ) ,FITYPE(I)
C601  FORMAT(' I ADC RTYPE FITYPE ',2(2X,I4 ) ,2(2X,F2.0) )
             IF ( FITYPE(I) .EQ. 1 ) ONESUM = ONESUM + CLUS(I,2 )
             IF ( FITYPE(I) .EQ. 2 ) TWOSUM = TWOSUM + CLUS(I,2 )
             IF ( FITYPE(I) .EQ. 3 ) THRSUM = THRSUM + CLUS(I,2 )
C

C ALSO FIND THE POINTER TO THE BLOCK IN CLUS THAT IS
C THE OUTERMOST ONE IN THE HIT CAKE SLICE (SEGMENT) OR WHATEVER
C YOU WANT TO CALL IT.USED TO CHOOSE WHICH RATIO TO CALCULATE
C
             IF ( (FITYPE(I ) .NE.2) .OR. (RTYPE(I ) .NE.3) ) GOTO 10
             OUTER = I
  10     CONTINUE
C
CTEMP USE DIFFERENT = N FOR RTYPE 1 = 3
         IF ( RTYPE(1) .NE. 3 ) GOTO 125
            DO 12 I = 1,100
             USEDAT(I) = RA3DAT(I)
  12        CONTINUE
            GOTO 14
C   WAS GOTO 13 - JMN
  125       DO 13  I = 1,100
             USEDAT(I) = RATDAT(I)
  13     CONTINUE
  14     CONTINUE

C        DEPSUM IS THE  SUM OF ACTUAL DEPOSITED ENERGY,AS OPPOSED
C          TO SUM WHICH IS THE ESTIMATE OF THE ACTUAL PARTICLE ENERGY
C        SUM EFFECTIVELY IS CORRECTED FOR EDGE EFFECTS,DEPSUM IS NOT
C
         DEPSUM = ONESUM + TWOSUM + THRSUM
C USE DEPSUM TO ESTIMATE AMMOUNT OF THIS SHOWER LOST
C
          RATLOS = SUM/DEPSUM
C       WRITE(6,609 ) RATLOS
  609   FORMAT(' RATLOS IS ',F5.2)
C
C      IF ( IWRITE .EQ. 1 ) WRITE(6,610 ) OUTER,RATLOS
C610  FORMAT('   OUTER IS ',I2,' RATLOS IS ',F5.2)
  11  CONTINUE
C
C
C FOR INNER RING BLOCKS (RTYPE = 1) RATIO = ENERGY IN MIDDLE AND OUTER
C                   RINGS COMBINED DIVIDED BY TOTAL
C FOR OUTER RING BLOCKS (RTYPE = 3) RATIO = ENERGY IN MIDDLE AND INNER
C                   RINGS COMBINED DIVIDED BY TOTAL
C FOR MIDDLE RING BLOCKS (RTYPE = 3) RATIO = ENERGY IN OUTER
C                   RING DIVIDED BY TOTAL
C
C DEBUG
C       IF(IWRITE.EQ.1 ) WRITE(6,699 ) ONESUM,TWOSUM,THRSUM,CLUS(1,2 ) ,
C    1  CLUS(OUTER,2)
C699    FORMAT(' SUMS IN RATIO CALC 1,2,3. CLUS1, CLUS OUT',5(2X,F10.2))

C       RATHER THATN USE TWOSUM,USE TWOSUM CORRECTED FOR LOSSES
C       AT INSIDE EDGE
C
        CORTWO = TWOSUM * RATLOS
C
        IF ( RTYPE(1) .EQ. 1 ) RATIO = CLUS(OUTER,2 ) /CORTWO
        IF ( RTYPE(1) .EQ. 2 ) RATIO = CLUS(OUTER,2 ) /CORTWO
        IF(RTYPE(1 ) .EQ.3 ) RATIO = ((TWOSUM - CLUS(1,2) ) /TWOSUM )
C       IF(RTYPE(1 ) .EQ.3 ) RATIO = ((CORTWO - CLUS(1,2) ) /CORTWO )
C     IF ( RTYPE(1) .EQ. 3 ) CALL HFILL(999,RATIO,0.0,1.0)
C
       IF ( RATIO .GT. 0.0001 ) GOTO 25
C
         IF ( RTYPE(1) .EQ. 1 ) R = R1
         IF ( RTYPE(1) .EQ. 2 ) R = R23
         IF ( RTYPE(1) .EQ. 3 ) R = R4
C       WRITE(6,625 ) RTYPE(1 ) ,ONE,R
         INOFIL = 1
  625  FORMAT('  RATIO IS ZERO,RTYPE(1) IS ',F2.0,'  ONE IS  ',I3,' SO
     1  R IS ',F7.2)
        GOTO 40
   25  CONTINUE

C
C     IF ( IWRITE .EQ. 1 ) WRITE(6,631 ) RTYPE(1 ) ,RATIO
C 631 FORMAT('  RTYPE(1) RATIO ',2(2X,F6.3) )
        RCORR = 200.0
          DO 31 IX = 1,90
          IF ( RATIO .LT. USEDAT(IX) ) GOTO 31
C
              RCORR = IX - 0.5
              GOTO 32
C
  31      CONTINUE
C
 32     CONTINUE
C
C     IF ( R .GT. 140 ) CALL HFILL(1000,RCORR,0.0,1.0)
C      IF ( IWRITE .EQ. 1 ) WRITE(6,632 ) RCORR
C632   FORMAT('  RCORR ',F7.2)
C
C ADD RCORR TO THE RELEVANT VALUE OF R ,THAT IS THE BOUNDARY
C WHICH DIVIDED RATIO ( = ENERGY OUTSIDE BOUNDARY/TOTAL ENERGY)
C
 33     IF ( RTYPE(1) .EQ. 1 ) R = R3 - RCORR
        IF ( RTYPE(1) .EQ. 2 ) R = R3 - RCORR
        IF ( RTYPE(1) .EQ. 3 ) R = R3 + RCORR
C
C LIMIT CORRECTION TO NOT TAKING CENTRE OF CLUSTER OUT OF HIT BLOCK
C TO PROTECT AGAINST OVER ZEALOUS CORRECTION DUE TO POOR CALIBRATION
C DEAD CHANELS ETC.
C
      IF ( IWRITE .EQ. 1 ) WRITE(6,634 ) R
  634 FORMAT('   R IS ',F6.2)
      IF ( (RTYPE(1) .EQ. 1) .AND. (R .LT. R1) ) R = R1
C NOTE IN FACT THIS ONLY STOPS IT GOING OUT OF COUNTER
      R2LIM = R1
C     IF ( FIRST ) WRITE(6,62 ) R2LIM
C 62  FORMAT(/,' MIDDLE RING HITS R LIMITED TO ',F6.2)
      IF ( (RTYPE(1) .EQ. 2) .AND. (R .LT. R2LIM) ) R = R2LIM
      IF ( (RTYPE(1) .EQ. 3) .AND. (R .GT. R4) ) R = R4
C
  40  CONTINUE
C SECOND ITERATION FOR LARGE R BLOCKS HAVING FIRST CORRECTED FOR
C GEOMETRICAL OPTICS
C     GOTO 41
C     IF ( FIRST ) WRITE(6,61)
C61   FORMAT(' GEOMETRICAL OPTICS FUDGE IS ON ')
      IF ( ILOOP .GT. 2 ) GOTO 41
C     IF ( RTYPE(1) .NE. 3 ) GOTO 41
      IF ( R .LT. 128 ) GOTO 41
      IF ( R .LT. 160 ) CLUS(1,2) = CLUS(1,2) * 1.10
      IF ( R .LT. 155 ) CLUS(1,2) = CLUS(1,2) * 1.10
      IF ( R .LT. 150 ) CLUS(1,2) = CLUS(1,2) * 1.125
      IF ( R .LT. 145 ) CLUS(1,2) = CLUS(1,2) * 1.15
C     IF ( R .GT. 190 ) CLUS(1,2) = CLUS(1,2) * 0.90
      GOTO 1
   41 CONTINUE
       IF ( INOFIL .EQ. 1 ) GOTO 441
C       CALL HFILL(3,R,0.0,1.0)
C       IF ( RTYPE(1) .EQ. 1 ) CALL HFILL(801,R,0.0,1.0)
C       IF ( RTYPE(1) .EQ. 2 ) CALL HFILL(802,R,0.0,1.0)
C       IF ( RTYPE(1) .EQ. 3 ) CALL HFILL(803,R,0.0,1.0)
C     IF ( INOFIL .NE. 1 ) CALL HFILL(993,R,0.0,1.0)
C
C -------------------------------------------------------
C
C  HAVING DETERMINED R WORK OUT FI
C
C -------------------------------------------------------
C
C
 441  IF ( IWRITE .NE. 1 ) GOTO 773
           WRITE(6,605 ) R
 605       FORMAT('  R IS ',F10.2)
C
 773  FICORR = 0
C IF ONLY ONE  HIT BLOCK NO FI CORRECTION CALCULATED
C
      IF ( NBIG .EQ. 1 ) GOTO 43
C
C     FISIGN = 0 = > NO ENERGY IN NEIGHBOURING BLOCKS
C     FISIGN = -1/+1 = > MOST ENERGY IN NEIGHBOURS IN -FI/+FI DIRECTION
C
       FISIGN = 0
C
C
C
      IF ( IWRITE .NE. 1 ) GOTO 774
           WRITE(6,666 ) ONESUM,TWOSUM,THRSUM,SUM
 666       FORMAT('  ONESUM,TWOSUM,THRSUM,SUM ',4(F10.2,2X) )

 774  CONTINUE
         RATIO = ONESUM/SUM
         FISIGN = - 1
  34  IF ( ONESUM .GT. THRSUM) GOTO 36
         RATIO = THRSUM/SUM
         FISIGN = + 1
  36  CONTINUE
C
C DEBUG
C
C     IF ( RTYPE(1) .EQ. 3 ) CALL HFILL(999,RATIO,0.0,1.0)
C IF FISIGN IS STILL 0 ONESUM AND THRSUM ARE 0 SO NO RATIO
C CALCULATED (FICOR = 0)
      IF ( FISIGN .EQ. 0 ) GOTO 43
C RIC IS DISTANCE IN  MM FROM SHOWER TO BOUNDARY BETWEEN
C HIT OCTANT AND NEIGHBOURING OCTANT,DETERMINED FROM SHARING
C IF RATIO IS LARGE,MOST OF SHOWER IS IN HIT OCTANT,SO RIC IS
C LARGE,RIC IS DISTANCE OF CENTRE OF SHOWER FROM BOUNDARY
C
CTEMPTEMPTEMP  THIS FORCES R AND FI CALCULATION TO USE SAME
C FUNCTION TO ESTIMATE CORRECTIONS
C     DO 999 I = 1,100
C999  FATDAT(I) = RATDAT(I)
C  - OLD VERSION - 9/3/84 - - - - - - - -
C         DO 38 IX = 1,90
C         IF ( RATIO .LT. FATDAT(IX) ) GOTO 38
C
C             FICORR = FISIGN * (PIBY8 - ASIN((IX - 0.5 ) /R)  )
C             GOTO 37
C
C 38      CONTINUE
C - END OF OLD VERSION - 9/3/84 - - - -
C - NEW VERSION 9/3/84
C
      FICORR = 0
      IF ( RATIO .LT. 0.0001 ) GOTO 37
      SLOPE = 0.10
      IF ( RATIO .LT. 0.12 ) SLOPE = 0.06
      A = 2 * RATIO
       RCORR = (LOG(A) ) /( - 1.0 * SLOPE)
        FICORR = FISIGN * (PIBY8 - ASIN(RCORR/R) )
  37  CONTINUE
C     IF ( R .GT. 140 ) CALL HFILL(995,FICORR,0.0,1.0)
C     CORRECT R FOR FI POSITION
C
      R = R/(COS(FICORR) )
C
C     IF ( IWRITE .NE. 1 ) GOTO 776
C          WRITE(6,902) FICORR
C902       FORMAT(2X,' FICORR IS ',F10.2)
 776  CONTINUE
C
C ACTUAL VALUE OF FI (TFI) IS FI OF 'HIT' BLOCK ('ONE') + FI CORRECTION
C
 43   TFI = FITAG(ONE) + FICORR
C
      IF ( IWRITE .NE. 1 ) GOTO 777
C
C          FIONE = FITAG(ONE)
C          WRITE(6,624 ) FIONE
C624       FORMAT('  FI ONE IS ',F10.4)
C          WRITE(6,623) TFI
C623       FORMAT(' TFI IS ',F10.4)
C
C CAND(2) = X = R COS(FI)   CAND(3) = Y = R SIN(FI)
C
 777  CAND(2) = R * (COS(TFI) )
      CAND(3) = R * (SIN(TFI) )
C
C CAND(1) = ENERGY OF CLUSTER
C
       CAND(1) = SUM
C
C NOW A REALLY NAUGHTY THING
C ADJUST ENERGY OF CLUSTER FOR 'GEOMETRICAL OPTICS'
C
      IF ( R .GT. 176 ) CAND(1) = CAND(1) * 0.90
      IF ( (RTYPE(1) .EQ. 3) .AND. (R .GT. R4) ) R = R4
C
C AND FINALLY - ERROR ON ENERGY = SIGEN
      SIGEN = 0.10 * SQRT(CAND(1) )
C FILL DEBUG HISTS FOR TRUE LUMI ONLY
      FIRST = .FALSE.
       IF ( CAND(1) .LT. 15000 ) GOTO 1000
C         CALL HFILL(4,TFI,0.0,1.0)
C         CALL HFILL(994,TFI,0.0,1.0)
C         IF ( JPART .LT. 0 ) CALL HFILL(996,TFI,0.0,1.0)
C         IF ( JPART .GT. 0 ) CALL HFILL(997,TFI,0.0,1.0)
C     IWRITE = 0
1000   RETURN
C     DEBUG SUBCHK
      END
