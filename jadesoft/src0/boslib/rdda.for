C   07/06/96 606071906  MEMBER NAME  RDDA     (S4)          FORTG1
      SUBROUTINE RDDA(NRC,NTOT,BUF)
C     BOS SUBPROGRAM  =4.6=
      COMMON/BCS/IW(1)
#include "ccs.for"
      INTEGER BUF(1610),BUFA(NTOT)
      IG=IUND-16
      GOTO (1,2,3),IG
    1 CONTINUE
      DEFINE FILE 17(200,1610,U,IVAR)
      GOTO 10
    2 CONTINUE
      DEFINE FILE 18(200,1610,U,IVAR)
      GOTO 10
    3 CONTINUE
      DEFINE FILE 19(200,1610,U,IVAR)
   10 READ(IUND'NRC) NTOT,BUF
      GOTO 100
C
      ENTRY WRDA(NRC,NTOT,BUFA)
      IF(NTOT.NE.0) WRITE(IUND'NRC) NTOT,BUFA
      IF(NTOT.EQ.0) WRITE(IUND'NRC) NTOT,NTOT
      GOTO 100
C
      ENTRY RDSQ(IUNTP,NTOT,BUFA,*)
      READ(IUNTP,END=101) NTOT,BUFA
      GOTO 100
C
      ENTRY WRSQ(IUNTP,NTOT,BUFA)
      WRITE(IUNTP) NTOT,BUFA
C
  100 RETURN
  101 RETURN 1
      END