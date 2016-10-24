C   24/11/78 C9101501   MEMBER NAME  DNUM     (JADEGS)      FORTRAN
      SUBROUTINE DNUM(NUMBER,XPOS,YPOS,AGT,THETA)
C
C     ******************************************************************
C     *   THIS SUBROUTINE WILL DRAW A 16-BIT INTEGER STARTING AT       *
C     *   POSITION (XPOS,YPOS).  THE HEIGHT IS GIVEN BY AGT AND THETA  *
C     *   SPECIFIES THE ANGLE IN RADIANS.  HEMSYM IS USED TO O/P CHARS *
C     *   WRITTEN BY H.E.MILLS  LAST UPDATED ON 09-AUG-78 AT 10.35.    *
C     ******************************************************************
C     MODIFIED 6.12.78 BY OLSSON, PURPOSE TRANSFER OF DECODED NUMBER
C     MODIFIED 14.10.79 BY OLSSON, PURPOSE WRITING NUMBERS > 32000
C
      IMPLICIT INTEGER*2 (H)
      DIMENSION HBUF(6)
C
      CALL NUMCOD(NUMBER,HBUF,K)
C
C     **** OUTPUT THE ARRAY ****
C
      CALL HEMSYM(XPOS,YPOS,AGT,HBUF,K,THETA)
      RETURN
      END
C------------------------
      SUBROUTINE NUMCOD(NUMBER,HBUF,K)
      IMPLICIT INTEGER*2 (H)
      character*2 HCH, HBUF, HBL
      DIMENSION ITENS(6),HBUF(6),HCH(10)
C
      DATA ITENS/100000,10000,1000,100,10,1/, HBL/' '/
      DATA HCH/'0','1','2','3','4','5','6','7','8','9'/
C
      K=0
      IND=0
      NUMB=NUMBER
C
C     **** LOOP 6 TIMES - PUT DIGIT IN J ****
C
      DO 50 I=1,6
      HBUF(I) = HBL
      IF(I.EQ.6) IND=1
      J=NUMB/ITENS(I)
      NUMB=NUMB-J*ITENS(I)
      IF(J.EQ.0 .AND. IND.EQ.0) GOTO 50
      IND=1
C
C     **** STORE CHARACTER IN HBUF ****
C
      K=K+1
      HBUF(K)=HCH(J+1)
   50 CONTINUE
      RETURN
      END
