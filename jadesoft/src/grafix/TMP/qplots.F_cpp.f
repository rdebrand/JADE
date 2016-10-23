C   23/03/80 705202031  MEMBER NAME  QPLOTS   (S)           FORTRAN
      SUBROUTINE QPLOTS
      IMPLICIT INTEGER*2 (H)
C---
C---     DISPLAY EVENT IN QPLANE PROJECTIONS, DRAW QPLOT ONTO PICTURE
C---      23.03.80              LAST CHANGE 16.07.81     J.OLSSON
C---      2.4.1985    CHANGE OF MOTAPR          KOMAMIYA/OLSSON
C---
C-----------------------------------------------------------------------
C                            MACRO CGRAPH .... GRAPHICS COMMON
C-----------------------------------------------------------------------
C
      LOGICAL DSPDTL,SSTPS,PSTPS,FREEZE
C
      COMMON / CGRAPH / JUSCRN,NDDINN,NDDOUT,IDATSV(11),ICREC,MAXREC,
     +                  LSTCMD,ACMD,LASTVW,ISTANV,
     +                  SXIN,SXAX,SYIN,SYAX,XMIN,XMAX,YMIN,YMAX,
     +                  DSPDTL(30),SSTPS(10),PSTPS(10),FREEZE(30),
     +                  IREADM,LABEL,LSTPS(10),IPSVAR
