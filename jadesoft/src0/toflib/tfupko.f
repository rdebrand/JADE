C   18/02/81 207171751  MEMBER NAME  TFUPKO   (S)           FORTRAN
      SUBROUTINE TFUNPK(IPTOFR)
C
C   LHIST=1 PRODUCES ALL HISTOGRAMS
C
      COMMON/RJECT/IREJ,KREJ
      COMMON/POINT/IPHEAD,IPLTCH,IPT1,IPTOF,IPCLST,IPR,IPPATR,IPNT(12),
     1             IPBP
      COMMON/EVRUN/NRUN,IEV,ITYP,NEV,IMISS
      COMMON/ENRGMG/BENGEV,BKGAUS,EGCOR
      COMMON/TOFHIT/XTOF(50),YTOF(50),ZTOF(50)
      COMMON/TRKINF/LTRK,DX1(10),DY1(10),DZ1(10),DXL(10),DYL(10),
     1            DZL(10),NXY(10),NRZ(10),CHIXY(10),ZPTOF(10),CHIRZ(10),
     2              X1(10),Y1(10),Z1(10),XL(10),YL(10),ZL(10),ZVER(10),
     3              NGOOD,IGOOD(10),PMOM(10),FI1(10),FIL(10),
     4              NFIN,ITRK1(10),ITRK2(10),RMIN(10)
      COMMON/TOFRES/TOFLGT(10),TDT(10),TDR(10),BETA(10),IQUAL(10)
     1          ,ITOFHT(10),PATH(10),MUCAND,IMUCND(10),NMU,IMUFIN(10)
     2          ,TAUMR(42),TAUPR(42)
      COMMON/TRACC/NACC,ALF(10),NMALF
      COMMON/DT4/NTGOOD(10),DDT1(10),DDT2(10),DDT3(10),DDT4(10)
#include "ddatas.for"
      COMMON/INOUT/WRITFL,EVWRIT
      COMMON/FLAGS/HISTFL,PRFL,NPRLIM
      LOGICAL WRITFL,EVWRIT,HISTFL,PRFL
      DIMENSION KKREJ(10),JTRK(2),NC1(10)
      DIMENSION RTOF(14,50),ITOF(14,50)
      EQUIVALENCE (RTOF(1,1),ITOF(1,1))
C
      DATA IBUG/ 0/,KBUG/ 0/,IENTRY/0/,JBUG/30/,KERR/0/
      DATA LBUG/0/,NPRREJ/0/
      DATA CVEL/  2.997925E2 /,RADTOF/920./
C
      IF(IENTRY.NE.0)  GOTO  19
      IENTRY = 1
      CFIC = 3.142/12.
      CTOF = 6.284/42.
      CTOF2= CTOF/2.
C     CALL HDELET(0)
      ZA = NRUN
      ZB = ZA+700.
      CALL HBOOK1(3507,20HREJECT CODES       $,100,0.,100.)
      CALL HTABLE(3506,' TOF CNTR FLAG $',42,0.,42.,4,-2.,2.,511.)
      CALL HBOOK1(1703,20HQUAL1              $,4,-2.,2.)
      CALL HBOOK1(1701,20H BETA              $,100,-1.,4.)
      CALL HBOOK2(1711,15HT      ITOF   $,100,-5.,15.,42,0.,42.)
      CALL HBOOK2(1702,15HNRUN TOF      $,100,ZA,ZB,40,-5.,15.)
C
   19 CONTINUE
      EVWRIT = .FALSE.
      CALL SETSL(KKREJ,0,40,0)
      MUCAND = 0
      NTR = IDATA(IPTOFR+1)
      CALL HF1(3507,20.,1.)
      KREJ = 70
      IF(NTR.NE.2) GOTO  60
      KREJ = 72
      CALL HF1(3507,22.,1.)
C
C
      DO   1   N=1,50
      DO   1   I=1,14
      RTOF(I,N) = DATA(IPTOFR+4+(N-1)*14+I)
    1 CONTINUE
C
      KREJ = 74
      CALL HF1(3507,23.,1.)
C
      JBUG = JBUG + 1
      IMU = 0
C
      IBUG = IBUG + 1
      IF(IBUG.LE.10) PRINT 106,NRUN,NEV,IEV,NTR,NOHIT
  106 FORMAT(' TFPROD NTR',8I5)
      IF(IBUG.LE.10) CALL TOFRPR
C
      CALL SETSL(NC1,0,40,0)
      DO   4   M=1,NTR
      NC1(1) = NC1(1)+1
      CALL HF1(3507,48.,1.)
C     P1 = ABS(PMOM(M))
      NC1(2) = NC1(2)+1
C
C  CHECK QUALITY OF TOF DETERMINATION
C
      CALL HF1 (1703,FLOAT(ITOF(2,M)),1.)
      IF(ITOF(2,M).GE.10)  GOTO  4
      ITOF1 = ITOF(3,M)
      CALL HFILL(3506,FLOAT(ITOF1),FLOAT(ITOF(2,M)))
      IF(ITOF(2,M).NE.1)  GOTO  4
      NC1(6) = NC1(6)+1
      CALL HF1(3507,60.,1.)
C
C
      PCOR1 = (RTOF(5,M)-RADTOF)/CVEL
      T1 = RTOF(4,M)-PCOR1
C     TAUMR(ITOF1) = TAUM(ITOF1)-PCOR1
C     TAUPR(ITOF1) = TAUP(ITOF1)-PCOR1
      NC1(8) = NC1(8)+1
C
C     IF(HSTAT(ITOF1).NE.2)CALL HFILL(1711,TAUMR(ITOF1),FLOAT(ITOF1))
C     IF(HSTAT(ITOF2).NE.2)CALL HFILL(1711,TAUMR(ITOF2),FLOAT(ITOF2))
C     IF(HSTAT(ITOF1).NE.1)CALL HFILL(1712,TAUPR(ITOF1),FLOAT(ITOF1))
C     IF(HSTAT(ITOF2).NE.1)CALL HFILL(1712,TAUPR(ITOF2),FLOAT(ITOF2))
      CALL HFILL(1711,T1,FLOAT(ITOF1))
      CALL HFILL(1702,FLOAT(NRUN),T1)
      CALL HF1(1701,RTOF(6,M),1.)
C
    7 IMU = IMU + 1
      IF(IMU.GT.10)  GOTO  4
      NC1(10) = NC1(10)+1
    4 CONTINUE
C
      DO   59   I=1,10
      IF(NC1(I).LE.0)  GOTO  59
      CALL HF1(3507,90.+FLOAT(I),1.)
   59 CONTINUE
C
   60 CONTINUE
      IF(MUCAND.LE.0) NPRREJ = NPRREJ + 1
      IF(MUCAND.LE.0.AND.NPRREJ.LE. 0)
     1  PRINT 701,NRUN,IEV,NEV,KREJ,KKREJ
  701 FORMAT(' REJECTED TFUNPK ',3I6,5X,I2,5X,10I3)
C
      RETURN
  997 CONTINUE
      KERR = KERR + 1
      IF(KERR.GT.20) RETURN
      PRINT 118
  118 FORMAT(' ERROR IN TOFR BANK')
      RETURN
      END
