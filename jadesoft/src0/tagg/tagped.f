C   12/03/84 412041858  MEMBER NAME  PEDFIX   (S)           FORTRAN
C
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       SUBROUTINE TAGPED
C
C
C ROUTINE TO DO PEDESTAL SUBTRACTION
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
#include "cwktag.for"
C
       IF ( MARK .EQ. 1 ) CALL TAGPD1
       IF ( MARK .EQ. 2 ) CALL TAGPD2
       RETURN
       END