C
C------- END OF MACRO CGRAPH -------------------------------------------
C
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
C
C
      NN = ACMD
      IF(NN.NE.0) GO TO 100
      CALL TRMOUT(80,'CODE 1: PROJ. ON THE Q2-Q3,Q1-Q2 PLANES WITH ENERG
     $Y HISTOGRAMS^')
      CALL TRMOUT(80,'CODE 2:  PROJ. ON THE Q1-Q2,Q2-Q3 AND Q3-Q1 PLANES
     $^')
      CALL TRMOUT(80,'CODE 3:  TRIANGEL PLOT OF Q1, (Q3-Q2)/SQRT(3)^')
      CALL TRMOUT(80,'ENTER OPTION:^')
      NN = TERNUM(DUM)
100   IF(NN.GE.1.AND.NN.LE.3) GO TO 130
      RETURN
130   GO TO (200,300,400),NN
200   CALL EVIPR4
      CALL TRIANQ(500,1100,600,1200)
201   CALL SETSCL(LASTVW)
      RETURN
300   CALL EVIPR2
      CALL TRIANQ(2800,3400,170,770)
      GO TO 201
400   CONTINUE
      CALL TRIANQ(800,1400,0,600)
      GO TO 201
      END
      SUBROUTINE TRIANQ(LXMN,LXMX,LYMN,LYMX)
      IMPLICIT INTEGER*2 (H)
C
C  DISPLAY Q-PLOT   ON SCREEN WINDOW  LXMN,LXMX,LYMN,LYMX
C                 J.OLSSON   24.03.80       LAST CHANGE  24.03.80
C
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
C-----------------------------------------------------------------------
C                            MACRO CGRAPH .... GRAPHICS COMMON
C-----------------------------------------------------------------------
C
      LOGICAL DSPDTL,SSTPS,PSTPS,FREEZE
C
      COMMON / CGRAPH / JUSCRN,NDDINN,NDDOUT,IDATSV(11),ICREC,MAXREC,
     +                  LSTCMD,ACMD,LASTVW,ISTANV,
     +                  SXIN,SXAX,SYIN,SYAX,XMIN,XMAX,YMIN,YMAX,
     +                  DSPDTL(30),SSTPS(10),PSTPS(10),FREEZE(30),
     +                  IREADM,LABEL,LSTPS(10),IPSVAR
C
C------- END OF MACRO CGRAPH -------------------------------------------
C
C
      DATA NHITMN/24/
C
      IPP= IBLN('PATR')
      INPA= IDATA(IPP)
      IF(INPA.LE.0) GO TO 5100
      CALL SUMPAT(INPA,*3000,*3000)
C
C ----- CALCULATE SPHERICITY AND Q-AXIS
C
      IPRMOM = 0
      CALL CHCLSP(SPH,CSTH1,PHI1,Q1,Q23,NHITMN,IPRMOM,*1500)
      CALL TWINDO(LXMN,LXMX,LYMN,LYMX)
      XMN = -.2
      YMN = -.2
      XMX = .8
      YMX = .8
      CALL DWINDO(XMN,XMX,YMN,YMX)
      CALL MOVEA(0.,0.)
      Y = 1./3.
      CALL DRAWA(0.,Y)
      X = 1./SQRT(3.)
      CALL DRAWA(X,0.)
      CALL DRAWA(0.,0.)
      CALL PLYGON(12,0.008,Q23,Q1,0)
      DO 4062 I = 1,3
      Y = I*.1
      CALL MOVEA(-.012,Y)
      CALL DRAWA(.012,Y)
4062  CONTINUE
      DO 4063 I = 1,5
      X = I*.1
      CALL MOVEA(X,-.012)
      CALL DRAWA(X,.012)
4063  CONTINUE
      CALL TWINDO (0,4095,0,4095)
      GO TO 1500
5100  WRITE(6,9510)
9510  FORMAT(' RAW DATA ERROR ')
1500  RETURN
3000  WRITE(6,3500)
3500  FORMAT(' NO CHARGED TRACKS')
      GO TO 1500
      END
      SUBROUTINE EVIPR4
C     T. KOBAYASHI     11.09.1979    16:10
C         MODIFIED     12.09.1979    17:30
C   MODIFIED FOR JADE GRAPHICS  20.03.80    J.OLSSON
C                                  LAST CHANGE 16.07.81
C --- EVENT DISPLAY ON IPS
C --- PROJECTION ON THE Q2-Q3,Q1-Q2 PLANE
C --- ENERGY HISTOGRAM
C
      IMPLICIT INTEGER*2 (H)
C
      COMMON / / P(10,100),BANK(12)
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
      COMMON/CWORK/RTRACK(600),NTRK,NTRKL,NTRKLH,
     *  RMIN1,RMIN2,RMINL,  ZMIN,ZMINL,
     *  SUMPT,SUMPTL,       SUMP,SUMPL,    SUMLX,SUMLY,SUMLZ,
     *  PTMAX,PMAX,         ACOP
     * ,EH(36),DPRT(10)
      DIMENSION ITRACK(600)
      EQUIVALENCE (ITRACK(1),RTRACK(1))
C-----------------------------------------------------------------------
C                            MACRO CGRAPH .... GRAPHICS COMMON
C-----------------------------------------------------------------------
C
      LOGICAL DSPDTL,SSTPS,PSTPS,FREEZE
C
      COMMON / CGRAPH / JUSCRN,NDDINN,NDDOUT,IDATSV(11),ICREC,MAXREC,
     +                  LSTCMD,ACMD,LASTVW,ISTANV,
     +                  SXIN,SXAX,SYIN,SYAX,XMIN,XMAX,YMIN,YMAX,
     +                  DSPDTL(30),SSTPS(10),PSTPS(10),FREEZE(30),
     +                  IREADM,LABEL,LSTPS(10),IPSVAR
C
C------- END OF MACRO CGRAPH -------------------------------------------
C
C
      COMMON /MOM/NCLST,NPHTN,NCHTR,PCL(4,50),PPH(4,50),PCH(4,50)
      DIMENSION PR(2)
      DATA NHITMN/24/,RTD/57.295779/
C
       CALL ERASE
C
      INHD=IDATA(IBLN('HEAD'))
         IF(INHD.LE.0)GO TO 5100
         INP =INHD*2+10
         NRUN=HDATA(INP)
         NEVT=HDATA(INP+1)
      INPA= IDATA(IBLN('PATR'))
      IF(INPA.LE.0) GO TO 5100
      CALL SUMPAT(INPA,*3000,*3000)
C
C ----- CALCULATE SPHERICITY AND Q-AXIS
C
      IPRMOM = 0
      CALL CHCLSP(SPH,CSTH1,PHI1,Q1,Q23,NHITMN,IPRMOM,*1500)
      NT=NCHTR+NCLST
         DPRT(1)=SPH
         DPRT(2)=Q1
         DPRT(3)=Q23
C
C ----- DECIDE SCALE AND GET PROJECTED MOM.
C
      IGR=0
      EFC=5.0
         DO 35 I=1,36
35       EH(I)=0.0
         SCALE=0.0
      DO 38 I=1,NT
      P(8,I)=P(1,I)*BANK(5)+P(2,I)*BANK(6)+P(3,I)*BANK(7)
      P(9,I)=P(1,I)*BANK(8)+P(2,I)*BANK(9)+P(3,I)*BANK(10)
         AP2=P(8,I)**2+P(9,I)**2
      P(10,I)=SQRT(AP2)
      IF(P(10,I).GT.SCALE)SCALE=P(10,I)
         IF(AP2.EQ.0.0)GO TO 38
         PHI=ATAN2(P(9,I),P(8,I))*RTD
         IF(PHI.LT.0.0)PHI=PHI+360.0
         IPHI=IFIX(0.1*PHI)+1
      EH(IPHI)=EH(IPHI)+P(10,I)/EFC
38    CONTINUE
         SCALE=1.1*SCALE
         A0=0.0
         A1=7.0*SCALE
         X0=2.0*SCALE
         X1=3.2*SCALE
      CALL DWINDO(A0,A1,A0,A1)
      GO TO 9
C
42    IF(IGR.NE.0) RETURN
      IGR=1
         DO 45 I=1,36
45       EH(I)=0.0
      DO 48 I=1,NT
      P(9,I)=P(1,I)*BANK(2)+P(2,I)*BANK(3)+P(3,I)*BANK(4)
         AP2=P(8,I)**2+P(9,I)**2
      P(10,I)=SQRT(AP2)
         IF(AP2.EQ.0.0)GO TO 48
         PHI=ATAN2(P(9,I),P(8,I))*RTD
         IF(PHI.LT.0.0)PHI=PHI+360.0
         IPHI=IFIX(0.1*PHI)+1
      EH(IPHI)=EH(IPHI)+P(10,I)/EFC
48    CONTINUE
         X0=5.0*SCALE
C
C ----- EVENT DISPLAY
C
9     CALL BOX(IDATSV,SCALE,ICREC,NRUN,NEVT,NCHTR,NCLST,DPRT,X0,X1,IGR)
C
      DO 20 I=1,NT
      PR(1)=-P(9,I)
      PR(2)=P(8,I)
C
      CALL MOVEA(X0,X1)
      IF(I.GT.NCHTR)GO TO 15
      CALL DRAWR(PR(1),PR(2))
      GO TO 20
15    CALL DASHR(PR(1),PR(2),34)
20    CONTINUE
C
C ----- ENERGY HISTOGRAM
C
      DO 40 I=1,36
         PHI=FLOAT(10*(I+8))/RTD
         I1=I+1
         IF(I1.GT.36)I1=I1-36
      CALL EHIST(PHI,EH(I),EH(I1),SCALE,X0,X1)
40    CONTINUE
      GO TO 42
C
3000  WRITE(6,3500)
3500  FORMAT(' NO CHARGED TRACKS')
       GO TO 1500
C
5100  WRITE(6,9510)
9510  FORMAT(' RAW DATA ERROR ')
1500  RETURN
      END
      SUBROUTINE BOX(IDATAL,SCALE,ICNT,NRUN,NEVT,NC,NN,DPRT,SX2,SY2,
     *               IGR)
C --- SUBROUTINE TO DRAW BOX AND WRITE DETAILS
C
      COMMON /CJTRIG/ PI,TWOPI
      DIMENSION IDATAL(11),FB(10),DPRT(10)
*** PMF 17/11/99: add variables needed for emulation of DESYLIB routine 'CORE'  
      CHARACTER cFB*40
      EQUIVALENCE (cFB,FB(1))
*** PMF(end)
C
      SX1=SX2-SCALE
      SX3=SX2+SCALE
      SY1=SY2-SCALE
      SY3=SY2+SCALE
      DL=0.05*SCALE
      DPHI = TWOPI/100
      PHI = 0.
      CALL MOVEA(SCALE+SX2,SY2)
C
      DO 10 I=1,100
      PHI = PHI + DPHI
10    CALL DRAWA(SCALE*COS(PHI)+SX2,SCALE*SIN(PHI)+SY2)
C
      CALL MOVEA(SX1,SY2)
      CALL DRAWR(DL,0.)
      CALL MOVEA(SX2,SY3)
      CALL DRAWR(0.,-DL)
      CALL MOVEA(SX3,SY2)
      CALL DRAWR(-DL,0.)
      CALL MOVEA(SX2,SY1)
      CALL DRAWR(0.,DL)
C
        IF(IGR.NE.0) RETURN
C
      CALL CHRSIZ(4)
         XSTXT=3.1*SCALE
         YSTXT=1.9*SCALE
         DL1=2.5*DL
      CALL MOVEA(XSTXT,YSTXT)
      CALL EOUTST(20,IDATAL)
C
      YSTXT=YSTXT-DL1
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,14)
      WRITE(cFB,100)ICNT ! PMF 17/11/99: UNIT=10 changed to cFB
100   FORMAT('EVENT NO.',I5)
      CALL EOUTST(14,FB)
C
      YSTXT=YSTXT-DL1
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,21)
      WRITE(cFB,110)NRUN,NEVT ! PMF 17/11/99: UNIT=10 changed to cFB
