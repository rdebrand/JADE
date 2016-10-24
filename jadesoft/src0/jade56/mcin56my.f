C   26/10/81 709102204  MEMBER NAME  MCIN56MY (S)           FORTRAN
      SUBROUTINE MCIN56
C
C    S.YAMADA  20-04-78  14:40
C     LAST MODIFICATION  20-11-78  21:55
C
C---- INITIALIZE THE SHOWER MONTE CARLO PROGRAM BY A.SATO.
C-
C-   MODIFED FROM LGMCIN, TO WORK WITH 56 SHOWER  MC  (SF5+SF6)
C-
C--          CHANGE 16.1.1986    J.OLSSON
C--          CHANGE 25.4.1987    J.OLSSON     CONS(2)=1.724
C--          CHANGE 26.4.1987    J.OLSSON     CONS(2)=1.684
C--          CHANGE 20.5.1987    J.OLSSON     CONS(1,2) UPDATED
C--          CHANGE 31.5.1987    J.OLSSON     CONS(1,2) UPDATED
C                                         FOR USE WITH ELENMX
C--   LAST   CHANGE 06.9.1987    J.OLSSON     CONS(1,2) UPDATED
C                                         FOR USE WITH ENELEL,ENELPO
C
      DIMENSION CP(10), A(10), Z(10), TIV(10)
C
      COMMON /SFCPA/SF,SFE
C
C  YAMADA COMMENT: SF AND SFE ARE ARBITRARY PARAMETERS AND CAN BE 1.2
C                  OR 1.05. CROSS SECTIOS ARE MODIFIED AND REMODIFIED
C                  BACK TO COMPENSATE THE EFFECT. THEY SERVE ONLY TO
C                  SPEED UP THE REFINEMENT...
C
      COMMON /M0PAR/ CUTM
C
C     COMMON /CLGGAN/ CONS,ECUTCR,ARED,IADCTH
      COMMON /CLGG56/ CONS(2),ECUTCR,ARED(2),IADCTH
C
C STILL OPEN QUESTION: IS ARED MATERIAL DEPENDENT? ECUTCR IS NOT(YAMADA)
C
      CUTM = 0.5
      SF = 1.2
      SFE = 1.2
C
C---- MONTE CARLO CONDITIONS
C
      ECUTMV = 1.2
      CALL SETECT(ECUTMV)
C
C---- CORRECTION FACTOR FOR ECUT
C
      ECUTCR = 1./(1.05415-0.08488*ECUTMV)
C
C---- NORMALIZATION CONS
CC    CONS = 0.1687  ( OLD CONS FOR 'LGAL'/1 )
C          NEW CONSTANT TO SIMULATE 'ALGN'/1
C
C  THIS CONSTANTS ARE USED IN LGCRGN, CALLED BY LSCCTC  (ENTRY LSCCTL)
C  THEY ARE DIFFERENT FOR SF5 AND SF6  (1,2)
C
C     CONS(1) = 0.86189
C     CONS(2) = 1.684
C  UPDATED ACC. TO   PLUS 7 %, PLUS 4 %
C     CONS(1) = 0.9222
C     CONS(2) = 1.7514
C  UPDATED ACC. TO   PLUS 13 %, PLUS 7 %, FOR USE WITH ENELMX
C  AVERAGE ENERGY LOSS INSTEAD OF RESTRICTED ENERGY LOSS (ENELS)
C     CONS(1) = 1.0421
C     CONS(2) = 1.8740
C  UPDATED ACC. TO   MINUS 3 %, PLUS 5 %, FOR USE WITH ENELEL,ENELPO
C  AVERAGE ENERGY LOSS INSTEAD OF RESTRICTED ENERGY LOSS (ENELS)
C  DIFFERENCE IN ELECTRONS/POSITRONS CONSIDERED
C     CONS(1) = 1.0108
C     CONS(2) = 1.9677
C  UPDATED ACC. TO   PLUS 2 %, PLUS 2 %, FOR USE WITH ENELEL,ENELPO
C  AVERAGE ENERGY LOSS INSTEAD OF RESTRICTED ENERGY LOSS (ENELS)
C  DIFFERENCE IN ELECTRONS/POSITRONS CONSIDERED   10.9.1987
      CONS(1) = 1.0310
      CONS(2) = 2.0071
C
      ARED(1) = 0.25
      ARED(2) = 0.25
C
      IADCTH = 25
C
C IADCTH IS READ OUT THRESHOLD, TIME DEPENDENT
C   IT IS NOT USED ANYWHERE, AS FAR AS SEEN (NOT IN LGCR56)
C
      WRITE(6,600) CONS(1),ARED(1),IADCTH
  600 FORMAT(' LG SF5 CALIB CONS=',F8.5,'  ARED=',F6.2,'  IADCTH=',I6,/)
      WRITE(6,601) CONS(2),ARED(2),IADCTH
  601 FORMAT(' LG SF6 CALIB CONS=',F8.5,'  ARED=',F6.2,'  IADCTH=',I6,/)
C
      CALL INITJA
C
      RETURN
      END