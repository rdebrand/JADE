C   16/08/80 601241047  MEMBER NAME  LGERSE   (SOURCE)      FORTRAN
      SUBROUTINE LGERSE(HEXP,HRUN,*)
C  TWO STEPS IN HANDLING BAD ADC'S
C  1.CHECK IF MANY ADC'S FIRED. IF SO SUBTRACT A CONSTANT FROM THEM
C     (3 CASES; ALL CRATES, EACH CRATE, AND EACH ADC MODULE)
C     NOW DONE EVENT BY EVENT. LGSUBC GIVES THE CONST.
C  2.FOR EACH BAD ADC CHANNEL, SUBTRACT CONST GIVEN IN HBUF
C
C            MODIFICATION 23/05/79  13:15
C            MODIFICATION BY Y.WATANABE 16-08-80 23:00
C
C            13/01/86 : COPIED FROM JADELG.SOURCE(LGERSE) M. KUHLEN
C       MOD. 14/01/86 : FULL RINGS 0 AND 31 ERASED        M. KUHLEN
C  LAST MOD. 15/01/86 : PRINT MESSAGE PRIVATE VERSION     M. KUHLEN
C
C
      IMPLICIT INTEGER *2 (H)
#include "clgwork1.for"
#include "clgkalb.for"
      COMMON /CLGBCH/ HABAD(2,3)
      COMMON /CTEMPB/ HCHB(500)
      INTEGER*2 HCR(3)
C
      DATA HEXPO,HRUNO/0,0/
C                                   MESSAGE
      DATA NCALL /0/
      NCALL = NCALL + 1
      IF( NCALL .LT. 2 ) WRITE(6,990)
 990  FORMAT(1X,'LGERSE:  CORRECTED VERSION FROM 24.1.1986 CALLED')
C
      IF(HRUN.LE.100) RETURN1
      IF(HRUN.EQ.HRUNO) GO TO 10
C        NO TEST ON EXP#
      CALL LGBADC(HEXP,HRUN,*190)
C
      HRUNO =HRUN
      HEXPO =HEXP
      NP=NCAL(7)
      HBADC=HCHB(5)
      HBCHN=HCHB(6)
      KPE=7+HBADC+HBADC
10    HIT=LNG-3
C
C     CHECK IF ALL CRATES FIRED.
      HCHB(4)=0
C     IF(HSUB.LT.1) GO TO 30
      IF(HIT.LT.HABAD(1,1)) GO TO 30
      CALL LGSUBC(4,HSUB)
      HCHB(4)=HSUB
      DO 20 I=1,HIT
      HADC=HLGADC(2,I)-HSUB
      IF(HADC.LT.0) HADC=0
      HLGADC(2,I)=HADC
20    CONTINUE
C     WRITE(6,900) HIT
C900   FORMAT(' ALL CRATES FIRED',I5)
      GO TO 62
C
C     CHECK IF SOME CRATES FIRED
30    IF(HIT.LT.HABAD(1,2)) GO TO 62
C     IF(HCHB(1).GT.0) GO TO 32
C     IF(HCHB(2).GT.0) GO TO 32
C     IF(HCHB(3).GT.0) GO TO 32
C     GO TO 62
32    HCR(1)=0
      HCR(2)=0
      HCR(3)=0
C     COUNT #ADC CHANNELS FIRED PER CRATE.
      J=1
      DO 40 I=1,HIT
      IF(HLGADC(1,I).GE.960) J=2
      IF(HLGADC(1,I).GE.1920) J=3
      HCR(J)=HCR(J)+1
40    CONTINUE
C
      DO 60 J=1,3
      HCHB(J)=0
      IF(HCR(J).LT.HABAD(1,2)) GO TO 60
C     WRITE(6,910) J,HIT,HCR(J)
C910   FORMAT(' ONE CRATE  FIRED',5I5)
      CALL LGSUBC(J,HSUB)
      HCHB(J)=HSUB
      IF(HSUB.LT.1) GO TO 60
C     (BAD CRATE)
      I1=960*(J-1)
      I2=I1+960
      DO 50 I=1,HIT
      HADC=HLGADC(1,I)
      IF(HADC.LT.I1) GO TO 50
      IF(HADC.GE.I2) GO TO 50
      HADC=HLGADC(2,I)-HSUB
      IF(HADC.LT.0) HADC=0
      HLGADC(2,I)=HADC
50    CONTINUE
60    CONTINUE
C
C     CHECK IF ANY ADC FIRED.
62    KP=7
      IF(HBADC.LT.1) GO TO 115
      IF(HIT.LT.HABAD(1,3)) GO TO 115
      HMODO=-1
      HA1=0
      HA2=0
      DO 100 I=1,HIT
      HMOD=HLGADC(1,I)/48
      JC=HLGADC(1,I)/960+1
      IF(HMOD.EQ.HMODO) GO TO 90
      IF(HMODO.LT.0) GO TO 80