110   FORMAT('RUN NO.',I6,' -',I6)
      CALL EOUTST(21,FB)
C
      YSTXT=YSTXT-DL1
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,18)
      WRITE(cFB,115)NC,NN ! PMF 17/11/99: UNIT=10 changed to cFB
115   FORMAT('N(C,N) =',2I5)
      CALL EOUTST(18,FB)
C
      YSTXT=YSTXT-DL1
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,11)
      WRITE(cFB,120)DPRT(1) ! PMF 17/11/99: UNIT=10 changed to cFB
120   FORMAT('S =',F8.4)
      CALL EOUTST(11,FB)
C
      YSTXT=YSTXT-DL1
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,19)
      WRITE(cFB,130)(DPRT(J),J=2,3) ! PMF 17/11/99: UNIT=10 changed to cFB
130   FORMAT('Q =',2F8.3)
      CALL EOUTST(19,FB)
C
      YSTXT=YSTXT-DL1
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,20)
      WRITE(cFB,200)SCALE ! PMF 17/11/99: UNIT=10 changed to cFB
200   FORMAT('SCALE =',F7.2,' GEV/C')
      CALL EOUTST(20,FB)
C
      RETURN
      END
      SUBROUTINE EHIST(PHI,E1,E2,SCALE,X0,Y0)
C
C --- SUBROUTINE TO DRAW ENERGY HISTOGRAM
C
      DATA DPH/0.0174533/
C
      R1=E1+SCALE
      R2=E2+SCALE
      PHI1=PHI
      CALL MOVEA(R1*COS(PHI1)+X0,R1*SIN(PHI1)+Y0)
C
      DO 10 I=1,10
      PHI1=PHI1+DPH
10    CALL DRAWA(R1*COS(PHI1)+X0,R1*SIN(PHI1)+Y0)
C
      CALL DRAWA(R2*COS(PHI1)+X0,R2*SIN(PHI1)+Y0)
C
      RETURN
      END
       SUBROUTINE SUMPAT(INPA,*,*)
      IMPLICIT INTEGER*2 (H)
C        LAST MODIFY AT 12.07.79
C
C        MODIFIED FOR REDUCTION 2
C            04/08/1979  19:20   H.TAKEDA
C            17/08/1979  15:15   T.KOBAYASHI
C ------ P>10 ---> P=5
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
C
       COMMON/CWORK/RTRACK(600),NTRK,NTRKL,NTRKLH,
     *  RMIN1,RMIN2,RMINL,  ZMIN,ZMINL,
     *  SUMPT,SUMPTL,       SUMP,SUMPL,    SUMLX,SUMLY,SUMLZ,
     *  PTMAX,PMAX,         ACOP
C
       DIMENSION ITRACK(600),PS(3,2),PSA(3),PSB(3)
       EQUIVALENCE (PSA(1),PS(1,1)),(PSB(1),PS(1,2))
       EQUIVALENCE (ITRACK(1),RTRACK(1))
       DIMENSION R(3),P(3),VECT1(3),VECT2(3),AXIS(3)
       DATA AXIS/0.0, 0.0, 1.0/
       DATA BENER/10.0/
C
            DO 50 I=1,3
  50        R(I)= 0.
            DO 100 I= 1,600
            ITRACK(I)= 0
 100        CONTINUE
       ACOP=1.5
C
       ISTP= INPA+1
       LPAT= IDATA(ISTP)-1
       ISTP= ISTP+1
       LPAT= LPAT+ISTP
       NTRK= IDATA(ISTP)
C/////////
       LTR= IDATA(ISTP+1)
       IF(NTRK.LE.0) RETURN1
       IF(NTRK.GT.50) RETURN2
       RMIN1=10000.
       RMIN2=10000.
       ZMN= 10000.
