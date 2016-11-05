C   25/07/79 C9073101   MEMBER NAME  LGBFIL   (SOURCE)      FORTRAN
      SUBROUTINE LGBFIL(II,J1,J2,*)
C     CODED BY Y.WATANABE ON 29/7/79, 02:00
      IMPLICIT INTEGER *2 (H)
C     USED IN LGCDIR PART OF ANALYSIS
C     INCREASE UP TO 100 TRACKS ON 20/9/79
      COMMON /CWORK/ NCHCLS,NPOINT,MAPCCL(101),HCLADR(1600),
     $               NCHCL2,HCLIST(4,100),  NCLST2,HCLLSO(4,80)
      DATA NPMAX/1600/
      IX=II
      IF(IX.LT.0) IX=IX+84
      IF(IX.LT.0) RETURN
      IX=MOD(IX,84)
      IX=IX*32
      JX=J1-1
10    JX=JX+1
      IF(JX.GT.J2) GO TO 20
      NPOINT=NPOINT+1
      IF(NPOINT.GE.NPMAX) RETURN1
      HCLADR(NPOINT)=JX+IX
C     WRITE(6,600) II,IX,JX,NPOINT
C600  FORMAT(' LGBFIL;',10I10)
      GO TO 10
20    RETURN
      END