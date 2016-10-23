C   07/11/78 C9060101   MEMBER NAME  GGCLUS   (S)           FORTRAN
      SUBROUTINE GGCLUS(JP,INIT,LNGJP,IER)
C
C     H.WRIEDT      16-11-78  16:40
C     LAST MODIFICATION   09-04-79  14:00
C
C     ORIGINALLY WRITTEN AS 'LGCLUS' BY S.YAMADA
C     AS TO BE FOUND ON YAMLGSRC.S
C
C
C---  LOCATE HIT CLUSTERS IN THE FORWARD DETECTOR  LEAD-GLASS COUNTERS
C---  ADC-S BELONGING TO A CLUSTER ARE GROUPED TOGETHER AND THE MAP OF
C---  THE STARTING MEMBER FOR EACH CLUSTER IS MADE.
C---  (SOME MODIFICATIONS ARE MADE FOR SPEED UP)
C
      IMPLICIT INTEGER*4 (G), INTEGER*2 (H)
C
      COMMON /CWORK/ IWORK1(42),LNG,HPOINT(4),HGGADC(2,192),IWORK2(263),
     &               ID,HTRACK(3),HCLST,HCLBEC(2),HNCLST,HCOL,HTYPE,HER,
     &               HCORR,HPBLAT,HDUMIN(2),HSCAL(36),HWORD(2),ACOLAN,
     &               ETOT(3),ENTOT(3),IWORK3(16),HCLMAP(2,51)
C***  COMMON /CGGADC/ LNG,HPOINT(4),HGGADC(2,192)
      COMMON /CGGPRM/ ITH,MAXCLS
C***  COMMON /CGGCLS/ NCLST,NCLBEC(2),HCLMAP(2,51),CLSPRP(10,51),ACOLAN,
C*** &                LCOLIN
C---- HCLST = NO.OF THE LOCATED CLUSTERS.
C---- HCLMAP(J)=THE INDEX OF THE FIRST MEMBER OF THE J-TH CLUSTER
C               IN THE HGGADC.
C
      COMMON /CMSGCT/ MSGDUM(20),GGMMAX,GGMSG1,GGMSG2
      COMMON /CNEIGH/ HLIST(6,96)
C     'HLIST' STORES NEIGHBOUR POSITIONS.
      DIMENSION GGADC(192)
      EQUIVALENCE (GGADC(1),HGGADC(1,1))
C
C---- INPUT
C     JP      PART OF THE LG-COUNTER TO BE ANALYSED, 1 FOR -Z-DIRECTION
C                                          (TOWARDS PLUTO/CELLO)
C                                                    2 FOR +Z-DIRECTION
C                                          (TOWARDS MARK J)
C     INIT    INITIAL DATA IN THE HGGADC FOR THE JP-TH PART
C     LNGJP     NO. OF ADC DATA FOR THE JP-TH PART
C
C---- RELATIVE THERESHOLD TO CONTINUE CLUSTER FINDING.
CCC*  HAS TO BE CHECKED WITH REAL DATA
      DATA IRLTHD/5/, IRLTH2/4/, IRLTH3/2/
C
      COMMON/ CGGVRN/ NVRSN(20)
      DATA NVCODE/178120812/,  MESS/0/
C
C---- INITIAL MESSAGE AND VERSION NO.SET.
      IF(MESS) 1001,1000,1001
 1000 WRITE(6,6000) ITH,MAXCLS,IRLTHD,IRLTH2
 6000 FORMAT('0 THRESHOLD OF CLUSTER SEARCH START=',I3,/' MAX.CLUSTER#='
     $,      I3,/' IRLTHD,IRLTH2=',2I5)
      NVRSN(8) = NVCODE
      MESS = 1
C
 1001 IER = 0
      IF(LNGJP) 80,80,2000
C
C---- ADC DATA SORTING ACCORDING TO THE PULSE HEIGHT
 2000 CALL GGSRTH(INIT-1,LNGJP)
      KEND = INIT+LNGJP-1
C
C---- INITIALIZATION
      HCLST = HCLST+1
      IF(HCLST.GT.MAXCLS) GO TO 90
      HCLMAP(1,HCLST) = INIT
      IPRNT = INIT
C
C---- SET THRESHOLDS
   30 IF(HGGADC(2,IPRNT).LT.ITH) GO TO 70
      IABTHD = HGGADC(2,IPRNT)/IRLTHD
      IABTH2 = HGGADC(2,IPRNT)/IRLTH2
C
C---- NEXT IS THE INDEX OF THE 1-ST NONREPLACED MEMBER.
      NEXT = IPRNT+1
   20 IF(NEXT.GT.KEND) GO TO 4
