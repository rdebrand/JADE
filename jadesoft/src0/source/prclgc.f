C   20/01/79 C9092001   MEMBER NAME  PRCLGC   (SOURCE)      FORTRAN
      SUBROUTINE PRCLGC
C
C      S.YAMADA   20-01-79   23:05
C     LAST MODIFICATION   10-08-79  05:55
C
C     PRINT THE COMMON BLOCK /CLGCHG/
C
      IMPLICIT INTEGER * 2 (H)
#include "clgwork2.for"
      COMMON /CLGCHG/ NCHIND,NSTEP,CXDCHG(9,100)
      DIMENSION JBCCHG(9,100)
      EQUIVALENCE (CXDCHG(1,1),JBCCHG(1,1))
C---- NCHIND=NO. OF CHARGED PARTICLES DETECTED BY THE INNER DET.
C---- NSTEP=1:TRACING FOR THE L.G. COUNTERS,   =2:TRACED FURTHER.
C---- CXDCHG  CONTAINS INNER TRACK INFORMATION
C     JBCCHG(1,N)     HITTING PART
C     CXDCHG(2,N)     CHARGE
C     CXDCHG(3-5,N)   HITTING POSITION ON THE COILOR ON THE END CAP
C     CXDCHG(6-8,N)   DIRECTION COSIGNS
C     CXDCHG(9,N)     ABSOLUTE MOMENTUM
C
      WRITE(6,600) NCHIND
  600 FORMAT('0DUMP OF CLGCHG,    NCHIND=',I5,/,5X,'N  JBC CHARGE',10X,
     $  'X,Y,Z',20X,'DX,DY,DZ',5X,'PABS',5X,'LG CONNECTIONS')
        DO 1 NNN=1,NCHIND
        WRITE(6,601) NNN,JBCCHG(1,NNN),(CXDCHG(MM,NNN),MM=2,9),
     $  (HCLIST(K,NNN),K=1,4)
  601   FORMAT(' ',2I5,F5.1,3X,3F7.1,3X,4F7.4,3X,4I5)
    1   CONTINUE
      RETURN
      END