C   07/06/96 606071828  MEMBER NAME  BREAD    (S4)          FORTG1
      SUBROUTINE BREAD(IUN,*,*)
C     BOS SUBPROGRAM =3.1=
      COMMON/BCS/IW(1)
   10 CALL BRDS(IUN,NBUFL,INIR)
      IF(INIR.EQ.0) GOTO 100
      CALL BFRD(IUN,IW(INIR),IW(INIR+1))
      IF(IW(INIR)) 102,101,10
  100 RETURN
  101 RETURN 1
  102 RETURN 2
      END