C---- SET UP THE NEIGHBOUR LIST FOR THE IPRNT-TH ADC.
      JPPRN = HGGADC(1,IPRNT)
      IF (JPPRN.GT.96) JPPRN = JPPRN-96
      NNBR = HLIST(1,JPPRN)+1
C
      GGAPRN = HGGADC(2,IPRNT)
      IABTH3 = GGAPRN*IRLTH3
C---- LOOK FOR DAUGHTERS
      NCAND = NEXT
   10   JPCND = HGGADC(1,NCAND)
        IF (JPCND.GT.96) JPCND = JPCND-96
C----   GLOBAL POSITION CHECK
        JDF = JPCND-JPPRN
        IF(JDF.LT.0) JDF = -JDF
        IF(JDF.GT.11) GO TO 1
C
C----   CAND IS CLOSE TO PRNT.SURVEY THE NEIGHBOUR TABLE.
          DO 2 NN=2,NNBR
          IF(JPCND.EQ.HLIST(NN,JPPRN)) GO TO 40
    2     CONTINUE
        GO TO 1
C
C----   A NEIGHBOUR IS FOUND. CHECK PULSE HEIGHT.
   40   IF(GGAPRN.GE.IABTHD) GO TO 3
C----   TAIL OF THE CLUSTER
        IF(HGGADC(2,NCAND).GT.IABTH2) GO TO 1
        IF(HGGADC(2,NCAND).GT.IABTH3) GO TO 1
C
C----   THE FOUND NEIGHBOUR IS MOVED TO FOLLOW THE PARENT.
    3   IF(NEXT-NCAND) 6,5,5
    6   LWORK = GGADC(NCAND)
C       SHIFT THE DATA BETWEEN NEXT AND NCAND.
        NSHIFT = NCAND-NEXT
          DO 60 NN=1,NSHIFT
          LL = NCAND-NN
          GGADC(LL+1) = GGADC(LL)
   60     CONTINUE
        GGADC(NEXT) = LWORK
C       PROCEED TO THE NEXT PLACE.
    5   NEXT = NEXT+1
    1   NCAND = NCAND+1
      IF(NCAND.LE.KEND) GO TO 10
C
C---- A SURVEY IS OVER FOR A PARENT.
C---- IF A NEW NEIGHBOUR WAS FOUND,TREAT IT AS A PARENT.
      IPRNT = IPRNT+1
      IF(IPRNT.LT.NEXT) GO TO 20
C
C---- ALL NEIGHBOURS ARE ALREADY FOUND.
C     STORE THE LAST INDEX OF THE ACTUAL CLUSTER & THE FIRST INDEX
C     OF THE FOLLOWING CLUSTER INTO HCLMAP
    4 HCLMAP(2,HCLST) = NEXT-1
      HCLST = HCLST+1
      IF(HCLST.GT.MAXCLS) GO TO 90
      HCLMAP(1,HCLST) = NEXT
C---- CHECK IF ANY MORE DATA IS LEFT
      IF(NEXT.LE.KEND) GO TO 30
C
C---- CLUSTER SEARCH IS FINISHED.
C
C---- SET THE LAST CLUSTER NO. FOR EACH PART INTO NCLBEC
   70 HCLST = HCLST-1
      HNCLST = HCLST
   80 HCLBEC(JP) = HCLST
      GO TO 100
C
C---- TOO MANY CLUSTER
   90 HCLBEC(JP) = HCLST-1
      IF(GGMSG1) 100,91,91
   91 GGMSG1 = GGMSG1+1
      IF(GGMSG1.LE.GGMMAX) WRITE(6,690)
  690 FORMAT(' ******* TOO MANY LG-CLUSTERS *******')
      IER = 1
  100 RETURN
      END
      BLOCK DATA
      COMMON /CNEIGH/ HLIST(6,96)
