C   22/03/84           MEMBER NAME  ANATA2   (S)           FORTRAN
C   14/03/84 403221749  MEMBER NAME  ANATAG   (S)           FORTRAN
C
C SPECIAL DUMMY VERSION OF ANATAG WRITTEN BY A.J.FINCH
C
      SUBROUTINE ANATAG(IER)
C
      DATA ICOUNT/0/

#include "cwktag.for"
C
       IF(ICOUNT.GT.5)RETURN
       ICOUNT = ICOUNT + 1
       WRITE(6,600)
 600   FORMAT(/,/,' ***********************WARNING********************'
     1,/,'  YOU HAVE CALLED A DUMMY VERSION OF ANATAG WHICH WILL DO '
     1,/,'  NO ANALYSIS OF TAGGING INFORMATION FOR 1979 80 JADE DATA '
     1,/,'  '
     1,/,' IF YOU REALLY WANT TO DO THIS ANALYSIS HOWEVER YOU SHOULD '
     1,/,' INCLUDE THE FOLLOWING IN YOUR SOURCE '
     1,/,' SUBROUTINE ANATAG(IER) '
     1,/,' CALL ANAL79(IER) '
     1,/,'   RETURN   '
     1,/,'  END       '
     1,/,'  IF YOU TRY IT -- GOOD LUCK ! YOU ARE BETTER OF USING'
     1,/,'  1981 AND LATER DATA  '
     1,/,'  1979 / 80 STUFF WAS PLAGUED BY PEDESTAL PROBLEMS '
     1,/,'   '
     1,/,' PLEASE SEE JADE COMPUTER NOTE 74 FOR MORE DETAILS '
     1,/,'   '
     1,/,'  THIS MESSAGE WILL BE REPEATED 5 TIMES '
     1,/,'  A.J.FINCH 22/3/84 ',/,/,/)
C      CALL ANAL79(IER)
C
       RETURN
       END
