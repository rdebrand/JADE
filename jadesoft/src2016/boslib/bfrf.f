C   07/06/96 606071812  MEMBER NAME  BFRF     (S4)          FORTG1
      SUBROUTINE BFRF(IUN,NTOT,BUFF)
C     BOS SUBPROGRAM =3.6=
C     ADDED 10.11.77 W. LUEHRSEN
      INTEGER BUFF(1608)
      READ(IUN,ERR=101,END=102) NTOT,BUFF
  100 RETURN
  101 NTOT=0
      READ(IUN,ERR=101,END=102)
      GOTO 100
  102 NTOT=-1
      GOTO 100
      END
