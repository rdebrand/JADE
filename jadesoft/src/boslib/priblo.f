C   07/06/96 606071903  MEMBER NAME  PRIBLO   (S4)          FORTG1
      SUBROUTINE PRIBLO(N)
C
C     PRINT ONE EVENT, IF NUMBER OF PRINTED EVENTS
C                      LESS THAN ARGUMENT N
C
      INTEGER M/0/
      IF(M.GE.N) RETURN
      M=M+1
      CALL BSLT
      CALL BPRM
      RETURN
      END