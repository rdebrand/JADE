C   07/06/96 606071834  MEMBER NAME  BSIN     (S4)          FORTG1
      SUBROUTINE BSIN(NRW,ICD)
C     BOS SUBPROGRAM =0.8=
#include "acs.for"
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (RW(1),IW(1))
      REAL FF/Z000000FF/
      EQUIVALENCE (INAME,XNAME)
      INTEGER ISTAR/Z0000005C/
      INTEGER IONE/1/
      EQUIVALENCE (IONE,ONE)
C     CREATE POINTER FOR NEW BANKS
    2 ICD=0
      NRIN=NRIN+1
      IEB=0
      NEXTS=NEXT
      IF(NRW.LT.4) GOTO 81
      NS=0
      NTOT=NRW
C     CHECK BANK LENGTH AND GET INDEX FOR NAME
   10 LENG=IW(NEXT+3)
      IF(LENG.LT.0) GOTO 83
      LENG=LENG+4
      IF(LENG.GT.NTOT) GOTO 83
      LNAM=IW(NEXT)
      IW(INAMV)=LNAM
      LFDI=MOD(IABS(LNAM),NPRIM)+NAMAX1
    1 LFDI=IW(LFDI+IPLST)
      IF(IW(LFDI+INAMV).NE.IW(INAMV)) GOTO 1
      IF(LFDI.EQ.0) LFDI=IBLN(IW(INAMV))
      KL  =LFDI
      IF(NS.GE.NLIST) STOP 35
      NS=NS+1
      RW(IOLST+KL)=OR(RW(IOLST+KL),ONE)
      IW(ISLST+NS)=KL
      IW(IMLST+NS)=1
      IF(IW(KL).EQ.0) GOTO 50
C     BANK ALREADY THERE, CHECK THIS RECORD
      DO 4 IS=1,NS
      IF(IW(ISLST+NS).EQ.IW(ISLST+IS)) GOTO 6
    4 CONTINUE
      IS=NS
    6 IF(IS.EQ.NS) GOTO 12
C     IN THIS RECORD
      NS=NS-1
      I=KL+1
    8 I=IW(I-1)
      IF(IW(I-1).NE.0) GOTO 8
      IF(IW(I-2).GE.IW(NEXT+1)) GOTO 84
      K=I
      INAME=LNAM
      XNAME=AND(XNAME,FF)
      GOTO 60
C     DELETE BANKS OF THE SAME NAME
   12 IEB=1
   15 INAME=IW(INAMV+KL)
      XNAME=AND(XNAME,FF)
      LENGS=0
      I=IW(KL)
      IW(KL)=0
   20 LENG=4+IW(I)
      LENGS=LENGS+LENG
      IW(I)=-LENG
      NFRE=NFRE+LENG
      I=IW(I-1)
      IF(I.NE.0) GOTO 20
      LENG=IW(NEXT+3)+4
      IF(INAME.EQ.ISTAR) NCPL=NCPL-LENGS
      GOTO 50
C     CHECK LENGTH OF BANK
   30 LENG=IW(NEXT+3)
      IF(LENG.LT.0) GOTO 82
      LENG=LENG+4
      IF(LENG.GT.NTOT) GOTO 83
C     CHECK BANK NR
      IF(IW(NEXT+1)-IW(K-2)) 84,40,60
C     SAME, APPEND
   40 IW(K)=IW(K)+LENG-4
      CALL UCOPY2(IW(NEXT+4),IW(NEXT),NTOT-4)
      NEXT=NEXT+LENG-4
      IF(INAME.EQ.ISTAR) NCPL=NCPL+LENG-4
      GOTO 70
C     NEW NAME
   50 K=KL+1
      INAME=IW(INAMV+KL)
      XNAME=AND(XNAME,FF)
C     LARGER NR
   60 IW(K-1)=NEXT+3
      K=NEXT+3
      IW(K-1)=0
      NEXT=NEXT+LENG
      IF(INAME.EQ.ISTAR) NCPL=NCPL+LENG
C     CHECK COMPLETE RECORD
   70 NTOT=NTOT-LENG
      IF(NTOT.EQ.0) GOTO 90
      IF(NTOT.LT.4) GOTO 85
      IF(IW(NEXT).EQ.LNAM) GOTO 30
      GOTO 10
C     ERRORS
C     RECORD END WRONG
   85 ICD=ICD+1
C     WRONG ORDER IN BANK NR
   84 ICD=ICD+1
C     BANK LENGTH TO LARGE
   83 ICD=ICD+1
C     BANK LENGTH NEGATIVE
   82 ICD=ICD+1
C     RECORD LENGTH LESS THAN 4
   81 ICD=ICD+1
      NER(ICD)=NER(ICD)+1
   89 CALL BMLT(0,0)
      CALL BDLM
      NEXT=NEXTS
      NS=0
      GOTO 100
   90 IF(IEB.EQ.0) GOTO 100
      NER(10)=NER(10)+1
C
  100 RETURN
      END
