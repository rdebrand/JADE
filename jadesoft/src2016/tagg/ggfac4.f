C   14/08/80 010081658  MEMBER NAME  GGFAC4   (S)           FORTRAN
      SUBROUTINE GGFAC4
C---  APPLY CORRECTION FACTORS FOR LEAD-GLASS ADCS TO THIRD SET OF
C---  CALIBRATION CONSTANTS OF LEAD-GLASS
C---  RUN 2751 TO RUN 4864
C
C     H.WRIEDT    13.09.79     19:00
C     LAST MODIFICATION    14.08.80   14:35
C
      COMMON /CFACT3/ FACT3(191)
      COMMON /CALICO/ FAKTOR(191)
C
      REAL*4 T(191)/
     10.,0.,8.,0.,25.,18.5,5.,13.,18.5,6.,0.,0.,18.5,16.5,16.,
     214.5,18.,15.5,0.,0.,17.,19.,16.5,17.,11.,15.5,11.5,15.,13.,0.,
     30.,11.,14.,13.5,15.5,15.,16.,0.,0.,18.5,18.,12.5,12.,14.,15.,
     40.,0.,0.,0.,13.,12.,13.,13.,14.,0.,0.,0.,12.5,15.,11.,
     514.,17.,17.,0.,0.,15.,9.,11.,17.,17.5,15.5,17.,17.,15.,0.,
     60.,15.5,16.,12.,17.,15.5,15.,15.5,0.,0.,15.,20.,17.,17.,12.,
     70.,0.,0.,0.,0.,0.,0.,0.,0.,0.,14.,13.5,12.,20.5,16.5,
     80.,0.,15.,15.,15.,18.,11.,13.,14.,0.,0.,8.,20.,17.,16.5,
     90.,15.5,14.,18.,19.,0.,0.,18.5,18.,16.5,14.5,15.,15.,0.,0.,
     A17.5,16.,17.,14.,16.,0.,0.,0.,0.,0.,16.,16.5,12.,12.,22.,
     B22.,0.,0.,9.,14.,10.,4.,16.,22.,0.,0.,0.,0.,12.,14.5,
     C16.,15.,9.,6.,15.,0.,0.,17.,14.,8.,14.,14.,16.,15.,0.,
     D0.,15.,9.5,10.,16.5,12.,0.,0.,0.,0.,0./
C
        DO 1 I = 1,191
        RNEW=T(I)
        IF(RNEW.LT.1.0) RNEW=15.0
        FACT3(I)=FACT3(I)*15.0/RNEW
    1   FAKTOR(I) = FACT3(I)
      WRITE(6,600)
  600 FORMAT(/' *** CORRECTIONS TO THIRD SET OF LEAD-GLASS',
     *        ' CALIBRATION CONSTANTS APPLIED ***')
      RETURN
      END
      BLOCK DATA
C
      COMMON /CFACT3/ FACT3
C     THIS DATA APPLICABLE FROM RUN 2751 TO RUN 4864
C     THE GAIN ASSUMES ENERGY(MEV)=CHANNEL*5.0
      REAL*4 FACT3(191)/191*1.65/
      END
