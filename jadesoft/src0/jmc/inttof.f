C   02/03/79 C9051501   MEMBER NAME  INTTOF   (S)           FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       SUBROUTINE INTTOF
C    BANK DESCRIPTOR SET TO ZERO BY E.ELSEN
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       INTEGER *2 IBSK
       COMMON/CTOF/IDATA(94)
       COMMON/CTWRK/IADC(84),ITDC(84)
C
       DO 100 I=1,84
       IADC(I)= 0
 100   ITDC(I)= 2048
       DO 200 I=1,94
 200   IDATA(I)= 0
C
       RETURN
       END
