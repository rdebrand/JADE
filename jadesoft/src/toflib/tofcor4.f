C   18/01/81 205211257  MEMBER NAME  TOFCOR4  (S)           FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       SUBROUTINE TOFCOR
C
C         MATCHING BETWEEN THE TOF COUNTERS AND
C         THE PARTICLE TRAJECTORIES DEFINED
C         BY THE INNER DETECTORS.
C         CODED AT 07.11.78
C         CHANGED AT 3.3.1980 BEATE NAROSKA
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       COMMON/CWORK/NR,RAW(5,42),NC,ICRT1(5,42),NTRK,ICRT2(50),TRK(5,50)
     - ,ITRC(50),NTC,ITRK(5,42),INFM(4),IR(14,50)
       DIMENSION IRAW(5,42)
      COMMON/INOUT/WRITFL,EVWRIT
      LOGICAL WRITFL,EVWRIT,HISTFL,PRFL
       EQUIVALENCE (IRAW(1,1),RAW(1,1))
C
       DATA PAI/3.1415927/,RTOF/920./
       DATA XPAI/.14960/,SQRAD/.36742/,DSTAN/.01/
      DATA IBUG/ 0/,IENTRY/0/
C     IF(IENTRY.NE.0)  GOTO  10
C     IENTRY = 1
C     CALL HDELET(0)
C     CALL HBOOK1(406,5HDFI $,100,-.5,.5)
C  10 CONTINUE

C
C=========   ININTIALIZATION OF CORRESPONDENCE TABLE
C
      IBUG = IBUG + 1
      IF(IBUG.LE.10) PRINT 150,(IRAW(1,NCN),NCN=1,42)
  150 FORMAT(' CNTRS',42I3)
      IF(IBUG.LE.10) PRINT 151,NTRK,(ITRC(I),I=1,NTRK)
  151 FORMAT(' TRKS',I5,3X,10I3)
      EVWRIT = .FALSE.
       CALL SETSL(ICRT1,0,42*20,0)
       CALL SETSL(ICRT2,0,200,0)
            DO 2000 LTRK=1,NTRK
            IF(ICRT2(LTRK).GT.0) GO TO 2000
            NCN= ITRC(LTRK)
            IF(NCN.GE.1.AND.NCN.LE.42) GO TO 1050
            ICRT2(LTRK)= -1
            GO TO 2000
 1050       CONTINUE
C
C=========   LOOK FOR HIT IN CORRESPONDING COUNTER
  501 FORMAT(/' TOFCOR ', 3I5,54F10.3)
C
            IF(IRAW(1,NCN).LE.0) GO TO 1500
                 MTRK=ITRK(2,NCN)
                 IF(MTRK.GE.4) GO TO 1200
                 IF(MTRK.LT.1) GO TO 1500
                      MTRK1=MTRK+2
                      DO 1100 I=3,MTRK1
                      IF(LTRK.EQ.ITRK(I,NCN)) GO TO 1200
 1100                 CONTINUE
                      GO TO 1500
 1200            ICNT=ICRT1(2,NCN)+1
                 ICRT1(2,NCN)=ICNT
                 ICRT2(LTRK)= NCN
                 ICRT1(1,NCN)= NCN
                 IF(ICNT.GE.4) GO TO 2000
                 ICRT1(ICNT+2,NCN)=LTRK
                 GO TO 2000
 1500      CONTINUE
C
C=========   COUNTER WAS NOT HIT LOOK IN ADJACENT ONES
C    LOOK IN ADJACENT COUNTERS
C
                PH1=(FLOAT(NCN)-1.)*XPAI
                DPH=TRK(2,LTRK)-PH1
      IF(ABS(DPH).GT.6.284-XPAI/2.) DPH = ABS(DPH)-(6.284-XPAI/2.)
C     CALL HF1(406,DPH,1.)
      IF(ABS(DPH).GT..100) EVWRIT = .TRUE.
      I =1
      IF(DPH.LT.0.) I = -1
      NC1 = NCN + I
      IF(NC1.GT.42) NC1 = NC1-42
      IF(NC1.LT.1)  NC1 = NC1 + 42
      IF(IBUG.LE.20) PRINT 503,LTRK,NCN,NC1,DPH
  503 FORMAT(' TRACK',I5,' HITS ',I5,' TRY CNTR ',I5,F10.4)
      IF(IRAW(1,NC1).LE.0) GO TO 2000
C  40 IF(DPH.GT..03) GO TO 1700
C  CHECK QUALITY OF TOF DETERMINATION
C     CALL TOFBRA(NC1,LTRK,IFLG)
C     IF(IBUG.LE.20) PRINT 501,IFLG
           ICNT=ICRT1(2,NC1)+1
           ICRT1(2,NC1)=ICNT
           ICRT2(LTRK)= NC1
           ICRT1(1,NC1)= NC1
           IF(ICNT.GE.4) GO TO 2000
           ICRT1(ICNT+2,NC1)= LTRK
           ICRT2(LTRK)= NC1
           ICRT1(1,NC1)= NC1
C
 2000  CONTINUE

           RETURN
           END
