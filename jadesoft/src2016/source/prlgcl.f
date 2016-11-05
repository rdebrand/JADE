C   11/03/79 006140243  MEMBER NAME  PRLGCL   (JADELGS)     FORTRAN
      SUBROUTINE PRLGCL
C
C     S.YAMADA    19-01-79   10:15
C     LAST MODIFICATION  11-09-79  22:00  Y.WATANABE
C
C---- PRINT THE BANK LGCL.
C
      IMPLICIT INTEGER *2 (H)
C
      COMMON /BCS/ IDATA(2)
      DIMENSION  ADATA(2), HDATA(2)
      EQUIVALENCE  (ADATA(1),IDATA(1)), (HDATA(1),IDATA(1))
C
C---- CONTENTS OF THE BUFFER FOR EACH CLUSTER
C
C     IDATA(NPCLS+1)=JBC, 0 FOR BARREL, -1 FOR BOTTOM, 1 FOR TOP
C     ADATA(NPCLS+2)=CLUSTER ENERGY IN GEV
C     ADATA(NCLST+3)=SIGMA(ENERGY)
C     ADATA(NPCLS+4)=WEIGHTED AVERAGE PHI
C     ADATA(NPCLS+5)=WEIGHTED AVERAGE Z
C     ADATA(NPCLS+6)=SIGMA PHI (WEIGHTED)
C     ADATA(NPCLS+7)=SIGMA Z (WEIGHTED)
C     IDATA(NPCLS+8)=NUMBER OF CORRESPONDING INNER TRACKS
C     ADATA(NPCLS+9-11)=DIRECTION COSIGNS CORRECTED FOR SHOWER DEPTH.
C     ADATA(NPCLS+12-14)=CLUSTER STRUCTURE,ELLIPS EIGENVALUES.
C
C---- FIX POINTERS FOR CLUSTER DATA
      DATA INITP/0/
      IF(INITP.GT.0) GO TO 5
      INITP=1
      IPCL= IBLN('LGCL')
5     CONTINUE
C     CALL BLOC( NPCL,'LGCL',1, &90)
      NPCL=IDATA(IPCL)
      IF(NPCL.LE.0) GO TO 90
      NPCGI = NPCL+IDATA(NPCL+1)-1
      NPCMP = NPCL+IDATA(NPCL+2)-1
      NNPCMP = 2*NPCMP
      NPCLS = NPCL+IDATA(NPCL+3)-1
C---- GET NO.OF WORDS FOR EACH CLUSTER.
      LSTEP = IDATA(NPCGI+21)
C
C---- GET NO.OF CLUSTERS
      NCLST = IDATA(NPCGI+3)
C
C---- WRITE THE GENERAL INF.
      K1 = NPCGI+1
      K6 = NPCGI+6
      K7 = NPCGI+7
      K10 = NPCGI+10
      K11 = NPCGI+11
      K12 = NPCGI+12
      K15 = NPCGI+15
      K16 = NPCGI+16
      K20 = NPCGI+20
      K21 = NPCGI+21
      WRITE(6,600) NPCL, (IDATA(K),K=K1,K6),(ADATA(K),K=K7,K10),
     $           IDATA(K11),  (ADATA(K),K=K12,K15),(IDATA(K),K=K16,K21)
  600 FORMAT('0===== LG-CLUSTERS =====  (NPCL=',I5,')    PROG.VERSION=',
     1        I2,'  DATE&TIME=',I9,'  ====================',
     2        /' NCLST=',4I5,'  ENERGY=',4F8.3,'    NG=',I3,'  E-GAM=',
     3        4F8.3,/'   FLAGS=',5I8,'  WORDS/CLUST=',I4)
C
C
C---- ADC-MAP FOR EACH CLUSTER
      K1 = NNPCMP+1
      KE = K1+2*NCLST
      WRITE(6,601) (HDATA(K),K=K1,KE)
  601 FORMAT(' LG-ADC MAP AFTER CLUSTER ANALYSIS',
     $               /' ',(10(I4,'-',I4,',  ')))
C
C
C---- CLUSTER INFORMATION
      KB = NPCLS
      IF(NCLST.LE.0) RETURN
      THE = 0.
      PHI = 0.
C
C---- TITLE
      WRITE(6,603)
  603 FORMAT('  I N J',/'  N B B ENERGY   +/-   PHI/X',5X,'Z/Y',
     1 ' +-PHI/X',3X,'+-Z/Y TRK   THE   PHI   COSX   COSY   COSZ',
     2 5X,'ELLIPS EIGENVALUES',3X,'EDGE',3X,'EUNC',/,'  D L C')
        DO 10 N=1,NCLST
C       NO.OF COUNTERS
        NCNT = HDATA(NNPCMP+2*N)-HDATA(NNPCMP+2*N-1)+1
        K1 = KB+1
        K2 = KB+2
        K7 = KB+7
        K8 = KB+8
        K9 = KB+9
        K14 = KB+14
        K16 = KB+16
C
        IF(IDATA(NPCGI+17).LT.2) GO TO 1
        THE = ARCOS(ADATA(KB+11))*57.2958
        PHI = ATAN2( ADATA(KB+10),ADATA(KB+9))*57.2958
C
    1   WRITE(6,602) N,NCNT,IDATA(K1),(ADATA(K),K=K2,K7),IDATA(K8),
     &               THE,PHI, (ADATA(K),K=K9,K16)
  602   FORMAT(' ',3I2,F7.3,F6.3,4F8.2,I4,2F6.1,3F7.4,3(1PE8.1),
     1    2(0PF7.3))
        KB = KB+LSTEP
   10   CONTINUE
      RETURN
C
   90 WRITE(6,690)
  690 FORMAT('0 ***** ''LGCL'' IS NOT FOUND ****',/)
      RETURN
      END
