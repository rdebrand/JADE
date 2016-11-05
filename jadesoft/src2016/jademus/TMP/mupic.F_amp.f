C   20/10/81 406182141  MEMBER NAME  MUPIC    (JADEMUS)     FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE MUPIC
C-----------------------------------------------------------------------
C
C LAST CHANGE 21.00 18/06/84 CHRIS BOWDERY - DRAW NOTHING IF NO CAL.
C      CHANGE 12.15  9/04/83 CHRIS BOWDERY - USE NEW MUFSTA FOR BODGE
C      CHANGE 12.30 31/03/82 HUGH MCCANN   - MODIFY BAD CHAMBER BODGE.
C      CHANGE 14.30 16/03/82 HUGH MCCANN   - TO BODGE GRAPHICS LIKE
C                                            MUCOOR RE DEAD CHAMS.
C      CHANGE 08.30 14/10/81 HUGH MCCANN   - TO DRAW (LONG) BASE OF YOKE
C      CHANGE 11.30 11/10/81 HUGH MCCANN   - TO DRAW Z-ENDS OF WIRES.
C      CHANGE 19.55 22/04/80 JOHN ALLISON  - TO DASH THE DEAD CHAMBERS.
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
#include "cmubcs.for"
#include "cgraph.for"
#include "cmucalib.for"
C
C------------------  C O D E  ------------------------------------------
C
      IPHEAD = IDATA(IBLN('HEAD'))
      IMONTH = HDATA(2*IPHEAD+7)
      IYEAR  = HDATA(2*IPHEAD+8)
      KRUN   = HDATA(2*IPHEAD+10)
      KREC   = HDATA(2*IPHEAD+11)
C
C                           FIX UP GRAPHICS PICTURE. DEAD CHAMBER BODGE.
C
      CALL MUFSTA( IMONTH, IYEAR )
C
C
      IF((LASTVW.LT.1).OR.(LASTVW.GT.11)) RETURN
      IVWN=3
      IF(LASTVW.GT.3) IVWN=2
      IF(LASTVW.GT.7) IVWN=1
C
C                            NO CALIBRATION? THEN RETURN
C
      IF( IZOEP1 .EQ. 0  .AND.  IZOEP3 .EQ. 0 ) RETURN
C
C
C
C                       IVWN = 1,2,3 FOR ZY,ZX,XY VIEWS RESPECTIVELY.
C
      GO TO (1,2,3),IVWN
C
 1    CONTINUE
C ZY VIEW - NO WIRES.
C FACE 3 AND 4 BLOCKS.
      X1=0.
      X2=0.
      DO 11 IFACE=3,4
      Z1=HBLLO(IFACE)
      Z2=HBLHI(IFACE)
      J=6*IFACE-5
      DO 11 IBLOCK=1,3
      Y1=HBNLIM(J)
      Y2=HBNLIM(J+1)
      CALL XYMUD(X1,Y1,Z1,XLO,YLO)
      CALL XYMUD(X2,Y2,Z2,XHI,YHI)
      CALL MUVIER(XLO,YLO,XHI,YHI)
      J=J+2
 11   CONTINUE
C FACE 5 AND 6 BLOCKS.
      DO 12 IFACE=5,6
      Y1=HBLLO(IFACE)
      Y2=HBLHI(IFACE)
      J=6*IFACE-5
      DO 12 IBLOCK=1,3
      Z1=HBNLIM(J)
      Z2=HBNLIM(J+1)
      CALL XYMUD(X1,Y1,Z1,XLO,YLO)
      CALL XYMUD(X2,Y2,Z2,XHI,YHI)
      CALL MUVIER(XLO,YLO,XHI,YHI)
      J=J+2
 12   CONTINUE
