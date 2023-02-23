C   07/12/81 705272126  MEMBER NAME  INITAL   (S)           FORTRAN
      SUBROUTINE INITAL(INDEL)
C
C  SPECIAL VERSION FOR TEST WITH JBENELS
C
C     S.YAMADA   07-12-81    11:55
C
C COPIED FROM F22YAM.LG.S(INITOP) ON 16.1.1986
C
C   INITIALIZE SHOWER PROGRAM FOR SEVERAL MATERIALS IN JADE
C          AL-ABS, SCINTILLATOR AND Z-CH., SF5 AND SF6 LEAD GLASS
C
C
      COMMON /CMATTR/ IMATTR,IMTLIS(10),XCM(10)
C
      DIMENSION CPAL(1), AAL(1), ZAL(1)
C     DIMENSION CPSC(3), ASC(3), ZSC(3)
      DIMENSION CPLG5(5), ALG5(5), ZLG5(5)
      DIMENSION CPLG6(6), ALG6(6), ZLG6(6)
C---- PARAMETER OF AL
      DATA NAMEAL/4HAL  /, RHOAL/2.70/, NCMPAL/1/
      DATA ZAL/13.0/, AAL/26.98/, CPAL/100.0/
C
C---- PARAMETER OF SCINT   (NOT USED)
C
C     DATA NAMESC/'SCIN'/, RHOSC/1.032/, NCMPSC/2/
C     DATA ZSC/   6.0,  1.0/,
C    1     ASC/ 12.01,  1.01/,
C    2     CPSC/92.25,  7.75/
C
C---- PARAMETER OF SF5
C
      DATA NAMLG5/4HSF5 /, RHOLG5/4.08/, NCPLG5/5/
      DATA ZLG5/  82.0,  19.0,  14.0,  11.0,  8.0/,
     1     ALG5/207.19, 39.10, 28.09, 22.99, 16.00/,
     2     CPLG5/53.75,  3.49, 18.95,  1.56, 22.25/
C
C---- PARAMETER OF SF6
C
      DATA NAMLG6/4HSF6 /, RHOLG6/5.201/, NCPLG6/6/
      DATA ZLG6/82.0,   19.0,  14.0,  11.0,  8.0,   33.0/
      DATA ALG6/207.19, 39.10, 28.09, 22.99, 16.00, 74.92/
      DATA CPLG6/65.948, 0.822, 12.70, 0.371, 19.932, 0.227/
C
C---- MATERIAL INITILIZATION
        DO 4000 I=1,10
 4000   IMTLIS(I) = 0
C
C     AL-COIL
C
      IF(INDEL.NE.1) GO TO 4110
      IMATTR = 1
      CALL INTSHW(CPAL,NCMPAL,AAL,ZAL,RHOAL,X0AL)
      WRITE(6,6000) NAMEAL
 6000 FORMAT('0 SHOWER PARAMETERS ARE SET FOR ',A4,//)
      GO TO 4130
C
C     SCINTILLATOR
C
C     IMATTR = 2
C     CALL INTSHW(CPSC,NCMPSC,ASC,ZSC,RHOSC,X0SC)
C     WRITE(6,6000) NAMESC
C
C     SF5 LG-BLOCKS
C
4110  IF(INDEL.NE.2) GO TO 4120
      IMATTR = 2
      CALL INTSHW(CPLG5,NCPLG5,ALG5,ZLG5,RHOLG5,X0LG5)
      WRITE(6,6000) NAMLG5
      GO TO 4130
C
C     SF6 LG-BLOCKS
C
4120  IF(INDEL.NE.2) GO TO 4130
      IMATTR = 3
      CALL INTSHW(CPLG6,NCPLG6,ALG6,ZLG6,RHOLG6,X0LG6)
      WRITE(6,6000) NAMLG6
C
4130  CONTINUE
      RETURN
      END
