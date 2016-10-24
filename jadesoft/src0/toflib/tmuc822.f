C   14/06/82 206142136  MEMBER NAME  TMUC822  (S)           FORTRAN
      SUBROUTINE TMUCUT(IPCLST,LHIST)
      INTEGER *2 HADC,HTDC
      COMMON/RJECT/IREJ,KREJ
      COMMON/MOMSTF/DM1,DM2,SAG,SNDFI,ACOP,PN1,PN2
      COMMON/TFPRM/ NRNC1,NRNC2,DYC1,DYC2,IFLC(42),CM(42),CP(42),
     -DTAU(42),WM(42),WP(42),SV(42),DM(42),DP(42),PEDLM(42),PEDLP(42)
      COMMON/TFPED/ HADC(2,42),HTDC(2,42),HB(42)
#include "ddatas.for"
      COMMON/TRKCLS/IBH,LCL(2,10),DXLG(2,10),DYLG(2,10),DZLG(2,10),
     1              ENCL(2,10),PHILG(2,10),ZLG(2,10)
      COMMON/TRGWRD/IANDOR
      COMMON/CLUST/NCLST,ETOTB,ALFLG(10),ACOPL(10)
      COMMON/TRACC/NNACC,ALF(10),NMALF
      COMMON/PU/ NTOF,NBEAM,IHIT(150),ILG(50),DPHI
      COMMON/EVRUN/NRUN,IEV,ITYP,NEV,IMISS
      COMMON/LGCUT/ELGCUT,ETCUT,ALFCUT,ACUT,TDTCUT,PCUT
      COMMON/TRKVTX/XCLOS(10),YCLOS(10),ZCLOS(10),XVTX(10),YVTX(10),
     1              ZVTX(10)
      COMMON/TRKINF/NTRK,DX1(10),DY1(10),DZ1(10),DXL(10),DYL(10),
     1              DZL(10),NXY(10),NRZ(10),CHIXY(10),DRZ(10),CHIRZ(10),
     2              X1(10),Y1(10),Z1(10),XL(10),YL(10),ZL(10),ZVER(10),
     3              NGOOD,IGOOD(10),PMOM(10),FI1(10),FIL(10),
     4              NFIN,ITRK1(10),ITRK2(10),RMIN(10)
      COMMON/ENRGMG/BENGEV,BKGAUS,EGCOR
      COMMON/INCLI/RTHET(10)
      COMMON/TOFRES/TOFLGT(10),TDT(10),TDR(10),BETA(10),IQUAL(10)
     1          ,ITOFHT(10),PATH(10),MUCAND,IMUCND(10),NMU,IMUFIN(10)
     2          ,TAUR(42,2)
      COMMON/DT4/NTGOOD(10),DDT1(10),DDT2(10),DDT3(10),DDT4(10)
      COMMON/TMTP/TAUM(42),TAUP(42)
      COMMON/MUTRK/NTRMU,IMUIN(10),IQUMU(10),ILAYR(10),NTHITS(10),
     1             CHIMU(10),ILASTL(10),IMUEF(10)
      COMMON/FLAGS/HISTFL,PRFL,NPRLIM
      COMMON/INOUT/WRITFL,EVWRIT,EVSEL,EVFL(10)
      LOGICAL WRITFL,EVWRIT,HISTFL,PRFL,PRSPC,EVSEL,EVFL
      DIMENSION JTRK(2),ECLUST(2),PLIM(2)
C
      DATA IBUG/0/,IENTRY/0/,KBUG/20/,LBUG/0/
C  TIME AND ENERGY DEPENDENT CUTS
      ELGCUT = EGCOR/3.
      ETCUT = 2.*ELGCUT
      ACUT = 1.
      IF(NRUN.LT.6060) ACUT = .76
      PCUT = EGCOR/3.
C
      IF(IENTRY.NE.0)  GOTO  10
      IENTRY = 1
      CFIC = 3.142/12.
      CTOF = 3.142/21.
