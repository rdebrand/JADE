C   10/04/80 311291221  MEMBER NAME  ERRMSG   (S)           FORTRAN
      SUBROUTINE ERRMSG(MSG,*)
C
C     PRINTOUT OF RUN + EVENT # MASSAGE
C     A. SATO
C
      IMPLICIT INTEGER*2 (H)
      LOGICAL * 1 MSG(1) ,CH1,CH2,CH3
      DATA CH1/';'/,CH2/'$'/,CH3/'^'/
C
#include "cheadr.for"
      LOGICAL*1 LBREAD
      COMMON /CADMIN/ IEVTP,NRREAD,NRWRIT,NRERR,LBREAD(4),IFLG
      EQUIVALENCE (HHEADR(18),HRUN) , (HHEADR(19),HEV)
      II=0
       DO 10 I=1,100
         IF(MSG(I).EQ.CH1) GOTO 11
         IF(MSG(I).EQ.CH2) GOTO 11
         IF(MSG(I).EQ.CH3) GOTO 11
10      CONTINUE
        I=100
11      CONTINUE
        I=I-1
C
      PRINT 2002
 2002 FORMAT(1X,' PRINT OUT FROM ERRMSG A POSSIBLE SOURCE IS TRLGL')
      PRINT 2001, NRREAD,HRUN,HEV ,(MSG(J),J=1,I)
 2001 FORMAT(1X,I6,' TH EVENT. NRUN,NRRC ',2I6,2X,100A1)
      RETURN 1
      END
