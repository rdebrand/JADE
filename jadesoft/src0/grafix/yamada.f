C   10/10/79 C9101501   MEMBER NAME  YAMADA   (JADEGS)      FORTRAN
      SUBROUTINE YAMADA(INDEX)
C----
C---     DRIVER ROUTINE FOR YAMADA'S CLUSTER FINDING ROUTINES WHEN THEY
C---     RUN UNDER GRAPHICS.      AUTHOR L.H. O'NEILL
C---                             ( CHANGED 15.7.79   J.OLSSON)
C---                             ( CHANGED 14.10.79   J.OLSSON)
      IMPLICIT INTEGER*2 (H)
#include "cgraph.for"
#include "cdata.for"
      COMMON /CMSGCT/ MSGDUM(10),LGMMAX,LGMSG(9)
      COMMON/CWORK/HWORK(40),XLINE(3,200,2),X,Y,X0,Y0,DX,DY,
     1NBLK,NBLK1,XCLMIN,XCLMAX,YCLMIN,YCLMAX,XCLDRW,YCLDRW,SIZE
      DATA ICALL/0/
      IF(ICALL.EQ.1) GO TO 300
      ICALL=1
      LGMMAX=10
      DO 400 I=1,6
      LGMSG(I)=0
  400 CONTINUE
      XMBARL=    0.00
      XRBARL= 6911.52
      YABARL= 4496.00
      XE01  =  898.50
      YE01  =  900.00
      XE02  = 6013.02
      YE02  =  900.00
  300 CONTINUE
      IF((INDEX.NE.2).AND.(INDEX.NE.3).AND.(LASTVW.NE.13))
     1CALL TRMOUT(80,'CLUSTER DISPLAY NOT AVAILABLE IN THIS VIEW.^')
      IF((INDEX.NE.3).AND.(LASTVW.NE.13)) RETURN
      IF(IDATA(IBLN('ALGN')).LT.1) RETURN
      IF(INDEX.NE.3) GO TO 3
      IERR=0
      IF(IDATA(IBLN('LGCL')).EQ.0) GO TO 8
      CALL BMLT(1,'LGCL')
      CALL BDLM
    8 CONTINUE
      IF(IERR.NE.0) CALL TRMOUT(80,'ERROR ATTEMPTING TO ERASE LGCL^')
      IF(IERR.NE.0) RETURN
      CALL LGANAL
      RETURN
    3 CONTINUE
      IPLGCL=IDATA(IBLN('LGCL'))
      IF(IPLGCL.LT.1) RETURN
      IRET=IDATA(IPLGCL+20)
      IF(IRET.NE.0) GO TO 1
      GO TO 2
    1 CONTINUE
      CALL TRMOUT(80,'CLUSTER ANALYSIS ERROR EXIT.^')
      RETURN
    2 CONTINUE
      IPSHUF=IDATA(IBLN('ALGN'))
      NCLST=IDATA(IPLGCL+7)
      IP3=IDATA(IPLGCL+3)
      NWPCL=IDATA(IPLGCL+25)
      IF(INDEX.NE.2) GO TO 301
      WRITE(JUSCRN,101) NCLST
  101 FORMAT(' NCLST=',I10)
  301 CONTINUE
      IF(NCLST.LT.1) GO TO 5
      IF(NCLST.GT.50) GO TO 5
      IPMAP=IDATA(IPLGCL+2)+IPLGCL-1
      DO 6 ICLST=1,NCLST
      LIM1=2*HDATA(2*IPMAP+2*ICLST-1)-1
      LIM2=2*HDATA(2*IPMAP+2*ICLST  )
      IB=IP3+(ICLST-1)*NWPCL-1+IPLGCL
      IF(INDEX.NE.2) GO TO 303
      CALL TRMOUT(80,' ^')
      NBLOKS=(LIM2-LIM1+1)/2
      WRITE(JUSCRN,102) ICLST,LIM1,LIM2,NBLOKS
  102 FORMAT(' CLUSTER, ADDRESS RANGE AND NUMBER OF BLOCKS = ',4I6)
      IF(NBLOKS.LT.1) GO TO 6
      NCYCLE=1+(NBLOKS-1)/5
      DO 302 LINE=1,NCYCLE
      LIML=LIM1+10*(LINE-1)
      LIMU=LIML+9
      IF(LIMU.GT.LIM2) LIMU=LIM2
      WRITE(JUSCRN,104) (HDATA(2*IPSHUF+6+KLM),KLM=LIML,LIMU)
  104 FORMAT(' ',10I6)
  302 CONTINUE
      CALL TRMOUT(80,
     1'JPART,          E,         DE,        PHI,          Z,       DPHI
     1          DZ^')
      WRITE(JUSCRN,105) IDATA(IB+1),(ADATA(IB+KLM),KLM=2,7)
  105 FORMAT(' ',I5,6F12.4)
      GO TO 6
  303 CONTINUE
      IF(LIM2.LT.LIM1) GO TO 5
      IF((LIM2-LIM1).GT.100) GO TO 5
      KOUNT=0
      XCLMIN= 100000.
      XCLMAX=-100000.
      YCLMIN= 100000.
      YCLMAX=-100000.
      DO 7 IADD=LIM1,LIM2,2
      NBLK=HDATA(2*IPSHUF+6+IADD)
      CALL XYBLK(NBLK,X0,Y0,DX,DY)
      IF( X0    .LT.XCLMIN) XCLMIN=X0
      IF((X0+DX).GT.XCLMAX) XCLMAX=X0+DX
      IF( Y0    .LT.YCLMIN) YCLMIN=Y0
      IF((Y0+DY).GT.YCLMAX) YCLMAX=Y0+DY
      IF(KOUNT.GT.198) GO TO 7
      KOUNT=KOUNT+1
      XLINE(1,KOUNT,1)=Y0
      XLINE(2,KOUNT,1)=X0
      XLINE(3,KOUNT,1)=X0+DX
      XLINE(1,KOUNT,2)=X0
      XLINE(2,KOUNT,2)=Y0
      XLINE(3,KOUNT,2)=Y0+DY
      KOUNT=KOUNT+1
      XLINE(1,KOUNT,1)=Y0+DY
      XLINE(2,KOUNT,1)=X0
      XLINE(3,KOUNT,1)=X0+DX
      XLINE(1,KOUNT,2)=X0+DX
      XLINE(2,KOUNT,2)=Y0
      XLINE(3,KOUNT,2)=Y0+DY
    7 CONTINUE
      SIZE=65.
      XCLDRW= XCLMIN - 3.*SIZE
      IF(ICLST.GE.10)  XCLDRW = XCLDRW - SIZE
      YCLDRW=(YCLMIN+YCLMAX)/2.-SIZE/2.
      CALL NUMBWR(13,ICLST,XCLDRW,YCLDRW,SIZE)
      DO 201 IDIR=1,2
      IF(KOUNT.LT.2) GO TO 201
      KOUNTM=KOUNT-1
      DO 202 J1=1,KOUNTM
      Y=XLINE(1,J1,IDIR)
      XMIN2=XLINE(2,J1,IDIR)
      XMAX2=XLINE(3,J1,IDIR)
      LIM1=J1+1
      DO 203 K1=LIM1,KOUNT
      Y1=XLINE(1,K1,IDIR)
      IF(ABS(Y1-Y).GT.1) GO TO 203
      XMIN1=XLINE(2,K1,IDIR)
      XMAX1=XLINE(3,K1,IDIR)
      IF(ABS(XMIN1-XMIN2).GT.1.) GO TO 304
      IF(ABS(XMAX1-XMAX2).GT.1.) GO TO 304
C--      IDENTICAL LINES
      XLINE(1,J1,IDIR)=100000.
      XLINE(1,K1,IDIR)=100000.
      GO TO 202
  304 CONTINUE
C--      CHECK FOR NON-OVERLAPPING LINES.
      IF((XMAX1-XMIN2).LT.1.) GO TO 203
      IF((XMIN1-XMAX2).GT.1.) GO TO 203
C--      THE LINES OVERLAP.
      IF(XMAX1.GT.XMAX2) GO TO 305
      XLINE(2,J1,IDIR)=XMAX1
      XLINE(3,K1,IDIR)=XMIN2
      GO TO 203
  305 CONTINUE
      XLINE(2,K1,IDIR)=XMAX2
      XLINE(3,J1,IDIR)=XMIN1
  203 CONTINUE
  202 CONTINUE
  201 CONTINUE
      IF(KOUNT.LT.2) GO TO 205
      DO 206 LINE=1,KOUNT
      Y0=XLINE(1,LINE,1)
      IF(Y0.GT.10000.) GO TO 207
      X0=XLINE(2,LINE,1)
      CALL MOVEA(X0,Y0)
      X1=XLINE(3,LINE,1)
      Y1=Y0
      CALL DRAWA(X1,Y1)
  207 CONTINUE
      X0=XLINE(1,LINE,2)
      IF(X0.GT.10000.) GO TO 206
      Y0=XLINE(2,LINE,2)
      CALL MOVEA(X0,Y0)
      Y1=XLINE(3,LINE,2)
      X1=X0
      CALL DRAWA(X1,Y1)
  206 CONTINUE
  205 CONTINUE
      IF(INDEX.NE.1) GO TO 6
      IF(IDATA(IB+1).NE.0) GO TO 306
C---     BARREL SECTION.
      X0=XMBARL+ADATA(IB+4)*XRBARL/6.283185308
      IF(X0.LT.0.) X0=X0+XRBARL
      X1=X0
      Y0=YABARL
      Y1=ADATA(IB+5)+Y0
      CALL SAEGE(X0,Y0,X1,Y1)
      GO TO 6
  306 CONTINUE
C---     END CAP CASE
      X0=XE01
      Y0=YE01
      IF(IDATA(IB+1).NE.1) GO TO 307
      X0=XE02
      Y0=YE02
  307 CONTINUE
      X1=-ADATA(IB+4)+X0
      Y1= ADATA(IB+5)+Y0
      CALL SAEGE(X0,Y0,X1,Y1)
    6 CONTINUE
    5 CONTINUE
      RETURN
      END