C
C   NTRKL    # OF TRACKS , IN WHICH # OF HITS IS GREATER THAN 24
C   NTRKLH   # OF TRACKS , IN WHICH TRANS. MOM. GREATER THAN O.2 GEV
C            ( # OF HITS IS GREATER THAN 24 )
C   RMINL    MINIMUM R AMONG "NTRKLH"
C   ZMINL    MINIMUM Z AMONG "NTRKLH"
C   ACOP     ACOPLANARITY ANGLE  COS(THETA)  WITH TWO GOOD TRACKS
C            INCLUDING Z-AXIS
C
       NTRKL=0
       NTRKLH=0
       RMINL=10000.0
       ZMNL= 10000.0
C
       PTMAX= 0.
       PMAX= 0.
       SUMPT= 0.
       SUMPL=0.
       SUMPTL=0.
       SUMP= 0.
       SUMPG= 0.
C
       SUMLX=0.
       SUMLY=0.
       SUMLZ=0.
C
       DO 1000 I= 1,NTRK
C
            IP= LTR*(I-1)+LPAT
            ITNUM= IDATA(IP)
            IPX=10*(I-1)+1
            ITRACK(IPX)= ITNUM
            IF(ITNUM.NE.I) GO TO 1000
C
            IPNX= IP-1
            ZV = ADATA(IPNX+31)
            CALL KIPRCR(IPNX,1,CAP,RMINP,PHIMP,SIGP)
             CALL MOTAPR(IPNX,1,R,P)
C
C     P      MOMENTUM VECTOR
C     PP     MAGNITUDE OF MOMENTUM VECTOR
C     PTP    TRANSVERSE COMPONENT OF MOMENTUM
C
C
            PTP2= P(1)**2+P(2)**2
            PTP= SQRT(PTP2)
            PP= SQRT(P(3)**2+PTP2)
C********************
C  IF MOMENTUM EXCEEDS BEAM ENERGY, IT IS SET TO BEAM ENERGY
C
            A=1.0
            IF(PP.GE.BENER) A=BENER/(2.0*PP)
      P(1)=P(1)*A
      P(2)=P(2)*A
      P(3)=P(3)*A
      PTP=PTP*A
      PP=PP*A
C*******************************
            RTRACK(IPX+1)= RMINP
            RTRACK(IPX+2)= PHIMP
            RTRACK(IPX+3)= ZV
            RTRACK(IPX+4)= PTP
            RTRACK(IPX+5)= PP
            RTRACK(IPX+6)= P(1)
            RTRACK(IPX+7)= P(2)
            RTRACK(IPX+8)= P(3)
            ITRACK(IPX+9)=IDATA(IPNX+24)
C
C  GET 1-ST AND 2-ND 'RMIN'
C
            ARMIN= ABS(RMINP)
C
      IF(ARMIN.GT.RMIN1) GO TO 1
      RMIN2=RMIN1
      RMIN1=ARMIN
      GO TO 2
C
    1 IF(ARMIN.GT.RMIN2) GO TO 2
      RMIN2=ARMIN
    2 CONTINUE
C
            AZV= ABS(ZV)
            IF(AZV.GT.ZMN)   GO TO 800
            ZMN= AZV
            ZMIN= ZV
  800       IF(PTP.GE.PTMAX) PTMAX= PTP
            IF(PP.GE.PMAX) PMAX= PP
            SUMPT= SUMPT+PTP
            SUMP = SUMP +PP
            IF(IDATA(IPNX+24).GE.32) SUMPG= SUMPG+PP
C
C
C  PICK UP LONG TRACK
C
      IF(IDATA(IPNX+24).LT.24 .OR. ARMIN.GT.100.0) GO TO 1000
      NTRKL=NTRKL+1
C--- TRANSEVERSE MOMENTUM
      IF(PTP.LT.0.2) GO TO 1002
C
      NTRKLH=NTRKLH+1
 1002 IF(ARMIN.LE.RMINL) RMINL=ARMIN
      IF(AZV.GT.ZMNL) GO TO 1001
      ZMNL=AZV
      ZMINL=ZV
C
 1001 SUMPL=SUMPL+PP
      SUMPTL=SUMPTL+PTP
C
      SUMLX=SUMLX+P(1)
      SUMLY=SUMLY+P(2)
      SUMLZ=SUMLZ+P(3)
C
      IF(NTRKL.GE.3) GO TO 1000
      PS(1,NTRKL)=P(1)
      PS(2,NTRKL)=P(2)
      PS(3,NTRKL)=P(3)
C
 1000   CONTINUE
C
      IF(NTRKL.NE.2) RETURN
C
      CALL OUTPRD(PSA,AXIS,VECT1)
      CALL OUTPRD(PSB,AXIS,VECT2)
      CALL INNPRD(VECT1,VECT2,ACOP)
C
        RETURN
        END
      SUBROUTINE OUTPRD(A,B,C)
C --- SUBROUTINE TO MAKE VECTOR PRODUCT  C = A * B
C
      DIMENSION A(3),B(3),C(3)
C
      C(1)=A(2)*B(3)-A(3)*B(2)
      C(2)=A(3)*B(1)-A(1)*B(3)
      C(3)=A(1)*B(2)-A(2)*B(1)
C
      RETURN
C  *****************************
C
C    INNER PRODUCT   D = A . B /'A' 'B'
C
      ENTRY INNPRD(A,B,D)
C
      D=0.0
      E=A(1)*B(1)+A(2)*B(2)+A(3)*B(3)
      A1=A(1)*A(1)+A(2)*A(2)+A(3)*A(3)
      B1=B(1)*B(1)+B(2)*B(2)+B(3)*B(3)
C
      IF(A1.LE.0.0 .OR. B1.LE.0.0) RETURN
      D=E/SQRT(A1)/SQRT(B1)
C
      RETURN
      END
      SUBROUTINE CHCLSP(SPH,CSTH,PHI,Q1,Q23,NHITMN,IPR,*)
      IMPLICIT INTEGER*2 (H)
C
C
C     T. KOBAYASHI    09.08.1979    23:20
C         MODIFIED    10.08.1979    23:35
C
C     SUBROUTINE TO CALCULATE SPHERICITY FOR CHARGED TRACKS
C                   AND CLUSTERS
C
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
C
      COMMON/CWORK/RTRACK(600),NTRK,NTRKL,NTRKLH,
     *  RMIN1,RMIN2,RMINL,  ZMIN,ZMINL,
     *  SUMPT,SUMPTL,       SUMP,SUMPL,    SUMLX,SUMLY,SUMLZ,
     *  PTMAX,PMAX,         ACOP
      DIMENSION ITRACK(600),NHIT(50)
      EQUIVALENCE (RTRACK(1),ITRACK(1))
C
      COMMON /MOM/NCLST,NPHTN,NCHTR,PCL(4,50),PPH(4,50),PCH(4,50)
      COMMON P(10,100),BANK(12)
      DATA RAD/0.0174533/
C
C -------- STORE CHARGED TRACK MOM. INTO PCH(4,50)
C
      NCHTR=0
      IF(NTRK.LE.0)GO TO 1
      DO 10 I=1,NTRK
      IT=10*(I-1)
         NHITG=ITRACK(IT+10)
         IF(NHITG.LT.NHITMN)GO TO 10
         NCHTR=NCHTR+1
         NHIT(NCHTR)=NHITG
      DO 15 J=1,3
15    P(J,NCHTR)=RTRACK(IT+J+6)
      P(4,NCHTR)=ABS(RTRACK(IT+6))
      DO 16 J=1,4
16    PCH(J,NCHTR)=P(J,NCHTR)
      IF(NCHTR.EQ.50) GO TO 1
10    CONTINUE
C
C ----- STORE CL AND PH MOM. INTO PCL(4,50)AND PPH(4,50)
C
1     NCLST=0
      NPHTN=0
      IND=IDATA(IBLN('LGCL'))
         IF(IND.NE.0)GO TO 2
         WRITE(6,100)
100      FORMAT(' ********** ERROR IN CHCLSP -----> NO "LGCL"')
         GO TO 3
2     IP1=IDATA(IND+1)
      IP3=IDATA(IND+3)
      NCLST=IDATA(IND+IP1+2)
      NWPCL=IDATA(IND+25)
      IF(NCLST.LE.0)GO TO 3
      IF(NCLST.GT.50) NCLST = 50
C
      DO 20 I=1,NCLST
      IB=IND+IP3+(I-1)*NWPCL-1
      DO 25 J=1,3
25    PCL(J,I)=ADATA(IB+2)*ADATA(IB+J+8)
      PCL(4,I)=ADATA(IB+2)
         NCH=IDATA(IB+8)
         IF(NCH.NE.0)GO TO 20
         NPHTN=NPHTN+1
         DO 30 J=1,4
30       PPH(J,NPHTN)=PCL(J,I)
20    CONTINUE
      DO 40 I=1,NCLST
      DO 40 J=1,4
      P(J,NCHTR+I)=PCL(J,I)
40    CONTINUE
C
C -------- CALCULATE SPHERICITY
C
3     NT=NCHTR+NCLST
         IF(NT.GT.1)GO TO 4
         WRITE(6,300)NT,NCHTR,NCLST
300      FORMAT(' ********** ERROR IN CHCLSP -----> N(T,CH,CL) =',3I6)
         RETURN1
C
4     CALL SPHRIX(NT)
      SPH=BANK(1)
      CSTH=BANK(10)
      PHI=ATAN2(BANK(9),BANK(8))/RAD
         IF(PHI.LT.0.0)PHI=PHI+360.0
      Q1=BANK(11)
      Q23=BANK(12)
C
      RETURN
      END
       SUBROUTINE SPHRIX(JNC)
C
C      T. KOBAYASHI    AUG.10.1979   23:10
C
C
C ---- CALCULATE SPHERICITY
C
C      EINGABE: EIN BEREICH VON P-VEKTOREN ZWISCHEN 1 UND JNC
C      AUSGABE: BANK
C               INHALT  + 1  LAMDA(3) --- SPHERICITY
C               INHALT  + 2  COSX OF AXIS(1)
C               INHALT  + 3  COSY OF AXIS(1)
C               INHALT  + 4  COSZ OF AXIS(1)
C               INHALT  + 5  COSX OF AXIS(2)
C               INHALT  + 6  COSY OF AXIS(2)
C               INHALT  + 7  COSZ OF AXIS(2)
C               INHALT  + 8  COSX OF AXIS(3) --- S
C               INHALT  + 9  COSY OF AXIS(3) --- S
C               INHALT  +10  COSZ OF AXIS(3) --- S
C               INHALT  +11  Q1
C               INHALT  +12  (Q3-Q2)/SQRT(3.)
C
C
       DIMENSION PHA(100)
       DIMENSION TT(3,3),DD(3,3),XX(3,3),VV(9),RR(9)
       COMMON P(10,100),BANK(12)
       EXTERNAL VECSUB
C
C
C
C     1:PX  2:PY  3:PZ  4:E
C
C
      DO 10 I=1,10
10    BANK(I)=-1001.0
        IF (JNC.LE.0)RETURN
        DO 301 IT=1,JNC
        CALL LENGTH(IT,PJ)
301     PHA(IT)=PJ
C
C ----- BILDE LAENGEN DER VEKTOREN
C
       DO 69 IT=1,3
       DO 69 JT=1,3
   69  TT(IT,JT)=.0
C
       DO 61 J=1,JNC
       PJ=PHA(J)
       DO 61 IT=1,3
       DO 61 JT=1,3
       IF (JT-IT) 63,62,63
 62    TT(IT,JT)=PJ*PJ+TT(IT,JT)
 63    TT(IT,JT)=TT(IT,JT)-P(IT,J)*P(JT,J)
 61    CONTINUE
C
       DO 64 IT=1,3
       DO 64 JT=1,3
       IF (JT.GT.IT) GO TO 64
       CALL LOC(IT,JT,KV,3,3,1)
       VV(KV)=TT(IT,JT)
64    CONTINUE
C
      CALL EIGEN(VV,RR,3,0)
C
C ----- EIGENVALUES IN DIAGONAL DD
      CALL VTM(VV,DD,3,1)
C
C ----- EIGENVECTORS IN XX IN ROWS
      CALL VTM(RR,XX,3,0)
      TRI=TT(1,1)+TT(2,2)+TT(3,3)
C
C ----- FORM SPHERICITY
C
      SJE=3.0*DD(3,3)/TRI
C
C ----- PUT THE RESULTS INTO BANK
C
         BANK(1)=SJE
      I1=2
      DO 110 I=1,3
      DO 110 J=1,3
         BANK(I1)=XX(I,J)
      I1=I1+1
110   CONTINUE
C
C ----- CALCULATE Q1,Q2,Q3
C
      Q1=1.0-2.0*DD(1,1)/TRI
      Q2=1.0-2.0*DD(2,2)/TRI
      Q3=1.0-2.0*DD(3,3)/TRI
         BANK(11)=Q1
         BANK(12)=(Q3-Q2)/SQRT(3.0)
C
      RETURN
      END
      SUBROUTINE MOTAPR( IND, ITYPE, R, P )
C *---------------------------------------------------------
C *
C *  VERSION OF 11/06/79     LAST MOD  18/06/79    E.ELSEN
C *  FIND MOMENTUM P OF TRACK IND IN PATR BANK AT POSITION R.
C *  ITYPE DETERMINES CURVATURE USED ( AVERAGE, AT FIRST POINT
C *  OR LAST POINT. SEE KIPRCR )
C *---------------------------------------------------------
C
      DIMENSION R(3), P(3), PRM(5)

      COMMON / BCS / RW(1)
      COMMON / CGEO1 / BKGAUS
C                                                FETCH TRACK PARAMETERS
      CALL KIPRCR( IND, ITYPE, CAP, RM, PHIM, SIG )
      DZDR = RW( IND + 30 )
      GO TO 100
C                                                FETCH TRACK PARAMETERS
      ENTRY PRMTOM( PRM, R, P )
C *---------------------------------------------------------
C *  FIND MOMENTUM P FROM PARAMETERS PRM AT R.
C *---------------------------------------------------------
      CAP = ABS( PRM(1) )
      SIG = SIGN( 1., PRM(1) )
      RM = PRM(2)
      PHIM = PRM(3)
      DZDR = PRM(4)
C
C                                                TANGENT DIRECTION
  100 RMIT = RM + 1. / CAP
      RX = R(1) - RMIT*COS( PHIM )
      RY = R(2) - RMIT*SIN( PHIM )
      RTOT = SQRT( RX*RX + RY*RY ) * SIG
      EX = RY / RTOT
      EY = -RX / RTOT
C                                                RADIAL MOMENTUM
C
C  CHANGE TO ABS(BKGAUS)  2.4.1985  KOMAMIYA/OLSSON
C
      PRAD = .3E-4*ABS(BKGAUS)/CAP
C                                                TOTAL MOMENTUM
      P(1) = PRAD * EX
      P(2) = PRAD * EY
      P(3) = PRAD * DZDR
C
      RETURN
      END
      SUBROUTINE MTOPRM( P, R, SIG, PRM )
C *---------------------------------------------------------
C *
C *  VERSION OF 18/06/79     LAST MOD  18/06/79    E.ELSEN
C *  CONVERT MOMENTUM P A TRACK POINT R INTO STANDARD TRACK
C *  PARAMETERS PRM.
C *---------------------------------------------------------
C
      DIMENSION R(3), P(3), PRM(5)

      COMMON / CGEO1 / BKGAUS
      BK = BKGAUS*.3E-4
C                                          RADIUS , CENTER OF CIRCLE
      PRAD = SQRT(P(1)**2+P(2)**2)
      RAD = ABS( PRAD / BK )
      R0X = R(1) + P(2)/BK*SIG
      R0Y = R(2) - P(1)/BK*SIG
C                                          TRACK PARAMETERS
      PRM(1) = 1./RAD*SIG
      PRM(2) = SQRT( R0X*R0X + R0Y*R0Y ) - RAD
      PRM(3) = ATAN2( R0Y, R0X )
      PRM(4) = P(3) / PRAD
      PRM(5) = R(3) - PRM(4)*SQRT( R(1)**2 + R(2)**2 )
C
      RETURN
      END
      SUBROUTINE KIPRCR( IPOINT, ITYPE, CAP, RMIN, PHIMIT, SIG )
C-----------------------------------------------------------
C   VERSION OF 14/06/79    LAST MOD 15/06/79     E.ELSEN
C   CONVERT FIT PARAMETERS OF TRACK ( BANK PATR ) INTO  CURVATURE,
C   PHIMIT AND RMIN AS PARAMETERS OF A CIRCLE. SIGN IS SIG.
C   IF ITYPE = 0  AVERAGE CURVATURE
C            = 1  CURVATURE AT FIRST POINT
C            = 2  CURVATURE AT LAST POINT
C-----------------------------------------------------------
C
      COMMON / BCS / IW(1)
      DIMENSION RW(1)
      EQUIVALENCE ( IW(1),RW(1))
C
      CAP = ABS( RW( IPOINT + 25 ) )
      IF( ITYPE .EQ. 1 ) CAP = ABS( RW( IPOINT + 27 ) )
      IF( ITYPE .EQ. 2 ) CAP = ABS( RW( IPOINT + 28 ) )
      IF( IW(IPOINT+18) .EQ. 2 ) GO TO 1000
C
CCCCIRCLE PARAMETERS
      RMIN = RW( IPOINT + 20 )
      PHIMIT = RW( IPOINT + 21 )
      SIG = SIGN( 1., RW( IPOINT + 27 ) )
      GO TO 2000
C
CCCCPARABOLIC PARAMETERS
C1000 SIG = SIGN( 1., - RW( IPOINT + 22 ) )
 1000 SIG = SIGN( 1., - RW( IPOINT + 25 ) )
      RHO = SIG / AMAX1( CAP, 1.E-8 )
      XCEN = RW(IPOINT+20) + RHO*SIN(RW(IPOINT+19))
      YCEN = RW(IPOINT+21) - RHO*COS(RW(IPOINT+19))
      PHIMIT = ATAN2( YCEN, XCEN )
      RMIN = SQRT( YCEN*YCEN + XCEN*XCEN ) - ABS( RHO )
C
 2000 RETURN
      END
      SUBROUTINE EVIPR2
C
C     T. KOBAYASHI     10.09.1979    10:00
C         MODIFIED     11.09.1979    20:00
C         MODIFIED     22.03.80  FOR USE IN JADE GRAPHICS
C         LAST CHANGE 16.07.81             J.OLSSON
C
C --- EVENT DISPLAY ON IPS
C --- PROJECTION ON THE Q1-Q2, Q2-Q3, Q3-Q1 PLANE
C
      IMPLICIT INTEGER*2 (H)
C
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
C
      COMMON/CWORK/RTRACK(600),NTRK,NTRKL,NTRKLH,
     *  RMIN1,RMIN2,RMINL,  ZMIN,ZMINL,
     *  SUMPT,SUMPTL,       SUMP,SUMPL,    SUMLX,SUMLY,SUMLZ,
     *  PTMAX,PMAX,         ACOP,
     *  DPRT(10)
C-----------------------------------------------------------------------
C                            MACRO CGRAPH .... GRAPHICS COMMON
C-----------------------------------------------------------------------
C
      LOGICAL DSPDTL,SSTPS,PSTPS,FREEZE
C
      COMMON / CGRAPH / JUSCRN,NDDINN,NDDOUT,IDATSV(11),ICREC,MAXREC,
     +                  LSTCMD,ACMD,LASTVW,ISTANV,
     +                  SXIN,SXAX,SYIN,SYAX,XMIN,XMAX,YMIN,YMAX,
     +                  DSPDTL(30),SSTPS(10),PSTPS(10),FREEZE(30),
     +                  IREADM,LABEL,LSTPS(10),IPSVAR
C
C------- END OF MACRO CGRAPH -------------------------------------------
C
      DIMENSION ITRACK(600)
      EQUIVALENCE (ITRACK(1),RTRACK(1))
C
      COMMON P(10,100),BANK(12)
      COMMON /MOM/NCLST,NPHTN,NCHTR,PCL(4,50),PPH(4,50),PCH(4,50)
      COMMON /CHEADR/ HEAD(108)
C
      DIMENSION PR(3)
C
      DATA NHITMN/24/,SCALE/5.0/
C
      CALL ERASE
C
         NRUN=HEAD(18)
         NEVT=HEAD(19)
      INPA= IDATA(IBLN('PATR'))
      IF(INPA.LE.0) GO TO 5100
      CALL SUMPAT(INPA,*3000,*3000)
C
C ----- CALCULATE SPHERICITY AND Q-AXIS
C
      IPRMOM = 0
      CALL CHCLSP(SPH,CSTH1,PHI1,Q1,Q23,NHITMN,IPRMOM,*1500)
      NT=NCHTR+NCLST
         DPRT(1)=SPH
         DPRT(2)=Q1
         DPRT(3)=Q23
C
C ----- EVENT DISPLAY
C
      AX0=0.0
      AX1=6.0*SCALE
      AY0=0.6*SCALE
      AY1=6.6*SCALE
      X0=2.0*SCALE
      X1=4.0*SCALE
      CALL DWINDO(AX0,AX1,AY0,AY1)
C
      CALL BOX3(IDATSV,SCALE,ICREC,NRUN,NEVT,NCHTR,NCLST,DPRT)
C
      DO 20 I=1,NT
         DO 22 J=1,3
         J1=3*J-1
22       PR(J)=P(1,I)*BANK(J1)+P(2,I)*BANK(J1+1)+P(3,I)*BANK(J1+2)
      CALL PLIMIT(PR,SCALE)
C
C -------- Q3-Q2
      CALL MOVEA(X0,X1)
      IF(I.GT.NCHTR)GO TO 11
      CALL DRAWR(PR(3),PR(2))
      GO TO 12
11    CALL DASHR(PR(3),PR(2),34)
C
C -------- Q1-Q2
12    CALL MOVEA(X1,X1)
      IF(I.GT.NCHTR)GO TO 13
      CALL DRAWR(PR(1),PR(2))
      GO TO 14
13    CALL DASHR(PR(1),PR(2),34)
C
C -------- Q3-Q1
14    CALL MOVEA(X0,X0)
      IF(I.GT.NCHTR)GO TO 15
      CALL DRAWR(PR(3),PR(1))
      GO TO 20
15    CALL DASHR(PR(3),PR(1),34)
20    CONTINUE
C
C
1500  RETURN
3000  WRITE(6,3500)
3500  FORMAT(' NO CHARGED TRACKS')
      GO TO 1500
C
5100  WRITE(6,9510)
9510  FORMAT(' RAW DATA ERROR ')
      GO TO 1500
      END
      SUBROUTINE BOX3(IDATAL,SCALE,ICNT,NRUN,NEVT,NC,NN,DPRT)
C
C --- SUBROUTINE TO DRAW BOX AND WRITE DETAILS
C
      LOGICAL DSPDTM
      COMMON /CGRAP2/ BCMD,DSPDTM(30)
      DIMENSION IDATAL(11),FB(10),DPRT(10)
C
*** PMF 17/11/99: add variables needed for emulation of DESYLIB routine 'CORE'  
      CHARACTER cFB*40
      EQUIVALENCE (cFB,FB(1))
*** PMF(end)
C     IF(DSPDTM(30)) WRITE(6,9151) SCALE,ICNT,NRUN,NEVT,NC,NN
C9151  FORMAT(' BOX3 SCLE ICNT NRU NVT NC NN ',E12.4,5I5)
C     IF(DSPDTM(30)) CALL PROMPT
      S1=SCALE
      S3=3.0*SCALE
      S5=5.0*SCALE
C     IF(DSPDTM(30)) WRITE(6,9152) S1,S3,S5
C9152  FORMAT(' BOX3 S1 S3 S5 ',3E12.4)
C     IF(DSPDTM(30)) CALL PROMPT
      CALL MOVEA(S3,S5)
      CALL DRAWA(S3,S1)
      CALL DRAWA(S1,S1)
      CALL DRAWA(S1,S5)
      CALL DRAWA(S5,S5)
      CALL DRAWA(S5,S3)
      CALL DRAWA(S1,S3)
C
      CALL CHRSIZ(3)
C     IF(DSPDTM(30)) WRITE(6,9153) S1,S3,S5
C9153  FORMAT(' BOX3 TO CALL PSCALE: S1,3,5 ',3E12.4)
C     IF(DSPDTM(30)) CALL PROMPT
      CALL PSCALE(S1,S1,S1)
      CALL MOVEA(2.6*S1,1.04*S1)
      CALL EOUTST(7,'(Q3,Q1)')
      CALL PSCALE(S1,S3,S1)
      CALL MOVEA(2.6*S1,3.04*S1)
      CALL EOUTST(7,'(Q3,Q2)')
      CALL PSCALE(S3,S3,S1)
      CALL MOVEA(4.6*S1,3.04*S1)
      CALL EOUTST(7,'(Q1,Q2)')
C
C
      XSTXT=3.6*SCALE
      YSTXT=2.3*S1
      DL=0.12*SCALE
      CALL MOVEA(XSTXT,YSTXT)
      CALL EOUTST(20,IDATAL)
C
      YSTXT=YSTXT-DL
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,14)
      WRITE(cFB,100)ICNT ! PMF 17/11/99: UNIT=10 changed to cFB
