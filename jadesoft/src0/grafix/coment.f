C   22/01/79 C9032101   MEMBER NAME  COMENT   (JADEGS)      FORTRAN
      SUBROUTINE COMENT
C---
C---     ENABLES THE GRAPHICS USER TO PUT A COMMENT ANY DELIBERATE
C---     PLACE ONTO HIS PICTURE;  THE COMMENT WILL APPEAR ON THE
C---     HARDCOPY.                           J.OLSSON 18.12.78
C---
      IMPLICIT INTEGER*2 (H)
      COMMON /CWORK1/ HMW(80),XST,YST
C
      CALL TRMOUT(80,'PLEASE ENTER START POSITION OF YOUR COMMENT^')
      CALL VCURSR(HMW(1),XST,YST)
      CALL MOVEA(XST,YST)
      DO 1  I = 1,3
1     CALL TRMOUT(80,' ^')
      CALL TRMOUT(80,'PLEASE ENTER YOUR COMMENT^')
      CALL TRMIN(80,HMW)
      CALL CHRSIZ(4)
      CALL EOUTST(80,HMW)
      RETURN
      END