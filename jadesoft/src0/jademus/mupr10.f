C   14/08/84 408271206  MEMBER NAME  MUPR10   (PWMUS)       FORTRAN
C   16/02/81 104100752  MEMBER NAME  MUPR10   (JADEMUS)     FORTRAN
C   11/02/81 102112042  MEMBER NAME  MUPR10P  (S)           FORTRAN
C   26/03/80 010211751  MEMBER NAME  MUPR10   (JADEMUS1)    FORTRAN
C
C LAST CHANGE 10.30 14/08/84 P. WARMING   - OUTPUT COMMENTED
C      CHANGE 07.30 10/04/81 HUGH MCCANN  - JADEMUS UPDATE.
C      CHANGE 20.45  11/02/81  HUGH MCCANN.
C                       26/03/80 HUGH MCCANN.
C-----------------------------------------------------------------------
C
C
      SUBROUTINE MUPR10(NHITS,NWHIT)
C
C  ROUTINE TO PRINT MUR1/0 RESULTS BANK.
C
      IMPLICIT INTEGER*2 (H)
#include "cmubcs.for"
C
C  FIND MUR1/0
      IP0=IDATA(IBLN('MUR1'))
      IF(IP0.LE.0)GO TO 10
      NHITS=IDATA(IP0+1)
      NWHIT=IDATA(IP0+3)
      WRITE(6,100)NHITS,NWHIT
  100 FORMAT('0 MUR1/0    NO. OF MU HITS =',I4,2X,
     *       'NO. OF 2-BYTE WORDS/HIT IN COORD BANK =',I3)
      RETURN
   10 CONTINUE
      WRITE(6,20)
   20 FORMAT('0 ******* MUR1/0 NOT FOUND ******')
      RETURN
      END