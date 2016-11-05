C   18/08/79 209010957  MEMBER NAME  RETTEN   (JADEGS)      FORTRAN
      SUBROUTINE RETTEN(NOPT)
      IMPLICIT INTEGER*2 (H)
C---
C---     SAVES CWORK CONTENTS ONTO DISK FILE OR RETRIEVES THEM AGAIN.
C---     LAST CHANGE              30.8.82    J.OLSSON
C---
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
      REAL*8 DDN
      COMMON/CWORK/IWORK(8467)
      COMMON/CSVCW1/NDDSVE
      DIMENSION IHEAD(108)
      DIMENSION HHEAD(216)
      EQUIVALENCE(IHEAD(1),HHEAD(1))
      DIMENSION IDATAL(11),HVOLSR(4)
      DATA ICONT /'CONT'/
      DATA HBLANK/'  '/
      DATA IBNM/'CWRK'/
      DATA LENG/8575/
*** PMF 02/12/99
      INTEGER LI
      CHARACTER CDATAL*44
      EQUIVALENCE (CDATAL,IDATAL(1))
*** PMF(end)
C---
      IF(NDDSVE.NE.0) GO TO 99
C---
C---   ALLOCATE DATA SET
C---
1     CALL TRMOUT(80,'PLEASE ENTER FULL NAME OF CATALOGUED DATA SET FOR
     $OUTPUT EVENTS:^')
      CALL TRMIN(44,IDATAL)
C---
C---     TEST FOR THE STRING CONTINUE.
C---
      IF(IDATAL(1).NE.ICONT) GO TO 9
      NDDSVE = 0
      GO TO 100
C---
C---     ALLOCATE FORTRAN REFERENCE NUMBER TO OUTPUT DATA SET.
C---
9     CONTINUE
      DO 8 I=1,11
    8 IDATSV(I)=IDATAL(I)
      DO 33 I=1,4
   33 HVOLSR(I)=HBLANK
      NDDSVE=0
*** PMF 02/12/99: add suffix '.CWORK@' to the file name,
*     if common /CWORK/ shall be saved on disk (NOPT.EQ.1).
*     '@' tells GETPDD that the specified output file does
*     not need to exist before allocation.
      IF( NOPT.EQ.1 ) THEN
         LI= MIN(INDEX(CDATAL,' '),38)
         CDATAL=CDATAL(1:LI-1)//'.CWORK@'
      ENDIF
*** PMF(end)
      CALL GETPDD(IDATAL,HVOLSR,DDN,NDDSVE,HERR)
      IF(HERR.EQ.0) GO TO 99
C---
C---     ERROR HAS OCCURRED ON ALLOCATION.
C---
      CALL TRMOUT(80,'THE NAME IS INCORRECT OR HMS/MSS IS JAMMED.^')
44    CALL TRMOUT(80,'PLEASE TRY AGAIN OR CONTINUE SESSION BY "CONTINUE"
     $.^')
      GO TO 1
C---
C---     SUCCESSFULLY ALLOCATED DATA SET.
C---
99    IPHEAD=IDATA(IBLN('HEAD'))
      IHHEAD=IPHEAD*2
      REWIND NDDSVE
      IF(NOPT.EQ.1) GO TO 111
      IF(NOPT.EQ.2) GO TO 222
      RETURN
111   CALL MVCL(IHEAD(1),0,IDATA(IPHEAD-3),0,412)
      IHEAD(104)=8575
      IHEAD(105)=IBNM
      IHEAD(106)=0
      IHEAD(107)=0
      IHEAD(108)=8467
      WRITE(NDDSVE) LENG,IHEAD,IWORK
      CALL TRMOUT(80,'HEADER BANK AND CWORK WRITTEN.^')
      END FILE NDDSVE
      CALL TRMOUT(80,'END OF FILE PUT ONTO SAFETY UNIT.^')
      RETURN
222   ISF=0
 4    READ(NDDSVE,ERR=1000,END=2000) LN,IHEAD
      ISF=ISF+1
      IF(IHEAD(105).EQ.IBNM) GO TO 3
      WRITE(JUSCRN,101) IHEAD(105)
  101 FORMAT(' ILLEGAL RECORD TYPE ON RECOVERY FILE. 2ND BANK NAME ',A4)
 3    WRITE(JUSCRN,102) ISF,HHEAD(18),HHEAD(19)
  102 FORMAT(' SAFETY RECORD',I4,' HOLDS CWORK FOR RUN,',I6,' EVENT',I6)
      I1=IHHEAD+10
      I2=IHHEAD+11
      IF((HHEAD(18).NE.HDATA(I1)).OR.(HHEAD(19).NE.HDATA(I2))) GO TO 4
 5    REWIND NDDSVE
 6    READ(NDDSVE,ERR=1000,END=2000) LN,IHEAD,IWORK
      ISF=ISF-1
      IF(ISF.GT.0) GO TO 6
      CALL TRMOUT(80,'CWORK RESTORED.^')
      RETURN
1000  CALL TRMOUT(80,'READ ERROR ON BACKUP FILE. RECOVERY FAILED.^')
      RETURN
2000  CALL TRMOUT(80,
     1'MATCHING EVENT NUMBER NOT FOUND RECOVERY FAILED.^')
100   CONTINUE
      RETURN
      END
