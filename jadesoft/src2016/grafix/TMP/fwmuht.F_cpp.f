C   20/08/80 202051433  MEMBER NAME  FWMUHT   (JADEGS)      FORTRAN
      SUBROUTINE FWMUHT
      IMPLICIT INTEGER*2 (H)
CODE L.O'NEILL,MODIFIED J.OLSSON   28.5.81
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
      COMMON /CHEADR/ HEAD(108)
      COMMON /CWORK2/AGEO(6,16)
      COMMON /CFWMU/ HAXES(4,3),AFWMU(18)
      DIMENSION HMIN(2), HPLU(2)
      DATA HMIN/'-','Z'/,HPLU/'+','Z'/,MASK2/Z20000/
C---
      IPNTR=IDATA(IBLN('LATC'))
      IF(IPNTR.LT.1) GO TO 200
      IPNTH=2*IDATA(IBLN('ATOF'))
      IF(IPNTH.LT.1) GO TO 200
      IF(HEAD(18).LT.3730.OR..NOT.DSPDTL(30)) IPNTH=0
      IBDC = IDATA(IPNTR+1)
      IWB1 = 21
      IWB2 = 22
      IF(LAND(MASK2,IBDC).NE.0) IWB1 = 12
      IF(LAND(MASK2,IBDC).NE.0) IWB2 = 13
      MPROJ=2
      IF(LASTVW.GT.7) MPROJ = 1
      IF(LASTVW.EQ.15) MPROJ=3
      IXS=HAXES(1,MPROJ)
      IXA=HAXES(2,MPROJ)
      IYS=HAXES(3,MPROJ)
      IYA=HAXES(4,MPROJ)
      DO 5010  I = 1,4
      AGEO(1,I) = AFWMU(I)
      AGEO(4,I) = AFWMU(I+4)
5010  AGEO(5,I) = AFWMU(I+8)
      DO 1 I=1,4
      AGEO(1,(9-I))=-AGEO(1,I)-5.
      AGEO(4,(9-I))= AGEO(4,I)
1     AGEO(5,(9-I))= AGEO(5,I)
      DO 2 I=1,8
      AGEO(1,(I+8))=AGEO(1,I)
      AGEO(4,(I+8))=AGEO(4,I)
2     AGEO(5,(I+8))=AGEO(5,I)
      DO 7110  J = 1,16
7110  AGEO(6,J) = AFWMU(15)
      DO 7111  J = 1,8
      AGEO(2,J+8) = AFWMU(17)
7111  AGEO(2,J) = AFWMU(13)
      DO 7112  J = 1,4
      AGEO(3,J+4) = AFWMU(16)
      AGEO(3,J+8) = -AFWMU(16)
      AGEO(3,J+12) = AFWMU(18)
7112  AGEO(3,J) = AFWMU(14)
      IF(LASTVW.NE.15) GO TO 300
      SH3=100.
      Y1=4000.
      ICNT=2
      X1=5250.-SH3
      CALL HEMSYM(X1,Y1,SH3,HPLU,ICNT,0.)
      X1=X1+SH3
      DO 301 I=1,8
      AGEO(1,I)=AGEO(1,I)-X1
301   AGEO(2,I)=AGEO(2,I)+Y1
      X1=1250.-SH3
      CALL HEMSYM(X1,Y1,SH3,HMIN,ICNT,0.)
      X1=X1+SH3
      DO 302 I=9,16
      AGEO(1,I)=AGEO(1,I)-X1
302   AGEO(2,I)=AGEO(2,I)+Y1
  300 CONTINUE
C---
      IW1=HDATA(2*IPNTR+IWB1)
      IW2=HDATA(2*IPNTR+IWB2)
      IW0=IW1+256*IW2
      MASK=1
      DO 12 I=1,16
      X0=IXS*AGEO(IXA,I)
      Y0=IYS*AGEO(IYA,I)
      DX=    AGEO((IXA+3),I)
      DY=    AGEO((IYA+3),I)
      IF(IPNTH.GT.0) CALL FTDLHO(IPNTH,I,MPROJ,X0,Y0,DX,DY)
      ITEST=LAND(IW0,MASK)
      MASK=2*MASK
      IF(ITEST.EQ.0) GO TO 12
      NSTEP=2.*DY/50.+1
      STEP=2.*DY/NSTEP
      CALL RECTAN(X0-DX,Y0-DY,X0+DX,Y0+DY,0)
      IFLIP=1
      X=X0-IFLIP*DX
      Y=Y0-DY
      CALL MOVEA(X,Y)
      DO 13 J=1,NSTEP
      IFLIP=-IFLIP
      X=X0-IFLIP*DX
      Y=Y+STEP
      CALL DRAWA(X,Y)
   13 CONTINUE
      IFLIP=-1
      X=X0-IFLIP*DX
      Y=Y0-DY
      CALL MOVEA(X,Y)
      DO 14 J=1,NSTEP
      IFLIP=-IFLIP
      X=X0-IFLIP*DX
      Y=Y+STEP
      CALL DRAWA(X,Y)
   14 CONTINUE
   12 CONTINUE
  200 CONTINUE
      RETURN
      END
      BLOCK DATA BLCKG3 !PMF 03/12/99: add name
      IMPLICIT INTEGER*2 (H)
      COMMON /CFWMU/ HAXES(4,3),AFWMU(18)
      DATA HAXES /1,3,1,2,1,3,1,1,-1,1,1,2/
      DATA AFWMU /-1378.,-1027.,-738.5,-512.5,2*175.,2*112.5,965.,1270.,
     $ 2*1300.,-22.,2569.,15.,2564.,-23.,-2582./
      END
