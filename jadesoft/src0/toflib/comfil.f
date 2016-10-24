C   16/05/80 205182255  MEMBER NAME  COMFIL   (S)           FORTRAN
      SUBROUTINE COMFIL(IENTRY,T,Z,PHIV,IPM)
C
      DIMENSION ZMAT(3,4,84),INDEX(3),YMAT(3,4),A(3,3)
      DIMENSION ZSOL(3,84)
      DATA RTOF/3.07/,IBUG/0/
C
      IF(IENTRY.LE.1)  GOTO  30
      IF(IENTRY.GT.2)  GOTO  20
      IF(IENTRY.NE.2) RETURN
      IBUG =IBUG + 1
      ZM = T
      IF(IBUG.LE.10) PRINT 113,IPM,T,Z,PHIV
  113 FORMAT(' COMFIL',I5,3F10.3)
C
      ZMAT(1,1,IPM) = ZMAT(1,1,IPM) + Z*Z
      ZMAT(2,1,IPM) = ZMAT(2,1,IPM) + Z
      ZMAT(3,1,IPM) = ZMAT(3,1,IPM) + Z*PHIV
C
      ZMAT(1,2,IPM) = ZMAT(1,2,IPM) + Z
      ZMAT(2,2,IPM) = ZMAT(2,2,IPM) + 1.
      ZMAT(3,2,IPM) = ZMAT(3,2,IPM) + PHIV
C
      ZMAT(1,3,IPM) = ZMAT(1,3,IPM) + Z*PHIV
      ZMAT(2,3,IPM) = ZMAT(2,3,IPM) + PHIV
      ZMAT(3,3,IPM) = ZMAT(3,3,IPM) + PHIV*PHIV
C
      ZMAT(1,4,IPM) = ZMAT(1,4,IPM) - Z*ZM
      ZMAT(2,4,IPM) = ZMAT(2,4,IPM) - ZM
      ZMAT(3,4,IPM) = ZMAT(3,4,IPM) -ZM*PHIV
C
      RETURN
   20 CONTINUE
      DO   1   I=1,84
      CALL UCOPY(ZMAT(1,1,I),YMAT(1,1),12)
      PRINT 103,I
  103 FORMAT(1X,I5,3E12.3)
      PRINT 113,YMAT
  113 FORMAT(6X,3E12.3)
      NDIM = 3
      MDIM = 1
      CALL MATIN1(YMAT,NDIM,NDIM,DUMMY,MDIM,INDEX,NERROR,DET)
      IF(NERROR.NE.0)  GOTO  2
      PRINT 104,I,DET
  104 FORMAT(' DET',I5,E12.5)
      PRINT 113,YMAT
      DO   4   L=1,3
      DO   3   K=1,3
C     A(K,L) = ZMAT(K,1,I)*YMAT(1,L)+ZMAT(K,2,I)*YMAT(2,L)+ZMAT(K,3,I)
C    1 *YMAT(3,L)
      A(K,L) = YMAT(K,1)*ZMAT(1,L,I)+YMAT(K,2)*ZMAT(2,L,I)+
     1  YMAT(K,3)*ZMAT(3,L,I)
    3 CONTINUE
    4 CONTINUE
      PRINT 113,A
      PRINT 101,(YMAT(L,4),L=1,3)
  101 FORMAT(' SOL',I5,12F 9.3)
      CALL UCOPY(YMAT(1,4),ZSOL(1,I),3)
      GOTO  1
    2 PRINT 102,I,NERROR
  102 FORMAT(' ERROR IN MAT INVERSION ',2I5)
    1 CONTINUE
C
      PRINT 105,ZSOL
  105 FORMAT(1X,3F12.5)
      WRITE(18) ZSOL
      RETURN
   30 CALL SETSL(ZMAT,0,84*12*4,0.)
      RETURN
      END