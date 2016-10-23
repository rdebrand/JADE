C   11/03/79 202131145  MEMBER NAME  LGCLSD   (SOURCE)      FORTRAN
      SUBROUTINE LGCLSD(MAP)
C
C     S.YAMADA    19-01-79   10:15
C     LAST MODIFICATION  11-09-79  02:00 Y.WATANABE
C
C---- PRINT THE LG-CLUSTER ANALYSIS RESULT
C     IF(MAP.EQ.0), CLUSTER MAP IS PRINTED.
C
      IMPLICIT INTEGER *2 (H)
C
#include "clgwork1.for"
C
      DIMENSION  HMAPC1(162)
      EQUIVALENCE  (HMAPC1(1),HMAPCL(1,1))
C
C---- CONTENTS OF THE BUFFER FOR EACH CLUSTER
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
C     ICLSPR(15,I)=MARK FOR CORNER HIT:# OF EDGE COUNTERS IN THE CLUSTER
C     CLSPRP(16,I)=ENERGY IN GEV (ORIGINAL ENERGY STORAGE)
C
C
C---- WRITE THE GENERAL INF.
C
      WRITE(6,600) IDENT,NCLST,NCLBEC,ETOT,NNEUT,EGAM,IFLAG,NWPCL
  600 FORMAT('0===== LG-CLUSTERS =====    PROG.VERSION=',I2,
     1   '  DATE&TIME=',I9,'  ====================',
     2        /' NCLST=',4I5,'  ENERGY=',4F8.3,'    NG=',I3,'  E-GAM=',
     3        4F8.3,/'   FLAGS=',5I8,'  WORDS/CLUST=',I4)
C
C
C---- ADC-MAP FOR EACH CLUSTER
      IF(MAP.EQ.0) GO TO 2
      KE = (NCLST+1)*2-1
      WRITE(6,601) (HMAPC1(K),K=1,KE)
  601 FORMAT(' LG-ADC MAP AFTER CLUSTER ANALYSIS',
     $           /' ',(10(I5,'-',I4,', ')))
C
C
C---- CLUSTER INFORMATION
    2 IF(NCLST.LE.0) RETURN
      THE = 0.
      PHI = 0.
C
C---- TITLE
      WRITE(6,603)
  603 FORMAT('  I N J',/'  N B B ENERGY  +/-    PHI/X',7X,'Z/Y',5X,
     1  '+-PHI/X', 3X,' +-Z/Y    TRK   THE   PHI COSX   COSY   COSZ',
     2  '     ELLIPS EIGENVALUES       EDGE',   /'  D L C')
C
        DO 10 N=1,NCLST
C----   NO.OF HITS IN THE CLUSTER
        NCNT = HMAPCL(2,N)-HMAPCL(1,N)+1
C
        IF(IFLAG(2).LT.2) GO TO 1
        THE = ARCOS(CLSPRP(11,N))*57.2958
        PHI = ATAN2( CLSPRP(10,N),CLSPRP(9,N))*57.2958
C
    1   WRITE(6,602) N,NCNT,ICLSPR(1,N),(CLSPRP(K,N),K=2,7),ICLSPR(8,N),
     &               THE,PHI, (CLSPRP(K,N),K=9,14),CLSPRP(15,N)
  602   FORMAT(' ',I2,2I2,F7.3,F6.3,2E11.3,2E10.3,I4,
     1                          2F6.1, 3F7.4,1P3E10.2,0PI2)
   10   CONTINUE
      RETURN
      END