C
C DRAW YOKE.
      DO 19 I=1,2
      S=-1.
      IF(I.EQ.2)S=1.
      CALL MOVEA(FLOAT(IZOEP1),S*IREP1)
      CALL DRAWA(FLOAT(IZOEP3),S*IREP2)
      CALL DRAWA(FLOAT(IZOEP3),S*IREP4)
      CALL DRAWA(FLOAT(IZOEP5),S*IREP4)
      IF(S)14,14,16
   14 IYKLDM=HYKLDM(3)
      CALL DRAWA(FLOAT(IZOEP5),S*IXYEP5)
      CALL DRAWA(FLOAT(IYKLDM),S*IXYEP5)
      CALL DRAWA(FLOAT(IYKLDM),S*HYKNMO(2))
      CALL DRAWA(-FLOAT(IYKLDM),S*HYKNMO(2))
      CALL DRAWA(-FLOAT(IYKLDM),S*IXYEP5)
      CALL DRAWA(-FLOAT(IZOEP5),S*IXYEP5)
      GO TO 18
   16 CALL DRAWA(FLOAT(IZOEP5),S*HYKNMO(2))
      CALL DRAWA(-FLOAT(IZOEP5),S*HYKNMO(2))
   18 CALL DRAWA(-FLOAT(IZOEP5),S*IREP4)
      CALL DRAWA(-FLOAT(IZOEP3),S*IREP4)
      CALL DRAWA(-FLOAT(IZOEP3),S*IREP2)
      CALL DRAWA(-FLOAT(IZOEP1),S*IREP1)
      CALL DRAWA(-FLOAT(IZEII),S*IREP1)
      CALL DRAWA(-FLOAT(IZEII),S*IREP3)
      CALL DRAWA(-FLOAT(IZEIO),S*IREP3)
      CALL DRAWA(-FLOAT(IZEIO),S*IXYEP5)
      CALL DRAWA(FLOAT(IZEIO),S*IXYEP5)
      CALL DRAWA(FLOAT(IZEIO),S*IREP3)
      CALL DRAWA(FLOAT(IZEII),S*IREP3)
      CALL DRAWA(FLOAT(IZEII),S*IREP1)
      CALL DRAWA(FLOAT(IZOEP1),S*IREP1)
 19   CONTINUE
      IFLO=3
      IFHI=6
      GO TO 4
C
 2    CONTINUE
C ZX VIEW - END WALL WIRES DISPLAYED.
      DO 21 ICHAM=443,634
      CALL MUWIRE(ICHAM,X,Y,Z)
      IF(HMCSTA(ICHAM).EQ.0)GO TO 201
      CALL XYMUD(X-150.,Y,Z,XS,YS)
      CALL MOVEA(XS,YS)
      CALL XYMUD(X+150.,Y,Z,XS,YS)
      CALL DASHA(XS,YS,45)
      GO TO 21
 201  CONTINUE
      CALL XYMUD(X,Y,Z,XS,YS)
      CALL POINTA(XS,YS)
 21   CONTINUE
C FACE 1 AND 2 BLOCKS.
      Y1=0.
      Y2=0.
      DO 22 IFACE=1,2
      Z1=HBLLO(IFACE)
      Z2=HBLHI(IFACE)
      J=6*IFACE-5
      DO 22 IBLOCK=1,3
      X1=HBNLIM(J)+HOVALL(IFACE)
      X2=HBNLIM(J+1)+HOVALL(IFACE)
      CALL XYMUD(X1,Y1,Z1,XLO,YLO)
      CALL XYMUD(X2,Y2,Z2,XHI,YHI)
      CALL MUVIER(XLO,YLO,XHI,YHI)
      J=J+2
 22   CONTINUE
C FACE 5 AND 6 BLOCKS - LEFT.
      DO 23 IFACE=5,6
      X1=HBTLO(IFACE)+HOVALL(4)
      X2=-50+HOVALL(4)
      J=6*IFACE-5
      DO 23 IBLOCK=1,3
      Z1=HBNLIM(J)
      Z2=HBNLIM(J+1)
      CALL XYMUD(X1,Y1,Z1,XLO,YLO)
      CALL XYMUD(X2,Y2,Z2,XHI,YHI)
      CALL MUVIER(XLO,YLO,XHI,YHI)
      J=J+2
 23   CONTINUE
C FACE 5 AND 6 BLOCKS - RIGHT.
      DO 24 IFACE=5,6
      X1=50+HOVALL(5)
      X2=HBTHI(IFACE)+HOVALL(5)
      J=6*IFACE-5
      DO 24 IBLOCK=1,3
      Z1=HBNLIM(J)
      Z2=HBNLIM(J+1)
      CALL XYMUD(X1,Y1,Z1,XLO,YLO)
      CALL XYMUD(X2,Y2,Z2,XHI,YHI)
      CALL MUVIER(XLO,YLO,XHI,YHI)
      J=J+2
 24   CONTINUE
