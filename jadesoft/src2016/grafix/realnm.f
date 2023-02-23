C   05/05/79 109062131  MEMBER NAME  REALNM   (JADEGS)      FORTRAN
      SUBROUTINE REALNM(RNUM1,RNUM2,RNUM3,RNUM4)
C--
C-- READ REAL NUMBERS FROM SCREEN
C--
C--                                   LATEST CHANGE 06.09.81, (J.OLSSON)
C--
      IMPLICIT INTEGER*2 (H)
      DIMENSION HNUMB(10),HWORD(2)
CAV      COMMON/CWORK1/HWORK(40),HINN(80)
CAV   Let us inclrease the size
CAV but it must be a BUG
      COMMON/CWORK1/HWORK(40),HINN(140)
      EQUIVALENCE(HWORD(1),IWORD)
      DATA HBLANK/2H  /,HPOINT/2H ./,HMINUS/2H -/
      DATA HNUMB/2H 0,2H 1,2H 2,2H 3,2H 4,2H 5,2H 6,2H 7,2H 8,2H 9/
      INTEGER*8 IHIGH, HHIGH, HLOW
      DATA IHIGH/Z'FF000000'/,HHIGH/Z'FF00'/,HLOW/Z'00FF'/,ICALL/0/
*** PMF 01/12/99
      CHARACTER CHWORK*160
      EQUIVALENCE (CHWORK,HWORK(1))
*** PMF(end)
C---
      RNUM1 = 0.
      RNUM2 = 0.
      RNUM3 = 0.
      RNUM4 = 0.
      IF(ICALL.NE.0) GO TO 1
C---
C---     ON FIRST CALL ZERO THE HIGH ORDER BYTES OF CHARACTER CONSTANTS.
C---     THE LOW ORDER BYTES CONTAIN THE CHARACTERS. MOVE THE INDIVIDUAL
C---     NON-BLANK CHARACTERS OF THE COMMAND CODES INTO THE LOW ORDER
C---     BYTES OF INTEGER*2 ARRAY VARIABLES AND ZERO THE HIGH ORDER BYTE
C---     THIS IS DONE SO THAT INDIVIDUAL CHARACTERS MAY BE ADDRESSED
C---     WITHOUT USING LOGICAL*1 (NOT AVAILABLE ON THE NORD) OR CHARACTE
C---     VARIABLES (NOT AVAILABLE ON THE IBM).
C---
      HBLANK=HLAND(HBLANK,HLOW) ! PMF 13/08/99  IAND2 -> HLAND
      HPOINT=HLAND(HPOINT,HLOW) ! PMF 13/08/99  IAND2 -> HLAND
      HMINUS=HLAND(HMINUS,HLOW) ! PMF 13/08/99  IAND2 -> HLAND
      DO 2 I=1,10
      HNUMB(I)=HLAND(HNUMB(I),HLOW) ! PMF 13/08/99  IAND2 -> HLAND
    2 CONTINUE
      ICALL=1
    1 CONTINUE
C---
 15   CALL TRMIN(80,cHWORK)
      HWORD(1)=0
      DO 5 I=1,70
C---
C---     PACK BYTES INTO THE LOW ORDER BYTES OF INTEGER*2 VARIABLES
C---     IN SAME WAY AS WAS DONE FOR THE COMMAND CODES.
C---
      HWORD(2)=HLAND(HHIGH,HWORK(I)) ! PMF 13/08/99  IAND2 -> HLAND
      IWORD=ISHFTR(IWORD,8)
      HINN(2*I-1)=HWORD(2)
      HINN(2*I)=HLAND(HLOW,HWORK(I)) ! PMF 13/08/99  IAND2 -> HLAND
    5 CONTINUE
C---
C---     FIND BEGINNING AND END OF THE TWO NUMBERS
C---
      IFIRST=0
      ISECND=0
      ITHIRD=0
      IFOURT=0
      ILS1=0
      ILS2=0
      ILS3=0
      ILS4=0
      DO 6 I=1,80
      IF(HINN(I).EQ.HBLANK.AND.IFIRST.NE.0.AND.ILS1.EQ.0) ILS1=I-1
      IF(HINN(I).EQ.HBLANK.AND.ISECND.NE.0.AND.ILS2.EQ.0) ILS2=I-1
      IF(HINN(I).EQ.HBLANK.AND.ITHIRD.NE.0.AND.ILS3.EQ.0) ILS3=I-1
      IF(HINN(I).EQ.HBLANK.AND.IFOURT.NE.0.AND.ILS4.EQ.0) ILS4=I-1
      IF(HINN(I).EQ.HBLANK) GO TO 6
      IF(IFIRST.EQ.0) IFIRST=I
      IF(ILS1.NE.0.AND.ISECND.EQ.0) ISECND=I
      IF(ILS2.NE.0.AND.ITHIRD.EQ.0) ITHIRD=I
      IF(ILS3.NE.0.AND.IFOURT.EQ.0) IFOURT=I
    6 CONTINUE
      IF(IFIRST.EQ.0) GO TO 111
      IF(ILS1.EQ.0) GO TO 111