C CONSTANT CUTS
      TDTCUT = 3.00
      ALFCUT = .200
      PRINT 924,ACUT,TDTCUT,PCUT,ELGCUT,ETCUT,ALFCUT
  924 FORMAT(' THETA ACC CUT',T20,F10.3/' TDTCUT',T20,F10.2/' PCUT',T20,
     1 F10.1/' ELGCUT',T20,F10.1/' ETCUT ',F10.2/
     2 ' ALFCUT',T20,F10.3//)
      ID = 2000
      CALL HBOOK1(3508,20HLTGOOD             $,100,0.,100.)
C
      CALL HBOOK1(ID+12,20H  ALFATR           $,100,0.,1.)
      CALL HINTEG(ID+12,3HYES)
      IF(LHIST.NE.1)  GOTO  11
      CALL HBOOK1(ID+29,20H P AVERAGE         $,100,0.,50.)
      CALL HBOOK2(ID+13,' ELG1 ELG2$', 40,0.,8.,40,0.,8.)
      CALL HBOOK2(ID+8,' DZ1 QUMU $',100,-1.,1.,5,0.,5.)
      CALL HTABLE(ID+22,20HQUAL1 QUAL2        $,4,-2.,2.,4,-2.,2.,8191.)
C
      CALL HBOOK2(ID+3,15HLTGOOD DT1800 $,100,-10.,15.,5,0.,5.)
      CALL HBOOK2(ID+4,20HT1 T2              $,40,-5.,15.,40,-5.,15.)
      CALL HBOOK1(ID+5,20HTDT                $,100,-10.,15.)
      CALL HBOOK2(ID+6,15HZ1 Z2         $,25,-150.,150.,25,-150.,150.)
      CALL HBOOK1(ID+7,20H ZZVV              $,100,-200.,200.)
      CALL HBOOK1(ID+9,10HCOS THETA$,100,-1.,1.)
      CALL HBOOK1(ID+10,20HTHETA              $,100,-1.,1.)
      CALL HBOOK1(ID+11,20HFI                 $,100,0.,6.)
   11 IF(LHIST.NE.2)  GOTO  10
   10 CONTINUE
C
      NMU = 0
      EVWRIT = .FALSE.
      EVSEL  = .FALSE.
      EVFL(2)  = .FALSE.
      IREJ = 1
      CALL HF1(3508,39.,1.)
      IF(MUCAND.LE.0) GOTO  60
      CALL HF1(3508,40.,1.)
      IREJ = 3
      NCLST = IDATA(IPCLST+7)
      NCLSTB = IDATA(IPCLST+8)
      ETOTB = DATA(IPCLST+12)
C
      IF(NCLST.LE.0) GOTO  24
      CALL HF1(3508,41.,1.)
      CALL CONBHA(IPCLST,0)
C
   24 CONTINUE
      IF(MUCAND.GT.10) MUCAND = 10
      CALL ALPHA
      DO   2000   N = 1,MUCAND
      IMUFIN(N) = 0
      NF = IMUCND(N)
      I1= ITRK1(NF)
      I2= ITRK2(NF)
      JTRK(1) = I1
      JTRK(2) = I2
C  ASSIGN CLUSTER TO TRACK
      ECLUST(1) = 0.
      ECLUST(2) = 0.
      ALFLG(NF) = 1000.
      ACOPL(NF) = 1000.
      IF(LCL(1,NF).GT.0) ECLUST(1) = ENCL(1,NF)
      IF(LCL(2,NF).GT.0) ECLUST(2) = ENCL(2,NF)
      CALL HFILL(ID+13,ECLUST(1),ECLUST(2))
C
C COMPUTE ACOLLINEARITY LEADGLASS
C
      IF(LCL(1,NF).LE.0.OR.LCL(2,NF).LE.0)  GOTO 25
      CALL HF1(3508,42.,1.)
      DXLG1 = DXLG(1,NF)
      DXLG2 = DXLG(2,NF)
      DYLG1 = DYLG(1,NF)
      DYLG2 = DYLG(2,NF)
      DZLG1 = DZLG(1,NF)
      DZLG2 = DZLG(2,NF)
      COS = DXLG1*DXLG2 + DYLG1*DYLG2 + DZLG1*DZLG2
      IF(ABS(COS).GE.1.)  GOTO  91
      ALFLG(NF) = 3.142-ABS(ACOS(COS))
   91 COPLN1 = SQRT(DXLG1*DXLG1+DYLG1*DYLG1)
      COPLN2 = SQRT(DXLG2*DXLG2+DYLG2*DYLG2)
      IF(ABS(COPLN1*COPLN2).LE..00000001)  GOTO  25
      COP = (DXLG1*DXLG2+DYLG1*DYLG2)/COPLN1/COPLN2
      IF(ABS(COP).GE.1.)  GOTO  25
      ACOPL(NF) = 3.142-ABS(ACOS(COP))
   25 CONTINUE
C
      T1 = TDR(JTRK(1))
      T2 = TDR(JTRK(2))
      ITOF1 = ITOFHT(JTRK(1))
      T1M = TAUR(ITOF1,1)
      T1P = TAUR(ITOF1,2)
      ITOF2 = ITOFHT(JTRK(2))
      T2M = TAUR(ITOF2,1)
      T2P = TAUR(ITOF2,2)
C
      ZZVV = .5*(ZVER(I1)+ZVER(I2))
      IQU1 = IQUAL(I1)
      IQU2 = IQUAL(I2)
      IF(ITOF1.EQ.8.OR.ITOF1.EQ.11)  GOTO  150
      IF(IQU1.LT.0.OR.IQU2.LT.0) EVFL(2) = .TRUE.
      GOTO  151
  150 IF(IQU2.LT.0) EVFL(2) = .TRUE.
  151 P1 = ABS(PMOM(I1))
      P2 = ABS(PMOM(I2))
      PB1 = PMOM(I1)
      PB2 = PMOM(I2)
      PAV = .5*(P1+P2)
      DDX1 = 3.142-ACOS(DX1(I1))-ACOS(DX1(I2))
      DDY1 = 3.142-ACOS(DY1(I1))-ACOS(DY1(I2))
      DDZ1 = 3.142-ACOS(DZ1(I1))-ACOS(DZ1(I2))
C
C  ACCEPTANCE CUT
C
      IREJ = 5
      IF(ABS(DZ1(I1)).GT.ACUT)  GOTO  2000
      IF(ABS(DZ1(I2)).GT.ACUT)  GOTO  2000
      CALL HF1(3508,43.,1.)
C
C  PLOTS BEFORE CUTS
C
      ID = 2000
      IF(LHIST.LE.0)  GOTO  71
      CALL HFILL(ID+4,TDR(JTRK(1)),TDR(JTRK(2)),1.)
      CALL HF1(ID+5,TDT(N),1.)
      CALL HFILL(ID+6,ZVER(JTRK(1)),ZVER(JTRK(2)),1.)
      CALL HFILL(ID+3,TDT(N),NTGOOD(N))
      CALL HF1(ID+7,ZZVV,1.)
      DO   70   L=1,2
      CALL HF1(ID+10,DZ1(JTRK(L)),1.)
      CALL HF1(ID+11,ABS(FI1(JTRK(L))),1.)
   70 CONTINUE
C
      PLIM(1) = PB1
      PLIM(2) = PB2
      IF(P1.GE.30.) PLIM(1) = 29.*PMOM(I1)/ABS(PMOM(I1))
      IF(P2.GE.30.) PLIM(2) = 29.*PMOM(I2)/ABS(PMOM(I2))
      CALL HF1(ID+29,PAV,1.)
      CALL HFILL(ID+22,FLOAT(IQUMU(I1)),FLOAT(IQUMU(I2)))
   71 CONTINUE
C
C  CUTS
C
      DO   7   I=1,2
      IF(LCL(I,NF).LE.0)  GOTO  7
      IREJ = 6+I
      IF(ECLUST(I).GT.ELGCUT)  GOTO  2000
    7 CONTINUE
      CALL HF1(3508,45.,1.)
      IREJ = 9
      IF(ABS(ZVER(I1)).GT.150.)  GOTO  2000
      IF(ABS(ZVER(I2)).GT.150.)  GOTO  2000
      CALL HF1(3508,47.,1.)
      IREJ = 10
      IF(ABS(ZZVV).GT.100.)  GOTO  2000
      CALL HF1(3508,49.,1.)
      IREJ = 12
      IF(TDT(N).GT.TDTCUT)  GOTO  2000
      CALL HF1(3508,51.,1.)
      IREJ = 13
C     IF(NTGOOD(N).LT.4)  GOTO  2000
      CALL HF1(3508,52.,1.)
      IREJ = 14
      IF(RMIN(I1).GT.20..AND.RMIN(I2).GT.20.)  GOTO  2000
      IF(RMIN(I1).GT.5.OR.RMIN(I2).GT.5.)  EVFL(2) = .TRUE.
      IREJ = 15
      CALL HF1(3508,53.,1.)
      IF(T1.LT.-1..OR.T1.GT.7.) GOTO  2000
      IF(T2.LT.-1..OR.T2.GT.7.) GOTO  2000
      IREJ = 17
      CALL HF1(3508,55.,1.)
      IF(ABS(PB1).LT.1. OR.ABS(PB2).LT.1.) GOTO  2000
      IREJ = 19
      CALL HF1(3508,57.,1.)
      CALL HF1(ID+12,ALF(NF),1.)
      IF(ALF(NF).GT.ALFCUT)  GOTO  2000
      CALL HF1(3508,61.,1.)
      IF(PAV.LT.PCUT)  GOTO  2000
      CALL HF1(3508,63.,1.)
      IREJ = 23
      IF(ABS(DDX1).GT..2)  GOTO  2000
      IF(ABS(DDY1).GT..2)  GOTO  2000
      IF(ABS(DDZ1).GT..3)  GOTO  2000
      CALL HF1(3508,65.,1.)
      IREJ = 25
      IF(ETOTB.GT.ETCUT)  CALL HF1(3508,67.,1.)
      CALL TRLTCH
      ITRB = IAND(IANDOR,48)
      ITR1 = IAND(ITRB,16)
      ITR2 = IAND(ITRB,32)
      IF(ITR1.GT.0)  CALL HF1(3508,80.,1.)
      IF(ITR2.GT.0)  CALL HF1(3508,81.,1.)
      IF(ITR1.GT.0.AND.ITR2.LE.0)  CALL HF1(3508,82.,1.)
      IF(ITR2.GT.0.AND.ITR1.LE.0)  CALL HF1(3508,83.,1.)
C     IF(ITR1.LE.0)  GOTO  2000
C     IF(ETOTB.GT.ETCUT)  EVWRIT = .TRUE.
C
C CALCULATE WHICH CELL LAST POINT IS IN
      AF = 0.
      IC1 = (FIL(I1)-AF*CFIC)/CFIC+1
      IC2 = (FIL(I2)-AF*CFIC)/CFIC+1
      DFI1 = FIL(I1)-(FLOAT(IC1)-.5+AF)*CFIC
      DFI2 = FIL(I2)-(FLOAT(IC2)-.5+AF)*CFIC
C
      CALL NEWMOM(I1,I2,0)
      IF(ABS(DZ1(I1)).LT..75.AND.ABS(DZ1(I2)).LT..75) GOTO  65
      EVWRIT = .FALSE.
      CALL HF1(3508,90.,1.)
      NQUMU = 0
      IF(IQUMU(I1).GT.0)  NQUMU = NQUMU + 1
      IF(IQUMU(I2).GT.0)  NQUMU = NQUMU + 1
      IF(LHIST.NE.0) CALL HFILL(ID+8,DZ1(I1),FLOAT(NQUMU))
      IF(NQUMU.GT.0)  EVWRIT = .TRUE.
      IF(EVWRIT) CALL HF1(3508,92.,1.)
      IREJ = 27
C     IF(.NOT.EVWRIT) PRINT 165,NTRK,NTRMU,(IQUMU(LK),LK=1,NTRMU)
C     IF(.NOT.EVWRIT) PRINT 165,I1,I2,NQUMU,(IQUMU(LK),LK=1,NTRK)
C 165 FORMAT(' I1,I2,NQUMU,IQUMU',10I5)
C     IF(.NOT.EVWRIT) CALL MUR2PR
      IF(.NOT.EVWRIT) GOTO  2000
   65 IREJ = 30
      NMU = NMU + 1
      IMUFIN(N) = 1
      EVWRIT = .TRUE.
      IF(EVWRIT) CALL HF1(3508,94.,1.)
      IF(LHIST.NE.0) CALL HF1(ID+9,DZ1(I1),1.)
C
 2000 CONTINUE
C
   60 CALL HF1(3508,FLOAT(IREJ),1.)
      CALL HF1(3508,FLOAT(NMU)+70.,1.)
      IF(NMU.GT.0)  RETURN
C REJECTED
      LBUG = LBUG + 1
C     IF(LBUG.LE.20) PRINT 255,NRUN,IEV,NEV,IREJ,KREJ
  255 FORMAT(' REJECT CODE',5I5)

      RETURN
      END