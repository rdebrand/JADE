C   07/06/96 606071857  MEMBER NAME  MSGPR    (S4)          FORTG1
      SUBROUTINE MSGPR
      character*8 WORD,LINE(16),BLANK/'        '/
      character*1 ALIST(9),LWORD(8),BLK/' '/,LIST(9,10)/90*' '/
      EQUIVALENCE (WORD,LWORD(1))
      INTEGER NL/0/
      IF(NL.EQ.0) GOTO 100
*xxx 09.01.98
      WRITE(*,'(''MSGPR:'')')
*xxx
      DO 30 N=1,NL
      WRITE(6,101)
      DO 20 LINENR=1,12
      DO 10 J=1,16
   10 LINE(J)=BLANK
*xxx 09.01.98     CALL BLKLET(LIST(1,N),LINENR,LINE,9)
*xxx      WRITE(6,101) LINE
      WRITE(*,'(2I3,2X,9L1)') N,LINENR,(LIST(IIII,N),IIII=1,9)
      PRINT *,LINENR,LINE,9
      PRINT *,LIST(1,N)
*xxx
   20 CONTINUE
      WRITE(6,101)
   30 CONTINUE
      DO 40 J=1,10
      DO 40 I=1,9
   40 LIST(I,J)=BLK
      NL=0
      GOTO 100
C
      ENTRY MSGTXT(ALIST)
      IF(NL.EQ.10) GOTO 100
      NL=NL+1
      DO 50 I=1,9
   50 LIST(I,NL)=ALIST(I)
      GOTO 100
C
      ENTRY MSGINT(NR,IA,IB)
      IF(NL.EQ.0) NL=1
      CALL ITODA(NR,WORD,-8)
      IL=IB
      IF(IL.GT.9) IL=9
      IF(IL.LT.1) IL=1
      NN=IB+1-IA
      NN=MIN0(NN,IL,8)
      NN=MAX0(NN,1)
      DO 60 I=1,NN
   60 LIST(IL+1-I,NL)=LWORD(9-I)
  100 RETURN
  101 FORMAT(3X,16A8)
      END