C---
C---     FIRST NUMBER, DECODE IT
C---
      NDIG=0
      NBP=-1
      N=0
      SIGN=1.
      DO 12 I=IFIRST,ILS1
      IF(HINN(I).EQ.HMINUS) SIGN=-1.
      IF(HINN(I).EQ.HMINUS) GO TO 12
      IF(HINN(I).EQ.HPOINT) NBP=0
      IF(HINN(I).EQ.HPOINT) GO TO 12
      IDIG=10
      DO 13 J=1,10
      IF(HINN(I).NE.HNUMB(J)) GO TO 13
      IDIG=J-1
   13 CONTINUE
      IF(IDIG.EQ.10) GO TO 14
      N=10*N+IDIG
      NDIG=NDIG+1
      IF(NBP.GE.0) NBP=NBP+1
   12 CONTINUE
      IF(NBP.EQ.-1) NBP=0
      A=SIGN*N/(10.**NBP)
      RNUM1 = A
      IF(ISECND.EQ.0) GO TO 111
      IF(ILS2.EQ.0) GO TO 111
C---
C---     THERE IS A SECOND NUMBER. DECODE IT.
C---
      NDIG=0
      NBP=-1
      N=0
      SIGN=1.
      DO 19 I=ISECND,ILS2
      IF(HINN(I).EQ.HMINUS) SIGN=-1.
      IF(HINN(I).EQ.HMINUS) GO TO 19
      IF(HINN(I).EQ.HPOINT) NBP=0
      IF(HINN(I).EQ.HPOINT) GO TO 19
      IDIG=10
      DO 18 J=1,10
      IF(HINN(I).NE.HNUMB(J)) GO TO 18
      IDIG=J-1
   18 CONTINUE
      IF(IDIG.EQ.10) GO TO 14
      N=10*N+IDIG
      NDIG=NDIG+1
      IF(NBP.GE.0) NBP=NBP+1
   19 CONTINUE
      IF(NBP.EQ.-1) NBP=0
      A=SIGN*N/(10.**NBP)
      RNUM2 = A
      IF(ITHIRD.EQ.0) GO TO 111
      IF(ILS3.EQ.0) GO TO 111
C---
C---     THERE IS A THIRD NUMBER. DECODE IT.
C---
      NDIG=0
      NBP=-1
      N=0
      SIGN=1.
      DO 79 I=ITHIRD,ILS3
      IF(HINN(I).EQ.HMINUS) SIGN=-1.
      IF(HINN(I).EQ.HMINUS) GO TO 79
      IF(HINN(I).EQ.HPOINT) NBP=0
      IF(HINN(I).EQ.HPOINT) GO TO 79
      IDIG=10
      DO 78 J=1,10
      IF(HINN(I).NE.HNUMB(J)) GO TO 78
      IDIG=J-1
   78 CONTINUE
      IF(IDIG.EQ.10) GO TO 14
      N=10*N+IDIG
      NDIG=NDIG+1
      IF(NBP.GE.0) NBP=NBP+1
   79 CONTINUE
      IF(NBP.EQ.-1) NBP=0
      A=SIGN*N/(10.**NBP)
      RNUM3 = A
      IF(IFOURT.EQ.0) GO TO 111
      IF(ILS4.EQ.0) GO TO 111
C---
C---     THERE IS A FOURTH NUMBER. DECODE IT.
C---
      NDIG=0
      NBP=-1
      N=0
      SIGN=1.
      DO 89 I=IFOURT,ILS4
      IF(HINN(I).EQ.HMINUS) SIGN=-1.
      IF(HINN(I).EQ.HMINUS) GO TO 89
      IF(HINN(I).EQ.HPOINT) NBP=0
      IF(HINN(I).EQ.HPOINT) GO TO 89
      IDIG=10
      DO 88 J=1,10
      IF(HINN(I).NE.HNUMB(J)) GO TO 88
      IDIG=J-1
   88 CONTINUE
      IF(IDIG.EQ.10) GO TO 14
      N=10*N+IDIG
      NDIG=NDIG+1
      IF(NBP.GE.0) NBP=NBP+1
   89 CONTINUE
      IF(NBP.EQ.-1) NBP=0
      A=SIGN*N/(10.**NBP)
      RNUM4 = A
      GO TO 111
   14 CONTINUE
      CALL TRMOUT(80,'ILLEGAL CHARACTER ENTERED, TRY AGAIN ^')
      GO TO 15
111   RETURN
      END
