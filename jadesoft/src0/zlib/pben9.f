C   26/08/86 707081025  MEMBER NAME  PBEN9    (S)           FORTRAN77
      SUBROUTINE PBEN9(INR,NCLU,ESHE,ESHM,IPBC,IPBER)
C
C  CHANGE  05/06/84    ELIPS1=ELIPS1*(1.-1.4*ABS(THLG))
C
      IMPLICIT INTEGER*2 (H)
C
#include "cdata.for"
C
      COMMON /LINK/   IBLCHK,IREG,NBLK,NBLE,XI,YI,ZI,XF,YF,ZF,XSTART,
     *                YSTART,ZSTART,PSTART,TRKL(2,50),TRITER,EBITER,
     *                PMAG,NNEW,NENEW,NLIST(40),ENEW,ICHARG(40,20),
     +                NBLO,MEICL(50),NEICL(50),EBIT1,NBN1,EBLO1,NBL1
      COMMON / CGENL / IRUN,IEVE,JIGG2,IPAC,LCO,LTC
      DIMENSION IRKL(2,50)
      DIMENSION WIDTH(5)
      DATA WIDTH / 0.5 , 0.5 , 0.5 ,0.5 , 0.5 /
      EQUIVALENCE(IRKL(1,1),TRKL(1,1))
      DATA ILGA/0/
C
      IPATR=IDATA(IBLN('PATR'))
      IALGN=IDATA(IBLN('ALGN'))
      IPLG=IDATA(IBLN('LGCL'))
      LO  = IDATA(IPATR+1)
      NTR = IDATA(IPATR+2)
      LTR = IDATA(IPATR+3)
C
      ESHM=-1.
      IPBER=0
      DO 600 IN=1,50
      MEICL(IN)=0
      NEICL(IN)=0
  600 CONTINUE
C
      IF(NTR.EQ.0) RETURN
      IPN=IPATR+LO+(INR-1)*LTR
C
       ILIPS=1
      CALL TRKBL9(IPN,IALGN,ITER1,ITER2,ILIPS)
      IF(IBLCHK.EQ.1) RETURN
C
       CALL SHADO9(WIDTH,ILIPS)
C
C
      EBITER=EBITER+ENEW
      ESHE=EBITER
C                               -----------------------------
C                               --   PB-ENERGIE-KORREKTUR  --
C                               -----------------------------
C    BLOECKE, DIE ZUM CLUSTER GEHOEREN IN MEICL(I) FUELLEN
      NBLO=0
      DO 100 I=1,NBLK
      NBLO=NBLO+1
      MEICL(NBLO)=IRKL(1,I)
  100 CONTINUE
      DO 200 I=1,NNEW
      NBLO=NBLO+1
      MEICL(NBLO)=NLIST(I)
  200 CONTINUE
C
      IER=0
C                              'ALGN',1  -->  'ALZW',2
      NWO=IDATA(IALGN)
      CALL BCRE(IALG2,'ALZW',2,NWO,&1100,IER)
      IF(IER.NE.0) GOTO 1120
      CALL BSAW(1,'ALZW')
      DO 300 I=1,NWO
  300 IDATA(IALG2+I)=IDATA(IALGN+I)
C                              'LGCL',1  -->  'LGZW',2
      NWOL=IDATA(IPLG)
      CALL BCRE(IPLG2,'LGZW',2,NWOL,&1100,IER)
      IF(IER.NE.0) GOTO 1125
      CALL BSAW(1,'LGZW')
      DO 302 I=1,NWOL
  302 IDATA(IPLG2+I)=IDATA(IPLG+I)
C
C                            IN 'ALGN',1 ALLE BLOECKE = -1
C                                    UND BLOCKNUMMERN = -1 SETZEN,
C                            DIE NICHT ZUM MEIER-CLUSTER GEHOEREN
      IPNH=2*IALGN+5
      MXH=2*(IALGN+NWO)
      NWA=3
