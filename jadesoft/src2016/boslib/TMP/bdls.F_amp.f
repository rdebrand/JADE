C   07/06/96 606071805  MEMBER NAME  BDLS     (S4)          FORTG1
      SUBROUTINE BDLS(NAME,NR)
C     BOS SUBPROGRAM =1.13=
#include "acs.for"
      COMMON/BCS/IW(1)
*** PMF      INTEGER IHELP(2)/'BNK '/
*** PMF 07/05/99
      INTEGER IHELP(2)/'BNK ','    '/
*** PMF (end)
#include "star.for"
      IW(INAMV)=NAME
      LFDI=MOD(IABS(NAME),NPRIM)+NAMAX1
    1 LFDI=IW(LFDI+IPLST)
      IF(IW(LFDI+INAMV).NE.IW(INAMV)) GOTO 1
      IF(LFDI.EQ.0) LFDI=IBLN(IW(INAMV))
      LFDK=LFDI+1
      LFDI=IW(LFDI)
      GOTO 3
    2 LFDK=LFDI
      LFDI=IW(LFDI-1)
    3 IF(LFDI.EQ.0)        GOTO    100
      IF(IW(LFDI-2).LT.NR) GOTO 2
      IF(IW(LFDI-2).GT.NR) GOTO    100
      NN=4+IW(LFDI)
      IW(LFDK-1)=IW(LFDI-1)
      IW(LFDI)=-NN
      IF(LFDI+NN-3.NE.NEXT) GOTO 4
C     LAST BANK
      NEXT=NEXT-NN
      GOTO 6
C     NOT LAST
    4 NFRE=NFRE+NN
      ILOW=MIN0(ILOW,LFDI)
C     LOW PRIORITY
    6 INAME=NAME
      IF(NOTLOW(XNAME)) GOTO 100
      NCPL=NCPL-NN
      GOTO 100
C
      ENTRY BPRS(NAME,NR)
      CALL BLOC(IND,NAME,NR,*100)
      ISAVE=IW(IND+1)
      IW(IND+1)=IND
      IHELP(2)=NA
      CALL UTP(IHELP,5,'NAME  NR PTR  NWINDX')
      CALL UWP(IW(IND-3),1,5)
      IW(IND+1)=ISAVE
      CALL UWP(IW(IND+1),1,IW(IND))
  100 RETURN
      END
