C   10/01/79 C9011001   MEMBER NAME  READSD   (JADELGS)     FORTRAN
      SUBROUTINE READSD(NUNIT,*)
C
C     S.YAMADA    10-01-79  10:20
C
C---- SIMPLE PROGRAM TO READ SEQUENTIAL DATA INTO /CDATA/.
C     IT IS USED TO AVOID THE APPEARENCE OF /CDATA/ IN THE @TESTLG.
C
      COMMON /CDATA/ LNGID,ID(4000)
C
      READ(NUNIT,END=100) LNGID,(ID(L),L=1,LNGID)
      RETURN
C
  100 RETURN 1
      END