CCCC
      IJK = 0
C
  400 IPNH=IPNH+2
      IF(IPNH.GT.MXH) GOTO 500
      IBLK=HDATA(IPNH)
      DO 410 IMEI=1,NBLO
      IF(IBLK.EQ.MEICL(IMEI)) THEN
                              IJK = IJK + 1
                              GOTO 490
      ENDIF
  410 CONTINUE
      HDATA(IPNH)=-1
      HDATA(IPNH+1)=-1
      GOTO 400
  490 NEICL(IMEI)=HDATA(IPNH+1)
      IF(HDATA(IPNH+1).GT.0) NWA=NWA+1
      GOTO 400
  500 CONTINUE
C                                     ALLE HALBWORTE > 0 AUS 'ALGN',1
C                                     NACH 'ALCO',1 KOPIEREN
      CALL BCRE(IALC,'ALCO',1,NWA,&1100,IER)
      IF(IER.NE.0) GOTO 1128
      CALL BSAW(1,'ALCO')
      IPNH=2*IALGN
      IAC2=2*IALC
      MXHC=2*(IALC+NWA)
  550 IPNH=IPNH+1
      IF(IPNH.GT.MXH) GOTO 560
      IF(HDATA(IPNH).LE.0.AND.IPNH.GT.(2*IALGN+3)) GOTO 550
      IAC2=IAC2+1
      IF(IAC2.GT.MXHC) GOTO 555
      HDATA(IAC2)=HDATA(IPNH)
      GOTO 550
  555 WRITE(6,5556)
 5556 FORMAT(/,1X,' LAENGE DER BANK ALCO UEBERSCHRITTEN +++++++++',/)
  560 NWP1=NWA*2-5
      HDATA(2*IALC+4)=NWP1
      HDATA(2*IALC+5)=NWP1
      HDATA(2*IALC+6)=NWP1
CCC
CCC   CALL BMLT(1,'ALCO')
CCC   CALL BPRM
CCC
      CALL BDLS('ALGN',1)
      CALL BRNM('ALCO',1,'ALGN',1)
C
C     WRITE(6,501) NBLO,(MEICL(I),I=1,NBLO)
C 501 FORMAT(1X,I4,' BLOECKE',18I6)
C     WRITE(6,502) (NEICL(L),L=1,NBLO)
C 502 FORMAT(1X,'     ENERGIE',18I6)
C
C                   CLUSTER-ANALYSE WIEDERHOLEN MIT NEUER 'ALGN',1-BANK
      NPLG=IDATA(IBLN('LGCL'))
      NCLU=IDATA(NPLG+7)
      CALL BDLS('LGCL',1)
      CALL LGANAL
      NPLG=IDATA(IBLN('LGCL'))
      NCLU=IDATA(NPLG+7)
C     NCLULG=NCLU
CCCCCCCC
      IF(NCLU.LE.0) GOTO 1140
CCCCCCCC
C                                    LGCDIR MACHT JETZT ENERGIEKORREKTUR
      CALL LGCDIR(IPATR,IALGN,NPLG)
C
C                      KORRIGIERTE CLUSTER-ENERGIE AUS 'LGCL',1-BANK
      NPLG=IDATA(IBLN('LGCL'))
      ESHM=ADATA(NPLG+11)
      NCLU=IDATA(NPLG+8)
C
      CALL CLOC(ITEL,'LGSA',INR)
      IF(ITEL.NE.0) CALL BDLS('LGSA',INR)
      CALL CLOC(ITEA,'ALSA',INR)
      IF(ITEA.NE.0) CALL BDLS('ALSA',INR)
C            UMBENENNUNG VON 'ALGN',1  IN  'ALSA',INR
C            UMBENENNUNG VON 'LGCL',1  IN  'LGSA',INR
C            SAVE 'ALSA',INR  UND 'LGSA',INR
      CALL BRNM('ALGN',1,'ALSA',INR)
      CALL BRNM('LGCL',1,'LGSA',INR)
      CALL BSAW(1,'ALSA')
      CALL BSAW(1,'LGSA')
