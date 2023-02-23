C   25/06/78 708272040  MEMBER NAME  ENELS    (S)           FORTRAN
      FUNCTION ENELS(E)
C
C THIS FUNCTION GIVES THE RESTRICTED IONIZATION LOSS, I.E. ENERGY LOSS
C UP TO A PREASSIGNED VALUE. THIS VALUE IS GIVEN BY /M0PAR/CUTM, WHICH
C IS SET IN MCIN56 TO 0.5 (MEV). THE FORMULA IS NR (60) IN STERNHEIMER,
C P.R.B (1971) 3681.
C NOTE THAT THIS IS NOT COMPLETELY TRUE, THE TERM -2BETA**2 SHOULD BE
C  ONLY -BETA**2 IN THIS FORMULA
C
C  NOTE THAT THE INPUT ENERGY COMES IN UNITS OF ME, I.E. == GAMMA,
C  THEREFORE     BETA**2 = 1 - 1/E**2
C  LN2 = .69315
C  CON = LN(P/MC) = LN(M BETA GAMMA/M) = LNE + .5 * LN(BETA**2)
C
C  COMMON/ILPAR/ IS SET IN PARST2, CALLED BY INTSHW
C
      COMMON/ILPAR/AI,BI,ALCUTM
      BE2=1.-1./E**2
      IF(BE2.LE.0.)GOTO10
      CON=ALOG(E)+ALOG(BE2)/2.
      ENELS=AI*(BI+0.69315+2.*CON+ALCUTM-2.*BE2
     @         -DENDEL(0.434294*CON))/BE2
C FUNCTION DENDEL CALCULATES DENSITY EFFECT CORRECTION.
      RETURN
 10   ENELS=0.
      RETURN
      END
