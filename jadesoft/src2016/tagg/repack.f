C   03/09/79 001141517  MEMBER NAME  REPACK   (JADPRIVS)    FORTRAN
      SUBROUTINE REPACK(IER)
C---  FILL ANALYSIS RESULTS INTO BOS-BANKS
C---  OUTPUT BANKS: 'ACLS' AND 'TAGG'
C
C     H.WRIEDT        15.03.79      19:00
C     LAST MODIFICATION       14.01.80        15:20
C
      IMPLICIT INTEGER*4 (G), INTEGER*2 (H)
C
      EXTERNAL BDLM
C
      COMMON /BCS/ IDATA(30000)
      DIMENSION HDATA(60000), RDATA(30000)
      EQUIVALENCE (HDATA(1),IDATA(1),RDATA(1))
C
      DIMENSION HID(2)
      EQUIVALENCE (ID,HID(1))
C
      COMMON /CWORK/ IWORK1(42),LNG,HPOINT(4),HGGADC(2,192),IWORK2(263),
     +               HINF(54),RINF(7),IWORK3(16),GCLMAP(51),
     +               CLSPRP(13,51),IWORK4(16),GLUMON(10),IWORK5(10),
     +               TRACK(10,51)
C
      DIMENSION GGADC(195)
      EQUIVALENCE (GGADC(4),HGGADC(1,1))
C
      INTEGER MOUTI(34)
      EQUIVALENCE (MOUTI(1),HINF(1))
C
      INTEGER MOUTC(663)
      EQUIVALENCE (MOUTC(1),CLSPRP(1,1))
C
      INTEGER MOUTT(510)
      EQUIVALENCE (MOUTT(1),TRACK(1,1))
C
      COMMON /CDATUM/ HDATE
C
      COMMON /CMSGCT/ MSGDUM(21),NGGMSG(16)
C
      COMMON /CGGVRN/ NVRSN(20)
      DATA NVCODE/480011415/
C
      NVRSN(14) = NVCODE
C---  PROGRAM IDENTIFIER
C---  VERSION NO. (4 AT THE MOMENT)
      HID(1) = 4
C---  DATE
      HID(2) = HDATE
C
C---  CREATE ACLS
      NDATA = LNG + 1
      CALL BCRE(IND,'ACLS',0,NDATA,*100,IER)
      CALL BSAW(1,'ACLS')
C---  TRANSFER DATA INTO ACLS
      GGADC(1) = ID
      CALL BSTR(IND,GGADC,NDATA)
C
C---  CREATE TAGG/0
      CALL BCRE(IND,'TAGG',0,34,*110,IER)
      CALL BSAW(1,'TAGG')
C---  TRANSFER DATA INTO TAGG/0
      MOUTI(1) = ID
C---  HWORD(1): NUMBER OF WORDS USED PER CLUSTER FOR THE CLUSTER
C               INFORMATION (13, AT PRESENT)
      HINF(53) = 13
C---  HWORD(2): NUMBER OF WORDS USED PER TRACK FOR THE TRACK INFORMATION
C               (10, AT PRESENT)
      HINF(54) = 10
      CALL BSTR(IND,MOUTI,34)
      IF (HINF(6).EQ.0) GOTO 3
C---  CREATE TAGG/1
      NTAGG1 = HINF(6)
      CALL BCRE(IND,'TAGG',1,NTAGG1,*111,IER)
C---  TRANSFER DATA INTO TAGG/1
      CALL BSTR(IND,GCLMAP,NTAGG1)
C---  CREATE TAGG/2
      NTAGG2 = HINF(6)*HINF(53)
      CALL BCRE(IND,'TAGG',2,NTAGG2,*112,IER)
C---  TRANSFER DATA INTO TAGG/2
      CALL BSTR(IND,MOUTC,NTAGG2)
C---  CREATE TAGG/3
    3 CALL BCRE(IND,'TAGG',3,10,*113,IER)
C---  TRANSFER DATA INTO TAGG/3
      CALL BSTR(IND,GLUMON,10)
      IF (HINF(3).EQ.0) GOTO 5
C---  CREATE TAGG/4
      NTAGG4 = HINF(3)*HINF(54)
      CALL BCRE(IND,'TAGG',4,NTAGG4,*114,IER)
C---  TRANSFER DATA INTO TAGG/4
      CALL BSTR(IND,MOUTT,NTAGG4)
C
    5 RETURN
C
C---  NOT ENOUGH SPACE
  100 NGGMSG(11) = NGGMSG(11) + 1
      RETURN
C
  110 NGGMSG(12) = NGGMSG(12) + 1
      RETURN
  111 NGGMSG(13) = NGGMSG(13) + 1
      RETURN
  112 NGGMSG(14) = NGGMSG(14) + 1
      RETURN
  113 NGGMSG(15) = NGGMSG(15) + 1
      RETURN
  114 NGGMSG(16) = NGGMSG(16) + 1
      RETURN
      END
