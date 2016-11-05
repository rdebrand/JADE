      SUBROUTINE THRUNB( P, NP, NMAXP, PTHR, AXIS, ITMERR )
      DIMENSION P(1), AXIS(3)
      DIMENSION PIN(320), IPERM(80),IPS(320),PS(320)
      COMMON / CWORK / WORK(720)
      EQUIVALENCE (WORK(1),PIN(1)),(WORK(321),IPERM(1))
      EQUIVALENCE (WORK(401),PS(1)),(WORK(401),IPS(1))
      DATA IPINC / 4 /
      DATA NLIMIT / 15 /
      DATA NSEC / 2 /
      ITMERR = 0
      NMAXP1 = NMAXP
      IF(
     -  NP.GE.NLIMIT .AND. ( NMAXP.EQ.0 .OR. NMAXP.GT.NLIMIT )
     -)THEN
      ASSIGN 17001 TO IZZZ01
      GOTO 17000
17001 CONTINUE
      NMAXP1 = NLIMIT
      ENDIF
      NTOT = NP
      NP1 = NTOT
      IF(
     - NTOT.GT.NMAXP1 .AND. NMAXP1.NE. 0
     -)THEN
      ASSIGN 17003 TO IZZZ02
      GOTO 17002
17003 CONTINUE
      NTOT = NMAXP1 - 1
      ASSIGN 17005 TO IZZZ03
      GOTO 17004
17005 CONTINUE
      ELSE
      CALL UCOPY( P, PIN, NTOT*4 )
      ENDIF
      ASSIGN 17007 TO IZZZ04
      GOTO 17006
17007 CONTINUE
      ASSIGN 17009 TO IZZZ05
      GOTO 17008
17009 CONTINUE
      RETURN
17000 CONTINUE
      WRITE(6,9101) NP,NLIMIT,NMAXP
 9101 FORMAT(' +++++  WARNING FROM THRUST ROUTINE  +++++'/
     *       2X,I4,' ARE TOO MANY INPUT VECTORS. NLIMIT=',I4,
     *' INPUT CUTOFF NMAXP=',I4,'.PTHR VAL. FOR NMAXP=NLIMIT WAS TAKEN')
      GOTO IZZZ01
17002 CONTINUE
      DO 13000 J=1,NTOT
      IPERM(J) = J*4
13000 CONTINUE
13001 CONTINUE
      M = NTOT / 2
15000 CONTINUE
      IF(
     -  M.GT.0
     -)THEN
      K = NTOT - M
      DO 13002 J=1,K
      I = J
15002 CONTINUE
      IF(
     -  I.GT.0
     -)THEN
      ILOW = IPERM(I)
      IHIGH = IPERM(I+M)
      IF(
     -  P(IHIGH) .GT. P(ILOW)
     -)THEN
      IPERM(I) = IHIGH
      IPERM(I+M) = ILOW
      I = I - M
      ELSE
      GOTO 15003
      ENDIF
      GOTO 15002
      ENDIF
15003 CONTINUE
13002 CONTINUE
13003 CONTINUE
      M = M/2
      GOTO 15000
      ENDIF
15001 CONTINUE
      GOTO IZZZ02
17004 CONTINUE
      DO 13004 J=1,NTOT
      IPJ = IPERM(J)
      J4 = J*4
      PIN(J4  ) = P(IPJ  )
      PIN(J4-1) = P(IPJ-1)
      PIN(J4-2) = P(IPJ-2)
      PIN(J4-3) = P(IPJ-3)
13004 CONTINUE
13005 CONTINUE
      GOTO IZZZ03
17006 CONTINUE
      NUP = NTOT*4 - 4
      K = 5
      IPS(1) = 1
      IPS(K) = 1
      PS(2) = 0.
      PS(3) = 0.
      PS(4) = 0.
      PM2 = 0.
16000 CONTINUE
      ASSIGN 17011 TO IZZZ06
      GOTO 17010
17011 CONTINUE
      IF(
     - IPS(K) .LT. NUP
     -)THEN
      ASSIGN 17013 TO IZZZ07
      GOTO 17012
17013 CONTINUE
      ELSE
      ASSIGN 17015 TO IZZZ08
      GOTO 17014
17015 CONTINUE
      ENDIF
      IF(.NOT.(
     - IPS(1) .NE. 1
     -))GOTO 16000
16001 CONTINUE
      AXISL = SQRT( PM2)
      DO 13006  J=1,3
      AXIS(J) = AXIS(J) / AXISL
13006 CONTINUE
13007 CONTINUE
      PSUM = 0.
      NIPINC = NTOT * 4
      DO 13008 J = 4,NIPINC,4
      PSUM = PSUM + PIN(J)
13008 CONTINUE
13009 CONTINUE
      PTHR = 2. * AXISL / PSUM
      GOTO IZZZ04
17008 CONTINUE
      NIPINC = NP1*IPINC
      SPCOS = 0.
      PSUM = 0.
      DO 13010 J=1,NIPINC,IPINC
      SPCOS = SPCOS + ABS( AXIS(1)*P(J)+AXIS(2)*P(J+1)+AXIS(3)*P(J+2) )
      PSUM = PSUM + P(J+3)
13010 CONTINUE
13011 CONTINUE
      PTHR = SPCOS / PSUM
      GOTO IZZZ05
17010 CONTINUE
      J = IPS(K)
      PS(K+1) = PS(K-3) + PIN(J  )
      PS(K+2) = PS(K-2) + PIN(J+1)
      PS(K+3) = PS(K-1) + PIN(J+2)
      PCL2 = PS(K+1)*PS(K+1) + PS(K+2)*PS(K+2) + PS(K+3)*PS(K+3)
      IF(
     -  PCL2 .GT. PM2
     -)THEN
      PM2 = PCL2
      AXIS(1) = PS(K+1)
      AXIS(2) = PS(K+2)
      AXIS(3) = PS(K+3)
      ENDIF
      GOTO IZZZ06
17012 CONTINUE
      K = K + 4
      IPS(K) = IPS(K-4) + 4
      GOTO IZZZ07
17014 CONTINUE
      K = K - 4
      IPS(K) = IPS(K) + 4
      IF(
     -  JUHR(NSEC) .EQ. 2
     -)THEN
      ASSIGN 17017 TO IZZZ09
      GOTO 17016
17017 CONTINUE
      RETURN
      ENDIF
      GOTO IZZZ08
17016 CONTINUE
      AXIS(1) = 0.
      AXIS(2) = 0.
      AXIS(3) = 1.
      PTHR = .5
      ITMERR = 1
      WRITE(6,9102) NSEC,NP,NMAXP,NLIMIT
 9102 FORMAT(' +++++++   TIME PROBLEMS IN THRUST - ROUTINE   ++++++++'/
     *       '        REMAINING TIME IS LESS THAN ',I4,' SECS.'/
     *       '        ',I4,' ARE TOO MANY INPUT VECTORS.  NMAXP =',I4,
     *       ' NLIMIT =',I4/
     *       '         AXIS WAS SET TO Z AXIS AND PTHR = .5')
      GOTO IZZZ09
      END