CCCCC
CCC   CALL BPRS('ALSA',INR)
CCC   CALL BPRS('LGSA',INR)
C
C            'ALZW',2 NACH 'ALGN',1 ZURUECKKOPIEREN
C            'LGZW',2 NACH 'LGCL',1 ZURUECKKOPIEREN
C            FALS MEHR ALS EINE SPUR IN EINEM EVENT EIN E-KANDIDAT IST
      CALL BRNM('ALZW',2,'ALGN',1)
      CALL BRNM('LGZW',2,'LGCL',1)
C
C
      RETURN
 1100 WRITE(6,1110) IER,IPBC
 1110 FORMAT(1X,' 1100 FEHLER BEIM KOPIEREN VON ALGN, FEHLER',I4,
     +       1X,'   ICALL',I4)
      IPBER=4
      GOTO 1200
 1120 WRITE(6,1121) IER,IPBC
 1121 FORMAT(1X,' 1120 FEHLER BEIM KOPIEREN VON ALGN, FEHLER',I4,
     +       1X,'   ICALL',I4)
CCC   CALL BPRS('ALZW',2)
      IPBER=4
      GOTO 1200
 1125 WRITE(6,1126) IER,IPBC
 1126 FORMAT(1X,' 1125 FEHLER BEIM KOPIEREN VON LGCL, FEHLER',I4,
     +       1X,'   ICALL',I4)
CCC   CALL BPRS('LGZW',2)
      IPBER=4
      GOTO 1200
 1128 WRITE(6,1129) IER,IPBC
 1129 FORMAT(1X,' 1128 FEHLER BEIM KOPIEREN VON ALCO, FEHLER',I4,
     +       1X,'   ICALL',I4)
      IPBER=4
      GOTO 1200
 1140 ILGA=ILGA+1
      IF(ILGA.GT.20) GOTO 1200
      WRITE(6,1150) IRUN,IEVE,JIGG2,INR,NBLO,(MEICL(IM),IM=1,NBLO)
      WRITE(6,1151) (NEICL(MI),MI=1,NBLO)
 1150 FORMAT(1X,' LGANAL FINDET KEINE CLUSTER, EVENT',3I8,'  SPUR',I3,
     +     /,1X,' NBLOCK',I4,'  NUMMER ',16I6)
 1151 FORMAT(1X,'            ENERGIE ',16I6)
      IPBER=2
      IF(ILGA.GT.5) GOTO 1200
CCC   CALL BPRS('ALZW',2)
CCC   CALL BPRS('LGCL',1)
      GOTO 1200
C1160 WRITE(6,1165)
C1165 FORMAT(1X,' CLUSTER IN ZWEI VERSCHIEDENEN DETEKTORTEILEN')
C     RETURN
C1170 WRITE(6,1175) NCLO
C1175 FORMAT(1X,'     >>>>> IFIND = 0 <<<<<,   NCLO =',I4)
C     RETURN
C
 1200 CONTINUE
      CALL BDLS('ALGN',1)
      CALL BDLS('LGCL',1)
      CALL BRNM('ALZW',2,'ALGN',1)
      CALL BRNM('LGZW',2,'LGCL',1)
      RETURN
      END
      REAL FUNCTION DGAUS2(X1,X2,A1,A2,SIG1,SIG2)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     2 - DIM. GAUSS - DISTRIBUTION                                    C
C     CORRELATION = 0                                                  C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      DGAUS2 = 0.
C
      B1 = ((X1 - A1)/SIG1)**2
      B2 = ((X2 - A2)/SIG2)**2
      ARGUM = -.5*(B1 + B2)
C
      IF(ARGUM.LE.-180.) RETURN
C
      DGAUS2 = (1./(6.283185*SIG1*SIG2))*EXP(ARGUM)
