C   09/06/78 C8112701   MEMBER NAME  MESSAG   (JADELGS)     FORTRAN
      SUBROUTINE MESSAG(INDEX)
C
C     L.H.O'NEIL     XX-XX-XX   00:00
C     MODIFIED BY S.YAMADA  TO INCLUDE LEAD GLASS PART.  24-11-78
C
      COMMON /MESSGB/ MSGVAL(5)
      DIMENSION AMSGVL(5)
      EQUIVALENCE (MSGVAL(1),AMSGVL(1))
      DIMENSION KOUNT(20),LIMIT(20)
      DATA LIMIT/20*100/
      DATA KOUNT/20*0/
C
      IF((INDEX.LT.1).OR.(INDEX.GT.19)) GO TO 1001
      KOUNT(INDEX)=KOUNT(INDEX)+1
      IF(KOUNT(INDEX).GT.LIMIT(INDEX)) RETURN
C
      IF(INDEX.GT.10) GO TO 200
C
C---- SUPERVISER ERROR MSG.
      GO TO (1,2,3),INDEX
C
 1001 CONTINUE
      KOUNT(20)=KOUNT(20)+1
      IF(KOUNT(20).GT.LIMIT(20)) RETURN
      WRITE(6,100)
  100 FORMAT(' MESSAG CALLED WITH ILLEGAL INDEX.')
      RETURN
C
    1 CONTINUE
      WRITE(6,101)
  101 FORMAT(' INPUT READ ERROR. PROGRAMMED STOP.')
      STOP
C
    2 CONTINUE
      WRITE(6,102)
  102 FORMAT(' ILLEGAL EVENT NUMBER REQUESTED.')
      RETURN
    3 CONTINUE
      WRITE(6,103)
  103 FORMAT(' ILLEGAL USER INDEX. SKIP REST OF INPUT DS AND END.')
      RETURN
C
C---- LEAD GLASS ERROR MSG.
  200 LGINDX = INDEX-10
      GO TO (201,202,203,204,205,206,207),LGINDX
  201 WRITE(6,6201)
 6201 FORMAT('0***** BUFFER OVER FLOW IN LGADCN *****')
      RETURN
  202 WRITE(6,6202) MSGVAL
 6202 FORMAT(' ***** LG-DATA ILLEGAL ADDRESS:',I5)
      RETURN
  203 WRITE(6,6203)
 6203 FORMAT(' ******* TOO MANY LG-CLUSTERS *******')
  204 RETURN
  205 WRITE(6,6205) MSGVAL(1),AMSGVL(2),AMSGVL(3)
 6205 FORMAT(' NON-CONVERGENCE FOR DEPAV IN (LGAVRZ). NTRY,DEPO,DEP=',
     1       I3,2F10.2,'  **********')
      RETURN
  206 WRITE(6,6206) MSGVAL(1)
 6206 FORMAT(' ** ERROR IN /LGCL/ COPY.IER FROM JBCRA=',I5,' *****')
      RETURN
  207 WRITE(6,6207) MSGVAL(1)
 6207 FORMAT(' ** ERROR IN /ALGN/ COPY.IER FROM JBCRA=',I5,' *****')
      RETURN
      END