C
C---  THE COMMON 'CNEIGH' IS USED BY 'GGCLUS',
C---  'HLIST' CONTAINS THE NEIGHBOURING BLOCKS OF EACH BLOCK
C---  (FROM BLOCK-NO. 1 TO NO. 96)
C---  THE BLOCKS 47, 48, 95, AND 96 ARE ONLY FICTICIOUS ONES!
      INTEGER*2 HLIST, HLIST1(6,19), HLIST2(6,19), HLIST3(6,10)
      INTEGER*2 HLIST4(6,8), HLIST5(6,19), HLIST6(6,21)
      EQUIVALENCE (HLIST(1,1),HLIST1(1,1)), (HLIST(1,20),HLIST2(1,1))
      EQUIVALENCE (HLIST(1,39),HLIST3(1,1)), (HLIST(1,49),HLIST4(1,1))
      EQUIVALENCE (HLIST(1,57),HLIST5(1,1)), (HLIST(1,76),HLIST6(1,1))
      DATA HLIST1/ 3, 2,5,6, 2*0,
     2 3, 1,3,7, 2*0,
     3 3, 2,8,9, 2*0,
     4 2, 5,12, 3*0,
     5 4, 1,4,6,13, 0,
     6 5, 1,5,7,13,14,
     7 4, 2,6,8,15, 0,
     8 5, 3,7,9,16,17,
     9 4, 3,8,10,17, 0,
     & 2, 9,18, 3*0,
     1 2, 12,21, 3*0,
     2 4, 4,11,13,22, 0,
     3 5, 5,6,12,14,23,
     4 5, 6,13,15,23,24,
     5 4, 7,14,16,25, 0,
     6 5, 8,15,17,26,27,
     7 5, 8,9,16,18,27,
     8 4, 10,17,19,28, 0,
     9 2, 18,29, 3*0/
      DATA HLIST2/ 2, 21,31, 3*0,
     1 4, 11,20,22,32, 0,
     2 4, 12,21,23,33, 0,
     3 5, 13,14,22,24,34,
     4 4, 14,23,25,34, 0,
     5 3, 15,24,26, 2*0,
     6 4, 16,25,27,35, 0,
     7 5, 16,17,26,28,35,
     8 4, 18,27,29,36, 0,
     9 4, 19,28,30,37, 0,
     & 2, 29,38, 3*0,
     1 4, 20,32,39,40, 0,
     2 5, 21,31,33,40,41,
     3 5, 22,32,34,41,42,
     4 4, 23,24,33,42, 0,
     5 4, 26,27,36,43, 0,
     6 5, 28,35,37,43,44,
     7 5, 29,36,38,44,45,
     8 4, 30,37,45,46, 0/
      DATA HLIST3/ 3, 31,40,49, 2*0,
     & 5, 31,32,39,41,50,
     1 5, 32,33,40,42,51,
     2 4, 33,34,41,52, 0,
     3 4, 35,36,44,53, 0,
     4 5, 36,37,43,45,54,
     5 5, 37,38,44,46,55,
     6 3, 38,45,56, 2*0,
     7 0, 5*0,
     8 0, 5*0/
      DATA HLIST4/ 3, 39,50,57, 2*0,
     & 5, 40,49,51,57,58,
     1 5, 41,50,52,58,59,
     2 4, 42,51,59,60, 0,
     3 4, 43,54,61,62, 0,
     4 5, 44,53,55,62,63,
     5 5, 45,54,56,63,64,
     6 3, 46,55,64, 2*0/
      DATA HLIST5/ 4, 49,50,58,65, 0,
     8 5, 50,51,57,59,66,
     9 5, 51,52,58,60,67,
     & 4, 52,59,68,69, 0,
     1 4, 53,62,71,72, 0,
     2 5, 53,54,61,63,73,
     3 5, 54,55,62,64,74,
     4 4, 55,56,63,75, 0,
     5 2, 57,66, 3*0,
     6 4, 58,65,67,76, 0,
     7 4, 59,66,68,77, 0,
     8 5, 60,67,69,78,79,
     9 4, 60,68,70,79, 0,
     & 3, 69,71,80, 2*0,
     1 4, 61,70,72,81, 0,
     2 5, 61,71,73,81,82,
     3 4, 62,72,74,83, 0,
     4 4, 63,73,75,84, 0,
     5 2, 64,74, 3*0/
      DATA HLIST6/ 2, 66,77, 3*0,
     7 4, 67,76,78,85, 0,
     8 5, 68,77,79,86,87,
     9 5, 68,69,78,80,87,
     & 4, 70,79,81,88, 0,
     1 5, 71,72,80,82,89,
     2 5, 72,81,83,89,90,
     3 4, 73,82,84,91, 0,
     4 2, 74,83, 3*0,
     5 2, 77,86, 3*0,
     6 4, 78,85,87,92, 0,
     7 5, 78,79,86,88,92,
     8 4, 80,87,89,93, 0,
     9 5, 81,82,88,90,94,
     & 4, 82,89,91,94, 0,
     1 2, 83,90, 3*0,
     2 3, 86,87,93, 2*0,
     3 3, 88,92,94, 2*0,
     4 3, 89,90,93, 2*0,   0, 5*0,   0, 5*0/
      END
