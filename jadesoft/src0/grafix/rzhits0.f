C   01/11/84 504171354  MEMBER NAME  RZHITS   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE RZHITS(IPZETC,XZ,YZ,XZ1,YZ1,XZ2,YZ2,ZZ1,ZZ2,IERR)
C-----------------------------------------------------------------------
C
C    AUTHOR:   J. OLSSON        ?     :  CALCULATE COORDINATES OF
C                                        FOR RZ CHAMBERS
C
C       MOD:   J. HAGEMANN   09/10/84 :  NOW OWN MEMBER (FROM EVDISP)
C  LAST MOD:   C. BOWDERY    17/04/85 :  COMMENT OUT ERROR PRINTOUT
C
C        IPZETC POINTS TO WORD BEFORE THE  QUADRUPLE OF HALFWORDS IN BCS
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL TBIT
C
#include "cdata.for"
#include "cgraph.for"
C
      COMMON /CZGEO/ RZCHI,RZCHA,NZRPSI,NZZ,Z1ZCH,Z2ZCH,ZCHA,ZCHB,ZCHSS,
     $               ZCHDL,ZCHDLL,DLZZ,DLZPHI,DLZW1,DLZW2
      COMMON /CZKON/ ZCVDR,ZCXCH,ZCTZER,ZCAPED,XL1,XL2
C
      COMMON /CJTRIG/ PI,TWOPI,PIHALF,PI3HAF
C
      DATA ICAL /0/,RESOL/40./
C
C-----------------  C O D E  -------------------------------------------
C
      IERR = 0
      ICAL = ICAL + 1
      IF(ICAL.NE.1) GO TO 2
      FI24 = PI/12.
      FI48 = FI24*.5
      COS48 = COS(FI48)
      SIN48 = SIN(FI48)
      RINRZ = RZCHI/COS48
      RUTRZ = RZCHA/COS48
2     HPZC = 2*IPZETC
      IWIR = HDATA(HPZC+1)
      IWIR = SHFTR(IWIR,3)
      IF(IWIR.GE.0.AND.IWIR.LE.63) GO TO 1
      WRITE(6,6248) IWIR,(HDATA(HPZC+I),I=1,4)
6248  FORMAT(' WRONG WIRE NR RZ CHAMBERS: ',I10,3X,4I8)
333   XZ = 0.
      YZ = 0.
      ZZ1 = 0.
      ZZ2 = 0.
      IERR = 1
      RETURN
1     IA1 = HDATA(HPZC+2)
      IA2 = HDATA(HPZC+3)
      IT = HDATA(HPZC+4)
      KWIR = IWIR
      IF(IWIR.GT.31) KWIR = KWIR - 32
      ZW = Z1ZCH + DLZZ*.5 +(KWIR/2)*DLZZ
      DELZ = FLOAT(IT)*ZCVDR
      ZZ1 = ZW - DELZ
      ZZ2 = ZW + DELZ
      IASUM = IA1 + IA2
      IF(IASUM.GT.0) GO TO 6251
C     WRITE(6,6249) IWIR,(HDATA(HPZC+I),I=1,4)
6249  FORMAT(' SUM OF AMPLITUDES <=0: ',I10,3X,4I8)
      GO TO 333
6251  XLXL = XL1
      DLZWW = DLZW1
      RWIR = RINRZ+ZCHA
      IF(.NOT.TBIT(IWIR,31)) GO TO 222
      XLXL = XL2
      DLZWW = DLZW2
      RWIR = RINRZ+ZCHB
222   CONTINUE
      XL1ML2 = .5*XLXL*FLOAT(IA2-IA1)/(FLOAT(IASUM)*ZCXCH)
      IF(IWIR.GT.31) XL1ML2 = - XL1ML2
C      IF((ICAL/10)*10.EQ.ICAL) WRITE(6,6665) XLXL,DLZWW,ZZ1,ZZ2,XL1ML2
C      IF(ICAL.LT.2) WRITE(6,6665) XLXL,DLZWW,ZZ1,ZZ2,XL1ML2
C
C        L1           I                   L2
C A1------------------I------------------------------------------A2
C                     I
C
C    -X SIDE HAS OPPOSITE ARRANGEMENT
C
C   WIRES RUN FROM -Z TO +Z    0-31  ON +X SIDE     32-63 ON -X SIDE
C
C
C
      IRFI = ABS(XL1ML2/DLZWW)
      IF(XL1ML2.LT.0.) IRFI = - IRFI
      IF(IABS(IRFI).LT.6) GO TO 7611
      WRITE(6,7612) IRFI
7612  FORMAT(' ERROR RFI COORD OUTSIDE CHAMBER, IRFI:',I6)
      WRITE(6,6247) IWIR,(HDATA(HPZC+I),I=1,4)
6247  FORMAT(' WIRE NR, HIT DATA ',I5,2X,4I6)
      WRITE(6,6665) XLXL,DLZWW,ZZ1,ZZ2,XL1ML2
6665  FORMAT(' XLXL DLZWW ZZ1 2 L1-L2 ',5E12.4)
      GO TO 333
7611  XLLX = FLOAT(IRFI)*DLZWW
      REST = XL1ML2 - XLLX
      PHIZ = IRFI*FI24
      FACTW = 1.
      IF(REST.LT.0) FACTW = -1.
      IF(IWIR.GT.31) PHIZ = PI - PHIZ
      IF(IWIR.GT.31) FACTW = -FACTW
      COSPH = COS(PHIZ)
      SINPH = SIN(PHIZ)
      XWIR = RWIR*COSPH
      YWIR = RWIR*SINPH
      EX = - SINPH*SIN48 + FACTW*COSPH*COS48
      EY = - COSPH*SIN48 - FACTW*SINPH*COS48
      AREST = ABS(REST)
      AAA = AREST*EX
      BBB = AREST*EY
      XZ = XWIR+BBB
      YZ = YWIR+AAA
      AREST1 = AREST - RESOL
      AAA1 = AREST1*EX
      BBB1 = AREST1*EY
      XZ1 = XWIR+BBB1
      YZ1 = YWIR+AAA1
      AREST2 = AREST + RESOL
      AAA2 = AREST2*EX
      BBB2 = AREST2*EY
      XZ2 = XWIR+BBB2
      YZ2 = YWIR+AAA2
C     IF(LASTVW.LT.3) CALL DRAMOV(-XWIR,YWIR,-XZ,YZ,0)
C     IF(ICAL.LT.2) WRITE(6,6667) IRFI,FACTW,REST,XWIR,YWIR,AAA
C     IF((ICAL/10)*10.EQ.ICAL)
C    $ WRITE(6,6667) IRFI,FACTW,REST,XWIR,YWIR,AAA
C6667  FORMAT(' IRI FW REST XYWR AAA ',I3,F4.0,4E12.4)
C      IF(ICAL.LT.2) WRITE(6,6668) EX,EY,BBB,XZ,YZ
C6668  FORMAT(' EXY BBB XYZ ',5E12.4)
      RETURN
      END