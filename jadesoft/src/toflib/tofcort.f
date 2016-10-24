C   14/03/83 303151151  MEMBER NAME  TOFCORT  (S)           FORTRAN
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
       EQUIVALENCE (IRAW(1,1),RAW(1,1))
      COMMON/POINT/IPHEAD,IPLTCH,IPT1,IPTOF,IPCLST,IPR,IPPATR,IPNT(13)
C
       DATA PAI/3.1415927/,RTOF/920./
       DATA XPAI/.14960/,SQRAD/.36742/,DSTAN/.01/
      DATA IBUG/50/
C
C=========   ININTIALIZATION OF CORRESPONDENCE TABLE
C
      IBUG = IBUG + 1
       CALL SETSL(ICRT1,0,42*20,0)
       CALL SETSL(ICRT2,0,200,0)
C
C---------------------------------------------------------------------
C   SEARCH TRACKS HITTING A PARTICULAR COUNTER,THAT HAD EITHER EXACTLY
C   ONE TRACK EXTRAPOLATING TO IT OR NONE
C---------------------------------------------------------------------
C
      DO   20   N=1,NTRK
      IF(ITRC(N).NE.41.AND.ITRC(N).NE.42)  GOTO  20
      GOTO  30
   20 CONTINUE
      RETURN
   30 PRINT 220,NTRK,(ITRC(N),N=1,NTRK)
  220 FORMAT(' TRACK INFO' I6,5X,10I8)
      CALL ATOFPR(IPTOF)
C
           RETURN
           END