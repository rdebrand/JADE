C   10/04/84            MEMBER NAME  NEWCAP   (JADEGS)      FORTRAN
      SUBROUTINE NEWCAP(ADX,ADY,LLL,ITXT)
      IMPLICIT INTEGER*2 (H)
C-----------------------------------------------------------------------
C                            MACRO CGEO2 .... JADE TAGGING GEOMETRY
C-----------------------------------------------------------------------
C
      COMMON / CGEO2 / FENDC,XYHOL1,XYHOL2,BLDPFW,ZMINBL,ZPLUBL,
     +                 XSC(2),YSC(2),RSC(2),ZMISC(2),ZPLSC(2),DZSC,
     +                 CHX(3,4),CHY(3,4),CHZ(3,4),WLEN,PITCH,WZDIS
C
C--------------------------- END OF MACRO CGEO2 ------------------------
C
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
C DRAW FRONT VIEW OF TAGGING SYSTEM IN 1981-82 VERSION
C
      DO 1 I=1,32
      NO=I-1
      CALL XYTAG(NO,X,Y,slope)  ! PMF 01/12/99: dummy argument slope added
      X0=ADX-X-0.5*FENDC
      X1=X0+FENDC
      Y0=ADY+Y-0.5*FENDC
      Y1=Y0+FENDC
      CALL RECTAN(X0,Y0,X1,Y1,LLL)
    1 CONTINUE
      IF(ITXT.EQ.0) RETURN
C     WRITE TEXT
C  WRITE +- Z  BELOW CAPS
      SH3 = 0.6*FENDC
      Y1 = ADY - 5.*FENDC
      I = 1
      IF(ADX.GT.0.) I = 2
      LABT = 101 + (I-1)*2
      X1 = ADX-0.5*FENDC
      CALL RUTEXT(LABT,X1,Y1,SH3)
C  DRAW BEAM CROSS INSIDE CAP
      CALL MOVEA(ADX,ADY-20.)
      CALL DRAWA(ADX,ADY+20.)
      CALL MOVEA(ADX+20.,ADY)
      CALL DRAWA(ADX-30.,ADY)
      CALL DRAWA(ADX-30.,ADY+15.)
      CALL DRAWA(ADX-45.,ADY)
      CALL DRAWA(ADX-30.,ADY-15.)
      CALL DRAWA(ADX-30.,ADY)
      RETURN
      END
