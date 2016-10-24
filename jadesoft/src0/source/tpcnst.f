C   13/02/79 005110616  MEMBER NAME  TPCNST   (SOURCE)      FORTRAN
      SUBROUTINE TPCNST( NPHD )
C
C     S.YAMADA   13-02-79  22:10
C---- LAST MODIFICATION   22-08-79  10:05  E.ELSEN
C
C---- FETCH EVENT CONSTANTS FOR ANALYSIS FROM THE 'HEAD'-BANK
C
#include "cdata.for"
C
      COMMON /CTPCNS/ EBMGEV, BKGAUS, NORDFG(15)
      DATA CONVF/0.001/
C
C
      NPHD2 = NPHD + NPHD
C
      EBMGEV = 0.001*HDATA( NPHD2+29 )
      IF(EBMGEV.LT.1.) EBMGEV=1.
      BKGAUS = CONVF*HDATA( NPHD2+30)
C
C---- UNPACK THE NORD READOUT PATTERN.
      NRP = HDATA(NPHD2+13)
        DO 1 I=1,15
        NRPW = NRP/2
        NORDFG(16-I) = NRP-2*NRPW
    1   NRP = NRPW
C//////////////////////////////
C       WRITE(6,6000) EBMGEV,BKGAUS, NORDFG
C6000   FORMAT(' EBMGEV,BKGAUS=',2E12.4,'  NORDFG=',8I2,2X,8I2)
C//////////////////////////////
      RETURN
      END