C   12/07/79 C9090201   MEMBER NAME  USERTM   (SOURCE)      FORTRAN
C
      SUBROUTINE USERTM
C
C
C    Y. TOTSUKA  12. 7. 1979
C
C---- CHECK TIME OUT
C
      WRITE(6, 6000)
 6000 FORMAT(' ', 10('='), ' PRINT FROM USERTM', 10('='))
C////////DUMP LAST EVENT//////////
      DATA IUN/2/
        CALL BMLT(0, DUMMY)
        CALL BFIXP
C       CALL BWRITE(IUN)
      CALL BPRS('PATR', 10)
      CALL HPRS('HEAD', 0)
      WRITE(6, 6000)
      RETURN
      END
