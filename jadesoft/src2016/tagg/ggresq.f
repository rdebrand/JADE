C   10/01/80 001111204  MEMBER NAME  GGRESQ   (S)           FORTRAN
      SUBROUTINE GGRESQ(NADC,NCLUS,*)
C---  CLEARS CONTENTS OF UNPHYSICAL BLOCKS
C---  (IF CONTENT BELOW CERTAIN THRESHOLD, AT THE MOMENT: 11)
C---  AND REORDERS POINTERS
C
C     H.WRIEDT     10.01.80    16:20
C     LAST MODIFICATION      11.01.80     12:00
C
      IMPLICIT INTEGER*2 (H)
C
      COMMON /CWORK/ IWORK1(42),LNG,HPOINT(4),HGGADC(2,192),IWORK2(263),
     &               ID,HTRACK(3),HCLST,HCLBEC(2),HNCLST,HCOL,HTYPE,HER,
     &               HCORR,HPBLAT,HDUMIN(2),HSCAL(36),HWORD(2),ACOLAN,
     &               ETOT(3),ENTOT(3),IWORK3(16),HCLMAP(2,51),
     &               CLSPRP(13,51)
C
      NADR = HGGADC(1,NADC)
      HGGADC(2,NADC) = 0
      LNG = LNG - 1
C---  CONTRACT HGGADC
C---  LAST FILLED ADC
      NFIN = HCLMAP(2,HCLST)
      IF (NADC.EQ.NFIN) GOTO 3
      NFIN = NFIN - 1
        DO 1 I = NADC,NFIN
        HGGADC(1,I) = HGGADC(1,I+1)
    1   HGGADC(2,I) = HGGADC(2,I+1)
      IF (HCLMAP(1,NCLUS).EQ.HCLMAP(2,NCLUS)) GOTO 3
      II = NADC - 2
      WRITE(6,600) ((HGGADC(K,J+II),K=1,2),J=1,3)
  600 FORMAT(/' ***** ERROR DETECTED IN GGRESQ, UNPHYSICAL CLUSTER',
     &        ' CONSISTS OF MORE THAN 1 BLOCK, LG ANALYSIS OF WHOLE',
     &        ' EVENT SKIPPED'/6(2X,I6))
      RETURN 1
C
C---  CORRECT HCLMAP
    3 IF (NCLUS.EQ.HCLST) GOTO 5
      NFIN = HCLST - 1
        DO 4 I = NCLUS,NFIN
        HCLMAP(1,I) = HCLMAP(1,I+1)
    4   HCLMAP(2,I) = HCLMAP(2,I+1)
C---  CORRECT HCLST AND HPOINT
    5 HCLST = HCLST - 1
      IF (HCLST.LE.0) RETURN 1
      HNCLST = HCLST
      IF (NADR.GT.96) GOTO 6
      HCLBEC(1) = HCLBEC(1) - 1
      HPOINT(2) = HPOINT(2) - 2
      GOTO 7
    6 HCLBEC(2) = HCLBEC(2) - 1
    7 HPOINT(3) = HPOINT(3) - 2
C
      NCLUS = NCLUS - 1
      RETURN
      END
