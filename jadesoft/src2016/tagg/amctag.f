C   22/03/80 403202335  MEMBER NAME  AMCTAG   (S)           FORTRAN
      SUBROUTINE AMCTAG(IER1)
C---  PROGRAM FOR FORWARD DETECTORS' DATA ANALYSIS
C---  MONTE CARLO VERSION
C
C     H.WRIEDT      10.04.79     14:25
C     LAST MODIFICATION      22.03.80       15:25
C
      IMPLICIT INTEGER*2 (H)
C
      COMMON /CWORK/ IWORK(1908),HRUNEX,HEVENT
C
      DATA MASK/1/
C
      COMMON /CMSGCT/ MSGDUM(20),NGGMAX,NGGMSG(16)
C
      COMMON /CGGVRN/ NVRSN(20)
      DATA NVCODE/580032215/
      DATA ICOUNT/0/
C
      NVRSN(1) = NVCODE
C
      IF (ICOUNT.EQ.0) CALL GGFAC2
      IF (ICOUNT.EQ.0) WRITE(6,610)
  610 FORMAT(/' *** AMCTAG WIRD BENUTZT ***')
      ICOUNT = 1
C---  CLEAR COMMON BLOCKS FOR NEW EVENT
C RENAMED TO GSCRUB FROM GCLEAR - A.J.FINCH 20/3/84 TO PREVENT
C CONFLICT WITH IPS COMMAND OF SAME NAME
      CALL GSCRUB
C
C---  UNPACK DATA OF NEW EVENT
      CALL UMCPAK(IER,*1)
      CALL CONVER
C***  IF (IER.EQ.0) GOTO 10
C***  IF (IER.EQ.7) GOTO 102
      IMASK = IAND(IER,MASK)
C***  IF (IMASK.EQ.1) GOTO 100
C
C---  DRIFT CHAMBERS
C***  HAS TO BE WRITTEN
   10 CONTINUE
C
C---  LEAD GLASS
  100 CALL GGSORT
      IER = IER/2
      IMASK = IAND(IER,MASK)
C***  IF (IMASK.EQ.1) GOTO 102
C
C---  CLUSTER SEARCH
      CALL GGCCTL(*200)
C
C---  LEAD-GLASS RESULT DUMP
      CALL GGCLPC
C
C---  COMBINE TRACK INFORMATION OF LUMONITORS AND LEAD GLASS
C---  (IN THE FUTURE DRIFT CHAMBERS, TOO)
      CALL TRACKS
C
C---  FILL RESULT INTO NEW BANKS
  102 CALL REPACK(IER1)
      GOTO 1
C
C---  HANDLING OF EVENTS WITH TOO MANY CLUSTERS
  200 IF (NGGMSG(5).LE.NGGMAX) WRITE(6,605) HEVENT,HRUNEX
  605 FORMAT(' EVENT',I6,' OF RUN',I6,' SKIPPED FOR MORE THAN 51',
     &       ' CLUSTERS IN THE FORWARD DETECTORS LEAD-GLASS BLOCKS')
C
   1  RETURN
      END
