C   07/06/96 606071857  MEMBER NAME  NBK      (S4)          FORTRAN
      FUNCTION NBK(NA,NB,NC)
C     BOS SUBPROGRAM
#include "acs.for"
      COMMON/BCS/IW(1)
#include "star.for"
      CALL NOARG(M)
      IND=0
      IW(INAMV)=NAME
      LFDI=MOD(IABS(NAMEV),NPRIM)+NAMAX1
    1 LFDI=IW(LFDI+IPLST)
      IF(IW(LFDI+INAMV).NE.IW(INAMV)) GOTO 1
      IF(LFDI.EQ.0) LFDI=IBLN(IW(INAMV))
      LFDK=LFDI+1
      LFDI=IW(LFDI)
      IF(M.GT.1) GOTO 3
      IND=LFDI
      GOTO 100
    2 LFDK=LFDI
      LFDI=IW(LFDI-1)
    3 IF(LFDI.EQ.0)        GOTO    10
      IF(IW(LFDI-2).LT.NR) GOTO 2
      IF(IW(LFDI-2).GT.NR) GOTO    10
      IND=LFDI
C     FOUND
      IF(M.EQ.2) GOTO 100
      NN=0
      IF(NC.LT.0) GOTO 20
      NN=NC-IW(IND)
      IF(NN) 11,100,12
   11 IF(IND+IW(IND)+1.EQ.NEXT) GOTO 20
      IF(NN.GT.(-4)) GOTO 20
C     INSERT DUMMY
      GOTO 100
C     NOT FOUND
   10 IF(M.EQ.2) GOTO 100
      IF(NC.LT.0) GOTO 100
      NN=NC+4
      IF(NEXT+NN.GE.NLST) GOTO 200
      INAME=NAME
      IF(NOTLOW(XNAME)) GOTO 40
      IF(NCPL+NN.GE.NSPL) GOTO 200
   30 NCPL=NCPL+NN
   40 IER=0
      IND=NEXT+3
      IW(IND-3)=NAME
      IW(IND-2)=NR
      IW(IND)=NW
      ISV=IW(LFDK-1)
      IW(LFDK-1)=IND
      IW(IND -1)=ISV
      IF(NW.GT.0) CALL VZERO(IW(IND+1),NW)
      NEXT=NEXT+NN
   50 LIND=IND
C
C     MOVE
   22 CALL UCOPY(IW(IND-3),IW(NEXT),NW)
      IW(IND)=-NN
      ILOW=MIN0(ILOW,IND)
      IND=NEXT+3
      NEXT=NEXT+NW
      IW(LFDK-1)=IND
      NFRE=NFRE+NW
  100 RETURN
  101 RETURN 1
      END
