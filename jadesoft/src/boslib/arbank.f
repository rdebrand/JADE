C   18/10/82 606071921  MEMBER NAME  ARBANK   (S)           FORTRAN
      SUBROUTINE ARBANK(NAME,NRUN,AR,NAR,IUNIT,IOPT)
C
C     ARBANK FETCHES AN ARRAY FROM DIRECT ACCESS DATA SET IUNIT
C     (IOPT='FE') OR STORES AN ARRAY ON DIRECT ACCESS DATA SET IUNIT
C     (IOPT='ST').
C
C                     ---- -- -- --- -----  --
C         CALL ARBANK(NAME,NR,AR,NAR,IUNIT,'ST')
C
C
C     THE ARRAY AR(1)...AR(NAR), VALID FOR THE RUNS NRUN..., IS STORED
C     ON DIRECT ACCESS DATA SET IUNIT UNDER THE IDENTIFIER NAME.
C     NAR MAY BE BETWEEN 1 AND 45000. NR IS A 6 DIGIT POSITIVE INTEGER.
C
C                     ---- --        -----  --
C         CALL ARBANK(NAME,NR,AR,NAR,IUNIT,'FE')
C                             -- ---
C
C     THE ARRAY AR(1)...AR(NAR), IDENTIFIED BY NAME, AND VALID FOR THE
C     RUN NRUN, IS FETCHED FROM THE DIRECT ACCESS DATA SET IUNIT
C     THE SIZE OF AR HAS TO BE BIG ENOUGH FOR THE DATA.
C
C     THE ARGUMENT NAME SHOULD NOT BE USED AS NAME OF A BANK (ACTUALLY
C     THE DATA ARE STORED ON THE DATA SET IN BANKS (NAME,NRUN),
C     (NAME,100000000+NRUN*100+1), (NAME,100000000+NRUN*100+2)....)
C
      COMMON/BCS/IW(1)
      REAL AR(NAR)
      INTEGER IOPT,FU/'FU  '/,FE/'FE  '/,ST/'ST  '/
      IF(IOPT.EQ.FE.OR.IOPT.EQ.FU) GOTO 20
      IF(IOPT.NE.ST) GOTO 200
      IF(NAR.GT.0.AND.NAR.LE.45000) GOTO 1
      WRITE(6,101) NAR
  101 FORMAT('0ERROR IN ARBANK CALL, NAR =',I12/)
C
C     STORE DATA OF ARRAY ON DIRECT ACCESS DATA SET IUNIT
C
    1 NRN=NRUN
      JA=1
   10 JB=MIN0(JA+3000-1,NAR)
      IND=IBANK(NAME,NRN,JB-JA+1)
      IF(IND.EQ.0) GOTO 200
      CALL UCOPY(AR(JA),IW(IND+1),JB-JA+1)
      IND=INDDIR(NAME,NRN,IUNIT,'ST')
      IND=IBANK(NAME,NRN,'DL')
      IF(JA.EQ.1) NRN=100000000+100*NRN
      NRN=NRN+1
      JA=JB+1
      IF(JB.NE.NAR) GOTO 10
      IND=INDDIR(NAME,NRN,IUNIT,'DL')
      GOTO 100
C
C     FETCH DATA FOR ARRAY FROM DIRECT ACCESS DATA SET
C
   20 IND=ILINK(NAME,NRUN)
      IF(IND.NE.0) GOTO 100
      NRX=NRUN
      IND=INDDIR(NAME,NRX,IUNIT,'FE')
      IF(IND.NE.0) GOTO 25
      NRX=NPDIR(NAME,NRX,IUNIT)
      IND=ILINK(NAME,NRX)
      IF(IND.NE.0) GOTO 100
   25 CALL BMLT(1,NAME)
      CALL BDLM
      NRN=NRX
      JA=1
   30 IND=INDDIR(NAME,NRN,IUNIT,'FE')
      IF(IND.EQ.0) GOTO 40
      JB=JA+IW(IND)-1
      CALL UCOPY(IW(IND+1),AR(JA),JB-JA+1)
      IND=IBANK(NAME,NRN,'DLGC')
      IF(JA.EQ.1) NRN=100000000+100*NRN
      NRN=NRN+1
      JA=JB+1
      GOTO 30
   40 IF(JA.EQ.1) GOTO 200
      IND=IBANK(NAME,NRX,0)
      NAR=JB
C
C
C
  100 RETURN
  200 CALL ABEND
      GOTO 100
      END
