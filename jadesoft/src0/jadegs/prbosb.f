C   01/03/80 003061155  MEMBER NAME  PRBOSB   (JADEGS)      FORTRAN
      SUBROUTINE PRBOSB(IPOINT)
      IMPLICIT INTEGER*2 (H)
#include "cdata.for"
      WRITE(6,100) IDATA(IPOINT-3)
  100 FORMAT(1H0,'BANK ',A4,' INTEGER*2, INTEGER*4 AND REAL*4',//)
      LENG=IDATA(IPOINT)
      IPNH=2*IPOINT
      LENH=2*LENG
      WRITE(6,101) (HDATA(IPNH+LHO-8),LHO=1,8)
  101 FORMAT(1X,I12,7I6)
      LINES=1+(LENH-1)/20
      DO 1 LINE=1,LINES
      LIML=20*(LINE-1)+1
      LIMU=20*LINE
      IF(LIMU.GT.LENH) LIMU=LENH
      WRITE(6,102) LIML,(HDATA(IPNH+LHO),LHO=LIML,LIMU)
  102 FORMAT(1X,I6,I12,19I6)
    1 CONTINUE
      WRITE(6,103) (IDATA(IPOINT+LHO-4),LHO=1,4)
  103 FORMAT(1H0,4I12,/)
      LINES=1+(LENG-1)/10
      DO 2 LINE=1,LINES
      LIML=10*(LINE-1)+1
      LIMU=10*LINE
      IF(LIMU.GT.LENG) LIMU=LENG
      WRITE(6,104) LIML,(IDATA(IPOINT+LHO),LHO=LIML,LIMU)
  104 FORMAT(1X,I6,10I12)
    2 CONTINUE
      WRITE(6,103) (IDATA(IPOINT+LHO-4),LHO=1,4)
      LINES=1+(LENG-1)/10
      DO 3 LINE=1,LINES
      LIML=10*(LINE-1)+1
      LIMU=10*LINE
      IF(LIMU.GT.LENG) LIMU=LENG
      WRITE(6,105) LIML,(ADATA(IPOINT+LHO),LHO=LIML,LIMU)
  105 FORMAT(1X,I6,10E12.4)
    3 CONTINUE
      RETURN
      END
