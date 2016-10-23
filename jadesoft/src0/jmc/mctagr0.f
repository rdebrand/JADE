C   24/08/85 508251307  MEMBER NAME  MCTAGR   (S)           FORTRAN
C
      SUBROUTINE MCTAGR
C
C
C
C ONCE PER EVENT SIMULATE FLUCTATING PEDESTALS
C + ANYTHING ELSE THAT MAY OCCUR ONCE PER EVENT
C    E.G. RANDOM NOISE
C
C SKIP THIS FOR 79/80 - PEDESTAL TREATMENT DIFFERENT IN
C ANALYSIS - I.E. CANT DO IT ON EVENT BY EVENT BASIS
C
      IMPLICIT INTEGER*2 (H)
#include "cmctag.for"
C
      DATA AVRGE/5.0/
C
      IF(MARKMC.EQ.1)GOTO 1000
C
C  INTODUCE RANDOM NOISE
C
C
      CALL NVERT(2.0,AVRGE,ANUM)
      NUM = NINT(ANUM)
      ANCHAN = NCHANS-1
C     WRITE(6,601)NUM,NCHANS,ANCHAN
 601  FORMAT(' NUM,NCHANS,ANCHAN ',I5,I5,F8.2)
      IF(NUM.EQ.0)GOTO 351
C
       DO 35 I = 1,NUM
        IBLOCK = NINT(RN(DUMMY)*ANCHAN) + 1
        CALL NVERT(10.0,0.0,RANCH)
 35     HGG(IBLOCK)=HGG(IBLOCK)+RANCH
351   CONTINUE
C
C NOW IMITATE FLUCTUATING PEDESTALS
C CHOOSE THE MEAN SIZE OF THE NOISE *CALIB-SO ITS RIGHT WHEN MCTAGS
C    DIVIDES BY CALIB
C
       AVPED=10.0*CALIBS
       CALL NVERT(AVPED,0.0,RMEAN)
C
C          GENERATE RANDOM PEDESTAL:  MEAN OF AVPED +/- 3 CHANNELS
C
       DO 36 I = 1,NCHANS
              CALL NVERT(3.0,RMEAN,APED)
36            HGG(I)=HGG(I)+NINT(APED)
C
1000    RETURN
        END
