C   19/02/84 705251746  MEMBER NAME  RDALGN   (JADEGS)      FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE RDALGN
C-----------------------------------------------------------------------
C
C  AUTHOR:   J. OLSSON    1/11/81 : REMAKE ALGN BANK FOR MC AFTER CUTS
C
C       MOD: J. OLSSON    4/02/84 : IMPROVED VERSION
C       MOD: C. BOWDERY  13/02/84 : PREVENT GRAPHICS MESSAGE PRINTING
C       MOD: C. BOWDERY  19/02/84 : S/R MOVED TO SEPARATE MEMBER
C       MOD: J. OLSSON   28/07/86 : UPDATE FOR 1983-1986
C       MOD: J. OLSSON   18/08/86 : REMOVE THE RECALCULATION OF ENERGY
C                                   BASED ON REAL CALIBRATION
C  LAST MOD: J. OLSSON   25/05/87 : UPDATE READOUT THRESHOLD FOR 1986
C
C       REMAKE THE BANK ALGN FOR MC EVENTS, KILLING ALL  BLOCKS  BELOW
C       THE READOUT THRESHOLD. THIS IS TO IMITATE REAL DATA READ  OUT.
C       BLOCKS WITH >= 5 COUNTS ARE READ OUT, THE REST ARE  KILLED  TO
C       ALLOW FOR PEDESTAL VARIATION. 5 COUNTS IS ABOUT  25 MEV.  THIS
C       WAS NOT FORESEEN IN MC TRACKING.
C
C       NOTE  THAT  MC  TRACKING  DELIVERS   THE   BANK   ALGN,   WITH
C       PULSEHEIGHTS IN MEV. THEY ARE HERE  CONVERTED  TO  ADC  COUNTS
C       BEFORE THE READ OUT  THRESHOLD  CHECK.  SURVIVING  BLOCKS  ARE
C       TRANSFORMED BACK TO MEV WITH HELP OF THE  AVERAGE  CALIBRATION
C       CONSTANT (C:A 5 MEV/COUNT). THIS GIVES AN EXTRA  "GRANULARITY"
C       EFFECT, WHICH IS OF  SOME  IMPORTANCE  AT  THE  LOWEST  PHOTON
C       ENERGIES.
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
#include "cdata.for"
#include "cgraph.for"
C
      COMMON / CRDSTA / NDUM(12), IPHALG
      COMMON / CTRIGG / IHIST(3)
      COMMON / CHEADR / HEAD(108)
      COMMON / CWORK  / HELP(2,2000)
C
      DIMENSION IHELP(2000)
      EQUIVALENCE (HELP(1,1),IHELP(1))
C
      DATA JELL1/0/,JELL2/0/,JELL3/0/,JELL4/0/,JELL5/0/
C  OLD CONSTANTS, USED UNTIL JULY 1986
C     DATA CALC80/5.32/, CALC81/4.94/,ICAL80/5320/, ICAL81/4940/
C     DATA CALC83/6.50/, ICAL83/6500/
C     DATA IUN80/5/, IUN81/6/
C     DATA IUN83/6/
C
C  NEW CONSTANTS DETERMINED FROM /CALIBR/, 29.7.1986
C   THE AVERAGE IS TAKEN OVER BARREL AND ENDCAP BLOCKS, INCLUDING ALL
C   NONZERO CONSTANTS, WITH VALUES BELOW 10000
C
      DATA CALC79 /5.74/, IUN79 /5/, ICAL79 /5740/
      DATA CALC80 /5.54/, IUN80 /5/, ICAL80 /5540/
      DATA CALC81 /4.69/, IUN81 /6/, ICAL81 /4690/
      DATA CALC82 /4.61/, IUN82 /6/, ICAL82 /4610/
      DATA CALC83 /6.29/, IUN83 /6/, ICAL83 /6290/
      DATA CALC84 /6.13/, IUN84 /6/, ICAL84 /6130/
      DATA CALC85 /6.09/, IUN85 /6/, ICAL85 /6090/
      DATA CALC86 /5.94/, IUN86 /6/, ICAL86 /5944/
C
C     DATA CALC86 /6.09/, IUN86 /6/, ICAL86 /6090/  UPDATE 25.5.87
C
      DATA ICALL/0/
C
C------------------  C O D E  ------------------------------------------
C
      IF(HEAD(18).GT.100) GO TO 1000
      IF(IPHALG.EQ.0) GO TO 1000
C
      IPALGN = IDATA(IBLN('ALGN'))
      IF(IPALGN.GT.0) GO TO 1
      JELL1 = JELL1 + 1
      IF(JELL1.LT.2 .AND. NDDINN .EQ. 0 ) WRITE(6,9901)
9901  FORMAT(' * * *  RDALGN MET EVENT  WITHOUT ALGN BANK ')
      GO TO 1000
1     NWO = IDATA(IPALGN)
      IF(NWO.GT.3) GO TO 2
      JELL2 = JELL2 + 1
      IF(JELL2.LT.5) WRITE(6,9902)