100   FORMAT('EVENT NO.',I5)
      CALL EOUTST(14,FB)
C
      YSTXT=YSTXT-DL
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,21)
      WRITE(cFB,110)NRUN,NEVT ! PMF 17/11/99: UNIT=10 changed to cFB
110   FORMAT('RUN NO.',I6,' -',I6)
      CALL EOUTST(21,FB)
C
      YSTXT=YSTXT-DL
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,18)
      WRITE(cFB,115)NC,NN ! PMF 17/11/99: UNIT=10 changed to cFB
115   FORMAT('N(C,N) =',2I5)
      CALL EOUTST(18,FB)
C
      YSTXT=YSTXT-DL
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,11)
      WRITE(cFB,120)DPRT(1) ! PMF 17/11/99: UNIT=10 changed to cFB
120   FORMAT('S =',F8.4)
      CALL EOUTST(11,FB)
C
      YSTXT=YSTXT-DL
      CALL MOVEA(XSTXT,YSTXT)
      CALL CORE(FB,19)
      WRITE(cFB,130)(DPRT(J),J=2,3) ! PMF 17/11/99: UNIT=10 changed to cFB
130   FORMAT('Q =',2F8.3)
      CALL EOUTST(19,FB)
C
      CALL MOVEA(3.2*S1,2.8*S1)
      CALL CORE(FB,20)
      WRITE(cFB,200)SCALE ! PMF 17/11/99: UNIT=10 changed to cFB
