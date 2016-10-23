C   12/03/84 412041858  MEMBER NAME  PEDFX2   (S)           FORTRAN
C
C
C
C
C
C
C
      SUBROUTINE TAGPD1
C
C ROUTINE TO SUBTRACT PEDESTALS - 1981/1982
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
#include "cwktag.for"
       INTEGER*4 TEST(64)/  3,4,6,7 ,5,8,9,12 ,10,11,13,14 ,15,16,17,1
     *             ,19,20,22,23 ,21,24,25,28 ,26,27,29,30 ,31,32,1,2
     *             ,33,34,63,64 ,35,36,38,39 ,37,40,41,44 ,42,43,45,46
     *             ,47,48,49,50 ,51,52,54,55 ,53,56,57,59 ,58,59,61,62/
       VALUE  = 800.0
       APICKM = 0.0
       APICKP = 0.0
       NUMM   = 0
       NUMP   = 0
C
C
C
C
C 1/4 OF A TAGGING SYSTEM =
C
C                               ___________
C                               I    I    I
C                     __________I    I    I
C                     I    I    L____L____I
C                     I    I    I    I    I
C                     L____L____I    I    I
C                     I    I    L____L____I
C                     I    I    I
C                  ___L____L____I
C                  I    I    I
C                  I    I    I
C                  L____L____I
C                  I    I    I
C                  I    I    I
C                  L____L____I__
C                     I    I    L
C                     I    I    I__________
C                     L____L____I    I    I
C                     I    I    L    I    I
C                     I    I    I____L____I
C                     L____L____I    I    I
C                               I    I    I
C                               L____L____I
C
C   'SUPERBLOCK' =
C
C                  ___________
C                  I    I    I
C                  I    I    I
C                  L____L____I
C                  I    I    I
C                  I    I    I
C                  L____L____I
C
C

C
C LOOP OVER ALL 'SUPERBLOCKS' (SET OF FOUR BLOCKS) IN -Z TAGGER
C
       DO 10 I = 1,32,4
C
          K = I + 3
C
C LOOP OVER ALL MEMBERS OF SUPERBLOCK
C
          DO 20 J = I,K
             ITEST = TEST(J)
C
C      TEST FOR GREATER THAN 'VALUE'
C
             IF ( CATAG(ITEST) .GT. VALUE ) GOTO 10
   20     CONTINUE
C
C   NONE OF THE BLOCKS IN THE SUPERBLOCK UNDER TEST HAVE FAILED
C   TO BE LESS THAN 800,SO ANY HITS MUST BE PEDESTALS
C
          DO 30 L = I,K
             ITEST = TEST(L)
             IF ( CATAG(ITEST) .EQ. 0 ) GOTO 30
             APICKM = APICKM+CATAG(ITEST)
             NUMM = NUMM + 1
   30     CONTINUE
   10  CONTINUE
C
C NOW PLUS ZED
C
       DO 11 I = 33,64,4
C
          K = I+3
          DO 21 J = I,K
             ITEST = TEST(J)
             IF ( CATAG(ITEST) .GT. VALUE ) GOTO 11
   21     CONTINUE
C
C   NONE OF THE BLOCKS IN THE SUPERBLOCK UNDER TEST HAVE FAILED
C   TO BE LESS THAN 800
C
          DO 31 L = I,K
             ITEST = TEST(L)
             IF ( CATAG(ITEST) .EQ. 0 ) GOTO 31
             APICKP = APICKP+CATAG(ITEST)
             NUMP = NUMP + 1
   31     CONTINUE
   11  CONTINUE
C
C    CALCULATE THE MEAN NON ZERO PEDESTAL
C
       IF ( NUMM .EQ. 0 ) GOTO 50
       APICKM = APICKM/NUMM
C
C NOW WE HAVE THE VALUES APICKP AND APICKM TO BE SUBTRACTED
C  DO THE SUBTRACTION
C
       IF ( NUMM .LE. 4 ) GOTO 50
       DO 40 I = 1,32
          IF ( CATAG(I) .EQ. 0 ) GOTO 40
          CATAG(I) = CATAG(I) - APICKM
          IF ( CATAG(I) .LT. 0) CATAG(I) = 0
   40  CONTINUE
C
C
   50  IF ( NUMP .EQ. 0 ) GOTO 41
       IF ( NUMP .LE. 4 ) GOTO 41
C
       APICKP = APICKP/NUMP
C
       DO 41 I = 33,64
          IF ( CATAG(I) .EQ. 0 ) GOTO 41
          CATAG(I) = CATAG(I) - APICKP
          IF ( CATAG(I) .LT. 0) CATAG(I) = 0
   41  CONTINUE
C
C
        RETURN
        END