C
C DRAW YOKE .
      DO 41 I=1,2
      S=-1.
      IF(I.EQ.2)S=1.
      CALL MOVEA(FLOAT(IZOEP1),S*IREP1)
      CALL DRAWA(FLOAT(IZOEP3),S*IREP2)
      CALL DRAWA(FLOAT(IZOEP3),S*IREP4)
      CALL DRAWA(FLOAT(IZOEP5),S*IREP4)
      CALL DRAWA(FLOAT(IZOEP5),S*HYKNMO(2))
      CALL DRAWA(-FLOAT(IZOEP5),S*HYKNMO(2))
      CALL DRAWA(-FLOAT(IZOEP5),S*IREP4)
      CALL DRAWA(-FLOAT(IZOEP3),S*IREP4)
      CALL DRAWA(-FLOAT(IZOEP3),S*IREP2)
      CALL DRAWA(-FLOAT(IZOEP1),S*IREP1)
      CALL DRAWA(-FLOAT(IZEII),S*IREP1)
      CALL DRAWA(-FLOAT(IZEII),S*IREP3)
      CALL DRAWA(-FLOAT(IZEIO),S*IREP3)
      CALL DRAWA(-FLOAT(IZEIO),S*IXYEP5)
      CALL DRAWA(FLOAT(IZEIO),S*IXYEP5)
      CALL DRAWA(FLOAT(IZEIO),S*IREP3)
      CALL DRAWA(FLOAT(IZEII),S*IREP3)
      CALL DRAWA(FLOAT(IZEII),S*IREP1)
      CALL DRAWA(FLOAT(IZOEP1),S*IREP1)
 41   CONTINUE
      IFLO=1
      IFHI=2
C
  4   CONTINUE
C  DRAW LONGITUDINAL SENSITIVE LIMITS (ZY * ZX VIEWS ONLY ).
C  XS--- * YS--- REFER TO HORIZL * VERTL COORDS ON SCREEN.
C
      DO 49 IFACE=IFLO,IFHI
          DO 49 ILAYER=1,5
              IF(IFACE.GT.4.AND.ILAYER.EQ.1)GO TO 49
              DO 47 IFRAME=1,82
                  IFR=IFRAME
                  IF(HFACE(IFR).NE.IFACE)GO TO 47
                  IF(HLAYER(IFR).NE.ILAYER)GO TO 47
                  IF(IFACE.GT.4)GO TO 45
  43              CONTINUE
                  XSLO=HCLLO(IFR)
                  XSHI=HCLHI(IFR)
                  YSFIXD=HDIST(IFR)
                  IF(IFACE.LE.2.AND.ILAYER.GT.1)
     *            YSFIXD=YSFIXD+HOVALL(IFACE)
                  CALL MOVEA(XSLO+20.,YSFIXD-20.)
                  CALL DRAWA(XSLO    ,YSFIXD-20.)
                  CALL DRAWA(XSLO    ,YSFIXD+20.)
                  CALL DRAWA(XSLO+20.,YSFIXD+20.)
                  CALL MOVEA(XSHI-20.,YSFIXD-20.)
                  CALL DRAWA(XSHI    ,YSFIXD-20.)
                  CALL DRAWA(XSHI    ,YSFIXD+20.)
                  CALL DRAWA(XSHI-20.,YSFIXD+20)
                  IF(IFACE.NE.4)GO TO 49
                  IF(ILAYER.EQ.1.OR.ILAYER.EQ.2)GO TO 49
                  IF(IFR.EQ.47.OR.IFR.EQ.55.OR.IFR.EQ.63)GO TO 49
                  IFR=IFR+4
                  GO TO 43
   45             XSFIXD=HDIST(IFR)
                  YSLO=HCLLO(IFR)
                  YSHI=HCLHI(IFR)
                  CALL MOVEA(XSFIXD-20.,YSLO+20.)
                  CALL DRAWA(XSFIXD-20.,YSLO    )
                  CALL DRAWA(XSFIXD+20.,YSLO    )
                  CALL DRAWA(XSFIXD+20.,YSLO+20.)
                  CALL MOVEA(XSFIXD-20.,YSHI-20.)
                  CALL DRAWA(XSFIXD-20.,YSHI    )
                  CALL DRAWA(XSFIXD+20.,YSHI    )
                  CALL DRAWA(XSFIXD+20.,YSHI-20.)
                  GO TO 49
   47         CONTINUE
   49 CONTINUE
      GO TO 99