9902  FORMAT(' * * *  RDALGN MET EVENT  WITH EMPTY ALGN BANK ')
      GO TO 1000
2     CONTINUE
C
C    LOOP OVER ALGN BANK
C
      IYEAR = IHIST(3)
      IYEAR = MOD(IYEAR,100)
C
      IY = IYEAR - 78
      GO TO (21,31,41,51,61,71,81,85), IY
C
85    CALC = CALC86
      ICALC = ICAL86
      IHMC = IUN86
        GO TO 150
81    CALC = CALC85
      ICALC = ICAL85
      IHMC = IUN85
        GO TO 150
71    CALC = CALC84
      ICALC = ICAL84
      IHMC = IUN84
        GO TO 150
61    CALC = CALC83
      ICALC = ICAL83
      IHMC = IUN83
        GO TO 150
51    CALC = CALC82
      ICALC = ICAL82
      IHMC = IUN82
        GO TO 150
41    CALC = CALC81
      ICALC = ICAL81
      IHMC = IUN81
        GO TO 150
31    CALC = CALC80
      ICALC = ICAL80
      IHMC = IUN80
        GO TO 150
21    CALC = CALC79
      ICALC = ICAL79
      IHMC = IUN79
C
150   CONTINUE
C
      ICALL = ICALL + 1
      IF( ICALL .GT. 1 .OR. NDDINN .NE. 0 ) GO TO 5710
      WRITE(6,5410) IHIST(3),CALC,IHMC
5410  FORMAT(' ** RDALGN **  YEAR: ',I5,'    CAL. CONST: ',F5.2,'  ',I2,
     +       ' COUNTS THRESHOLD')
5710  IPH = IPALGN*2 + 7
      IPHL = 2*(NWO + IPALGN)
      N1 = 0
      N2 = 0
      N3 = 0
      NWRD = 3
      DO 100 IH = IPH,IPHL,2
      IPU = HDATA(IH+1)
      NBL = HDATA(IH)
      PU = FLOAT(IPU)/CALC
      IPUX = IFIX(PU)
      IF(IPUX.LT.IHMC) GO TO 100
C -------------------------------------------------------
C
C THE FOLLOWING 2 STATEMENTS ARE BASED ON THE REAL DATA CALIBRATION
C THEY LEAD TO SYSTEMATICALLY TOO LOW LG ENERGIES...
C
C     IPU = IPUX * ICALC + 512
C     IPU=ISHFTR(IPU,10)
C -------------------------------------------------------
      IF(NBL.GT.0.AND.NBL.LT.2881) GO TO 5
      JELL3 = JELL3 + 1
      IF(JELL3.LT.5) WRITE(6,9903) NBL
9903  FORMAT(' * * *  RDALGN MET EVENT  WITH ILLEGAL BLOCK NR ',I6)
      GO TO 100
5     IF(NBL.LT.2689) N1 = N1 + 1
      IF(NBL.GT.2688.AND.NBL.LT.2785) N2 = N2 + 1
      IF(NBL.GT.2784) N3 = N3 + 1
      NWRD = NWRD + 1
      HELP(1,NWRD) = NBL
      HELP(2,NWRD) = IPU
100   CONTINUE
C
C   SET POINTERS
C
      IHELP(1) = IDATA(IPALGN+1)
      HELP(1,2) = 1
      HELP(2,2) = 1
      IF(N1.GT.0) HELP(2,2) = 2*N1 + 1
      HELP(1,3) = HELP(2,2) + 2*N2
      HELP(2,3) = HELP(1,3) + 2*N3
C
C  RECREATE ALGN
C
      CALL BDLS('ALGN',1)
      CALL BDLS('LGCL',1)
      CALL BGAR(IGA)
      CALL BCRE(KPALGN,'ALGN',1,NWRD,*91,IER)
      CALL BSAW( 1, 'ALGN')
      IF(IER.EQ.0) GO TO 20
C
C---- BCRE ENDS WITH AN ERROR.
C     THE 'ALGN' EXISTS ALREADY.
C
      JELL4 = JELL4 + 1
      IF(JELL4.LT.5) WRITE(6,9904)
9904  FORMAT(' * * *  RDALGN GOT ERROR IN CREATING ALGN BANK ')
      GO TO 1000
C
C---- NOT ENOUGH SPACE IN /BCS/.
   91 JELL5 = JELL5 + 1
      IF(JELL5.LT.5) WRITE(6,9905)
9905  FORMAT(' * * *  RDALGN FOUND NOT ENOUGH SPACE IN BCS ')
      GO TO 1000
C
C---- OVERWRITE 'ALGN'-BANK WITH THE HELP ARRAY
C
  20  CALL MVCL(IDATA,4*KPALGN,IHELP,0,4*NWRD)
C               TO             FROM      BYTES
C
1000  CONTINUE
      RETURN
      END
