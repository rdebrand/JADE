C   31/10/76 C9070301   MEMBER NAME  UWP      (JADEGS)      FORTRAN
      SUBROUTINE UWP(BIN,NA,NB)
C *---------------------------------------------------------
C *
C * VERSION OF 02/07/79    LAST 02/07/79    E.ELSEN
C * UWP VERSION DISTINGUISHING BETWEEN I*4 AND I*2
C * ACCORDING TO VALUE OF I*4 WORD
C *---------------------------------------------------------
C
      REAL*4 BIN(2)
      REAL*8 FMT(13),FMTF/'  F12.4,'/,FMTG/'  G12.4,'/,
     1     FMTI/'    I12,'/,FMTA/'  8X,A4,'/,FMT1/'        '/,
     2     FMT2/'(11X,   '/,FMTI2/'  2I6,  '/
      INTEGER NEQ/0/,LIM(2,8)
      LOGICAL*1 LFMT(96),LL(8),LAST/')'/
      DATA FMT(1)/'(1X,I5, '/,FMT(2)/''' -'',I3,'/
      DATA LIM/75,80,91,97,107,111,123,136,
     1     193,201,209,217,226,233,240,249/
      EQUIVALENCE(FMT(1),LFMT(1)),(LL(1),REQ),(LL(5),NEQ)
      REAL*8 FMZ(11)
      EQUIVALENCE (FMT(3),FMZ(1))
      DIMENSION JOBUF(20),ROBUF(20)
      INTEGER*2 HELP(2)
      EQUIVALENCE (HELP(1), IHELP, RHELP),(ROBUF(1),JOBUF(1))
      DATA IWOLI / 10 /
C
C
C     PURPOSE
C        PRINT ARRAY WITH AUTOMATIC SELECTION OF INTEGER,
C        FLOATING POINT OR TEXT FORMAT FOR EACH WORD ACCORDING
C        TO CONTENT
C
C     USAGE       --- -- --
C        CALL UWP(BIN,NA,NB)
C
C        PRINTS ARRAY BIN(NA) . . . BIN(NB)
C
C                 -- -- ----
C        CALL UTP(VS,IT,TEXT)
C
C        PRINTS ARRAY VS(2) IN A-FORMAT AND FOR IT.GT.0 THE
C        ARRAY TEXT(1) . . . TEXT(IT) IN A-FORMAT   (IT.LE.10)
C
C        CALL UPP
C
C        NEW PAGE
C
      IUWU=0
    1 IF(NA.GT.NB) GOTO 100
      IZERO=0
      NF=((NA-1)/IWOLI)*IWOLI+1
      N=NB+1-NF
      DO 60 I=NF,NB,IWOLI
      IA=I
      IB=MIN0(I+IWOLI-1,NB)
      IF(IUWU.EQ.0) GOTO 8
      IF(IB.EQ.NB) GOTO 4
      DO 2 J=IA,IB
      IF(BIN(J).NE.0) GOTO 4
    2 CONTINUE
      IF(IZERO.EQ.0) IZERO=IA
      GOTO 60
    4 IF(IZERO.EQ.0) GOTO 8
      WRITE(6,103) IZERO
      IZERO=0
    8 M=3
      JO = 0
      DO 50 J=IA,IB
      REQ=BIN(J)
      M=M+1
      JO = JO + 1
      LA=0
      DO 20 K=1,4
      LL(8)=LL(K)
      IF(NEQ.EQ.64) GOTO 20
      DO 10 L=1,8
      IF(NEQ.LT.LIM(1,L)) GOTO 40
      IF(NEQ.GT.LIM(2,L)) GOTO 10
      IF(L.LE.4) LA=LA+1
      GOTO 20
   10 CONTINUE
      GOTO 40
   20 CONTINUE
      IF(LA.GT.2) GOTO 40
      ROBUF(JO) = BIN(J)
      FMT(M)=FMTA
      GOTO 50
   40 IF(ABS(REQ).GT.1.E20.OR.ABS(REQ).LT.1.E-20) GOTO 30
      IF(ABS(REQ).LT.10000.0.AND.ABS(REQ).GE.0.1) GOTO 45
      ROBUF(JO) = BIN(J)
      FMT(M)=FMTG
      GOTO 50
   45 FMT(M)=FMTF
      ROBUF(JO) = BIN(J)
      GOTO 50
   30 RHELP = BIN(J)
      IF( IHELP .GE. -32768.AND. IHELP .LE. 32767 ) GO TO 35
      JOBUF(JO) = HELP(1)
      JO = JO + 1
      JOBUF(JO) = HELP(2)
      FMT(M) = FMTI2
      GO TO 50
   35 JOBUF(JO) = IHELP
      FMT(M)=FMTI
   50 CONTINUE
      LFMT(8*M)=LAST
      IF(N.LE.IWOLI) GOTO 55
      FMT(3)=FMT1
      JB=MOD(IB,1000)
      WRITE(6,FMT) IA,JB,(ROBUF(II),II=1,JO)
      GOTO 60
   55 FMT(3)=FMT2
      WRITE(6,FMZ) (ROBUF(II),II=1,JO)
   60 CONTINUE
      GOTO 100
C     ENTRY WITH SPPRESSSION OF ZEROS IN SEVERAL LINES
      ENTRY UWU(BIN,NA,NB)
      IUWU=1
      GOTO 1
C
      ENTRY UTP(VS,IT,TEXT)
C
      INTEGER VS(2),TEXT(10)
      IF(IT.LE.0) GOTO 70
      WRITE(6,101) VS,(TEXT(I),I=1,IT)
      GOTO 100
   70 WRITE(6,101) VS
      GOTO 100
C
      ENTRY UPP
C
      WRITE(6,102)
  100 RETURN
  101 FORMAT('0  ',2A4,10(8X,A4))
  102 FORMAT('1')
  103 FORMAT(1X,I5,2X,'AND FOLLOWING ALL ZERO')
      END