200   FORMAT('SCALE =',F7.1,' GEV/C')
      CALL EOUTST(20,FB)
C
      RETURN
      END
      SUBROUTINE PSCALE(X,Y,S)
      LOGICAL DSPDTM
      COMMON /CGRAP2/ BCMD,DSPDTM(30)
C
C --- SUBROUTINE TO DRAW SCALES IN THE BOX
C
C     IF(DSPDTM(30)) WRITE(6,9144) X,Y,S
C9144  FORMAT(' PSCALE XYS ',3E12.4)
C     IF(DSPDTM(30)) CALL PROMPT
      DL=0.05*S
      S2=2.0*S
C     IF(DSPDTM(30)) WRITE(6,9154) X,Y,S,DL,S2
C9154  FORMAT(' PSCALE XYS DL S2 ',5E12.4)
C     IF(DSPDTM(30)) CALL PROMPT
      CALL MOVEA(X,Y+S)
      CALL DRAWR(DL,0.)
C     IF(DSPDTM(30)) CALL PROMPT
      CALL MOVEA(X+S,Y+S2)
      CALL DRAWR(0.,-DL)
C     IF(DSPDTM(30)) CALL PROMPT
      CALL MOVEA(X+S2,Y+S)
      CALL DRAWR(-DL,0.)
C     IF(DSPDTM(30)) CALL PROMPT
      CALL MOVEA(X+S,Y)
      CALL DRAWR(0.,DL)
      RETURN
      END
      SUBROUTINE PLIMIT(PR,SCALE)
C
C --- SUBROUTINE TO REDUCE MOM. WHICH IS OUT OF THE BOUNDARY
C
      DIMENSION PR(3),APR(3)
C
      DO 10 I=1,3
      APR(I)=ABS(PR(I))
      IF(APR(I).GT.SCALE)GO TO 1
10    CONTINUE
      RETURN
C
1     AP=APR(1)
      IF(APR(2).GT.AP)AP=APR(2)
      IF(APR(3).GT.AP)AP=APR(3)
      FC=SCALE/AP
      DO 20 I=1,3
20    PR(I)=FC*PR(I)
      RETURN
      END