C     CHECK IF #HITS EXCEED THE LIMIT.
64    IF(HMODO.LT.HCHB(KP)) GO TO 80
      IF(HMODO.EQ.HCHB(KP)) GO TO 66
      KP=KP+2
      IF(KP.GE.KPE) GO TO 115
      GO TO 64
66    IF(HAHIT.LT.HABAD(1,3)) GO TO 80
      HSUB=HCHB(KP+1)-HCHB(JC)-HCHB(4)
      IF(HSUB.LT.1) GO TO 72
      DO 70 J=HA1,HA2
      HADC=HLGADC(2,J)-HSUB
      IF(HADC.LT.0) HADC=0
      HLGADC(2,J)=HADC
70    CONTINUE
C
72    CONTINUE
C     WRITE(6,920) HIT,HMODO,HAHIT,HA1,HA2
C920   FORMAT(' ADC MODULE FIRED',8I5)
75    KP=KP+2
      IF(KP.GE.KPE) GO TO 115
80    HAHIT=0
      HA1=I
      HA2=I
      IF(I.EQ.HIT) GO TO 110
90    HAHIT=HAHIT+1
      HA2=I
      HMODO=HMOD
      IF(I.EQ.HIT) GO TO 64
100   CONTINUE
110   CONTINUE
C
C     NOW INDIVIDUAL CHANNELS
115   KP=KPE
      IF(HBCHN.LT.1) GO TO 145
      I=1
      DO 140 N=1,HBCHN
      HB=HCHB(KP)
      DO 120 J=I,HIT
      IF(HB.GT.HLGADC(1,J)) GO TO 120
      IF(HB.NE.HLGADC(1,J)) GO TO 130
      HADC=HLGADC(2,J)-HCHB(KP+1)
      IF(HADC.LT.0) HADC=0
      IF(HCHB(KP+1).GT.1000.AND.HLGADC(2,J).GT.4000) HADC=0
C        KILL THE BAD ONE IF OVERFLOWS
      HLGADC(2,J)=HADC
      GO TO 130
120   CONTINUE
C
      GO TO 140
130   KP=KP+2
140   CONTINUE
C
C     ALSO BLOCKS NOT PRESENT MAY HAVE NONZERO VALUES SINCE THE
C     ELECTRONICS FOR THEM IS READ OUT AND MAY BE 'SPINNING'.
C
C     ERASE RING 0 AND 31 WHICH ARE UNPHYSICAL FOR THE MOMENT
C      (AUTOMATICALLY DONE IN LGCALB, I.E. THE GAIN FACTOR=0 FOR TNEM)
C
C     THESE TWO FULL RINGS ARE ERASED IN STANDARD PROCEDURES REGARDLESS
C     WHETHER THE TWO HALF RINGS (INSTALLED IN 1983) ARE ACTUALLY
C     PRESENT ORE NOT, IN ORDER TO KEEP ACCEPTANCE CALCULATIONS
C     COMPATIBLE WITH FORMER DATA.
C
145   CONTINUE
      DO 150 I=1,HIT
         IADC = HLGADC(1,I)
         IF(IADC.GT.2687) GO TO 150
         IRING=MOD(IADC,32)
C                                   ADC  #  0 - 2687   ( BARREL )
C                                   RING #  0 -   31
C                                   ROW  #  1 -   84
C     BLOCKS   A B S E N T : RING  0, ROW  1 TO 21 AND ROW 64 TO 84
C                            RING 31, ROW 22 TO 63
C
C     IT IS POSSIBLE TO KEEP THE TWO HALFRINGS WHICH ARE REALLY THERE:
C     REMOVE THE COMMENTING OF THE FOLLOWING 3 STATEMENTS AND
C     PRESENT BLOCKS WILL NOT BE KILLED.
C        IROW = 1 + IADC/32
C        IF( IRING.EQ. 0 .AND. (IROW.GE.22.AND.IROW.LE.63) ) GOTO 150
C        IF( IRING.EQ.31 .AND. (IROW.LE.21 .OR.IROW.GE.64) ) GOTO 150
C
         IF(IRING.EQ.0.OR.IRING.EQ.31) HLGADC(2,I)=0
 150  CONTINUE
      RETURN
C
C  RUN # NOT FOUND
190   CONTINUE
      DATA MESCNT/0/
      MESCNT = MESCNT+1
      IF(MESCNT.LE.10) WRITE(6,600) HRUN
600   FORMAT(1X,'*** RUN # ',I5,'  NOT FOUND ***',
     $       2X,'(MESSAGE FROM LGERSE)')
      RETURN1
      END