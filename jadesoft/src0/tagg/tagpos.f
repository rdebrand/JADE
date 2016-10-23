C   07/12/84 412071452  MEMBER NAME  TAGPOS   (S)           FORTRAN
C
C
C
C
C
C
       SUBROUTINE TAGPOS(SUM,ISHALL)
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
       IF ( MARK .EQ. 1 ) CALL TAGPS1(SUM,ISHALL)
       IF ( MARK .EQ. 2 ) CALL TAGPS2(SUM,ISHALL)
       RETURN
       END
