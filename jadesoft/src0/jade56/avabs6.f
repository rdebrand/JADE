C   11/05/81 509272142  MEMBER NAME  AVABS6   (JADEMC2)     FORTRAN

      FUNCTION  AVABS(ALAMDA)
C---- S.YAMADA     11-05-81
C     LAST MODIFICATION  18-10-78  21:15
C
C---- CALCULATE MEAN ABSORPTION LENGTH IN SF6 FOR WAVE LENGTH ALAMDA.
C     UNIT OF ALAMDA  IS NANO-METER.
C     UNIT   OF AVABS IS CM.
C
      IF(ALAMDA.GE.428.) GO TO  3
      IF(ALAMDA-390.) 1,2,2
    1 AVABS = 10.**(0.03448*ALAMDA-12.654)
      RETURN
    2 AVABS = 10.**(0.02326*ALAMDA-8.2807)
      RETURN
    3 AVABS = 10.**(0.01429*ALAMDA-4.4305)
      RETURN
      END