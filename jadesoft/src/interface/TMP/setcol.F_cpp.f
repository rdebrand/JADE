******************************************************************
*
*     HIGZ colour settings for graphics action with PLOT10.
*
*     12/11/1999  P.A. Movilla Fernandez
*
      SUBROUTINE SETCOL(C)
      IMPLICIT NONE
      CHARACTER C*(*)
      INTEGER ICI,ITCI,ICI2,ITCI2,I
      REAL WI
*
******************************************************************
*
*     PLOT10/HIGZ TERMINAL PARAMETERS
*
*     This file is included when compiling plot10.F
*
*     (XTMIN,YTMIN),(XTMAX,YTMAX) : Edges of the screen
*     (XMIN0,YMIN0),(XMAX0,YMAX0) : Edges of user window in screen coordinates
*     (XMIN,YMIN),(XMAX,YMAX)     : Edges of user window in virtual coordinates
*     XPOS0,YPOS0                 : Beam position in screen coordinates 
*     XPOS,YPOS                   : Beam position in virtual coordinates 
*
*     TTEST .EQ. .TRUE. : SUBROUTINE TWINDO was executed
*     DTEST .EQ. .TRUE. : SUBROUTINE DWINDO was executed
*     INIT .EQ. .TRUE.  : SUBROUTINE INITT was executed
*
*     NTS  : HIGZ normalization transformation index of screen window
*     NTV  : HIGZ normalization transformation index of virtual window
*
      LOGICAL TTEST,DTEST,INIT,TRACE,LROTAT,LSCALE,LTSO
      INTEGER NTV,NTS,KWTYPE,KLIN,KCHR,TLINE,IFNT,IPRC,ISYNC,ICHRSZ
      REAL XTMIN,XTMAX,YTMIN,YTMAX,XTMG,YTMG
     +     ,XMIN0,XMAX0,YMIN0,YMAX0,XPOS0,YPOS0
     +     ,XMIN,XMAX,YMIN,YMAX,XPOS,YPOS
     +     ,ANGLE,SCALE,XSIZE,YSIZE
     +     ,XCHAR,YCHAR
      CHARACTER FNAME*256
      COMMON /PLOT10/ TTEST,DTEST,INIT,TRACE,NTV,NTS,KWTYPE,LTSO
     +     ,XTMIN,XTMAX,YTMIN,YTMAX,XTMG,YTMG
     +     ,XMIN0,XMAX0,YMIN0,YMAX0,XPOS0,YPOS0
     +     ,XMIN,XMAX,YMIN,YMAX,XPOS,YPOS
     +     ,LROTAT,ANGLE,LSCALE,SCALE
     +     ,XCHAR,YCHAR,KLIN,KCHR,TLINE,ICHRSZ
     +     ,XSIZE,YSIZE,IFNT,IPRC,ISYNC
      COMMON /PLT10C/ FNAME
*******************************************************************
*******************************************************************
*
*     HIGZ colour parameters for graphics action in JADEZ
*
*     This file is included when compiling SETCOL
*
      LOGICAL LCOL,LINIT
      INTEGER NCOL,IFORE,IBACK,IFORE2,IBACK2
      REAL WID
      PARAMETER (NCOL=10)
      REAL RED,GREEN,BLUE
      CHARACTER TCOL*4
      COMMON /PLTCOL/ LCOL,LINIT,IFORE,IBACK,IFORE2,IBACK2
     _     ,RED(NCOL),GREEN(NCOL),BLUE(NCOL),TCOL(NCOL),WID(NCOL)

      INTEGER PLTFLG
      COMMON /CPLTC2/ PLTFLG
*******************************************************************      

Code:
      IF (.NOT.LCOL ) RETURN
      CALL CLTOU(C)
      IF( .NOT.LINIT .AND. C.NE.'*INI' ) RETURN
      IF( C.EQ.'*INI' ) THEN
         LINIT=.TRUE.
         DO I=1,NCOL
            CALL ISCR(1,10+I,RED(I),GREEN(I),BLUE(I))
            CALL IXSETCO(10+I,RED(I),GREEN(I),BLUE(I))
         ENDDO
         CALL IXSETCO(100,1.,1.,1.)
         CALL IXSETCO(101,0.,0.,0.)
C default settings for PostScript output
C                            foreground
         CALL ISELNT(NTS)
         CALL ISLWSC(1.)
         CALL ISPLCI(IFORE)
         CALL ISPMCI(IFORE)
         CALL ISTXCI(IFORE)
