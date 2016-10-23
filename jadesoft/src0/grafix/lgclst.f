C   20/12/85 512202036  MEMBER NAME  LGCLST   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE LGCLST
C-----------------------------------------------------------------------
C
C
C    DISPLAY TABLE OF RESULTS FOR CLUSTER ANALYSIS BANK  "LGCL"
C        IPO:          START ADRESS OF BANK CONTENT
C        NBK:          BOS NUMBER OF BANK
C        INDEX:        VIEW INDEX ACCORDING TO DISPLAY PROGRAM
C            J.OLSSON,  18.07.79           LAST CHANGE 01.12.79
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
#include "cdata.for"
      LOGICAL DSPDTM
C
#include "cgraph.for"
#include "cgeo1.for"
C
      COMMON / CGRAP2 / BCMD,DSPDTM(30),ISTVW,JTVW
      COMMON/CWORK2/HWORK(40),JNDEX,NTR,LTR,ITR,IPO,ICNT,NBK,NCLST,NWPCL
     $,PMOM,PZ,PTRANS,RMS,NHTF,RAD,RAD1,THE,PHI,XXX,YYY,SSS,IPP,IHO,IVE
     $,DUMM,NTRRES,IW52
      COMMON /CJTRIG/ PI,TWOPI
C
      DATA INAME /'LGCL'/
C
C------------------  C O D E  ------------------------------------------
C
      IPP = IPO
      ICNT = 0
      IFL = 0
C
C LSTCMD=111,112: NEXT EVENT, WRIT EVENT   SPECIAL FOR AUTO DISPLAY
C
      IF(DSPDTL(14).AND.ACMD.NE.0..AND.LSTCMD.NE.111.AND.LSTCMD.NE.112)
     $ IFL = 1
C---
      XXX = XMIN
      YYY = YMIN+.76*(YMAX-YMIN)
      CALL XXXYYY(XXX,YYY,SSS,2)
C     IF(DSPDTL(14).AND.ACMD.NE.0..AND.LASTVW.EQ.13) GO TO 2277
      IF(IFL.NE.0.AND.LASTVW.EQ.13) GO TO 2277
C
C                            IF OPT 46 IS ON AND OPT 13 IS OFF
C                            FOR PUBLICATION PICTURES WITHOUT CAPTIONS,
C                            SUPPRESS THE RESULTS HEADER.
C
      IF( DSPDTM(16)  .AND.  .NOT. DSPDTL(13) ) GO TO 2277
C
      CALL CORE(HWORK,80)
      WRITE(10,220) INAME,NBK,NCLST
220   FORMAT('BANK ',A4,I2,' NR OF CLUSTERS',I3)
      CALL SYSSYM(XXX,YYY,SSS,HWORK,29,0.)
C
2277  IF( .NOT. DSPDTL(13) ) GO TO 21
      YYY = YYY - 3.*SSS
      IGMX = 0
200   ICNT = ICNT + 1
      IF(ICNT.GT.NCLST.OR.ICNT.GT.26) GO TO 21
      IPP = IPP + NWPCL
      IF(IDATA(IPP+8).EQ.0) IGMX = IGMX + 1
      CALL GMTEXT(IPP,NTRRES,ICNT,IGMX)
      GO TO 200
21    CONTINUE
      XXX = XMIN+.33*(XMAX-XMIN)
      YYY = YMIN+.01*(YMAX-YMIN)
      CALL XXXYYY(XXX,YYY,SSS,1)
      IF(IFL.NE.0.AND.LASTVW.EQ.13) GO TO 2278
C     IF(DSPDTL(14).AND.ACMD.NE.0..AND.LASTVW.EQ.13) GO TO 2278
C
C                            IF OPT 46 IS ON AND OPT 13 IS OFF
C                            FOR PUBLICATION PICTURES WITHOUT CAPTIONS,
C                            SUPPRESS THE RESULTS HEADER.
C
      IF( DSPDTM(16)  .AND.  .NOT. DSPDTL(13) ) RETURN
C
      CALL CORE(HWORK,80)
      IPLGCL=IDATA(IBLN('LGCL'))
      WRITE(10,865) ADATA(IPLGCL+11),ADATA(IPLGCL+16),IDATA(IPLGCL+15)
865   FORMAT(' TOTAL CLUSTER ENERGY ',F7.3,'  PHOTON ENERGY ',F7.3,' NR
     $OF PHOTONS ',I3)
      CALL SYSSYM(XXX,YYY,SSS,HWORK,70,0.)
2278  CONTINUE
      RETURN
      END
