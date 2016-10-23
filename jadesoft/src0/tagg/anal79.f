C   14/03/84 403202337  MEMBER NAME  ANAL79   (S)           FORTRAN
C   13/01/82 201271037  MEMBER NAME  @ANALYS1 (S)           FORTRAN
C---  ANALYSIS PROGRAM (DATA WITH TAGGING TRIGGER)
C---  (PEDESTAL SUBTRACTION, LATCHES REORDERED MAY 79)
C---  (TREATS CHANNELS WITH OR WITHOUT VARIING PEDESTALS)
C---  DEALS WITH REDUCED DATA
C---  WRITES OUTPUT ONTO TAPE (SINGLE TAGG EVENTS)
C
C     H.WRIEDT      09.03.79     18:50
C     LAST MODIFICATION      13.01.82       16:30
C
C     COPIED BY A.J.FINCH14/3/84 AND ADAPTED
C       TO BE CALLED FROM TP JOB
C
C
C****************************************************************
C     STRUCTURE OF THE ANALYSIS PROGRAMS CHAIN
C     @ANALYSE   CALLS THE FOLLOWING SUBROUTINES:
C               GGBLCK
C               GCLEAR
C               INGAMW
C               GGSORT
C               PICTUR     (OPTION)
C               GGADCD     (OPTION)
C               GGCCTL
C               GGCLPC
C               GGCLSD     (OPTION)
C               LUMOUT     (OPTION)
C               OUTGAM
C*************************************************************
C
      SUBROUTINE ANAL79(IER)
      IMPLICIT INTEGER*2 (H)
C
      COMMON /BCS/ IDATA(30000)
      REAL RDATA(30000)
      EQUIVALENCE (IDATA(1),RDATA(1))
C
      COMMON /CWORK/ IWORK1(42),LNG,HPOINT(4),HGGADC(2,192),HWORK(532),
     &               HCLSTM,HCLSTP,
     &               IWORK5(23),ACOLAN,ETOT,ETOTM,ETOTP,IWORK4(757),
     &               HACC,HWORK1,IWORK3(619),HRUNEX,HEVENT
C
      COMMON /CRUNCO/ HRUN,HOLDRN,IUN
C
      COMMON /CSUMEA/ HEVENA
C
      LOGICAL*1 LDUMP/.TRUE./
      DATA LIMIT/100/, MASK/1/, IMISS/0/, NIER1/0/
      DATA HEVEN1/0/
      LOGICAL FIRST/.TRUE./
C
      DATA ICOUNT/0/
      DATA IEVLIM/3/
C
C
C
       IF(.NOT.FIRST)GOTO 1
       FIRST=.FALSE.
C---  INITIALIZE FORWARD DETECTORS DATA
      CALL GGBLCK
C---  READ FIRST SET OF CALIBRATION FACTORS OF PB-GLASS
      CALL GGFAC1
C
C---  PREPARE NEW RUN
      NREDUC = 22
      HOLDRN = 0
C
C---  GET DATE
      HDATE = DATE(DUMMY)
C
C
    1 CONTINUE
      ICOUNT = ICOUNT + 1
C
C---  CLEAR COMMON BLOCKS FOR NEW EVENT
C RENAMED TO GSCRUB FROM GCLEAR - A.J.FINCH 20/3/84 TO PREVENT
C CONFLICT WITH IPS COMMAND OF SAME NAME
      CALL GSCRUB
COLDOLDALL GCLEAROLD
C
C---   UNPACK DATA OF NEW EVENT
      CALL INGAM1(IER)
C
      HEVENA = HEVENA + 1
C---  1981 (OR LATER) - DATA ARE NOT ANALYSED BY @ANALYS1:
      IF (HRUNEX.GT.6000) GOTO 104
C---  ONLY EVENTS WITH TAGGING TRIGGER OR ENERGY IN TAGGING LEAD-GLASS
C---  ARE PROCESSED FURTHER
      IF (HACC.NE.0) GOTO 2
      GOTO 103
    2 HEVEN1 = HEVEN1 + 1
      IF (IER.EQ.0) GOTO 10
      IF (IER.EQ.7) GOTO 103
      IMASK = IAND(IER,MASK)
      IF (IMASK.EQ.1) GOTO 100
   10 CONTINUE
C
C---  LEAD GLASS
  100 IER = IER/2
      IMASK = IAND(IER,MASK)
      IF (IMASK.EQ.1) GOTO 103
C
C---  CLUSTER SEARCH
      CALL GGCCTL(&103)
      CALL GGCLPC(&103)
C
C---  LEAD GLASS RESULT DUMP
C AJF - ONLY FIRST FEW EVENTS
C
      IF(ICOUNT.GT.IEVLIM)GOTO 103
      IF (HCLSTM.LT.1 .AND. HCLSTP.LT.1) GOTO 103
      IF (HACC.EQ.1) WRITE(6,501)
  501 FORMAT(' EVENT HAS GOT TAG-TRIGGER & ENERGY IN TAGGING-LG')
      IF (HACC.EQ.2) WRITE(6,502)
  502 FORMAT(' EVENT HAS GOT NO TAG-TRIGGER BUT ENERGY IN TAGGING-LG')
      IF (.NOT.LDUMP) GOTO 103
      WRITE(6,603) HEVENA
  603 FORMAT(///1X,'EVENT NO.',I5,' DISPLAYED')
      WRITE(6,608) HEVENT,HRUNEX
  608 FORMAT(' THIS IS EVENT NO.',I5,' OF RUN NO.',I4)
C
      CALL GGCLSD
C
C---  WRITE RESULT INTO NEW BANKS
  103 CALL OUTGAW(IER1)
      IER = IER1
104   RETURN
      END
