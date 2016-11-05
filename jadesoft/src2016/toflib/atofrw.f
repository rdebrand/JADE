C   03/12/81 112151000  MEMBER NAME  ATOFRW   (S)           FORTRAN
      SUBROUTINE ATOFRW(IPTOF)
      IMPLICIT INTEGER*2 (H)
      COMMON /CHEADR/ IHEADR(54)
      EQUIVALENCE (IHEADR(1),HEADR(1))
      COMMON/BCS/IDATA(1)
      DIMENSION HDATA(2),HEADR(108)
      EQUIVALENCE  (HDATA(1),IDATA(1))
      DATA NRUNB,IEVB/0,0/,IBUG/0/
C
      IBUG = IBUG + 1
      NRUN = HEADR(18)
      IEV  = HEADR(19)
      IF(NRUN.EQ.NRUNB.AND.IEV.EQ.IEVB) GOTO 70
      IA = IPTOF-2
      PRINT 101,NRUN,IEV,IBUG,IDATA(IA-1),(IDATA(I),I=IA,IPTOF)
  101 FORMAT(//1X,' *** ATOFRW ',3I5,' ***',A5,3I5)
      IA = IPTOF*2+1
      IB = IA + 1
      PRINT 105,(HDATA(I),I=IA,IB)
  105 FORMAT(' BANK DESCRIPTOR',2I5)
      IA = IPTOF*2+3
      IB = IPTOF*2 + IDATA(IPTOF)*2
      PRINT 102,(HDATA(I),I=IA,IB)
      PRINT 104
      PRINT 104
  102 FORMAT(1X,20I6)
  104 FORMAT(/)
   70 NRUNB = NRUN
      IEVB = IEV
      RETURN
      END
