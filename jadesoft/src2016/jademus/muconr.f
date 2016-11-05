C   12/11/81            MEMBER NAME  MUCONR   (JADEMUS)     FORTRAN
C   13/08/81 108132002  MEMBER NAME  MUCONR   (JADEMUS1)    FORTRAN
C   25/03/81            TAKEN FROM:  MUCONR   (F22BOW.MUCAL.S)
C   26/11/79            TAKEN FROM:  MUCONR   (JADEMUS1)
C
C NEW VERSION 22.00 25/03/81 C. BOWDERY :GETS LUNIN FROM ARGUMENT RATHER
C                                       :THAN COMMON/CMULUN/. ADD HERR
C                                       :ERROR FLAG AND USE MUERRY.
C      CHANGE 09.48 10/09/80 J. ALLISON :TO REPLACE WRITE'S BY MUMESS
C
      SUBROUTINE MUCONR(LUNIN,HERR)
C
      IMPLICIT INTEGER*2 (H)
C
C-----------------------------------------------------------------------
C
C MUCONR READS CALIB. DATA INTO /BCS/ AND THEN CALLS MUCON AND MUREG TO
C MOVE IT INTO /CALIBR/ AND /CMUREG/.  IT TAKES CARE OF BOS LISTS.
C HERR = 0 NORMAL RETURN  ; = 1 BOS READ ERROR ; = 2 END-OF-DATA ERROR
C      =-1 WARNING: NO MUON CALIBRATION READ
C-----------------------------------------------------------------------
      HERR=0
      CALL MUMESS('MUCONR',LUNIN,'=LOGICAL UNIT OF MU CALIB DATASET.^')
      IF(LUNIN.GT.0)GO TO 1
        CALL MUMESS('MUCONR',-1,'NO MUON CALIBRATION READ^')
        HERR=-1
        RETURN
C
C-----------------------------------------------------------------------
C
C            ----> PRESERVE SPECIAL LIST.
 1    CALL BSLS(1)
C            ----> READ CALIBRATION DATA RECORD.
C
      CALL BREAD (LUNIN,*10,*20)
C
C            ----> MOVE FROM /BCS/ TO /CALIBR/ BY CALLING MUCON.
      CALL MUCON
C            ----> UPDATE COMMON/CMUREG/.
      CALL MUREG(0)
C            ----> MAKE CURRENT LIST EQUAL TO LIST OF BANKS JUST READ IN
      CALL BSLT
C            ----> DELETE BANKS IN CURRENT LIST.
      CALL BDLG
C            ----> CLEAR SPECIAL LIST.
      CALL BSLC
C            ----> RESTORE SPECIAL LIST.
      CALL BSLR(1)
C            ----> REWIND UNIT LUNIN SO THAT IT CAN BE RE-READ NEXT TIME
      REWIND LUNIN
      RETURN
C
C-----------------------------------------------------------------------
C
C                  ERROR CONDITIONS.
C
 10   CALL MUERRY('MUCONR',1,'ERROR READING MU  CALIBRATION DATA. DS HAS
     + NO OR INVALID BOS BANK(S)^')
      HERR=1
      RETURN
C
 20   CALL MUERRY('MUCONR',2,'END-OF-DATA ERROR ON READING MU CALIB. EMP
     +TY,TOO SHORT OR NON-BOS DS^')
      HERR=2
      RETURN
      END
