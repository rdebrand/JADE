C   14/03/84            MEMBER NAME  TRACKS   (S)           FORTRAN
C   27/06/79 C9062701   MEMBER NAME  TRACKS   (S)           FORTRAN
      SUBROUTINE TRACKS
C---  COMBINE AVAILABLE INFORMATION OF LUMONITORS, LEAD-GLASS, AND
C---  DRIFT-CHAMBERS IN ORDER TO CREATE TRACK INFORMATION TO BE STORED
C---  IN OUTPUT BANK TAGG/4
C***  UP TO NOW NO DRIFT-CHAMBER INFORMATION AVAILABLE, THEREFORE THE
C***  FOLLOWING IS DONE:
C***   A) EACH 'TRACK' IS DEFINED BY A LEAD-GLASS CLUSTER; THE NUMBERS
C***      OF CLUSTERS AND TRACKS ARE IDENTICAL
C***   B) EACH 'TRACK' POINTS TO THE INTERSECTION REGION
C***   C) EACH 'TRACK' HAS EXACTLY ONE ASSOCIATED LEAD-GLASS CLUSTER
C***   D) THE COORDINATES OF THE 'TRACKS' IN THE DRIFT-CHAMBER PLANES
C***      ARE LEFT EMPTY
C
C     H.WRIEDT         27.6.79       02:15
C     LAST MODIFICATION      27.6.79       02:15
C
      IMPLICIT INTEGER*2 (H)
C
      COMMON /CWORK/ IWORK1(501),HITRAK(3),HCLST,HCLBEC(2),IWORK2(97),
     *               CLSPRP(13,51),IWORK3(25),HLULAT,HWORK1,IWORK4(10),
     *               TRACK(10,51)
      DIMENSION HCLSPR(26,51), HTRACK(20,51)
      EQUIVALENCE (HCLSPR(1,1),CLSPRP(1,1)), (HTRACK(1,1),TRACK(1,1))
C
      NTRACK = HCLST
      IF (NTRACK.LE.0) RETURN
        DO 10 I = 1,NTRACK
        HTRACK(1,I) = I
        HTRACK(2,I) = 1
        HTRACK(3,I) = HCLSPR(1,I)
        HCLSPR(3,I) = 1
        HCLSPR(4,I) = HTRACK(1,I)
        CALL LUMONS(ICOMB,I)
        HTRACK(4,I) = ICOMB
        ILATCH = HLULAT
        ITEST = JBYTET(ILATCH,ICOMB,1,16)
        HTRACK(5,I) = ITEST
        IF (HCLSPR(2,I).EQ.-1) HITRAK(2) = HITRAK(2) + 1
   10   IF (HCLSPR(2,I).EQ.+1) HITRAK(3) = HITRAK(3) + 1
      HITRAK(1) = NTRACK
      RETURN
      END