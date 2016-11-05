C   07/06/96 606071916  MEMBER NAME  UPATT    (S4)          FORTRAN
      SUBROUTINE UPATT(NA,LIST)
C
C     ADD PATTERN IN LIST(1)...LIST(ND) TO PATTERN TABLE NA
C     CORRECTED JULY 82
C
      COMMON/BCS/IW(1)
      INTEGER LIST(10)
      IND=ILINK('PAT*',NA)
      IF(IND.EQ.0) GOTO 100
      ND=IW(IND+1)
      K=0
      DO 10 I=1,ND
   10 K=K+IABS(LIST(I))*I*I
      K=4+MOD(K,97)
   15 J=IW(IND+K)
      IF(J.EQ.0) GOTO 40
      DO 20 I=1,ND
      IF(LIST(I).NE.IW(IND+J+I)) GOTO 30
   20 CONTINUE
      IW(IND+J)=IW(IND+J)+1
      GOTO 100
   30 K=J+ND+1
      GOTO 15
C     NEW ENTRY
   40 N=IW(IND+2)+ND+2
      IF(N.LT.IW(IND)) GOTO 50
      IW(IND+3)=IW(IND+3)+1
      GOTO 100
   50 IW(IND+2)=N
      IW(IND+K)=N
      IW(IND+N)=1
      DO 60 I=1,ND
      N=N+1
   60 IW(IND+N)=LIST(I)
      GOTO 100
***PMF      ENTRY DPATT(NA,ND,NL)
***PMF 07/05/99
      ENTRY DPATT(NA,ND2,NL)
      ND=ND2
***PMF(End)
C
C     DEFINE PARAMETERS FOR PATTERN TABLE NA
C
C     CALL DPATT(NA,ND,NL)
C
C        ND = DIMENSION OF LIST (IN UPATT)
C        NL = MAX NUMBER OF DIFFERENT ENTRIES
C
      IF(ND.LT.1.OR.ND.GT.10) GOTO 100
      NW=100+(ND+2)*NL
      IND=IBANK('PAT*',NA,NW)
      IF(IND.EQ.0) GOTO 100
      IW(IND+1)=ND
      IW(IND+2)=99-ND
      GOTO 100
C
      ENTRY PPATT(NA)
C
C     PRINT OUT OF PATTERN TABLES FOR NA OR ALL (IF NA=0)
C
      IF(NA.EQ.0) GOTO 70
      IND=ILINK('PAT*',NA)
      GOTO 80
   70 IND=IBLN('PAT*')+1
      IND=IW(IND-1)
   80 IF(IND.EQ.0) GOTO 100
      NTOT=IW(IND+3)
      ND=IW(IND+1)
      NAA=IW(IND-2)
      NLIM=IW(IND+2)
      IW(IND+2)=0
      N=99-ND
   82 N=N+ND+2
      IF(N.GT.NLIM) GOTO 84
      NTOT=NTOT+IW(IND+N)
      IW(IND+N+ND+1)=0
      GOTO 82
   84 N=99-ND
      WRITE(6,101) IW(IND-2),IW(IND+3),NTOT
   86 N=N+ND+2
      IF(N.GT.NLIM) GOTO 94
      MFR=2
   88 M=IW(IND+MFR)
      IF(M.EQ.0) GOTO 92
      DO 90 I=1,ND
      IF(IW(IND+N+I)-IW(IND+M+I)) 92,90,91
   90 CONTINUE
   91 MFR=M+ND+1
      GOTO 88
   92 IW(IND+N+ND+1)=IW(IND+MFR)
      IW(IND+MFR)=N
      GOTO 86
   94 MFR=2
   96 M=IW(IND+MFR)
      IF(M.EQ.0) GOTO 98
      WRITE(6,102) IW(IND+M),(IW(IND+M+I),I=1,ND)
      MFR=M+ND+1
      GOTO 96
   98 IND=IW(IND-1)
      IDL=ILOC('PAT*',NAA,-1)
      IF(NA.EQ.0) GOTO 80
  100 RETURN
  101 FORMAT('0-------------'/' UPATT',I8,I20,' OVERFLOWS',1X,
     1   'OF TOTAL',I8,' ENTRIES'/
     1   '       ENTRIES   PATTERN . . .'/)
  102 FORMAT(4X,11I10)
      END
