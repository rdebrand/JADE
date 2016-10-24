C   18/02/80 002190802  MEMBER NAME  POSEND   (SOURCE)      FORTRAN
      SUBROUTINE POSEND(ENERGY,DR,FACT,*)
C     POSITION DEPENDENCE OF END CAP COUNTERS
C     INPUT ENERGY  INPUT ENERGY IN GEV
C           DR      DISTANCE BTW THE CENTER OF THE LEAD GLASS
C                   AND THE HIT POINT
C                   +DR  HIT POINT LIES IN OUTER HALF
C                        WRITTEN BY H.TAKEDA  15/02/80
C                        TYPED BY Y.WATANABE  19/02/80
      DIMENSION BENG(16),BPOS(23)
      INTEGER*2 HCOR(23,16),HCORA(23,8),HCORB(23,8)
      EQUIVALENCE (HCOR(1,1),HCORA(1,1)),(HCOR(1,9),HCORB(1,1))
      DATA MXEBIN/15/,ISFLAG/0/,IERR1,IERR2/2*0/,IERCNT/5/
      DATA BENG/0.,.6,.8,1.,1.5,2.,2.5,3.,3.5,4.,6.,11.,13.7,
     1  15.,15.8,100./
      DATA BPOS/-100.,-10.,-9.,-8.,-7.,-6.,-5.,-4.,-3.,-2.,-1.,0.,
     1          1.,2.,3.,4.,5.,6.,7.,8.,9.,10.,100./
      DATA HCORA/23*0,2*50,51,2*52,2*53,2*54,2*55,5*56,55,2*54,53,51,
     3 2*50, 3*69,70,71,73,74,75,2*76,4*77,76,75,74,73,72,70,3*69,
     4 2*87,3*88,89,90,91,92,95,97,98,99,2*100,98,96,93,91,88,86,2*84,
     5 2*128,129,131,133,135,138,140,144,149,154,158,159,158,155,
     5 150,146,142,138,135,132,2*130,
     6 2*169,170,174,177,182,187,193,200,209,218,224,224,219,210,203,
     6 196,190,184,180,176,2*173,
     7 2*225,226,228,232,234,236,242,250,262,276,290,294,290,278,264,
     7 252,244,235,228,224,2*220,
     8 2*274,275,277,280,284,290,298,313,332,355,374,378,362,332,312,
     8 300,288,280,276,274,2*274/
       DATA HCORB/2*320,322,324,328,335,343,353,370,396,425,446,446,430,
     1 406,376,354,340,330,322,318,2*318,
     2 2*372,374,376,382,392,402,420,442,470,500,516,510,
     2 486,460,430,410,395,384,374,372,2*372,
     3 2*508,513,522,535,556,580,614,650,690,704,700,682,662,640,614,
     3 585,566,550,536,526,2*520,
     4 2*930,940,960,980,1020,1070,1170,1280,1330,1380,1380,
     4 1330,1220,1160,1090,1040,1020,980,970,970,2*960,
     5 2*1090,1110,1140,1180,1240,1330,1450,1570,1660,1690,
     5 1680,1630,1560,1460,1390,1320,1270,1230,1200,1170,2*1170,
     6 2*1250,1260,1280,1320,1390,1490,1600,1760,1860,1920,
     6 1920,1880,1800,1600,1480,1410,1370,1330,1310,1290,2*1280,
     7 2*1300,1320,1340,1390,1450,1520,1700,1880,1980,2030,
     7 2020,1960,1870,1740,1560,1450,1420,1400,1380,1370,2*1360,23*0/
C     SET CORRECTION FACTORS AT 100GEV
      IF(ISFLAG.GT.0) GO TO 10
C     WRITE(6,900) HCOR
C900  FORMAT(2X,23I5)
      ISFLAG=1
      K=MXEBIN
      K1=K+1
      SUMX1=BENG(K)+BENG(K-1)+BENG(K-2)
      SUMX2=BENG(K)**2+BENG(K-1)**2+BENG(K-2)**2
      DO 11 I=1,23
      SUMY1=HCOR(I,K)+HCOR(I,K-1)+HCOR(I,K-2)
      SUMXY=HCOR(I,K)*BENG(K)+HCOR(I,K-1)*BENG(K-1)
     1  +HCOR(I,K-2)*BENG(K-2)
      COEF=(SUMX1*SUMY1-3*SUMXY)/(SUMX1*SUMX1-3*SUMX2)
      AINT=(SUMY1-COEF*SUMX1)/3.
      HCOR(I,K1)=COEF*BENG(K1)+AINT
11    CONTINUE
C     RENORMALIZATION OF CALIB. DATA BELOW 4.0 GEV
      SUMA=0
      SUMB=0
      DO 12 I=2,22
      SUMA=HCOR(I,10)+SUMA
      SUMB=HCOR(I,11)+SUMB
12    CONTINUE
      RENORM=SUMA/SUMB*BENG(11)/BENG(10)
C     WRITE(6,910) SUMX1,SUMX2,SUMY1,SUMXY,COEF,AINT,SUMA,SUMB,RENORM
C910  FORMAT(10F12.6)
C       RENORMALIZE SUCH THAT GAIN IS 1 AT ABS(R).GT.6 CM.
      RENORM=1.15/RENORM
      DO 13 I=1,16
      IF(I.GT.10) RENORM=1.15
      DO 13 J=1,23
      HCOR(J,I)=HCOR(J,I)*RENORM
13    CONTINUE
C     WRITE(6,900) HCOR
C
10    FACT=1.
      DO 1 I=1,K1
      IF(ENERGY.LT.BENG(I)) GO TO 2
1     CONTINUE
3     IERR1=IERR1+1
      IF(IERR1.GT.IERCNT) RETURN1
      WRITE(6,600) ENERGY
600   FORMAT('0 **BAD  ENERGY INTO LGECOR(POSEND) E=',F10.3)
      RETURN1
2     IF(I.LT.2) GO TO 3
      DO 4 J=1,23
      IF(DR.LT.BPOS(J)) GO TO 5
4     CONTINUE
6     IERR2=IERR2+1
      IF(IERR2.GT.IERCNT) RETURN1
      WRITE(6,610) DR
610   FORMAT('0 **BAD DR INTO LGECOR(POSEND) DR=',F10.3)
      RETURN1
5     IF(J.EQ.1) GO TO 6
C
C        INTERPOLATION
C
      EPORT=(ENERGY-BENG(I-1))/(BENG(I)-BENG(I-1))
      PPORT=(DR    -BPOS(J-1))/(BPOS(J)-BPOS(J-1))
      FACT1=HCOR(J-1,I-1)+EPORT*(HCOR(J-1,I)-HCOR(J-1,I-1))
      FACT2=HCOR(J  ,I-1)+EPORT*(HCOR(J  ,I)-HCOR(J  ,I-1))
      ENG=FACT1+PPORT*(FACT2-FACT1)
      FACT=0.01*ENG/ENERGY
      RETURN
      END