C   15/03/79 804061818  MEMBER NAME  LGCLPB   (SOURCE)      FORTRAN
C
C
C   CHANGED 13.12.87 : CALL BBLEAK TO CORRECT THE CALIBRATION.
C      FOR REAL-DATA ONLY ( RUN # > 100, BOS-COMMON ADDED ).
C                                                              D.PITZL

C--  CHANGED 06.04.88 : HALF-WORD 2 IN ALGN-BANK ( HNORML IN
C         WORK-COMMON ) IS INCREASED BY 12000 IF BBLEAK
C         IS DONE. SO BBLEAK IS APPLIED ONLY ONCE.           D.PITZL
C
C*************************************************************
      SUBROUTINE LGCLPB
C*************************************************************
C     MODIFIED TO CALCULATE THE CLUSTER SHAPE
C     BY R.EICHLER       15-03-78  12:00
C     LAST MODIFICATION   16-08-79  19:30   Y.WATANABE
C
C     ORIGINAL S.YAMADA 09-10-78  15:55 VERSION 4(L.M. 08-02-79,23:10)
C
C---- LEAD GLASS CLUSTERS IN THE BARREL PART ARE PROCESSED.
C---- TOTAL PULSE HEIGHT,AVERAGE POSITION AND SPATIAL SPREAD ARE
C     CALCULATED FOR EACH CLUSTER.
C
C---- MODIFICATION FOR VERSION 4;
C     ONLY THESE VARIABLES WHICH DO NOT NEED INNER TRACK INF.ARE FILLED.
C
      IMPLICIT INTEGER *2 (H)
C
      COMMON /CLGDMS/ X0,RADIUS(6),RADSX0(6),THX0(4),
     $                ZEND(2),ZENDX0(2),ZWID(2),ZGAP(2),PHWID(2),
     $                ZECAP(4),ZECAPX(4),THECPX(2)
C     COMMON /CLGPRM/ ITHADC,MAXCLS
      COMMON /CLGPRM/ ITHADC,MAXCLS,IRLTHD,IRLTH2,IRLTH3, ZVRTX,DZ
      COMMON/LGSHP/WW(50),ZZ(50),XX(50),EW(2),AVPH,AVZ,SIGPH,SIGZ,EV,KK
C
#include "clgwork1.for"
#include "cdata.for"
      EQUIVALENCE (NCLBRL,NCLBEC(1))
C
      COMMON /CLGMSB/ AMSGVL(5)
C
C     ICLSPR(1,I)=JBC, 0 FOR BARREL, -1 FOR BOTTOM, 1 FOR TOP
C     CLSPRP(2,I)=ENERGY IN GEV
C     CLSPRP(3,I)=SIGMA(ENERGY)
C     CLSPRP(4,I)=WEIGHTED AVERAGE PHI
C     CLSPRP(5,I)=WEIGHTED AVERAGE Z
C     CLSPRP(6,I)=SIGMA PHI (WEIGHTED)
C     CLSPRP(7,I)=SIGMA Z (WEIGHTED)
C     ICLSPR(8,I)=CHARGE,IF THERE IS A CHARGED NEIGHBOUR
C                  TRACK,ITS CHARGE IS COPIED.
C     CLSPRP(9-11,I)=DIRECTION COSIGNS CORRECTED FOR SHOWER DEV.
C     CLSPRP(12-14,I)=CLUSTER SHAPE: ELLIPS EIGENVALUES AND DIRECTION
C     CLSPRP(15,I)=FRACTION OF ENERGY IN EDGE COUNTERS IN THE CLUSTER
C
C
      COMMON /CLGZPT/ YETOT,Y(32),WEIGHT(32),YFIT(32),DERIV(32),PHI(84)
C---- THIS COMMON IS USED TO GET THE (Z,PHI)-POSITION OF THE CLUSTER.
C     SEE LGAVRZ AND LGAVRP.
C
      DATA ICALLS / 0 /
      DATA PHUNIT/0.07479983/
      COMMON /CLGVRN/ NVRSN(20)
      DATA NVCODE/478110108/
      NVRSN(9) = NVCODE
C
      IHEAD = IDATA( IBLN('HEAD') )
      NRUN = HDATA(2*IHEAD+10)
C
      ICALLS = ICALLS + 1
      IF ( ICALLS .EQ. 1  .AND.  NRUN .GT. 100  .AND.
     +    HNORML .LT. 11000 ) PRINT 2732, HNORML
 2732 FORMAT (/T2,' JADELG.LOAD (LGCLPB) VERSION OF 06.04.88.',
     +    ' HNORML=', I6,' => CALIBRATION CORRECTION WILL BE APPLIED'/)

      IF ( ICALLS .EQ. 1  .AND.  NRUN .GT. 100  .AND.
     +    HNORML .GT. 11000 ) PRINT 2733, HNORML
 2733 FORMAT (/T2,' JADELG.LOAD (LGCLPB) VERSION OF 06.04.88.',
     +   ' HNORML=',I6, ' => BBLEAK CORRECTION WAS ALREADY DONE'/)

      IF ( ICALLS .EQ. 1  .AND.  NRUN .LT. 100 ) PRINT 2734
 2734 FORMAT (/T2,' JADELG.LOAD (LGCLPB) VERSION OF 06.04.88',
     +    ' CALLED FOR MC-DATA'/)
C
C
      ZSTEP=ZWID(1)+ZGAP(1)
      Z0=ZEND(1)+0.5*ZWID(1)
C
      IF(NCLBRL.LE.0) RETURN
      N2=NCLBRL
      IF(N2 .GT. MAXCLS) N2=MAXCLS
        DO 1 N=1,N2
        ICLSPR(1,N) = 0
C
        NS = HMAPCL(1,N)
        NL = HMAPCL(2,N)
        WSUM = 0.
        IDO = HLGADC(1,NS)
        IPHO = IDO/32
        NPMIN = 42
C----   CLEAR Y
        CALL SETSL(Y,0,848,0)
        KK=NL-NS+1
C---    CHECK NO.OF HITS IN THE CLUSTER
        IF(KK.LE.50) GO TO 3
        KK = 50
C
    3     DO 2 NN=NS,NL
          ID = HLGADC(1,NN)
          IPH = ID/32
          IZ = ID-32*IPH
C
C----     ANGLE PHI IS CONSIDERED WITH RESPECT TO THE FIRST BLOCK
C         TO AVOID ANGLE UNCERTAINTY.
          IPHD = IPH-IPHO
          IF(IPHD.GT.42) IPHD = IPHD-84
          IF(IPHD.LE.-42) IPHD = IPHD+84
          NPHD = IPHD+42
C----     CHECK THE MIN.PHI COUNTER #.
          IF(NPHD.LT.NPMIN) NPMIN = NPHD
C
C----     PULSE HEIGHT OF THE NN-TH HIT IS CALIBRATED IN MEV.
C
          W = HLGADC(2,NN)
C
C----     ADD W
          WSUM = WSUM+W
C
          IF(W) 90,9,9
C----     NEGATIVE ENERGY,   CLEARED TO PROTECT 'LGEIGN'.
   90     AMSGVL(1) = W
          CALL LGMESG( 6, 2)
          W = 0.
C
C
C----   FILL ARRAYS FOR CLUSTER SHAPE ANALYSIS
   9      NM=NN-NS+1
          IF(NM.GT.50) GO TO 4
          WW(NM)=W
          ZZ(NM)=IZ*ZSTEP+Z0
          XX(NM)=IPHD*PHUNIT*RADIUS(3)
C
C----     CHECK CORNER HIT
    4     CALL LGCRNR( 0, IZ, IPHI, ICLS)
          IF(ICLS.EQ.1) CLSPRP(15,N)=CLSPRP(15,N)+W
C
    2 CONTINUE
C
C  ===============================================================
C
C   CHANGED 24/04/87 D.PITZL:
C
C   CORRECTION FOR BHABHA LEAKAGE IN CALIBRATION DONE FOR EVERY BLOCK
C                                        LOOP OVER ALL BLOCKS IN CLUSTER
C---                 HNORML = 22000 => BBLEAK ALREADY PERFORMED
C---                 HNORML = 10000 => NEW LG-CALIBRATION
      IF ( NRUN .LT. 100  .OR. HNORML .GT. 11000 ) GOTO 7083
      WSUM = 0.0
      DO 7082 NN = NS,NL
         ID = HLGADC(1,NN)
         IPH = ID/32
         IZ = ID-32*IPH
         W = HLGADC(2,NN)
         RBBLK = 0.0
         CALL BBLEAK ( IZ, RBBLK )
         W = W * ( 1. - RBBLK )
         WSUM = WSUM + W
         HLGADC(2,NN) = W
 7082 CONTINUE
C---               CHANGE ALGN-BANK-DESCRIPTOR WORD TO INDICATE THAT
C                  CALIBRATION CORRECTION WAS PERFORMED:
      HNORML = HNORML + 12000
C
 7083 CONTINUE
C
C END CHANGE ====================================================
C
C
C----   CHANGE ENERGY UNIT TO GEV.
        WSUM = WSUM*0.001
C----   CALCULATE EIGENVALUES AND 3.MOMENTS OF CLUSTER
        CALL LGEIGN(0.)
C       CHANGE SIGZ AND SIGPH IN LINEAR DIMENSION.(Y.WATANABE 8/9/79)
        IF(SIGZ.GT.0.) SIGZ=SQRT(SIGZ)
        IF(ABS(AVZ-ZZ(1)).LT.0.1) SIGZ=ZWID(1)/3.4641
C       (IF ONLY ONE ROW OF THAT DIMENSION FIRE,
C       SIGMA=COUNTER WIDTH/2/SQRT(3).
        IF(SIGPH.GT.0.) SIGPH=SQRT(SIGPH)/RADIUS(3)
        IF(ABS(AVPH-XX(1)).LT.0.1) SIGPH=PHWID(1)/3.4641/RADIUS(3)
C
C----   CALCULATE SIG(ENERGY)
        CALL LGEERR(0,WSUM,SIGENG)
        CLSPRP(2,N) = WSUM
        CLSPRP(3,N) = SIGENG
        CLSPRP(4,N) = AVPH/RADIUS(3)+IPHO*PHUNIT+0.5*PHUNIT
        CLSPRP(5,N) = AVZ
        CLSPRP(6,N) = SIGPH
        CLSPRP(7,N) = SIGZ
        CLSPRP(12,N)=EW(2)/EW(1)
        CLSPRP(13,N)=EW(1)+EW(2)
        CLSPRP(14,N)=EV
        CLSPRP(15,N)=0.001*CLSPRP(15,N)/WSUM
C
        ETOT(2) = ETOT(2)+WSUM
C
    1   CONTINUE
      RETURN
      END