C
 3    CONTINUE
C XY VIEW - WIRES IN 'BARREL'.
      DO 31 ICHAM=1,442
      CALL MUWIRE(ICHAM,X,Y,Z)
      IF((ICHAM.GE.323.AND.ICHAM.LE.346)
     * .OR. (ICHAM.GE.371.AND.ICHAM.LE.394)
     * .OR. (ICHAM.GE.419.AND.ICHAM.LE.442))Y=Y+10.
      IF(HMCSTA(ICHAM).EQ.0)GO TO 301
      IFRAME=HFR(ICHAM)
      IF(HTRANS(IFRAME).GT.1)GO TO 302
      CALL XYMUD(X-150.,Y,Z,XS,YS)
      CALL MOVEA(XS,YS)
      CALL XYMUD(X+150.,Y,Z,XS,YS)
      CALL DASHA(XS,YS,45)
      GO TO 31
 302  CONTINUE
      CALL XYMUD(X,Y-150.,Z,XS,YS)
      CALL MOVEA(XS,YS)
      CALL XYMUD(X,Y+150.,Z,XS,YS)
      CALL DASHA(XS,YS,45)
      GO TO 31
 301  CONTINUE
      CALL XYMUD(X,Y,Z,XS,YS)
      CALL POINTA(XS,YS)
 31   CONTINUE
C FACE 1 AND 2 BLOCKS.
      Z1=0.
      Z2=0.
      DO 32 IFACE=1,2
      Y1=HBTLO(IFACE)
      Y2=HBTHI(IFACE)
      J=6*IFACE-5
      DO 32 IBLOCK=1,3
      X1=HBNLIM(J)+HOVALL(IFACE)
      X2=HBNLIM(J+1)+HOVALL(IFACE)
      CALL XYMUD(X1,Y1,Z1,XLO,YLO)
      CALL XYMUD(X2,Y2,Z2,XHI,YHI)
      CALL MUVIER(XLO,YLO,XHI,YHI)
      J=J+2
 32   CONTINUE
C FACE 3 BLOCKS.
      X1=HBTLO(3)
      X2=HBTHI(3)
      J=13
      DO 33 IBLOCK=1,3
      Y1=HBNLIM(J)
      Y2=HBNLIM(J+1)
      CALL XYMUD(X1,Y1,Z1,XLO,YLO)
      CALL XYMUD(X2,Y2,Z2,XHI,YHI)
      CALL MUVIER(XLO,YLO,XHI,YHI)
      J=J+2
 33   CONTINUE
C FACE 4 BLOCKS.
      X1=HBTLO(4)+HOVALL(4)
      X2=-50+HOVALL(4)
      J=19
      DO 34 IBLOCK=1,3
      Y1=HBNLIM(J)
      Y2=HBNLIM(J+1)
      CALL XYMUD(X1,Y1,Z1,XLO,YLO)
      CALL XYMUD(X2,Y2,Z2,XHI,YHI)
      CALL MUVIER(XLO,YLO,XHI,YHI)
      J=J+2
 34   CONTINUE
      X1=50+HOVALL(5)
      X2=HBTHI(4)+HOVALL(5)
      J=19
      DO 35 IBLOCK=1,3
      Y1=HBNLIM(J)
      Y2=HBNLIM(J+1)
      CALL XYMUD(X1,Y1,Z1,XLO,YLO)
      CALL XYMUD(X2,Y2,Z2,XHI,YHI)
      CALL MUVIER(XLO,YLO,XHI,YHI)
      J=J+2
 35   CONTINUE
C
C DRAW YOKE.
      XLO=HYKNMI(1)
      CALL MUVIER(XLO,XLO,-XLO,-XLO)
      XLO=HYKNMO(1)
      CALL MUVIER(XLO,XLO,-XLO,-XLO)
C
      GO TO 99
C
 99   CONTINUE
      RETURN
      END
C-----------------------------------------------------------------------
      SUBROUTINE MUVIER(XLO,YLO,XHI,YHI)
C DRAWS A RECTANGLE.
      CALL MOVEA(XLO,YLO)
      CALL DRAWA(XLO,YHI)
      CALL DRAWA(XHI,YHI)
      CALL DRAWA(XHI,YLO)
      CALL DRAWA(XLO,YLO)
      RETURN
      END