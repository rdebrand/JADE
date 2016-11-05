C   07/06/96 606071827  MEMBER NAME  BPLU     (S4)          FORTG1
      SUBROUTINE BPLU(IRB,IEV)
C     SPECIAL PLUTO PROGRAM
C
C     FOR NEW RUN   IRB = RUN NR       = 0 OTHERWISE
C                   IEV = IW(IHD+4)
C
      COMMON/BCS/IW(1)
      COMMON/IPAR64/IPAR(32)
      INTEGER LRN/0/,IJ/0/
      IF(LRN.EQ.0) CALL VZERO(IPAR,32)
      IRB=0
      IEV=0
      CALL BLOC(IHD,'HEAD',0,*100)
      IRN=IW(IHD+1)
      IEV=IW(IHD+4)
      IF(IRN.EQ.LRN) GOTO 100
      LRN=IRN
      CALL BSPC(IA,LB,IDUM1,IDUM2)
      CALL GETRUN(LRN,IPAR,IW(IA),*10,*10)
      IRB=IRN
      J=MOD(IJ,16)
      I=IJ/16
      IJ=IJ+1
      CALL ITABL(0,I,J,IRB)
      GOTO 100
C
   10 CALL VZERO(IPAR,32)
  100 RETURN
      END
