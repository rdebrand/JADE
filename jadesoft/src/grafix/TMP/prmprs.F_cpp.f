C   10/02/86 604291407  MEMBER NAME  PRMPRSR  (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE PRMPRS( IPMPRS, XS, YS , DEL, SIZE ) 
C-----------------------------------------------------------------------
C
C   AUTHOR:   J. HAGEMANN 29/04/86 :  PRINT BOS BANK MPRS
C
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
      LOGICAL TBIT
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
      COMMON / CWORK1 / HWORK(70)
      COMMON / CWORK  / HDUM(8000),
     +                  HADC(2,42),HTDC(2,42),HTDC1(2,42),HADCF(2,16),
     +                  HTDCF(2,16),HTSPAR(16)
C
      DIMENSION HSY(13,16)
C
      DATA HSY/
     $'UN','EX','PE','CT','ED',' I','NT','ER','RU','PT',' N','-3','  ',
     $'UN','EX','PE','CT','ED',' I','NT','ER','RU','PT',' N','-2','  ',
     $'NO','N ','IN','CR','EA','SI','NG',' W','IR','E-','NU','MB','ER',
     $'IL','LE','GA','L ','HI','T ','CO','UN','TE','R ','  ','  ','  ',
     $'NE','GA','TI','VE',' D','AT','A ','FO','UN','D ','  ','  ','  ',
     $'JE','TC',' B','AN','K ','LO','NG','ER',' T','HA','N ','40','00',
     $'WI','RE',' N','UM','BE','R ','GR','EA','TE','R ','15','36','  ',
     $'NO',' H','IT','S ','IN',' R','IN','G2','  ','  ','  ','  ','  ',
     $'LA','ST',' C','EL','L ','IN',' R','IN','G ','IN','CO','MP','L.',
     $'  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ',
     $'  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ',
     $'  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ',
     $'T2','  ','RE','JE','CT','  ','  ','  ','  ','  ','  ','  ','  ',
     $'Z-','VE','RT','EX',' R','EJ','EC','T ','  ','  ','  ','  ','  ',
     $'  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ','  ',
     $'AC','TU','AL','LY',' R','EJ','EC','TE','D ','BY',' N','10','  '/
C
*** PMF 17/11/99: add variables needed for emulation of DESYLIB routine 'CORE'  
      CHARACTER cHWORK*140
      EQUIVALENCE (cHWORK,HWORK(1))
*** PMF(end)
C
C------------------  C O D E  ------------------------------------------
C
      LIM2 = IPMPRS
      LH2  = LIM2*2
      YS   = YS - DEL
      CALL CORE(HWORK,46)
      WRITE(cHWORK,1) HDATA(LH2+10) ! PMF 17/11/99: JUSCRN changed to cHWORK
    1 FORMAT(' MIPROC EVENT COUNT (=TRIGGER NUMBER) ',I8)
      CALL SYSSYM(XS,YS,SIZE,HWORK,46,0.)
C
      YS = YS - DEL
      CALL CORE(HWORK,59)
      WRITE(cHWORK,2) HDATA(LH2+4),(HDATA(LH2+K),K=7,9)! PMF 17/11/99: JUSCRN changed to cHWORK
    2 FORMAT(' MIPROC ZVTX',I6,' ZVX AND BACKG. PEAKS',2I6,' FLAG ',I2)
      CALL SYSSYM(XS,YS,SIZE,HWORK,59,0.)
C
      YS = YS - DEL
      CALL CORE(HWORK,27)
      WRITE(cHWORK,3) HDATA(LH2+5)! PMF 17/11/99: JUSCRN changed to cHWORK
    3 FORMAT(' MIPROC FOUND ',I3,' R3 TRACKS')
      CALL SYSSYM(XS,YS,SIZE,HWORK,27,0.)
C
      YS = YS - DEL
      CALL CORE(HWORK,37)
      WRITE(cHWORK,4) HDATA(LH2+3)! PMF 17/11/99: JUSCRN changed to cHWORK
    4 FORMAT(' MIPROC REJECTION AND ERROR FLAG ',Z4)
      CALL SYSSYM(XS,YS,SIZE,HWORK,37,0.)
C
      MIPROC = HDATA(LH2+3)
      MIPROC = ISHFTL(MIPROC,1)
      DO 7 IBT = 1,16
         MIPROC = ISHFTR(MIPROC,1)
         IF( .NOT. TBIT(MIPROC,31) ) GO TO 7
C BIT IBT IS ON, WRITE CORRESPONDING INFORMATION
         DO 5  I = 1,13
            HDUM(I) = HSY(I,IBT)
    5    CONTINUE
         YS = YS - DEL
         CALL CORE(HWORK,41)
         WRITE(cHWORK,6) (HDUM(I),I=1,13)! PMF 17/11/99: JUSCRN changed to cHWORK
    6    FORMAT('  ACTION/ERROR ',13A2)
         CALL SYSSYM(XS,YS,SIZE,HWORK,41,0.)
    7 CONTINUE
      RETURN
      END
