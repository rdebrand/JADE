C   05/11/82 311221845  MEMBER NAME  DETHRY   (S)           FORTRAN
       FUNCTION DETHRY(PMOM)
C
C           RETURNS 'THEORETICAL' VALUE OF JADE DEDX FOR GIVEN
C        MOMENTUM PMOM, ASSUMING A PION MASS.
C        THE 'THEORETICAL' VALUES IN THE TABLE HAVE BEEN FOUND
C        USING A. WAGNER'S THEORETICAL-EMPIRICAL FUNCTION 'DEDXTH'.
C        THE FUNCTION IS BASED ON A MODIFIED STERNHEIMER TREATMENT.
C
C                                                  J.A.J.SKARD, 14/8/83
C
C        FUNCFL IS A FLAG TO DETERMINE WHETHER TO USE AN INTERPOLATION
C        OF THE TABLE VALUES, OR THE FUNCTION DEDXTH DIRECTLY.
C
C        ********   SR POLINT ON CERNLIB   ********
C
      LOGICAL FUNCFL/.TRUE./
C        EXPERIMENTAL VALUE FOR DE/DX AT MINIMUM
      DATA DEMIN/7.2/
C        ORDER OF POLYNOMIAL APPROXIMATION IN POLINT IS NORDR-1
       DATA NORDR/3/
       DIMENSION P(40),D(40)
       DATA P/0.009,.01,.02,.03,.04,.04463,.05,.06,.07,.08,
     1        .0848,.09,.1,.104,.119,.1339,.149,.2,.253,.3,
     2        .4,.5,.6,.7,.8,.9,1.,2.,3.,4.,
     3        6.,8.,10.,20.,30.,60.,100.,200.,300.,600./
       DATA D/
     1      1375.,1118.,283.3,129.1,75.12,61.46,50.16,36.59,28.43,23.14,
     2      21.24,19.52,16.93,16.10,13.71,12.10,10.95,8.856,7.952,7.567,
     3      7.252,7.199,7.224,7.273,7.330,7.390,7.449,7.919,8.227,8.451,
     4      8.771,8.978,9.108,9.435,9.577,9.746,9.823,9.879,9.893,9.899/
      IF(FUNCFL)GO TO 50
       DO 10 K=1,39
       IF(PMOM .LT. P(K)) GOTO 20
10     CONTINUE
20     IF(K .LT. 2) K=2
       CALL POLINT(D(K-1),P(K-1),NORDR,PMOM,DD)
       DETHRY=DD
       RETURN
C        USE THEORETICAL-EMPIRICAL FUNCTION DIRECTLY
50    BETGAM=PMOM/0.139
      BET=BETGAM/SQRT(1.0+BETGAM*BETGAM)
      GAM=BETGAM/BET
C     IF(BETGAM.LE.0..OR.GAM.LE.0..OR.BET.LE.0.) WRITE(6,999)
C    *       BETGAM,GAM,BET,PMOM
C 999 FORMAT(' *** DETHRY: BETGAM,GAM,BET,PMOM:',4E12.4)
      DETHRY=THDEDX(BET,GAM,DEMIN)
      RETURN
       END