C     DGAUS2 = EXP(ARGUM)
C
      RETURN
      END
C   04/12/81 207051513  MEMBER NAME  NUMBLC   (SHOWS)       FORTRAN
      FUNCTION NUMBLC(XA,YA,ZA,IREG)
C
C     RETURNS BLOCK NUMBER FOR GIVEN COORDINATES AND LG-PART
C
C                                           05/07/82
C
#include "cgeo1.for"
C
      COMMON /CJTRIG/ PI,TWOPI
      DIMENSION MAP(6,6)
C
      DATA ICALL/0/
      IF(ICALL.NE.0) GO TO 9999
      ICALL=1
      MAP(1,1)=   -1
      MAP(2,1)=   -1
      MAP(3,1)= 2688
      MAP(4,1)= 2692
      MAP(5,1)= 2697
      MAP(6,1)= 2703
      MAP(1,2)=   -1
      MAP(2,2)=   -1
      MAP(3,2)= 2689
      MAP(4,2)= 2693
      MAP(5,2)= 2698
      MAP(6,2)= 2704
      MAP(1,3)= 2691
      MAP(2,3)= 2690
      MAP(3,3)= 2694
      MAP(4,3)= 2699
      MAP(5,3)= 2705
      MAP(6,3)=   -1
      MAP(1,4)= 2696
      MAP(2,4)= 2695
      MAP(3,4)= 2700
      MAP(4,4)= 2707
      MAP(5,4)= 2706
      MAP(6,4)=   -1
      MAP(1,5)= 2702
      MAP(2,5)= 2701
      MAP(3,5)= 2709
      MAP(4,5)= 2708
      MAP(5,5)=   -1
      MAP(6,5)=   -1
      MAP(1,6)= 2711
      MAP(2,6)= 2710
      MAP(3,6)=   -1
      MAP(4,6)=   -1
      MAP(5,6)=   -1
      MAP(6,6)=   -1
C
 9999 IBLK=-1
      X=XA
      Y=YA
      Z=ZA
      IF(IREG.EQ.0) GO TO 1
      IF((ABS(X).LT.(2.*BLXY)).AND.(ABS(Y).LT.(2.*BLXY))) GO TO 100
      IF((X.GT.0.).AND.(Y.GE.0.)) IQUAD=1
      IF((X.LE.0.).AND.(Y.GT.0.)) IQUAD=2
      IF((X.LT.0.).AND.(Y.LE.0.)) IQUAD=3
      IF((X.GE.0.).AND.(Y.LT.0.)) IQUAD=4
C
C     ROTATE (X,Y) INTO THE FIRST QUADRANT.
C
      JQUAD=0
    2 CONTINUE
      JQUAD=JQUAD+1
      IF(JQUAD.GE.IQUAD) GO TO 3
      XS = Y
      YS =-X
      X  =XS
      Y  =YS
      GO TO 2
    3 CONTINUE
      IF(Y.LT.BLXY) X=X-50.
      IF(X.LT.BLXY) Y=Y-50.
      IX=1.+X/BLXY
      IY=1.+Y/BLXY
      IF((IX.GT.6).OR.(IY.GT.6)) GO TO 100
      IBLK=MAP(IX,IY)
      IF(IBLK.LT.0) GO TO 100
      IBLK=IBLK+24*(IQUAD-1)+48*(IREG+1)
      GO TO 100
    1 CONTINUE
      PHI=ATAN2(Y,X)
      IF(PHI.LT.0.) PHI=PHI+TWOPI
      IPHI=84.*PHI/TWOPI
      IF(IPHI.GT.83) IPHI=83
      IZ=(Z-ZLGMI)/BLZ
      IF((IZ.LT.1).OR.(IZ.GT.30)) GO TO 100
      IBLK=IZ+32*IPHI
  100 CONTINUE
      NUMBLC=IBLK
      RETURN
      END