C                            background
         IF( IBACK.EQ.1 ) THEN
            CALL ISFAIS(1)
            CALL ISFACI(IBACK)
            CALL IGBOX(XTMIN,XTMAX,YTMIN,YTMAX)
         ENDIF
C additional settings for X11
         IF( IBACK2.EQ.1 .OR. IBACK.EQ.1  ) THEN
            CALL IXSETTC(IFORE2)
            CALL IXSETLC(IFORE2)
            CALL IXSETMC(IFORE2)
            CALL IXSETFC(IBACK2)
            CALL IXBOX(XTMIN,XTMAX,YTMIN,YTMAX,1)
         ENDIF
C
         CALL IUWK(0,1)
         RETURN
      ENDIF
C Set colour
      DO I=1,NCOL
         IF( C.EQ.TCOL(I) ) THEN
            IF( C.NE.'TEXT' ) THEN
               WI=WID(I)
               ICI=10+I
               ITCI=10+I
               ICI2=ICI
               ITCI2=ITCI
            ELSE
               WI=1.
               ICI=10+I
               ITCI=10+I
               ICI2=ICI
               ITCI2=ITCI
               IF( IBACK.EQ.0 ) THEN
                  ICI=ICI+1
                  ITCI=ITCI+1
               ENDIF
               IF( IBACK2.EQ.0 ) THEN
                  ICI2=ICI2+1
                  ITCI2=ITCI2+1
               ENDIF
            ENDIF
            GOTO 10
         ENDIF
      ENDDO
      WI=1.
      ITCI=IFORE
      ICI=IFORE
      ITCI2=IFORE2
      ICI2=IFORE2
 10   CONTINUE
C Force special attributes required exceptionally in certain contexts
      IF( PLTFLG.EQ. 1 ) THEN
         IF( C.EQ.'HITS' ) WI = 1.
      ENDIF

C Set attributes for graphics in PS file
      CALL ISLWSC(WI)
      CALL ISPLCI(ICI)
      CALL ISPMCI(ICI)
      CALL ISTXCI(ITCI)

C Set attributes for graphics apearing on the screen
      CALL IXSETLC(ICI2)
      CALL IXSETMC(ICI2)
      CALL IXSETTC(ITCI2)
      CALL IXSETLN(1)
C
      RETURN
      END

C /PLTCOL/
      BLOCKDATA CPLTCOL
*******************************************************************
*
*     HIGZ colour parameters for graphics action in JADEZ
*
*     This file is included when compiling SETCOL
*
      LOGICAL LCOL,LINIT
      INTEGER NCOL,IFORE,IBACK,IFORE2,IBACK2
      REAL WID
      PARAMETER (NCOL=10)
      REAL RED,GREEN,BLUE
      CHARACTER TCOL*4
      COMMON /PLTCOL/ LCOL,LINIT,IFORE,IBACK,IFORE2,IBACK2
     _     ,RED(NCOL),GREEN(NCOL),BLUE(NCOL),TCOL(NCOL),WID(NCOL)

      INTEGER PLTFLG
      COMMON /CPLTC2/ PLTFLG
*******************************************************************      

      DATA LCOL/.TRUE./
      DATA LINIT/.FALSE./
      DATA IFORE /1/, IBACK /0/   ! <--- for PostScript
      DATA IFORE2/0/, IBACK2/1/   ! <--- for screen
      DATA TCOL/'JADE','TRCK','ECAL','TOFH','TRUE','HITS'
     +        ,'VTX ','TEXT','TXT2','TITL'/
      DATA RED  /  .4,  .0,  1. ,   0.,  .0  ,   1.,   
     +            8.,   1.,   0.,   0./
      DATA GREEN/  .4,   .7,  .6 ,  .9 ,  1.  ,   .0,
     +            1.,   1.,   0.,   1./
      DATA BLUE /  .4,   1.,  .0 ,  .0 ,  .5  ,   .0,
     +            0.,   .0,   .5,   0./
      DATA WID  /   1.,   2.,  4.,   2.,   4. ,   4.,
     +             6.,   1.,    1.,  1./
      DATA PLTFLG/0/
      END
C JADE .64 .4 .0
      SUBROUTINE SETCOL0(C)
      IMPLICIT NONE
      CHARACTER*4 C
      RETURN
      END
