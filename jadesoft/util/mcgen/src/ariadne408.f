CDECK  ID>, ARINIT.
      SUBROUTINE ARINIT(MODE)
C...ARiadne subroutine INITialize

C...Initializes Ariadne to run with other (Lund) MC programs

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARDAT2/ PQMAS(10)
      SAVE /ARDAT2/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      COMMON/GUDAT2/KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
      INTEGER  KCHG
      REAL  PMAS,PARF,VCKM
      SAVE /GUDAT2/
**JWG  add psi'(3685) as KC code 80, needed for Eurodec interface
*      --- ---------- -- -- ---- --- ------ --- ------- ---------
      INTEGER  IDPSIP
      PARAMETER  (IDPSIP=80)
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/
      COMMON /PYPARS/ MSTP(200),PARP(200),MSTI(200),PARI(200)
      SAVE /PYPARS/

      CHARACTER MODE*(*)


C...Set output files if not already done
      IF (MSTA(7).LT.0) MSTA(7)=MSTU(11)
      IF (MSTA(8).LT.0) MSTA(8)=MSTU(11)

C...Set Drell-Yan flagg
      QQ(MAXPAR-2)=.FALSE.

C...Write out header
      WRITE(MSTA(7),1000)
      MSTA(2)=1

C...If Ariadne mode, do nothing special
      IF (MODE(1:7).EQ.'ARIADNE'.OR.MODE(1:7).EQ.'ariadne') THEN
        MSTA(1)=0

C...If JETSET mode, switch off cascade and fragmentation in JETSET
      ELSEIF (MODE(1:6).EQ.'JETSET'.OR.MODE(1:6).EQ.'jetset') THEN
        MSTA(1)=1
        MSTA(5)=MIN(MAX(MSTJ(105),0),1)
        MSTJ(101)=5
        MSTJ(41)=0
        MSTJ(105)=0
        WRITE(MSTA(7),1010)

C...If PYTHIA mode, switch off cascades and fragmentation. Check that 
C...Ariadne can handle selected processes
      ELSEIF (MODE(1:6).EQ.'PYTHIA'.OR.MODE(1:6).EQ.'pythia') THEN

        MSTA(1)=2
        WRITE(MSTA(7),1020)
        MSTA(5)=MIN(MAX(MSTP(111),0),1)
        MSTP(61)=0
        MSTP(71)=0
        MSTP(111)=0
        MSTP(126)=40

C...If LEPTO mode, switch off cascades and fragmentation.
      ELSEIF (MODE(1:5).EQ.'LEPTO'.OR.MODE(1:5).EQ.'lepto') THEN
        MSTA(1)=3
        WRITE(MSTA(7),1030)
        IF (MSTA(32).EQ.0) THEN
          LST(8)=9
        ELSE
          LST(8)=0
        ENDIF
        MSTA(5)=MIN(MAX(LST(7),0),1)
        LST(7)=0
        LST(34)=0

C...Warn if mode is none of the above
      ELSE
        WRITE(MSTA(7),1040) MODE
        MSTA(1)=0
      ENDIF

C...Set quark masses
      IF (MSTA(24).GT.0) THEN
        DO 100 I=1,8
          PQMAS(I)=PMAS(I,1)
 100    CONTINUE
      ENDIF

      IF (MSTA(24).GE.2) THEN
        DO 110 I=1,5
          PQMAS(I)=PARF(100+I)
 110    CONTINUE
      ENDIF

      IF (MSTA(3).EQ.1) CALL ARTUNE('EMC')

 1000 FORMAT(/,12X,
     $     'The Lund Monte Carlo - Ariadne version 4 revision 08',
     $     /,23X,'Latest date of change: Nov 30 1995')
 1010 FORMAT(18X,'Initialization done for running with JETSET')
 1020 FORMAT(18X,'Initialization done for running with PYTHIA')
 1030 FORMAT(18X,'Initialization done for running with LEPTO')
 1040 FORMAT(/,15X,'WARNING: Ariadne cannot be initialized for "',A,
     $     '".',/,21X,'Using default initialization instead.')

      RETURN

C**** END OF ARINIT ****************************************************
      END
C***********************************************************************

      BLOCK DATA ARDATA

C...ARiadne block DATA statements

C...Initialization of the common blocks used in Ariadne

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARDAT2/ PQMAS(10)
      SAVE /ARDAT2/
      COMMON /ARDAT3/ IWRN(40)
      SAVE /ARDAT3/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /ARPOPA/ TOTSIG,PPOW,CA(3),PB(3),CF(0:6),XA(0:6),NB(0:6)
      SAVE /ARPOPA/ 

C...Breif explanation of parameters and switches:
C...
C...
C...Parameters:
C...
C...PARA(1) (D=0.22) lambda_QCD
C...PARA(2) (D=0.200) Constant alpha_QCD for MSTA(12)=0
C...PARA(3) (D=0.600) Cutoff in invariant p_t for QCD emission
C...PARA(4) (D=1/137) Constant alpha_EM
C...PARA(5) (D=0.600) Cutoff in invariant p_t for EM emission
C...PARA(6) (D=-1.00) Maximum allowed invariant p_t^2 (if >0)
C...PARA(7-9) not used
C...PARA(10)(D=1.000) Power in soft suppression (dimnsionality of
C...                  the extended source)
C...PARA(11)(D=0.600) Soft suppression parameter for code 1 or for
C...                  hadron on side 1 in PYTHIA or for the hadron
C...                  in LEPTO
C...PARA(12)(D=0.600) Soft suppression parameter for code 2 or for
C...                  hadron on side 2 in PYTHIA
C...PARA(13)(D=0.600) Soft suppression parameter for code 3
C...PARA(14)(D=1.000) Factor to multiply p_t of resolved photon or
C...                  or pomeron to get soft suppression parameter
C...PARA(15)(D=1.000) Power in soft suppression for resolved photon or
C...                  or pomeron
C...PARA(16)(D=-1.00) Mean of gaussian distributed mean intrinsic k_t
C...                  in pomeron (if less that 0 this is instead taken
C...                  from the corresponding hadron variables in LEPTO
C...                  or PYTHIA
C...PARA(17)(D=2.000) Maximum value of intrinsic k_t as given by
C...                  PARA(16)
C...PARA(18)(D=1.000) Maximum fraction of pomeron strf of total
C...PARA(19)(D=0.001) Minimum value of stucture function in denominator in
C...                  initial state g->qqbar
C...PARA(20)(D=0.000) Factor multiplying Q^2 before comparing with
C...                  momentum transfer in cutoff for DIS Matrix
C...                  elements. If < 0 W^2 is used as scale.
C...PARA(21)(D=1.000) Factor multiplying Q^2 when comparing with an
C...                  invariant p_T^2
C...PARA(22-24) not used
C...PARA(25)(D=2.000) exponent in propability for having a larger
C...                  fraction than a in extended emissions.
C...PARA(26)(D=9.000) Number of differently coloured dipoles
C...PARA(27)(D=0.600) Squared gives the mean value of primordial
C...                  k_t^2 for MSTA(37) > 0
C...PARA(28)(D=0.000) If > 0: Minimum energy for an emitted gluon.
C...                  If < 0: -Maximum energy for an emitted gluon.
C...PARA(29-30) not used
C...PARA(31)(D=25.00) Maximum invariant p_t^2 for clustering three jets
C...                  into two in ARCLUS
C...PARA(33-38) not used
C...PARA(39)(D=0.001) Tolerance factor for momentum conservation
C...PARA(40)(D=1E32)  Maximum allowed floating point number ("minimum"
C...                  is 1/PARA(40)
C...
C...Switches:
C...
C...MSTA(1) (R)       Ariadne mode (set by ARINIT) for treatment of
C...                  incomming events.
C...         0 =>      No special treatment
C...         1 =>      as if produced by JETSET
C...         2 =>      as if produced by PYTHIA
C...         3 =>      as if produced by LEPTO
C...MSTA(2) (I)       Initialization done and headers written
C...MSTA(3) (D=1)     Setting of parameters in  Ariadne, JETSET, 
C...                  PYTHIA and LEPTO to suitable values.
C...         0 =>      off
C...         1 =>      on
C...MSTA(4) (I)       Number of calls made to AREXEC
C...MSTA(5) (D=0)     Perform fragmentation at the end of AREXEC
C...         0 =>      off
C...         1 =>      on
C...                  When running with JETSET, PYTHIA or LEPTO this
C...                  switch is set to the value of the corresponding
C...                  switch in these programs.
C...MSTA(6) (D=-1)    Maximum number of emission (per string) in a
C...                  AREXEC call (if <0 - no limit) (Disabled when
C...                  used with PYTHIA.)
C...MSTA(7) (D=6)     File number for output (stdout) from Ariadne
C...                  set to MSTU(11) by ARINIT
C...MSTA(8) (D=6)     File number for error messages (stdout) from
C...                  Ariadne
C...MSTA(9) (D=1)     Debug mode
C...         0 =>      debug off
C...         1 =>      check that energy and momentum is conserved after
C...                   each call to AREXEC produce. Warns if change
C...                   in momentum is larger a factor PARA(39)
C...         2 =>      as for 1 but check every emission
C...         3 =>      as for 2 but dump string to /LUJETS/ after each 
C...                   emission
C...MSTA(10)(D=5)     Maximum number of warnings (of each kind) issued
C...                  by Ariadne
C...MSTA(11)(D=0)     Phase space restrictions. The maximum p_t of an 
C...                  emission is set to the p_t of the last emission
C...                  (otherwise no restrictions) for:
C...                    gluon  q-qbar  photon  emissions
C...         0 =>        yes     yes     yes
C...         1 =>        yes     yes     no
C...         2 =>        yes     no      yes
C...         3 =>        yes     no      no
C...         4 =>        no      no      no
C...MSTA(12)(D=1)     Running alpha_QCD
C...         0 =>      off
C...         1 =>      on
C...MSTA(13) (R)      Error experienced by Ariadne in last call to 
C...                  AREXEC. Reset to 0 at each call to AREXEC
C...MSTA(14)(D=1)     The maximum allowed p_t is set to the minimum
C...                  invariant p_t of all gluons in an incomming
C...                  string
C...         0 =>      off
C...         1 =>      on except in PYTHIA where instead limit is set
C...                   to the p_T^2 of the hard interaction for
C...                   relevant sub processes.
C...         2 =>      on
C...MSTA(15)(D=5)     Number of flavours allowed in final state
C...                  gluon -> q-qbar emission
C...MSTA(16)(D=2)     Recoil treatment
C...         0 =>      minimize p_t1^2 + p_t3^2
C...         1 =>      as for 0 but pointlike string ends takes
C...                   all recoil
C...         2=>       as for 0 but also extended string ends which
C...                   have a>1 takes full recoil
C...MSTA(17)(D=3)     Recoil treatment for extended dipoles
C...         0 =>      no special treatment (but cf. MSTA(16))
C...         1 =>      emit recoil gluon (except if pointlike quark
C...                   in other dipole end for MSTA(16)=1)
C...         2 =>      emit recoilgluon according to new strategy 
C...                   (except if pointlike quark in other dipole end 
C...                   for MSTA(16)=1)
C...         3 =>      always emit recoilgluon according to new strategy 
C...MSTA(18)(D=3)     P_t ordering of recoil gluons
C...         0 =>      off
C...         1 =>      on and require p_t larger than cutoff and mu
C...         2 =>      as 1 but p_t may be smaller than mu 
C...         3 =>      as 2 but p_t may also be smaller than the cutoff
C...MSTA(19)(D=2)     Correct or quick treatment of emissions from
C...                  heavy quarks
C...         0 =>      quick
C...         1 =>      correct
C...         2 =>      as for 1 but also use max(p_t^2,Q^2) in argument
C...                   for alpha_S for LEPTO
C...MSTA(20)(D=0)     Final state photon radiation
C...         0 =>      off
C...         1 =>      on
C...         2 =>      on but turned off at the first occurence of
C...                   q-qbar emission in a string.
C...MSTA(21)(D=0)     Photon radiation when run with PYTHIA or LEPTO
C...         0 =>      off
C...         1 =>      on
C...MSTA(22)(D=1)     Transfer of recoils in Drell-Yan processes
C...         0 =>      off
C...         1 =>      on
C...         2 =>      on but no transfer if a > 1
C...         3 =>      on but modified phase space
C...        <0 =>      as for >0 but only transfer recoil from recoil
C...                   gluons
C...MSTA(23)(D=1)     Fix bug in matix element for q-qbar emissions
C...         0 =>      Wrong ME
C...         1 =>      correct ME
C...         2 =>      as 1 but use m_t as ordering variable for q-qbar
C...                   emissions instead of p_t.
C...MSTA(24)(D=2)     Quark masses to be used in q-qbar emissions
C...         0 =>      as specified in PMAS(1-8) in /ARDAT2/
C...         1 =>      "bare" quark masses as specified in PMAS(1-8)
C...                   in /LUDAT2/
C...         2 =>      "constituent" quark masses as specified in 
C...                   PARF(101-108) in /LUDAT2/
C...MSTA(25)(D=1)     Generation procedure for exetended dipoles
C...         0 =>      Using restricted phase space
C...         1 =>      Using full phase space rejecting unphysical 
C...                   emissions allowing larger fractions of a
C...                   according  to PARA(25)
C...         2 =>      as 1 but new definition of p_T for calculation
C...                   of a
C...         3 =>      as for 1
C...         4 =>      but use real p_t of gluon w.r.t. remnant.
C...         5 =>      but use real p_t of gluon w.r.t. struck quark.
C...MSTA(26) not used
C...MSTA(27)(D=0)     Normalize pomeron structure function
C...         0 =>      nope
C...         1 =>      jupp
C...MSTA(28)(D=0)     Final state g->QQbar options
C...          0        normal Dipole model p_t ordering
C...          1        require m_QQ < p_tg
C...          2        require m_QQ-2m_Q < p_tg
C...         <0        as for >0 but don't limit p_tQQ
C...MSTA(29)(D=0)     Treatment of gluon rings
C...          0        allowed
C...          1        disallowed
C...MSTA(30)(D=3)     Extendedness of remnants
C...         0 =>      Stuck quark point like, remnant extended with
C...                   PARA(11)
C...         1 =>      as 0 but remnant extended with PARA(11)/(1-x)
C...         2 =>      as 1 but struck quark extended with Q
C...         3 =>      as 2 but emitted quark in initial state g->qqbar
C...                   not extended.
C...MSTA(31)(D=1)     mass of extended partons
C...         0 =>      set to zero for backward compatibility
C...         1 =>      keeps value given
C...MSTA(32)(D=1)     Treatment of DIS matrix element for BGF, and inclusion
C...                  of initial state g->qqbar in cascade
C...         0 =>      use old (wrong) treatment of BGF matrix elements
C...                   events
C...         1 =>      Let Lepto only generate Electro-weak vertex.
C...                   Generate BGF with sudakov in Ariadne and perform
C...                   this if it has higher p_t^2 than the first gluon
C...                   emission
C...         2 =>      Include initial state g->qqbar in cascade and correct
C...                   first emission for matrix elements if MSTA(33)!=0
C...MSTA(33)(D=1)     Treatment of DIS matrix element for QCM
C...
C...
C...         0 =>      approximated in cascade with the dipole formula
C...                   (Also only leading log BGF)
C...         1 =>      cascade corrected in first gluon emission
C...MSTA(34)(D=2)     Include Pomeron remnants
C...         -1 =>      included using external structure functions as
C...                   supplied in subroutine ARUPOM
C...         0 =>      not included
C...         1 =>      included using built in structure functions as
C...                   defined in /ARPOPA/ with zfq(z) = cf z^xa(1-z)^nb
C...                   and fp(x) ~ x^(-ppow/2)
C...         2 =>      as for 1 but zfq(z) = cf z(1-z) and
C...                   fp(x) ~ (1-x)^3/x
C...         3 =>      as for 1 but zfq(z) = cf z(1-z) and
C...                   fp(x) ~ (1-x)^5/x
C...
C...MSTA(35)(D=0)     Colour rearrangement of dipoles in the cascade
C...                    -1 => Allow rearrangement after the cascade
C...                     0 => off
C...                     1 => Allow rearrangement within each initial
C...                          string separately
C...                     2 => As 1 but allow global rearrangements
C...                          e.g. below gluon energies of PARA(28)
C...                     3 => Allow global rearrangements from start
C...MSTA(36)(D=2)     Extension of remnant overides other switches
C...                      0 => PARA(11/12) or as defined by other switches
C...                      1 => PARA(11/12)/(1-z)
C...
C...
C...                      2 => intrinsic p_t*PARA(14)
C...                      3 => intrinsic p_t*PARA(14)/(1-x)
C...                      4 => intrinsic p_t*PARA(14)/((1-x)(1-z))
C...MSTA(37)(D=1)     Handeling of primordial k_t of proton
C...                      0 => As in program initialized for
C...                      1 => Gaussian with <k_T^2> = PARA(27)^2
C...                      2 => Exponential with <k_T^2> = PARA(27)^2
C...End of description


C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...
C...

      DATA PARA/0.22,0.2,0.6,0.007297353,0.6,-1.0,0.0,0.0,0.0,1.0,
     $          0.6,0.6,0.6,1.0,1.0,-1.0,2.0,1.0,0.001,0.0,
     $          1.0,0.0,2*0.0,2.0,9.0,0.6,3*0.0,
     $          25.0,7*0.0,0.001,1.0E32/
      DATA MSTA/0,0,1,0,0,-1,6,6,1,5,
     $          0,1,0,1,5,2,3,3,2,0,
     $          0,1,1,2,1,0,0,2*0,3,
     $          1,1,1,2,0,2,1,3*0/
      DATA PHAR/100*0.0,
     $          -1.0,-1.0,1.0,1.0,0.0,0.0,-1.0,0.0,9.0,91*0.0,
     $          100*0.0,
     $          100*0.0/
      DATA MHAR/100*0,
     $          2,2,1,0,0,0,0,0,0,0,1,-1,1,0,0,0,0,0,0,1,7*0,1,0,1,
     $          1,1,9,1,66*0,
     $          100*0,
     $          100*0/
      DATA PQMAS/10*0.0/
      DATA IWRN/40*0/
      DATA TOTSIG/2.3/
      DATA PPOW/2.0/
      DATA CA/6.38,0.424,0.0/
      DATA PB/8.0,3.0,0.0/
      DATA (CF(I),I=0,6)/0.0,1.0,1.0,0.0,0.0,0.0,0.0/
      DATA (XA(I),I=0,6)/7*1.0/
      DATA (NB(I),I=0,6)/7*1/

C**** END OF ARDATA ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARADDG.
      SUBROUTINE ARADDG(ID,ICLOSE)

C...ARiadne subroutine ADD Gluon

C...Adds a gluon entry between the partons in dipole ID thus creating 
C...a new dipole

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/

      INXT(I)=IDO(IP3(I))
      IPRV(I)=IDI(IP1(I))


C...Allocate new gluon and new dipole at postitons IPART+1 and IDIPS+1
C...if there is space left.
      IPART=IPART+1
      IDIPS=IDIPS+1
      IF (IPART.GE.MAXPAR-10) CALL ARERRM('ARADDG',6,0)
      IF (IDIPS.GE.MAXDIP-10) CALL ARERRM('ARADDG',7,0)

C...Set properties of new gluon
      DO 100 I=1,5
        BP(IPART,I)=0.0
 100  CONTINUE
      IFL(IPART)=21
      QEX(IPART)=.FALSE.
      XPMU(IPART)=0.0
      XPA(IPART)=0.0
      QQ(IPART)=.FALSE.
      INQ(IPART)=0
      IDI(IPART)=ID
      IDO(IPART)=IDIPS
      PT2GG(IPART)=PT2IN(ID)

C...Set properties of new dipole
      IP1(IDIPS)=IPART
      IP3(IDIPS)=IP3(ID)
      QDONE(IDIPS)=.FALSE.
      QEM(IDIPS)=.FALSE.
      ISTR(IDIPS)=ISTR(ID)
      PT2IN(IDIPS)=PT2IN(ID)

C...Fix pointers for old dipole
      IP3(ID)=IPART
      IDI(IP3(IDIPS))=IDIPS
      IF (IPRV(ID).NE.0) QDONE(IPRV(ID))=.FALSE.
      QDONE(ID)=.FALSE.
      IF (INXT(IDIPS).NE.0) QDONE(INXT(IDIPS))=.FALSE.

      IS=ISTR(ID)
      IF (IFLOW(IS).EQ.2) THEN
        IPF(IS)=IP3(ID)
        IPL(IS)=IP1(ID)
      ENDIF

C...Fix colour assignment
      ISCOL=ICOLI(ID)/1000
      IF (ICLOSE.EQ.1) THEN
        ICOLI(IDIPS)=ICOLI(ID)
        CALL ARCOLI(ID,-ISCOL)
      ELSE
        CALL ARCOLI(IDIPS,-ISCOL)
      ENDIF

      RETURN

C**** END OF ARADDG ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARREMG.
      SUBROUTINE ARREMG(IGI)

C...ARiadne subroutine REMove Gluon

C...Removes the gluon entry IG and reconnects neighboring dipoles

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/

C...Check that we don't have a gluon ring...
      IG=IGI
      IF (IFLOW(ISTR(IDO(IG))).EQ.2.AND.
     $     IP3(IDO(IG)).EQ.IP1(IDI(IG))) RETURN

C...First change pointers making IG and one neighboring dipole orphans
      IDREM=IDO(IG)
      IP=IP3(IDREM)
      ID=IDI(IG)
      IP3(ID)=IP
      IDI(IP)=ID
      IDP=IDI(IG)
      IF (IDP.GT.IDREM) IDP=IDP-1

C...Purge the parton vector
      DO 100 IP=IG+1,IPART
        I=IP-1
        DO 110 J=1,5
          BP(I,J)=BP(IP,J)
 110    CONTINUE
        IFL(I)=IFL(IP)
        QEX(I)=QEX(IP)
        QQ(I)=QQ(IP)
        IDI(I)=IDI(IP)
        IDO(I)=IDO(IP)
        INO(I)=INO(IP)
        INQ(I)=INQ(IP)
        XPMU(I)=XPMU(IP)
        XPA(I)=XPA(IP)
        PT2GG(I)=PT2GG(IP)
 100  CONTINUE
      IPART=IPART-1

C...Purge the dipole vector
      DO 200 ID=IDREM+1,IDIPS
        I=ID-1
        BX1(I)=BX1(ID)
        BX3(I)=BX3(ID)
        PT2IN(I)=PT2IN(ID)
        SDIP(I)=SDIP(ID)
        IP1(I)=IP1(ID)
        IP3(I)=IP3(ID)
        AEX1(I)=AEX1(ID)
        AEX1(I)=AEX3(ID)
        QDONE(I)=QDONE(ID)
        QEM(I)=QEM(ID)
        IRAD(I)=IRAD(ID)
        ISTR(I)=ISTR(ID)
        ICOLI(I)=ICOLI(ID)
 200  CONTINUE
      IDIPS=IDIPS-1

C...Reset changed pointers

      DO 300 IP=1,IPART
        IF (IDO(IP).GE.IDREM) IDO(IP)=IDO(IP)-1
        IF (IDI(IP).GE.IDREM) IDI(IP)=IDI(IP)-1
 300  CONTINUE
      DO 310 ID=1,IDIPS
        IF (IP3(ID).GE.IG) IP3(ID)=IP3(ID)-1
        IF (IP1(ID).GE.IG) IP1(ID)=IP1(ID)-1
 310  CONTINUE
      DO 320 IS=1,ISTRS
        IF (IPF(IS).GE.IG) IPF(IS)=IPF(IS)-1
        IF (IPL(IS).GE.IG) IPL(IS)=IPL(IS)-1
 320  CONTINUE

C...Fix up colour indices
      IDN=IDO(IP3(IDP))
      IF (IDN.GT.0) THEN
        IF (ICOLI(IDN).EQ.ICOLI(IDP)) THEN
          ISCOL=ICOLI(IDN)/1000
          ICOLI(IDN)=0
          ICOLI(IDP)=0
          CALL ARCOLI(IDN,-ISCOL)
          CALL ARCOLI(IDP,-ISCOL)
        ENDIF
      ENDIF

      RETURN

C**** END OF ARREMG ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARJOQQ.
      SUBROUTINE ARJOQQ(IQ1,IQ2)

C...ARiadne subroutine JOin QQbar pair

C...Join quark and anti-quark entry IQ1 and IQ2 into a gluon entry
C...located in MIN(IQ1,IQ2). Disregard flavour consistency

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/


      IG=MIN(IQ1,IQ2)
      IREM=MAX(IQ1,IQ2)

C...First remove any EM-dipoles
      IF (IDI(IREM).GT.0) THEN
        IF (QEM(IDI(IREM))) CALL ARREMD(IDI(IREM))
      ENDIF
      IF (IDO(IREM).GT.0) THEN
        IF (QEM(IDO(IREM))) CALL ARREMD(IDO(IREM))
      ENDIF
      IF (IDI(IG).GT.0) THEN
        IF (QEM(IDI(IG))) CALL ARREMD(IDI(IG))
      ENDIF
      IF (IDO(IG).GT.0) THEN
        IF (QEM(IDO(IG))) CALL ARREMD(IDO(IG))
      ENDIF

C...Check that quarks not directly connected and then join them
      IF (IDI(IG).GT.0) THEN
        IF (IDO(IG).GT.0) RETURN
        IF (IDI(IREM).GT.0) CALL AREVST(ISTR(IDI(IREM)))
        CALL ARJOST(ISTR(IDI(IG)),ISTR(IDO(IREM)),IG,IREM)
        IP1(IDO(IREM))=IG
        IDO(IG)=IDO(IREM)
        IDO(IREM)=0
      ELSE
        IF (IDO(IG).LE.0) RETURN
        IF (IDO(IREM).GT.0) CALL AREVST(ISTR(IDO(IREM)))
        CALL ARJOST(ISTR(IDO(IG)),ISTR(IDI(IREM)),IG,IREM)
        IP3(IDI(IREM))=IG
        IDI(IG)=IDI(IREM)
        IDI(IREM)=0
      ENDIF

C...Remove quark entry
      CALL ARREMP(IREM)
      QQ(IG)=.FALSE.
      IFL(IG)=21
      PT2GG(IG)=0.0
      INQ(IG)=0

      IF (ICOLI(IDI(IG)).EQ.ICOLI(IDO(IG))) THEN
        ISCOL=ICOLI(IDI(IG))/1000
        ICOLI(IDI(IG))=0
        ICOLI(IDO(IG))=0
        CALL ARCOLI(IDI(IG),-ISCOL)
        CALL ARCOLI(IDO(IG),-ISCOL)
      ENDIF

      RETURN

C**** END OF ARJOQQ ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARREMP.
      SUBROUTINE ARREMP(IREM)

C...ARiadne subroutine REMove Parton

C...Remove parton entry from /ARPART/ and purge event record

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/


C...Purge the parton vector
      DO 100 IP=IREM+1,IPART
        I=IP-1
        DO 110 J=1,5
          BP(I,J)=BP(IP,J)
 110    CONTINUE
        IFL(I)=IFL(IP)
        QEX(I)=QEX(IP)
        QQ(I)=QQ(IP)
        IDI(I)=IDI(IP)
        IDO(I)=IDO(IP)
        INO(I)=INO(IP)
        INQ(I)=INQ(IP)
        XPMU(I)=XPMU(IP)
        XPA(I)=XPA(IP)
        PT2GG(I)=PT2GG(IP)
 100  CONTINUE

C...Fix pointers for special entries
      DO 120 IP=MAXPAR-4,MAXPAR-3
        IF (.NOT.QQ(IP)) GOTO 120
        IF (INQ(IP).EQ.IREM) THEN
          INQ(IP)=0
        ELSEIF (INQ(IP).GT.IREM.AND.INQ(IP).LE.IPART) THEN
          INQ(IP)=INQ(IP)-1
        ENDIF
        IF (IDI(IP).EQ.IREM) THEN
          IDI(IP)=0
        ELSEIF (IDI(IP).GT.IREM.AND.IDI(IP).LE.IPART) THEN
          IDI(IP)=IDI(IP)-1
        ENDIF
 120  CONTINUE

C...Reset changed pointers

      DO 200 ID=1,IDIPS
        IF (IP1(ID).EQ.IREM) THEN
          IP1(ID)=0
        ELSEIF (IP1(ID).GT.IREM.AND.IP1(ID).LE.IPART) THEN
          IP1(ID)=IP1(ID)-1
        ENDIF
        IF (IP3(ID).EQ.IREM) THEN
          IP3(ID)=0
        ELSEIF (IP3(ID).GT.IREM.AND.IP3(ID).LE.IPART) THEN
          IP3(ID)=IP3(ID)-1
        ENDIF
 200  CONTINUE

      DO 210 IS=1,ISTRS
        IF (IPF(IS).GE.IREM.AND.IPF(IS).LE.IPART) IPF(IS)=IPF(IS)-1
        IF (IPL(IS).GE.IREM.AND.IPL(IS).LE.IPART) IPL(IS)=IPL(IS)-1
 210  CONTINUE

      IPART=IPART-1

      RETURN

C**** END OF ARREMP ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARREMD.
      SUBROUTINE ARREMD(IREM)

C...ARiadne subroutine REMove Dipole

C...Remove dipole entry from /ARDIPS/ and purge event record

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/


      IDP=-1
      IF (IP1(IREM).GT.0) IDP=IDI(IP1(IREM))
      IDN=-1
      IF (IP3(IREM).GT.0) IDN=IDO(IP3(IREM))
      IF (IDP.GT.IREM) IDP=IDP-1
      IF (IDN.GT.IREM) IDN=IDN-1

C...Purge the dipole vector
      DO 100 ID=IREM+1,IDIPS
        I=ID-1
        BX1(I)=BX1(ID)
        BX3(I)=BX3(ID)
        PT2IN(I)=PT2IN(ID)
        SDIP(I)=SDIP(ID)
        IP1(I)=IP1(ID)
        IP3(I)=IP3(ID)
        AEX1(I)=AEX1(ID)
        AEX3(I)=AEX3(ID)
        QDONE(I)=QDONE(ID)
        QEM(I)=QEM(ID)
        IRAD(I)=IRAD(ID)
        ISTR(I)=ISTR(ID)
        ICOLI(I)=ICOLI(ID)
 100  CONTINUE

      DO 200 IP=1,IPART
        IF (IDO(IP).EQ.IREM) THEN
          IDO(IP)=0
        ELSEIF (IDO(IP).GT.IREM.AND.IDO(IP).LE.IDIPS) THEN
          IDO(IP)=IDO(IP)-1
        ENDIF
        IF (IDI(IP).EQ.IREM) THEN
          IDI(IP)=0
        ELSEIF (IDI(IP).GE.IREM.AND.IDI(IP).LE.IDIPS) THEN
          IDI(IP)=IDI(IP)-1
        ENDIF
 200  CONTINUE

      IDIPS=IDIPS-1

      IF (IDP.GT.0.AND.IDN.GT.0) THEN
        IF (ICOLI(IDP).EQ.ICOLI(IDN)) THEN
          ISCOL=ICOLI(IDP)/1000
          ICOLI(IDP)=0
          ICOLI(IDN)=0
          CALL ARCOLI(IDP,-ISCOL)
          CALL ARCOLI(IDN,-ISCOL)
        ENDIF
      ENDIF

      RETURN

C**** END OF ARREMD ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, AREVST.
      SUBROUTINE AREVST(ISIN)

C...Ariadne subroutine REVerse colour flow of STring entry

C...Reverse the colour flow of string entry ISIN in /ARSTRS/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/


C...Purely glounic strings have no determined flow
      IF (IFLOW(ISIN).EQ.2) RETURN

C...The first shall be the last
      IS=ISIN
      IP=IPF(IS)
 100  ICO=IDO(IP)
      IDO(IP)=IDI(IP)
      IDI(IP)=ICO
      IF (ICO.GT.0) THEN
        IPS=IP3(ICO)
        IP3(ICO)=IP1(ICO)
        IP1(ICO)=IPS
        BX=BX1(ICO)
        BX1(ICO)=BX3(ICO)
        BX3(ICO)=BX
        AEX=AEX1(ICO)
        AEX1(ICO)=AEX3(ICO)
        AEX3(ICO)=AEX
        IF (ABS(IRAD(ICO)).LT.10) IRAD(ICO)=-IRAD(ICO)
      ENDIF
      IF (IP.NE.IPL(IS)) THEN
        IP=IPS
        GOTO 100
      ENDIF

      IFLOW(IS)=-IFLOW(IS)
      IP=IPF(IS)
      IPF(IS)=IPL(IS)
      IPL(IS)=IP

      RETURN

C**** END OF AREVST ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARJOST.
      SUBROUTINE ARJOST(IS1,IS2,IPA1,IPA2)

C...ARiadne subroutine JOin two STring entries

C...Join the string entries IS1 and IS2 in the ends IP1 and IP2

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/


      IS=IS1
      ISREM=IS2
      IP=IPA1
      IPREM=IPA2

C...If the strings are the same we make a purely gluonic string
      IF (IS.EQ.ISREM) THEN
        IFLOW(IS)=2
        IPF(IS)=IP
        IPL(IS)=IP
        RETURN
      ENDIF

      IF (IP.EQ.IPF(IS)) THEN
        IF (IPREM.EQ.IPF(ISREM)) CALL ARERRM('ARJOST',5,0)
        IPF(IS)=IPF(ISREM)
      ELSE
        IF (IP.NE.IPL(IS).OR.IPREM.EQ.IPL(ISREM))
     $       CALL ARERRM('ARJOST',5,0)
        IPL(IS)=IPL(ISREM)
      ENDIF

      DO 100 ID=1,IDIPS
        IF (ISTR(ID).EQ.ISREM) ISTR(ID)=IS
 100  CONTINUE

      DO 110 IS=ISREM,ISTRS-1
        IPF(IS)=IPF(IS+1)
        IPL(IS)=IPL(IS+1)
        IFLOW(IS)=IFLOW(IS+1)
 110  CONTINUE

      ISTRS=ISTRS-1

      DO 120 ID=1,IDIPS
        IF (ISTR(ID).GT.ISREM) ISTR(ID)=ISTR(ID)-1
 120  CONTINUE

      RETURN

C**** END OF ARJOST ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARPADD.
      SUBROUTINE ARPADD(IP,NP,IPV)

C...ARiadne subroutine Pointer ADD

C...Add pointer IP to vector IPV(NP)

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      DIMENSION IPV(NP+1)

      IF (IP.GT.0) GOTO 900
      DO 100 I=1,NP
        IF (IPV(I).EQ.ABS(IP)) RETURN
 100  CONTINUE

 900  NP=NP+1
      IPV(NP)=ABS(IP)

      RETURN

C**** END OF ARPADD ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARPADO.
      SUBROUTINE ARPADO(IP,NP,IPV)

C...ARiadne subroutine Pointer ADd to Ordered list

C...Add pointer IP to ordered vector IPV(NP)

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      DIMENSION IPV(NP+1)

      IPV(NP+1)=0
      DO 100 I=1,NP
        IF (IPV(I).EQ.IP) RETURN
        IF (IP.LT.IPV(I)) THEN
          CALL ARPINS(IP,I,NP,IPV)
          RETURN
        ENDIF
 100  CONTINUE

      CALL ARPINS(IP,NP+1,NP,IPV)

      RETURN

C**** END OF ARPADO ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARPINS.
      SUBROUTINE ARPINS(IP,INP,NP,IPV)

C...ARiadne subroutine Pointer INSert

C...Insert pointer IP to vector IPV(NP) in position I

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      DIMENSION IPV(NP+1)

      DO 100 I=NP,INP,-1
        IPV(I+1)=IPV(I)
 100  CONTINUE
      IPV(INP)=IP

      NP=MAX(NP+1,INP)

      RETURN

C**** END OF ARPINS ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARPREM.
      SUBROUTINE ARPREM(IP,NP,IPV)

C...ARiadne subroutine Pointer REMove

C...Remove pointer IP from vector IPV(NP) and purge the vector.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      DIMENSION IPV(NP)

      NFOUND=0
      DO 100 I=1,NP
        IF (NFOUND.GT.0) IPV(I-NFOUND)=IPV(I)
        IF (IPV(I).EQ.IP) NFOUND=NFOUND+1
 100  CONTINUE

      NP=NP-NFOUND

      RETURN

C**** END OF ARPREM ****************************************************
      END
C***********************************************************************
C $Id: araddg.f,v 3.14 1995/08/13 17:28:58 lonnblad Exp $
CDECK  ID>, ARREMS.
      SUBROUTINE ARREMS(IREM)

C...ARiadne subroutine REMove String 

C...Remove String entry from /ARSTRS/ and purge event record

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/


C...Purge the dipole vector
      DO 100 IS=IREM+1,ISTRS
        I=IS-1
        IFLOW(I)=IFLOW(IS)
        IPF(I)=IPF(IS)
        IPL(I)=IPL(IS)
 100  CONTINUE

      ISTRS=ISTRS-1

      DO 110 ID=1,IDIPS
        IF (ISTR(ID).EQ.IREM) ISTR(ID)=0
        IF (ISTR(ID).GT.IREM) ISTR(ID)=ISTR(ID)-1
 110  CONTINUE

      RETURN

C**** END OF ARREMS ****************************************************
      END
C***********************************************************************
C $Id: arangl.f,v 3.3 1994/05/11 07:10:09 lonnblad Exp $
CDECK  ID>, ARANGL.
      REAL FUNCTION ARANGL(I1,I2)

C...ARiadne function ANGLe

C...Returns the angle between parton I1 and I2

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/


      D12=BP(I1,1)*BP(I2,1)+BP(I1,2)*BP(I2,2)+BP(I1,3)*BP(I2,3)
      DP1=SQRT(BP(I1,1)**2+BP(I1,2)**2+BP(I1,3)**2)
      DP2=SQRT(BP(I2,1)**2+BP(I2,2)**2+BP(I2,3)**2)
      ARANGL=ACOS(MAX(-1.0D0,MIN(1.0D0,D12/(DP1*DP2))))

      RETURN

C**** END OF ARANGL ****************************************************
      END
C***********************************************************************
C $Id: arbocm.f,v 3.4 1995/03/06 16:54:27 lonnblad Exp $
CDECK  ID>, ARBOCM.
      SUBROUTINE ARBOCM(ID)

C...ARiadne subroutine BOost to Center of Mass

C...Boost the partons in dipole ID to the CMS of the dipole

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARINT2/ DBEX,DBEY,DBEZ,PHI,THE
      SAVE /ARINT2/


C...Calculate boostvector and boost
      I1=IP1(ID)
      I3=IP3(ID)
      DPE1=BP(I1,4)
      DPE3=BP(I3,4)
      DPE=DPE1+DPE3
      DPX1=BP(I1,1)
      DPX3=BP(I3,1)
      DBEX=(DPX1+DPX3)/DPE
      DPY1=BP(I1,2)
      DPY3=BP(I3,2)
      DBEY=(DPY1+DPY3)/DPE
      DPZ1=BP(I1,3)
      DPZ3=BP(I3,3)
      DBEZ=(DPZ1+DPZ3)/DPE
      CALL AROBO2(0.0,0.0,-DBEX,-DBEY,-DBEZ,I1,I3)

C...Calculate rotation angles but no need for rotation yet
      PX=BP(I1,1)
      PY=BP(I1,2)
      PZ=BP(I1,3)
      PHI=ULANGL(PX,PY)
      THE=ULANGL(PZ,SQRT(PX**2+PY**2))

      RETURN

C**** END OF ARBOCM ****************************************************
      END
C***********************************************************************
C $Id: arbocm.f,v 3.4 1995/03/06 16:54:27 lonnblad Exp $
CDECK  ID>, ARBOLE.
      SUBROUTINE ARBOLE(THEL,PHI1,PHI2,DBXL,DBYL,DBZL)

C...ARiadne subroutine BOost to hadronic center of mass of LEpto event

C...Boost partons to the hadronic CMS of a LEPTO event


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/


      DBXL=0.0D0
      DBYL=0.0D0
      DBZL=0.0D0
      DBEL=0.0D0
      THEL=0.0
      PHI1=0.0
      PHI2=0.0

      DO 100 I=5,N
        DBXL=DBXL+DBLE(P(I,1))
        DBYL=DBYL+DBLE(P(I,2))
        DBZL=DBZL+DBLE(P(I,3))
        DBEL=DBEL+DBLE(P(I,4))
 100  CONTINUE

      DBXL=DBXL/DBEL
      DBYL=DBYL/DBEL
      DBZL=DBZL/DBEL

      CALL LUDBRB(1,N,0.0,0.0,-DBXL,-DBYL,-DBZL)
      PHI1=ULANGL(P(3,1),P(3,2))
      THEL=ULANGL(P(3,3),SQRT(P(3,1)**2+P(3,2)**2))
        
      CALL LUDBRB(1,N,0.0,-PHI1,0.0D0,0.0D0,0.0D0)
      CALL LUDBRB(1,N,-THEL,0.0,0.0D0,0.0D0,0.0D0)

      PHI2=ULANGL(P(1,1),P(1,2))
      CALL LUDBRB(1,N,0.0,-PHI2,0.0D0,0.0D0,0.0D0)

      RETURN

C**** END OF ARBOLE ****************************************************
      END

C***********************************************************************
C $Id: arbocm.f,v 3.4 1995/03/06 16:54:27 lonnblad Exp $
CDECK  ID>, ARBOPY.
      SUBROUTINE ARBOPY(THEPY,PHIPY,DBXPY,DBYPY,DBZPY,PHI2PY)

C...ARiadne subroutine BOost to center of mass of PYthia event

C...Boost partons to the total CMS of a PYTHIA event


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      COMMON /PYPARS/ MSTP(200),PARP(200),MSTI(200),PARI(200)
      SAVE /PYPARS/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/

      DOUBLE PRECISION DBP(4)


      ISUB=MSTI(1)
      DO 10 J=1,4
        DBP(J)=0.0D0
 10   CONTINUE
     
      IF ((ISUB.EQ.10.OR.ISUB.EQ.83).AND.
     $     ABS(MSTI(15)).GE.11.AND.ABS(MSTI(15)).LE.18.AND.
     $     ABS(MSTI(16)).GE.1.AND.ABS(MSTI(16)).LE.8) THEN

        DO 100 I=MSTI(4),N
          IF (K(I,3).NE.2.AND.K(I,3).NE.MSTI(8)) GOTO 100
          DO 110 J=1,4
            DBP(J)=DBP(J)+DBLE(P(I,J))
 110      CONTINUE
 100    CONTINUE

        IQ=-2
        IL=MSTI(7)

        DBXPY=DBP(1)/DBP(4)
        DBYPY=DBP(2)/DBP(4)
        DBZPY=DBP(3)/DBP(4)

        X=PARI(34)
        XQ2=-PARI(15)
        W2=DBP(4)**2-DBP(3)**2-DBP(2)**2-DBP(1)**2
        U=P(2,4)*(P(IL-2,4)-P(IL,4))-P(2,3)*(P(IL-2,3)-P(IL,3))-
     $       P(2,2)*(P(IL-2,2)-P(IL,2))-P(2,1)*(P(IL-2,1)-P(IL,1))
        XY=U/(P(1,4)*P(2,4)-P(1,3)*P(2,3)-P(1,2)*P(2,2)-P(1,1)*P(2,1))

      ELSEIF ((ISUB.EQ.10.OR.ISUB.EQ.83).AND.
     $       ABS(MSTI(16)).GE.11.AND.ABS(MSTI(16)).LE.18.AND.
     $       ABS(MSTI(15)).GE.1.AND.ABS(MSTI(15)).LE.8) THEN

        DO 200 I=MSTI(4)+1,N
          IF (K(I,3).NE.1.AND.K(I,3).NE.MSTI(7)) GOTO 200
          DO 210 J=1,4
            DBP(J)=DBP(J)+DBLE(P(I,J))
 210      CONTINUE
 200    CONTINUE

        IQ=1
        IL=MSTI(8)

        DBXPY=DBP(1)/DBP(4)
        DBYPY=DBP(2)/DBP(4)
        DBZPY=DBP(3)/DBP(4)

        X=PARI(33)
        XQ2=-PARI(15)
        W2=DBP(4)**2-DBP(3)**2-DBP(2)**2-DBP(1)**2
        U=P(1,4)*(P(IL-2,4)-P(IL,4))-P(1,3)*(P(IL-2,3)-P(IL,3))-
     $       P(1,2)*(P(IL-2,2)-P(IL,2))-P(1,1)*(P(IL-2,1)-P(IL,1))
        XY=U/(P(1,4)*P(2,4)-P(1,3)*P(2,3)-P(1,2)*P(2,2)-P(1,1)*P(2,1))

      ELSE

        DEPY=DBLE(P(1,4))+DBLE(P(2,4))
        DBXPY=(DBLE(P(1,1))+DBLE(P(2,1)))/DEPY
        DBYPY=(DBLE(P(1,2))+DBLE(P(2,2)))/DEPY
        DBZPY=(DBLE(P(1,3))+DBLE(P(2,3)))/DEPY

        IQ=1
        IL=0

        XQ2=-1.0

      ENDIF

      CALL LUDBRB(1,N,0.0,0.0,-DBXPY,-DBYPY,-DBZPY)

      I=ABS(IQ)
      PHIPY=ULANGL(P(I,1),P(I,2))
      THEPY=ULANGL(P(I,3),SQRT(P(I,1)**2+P(I,2)**2))
      IF (IQ.LT.0) THEPY=PARU(1)+THEPY
        
      CALL LUDBRB(1,N,0.0,-PHIPY,0.0D0,0.0D0,0.0D0)
      CALL LUDBRB(1,N,-THEPY,0.0,0.0D0,0.0D0,0.0D0)

      PHI2PY=0.0
      IF (IL.GT.0) THEN
        PHI2PY=ULANGL(P(IL,1),P(IL,2))
        CALL LUDBRB(1,N,0.0,-PHI2PY,0.0D0,0.0D0,0.0D0)
      ENDIF

      RETURN

C**** END OF ARBOPY ****************************************************
      END
C***********************************************************************
C $Id: arcasc.f,v 3.9 1995/11/30 10:15:20 leif Exp $
CDECK  ID>, ARCASC.
      SUBROUTINE ARCASC

C...ARiadne subroutine perform dipole CASCade

C...Performs a colour dipole cascade on string put in the ariadne
C...event record.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/


C...Calculate total momentum of strings for debugging
      IF (MSTA(9).GT.0) CALL ARCHEM(1)

C...Reset counter
      IO=0
      NPTOT=0

C...Perform the evolution
      CALL AREVOL(SQRT(PT2LST),0.0)

C...Check momentum and dump to /LUJETS/
      IF (.NOT.QDUMP) CALL ARDUMP
      IF (MSTA(9).GT.0) CALL ARCHEM(0)

      RETURN

C**** END OF ARCASC ****************************************************
      END
C***********************************************************************
C $Id: arcasc.f,v 3.9 1995/11/30 10:15:20 leif Exp $
CDECK  ID>, ARCONT.
      SUBROUTINE ARCONT

C...ARiadne subroutine CONTinue dipole cascade

C...Continues a dipole cascade peviously started with ARCASC

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/


C...Perform the evolution
      CALL AREVOL(SQRT(PT2LST),0.0)

C...Check momentum and dump to /LUJETS/
      IF (.NOT.QDUMP) CALL ARDUMP
      IF (MSTA(9).GT.0) CALL ARCHEM(0)

      RETURN

C**** END OF ARCONT ****************************************************
      END
C***********************************************************************
C $Id: arcasc.f,v 3.9 1995/11/30 10:15:20 leif Exp $
CDECK  ID>, AREVOL.
      SUBROUTINE AREVOL(PTMAX,PTMIN)

C...ARiadne subroutine EVOLute with dipole emissions

C...Evolves a string in the ariadne event record using dipole
C...successive emissions between the scale PTMAX and PTMIN

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/


C...Set limits
      PT2LST=PTMAX**2
      PSAV3=PARA(3)
      PSAV5=PARA(5)
      PARA(3)=MAX(PARA(3),PTMIN)
      PARA(5)=MAX(PARA(5),PTMIN)
      QABOVE=(MSTA(35).GT.1.AND.PT2LST.GT.ABS(PHAR(112)).AND.
     $     PHAR(112).NE.0)

C...Loop over all dipole to find largest possible p_t^2
 100  ISEL=0
      IF (MSTA(35).GT.0.AND.(IO.GT.0.OR.MHAR(108).GT.0)) CALL AREARR
      PT2MAX=0.0
      DO 110 I=1,IDIPS
        PT2I=ARGPT2(I)
        IF (PT2I.GT.PT2MAX) THEN
          PT2MAX=PT2I
          ISEL=I
        ENDIF
 110  CONTINUE

C...Check that largest p_t^2 is above cuts.
      IF (ISEL.GT.0) THEN
        IF ((QEM(ISEL).AND.PT2MAX.LE.PARA(5)**2).OR.
     $     ((.NOT.QEM(ISEL)).AND.PT2MAX.LE.PARA(3)**2)) ISEL=0
      ENDIF

      IF (MSTA(6).GE.0.AND.IO.GE.MSTA(6)) ISEL=0

C...Check if reconnection between strings are possible.
      IF (QABOVE.AND.(PT2MAX.LT.ABS(PHAR(112)).OR.ISEL.EQ.0)) THEN
        QABOVE=.FALSE.
        DO 200 ID=1,IDIPS
          IF (QEM(ID)) GOTO 200
          ICOLI(ID)=MOD(ICOLI(ID),1000)
 200    CONTINUE
      ENDIF

C...Exit if below cuts or limit of number of emissions is reached
      IF (ISEL.EQ.0) THEN
        IF (MHAR(107).EQ.-1) THEN
          DO 210 ID=1,IDIPS
            IF (QEM(ID)) GOTO 210
            ICOLI(ID)=MOD(ICOLI(ID),1000)
 210      CONTINUE
        ENDIF
        IF (MSTA(35).NE.0) CALL AREARR
        PARA(3)=PSAV3
        PARA(5)=PSAV5
        RETURN
      ENDIF

C...Perform the emission
      IO=IO+1
      PT2LST=PT2MAX
      CALL AREMIT(ISEL)
      QDUMP=.FALSE.

C...Check total momentum and dump according to debug mode
      IF (MSTA(9).GT.2) CALL ARDUMP
      IF (MSTA(9).GT.1) CALL ARCHEM(0)
      GOTO 100

C**** END OF ARCASC ****************************************************
      END
C***********************************************************************
C $Id: archem.f,v 3.5 1994/05/11 07:10:12 lonnblad Exp $
CDECK  ID>, ARCHEM.
      SUBROUTINE ARCHEM(IMOD)

C...ARiadne subroutine CHEck Momentum conservation

C...Checks that momentum is conserved in ariadne

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARINT3/ DPTOT(5)
      SAVE /ARINT3/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/

      DIMENSION DTOT(5)


C...Reset momentum counter. Include Drell-Yan produced particle and
C...others in special positions if present and check its momentum
C...consistency.
      DO 100 J=1,4
        DTOT(J)=0.0D0
 100  CONTINUE
      DO 110 I=MAXPAR-4,MAXPAR-2
        IF (.NOT.QQ(I)) GOTO 110
        DO 120 J=1,4
          DTOT(J)=DTOT(J)+BP(I,J)
 120    CONTINUE
        IF (ABS(BP(I,4)**2-BP(I,3)**2-BP(I,2)**2-BP(I,1)**2-BP(I,5)**2)
     $         .GT.PARA(39)*BP(I,4)**2) CALL ARERRM('ARCHEM',10,I)
 110  CONTINUE
      
C...Sum all partons momentum and check their momentum concistency.
      DO 130 I=1,IPART
        DO 140 J=1,4
          DTOT(J)=DTOT(J)+BP(I,J)
 140    CONTINUE
        IF (ABS(BP(I,4)**2-BP(I,3)**2-BP(I,2)**2-BP(I,1)**2-BP(I,5)**2)
     $       .GT.PARA(39)*BP(I,4)**2.AND.MSTA(9).GE.2)
     $       CALL ARERRM('ARCHEM',10,I+N)
 130  CONTINUE
      DTOT(5)=DSQRT(MAX(DTOT(4)**2-DTOT(3)**2-DTOT(2)**2-DTOT(1)**2,
     $                  0.0D0))

C...If IMOD=1 save total momentum for later use
      IF (IMOD.EQ.1) THEN
        DO 200 J=1,5
          DPTOT(J)=DTOT(J)
 200    CONTINUE
        RETURN
      ENDIF

C...IF IMOD=1 compare total momentum with old one
      DIFF=0.0D0
      DO 300 J=1,5
        DIFF=DIFF+(DTOT(J)-DPTOT(J))**2
 300  CONTINUE
      IF (DIFF.GT.(DPTOT(5)*PARA(39))**2) CALL ARERRM('ARCHEM',9,0)

      RETURN

C**** END OF ARCHEM ****************************************************
      END
C***********************************************************************
C $Id: arclus.f,v 3.4 1994/05/11 07:10:14 lonnblad Exp $
CDECK  ID>, ARCLUS.
      SUBROUTINE ARCLUS(NJET)

C...ARiadne subroutine jet CLUStering

C...Clusters particle in the /LUJETS/ common block into jets according
C...the dipole clustering algorithm.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/


C...Reset error flag.
      MSTA(13)=0

C...Copy all particle to be considered as jet-initiators to the end
C...of the event record.
      CALL ARCOPJ

C...The total number of jetinitiators = current number of jets.
      I1=0
      I3=0

      IF (IDIPS.LT.MAX(MSTU(47),2)) THEN
        CALL ARORDJ(NJET)
        NJET=-1
        RETURN
      ENDIF

C...Loop over all possible three-jets to find the three jets with
C...smallest invariant p_t^2

C...Exit if minimum number of jets reached
 100  IF (IDIPS.EQ.2) THEN
        CALL ARORDJ(NJET)
        RETURN
      ENDIF

      J1=0
      J2=0
      J3=0
      PT2MIN=PARA(31)

      DO 110 I2=1,IPART
        IF (QDONE(I2)) GOTO 110
        CALL ARUPDJ(I2,I1,I3)
        IF (PT2IN(I2).LT.PT2MIN) THEN
          J1=IDI(I2)
          J2=I2
          J3=IDO(I2)
          PT2MIN=PT2IN(I2)
        ENDIF
 110  CONTINUE

      PARU(63)=SQRT(PT2MIN)

C...Exit if smallest p_t^2 is above cutoff 
      IF (J1.EQ.0.OR.IDIPS.EQ.MAX(MSTU(47),2)) THEN
        CALL ARORDJ(NJET)
        RETURN
      ENDIF

C...Else join the three jets into two and redo the procedure.
      CALL ARJOIN(J1,J2,J3)
      I1=J1
      I3=J3

      GOTO 100

C**** END OF ARCLUS ****************************************************
      END
C***********************************************************************
C $Id: arcopa.f,v 3.10 1995/08/13 17:29:02 lonnblad Exp $
CDECK  ID>, ARCOPA.
      SUBROUTINE ARCOPA(IJ,IP,ITYP)

C...ARiadne subroutine COpy PArton

C...Copies a parton from position IJ in /LUJETS/ common block to
C...Position IP in /ARPART/ common block.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/


      DO 100 I=1,5
        BP(IP,I)=P(IJ,I)
 100  CONTINUE

      IFL(IP)=K(IJ,2)
      IEX=MOD(K(IJ,4),10)
      IF (IEX.NE.0) THEN
        QEX(IP)=.TRUE.
        IF (PARA(10+IEX).GT.0.0) THEN
          XPMU(IP)=PARA(10+IEX)
        ELSE
          XPMU(IP)=V(IJ,4)
        ENDIF
        XPA(IP)=PARA(10)
      ELSE
        QEX(IP)=.FALSE.
        XPMU(IP)=0.0
        XPA(IP)=0.0
      ENDIF
        
      QQ(IP)=(ITYP.NE.2)
      INO(IP)=0
      INQ(IP)=0
      IDI(IP)=0
      IDO(IP)=0
      IF (MSTA(1).EQ.2) INQ(IP)=-IJ
      PT2GG(IP)=0.0
      K(IJ,4)=-IP
     
      RETURN

C**** END OF ARCOPA ****************************************************
      END
C***********************************************************************
C $Id: arcopj.f,v 3.5 1994/05/11 07:10:15 lonnblad Exp $
CDECK  ID>, ARCOPJ.
      SUBROUTINE ARCOPJ

C...ARiadne subroutine COPy Jet

C...Copies particles into jet initiators in /LUCLUS/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      COMMON/GUDAT2/KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
      INTEGER  KCHG
      REAL  PMAS,PARF,VCKM
      SAVE /GUDAT2/
**JWG  add psi'(3685) as KC code 80, needed for Eurodec interface
*      --- ---------- -- -- ---- --- ------ --- ------- ---------
      INTEGER  IDPSIP
      PARAMETER  (IDPSIP=80)

      DIMENSION DSUMP(5)


C...If continuing jet clustering return immediately
      IF (MSTU(48).EQ.1.AND.IPART.GT.0) RETURN

C...Reset momentum sum
      DO 100 J=1,4
        DSUMP(J)=0.0
 100  CONTINUE

C...Reset jet counter
      IPART=0

C...Loop over all particles in the event record
      DO 300 I=1,N

C...Disregard all decayed particles and unknown entries
        IF (K(I,1).LE.0.OR.K(I,1).GE.10) GOTO 300

C...Disregard neutrinos and neutral particles according to MSTU(41)
        IF (MSTU(41).GE.2) THEN
          KC=LUCOMP(K(I,2))
          IF (KC.EQ.0.OR.KC.EQ.12.OR.KC.EQ.14
     $         .OR.KC.EQ.16.OR.KC.EQ.18) 
     $      GOTO 300
          IF (MSTU(41).GE.3.AND.KCHG(KC,2).EQ.0.AND.
     $         LUCHGE(K(I,2)).EQ.0)
     $      GOTO 300
        ENDIF

        IF (IPART.GE.MAXPAR.OR.IPART.GE.MAXDIP) THEN
          CALL ARERRM('ARCOPJ',21,0)
          IPART=0
          RETURN
        ENDIF

C...Tag found jet-initiator
        IPART=IPART+1
        DO 400 J=1,5
          BP(IPART,J)=P(I,J)
          DSUMP(J)=DSUMP(J)+BP(IPART,J)
 400    CONTINUE
        PT2IN(IPART)=0.0
        BX1(IPART)=BP(IPART,5)**2
        QDONE(IPART)=.FALSE.
        IDI(IPART)=0
        IDO(IPART)=0
 300  CONTINUE

      IDIPS=IPART
      MSTU(62)=IPART
      PARU(61)=SQRT(MAX(0.0D0,DSUMP(4)**2-
     $     DSUMP(3)**2-DSUMP(2)**2-DSUMP(1)**2))

      RETURN

C**** END OF ARCOPJ ****************************************************
      END
C***********************************************************************
C $Id: arcrdi.f,v 3.2 1995/06/07 09:19:17 lonnblad Exp $
CDECK  ID>, ARCRDI.
      SUBROUTINE ARCRDI(ID,IPA1,IPA3,IS,QED)

C...ARiadne subroutine CReate DIpole

C...Creates a dipole from partons IPA1 and IPA3

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/


      IDO(IPA1)=ID
      IDI(IPA3)=ID
      IP1(ID)=IPA1
      IP3(ID)=IPA3
      ISTR(ID)=IS
      QDONE(ID)=.FALSE.
      QEM(ID)=QED
      ICOLI(ID)=0

      RETURN

C**** END OF ARCRDI ****************************************************
      END
C***********************************************************************
C $Id: ardump.f,v 3.7 1994/05/16 11:02:32 lonnblad Exp $
CDECK  ID>, ARDUMP.
      SUBROUTINE ARDUMP

C...ARiadne subroutine DUMP 

C...Dumps the entries in /ARPART/ into /LUJETS/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/

      INXT(I)=IP3(IDO(I))


C...Loop over all strings in dipole record
      DO 200 IS=1,ISTRS

C...Loop over all particles in each string
        I=IPF(IS)
 210    N=N+1
        DO 220 J=1,5
          P(N,J)=BP(I,J)
          V(N,J)=V(IMF,J)
 220    CONTINUE
        K(N,2)=IFL(I)
        K(N,3)=IMF
        K(N,4)=-I
        K(N,5)=INO(I)
        IF (I.EQ.IPL(IS).AND.IFLOW(IS).NE.2) THEN
          K(N,1)=1
        ELSEIF (IFLOW(IS).EQ.2.AND.INXT(I).EQ.IPF(IS)) THEN
          K(N,1)=1
        ELSE
          K(N,1)=2
          I=INXT(I)
          GOTO 210
        ENDIF
 200  CONTINUE

      IEXTRA=0
      DO 250 I=MAXPAR-4,MAXPAR-3
        IF (.NOT.QQ(I)) GOTO 250
        IEXTRA=IEXTRA+1
        N=N+1
        DO 260 J=1,5
          P(N,J)=BP(I,J)
          V(N,J)=V(IMF,J)
 260    CONTINUE
        K(N,1)=1
        K(N,2)=IFL(I)
        K(N,3)=IMF
        K(N,4)=-I
        K(N,5)=0
 250  CONTINUE

C...Set pointers to cascaded string and fix complex remnant
      IMFNEW=N+1-IPART-IEXTRA
      IMLNEW=N

C...Tag particles in old string with pointers to cascaded string 
      DO 100 I=1,IML
        IF (K(I,1).LT.10.AND.K(I,4).LT.0) THEN
          K(I,1)=K(I,1)+10
          K(I,4)=IMFNEW
          K(I,5)=IMLNEW
        ENDIF
 100  CONTINUE

      IMF=IMFNEW
      IML=IMLNEW
      QDUMP=.TRUE.

C...Check if Drell-Yan particle is present
      IF (QQ(MAXPAR-2)) THEN
        IDY=IDI(MAXPAR-2)
        DO 300 J=1,5
          P(IDY,J)=BP(MAXPAR-2,J)
 300    CONTINUE
      ENDIF

      RETURN

C**** END OF ARDUMP ****************************************************
      END
C***********************************************************************
C $Id: arduph.f,v 3.1 1994/05/11 07:10:18 lonnblad Exp $
CDECK  ID>, ARDUPH.
      SUBROUTINE ARDUPH

C...ARiadne subroutine DUmp PHoton

C...Moves photon emitted by Ariadne to /LUJETS/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARINT3/ DPTOT(5)
      SAVE /ARINT3/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/


      N=N+1
      DO 100 I=1,5
        P(N,I)=BP(IPART+1,I)
        DPTOT(I)=DPTOT(I)-BP(IPART+1,I)
        V(N,I)=V(IMF,I)
 100  CONTINUE

      DPTOT(5)=DSQRT(DPTOT(4)**2-DPTOT(3)**2-DPTOT(2)**2-DPTOT(1)**2)

      K(N,1)=1
      K(N,2)=22
      K(N,3)=IMF
      K(N,4)=0
      K(N,5)=IO

      RETURN

C**** END OF ARDUPH ****************************************************
      END
C***********************************************************************
C $Id: ardyre.f,v 3.10 1995/08/13 17:29:03 lonnblad Exp $
CDECK  ID>, ARDYRE.
      REAL FUNCTION ARDYRE(IDE,BW,QRG1,QRG3)

C...ARiadne subroutine Drell-Yan REcoil treatment

C...Transfers the recoil of an emission to a Drell-Yan produced
C...particle if the emission and the particle are in the same
C...phase space region.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT2/ DBEX,DBEY,DBEZ,PHI,THE
      SAVE /ARINT2/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/


      ARDYRE=-1.0

      QEXDY=((ABS(MHAR(123)).EQ.1.AND.IO.EQ.1).OR.MHAR(123).GT.1.OR.
     $     (MHAR(131).NE.0.AND.IO.EQ.1.AND.MHAR(132).EQ.1))

C...Check if there are recoil gluons
      IF (MSTA(22).EQ.0) RETURN
      IF (MSTA(22).LT.0.AND.(.NOT.QEXDY)
     $     .AND.(.NOT.QRG1).AND.(.NOT.QRG3)) RETURN

C...Locate Drell-Yan produced particle (IDY) and boost it to CMS 
C...of dipole
      IDY=MAXPAR-2
      CALL AROBO1(0.0,0.0,-DBEX,-DBEY,-DBEZ,IDY)
      CALL AROBO1(0.0,-PHI,0.0D0,0.0D0,0.0D0,IDY)
      CALL AROBO1(-THE,0.0,0.0D0,0.0D0,0.0D0,IDY)
      BZP=BP(IDY,4)+BP(IDY,3)
      BZM=BP(IDY,4)-BP(IDY,3)
      BZX=BP(IDY,1)
      BZY=BP(IDY,2)

C...Boost Gluon and check if we have overlap
      IG=IP3(IDE)
      CALL AROBO1(0.0,0.0,-DBEX,-DBEY,-DBEZ,IG)
      CALL AROBO1(0.0,-PHI,0.0D0,0.0D0,0.0D0,IG)
      CALL AROBO1(-THE,0.0,0.0D0,0.0D0,0.0D0,IG)
      BGP=BP(IG,4)+BP(IG,3)
      BGM=BP(IG,4)-BP(IG,3)

C...Check if we are inside D-Y triangle
      BFUZZ=SQRT(BZP*BZM)*PHAR(105)*LOG(RLU(0))
      IF (ABS(MSTA(22)).LT.3.AND.(.NOT.QEXDY).AND.
     $     (BGP+BFUZZ.GT.BZP.OR.BGM+BFUZZ.GT.BZM)) THEN
        CALL AROBO2(THE,PHI,DBEX,DBEY,DBEZ,IG,IDY)
        RETURN
      ENDIF
      IF (ABS(MSTA(22)).EQ.3.AND.(.NOT.QEXDY).AND.
     $     BGP+BFUZZ.GT.BZP.AND.BGM+BFUZZ.GT.BZM) THEN
        CALL AROBO2(THE,PHI,DBEX,DBEY,DBEZ,IG,IDY)
        RETURN
      ENDIF

      I1=IP1(IDE)
      IF (QRG1) I1=IP1(IDI(I1))
      I3=IP3(IDO(IG))
      IF (QRG3) I3=IP3(IDO(I3))

      CALL AROBO2(0.0,0.0,-DBEX,-DBEY,-DBEZ,I1,I3)
      CALL AROBO2(0.0,-PHI,0.0D0,0.0D0,0.0D0,I1,I3)
      CALL AROBO2(-THE,0.0,0.0D0,0.0D0,0.0D0,I1,I3)

      BSX=BZX-BP(IG,1)
      BSY=BZY-BP(IG,2)
      B1X=0.0
      B1Y=0.0
      IF (.NOT.QRG1.AND.MSTA(22).LT.0) THEN
        B1X=BP(I1,1)
        B1Y=BP(I1,2)
        BSX=BSX-B1X
        BSY=BSY-B1Y
      ENDIF
      B3X=0.0
      B3Y=0.0
      IF (.NOT.QRG3.AND.MSTA(22).LT.0) THEN
        B3X=BP(I3,1)
        B3Y=BP(I3,2)
        BSX=BSX-B3X
        BSY=BSY-B3Y
      ENDIF

      BA2=(BP(IDY,5)**2+BSX**2+BSY**2)/(BZP*BZM)
      IF (BA2.LE.0.0) GOTO 900
      BA=SQRT(BA2)
      BNZP=BA*BZP
      BNZM=BA*BZM

      BTP=BW+BZP-BGP-BNZP
      BTM=BW+BZM-BGM-BNZM
      IF (BTP.LE.0.0.OR.BTM.LE.0.0) GOTO 900
      B1T2=B1X**2+B1Y**2+BP(I1,5)**2
      B3T2=B3X**2+B3Y**2+BP(I3,5)**2
      BARG=(B1T2-B3T2+BTP*BTM)**2-4.0*BTP*BTM*B1T2
      IF (BARG.LT.0) GOTO 900
      B1P=0.5*(B1T2-B3T2+BTP*BTM+SQRT(BARG))/BTM
      IF (B1P**2.LE.B1T2) GOTO 900
      B1M=B1T2/B1P
      BARG=(B3T2-B1T2+BTP*BTM)**2-4.0*BTP*BTM*B3T2
      IF (BARG.LT.0) GOTO 900
      B3M=0.5*(B3T2-B1T2+BTP*BTM+SQRT(BARG))/BTP
      IF (B3M**2.LE.B3T2) GOTO 900
      B3P=B3T2/B3M

      IF (ABS(MSTA(22)).EQ.2) THEN
        IF (QRG1.AND.B1P.LT.BP(I1,4)+BP(I1,3)) GOTO 900
        IF (QRG3.AND.B3M.LT.BP(I3,4)-BP(I3,3)) GOTO 900
      ENDIF

      IF (QRG1) THEN
        CALL ARREMG(IP1(IDE))
        QRG1=.FALSE.
        ID=IDO(I1)
        IDE=ID
        IG=IP3(ID)
        I3=IP3(IDO(IG))
        IF (QRG3) I3=IP3(IDO(I3))
      ENDIF
      IF (QRG3) THEN
        CALL ARREMG(IP3(IDO(IG)))
        ID=IDO(I1)
        IDE=ID
        IG=IP3(ID)
        I3=IP3(IDO(IG))
        QRG3=.FALSE.
      ENDIF

      BP(I1,1)=B1X
      BP(I1,2)=B1Y
      BP(I1,3)=0.5*(B1P-B1M)
      BP(I1,4)=0.5*(B1P+B1M)

      BP(I3,1)=B3X
      BP(I3,2)=B3Y
      BP(I3,3)=0.5*(B3P-B3M)
      BP(I3,4)=0.5*(B3P+B3M)

      BP(IDY,1)=BSX
      BP(IDY,2)=BSY
      BP(IDY,3)=0.5*(BNZP-BNZM)
      BP(IDY,4)=0.5*(BNZP+BNZM)

      ARDYRE=1.0

 900  CALL AROBO4(THE,PHI,DBEX,DBEY,DBEZ,IG,I1,I3,IDY)

      RETURN

C**** END OF ARDYRE ****************************************************
      END
C***********************************************************************
C $Id: aremit.f,v 3.12 1995/08/13 17:29:06 lonnblad Exp $
CDECK  ID>, AREMIT.
      SUBROUTINE AREMIT(ID)

C...ARiadne subroutine EMIT

C...Administers the an emission from dipole ID

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/

      INXT(I)=IDO(IP3(I))

      IF (MHAR(101).EQ.2) THEN
        CALL AREMI3(ID)
        RETURN
      ELSEIF (MSTA(32).GT.1.OR.MHAR(101).EQ.1) THEN
        CALL AREMI2(ID)
        RETURN
      ENDIF

C...If FSR photon emission go a head
      IF (QEM(ID)) THEN
        CALL ARRADP(ID)
        RETURN

C...If q-qbar splitting go a head
      ELSEIF (IRAD(ID).NE.0) THEN
        CALL ARRADQ(ID)
        RETURN

C...If gluon emission from point-like dipole or if no p_t-ordered
C...recoil gluon, go a head
      ELSEIF (((.NOT.QEX(IP1(ID))).AND.(.NOT.QEX(IP3(ID))))
     $             .OR.MSTA(18).EQ.0) THEN
        CALL ARRADG(ID,0,SNR,PT21,PT23)
        RETURN
      ENDIF

C...If p_t-ordered recoil gluon, first save initial configuration
C...Then perform trial emission
      CALL ARSTOR(ID,IDS,IS1,IS3)
      CALL ARRADG(ID,0,SNR,PT21,PT23)

C...If no recoil gluon was produces keep trial emission
      IF (SNR.LE.1.0) RETURN

C...If two recoil gluons, tag the smallest one for p_t-ordering
      IF (AEX1(ID).LT.1.0.AND.AEX3(ID).LT.1.0) THEN
        INEWD=3
        IF ((MSTA(17).GE.2.AND.PT21.GE.PT23).OR.
     $       (MSTA(17).LT.2.AND.BX3(ID).GE.BX1(ID))) THEN
          IGR=3
        ELSE
          IGR=1
        ENDIF

C...If only one recoil gluon, tag it for p_t-ordering
      ELSEIF (AEX1(ID).LT.1.0.AND.AEX3(ID).GE.1.0) THEN
        IGR=1
        INEWD=2
      ELSEIF (AEX1(ID).GE.1.0.AND.AEX3(ID).LT.1.0) THEN
        IGR=3
        INEWD=2
      ENDIF

      IDT=MAXDIP-1

C...Calculate the p_t^2 of a possibly earlier emission in place
C...of the recoil gluon. If this p_t^2 is lower than that of the
C...recoil gluon it could not have been emitted earlier and hence
C...the recoil gluon from the trial emission is kept.
      IF (IGR.EQ.1) THEN
        QABOVE=((MSTA(18).GT.2.OR.PT21.GT.PARA(3)**2).AND.
     $       (MSTA(18).GT.1.OR.PT21.GT.XPMU(IS1)**2))
        S=SNR
        XT2MP=PT2IN(IDS)/SNR
        QQ1=QQ(IS1)
        QQ3=.FALSE.
        QE1=QEX(IS1)
        QE3=.FALSE.
        XT2GG3=XT2MP
        XT2GG1=-1.0
        IF ((.NOT.QQ1).AND.(.NOT.QE1)) THEN
          XT2GG1=XT2MP
          IF(INO(IS1).NE.0) XT2GG1=PT2GG(IS1)
        ENDIF
        ALP1=XPA(IS1)
        ALP3=0.0
        XMU1=XPMU(IS1)
        XMU3=0.0
        SY1=BP(IS1,5)/SQRT(SNR)
        SY3=0.0
        IFL1=IFL(IS1)
        IFL3=21
        CALL ARGQCD(-IDT)
        IF (PT2IN(IDT).LT.PT21.AND.QABOVE) RETURN
      ELSE
        QABOVE=((MSTA(18).GT.2.OR.PT23.GT.PARA(3)**2).AND.
     $       (MSTA(18).GT.1.OR.PT23.GT.XPMU(IS3)**2))
        S=SNR
        IF (INO(IS3).NE.0) XT2GG3=PT2GG(IS3)
        QQ1=.FALSE.
        QQ3=QQ(IS3)
        QE1=.FALSE.
        QE3=QEX(IS3)
        XT2GG1=XT2MP
        XT2GG3=-1.0
        IF ((.NOT.QQ3).AND.(.NOT.QE3)) THEN
          XT2GG3=XT2MP
          IF(INO(IS3).NE.0) XT2GG3=PT2GG(IS3)
        ENDIF
        ALP1=0.0
        ALP3=XPA(IS3)
        XMU1=0.0
        XMU3=XPMU(IS3)
        SY1=0.0
        SY3=BP(IS3,5)/SQRT(SNR)
        IFL1=21
        IFL3=IFL(IS3)
        CALL ARGQCD(-IDT)
        IF (PT2IN(IDT).LT.PT23.AND.QABOVE) RETURN
      ENDIF

C...A gluon can be emittes in place of the recoil gluon at an earlier 
C...time. Recall the initial configuration and redo the emission without
C...recoil gluon
      CALL ARRECA(ID,IDS,IS1,IS3)

      IDIPS=IDIPS-INEWD
      IPART=IPART-INEWD
      CALL ARRADG(ID,IGR,SNREF,PT21,PT23)

C...Set p_t^2 for the emission in place of the recoil gluon
      IDS=ID
      IF (IGR.EQ.3) THEN
        IDS=INXT(ID)
        IF (INEWD.EQ.3.AND.PT21.GT.0.0) IDS=INXT(IDS)
      ENDIF

      CALL ARSTOR(IDS,IDSS,ISS1,ISS3)
      IP1(IDSS)=ISS1
      IP3(IDSS)=ISS3
      CALL ARBOCM(IDSS)

      QDONE(IDS)=.TRUE.
      SDIP(IDS)=ARMAS2(ISS1,ISS3)
      BX1(IDS)=BX1(IDT)
      BX3(IDS)=BX3(IDT)
      AEX1(IDS)=AEX1(IDT)
      AEX3(IDS)=AEX3(IDT)
      IRAD(IDS)=IRAD(IDT)
      PT2IN(IDS)=PT2IN(IDT)

      CALL ARCHKI(IDS,IOK)
      IF (IOK.EQ.0.AND.PT2IN(IDS).GT.PARA(3)**2) THEN
        QDONE(IDS)=.FALSE.
      ENDIF

      RETURN

C**** END OF AREMIT ****************************************************
      END
C***********************************************************************
C $Id: aremit.f,v 3.12 1995/08/13 17:29:06 lonnblad Exp $
CDECK  ID>, AREMI2.
      SUBROUTINE AREMI2(ID)

C...ARiadne subroutine EMIT version 2

C...Administers the an emission from dipole ID

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/

      DIMENSION IPEM1(MAXPAR),IPEM2(MAXPAR),IDEM1(MAXDIP),IDEM2(MAXDIP)

      INXT(I)=IDO(IP3(I))

C...IF Initial state gluon splitting, go ahead.
      IF (IO.EQ.1) MHAR(121)=2
      IF (IRAD(ID).GT.10000) THEN
        IF (IO.EQ.1) MHAR(121)=3
        CALL ARADIG(ID)
        GOTO 990
      ENDIF

C...Reset initial state gluon splitting generation
      PT2GG(MAXPAR-3)=-1.0
      PT2GG(MAXPAR-4)=-1.0
      NPTOT=0

C...If FSR photon emission go a head
      IF (QEM(ID)) THEN
        IF (IO.EQ.1) MHAR(121)=1
        CALL ARRADP(ID)
        RETURN

C...If q-qbar splitting go a head
      ELSEIF (IRAD(ID).NE.0) THEN
        IF (IO.EQ.1) MHAR(121)=4
        CALL ARRADQ(ID)
        RETURN

C...If gluon emission from point-like dipole or if no p_t-ordered
C...recoil gluon, go a head
      ELSEIF (((.NOT.QEX(IP1(ID))).AND.(.NOT.QEX(IP3(ID))))
     $             .OR.MSTA(18).EQ.0) THEN
        CALL ARRADG(ID,0,SNR,PT21,PT23)
        GOTO 990
      ENDIF

C...If p_t-ordered recoil gluon, first save initial configuration
C...Then perform trial emission
      
      NPEM1=0
      NDEM1=0
      CALL ARPADO(IP1(ID),NPEM1,IPEM1)
      CALL ARPADO(IP3(ID),NPEM1,IPEM1)
      CALL ARPADO(ID,NDEM1,IDEM1)
      CALL ARCODI(ID,IDS,IS1,IS3)
      NPEM2=0
      NDEM2=0
      CALL ARPADO(IS1,NPEM2,IPEM2)
      CALL ARPADO(IS3,NPEM2,IPEM2)
      CALL ARPADO(IDS,NDEM2,IDEM2)
      NPSAV=IPART
      NDSAV=IDIPS
      IPP1=IP1(ID)
      IPP3=IP3(ID)
      CALL ARRADG(ID,0,SNR,PT21,PT23)
      DO 100 I=NPSAV+1,IPART
        CALL ARPADO(I,NPEM1,IPEM1)
 100  CONTINUE
      DO 110 I=NDSAV+1,IDIPS
        CALL ARPADO(I,NDEM1,IDEM1)
 110  CONTINUE

C...If no recoil gluon was produces keep trial emission
      IF (SNR.LE.1.0) GOTO 910

C...If two recoil gluons, tag the smallest one for p_t-ordering
      IF (AEX1(ID).LT.1.0.AND.AEX3(ID).LT.1.0) THEN
        IF ((MSTA(17).GE.2.AND.PT21.GE.PT23).OR.
     $       (MSTA(17).LT.2.AND.BX3(ID).GE.BX1(ID))) THEN
          IGR=3
          PT2RG=PT23
        ELSE
          IGR=1
          PT2RG=PT21
        ENDIF

C...If only one recoil gluon, tag it for p_t-ordering
      ELSEIF (AEX1(ID).LT.1.0.AND.AEX3(ID).GE.1.0) THEN
        IGR=1
        PT2RG=PT21
      ELSEIF (AEX1(ID).GE.1.0.AND.AEX3(ID).LT.1.0) THEN
        IGR=3
        PT2RG=PT23
      ENDIF

      NPSAV=IPART
      NDSAV=IDIPS
      CALL ARRADG(IDS,IGR,SNREF,PT21,PT23)
      DO 120 I=NPSAV+1,IPART
        CALL ARPADO(I,NPEM2,IPEM2)
 120  CONTINUE
      DO 130 I=NDSAV+1,IDIPS
        CALL ARPADO(I,NDEM2,IDEM2)
 130  CONTINUE

      IF (IGR.EQ.1) THEN
        IDT=IDO(IS1)
      ELSE
        IDT=IDI(IS3)
      ENDIF

      NPTOT=0
      DO 200 I=1,IPART
        DO 210 J=1,NPEM1
          IF (IPEM1(J).EQ.I) GOTO 200
 210    CONTINUE
        CALL ARPADD(I,NPTOT,IPTOT)
 200  CONTINUE
      IF (QQ(MAXPAR-3)) THEN
        IF (INQ(MAXPAR-3).EQ.IPP1) INQ(MAXPAR-3)=IS1
        IF (INQ(MAXPAR-3).EQ.IPP3) INQ(MAXPAR-3)=IS3
        IF (IDI(MAXPAR-3).EQ.IPP1) IDI(MAXPAR-3)=IS1
        IF (IDI(MAXPAR-3).EQ.IPP3) IDI(MAXPAR-3)=IS3
      ENDIF
      IF (QQ(MAXPAR-4)) THEN
        IF (INQ(MAXPAR-4).EQ.IPP1) INQ(MAXPAR-4)=IS1
        IF (INQ(MAXPAR-4).EQ.IPP3) INQ(MAXPAR-4)=IS3
        IF (IDI(MAXPAR-4).EQ.IPP1) IDI(MAXPAR-4)=IS1
        IF (IDI(MAXPAR-4).EQ.IPP3) IDI(MAXPAR-4)=IS3
      ENDIF

      IF (ARGPT2(IDT).GT.PT2RG) GOTO 900

      IF (QQ(MAXPAR-3)) THEN
        IF (INQ(MAXPAR-3).EQ.IS1) INQ(MAXPAR-3)=IPP1
        IF (INQ(MAXPAR-3).EQ.IS3) INQ(MAXPAR-3)=IPP3
        IF (IDI(MAXPAR-3).EQ.IS1) IDI(MAXPAR-3)=IPP1
        IF (IDI(MAXPAR-3).EQ.IS3) IDI(MAXPAR-3)=IPP3
      ENDIF
      IF (QQ(MAXPAR-4)) THEN
        IF (INQ(MAXPAR-4).EQ.IS1) INQ(MAXPAR-4)=IPP1
        IF (INQ(MAXPAR-4).EQ.IS3) INQ(MAXPAR-4)=IPP3
        IF (IDI(MAXPAR-4).EQ.IS1) IDI(MAXPAR-4)=IPP1
        IF (IDI(MAXPAR-4).EQ.IS3) IDI(MAXPAR-4)=IPP3
      ENDIF
 910  DO 300 I=NPEM2,1,-1
        CALL ARREMP(IPEM2(I))
 300  CONTINUE
      DO 310 I=NDEM2,1,-1
        CALL ARREMD(IDEM2(I))
 310  CONTINUE
      PT2GG(MAXPAR-3)=-1.0
      PT2GG(MAXPAR-4)=-1.0
      NPTOT=0

      GOTO 990

 900  IF (IDI(IPP1).GT.0) IP3(IDI(IPP1))=IS1
      IF (IDO(IPP3).GT.0) IP1(IDO(IPP3))=IS3
      DO 320 IS=1,ISTRS
        IF (IPF(IS).EQ.IPP1) IPF(IS)=IS1
        IF (IPF(IS).EQ.IPP3) IPF(IS)=IS3
        IF (IPL(IS).EQ.IPP1) IPL(IS)=IS1
        IF (IPL(IS).EQ.IPP3) IPL(IS)=IS3
 320  CONTINUE
      DO 330 I=NPEM1,1,-1
        CALL ARREMP(IPEM1(I))
 330  CONTINUE
      DO 340 I=NDEM1,1,-1
        CALL ARREMD(IDEM1(I))
 340  CONTINUE
      DO 350 I=1,IPART
        IPTOT(I)=I
 350  CONTINUE
      NPTOT=IPART

 990  CONTINUE

      RETURN

C**** END OF AREMI2 ****************************************************
      END
C***********************************************************************
C $Id: aremit.f,v 3.12 1995/08/13 17:29:06 lonnblad Exp $
CDECK  ID>, AREMI3.
      SUBROUTINE AREMI3(ID)

C...ARiadne subroutine EMIT version 3

C...Administers the an emission from dipole ID

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/


C...Save the event record in case we want to throw
      NFIRST=IPART+1
      IPP1=IP1(ID)
      IPP3=IP3(ID)
      JRAD=IRAD(ID)
      CALL ARPUTR(1)

C...IF Initial state gluon splitting, go ahead.
      IF (IO.EQ.1) MHAR(121)=2
      IF (IRAD(ID).GT.10000) THEN
        IF (IO.EQ.1) MHAR(121)=3
        CALL ARADIG(ID)
        GOTO 900
      ENDIF

C...Reset initial state gluon splitting generation
      PT2GG(MAXPAR-3)=-1.0
      PT2GG(MAXPAR-4)=-1.0
      NPTOT=0

C...If FSR photon emission go a head
      IF (QEM(ID)) THEN
        IF (IO.EQ.1) MHAR(121)=1
        CALL ARRADP(ID)
        GOTO 900

C...If q-qbar splitting go a head
      ELSEIF (IRAD(ID).NE.0) THEN
        IF (IO.EQ.1) MHAR(121)=4
        CALL ARRADQ(ID)
        GOTO 900

C...If gluon emission from point-like dipole or if no p_t-ordered
C...recoil gluon, go a head
      ELSEIF (((.NOT.QEX(IP1(ID))).AND.(.NOT.QEX(IP3(ID))))
     $             .OR.MSTA(18).EQ.0) THEN
        CALL ARRADG(ID,0,SNR,PT21,PT23)
        GOTO 900
      ENDIF

C...If p_t-ordered recoil gluon, first save initial configuration
C...Then perform trial emission
      
      CALL ARRADG(ID,0,SNR,PT21,PT23)

C...If no recoil gluon was produces keep trial emission
      IF (SNR.LE.1.0) GOTO 900

C...If two recoil gluons, tag the smallest one for p_t-ordering
      IF (AEX1(ID).LT.1.0.AND.AEX3(ID).LT.1.0) THEN
        IF ((MSTA(17).GE.2.AND.PT21.GE.PT23).OR.
     $       (MSTA(17).LT.2.AND.BX3(ID).GE.BX1(ID))) THEN
          IGR=3
          PT2RG=PT23
        ELSE
          IGR=1
          PT2RG=PT21
        ENDIF

C...If only one recoil gluon, tag it for p_t-ordering
      ELSEIF (AEX1(ID).LT.1.0.AND.AEX3(ID).GE.1.0) THEN
        IGR=1
        PT2RG=PT21
      ELSEIF (AEX1(ID).GE.1.0.AND.AEX3(ID).LT.1.0) THEN
        IGR=3
        PT2RG=PT23
      ENDIF

      QTHR2=(ARTHRW(ID,JRAD,IPP1,IPP3,NFIRST,IPART).LT.0)

      CALL ARPUTR(2)
      CALL ARGETR(1)
      IS1=IP1(ID)
      IS3=IP3(ID)
      CALL ARRADG(ID,IGR,SNREF,PT21,PT23)

      IF (IGR.EQ.1) THEN
        IDT=IDO(IS1)
      ELSE
        IDT=IDI(IS3)
      ENDIF

      QTHR3=(ARTHRW(ID,JRAD,IPP1,IPP3,NFIRST,IPART).LT.0)
      IF (QTHR3.AND.QTHR2) THEN
        CALL ARGETR(1)
        IO=IO-1
        QDONE(ID)=.FALSE.
      ELSEIF (QTHR2.AND.(.NOT.QTHR3)) THEN
        CALL ARGETR(2)
      ELSEIF ((.NOT.QTHR2).AND.(.NOT.QTHR3)) THEN
        IF (ARGPT2(IDT).LE.PT2RG) CALL ARGETR(2)
      ENDIF
      RETURN

 900  IF (ARTHRW(ID,JRAD,IPP1,IPP3,NFIRST,IPART).LT.0) THEN
        CALL ARGETR(1)
        IO=IO-1
        QDONE(ID)=.FALSE.
      ENDIF

      RETURN

C**** END OF AREMI3 ****************************************************
      END
C***********************************************************************
C $Id: arerrm.f,v 3.6 1995/08/13 17:29:08 lonnblad Exp $
CDECK  ID>, ARERRM.
      SUBROUTINE ARERRM(SUB,IERR,ILINE)

C...ARiadne subroutine ERRor Message

C...Writes out an error message and optionally terminates the program

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARDAT3/ IWRN(40)
      SAVE /ARDAT3/

      CHARACTER SUB*(*)


C...Write out common message
      IF (IWRN(IERR).LT.MSTA(10)) WRITE(MSTA(8),1000) SUB,IERR,MSTA(4)
      MSTA(13)=IERR
      IWRN(IERR)=IWRN(IERR)+1
      IFATAL=0
      IDUMP=0

C...Check error code and write appropriate message
      IF (IERR.EQ.1) THEN
        WRITE(MSTA(8),1010)
        WRITE(MSTA(8),1001) ILINE
        IFATAL=1
        IDUMP=1
      ELSEIF (IERR.EQ.2) THEN
        WRITE(MSTA(8),1020)
        WRITE(MSTA(8),1001) ILINE
        IFATAL=1
        IDUMP=1
      ELSEIF (IERR.EQ.3) THEN
        IF (IWRN(3).GT.MSTA(10)) RETURN
        IWRN(3)=IWRN(3)+1
        WRITE(MSTA(8),1030)
        IF (IWRN(3).EQ.MSTA(10)) THEN
          WRITE(MSTA(8),1001) ILINE
          IDUMP=1
        ENDIF
      ELSEIF (IERR.EQ.4) THEN
        WRITE(MSTA(8),1040)
        WRITE(MSTA(8),1001) ILINE
        IFATAL=1
        IDUMP=1
      ELSEIF (IERR.EQ.5) THEN
        WRITE(MSTA(8),1050)
        WRITE(MSTA(8),1001) ILINE
        IFATAL=1
        IDUMP=1
      ELSEIF (IERR.EQ.6) THEN
        WRITE(MSTA(8),1060) MAXPAR
        IFATAL=1
      ELSEIF (IERR.EQ.7) THEN
        WRITE(MSTA(8),1070) MAXDIP
        IFATAL=1
      ELSEIF (IERR.EQ.8) THEN
        WRITE(MSTA(8),1080) MAXSTR
        IFATAL=1
      ELSEIF (IERR.EQ.9) THEN
        IF (IWRN(9).GT.MSTA(10)) RETURN
        WRITE(MSTA(8),1090)
        IF (IWRN(9).EQ.MSTA(10)) IDUMP=1
      ELSEIF (IERR.EQ.10) THEN
        IF (IWRN(10).GT.MSTA(10)) RETURN
        WRITE(MSTA(8),1100)
      ELSEIF (IERR.EQ.11) THEN
        WRITE(MSTA(8),1110)
        IFATAL=1
        IDUMP=1
      ELSEIF (IERR.EQ.12) THEN
        WRITE(MSTA(8),1120)
        IFATAL=1
      ELSEIF (IERR.EQ.13) THEN
        IF (IWRN(13).GT.MSTA(10)) RETURN
        WRITE(MSTA(8),1130)
      ELSEIF (IERR.EQ.14) THEN
        WRITE(MSTA(8),1140)
        IFATAL=1
      ELSEIF (IERR.EQ.20) THEN
        IF (IWRN(20).GT.MSTA(10)) RETURN
        WRITE(MSTA(8),1200)
      ELSEIF (IERR.EQ.21) THEN
        IF (IWRN(21).GT.MSTA(10)) RETURN
        WRITE(MSTA(8),1210)
      ELSEIF (IERR.EQ.22) THEN
        IF (IWRN(22).GT.MSTA(10)) RETURN
        WRITE(MSTA(8),1220)
      ELSEIF (IERR.EQ.23) THEN
        WRITE(MSTA(8),1230)
        IFATAL=1
      ELSEIF (IERR.EQ.24) THEN
        WRITE(MSTA(8),1240)
        IFATAL=1
      ELSEIF (IERR.EQ.25) THEN
        IF (IWRN(25).GT.MSTA(10)) RETURN
        WRITE(MSTA(8),1250)
        IF (IWRN(25).EQ.MSTA(10)) IDUMP=1
      ELSEIF (IERR.EQ.26) THEN
        IF (IWRN(26).GT.MSTA(10)) RETURN
        WRITE(MSTA(8),1260)
      ELSEIF (IERR.EQ.27) THEN
        WRITE(MSTA(8),1270)
        IFATAL=1
      ELSEIF (IERR.EQ.28) THEN
        WRITE(MSTA(8),1280)
        IFATAL=1
      ELSEIF (IERR.EQ.29) THEN
        IF (IWRN(29).GT.MSTA(10)) RETURN
        WRITE(MSTA(8),1290)
      ELSEIF (IERR.EQ.30) THEN
        WRITE(MSTA(8),1300)
        IFATAL=1
      ELSEIF (IERR.EQ.31) THEN
        WRITE(MSTA(8),1310)
        IFATAL=1
      ELSEIF (IERR.EQ.32) THEN
        WRITE(MSTA(8),1320)
        IFATAL=1
      ELSEIF (IERR.EQ.33) THEN
        WRITE(MSTA(8),1330) ILINE
        IFATAL=1
      ELSEIF (IERR.EQ.34) THEN
        WRITE(MSTA(8),1340) ILINE
        IFATAL=1
      ELSEIF (IERR.EQ.35) THEN
        WRITE(MSTA(8),1350) ILINE
        IFATAL=1
      ELSEIF (IERR.EQ.36) THEN
        WRITE(MSTA(8),1360) ILINE
        IFATAL=1
      ELSEIF (IERR.EQ.37) THEN
        WRITE(MSTA(8),1370) ILINE
        IFATAL=1
      ELSEIF (IERR.EQ.38) THEN
        WRITE(MSTA(8),1380) ILINE,ILINE+1
        IFATAL=1
      ENDIF

C...Dump ariadne dipole record and list the event if necessary
      IF (IDUMP.GT.0.OR.IFATAL.GT.0) THEN
        IF (.NOT.QDUMP) CALL ARDUMP
        WRITE(MSTA(8),1002)
        CALL LULIST(2)
      ENDIF

C...Stop execution if necessary
      IF (IFATAL.GT.0) THEN
        CALL ARPRDA
        WRITE(MSTA(8),1003)
        STOP 0
      ENDIF

 1000 FORMAT('*** ERROR Found by Ariadne ***'/'In routine ',A6,
     $     '. Error type =',I3,'. Ariadne call number:',I7)
 1001 FORMAT('Line number:',I4)
 1002 FORMAT('Dump of event follows:')
 1003 FORMAT('Error is fatal. Execution stopped.')

 1010 FORMAT('Found colour-singlet particle in string.')
 1020 FORMAT('Found colour-triplet particle in string.')
 1030 FORMAT('Found colour-singlet particle in string.',
     $       ' Will try to cope...')
 1040 FORMAT('Found colour-triplet particle in purely gluonic string.')
 1050 FORMAT('Inconsistent colour flow in string.')
 1060 FORMAT('Maximum number of partons (',I5,') exceeded. See manual.')
 1070 FORMAT('Maximum number of dipoles (',I5,') exceeded. See manual.')
 1080 FORMAT('Maximum number of strings (',I5,') exceeded. See manual.')
 1090 FORMAT('Four-momentum was not conserved.')
 1100 FORMAT('Particle has inconsistent four-momentum. ',
     $     'Will try to cope...')
 1110 FORMAT('Recoil transfer for Drell-Yan process was not',
     $       ' kinematically allowed.')
 1120 FORMAT('Ariadne not properly initialized before call to AREXEC.')
 1130 FORMAT('Dipole has inconsistent mass. Will try to cope...')
 1140 FORMAT('Unphysical boost vector.',/,
     $     'Try switching to double precision - see manual')
 1200 FORMAT('Selected sub-process in PYTHIA is not suported by',
     $  ' Ariadne.',/,
     $  '(only processes 11,12,13,28,53,68 are currently supported)',/,
     $  'Will try to continue but results may not be meaningful.')
 1210 FORMAT('Too many jet-initiators. ARCLUS was not performed.')
 1220 FORMAT('Caught in an infinite loop. Please disregard this event.')
 1230 FORMAT('Cannot handle non-baryon targets (yet).')
 1240 FORMAT('This routine should not have been called.',/,
     $     ' See installation instructions for further information')
 1250 FORMAT('Four-momentum was not conserved.',/,
     $     ' Please disregard this event')
 1260 FORMAT('Probability in BGF greater than 1')
 1270 FORMAT('Could not find Drell-Yan particle.')
 1280 FORMAT('Uphysical parameters in /ARPOPA/')
 1290 FORMAT('Pomeron structure function greater than the total.',/,
     $     ' Rescaling Pomeron structure function.')
 1300 FORMAT('Inconsistent remnants')
 1310 FORMAT('Tried to access event record outside of the stack')
 1320 FORMAT('No colour information available for rearrangement.')
 1330 FORMAT('Too few particles (',i2,') in event record.')
 1340 FORMAT('Particle in line ',i2,' is not a fermion.')
 1350 FORMAT('Particle in line ',i2,' does not obey sign')
 1360 FORMAT('Particle in line ',i2,' is not a photon.')
 1370 FORMAT('Particle in line ',i2,
     $       ' has incinsistent momentum vector.')
 1380 FORMAT('Fermion pair in lines ',i2,' and',i2,' is inconsistent.')

      RETURN

C**** END OF ARERRM ****************************************************
      END
C***********************************************************************
C $Id: arexec.f,v 3.13 1995/11/30 10:15:23 leif Exp $
CDECK  ID>, AREXEC.
      SUBROUTINE AREXEC

C...ARiadne subroutine EXECute ariadne

C...The Main driver routine in Ariadne.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/

C...Step counter
      MSTA(4)=MSTA(4)+1

C...Reset some stuff
      MSTA(13)=0
      MHAR(121)=0
      MHAR(129)=0
      MHAR(135)=0
      MHAR(136)=0

C...Error if ARINIT has not been called
      IF (MSTA(2).EQ.0) CALL ARERRM('AREXEC',12,0)

C...Unmark unused special positions in dipole record
      DO 100 I=MAXPAR-4,MAXPAR-2
        QQ(I)=.FALSE.
 100  CONTINUE

C...If ariadne mode just pass event through to ARPARS
      IF (MSTA(1).EQ.0) THEN
        CALL ARPARS(1,N)

C...If JETSET mode should work by just passing event on to ARPARS
      ELSEIF (MSTA(1).EQ.1) THEN
        CALL ARPARS(1,N)

C...If PYTHIA mode tag extended partons etc.
      ELSEIF (MSTA(1).EQ.2) THEN

        CALL ARPYTH

C...If LEPTO mode tag extended partons
      ELSEIF (MSTA(1).EQ.3) THEN
        IF (MSTA(32).GT.0) THEN
          CALL ARLEPT
          GOTO 900
        ENDIF

C...Boost to hadronic cm to avoid precision problems
        CALL ARBOLE(THEL,PHI1,PHI2,DBXL,DBYL,DBZL)

        IF (LST(24).EQ.1) THEN

          IF (MSTA(30).LT.2) THEN
            K(5,4)=0
          ELSE
            K(5,4)=3
            PARA(13)=SQRT(XQ2)
          ENDIF
          IF (MSTA(30).EQ.0) THEN
            K(6,4)=1
          ELSE
            K(6,4)=2
            PARA(12)=PARA(11)/(1.0-X)
          ENDIF
          CALL ARPARS(5,6)
        ELSEIF (LST(24).EQ.3) THEN

          IF (MSTA(30).LT.2) THEN
            K(5,4)=0
          ELSE
            K(5,4)=3
            PARA(13)=SQRT(XQ2)
          ENDIF
          IF (MSTA(30).EQ.0) THEN
            K(6,4)=1
          ELSE
            K(6,4)=2
            PARA(12)=PARA(11)/(1.0-X)
          ENDIF
          CALL ARPARS(5,6)
          IF (MSTA(30).LT.2) THEN
            K(7,4)=0
          ELSE
            K(7,4)=3
            PARA(13)=SQRT(XQ2)
          ENDIF
          IF (MSTA(30).EQ.0) THEN
            K(8,4)=1
          ELSE
            K(8,4)=2
            PARA(12)=PARA(11)/(1.0-X)
          ENDIF
          CALL ARPARS(7,8)
        ENDIF
        CALL LUDBRB(1,N,0.0,PHI2,0.0D0,0.0D0,0.0D0)
        CALL LUDBRB(1,N,THEL,PHI1,DBXL,DBYL,DBZL)
      ENDIF

C...Perform fragmentation if requested
 900  IF (MSTA(5).EQ.1) CALL LUEXEC

      RETURN

C**** END OF AREXEC ****************************************************
      END
C***********************************************************************
C $Id: argpt2.f,v 3.10 1995/03/06 16:54:34 lonnblad Exp $
CDECK  ID>, ARGPT2.
      REAL FUNCTION ARGPT2(ID)

C...ARiadne function Generate PT2

C...Returns the p_t^2 for a possible emission from dipole ID.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/


C...Set invariant mass squared in the dipole and generate a p_t^2

C...with the appropriate Monte Carlo subroutine
      IF (QEM(ID).AND.MSTA(20).GE.2.AND.ISTRS.GE.2) THEN
        PT2IN(ID)=0.0
        QDONE(ID)=.TRUE.
      ENDIF
      IF (.NOT.QDONE(ID)) THEN
        IRAD(ID)=0
        SDIP(ID)=ARMAS2(IP1(ID),IP3(ID))
        IF (QEM(ID)) THEN
          CALL ARGQED(ID)
        ELSEIF ((MSTA(33).EQ.1.AND.MSTA(1).EQ.3.AND.IO.EQ.0).OR.
     $         (MSTA(1).EQ.2.AND.IO.EQ.0
     $         .AND.XQ2.GT.0.0.AND.MHAR(120).GT.0)) THEN
          CALL ARGDIS(ID)
        ELSEIF (MSTA(33).EQ.-1.AND.MSTA(1).EQ.3.AND.IO.EQ.0) THEN
          PSAV3=PARA(3)
          IF (PARA(20).GE.0.0) THEN
            PTCUT=MAX(SQRT(PARA(20)*PARA(21)*XQ2),PARA(3))
          ELSE
            PTCUT=MAX(SQRT(-PARA(20)*PARA(21)*W2),PARA(3))
          ENDIF
          PARA(3)=PTCUT
          CALL ARGDIS(ID)
          PARA(3)=PSAV3
          IF (PT2IN(ID).LT.PTCUT**2) THEN
            PT2LST=PTCUT**2
            CALL ARGQCD(ID)
          ENDIF
        ELSE
          CALL ARGQCD(ID)
        ENDIF
        QDONE(ID)=.TRUE.
      ENDIF

      IF (QQ(MAXPAR-3).AND.MSTA(32).GE.2) THEN
        IF (PT2GG(MAXPAR-3).LT.0.0.AND.
     $       (INQ(MAXPAR-3).EQ.IP1(ID).OR.INQ(MAXPAR-3).EQ.IP3(ID)))
     $       CALL ARGING(ID,MAXPAR-3)
      ENDIF
      IF (QQ(MAXPAR-4).AND.MSTA(32).GE.2) THEN
        IF (PT2GG(MAXPAR-4).LT.0.0.AND.
     $       (INQ(MAXPAR-4).EQ.IP1(ID).OR.INQ(MAXPAR-4).EQ.IP3(ID)))
     $       CALL ARGING(ID,MAXPAR-4)
      ENDIF

      ARGPT2=PT2IN(ID)

      RETURN

C**** END OF ARGPT2 ****************************************************
      END
C***********************************************************************
C $Id: argqcd.f,v 3.16 1995/08/13 17:29:09 lonnblad Exp $
CDECK  ID>, ARGQCD.
      SUBROUTINE ARGQCD(IDIN)

C...ARiadne subroutine Generate pt2 for QCD emission.

C...Generates a p_t^2 for a possible QCD emission from dipole ID

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/


C...Copy some information from dipole record if ID < 1 these information
C...Has already been copied
C...S      = the invariant mass squared
C...W      = total energy in dipole
C...XT2MP  = maximum allowed fractional p_t^2 (x_t^2) for restricted  
C...         phase space option
C...QQ1(3) = Boolean variable 'is quark' for parton 1(3)
C...QE1(3) = true if parton 1(3) is extended
C...ALP1(3)= alpha parameter of parton 1(3)
C...XMU1(3)= mu parameter of parton 1(3)
C...SY1(3) = fractional mass of parton 1(3)

      IF (IDIN.GT.0) THEN
        ID=IDIN
        PT2IN(ID)=0.0
        S=SDIP(ID)
        IF (S.LT.4.0*PARA(3)**2) RETURN
        W=SQRT(S)
        XT2MP=PT2LST/S
        QQ1=QQ(IP1(ID))
        QQ3=QQ(IP3(ID))
        QE1=QEX(IP1(ID))
        QE3=QEX(IP3(ID))
        ALP1=XPA(IP1(ID))
        ALP3=XPA(IP3(ID))
        XMU1=XPMU(IP1(ID))
        XMU3=XPMU(IP3(ID))
        SY1=BP(IP1(ID),5)/W
        SY3=BP(IP3(ID),5)/W
        IFL1=IFL(IP1(ID))
        IFL3=IFL(IP3(ID))
        XT2GG1=-1.0
        XT2GG3=-1.0
        IF ((.NOT.QQ1).AND.(.NOT.QE1)) THEN
          XT2GG1=XT2MP
          IF (INO(IP1(ID)).NE.1) XT2GG1=PT2GG(IP1(ID))/S
        ENDIF
        IF ((.NOT.QQ3).AND.(.NOT.QE3)) THEN
          XT2GG3=XT2MP
          IF (INO(IP3(ID)).NE.1) XT2GG3=PT2GG(IP3(ID))/S
        ENDIF
        IF (PARA(19).LT.0.0) CALL ARPRGC(ID)
      ELSE
        ID=-IDIN
        PT2IN(ID)=0.0
        IF (S.LT.4.0*PARA(3)**2) RETURN
        W=SQRT(S)
      ENDIF

      IF (S.LT.4.0*PARA(3)**2) RETURN

C...XLAM = scaled lambda_QCD squared
      XLAM2=PARA(1)**2/S

C...alpha_0 for alpha_QCD = alpha_0/ln(p_t^2/lambda_QCD^2)
      XNUMFL=MAX(ARNOFL(W,MAX(5,MSTA(15))),3.0)
      ALPHA0=12.0*PARU(1)/(33.0-2.0*XNUMFL)

C...Normal gluon emission
      CALL ARGQCG(ID)

C...q-qbar emission
      IF (MSTA(15).GT.0) CALL ARGQCQ(ID)

      RETURN

C**** END OF ARGQCD ****************************************************
      END
C***********************************************************************
C $Id: argqcd.f,v 3.16 1995/08/13 17:29:09 lonnblad Exp $
CDECK  ID>, ARGQCG.
      SUBROUTINE ARGQCG(ID)

C...ARiadne subroutine Generate pt2 for QCD emission.

C...Generates a p_t^2 for a possible QCD emission from dipole ID

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON /ARINT2/ DBEX,DBEY,DBEZ,PHI,THE
      SAVE /ARINT2/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      EXTERNAL ARNDX1,ARNDX2,ARNDY1,ARNDY2,ARVET3,ARVET4
      REAL ARNDX1,ARNDX2,ARNDY1,ARNDY2,ARVET3,ARVET4


C...C = colour factors etc. in cross section
      C=6.0/(4.0*PARU(1))
      IF (QQ1.AND.QQ3) C=4.0/(3.0*PARU(1))
      SY2=0.0
      SQ2=0.0

C...Set exponents in cross section
      NXP1=3
      NXP3=3
      IF (QQ1) NXP1=2
      IF (QQ3) NXP3=2

C...Flavour of this emission 0 = gluon emission
      IFLG=0

C...Calculate mass dependent parameters
      CALL ARMADE

C...Allow extra phase space when Drell-Yan process
      QEXDY=.FALSE.
      IF (((ABS(MHAR(123)).EQ.1.AND.IO.EQ.0).OR.MHAR(123).GT.1.OR.
     $     (MHAR(131).NE.0.and.IO.EQ.0))
     $     .AND.QQ(MAXPAR-2)) THEN
        QEXDY=.TRUE.
        IDY=MAXPAR-2
        CALL ARBOCM(ID)
        CALL AROBO1(0.0,0.0,-DBEX,-DBEY,-DBEZ,IDY)
        CALL AROBO1(0.0,-PHI,0.0D0,0.0D0,0.0D0,IDY)
        CALL AROBO1(-THE,0.0,0.0D0,0.0D0,0.0D0,IDY)
        BPDY=BP(IDY,4)+BP(IDY,3)
        BMDY=BP(IDY,4)-BP(IDY,3)
        CALL AROBO1(THE,PHI,DBEX,DBEY,DBEZ,IDY)
        CALL AROBO2(0.0,0.0,DBEX,DBEY,DBEZ,IP1(ID),IP3(ID))
      ENDIF

C...Minimum x_t^2
      XT2C=MAX(PT2IN(ID),PARA(3)**2)/S
      XT2=0.0

C...Set maximum x_t^2
      IF (MSTA(11).LT.4) XT2M=MIN(XT2M,XT2MP)

      IF (XT2M.LE.XT2C) GOTO 900

C...Set additional parameters and call the veto algorith with
C...Suitable random functions
      IF (MSTA(12).GT.0) THEN
C.......Running alpha_QDC
        YINT=2.0*LOG(0.5/SQRT(XLAM2)+SQRT(0.25/XLAM2-1.0))
        CN=1.0/(YINT*C*ALPHA0)
        IF (QE1.OR.QE3) THEN
C.........Extended dipole
          CALL ARMCDI(ARNDX1,ARNDY2,ARVET4)
        ELSE
C.........Pointlike dipole
          CALL ARMCDI(ARNDX1,ARNDY1,ARVET4)
        ENDIF
      ELSE
C.......Constant alpha_QCD
        YINT=1.0
        CN=2.0/(C*PARA(2))
        IF (QE1.OR.QE3) THEN
C.........Extended dipole
          CALL ARMCDI(ARNDX2,ARNDY2,ARVET3)
        ELSE
C.........Pointlike dipole
          CALL ARMCDI(ARNDX2,ARNDY1,ARVET3)
        ENDIF
      ENDIF

C...Save the generated values of p_t^2, x1, x3, a1 and a3
      IF (XT2.GT.XT2C) THEN
        PT2IN(ID)=XT2*S
        BX1(ID)=B1
        BX3(ID)=B3
        AEX1(ID)=AE1
        AEX3(ID)=AE3
        IRAD(ID)=0
      ENDIF

 900  CONTINUE

      QEXDY=.FALSE.

      RETURN

C**** END OF ARGQCG ****************************************************
      END
C***********************************************************************
C $Id: argqcd.f,v 3.16 1995/08/13 17:29:09 lonnblad Exp $
CDECK  ID>, ARGQCQ.
      SUBROUTINE ARGQCQ(ID)

C...ARiadne subroutine Generate pt2 for QCD emission.

C...Generates a p_t^2 for a possible QCD emission from dipole ID

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARDAT2/ PQMAS(10)
      SAVE /ARDAT2/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      EXTERNAL ARNDX1,ARNDX3,ARNDY3,ARNDY4,ARVET5
      REAL ARNDX1,ARNDX3,ARNDY3,ARNDY4,ARVET5


C...Exit if no point-like gluons
      QG1=((.NOT.QQ1).AND.(.NOT.QE1))
      QG3=((.NOT.QQ3).AND.(.NOT.QE3))
      IF ((.NOT.QG1).AND.(.NOT.QG3)) RETURN

C...Colour factors and things in cross section. If g-g dipole
C...q-qbar splitting only calculated for one gluon but double
C...cross section
      C=1.0/(8.0*PARU(1))
      IF (QG1.AND.QG3) C=C*2.0
      SQ2=0.0

C...Parton 3 is always assumed to be split
      IF (QG1) THEN
        SY1=SY3
        QE1=QE3
        QE3=.FALSE.
        XMU1=XMU3
        ALP1=ALP3
        XMU3=0.0
        ALP3=0
      ENDIF

C...set 'minimum' XT2 to the XT2 of the gluon emission. XT2s below that
C...are not relevant

C...Loop over allowed flavours
      DO 100 IFLG=1,MSTA(15)

C...Set mass dependent parameters
        SY2=PQMAS(IFLG)/W
        SY3=SY2
        CALL ARMADE

C...Set phase space restrictions
        IF (MSTA(11).LT.2.AND.MSTA(28).GE.0) XT2M=MIN(XT2M,XT2MP)

C...Exit if not enough energy
        XT2C=MAX(PT2IN(ID),PARA(3)**2)/S
        XT2=0.0
        IF (XT2M.LE.XT2C.OR.SSY.GE.1.0) GOTO 900

C...Set additional parameters and call the veto algorith with
C...Suitable random functions
        YINT=2.0*SQRT(S)
C.......Running alpha_QCD
        IF (MSTA(12).GT.0) THEN
          CN=1.0/(YINT*C*ALPHA0)
          IF (QE1.OR.QE3) THEN
C...........extended dipole
            CALL ARMCDI(ARNDX1,ARNDY4,ARVET5)
          ELSE
C...........pointlike dipole
            CALL ARMCDI(ARNDX1,ARNDY3,ARVET5)
          ENDIF
        ELSE
C.........Constant alpha_QCD
          CN=2.0/(YINT*C*PARA(2))
          IF (QE1.OR.QE3) THEN
C...........extended dipole
            CALL ARMCDI(ARNDX3,ARNDY4,ARVET5)
          ELSE
C...........pointlike dipole
            CALL ARMCDI(ARNDX3,ARNDY3,ARVET5)
          ENDIF
        ENDIF

C...If Generated XT2 is larger than previous XT2 accept this and save
C...the generated values of p_t^2, x1, x3, a1 and a3
        IF (XT2.GT.XT2C) THEN
          PT2IN(ID)=XT2*S
          BX1(ID)=B1
          BX3(ID)=B3
          AEX1(ID)=AE1
          AEX3(ID)=AE3
          IRAD(ID)=IFLG
        ENDIF

 100  CONTINUE

C...Exit if gluon emission was chosen 
 900  IF (IRAD(ID).EQ.0) RETURN

C...Select wich gluon to split
      QFORCE=.FALSE.
      IF (MSTA(28).NE.0) THEN
        SMQQ=1.0-BX1(ID)+Y1
        IF (ABS(MSTA(28)).EQ.2)
     $       SMQQ=SMQQ-4.0*(PQMAS(ABS(IRAD(ID)))/W)**2
        IF (XT2GG1.GT.0.0.AND.(.NOT.QG3).AND.SMQQ.GT.XT2GG1) RETURN
        IF (XT2GG3.GT.0.0.AND.SMQQ.GT.XT2GG3) QFORCE=.TRUE.
      ENDIF

      IF ((.NOT.QG3).OR.(QG1.AND.(RLU(IDUM).GT.0.5.OR.QFORCE))) THEN
        IRAD(ID)=-IRAD(ID)
        B1=BX1(ID)
        BX1(ID)=BX3(ID)
        BX3(ID)=B1
        AE1=AEX1(ID)
        AEX1(ID)=AEX3(ID)
        AEX3(ID)=AE1
      ENDIF

      RETURN

C**** END OF ARGQCQ ****************************************************
      END
C***********************************************************************
C $Id: argqcd.f,v 3.16 1995/08/13 17:29:09 lonnblad Exp $
CDECK  ID>, ARPRGC.
      SUBROUTINE ARPRGC(ID)

C...ARiadne subroutine PRepare Gluon Check.

C...Set up variables to be used by ARCHKI to perform safety check on
C...gluon emission to prevent trouble for subsequent initial state gluon
C...splitting.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/


      KQ1=0
      KQ3=0
      IF (MSTA(32).LT.2) RETURN

      IF (.NOT.(QQ(MAXPAR-3).OR.QQ(MAXPAR-4))) RETURN
      IRP=MAXPAR-3
      IF (QQ(IRP)) THEN
        IT=2
        IDIR=IRDIR(IT)
        IR=INQ(IRP)
        PMT=P(IT,4)+IDIR*P(IT,3)
        IF (IR.EQ.IP1(ID)) THEN
          KF1=K(IT,2)
          KQ1=IDO(IRP)
          BMRP1=(BP(IRP,4)+IDIR*BP(IRP,3))/PMT
          BMR1=(BP(IR,4)+IDIR*BP(IR,3))/PMT
        ELSEIF (IR.EQ.IP3(ID)) THEN
          KF3=K(IT,2)
          KQ3=IDO(IRP)
          BMRP3=(BP(IRP,4)+IDIR*BP(IRP,3))/PMT
          BMR3=(BP(IR,4)+IDIR*BP(IR,3))/PMT
        ENDIF
      ENDIF
      IRP=MAXPAR-4
      IF (QQ(IRP)) THEN
        IT=1
        IDIR=IRDIR(IT)
        IR=INQ(IRP)
        PMT=P(IT,4)+IDIR*P(IT,3)
        IF (IR.EQ.IP1(ID)) THEN
          KF1=K(IT,2)
          KQ1=IDO(IRP)
          BMRP1=(BP(IRP,4)+IDIR*BP(IRP,3))/PMT
          BMR1=(BP(IR,4)+IDIR*BP(IR,3))/PMT
        ELSEIF (IR.EQ.IP3(ID)) THEN
          KF3=K(IT,2)
          KQ3=IDO(IRP)
          BMRP3=(BP(IRP,4)+IDIR*BP(IRP,3))/PMT
          BMR3=(BP(IR,4)+IDIR*BP(IR,3))/PMT
        ENDIF
      ENDIF

      RETURN

C**** END OF ARGQCQ ****************************************************
      END
C***********************************************************************
C $Id: argqed.f,v 3.6 1995/03/06 16:54:37 lonnblad Exp $
CDECK  ID>, ARGQED.
      SUBROUTINE ARGQED(ID)

C...ARiadne subroutine Generate pt2 for QED emission

C...Generates a p-t^2 for a possible QED emission from dipole ID.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      EXTERNAL ARNDX2,ARNDY1,ARVET1
      REAL ARNDX2,ARNDY1,ARVET1


C...Copy information about partons in dipole (for explanation see
C...subroutine ARGQCD
      PT2IN(ID)=0.0
      S=SDIP(ID)
      IF (S.LE.4.0*PARA(5)**2) RETURN
      IF (MSTA(20).GE.2.AND.ISTRS.GE.2) RETURN
      W=SQRT(S)
      XT2MP=PT2LST/S
      QQ1=QQ(IP1(ID))
      QQ3=QQ(IP3(ID))
      QE1=QEX(IP1(ID))
      QE3=QEX(IP3(ID))

      QEXDY=.FALSE.

      SY1=BP(IP1(ID),5)/W
      SY2=0.0
      SY3=BP(IP3(ID),5)/W
      IF (PARA(19).LT.0.0) CALL ARPRGC(ID)

      XT2C=PARA(5)**2/S
      NXP1=2
      NXP3=2

C...Set charges of emitting quarks and set constant in cross section
      IQ1=LUCHGE(IFL(IP1(ID)))
      IQ3=LUCHGE(IFL(IP3(ID)))
      FQMAX=REAL(MAX(ABS(IQ1),ABS(IQ3)))
      FQ1=REAL(IQ1)/FQMAX
      FQ3=REAL(IQ3)/FQMAX
      C=(FQMAX**2)/(9.0*PARU(1))
      IFLG=-1

C...Set mass dependent parameters
      CALL ARMADE

C...Restrict phase space if demanded
      IF (MSTA(11).EQ.0.OR.MSTA(11).EQ.2) XT2M=MIN(XT2M,XT2MP)

C...Set some further parameters and call the veto algorithm with
C...suitable random functions for constant alpha_EM.
      YINT=1.0
      CN=2.0/(C*PARA(4))
      CALL ARMCDI(ARNDX2,ARNDY1,ARVET1)

C...Save information about emission
      PT2IN(ID)=XT2*S
      BX1(ID)=B1
      BX3(ID)=B3
      AEX1(ID)=AE1
      AEX3(ID)=AE3

      RETURN

C**** END OF ARGQED ****************************************************
      END
C***********************************************************************
C $Id: argtyp.f,v 3.1 1994/05/11 07:10:26 lonnblad Exp $
CDECK  ID>, ARGTYP.
      SUBROUTINE ARGTYP(I,ITYP)

C...ARiadne subroutine Get TYpe of Particle

C...Determines the type of particle I according to ITYP=2: gluon,
C...ITYP=1: quark or anti-di-quark, ITYP=-1: anti-quark or di-quark,
C...ITYP=0: other.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT2/KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
      INTEGER  KCHG
      REAL  PMAS,PARF,VCKM
      SAVE /GUDAT2/
**JWG  add psi'(3685) as KC code 80, needed for Eurodec interface
*      --- ---------- -- -- ---- --- ------ --- ------- ---------
      INTEGER  IDPSIP
      PARAMETER  (IDPSIP=80)


      ITYP=KCHG(LUCOMP(K(I,2)),2)*ISIGN(1,K(I,2))

      RETURN

C**** END OF ARGTYP ****************************************************
      END
C***********************************************************************
C $Id: aript2.f,v 3.1 1994/05/11 07:10:31 lonnblad Exp $
CDECK  ID>, ARIPT2.
      REAL FUNCTION ARIPT2(I1,I2,I3)

C...ARiadne function Invariant PT2

C...Returns the invariant p_t^2 of three partons

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/


      ARIPT2=(ARMAS2(I1,I2)-(BP(I1,5)+BP(I2,5))**2)*
     $       (ARMAS2(I2,I3)-(BP(I2,5)+BP(I3,5))**2)/
     $        ARMAS3(I1,I2,I3)

      RETURN

C**** END OF ARIPT2 ****************************************************
      END
C***********************************************************************
C $Id: arjoin.f,v 3.5 1994/10/27 08:57:04 lonnblad Exp $
CDECK  ID>, ARJOIN.
      SUBROUTINE ARJOIN(J1,J2,J3)

C...ARiadne subroutine JOIN jets

C...Join three jets into two

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/

C...Boost to CMS of jets
      DE=BP(J1,4)+BP(J2,4)+BP(J3,4)
      DBEX=(BP(J1,1)+BP(J2,1)+BP(J3,1))/DE
      DBEY=(BP(J1,2)+BP(J2,2)+BP(J3,2))/DE
      DBEZ=(BP(J1,3)+BP(J2,3)+BP(J3,3))/DE

      IF (DBEX**2+DBEY**2+DBEZ**2.GE.1.0D0) THEN
        BP(J1,1)=BP(J1,1)+BP(J2,1)*0.5
        BP(J1,2)=BP(J1,2)+BP(J2,2)*0.5
        BP(J1,3)=BP(J1,3)+BP(J2,3)*0.5
        BP(J1,4)=BP(J1,4)+BP(J2,4)*0.5
        BP(J1,5)=0.0
        BX1(J1)=0.0
        BP(J3,1)=BP(J3,1)+BP(J2,1)*0.5
        BP(J3,2)=BP(J3,2)+BP(J2,2)*0.5
        BP(J3,3)=BP(J3,3)+BP(J2,3)*0.5
        BP(J3,4)=BP(J3,4)+BP(J2,4)*0.5
        BP(J3,5)=0.0
        BX1(J3)=0.0
        QDONE(J2)=.TRUE.
        IDIPS=IDIPS-1
        RETURN
      ENDIF

      CALL AROBO3(0.0,0.0,-DBEX,-DBEY,-DBEZ,J1,J2,J3)

C...Rotate Jet 1 to z-axis and jet 2 to xz plane
      PX=BP(J1,1)
      PY=BP(J1,2)
      PZ=BP(J1,3)
      PHI=ULANGL(PX,PY)
      CALL AROBO3(0.0,-PHI,0.0D0,0.0D0,0.0D0,J1,J2,J3)
      THE=ULANGL(PZ,SQRT(PX**2+PY**2))
      CALL AROBO3(-THE,0.0,0.0D0,0.0D0,0.0D0,J1,J2,J3)
      PX=BP(J2,1)
      PY=BP(J2,2)
      PHI2=ULANGL(PX,PY)
      CALL AROBO3(0.0,-PHI2,0.0D0,0.0D0,0.0D0,J1,J2,J3)

C...Calculate energy fractions
      BE=BP(J1,4)+BP(J2,4)+BP(J3,4)
      B1=2.0*BP(J1,4)/BE
      B3=2.0*BP(J3,4)/BE

C...Determine recoil angle
      BET=ARANGL(J1,J3)
      PSI=0.0
      PSI=(PARU(1)-BET)*(B3**2)/(B1**2+B3**2)
      BP(J1,1)=0.0
      BP(J1,2)=0.0
      BP(J1,3)=BE*0.5
      BP(J1,4)=BE*0.5
      BP(J1,5)=0.0
      BX1(J1)=0.0
      BP(J3,1)=0.0
      BP(J3,2)=0.0
      BP(J3,3)=-BE*0.5
      BP(J3,4)=BE*0.5
      BP(J3,5)=0.0
      BX1(J3)=0.0
      QDONE(J2)=.TRUE.
      IDIPS=IDIPS-1

C...Rotate and boost back
      CALL AROBO2(PSI,0.0,0.0D0,0.0D0,0.0D0,J1,J3)
      CALL AROBO2(0.0,PHI2,0.0D0,0.0D0,0.0D0,J1,J3)
      CALL AROBO2(THE,PHI,DBEX,DBEY,DBEZ,J1,J3)

      RETURN

C**** END OF ARJOIN ****************************************************
      END
C***********************************************************************
C $Id: armade.f,v 3.8 1994/05/25 10:56:31 lonnblad Exp $
CDECK  ID>, ARMADE.
      SUBROUTINE ARMADE

C...ARiadne subroutine set MAss DEpendencies

C...Sets some mass dependencies needed for ARMCDI

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      SSY=SY1+SY2+SY3
      Y1=SY1**2
      Y2=SY2**2
      Y3=SY3**2

      BC1=DBLE(Y1)+1.0D0-DBLE(SY2+SY3)**2
      IF (IFLG.GT.0.AND.MSTA(23).EQ.2) BC1=DBLE(Y1)+1.0D0
      BC3=DBLE(Y3)+1.0D0-DBLE(SY2+SY1)**2
      XT2M=0.0
      IF (SQRT(0.25+Y2)-1.0+(BC1+BC3)/2.0.LT.0.0) RETURN
      XTS=(SQRT(0.25+Y2)-1.0+(BC1+BC3)/2.0)**2
      XT1=BC1-2.0*SY1
      XT3=BC3-2.0*SY3
      IF (XT1.LT.0.0) RETURN
      IF (XT3.LT.0.0) RETURN
      XT2M=MIN(XTS,XT1*XT3)

      BZP=0.5*(1.0+Y1-Y3+SQRT(1.0+(Y1-Y3)**2-2.0*(Y1+Y3)))
      BZM=0.5*(1.0+Y3-Y1+SQRT(1.0+(Y1-Y3)**2-2.0*(Y1+Y3)))

      RETURN

C**** END OF ARMADE ****************************************************
      END
C***********************************************************************
C $Id: armass.f,v 3.2 1994/05/11 07:10:35 lonnblad Exp $
CDECK  ID>, ARMAS2.
      REAL FUNCTION ARMAS2(I1,I2)

C...ARiadne function invariant MASs of 2 partons

C...Returns the invariant mass^2 of partons I1 and I2

      DIMENSION I(2)


      I(1)=I1
      I(2)=I2

      ARMAS2=ARMASS(2,I)

      RETURN

C**** END OF ARMAS2 ****************************************************
      END
C***********************************************************************
C $Id: armass.f,v 3.2 1994/05/11 07:10:35 lonnblad Exp $
CDECK  ID>, ARMAS3.
      REAL FUNCTION ARMAS3(I1,I2,I3)

C...ARiadne function invariant MASs of 3 partons

C...Returns the invariant mass^2 of partons I1, I2 and I3

      DIMENSION I(3)


      I(1)=I1
      I(2)=I2
      I(3)=I3
      
      ARMAS3=ARMASS(3,I)

      RETURN

C**** END OF ARMAS3 ****************************************************
      END
C***********************************************************************
C $Id: armass.f,v 3.2 1994/05/11 07:10:35 lonnblad Exp $
CDECK  ID>, ARMAS4.
      REAL FUNCTION ARMAS4(I1,I2,I3,I4)

C...ARiadne function invariant MASs of 4 partons

C...Returns the invariant mass^2 of partons I1, I2, I3 and I4

      DIMENSION I(4)


      I(1)=I1
      I(2)=I2
      I(3)=I3
      I(4)=I4

      ARMAS4=ARMASS(4,I)

      RETURN

C**** END OF ARMAS4 ****************************************************
      END
C***********************************************************************
C $Id: armass.f,v 3.2 1994/05/11 07:10:35 lonnblad Exp $
CDECK  ID>, ARMASS.
      REAL FUNCTION ARMASS(N,I)

C...ARiadne function invariant MASS of partons

C...Returns the total invariant mass^2 of N partons

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      DIMENSION I(N),DPS(4)


      DO 100 IK=1,4
        DPS(IK)=0.0D0
        DO 200 IJ=1,N
          DPS(IK)=DPS(IK)+BP(I(IJ),IK)
 200    CONTINUE
 100  CONTINUE

      DMASS=DPS(4)**2-DPS(3)**2-DPS(2)**2-DPS(1)**2
      ARMASS=MAX(DMASS,0.0D0)

      RETURN

C**** END OF ARMASS ****************************************************
      END
C***********************************************************************
C $Id: armcdi.f,v 3.4 1994/05/11 07:10:35 lonnblad Exp $
CDECK  ID>, ARMCDI.
      SUBROUTINE ARMCDI(ARRNDX,ARRNDY,ARVETO)

C...ARiadne subroutine Monte Carlo DIstribution

C...Generates x_1 and x_3 for a radiating dipole

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


C...Exit if below cut
 100  IF (XT2M.LT.XT2C) GOTO 900
      QFAIL=.FALSE.

C...Generate random XT2
      XT2=ARRNDX()
      IF (XT2.LT.XT2C) GOTO 900
      XT=SQRT(XT2)

C...Generate rapidity Y
      Y=ARRNDY()

C...Calculate energy fractions
      B1=BC1-XT*EXP(Y)
      B3=BC3-XT*EXP(-Y)
      B2=2.0-B1-B3

C...Set maximum XT2 for possible next random call (VETO algorithm)
      XT2M=XT2

C...Redo random calls according to veto-algorithm
      IF (QFAIL.OR.ARVETO().LE.RLU(IDUM)) GOTO 100

C...Check that Current values are kinematically allowed
      CALL ARCHKI(0,IOK)
      IF (IOK.EQ.0) GOTO 100

      RETURN

C...If below cuts set XT2 to 0
 900  B1=BC1
      B3=BC3
      XT2=0.0

      RETURN

C**** END OF ARMCDI ****************************************************
      END
C***********************************************************************
C $Id: armipt.f,v 3.4 1994/10/07 09:31:05 lonnblad Exp $
CDECK  ID>, ARMIPT.
      REAL FUNCTION ARMIPT(IFST,ILST)

C...ARiadne function determine MInimum PT2

C...Determines the minimum p_t^2 of any gluon between positions 
C...IF and IL.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/

      INXT(IP)=IP3(IDO(IP))
      IPRV(IP)=IP1(IDI(IP))


      ARMIPT=PARA(40)
      DO 100 I=IFST,ILST
        IF (.NOT.QQ(I)) THEN
          IF (INXT(I).NE.IPRV(I))
     $         ARMIPT=MIN(ARMIPT,ARIPT2(IPRV(I),I,INXT(I)))
        ENDIF
 100  CONTINUE

      RETURN

C**** END OF ARMIPT ****************************************************
      END
C***********************************************************************
C $Id: arnofl.f,v 3.3 1994/10/06 16:49:49 lonnblad Exp $
CDECK  ID>, ARNOFL.
      REAL FUNCTION ARNOFL(W,MNOFL)

C...ARiadne function Number Of FLavours 

C...Returns the number of flavourspossible at energy W

      COMMON /ARDAT2/ PQMAS(10)
      SAVE /ARDAT2/


      ARNOFL=0.0
      DO 100 I=1,MNOFL
        IF (W.LT.2.0*PQMAS(I)) RETURN
        ARNOFL=REAL(I)
 100  CONTINUE

      RETURN

C**** END OF ARNOFL ****************************************************
      END
C***********************************************************************
C $Id: arordj.f,v 3.3 1994/05/11 07:10:38 lonnblad Exp $
CDECK  ID>, ARORDJ.
      SUBROUTINE ARORDJ(NJET)

C...ARiadne subroutine ORDer Jets

C...Orders jets in falling energy

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/


C...Error if no space left in /ARPART/
      IF (IPART+N.GT.MSTU(4)) THEN
        CALL LUERRM(11,'(ARCLUS:) no more memory left in LUJETS')
        NJET=-1
        MSTU(3)=0
        RETURN
      ENDIF

C...Tag all jets to be copied
      NJET=0
      DO 100 I=1,IPART
        QQ(I)=QDONE(I)
        IF (.NOT.QDONE(I)) NJET=NJET+1
 100  CONTINUE

C...Loop twice to get jets in falling order in energy
      IJ=N
      DO 200 II=1,NJET
        EMAX=-1.0
        IEMAX=0
        DO 210 I=1,IPART
          IF (QQ(I)) GOTO 210
          IF (BP(I,4).LE.EMAX) GOTO 210
          EMAX=BP(I,4)
          IEMAX=I
 210    CONTINUE

C...Copy jet into /LUJETS/

        IJ=IJ+1
        DO 220 J=1,5
          P(IJ,J)=BP(IEMAX,J)
          K(IJ,J)=0
 220    CONTINUE
        K(IJ,1)=31
        K(IJ,2)=97
        QQ(IEMAX)=.TRUE.

 200  CONTINUE

      MSTU(3)=NJET

      RETURN

C**** END OF ARORDJ ****************************************************
      END
C***********************************************************************
C $Id: arorie.f,v 3.3 1995/11/30 10:15:28 leif Exp $
CDECK  ID>, ARORIE.
      SUBROUTINE ARORIE(I1,I2,I3,BS,B1,B3,QR1,QR3,PT21,PT23)

C...ARiadne subroutine ORIEnt

C...Orients three partons according to recoil strategy determined
C...by QR1 and QR3

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/

      INXT(I)=IP3(IDO(I))
      IPRV(I)=IP1(IDI(I))


C...Set parton energies and momentum and total energy
      BW=SQRT(BS)
      IF (B1.LE.0.0) CALL ARERRM('ARORIE',9,0)
      DE1=0.5*B1*BW
      IF (B3.LE.0.0) CALL ARERRM('ARORIE',9,0)
      DE3=0.5*B3*BW
      DE2=BW-DE1-DE3
      IF (DE2.LT.BP(I2,5)) CALL ARERRM('ARORIE',9,0)
      DP1=SQRT(DE1**2-BP(I1,5)**2)
      DP2=SQRT(DE2**2-BP(I2,5)**2)
      DP3=SQRT(DE3**2-BP(I3,5)**2)

C...If both partons 1 and 3 can take full recoil choose one according to
C...Kleiss
      IF (QR1.AND.QR3) THEN
        IF (B1**2.GT.(B1**2+B3**2)*RLU(IDUM)) THEN
          QR1=.FALSE.
        ELSE
          QR3=.FALSE.
        ENDIF
      ENDIF

C...Calculate angle between partons 1 and 3
      BCALP=1.0
      IF (DP1.GT.0.0.AND.DP3.GT.0.0) THEN
        BCALP=(DP2**2-DP1**2-DP3**2)/(2.0*DP1*DP3)
      ELSE
        CALL ARERRM('ARORIE',9,0)
      ENDIF
      IF (ABS(BCALP).GT.1.0) CALL ARERRM('ARORIE',9,0)
      BCALP=MAX(-1.0D0,MIN(1.0D0,DBLE(BCALP)))
      BALP=ACOS(BCALP)

C...Determine angle between parton 1 and z-axis
      IF (QR1.AND.PT21.LE.0.0.AND.PT23.LE.0.0) THEN
        BPSI=PARU(1)-BALP
      ELSEIF (QR3.AND.PT21.LE.0.0.AND.PT23.LE.0.0) THEN
        BPSI=0.0
      ELSE
        BPSI=(PARU(1)-BALP)*(B3**2)/(B1**2+B3**2)

C...New recoil strategy
        IF (PT21.GT.0.0.AND.PT21.GE.PT23) THEN
          I0=IPRV(I1)
          BPSI=ARECOI(BP(I0,4),DE1,DE2,DE3,ABS(BP(I0,3)),DP1,DP2,DP3,
     $         BALP,PT21)
        ELSEIF (PT23.GT.0.0.AND.PT23.GT.PT21) THEN
          I4=INXT(I3)
          BPSI=PARU(1)-BALP-
     $         ARECOI(BP(I4,4),DE3,DE2,DE1,ABS(BP(I4,3)),
     $         DP3,DP2,DP1,BALP,PT23)
        ENDIF
      ENDIF

C...Set random azimuth angle
      BGAM=PARU(2)*RLU(IDUM)
      BSGAM=SIN(BGAM)
      BCGAM=COS(BGAM)
      BSPSI=SIN(BPSI)
      BCPSI=COS(BPSI)
      BSPSA=SIN(BPSI+BALP)
      BCPSA=COS(BPSI+BALP)

C...Set fourmomentum of partons
      BP(I1,1)=DP1*BSPSI*BSGAM
      BP(I1,2)=-DP1*BSPSI*BCGAM
      BP(I1,3)=DP1*BCPSI
      BP(I1,4)=DE1

      BP(I3,1)=DP3*BSPSA*BSGAM
      BP(I3,2)=-DP3*BSPSA*BCGAM
      BP(I3,3)=DP3*BCPSA
      BP(I3,4)=DE3

      DZ2=-DP1*BCPSI-DP3*BCPSA
      DT2=DSQRT(MAX(DP2**2-DZ2**2,0.0D0))
      BP(I2,1)=-DT2*BSGAM
      BP(I2,2)=DT2*BCGAM
      BP(I2,3)=DZ2
      BP(I2,4)=DE2

      RETURN

C**** END OF ARORIE ****************************************************
      END
C***********************************************************************
C $Id: arorie.f,v 3.3 1995/11/30 10:15:28 leif Exp $
CDECK  ID>, ARECOI.
      REAL FUNCTION ARECOI(BE0,DE1,DE2,DE3,BP0,DP1,DP2,DP3,BALP,PT12)

C...Ariadne function RECOIl

C...Calculates the angle of a recoil gluon according to the new
C...Recoil strategy: p_t1^2*exp(-y_1)=p_t2^2*exp(-y_2)

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/

C...Calculate the maximum and minimum angle
      PHIL=0.0
      PHIU=PARU(1)-BALP

C...Calculate angle of recoil gluon
      BW=DE1+DE2+DE3
      BS=BW**2
      BM3=DE3**2-DP3**2
      S0123=(BW+BE0)**2-BP0**2
      S12=BS-2.0*BW*DE3+BM3
      S23=BS-2.0*BW*DE1
      S13=BS-2.0*BW*DE2
      D01=2.0*S12*DE1*BE0
      D02=2.0*S12*DP1*BP0
      D03=PT12*(S0123-S13-S23+BM3-2.0*DE3*BE0)
      D04=2*DP3*BP0*PT12*COS(BALP)
      D05=2*DP3*BP0*PT12*SIN(BALP)
      D11=D01-D03
      D12=D05
      D13=D04+D02
      D21=(D11**2-D13**2)/(D12**2+D13**2)
      D22=D12*D11/(D12**2+D13**2)
      D31=D22**2-D21
      DSPHI=SQRT(MAX(D31,0.0D0))-D22
      IF (DSPHI.LT.0.0D0) THEN
        PHI=PHIL
      ELSEIF (DSPHI.GE.1.0D0) THEN
        PHI=PHIU
      ELSE
        PHI=MIN(ASIN(DSPHI),DBLE(PARU(1))-BALP)
      ENDIF

      ARECOI=PHI

      RETURN


C**** END OF ARECOI ****************************************************
      END
C***********************************************************************
C $Id: arpars.f,v 3.10 1995/08/13 17:29:14 lonnblad Exp $
CDECK  ID>, ARPARS.
      SUBROUTINE ARPARS(NSTART,NEND)

C...ARiadne subroutine PARSe the event record

C...Parse through the /LUJETS/ event record to find un-cascaded
C...strings. Performs dipole cascade on each found.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/


      IDIR=0
      QQ(MAXPAR-3)=.FALSE.
      QQ(MAXPAR-4)=.FALSE.

C...Loop over entries in /LUJETS/ to be considered
      DO 100 I=NSTART,NEND

C...If IDIR=0 there is no current string so skip all entries which
C...are not the begining of a string (K(I,1)=2) otherwise copy
C...parton to dipole record
        IF (IDIR.EQ.0) THEN
          IF (K(I,1).NE.2) THEN
            K(I,4)=MAX(K(I,4),0)
            GOTO 100
          ENDIF
          CALL ARGTYP(I,ITYP)
          IF (MHAR(133).GE.1.AND.ITYP.EQ.2.AND.K(I,3).EQ.0) THEN
            K(I,4)=MAX(K(I,4),0)
            GOTO 100
          ENDIF            
          IF (MHAR(133).GE.3.AND.K(I,3).EQ.0) THEN
            K(I,4)=MAX(K(I,4),0)
            GOTO 100
          ENDIF            
          IF (ITYP.EQ.0) CALL ARERRM('ARPARS',1,I)
          IDIR=ITYP
          IMF=I
          IPART=1
          IDIPS=0
          CALL ARCOPA(I,IPART,ITYP)
        ELSE

C...If in a string, copy parton and create a dipole. Error if
C...colour singlets of triplets are found
          IF (K(I,1).EQ.2) THEN
            CALL ARGTYP(I,ITYP)
            IF (ABS(ITYP).EQ.1) CALL ARERRM('ARPARS',2,I)
            IF (ABS(ITYP).EQ.0) CALL ARERRM('ARPARS',1,I)
            IPART=IPART+1
            IDIPS=IDIPS+1
            CALL ARCOPA(I,IPART,ITYP)
            CALL ARCRDI(IDIPS,IPART-1,IPART,1,.FALSE.)
            CALL ARCOLI(IDIPS,-1)

C...If the end of a string check colour flow and consistency
          ELSEIF (K(I,1).EQ.1) THEN
            CALL ARGTYP(I,ITYP)
            IF (ITYP.EQ.0) CALL ARERRM('ARPARS',1,I)
            IML=I
            IPART=IPART+1
            IDIPS=IDIPS+1
            CALL ARCOPA(I,IPART,ITYP)
            CALL ARCRDI(IDIPS,IPART-1,IPART,1,.FALSE.)
            CALL ARCOLI(IDIPS,-1)
C...........If purely gluonic string create extra dipole
            IF (ITYP.EQ.2) THEN
              IF (IDIR.NE.2) CALL ARERRM('ARPARS',4,I)
              IDIPS=IDIPS+1
              CALL ARCRDI(IDIPS,IPART,1,1,.FALSE.)
              CALL ARCOLI(IDIPS,-1)
C...........If ordinary string create EM-dipole
            ELSE
              IF (ITYP.NE.-IDIR) CALL ARERRM('ARPARS',5,I)
              IF (MSTA(20).GT.0.AND.IDIPS.EQ.1.AND.
     $               (.NOT.QEX(1)).AND.(.NOT.QEX(IPART))) THEN
                IDIPS=IDIPS+1
                CALL ARCRDI(IDIPS,IPART,1,1,.TRUE.)
              ENDIF
            ENDIF

C...Initialize string variables in dipole record and perform cascade
            PT2LST=PARA(40)
            IF (MSTA(14).GE.1.AND.IPART.GT.2) PT2LST=ARMIPT(1,IPART)
            IF (PARA(6).GT.0.0) PT2LST=MIN(PT2LST,PARA(6))
            IF (MHAR(133).LT.0) PT2LST=P(I,1)**2+P(I,2)**2
C...Special case if purely gluonic string
            IF (IDIR.EQ.2) THEN
C...Don't allow purely gluonic strings
C              IDIR=0
C              GOTO 100
            ENDIF
            IPF(1)=1
            IPL(1)=IPART
            ISTRS=1
            IFLOW(1)=IDIR
            CALL AREXMA(1,IPART)
            QDUMP=.FALSE.
            CALL ARCASC
            IDIR=0
          ENDIF
        ENDIF
 100  CONTINUE


      RETURN

C**** END OF ARPARS ****************************************************
      END
C***********************************************************************
C $Id: arradg.f,v 3.14 1995/08/15 09:08:55 lonnblad Exp $
CDECK  ID>, ARRADG.
      SUBROUTINE ARRADG(ID,NREM,SNR,PT21,PT23)

C...ARiadne subroutine RADiate Gluon

C...Performs the radiation of a gluon from dipole ID

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT2/ DBEX,DBEY,DBEZ,PHI,THE
      SAVE /ARINT2/
      COMMON /ARINT4/ BASS(5),BASSX1,BASSX3,IFLASS
      SAVE /ARINT4/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/

      INXT(I)=IDO(IP3(I))


C...Boost dipole to its CMS
      CALL ARBOCM(ID)

C...Copy some information about dipole
      BS=ARMAS2(IP1(ID),IP3(ID))
      IF (ABS(BS-SDIP(ID)).GT.(BS+SDIP(ID))*PARA(39).AND.
     $     MSTA(9).GE.2) CALL ARERRM('ARRADG',13,0)

      BW=SQRT(BS)
      B1=BX1(ID)
      B3=BX3(ID)
      QE1=QEX(IP1(ID))
      QE3=QEX(IP3(ID))

C...If parton not extended - no recoil gluon (trivial)
      IF (.NOT.QE1) AEX1(ID)=2.0
      IF (.NOT.QE3) AEX3(ID)=2.0

C...No recoil gluon if reemission
      IF (NREM.EQ.1) AEX1(ID)=2.0
      IF (NREM.EQ.3) AEX3(ID)=2.0

C...If AEX1(3) >= 1 then no recoil gluon
      IF (MSTA(17).EQ.0) THEN
        AEX1(ID)=2.0
        AEX3(ID)=2.0
      ENDIF

C...No recoil gluons if not enough energy left for original parton
      IF (AEX1(ID).LT.1.0.OR.AEX3(ID).LT.1.0) THEN
        BY1=BP(IP1(ID),5)**2/BS
        BY3=BP(IP3(ID),5)**2/BS
        BPT=0.5*BW*(1.0+BY1-BY3+SQRT(1.0+(BY1-BY3)**2-2.0*(BY1+BY3)))
        IF (MSTA(25).GT.0) THEN
          B1P=(1.0-AEX1(ID))*(BPT-BP(IP1(ID),5))+BP(IP1(ID),5)
        ELSE
          B1P=(1.0-AEX1(ID))*BPT
        ENDIF
        IF (B1P.LE.BP(IP1(ID),5)) THEN
          AEX1(ID)=2.0
          B1P=0.0
          B1M=0.0
        ELSE
          B1M=BS*BY1/B1P
        ENDIF
        BMT=0.5*BW*(1.0+BY3-BY1+SQRT(1.0+(BY1-BY3)**2-2.0*(BY1+BY3)))
        IF (MSTA(25).GT.0) THEN
          B3M=(1.0-AEX3(ID))*(BMT-BP(IP3(ID),5))+BP(IP3(ID),5)
        ELSE
          B3M=(1.0-AEX3(ID))*BMT
        ENDIF
        IF (B3M.LE.BP(IP3(ID),5)) THEN
          AEX3(ID)=2.0
          B3P=0.0
          B3M=0.0
        ELSE
          B3P=BS*BY3/B3M
        ENDIF
      ENDIF

C...Check if any parton can take full recoil.
      QR1=(QQ(IP1(ID)).AND.MSTA(16).GE.1.AND.((.NOT.QEX(IP1(ID))).OR.
     $     (QEX(IP1(ID)).AND.MSTA(16).EQ.2.AND.AEX1(ID).GE.1.0)))
      QR3=(QQ(IP3(ID)).AND.MSTA(16).GE.1.AND.((.NOT.QEX(IP3(ID))).OR.
     $     (QEX(IP3(ID)).AND.MSTA(16).EQ.2.AND.AEX3(ID).GE.1.0)))

C...No recoil gluons if one parton can take full recoil
      IF ((AEX1(ID).LT.1.0.OR.AEX3(ID).LT.1.0).AND.
     $     (MSTA(17).EQ.1.OR.MSTA(17).EQ.2)) THEN
        IF (QR3.AND.NREM.NE.3) AEX1(ID)=2.0
        IF (QR1.AND.NREM.NE.1) AEX3(ID)=2.0
      ENDIF

      QRG1=(AEX1(ID).LT.1.0)
      QRG3=(AEX3(ID).LT.1.0)

      IDE=ID

C...Add recoil gluon for parton 1
      IF (QRG1) THEN
        CALL ARADDG(ID,1)
        IDE=INXT(ID)
        BP(IP1(ID),1)=0.0
        BP(IP1(ID),2)=0.0
        BP(IP1(ID),3)=0.5*(B1P-B1M)
        BP(IP1(ID),4)=0.5*(B1P+B1M)
        INO(IP3(ID))=-IO
      ENDIF

C...Add emitted gluon
      IF ((MHAR(134).EQ.0.AND.B1.GT.B3).OR.
     $     (MHAR(134).EQ.1.AND.B1**2.GT.RLU(0)*(B1**2+B3**2))) THEN
        CALL ARADDG(IDE,3)
      ELSE
        CALL ARADDG(IDE,1)
      ENDIF

      INO(IP3(IDE))=IO

C...Add recoil gluon for parton 3
      IF (QRG3) THEN
        IDL=INXT(IDE)
        CALL ARADDG(IDL,3)
        IDL=INXT(IDL)
        BP(IP3(IDL),1)=0.0
        BP(IP3(IDL),2)=0.0
        BP(IP3(IDL),3)=0.5*(B3P-B3M)
        BP(IP3(IDL),4)=0.5*(B3P+B3M)
        INO(IP1(IDL))=-IO
      ENDIF

      IF (NREM.EQ.0) THEN
        IF (QRG1.AND.QRG3) THEN
          SNR3=BS*((BW-B1M)*(1.0-B1+BY1-BY3)/BW+BY3)
          SNR1=BS*((BW-B3P)*(1.0-B3+BY3-BY1)/BW+BY1)
        ELSEIF (QRG1) THEN
          SNR=BS*(1.0-B3+BY3)
        ELSEIF (QRG3) THEN
          SNR=BS*(1.0-B1+BY1)
        ELSE
          SNR=0.0
        ENDIF
      ENDIF

      PT21=0.0
      PT23=0.0
      IF (QRG1.OR.QRG3) THEN
        B2M=(1.0-B3+BY3-BY1)*BW
        B2P=(1.0-B1+BY1-BY3)*BW
        IF (QRG1.AND.MSTA(17).GE.2) PT21=(B2M*B2P**3)/(BW-B1P-B2P)**2
        IF (QRG3.AND.MSTA(17).GE.2) PT23=(B2P*B2M**3)/(BW-B3M-B2M)**2
        DA=(BW-B1P-B3P)/(BW-B1M-B3M)
        SA=(BW-B1P-B3P)*(BW-B1M-B3M)/BS
        DB=(DA-1.0D0)/(DA+1.0D0)
        BY1A=BY1/SA
        IF (QRG1) BY1A=0.0
        BY3A=BY3/SA
        IF (QRG3) BY3A=0.0
        BS=BS*SA
        B1=1.0-(1.0-B1+BY1-BY3)/SQRT(SA*DA)+BY1A-BY3A
        B3=1.0-(1.0-B3+BY3-BY1)/SQRT(SA/DA)+BY3A-BY1A

        IF (QRG1) CALL AROBO1(0.0,0.0,0.0D0,0.0D0,-DB,IP1(ID))
        IF (QRG3) CALL AROBO1(0.0,0.0,0.0D0,0.0D0,-DB,IP3(IDL))
      ENDIF

C...Disable Kleiss orientation if extended partons
      IF (QR1.AND.QR3.AND.(QE1.OR.QE3)) THEN
        QR1=.FALSE.
        QR3=.FALSE.
      ENDIF

C...Orientate the emitted partons
      IF (NREM.EQ.0) THEN
        CALL ARORIE(IP1(IDE),IP3(IDE),IP3(INXT(IDE)),BS,B1,B3,QR1,QR3,
     $       PT21,PT23)
      ELSEIF (NREM.EQ.1) THEN
        QR1=.FALSE.
        QR3=.TRUE.
        CALL ARORIE(IP1(IDE),IP3(IDE),IP3(INXT(IDE)),BS,B1,B3,
     $       QR1,QR3,0.0,0.0)
      ELSEIF (NREM.EQ.3) THEN
        QR1=.TRUE.
        QR3=.FALSE.
        CALL ARORIE(IP1(IDE),IP3(IDE),IP3(INXT(IDE)),BS,B1,B3,
     $       QR1,QR3,0.0,0.0)
      ENDIF

C...Boost created dipoles back to original CMS, Optionally including
      IF ((.NOT.QRG1).AND.(.NOT.QRG3)) THEN
        CALL AROBO3(THE,PHI,DBEX,DBEY,DBEZ,
     $              IP1(IDE),IP3(IDE),IP3(INXT(IDE)))
      ELSEIF (QRG1.AND.(.NOT.QRG3)) THEN
        IF (MSTA(17).LT.2) PT21=ARIPT2(IP1(ID),IP1(IDE),IP3(IDE))
        CALL AROBO4(0.0,0.0,0.0D0,0.0D0,DB,
     $              IP1(ID),IP1(IDE),IP3(IDE),IP3(INXT(IDE)))
        CALL AROBO4(THE,PHI,DBEX,DBEY,DBEZ,
     $              IP1(ID),IP1(IDE),IP3(IDE),IP3(INXT(IDE)))
      ELSEIF ((.NOT.QRG1).AND.QRG3) THEN
        IF (MSTA(17).LT.2)
     $       PT23=ARIPT2(IP1(IDE),IP3(IDE),IP3(INXT(IDE)))
        CALL AROBO4(0.0,0.0,0.0D0,0.0D0,DB,
     $              IP1(IDE),IP3(IDE),IP3(INXT(IDE)),IP3(IDL))
        CALL AROBO4(THE,PHI,DBEX,DBEY,DBEZ,
     $              IP1(IDE),IP3(IDE),IP3(INXT(IDE)),IP3(IDL))
      ELSEIF (QRG1.AND.QRG3) THEN
        IF (MSTA(17).LT.2) THEN
          PT21=ARIPT2(IP1(ID),IP1(IDE),IP3(IDE))
          PT23=ARIPT2(IP3(IDE),IP3(INXT(IDE)),IP3(IDL))
        ENDIF
        IF (PT21.GE.PT23) THEN
          SNR=SNR3
        ELSE
          SNR=SNR1
        ENDIF
        CALL AROBO5(0.0,0.0,0.0D0,0.0D0,DB,
     $              IP1(ID),IP1(IDE),IP3(IDE),IP3(INXT(IDE)),IP3(IDL))
        CALL AROBO5(THE,PHI,DBEX,DBEY,DBEZ,
     $              IP1(ID),IP1(IDE),IP3(IDE),IP3(INXT(IDE)),IP3(IDL))
      ENDIF

C...Special treatment for Drell-Yan produced particles
      IF (QQ(MAXPAR-2).AND.NREM.EQ.0) THEN
        IF (ARDYRE(IDE,BW,QRG1,QRG3).GT.0.0) SNR=0.0
      ENDIF

C...Register radiated gluon for subsequent calculation of azimuthal
C...Asymmetry for O(alpha_) lepto-production  ME
      IG=IP3(IDE)
      IF (IO.EQ.1.AND.MSTA(1).EQ.3.AND.ABS(MSTA(33)).EQ.1) THEN
        DO 200 J=1,5
          BASS(J)=BP(IG,J)
 200    CONTINUE
        IFLASS=IFL(IG)
      ENDIF

      IF (IO.EQ.1.AND.NREM.EQ.0) THEN
        PHAR(121)=0.5*LOG(MAX(BP(IG,4)+BP(IG,3),1.0D-30)/
     $       MAX(BP(IG,4)-BP(IG,3),1.0D-30))
        PHAR(122)=BP(IG,1)**2+BP(IG,2)**2
      ENDIF

 100  CONTINUE

      RETURN

C**** END OF ARRADG ****************************************************
      END
C***********************************************************************
C $Id: arradp.f,v 3.2 1994/05/11 07:10:46 lonnblad Exp $
CDECK  ID>, ARRADP.
      SUBROUTINE ARRADP(ID)

C...ARiadne subroutine RADiate Photon

C...Performs the radiation of a photon from EM-dipole ID

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT2/ DBEX,DBEY,DBEZ,PHI,THE
      SAVE /ARINT2/

      INXT(I)=IDO(IP3(I))
      IPRV(I)=IDI(IP1(I))

C...Boost dipole to its CMS, and get its invaiant mass^2
      CALL ARBOCM(ID)
      BS=ARMAS2(IP1(ID),IP3(ID))
      IF (ABS(BS-SDIP(ID)).GT.(BS+SDIP(ID))*PARA(39).AND.
     $     MSTA(9).GE.2) CALL ARERRM('ARRADG',13,0)

      QR1=.TRUE.
      QR3=.TRUE.
C...Use position IPART+1 temporarily for the photon and orientate
C...the particles/partons
      BP(IPART+1,5)=0.0
      CALL ARORIE(IP1(ID),IPART+1,IP3(ID),BS,BX1(ID),BX3(ID),
     $            QR1,QR3,0.0,0.0)

C...Boost back to original CMS
      CALL AROBO3(THE,PHI,DBEX,DBEY,DBEZ,
     $            IP1(ID),IPART+1,IP3(ID))
C...Copy photon information to /LUJETS/
      CALL ARDUPH

C...Flagg dipoles that were affected by the emission
      QDONE(INXT(ID))=.FALSE.
      QDONE(IPRV(ID))=.FALSE.
      QDONE(ID)=.FALSE.

      RETURN

C**** END OF ARRADP ****************************************************
      END
C***********************************************************************
C $Id: arradq.f,v 3.2 1994/05/11 07:10:47 lonnblad Exp $
CDECK  ID>, ARRADQ.
      SUBROUTINE ARRADQ(ID)

C...ARiadne subroutine RADiate Q-qbar pair

C...Performs the emission of a q-qbar pair from gluon in dipole ID

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT2/ DBEX,DBEY,DBEZ,PHI,THE
      SAVE /ARINT2/

      INXT(I)=IDO(IP3(I))
      IPRV(I)=IDI(IP1(I))

C...Boost dipole to its CMS and copy its invariant mass^2
      CALL ARBOCM(ID)
      BS=ARMAS2(IP1(ID),IP3(ID))
      IF (ABS(BS-SDIP(ID)).GT.(BS+SDIP(ID))*PARA(39).AND.
     $     MSTA(9).GE.2) CALL ARERRM('ARRADQ',13,0)

C...Check which gluon to split
      IF (IRAD(ID).LT.0) THEN
C.......Determine patons ability to recoil, save pointers and flag
C.......affected dipoles
        QR1=.TRUE.
        QR3=(QQ(IP3(ID)).AND.MSTA(16).GT.0)
        IPG=IP1(ID)
        IDN=ID
        IDP=IPRV(ID)
        IF (INXT(ID).NE.0) QDONE(INXT(ID))=.FALSE.
C.......Split the gluon entry, orientate the partons, and boost back
        CALL ARSPLG(IPG,ABS(IRAD(ID)))
        CALL ARORIE(IP3(IDP),IP1(IDN),IP3(IDN),BS,BX1(ID),BX3(ID),
     $              QR1,QR3,0.0,0.0)
        CALL AROBO3(THE,PHI,DBEX,DBEY,DBEZ,
     $              IP3(IDP),IP1(IDN),IP3(IDN))
      ELSE
C.......Determine patons ability to recoil, save pointers and flag
C.......affected dipoles
        QR3=.TRUE.
        QR1=(QQ(IP1(ID)).AND.MSTA(16).GT.0)
        IPG=IP3(ID)
        IDP=ID
        IDN=INXT(ID)
        IF (IPRV(ID).NE.0) QDONE(IPRV(ID))=.FALSE.
C.......Split the gluon entry, orientate the partons, and boost back
        CALL ARSPLG(IPG,ABS(IRAD(ID)))
        CALL ARORIE(IP1(IDP),IP3(IDP),IP1(IDN),BS,BX1(ID),BX3(ID),
     $              QR1,QR3,0.0,0.0)
        CALL AROBO3(THE,PHI,DBEX,DBEY,DBEZ,
     $              IP1(IDP),IP3(IDP),IP1(IDN))
      ENDIF



      RETURN

C**** END OF ARRADQ ****************************************************
      END
C***********************************************************************
C $Id: arreca.f,v 3.4 1995/06/07 09:19:29 lonnblad Exp $
CDECK  ID>, ARRECA.
      SUBROUTINE ARRECA(ID,IDS,IS1,IS3)

C...ARiadne function RECAll

C...Recalls a dipole entry stored by ARSTOR

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/


      SDIP(ID)=SDIP(IDS)
      IP1(ID)=IP1(IDS)
      IP3(ID)=IP3(IDS)
      BX1(ID)=BX1(IDS)
      BX3(ID)=BX3(IDS)
      PT2IN(ID)=PT2IN(IDS)
      AEX1(ID)=AEX1(IDS)
      AEX3(ID)=AEX3(IDS)
      QDONE(ID)=QDONE(IDS)
      QEM(ID)=QEM(IDS)
      IRAD(ID)=IRAD(IDS)
      ISTR(ID)=ISTR(IDS)
      ICOLI(ID)=ICOLI(IDS)

      I1=IP1(ID)
      I3=IP3(ID)

      DO 100 I=1,5
        BP(I1,I)=BP(IS1,I)
        BP(I3,I)=BP(IS3,I)
 100  CONTINUE
      IFL(I1)=IFL(IS1)
      IFL(I3)=IFL(IS3)
      QEX(I1)=QEX(IS1)
      QEX(I3)=QEX(IS3)
      XPA(I1)=XPA(IS1)
      XPA(I3)=XPA(IS3)
      XPMU(I1)=XPMU(IS1)
      XPMU(I3)=XPMU(IS3)
      PT2GG(I1)=PT2GG(IS1)
      PT2GG(I3)=PT2GG(IS3)
      QQ(I1)=QQ(IS1)
      QQ(I3)=QQ(IS3)
      IDI(I1)=IDI(IS1)
      IDI(I3)=IDI(IS3)
      IDO(I1)=IDO(IS1)
      IDO(I3)=IDO(IS3)
      INO(I1)=INO(IS1)
      INO(I3)=INO(IS3)

      RETURN

C**** END OF ARRECA ****************************************************
      END
C***********************************************************************
C $Id: arupdj.f,v 3.5 1994/05/11 07:10:57 lonnblad Exp $
CDECK  ID>, ARUPDJ.
      SUBROUTINE ARUPDJ(I2,I1,I3)
 
C...ARiadne subroutine UPDate Jet entry
 
C...Takes a jet entry I2 and determines its minimum invariant pt wrt.
C...all other jets. I1 and I3 indicates which jets have been changed
C...since last call
 
      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/


      IF (QDONE(I2)) RETURN

      BP21=BP(I2,1)
      BP22=BP(I2,2)
      BP23=BP(I2,3)
      BP24=BP(I2,4)
      BP25=BP(I2,5)
      BP252=BX1(I2)
      B0=0.0

      IF (I1.EQ.0.OR.QDONE(IDI(I2)).OR.QDONE(IDO(I2)).OR.I2.EQ.I1.OR.
     $     I2.EQ.I3.OR.IDI(I2).EQ.I1.OR.IDO(I2).EQ.I3) THEN

C...If jet I2 has been changed or if jets wrt. which I2 has minimum pt
C...has been changed then recalculate minimum pt from scratch
        PT2IN(I2)=PARA(40)
        DO 100 J1=1,IPART-1
          IF ((.NOT.QDONE(J1)).AND.J1.NE.I2) THEN
            BP11=BP(J1,1)
            BP12=BP(J1,2)
            BP13=BP(J1,3)
            BP14=BP(J1,4)
            BP15=BP(J1,5)
            BP152=BX1(J1)
            BP1P2=MAX(BP14*BP24-BP13*BP23-BP12*BP22-BP11*BP21,B0)
            BR12=MAX(BP1P2-BP15*BP25,B0)
            DO 110 J3=J1+1,IPART
              IF ((.NOT.QDONE(J3)).AND.J3.NE.I2) THEN
                BP31=BP(J3,1)
                BP32=BP(J3,2)
                BP33=BP(J3,3)
                BP34=BP(J3,4)
                BP2P3=MAX(BP34*BP24-BP33*BP23-BP32*BP22-BP31*BP21,B0)
                BR23=MAX(BP2P3-BP25*BP(J3,5),B0)
                BP1P3=MAX(BP14*BP34-BP13*BP33-BP12*BP32-BP11*BP31,B0)
                PT2I=4.0*BR12*BR23/(BP152+BP252+BX1(J3)+
     $               2.0*(BP1P2+BP2P3+BP1P3))
                IF (PT2I.LT.PT2IN(I2)) THEN
                  PT2IN(I2)=PT2I
                  IDI(I2)=J1
                  IDO(I2)=J3
                ENDIF
              ENDIF
 110        CONTINUE
          ENDIF
 100    CONTINUE
      ELSE

C...Check all combinations involving changed jets to see if new minimum pt
C...is obtained.
        BP11=BP(I1,1)
        BP12=BP(I1,2)
        BP13=BP(I1,3)
        BP14=BP(I1,4)
        BP15=BP(I1,5)
        BP152=BX1(I1)
        BP31=BP(I3,1)
        BP32=BP(I3,2)
        BP33=BP(I3,3)
        BP34=BP(I3,4)
        BP35=BP(I3,5)
        BP352=BX1(I3)
        BP1P2=MAX(BP14*BP24-BP13*BP23-BP12*BP22-BP11*BP21,B0)
        BP2P3=MAX(BP34*BP24-BP33*BP23-BP32*BP22-BP31*BP21,B0)
        BR12=MAX(BP1P2-BP15*BP25,B0)
        BR23=MAX(BP2P3-BP25*BP35,B0)

        DO 200 J=1,IPART
          IF (J.NE.I2.AND.(.NOT.QDONE(J))) THEN
            BPJ1=BP(J,1)
            BPJ2=BP(J,2)
            BPJ3=BP(J,3)
            BPJ4=BP(J,4)
            BPJ52=BX1(J)
            BPJP2=MAX(BPJ4*BP24-BPJ3*BP23-BPJ2*BP22-BPJ1*BP21,B0)
            BRJ2=MAX(BPJP2-BP(J,5)*BP25,B0)
            IF (J.NE.I1) THEN
              BP1PJ=MAX(BP14*BPJ4-BP13*BPJ3-BP12*BPJ2-BP11*BPJ1,B0)
              PT2I=4.0*BR12*BRJ2/(BP152+BP252+BPJ52+
     $             2.0*(BP1P2+BPJP2+BP1PJ))
              IF (PT2I.LT.PT2IN(I2)) THEN
                PT2IN(I2)=PT2I
                IF (J.GT.I1) THEN
                  IDI(I2)=I1
                  IDO(I2)=J
                ELSE
                  IDI(I2)=J
                  IDO(I2)=I1
                ENDIF
              ENDIF
            ENDIF
            IF (J.NE.I3) THEN
              BPJP3=MAX(BPJ4*BP34-BPJ3*BP33-BPJ2*BP32-BPJ1*BP31,B0)
              PT2I=4.0*BRJ2*BR23/(BPJ52+BP252+BP352+
     $             2.0*(BPJP2+BP2P3+BPJP3))
              IF (PT2I.LT.PT2IN(I2)) THEN
                PT2IN(I2)=PT2I
                IF (J.LT.I3) THEN
                  IDI(I2)=J
                  IDO(I2)=I3
                ELSE
                  IDI(I2)=I3
                  IDO(I2)=J
                ENDIF
              ENDIF
            ENDIF
          ENDIF
 200    CONTINUE
      ENDIF

      RETURN
 
C**** END OF ARUPDJ ****************************************************
      END
C***********************************************************************
C $Id: arrndx.f,v 3.3 1994/05/11 07:10:49 lonnblad Exp $
CDECK  ID>, ARNDX.
      REAL FUNCTION ARNDX1()

C...Ariadne function RNDom Xt2 version 1

C...Generate an x_t^2 according to a Sudakov suppressed distribution.
C...Suitable for running alpha_QCD

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARNDX1=0.0
      ARG=RLU(IDUM)
      IF (LOG(ARG)*CN.LT.LOG(LOG(XT2C/XLAM2)/LOG(XT2M/XLAM2))) RETURN
      ARNDX1=XLAM2*(XT2M/XLAM2)**(ARG**CN)

      RETURN

C**** END OF ARNDX1 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARNDX2.
      REAL FUNCTION ARNDX2()

C...Ariadne function RNDom Xt2 version 2

C...Generate an x_t^2 according to a Sudakov suppressed distribution.
C...Suitable for constant alpha_QCD and QED emission

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARNDX2=0.0
      ARG=RLU(IDUM)
      IF (CN*LOG(ARG).LT.(LOG(XT2M))**2-(LOG(XT2C))**2) RETURN
      ARNDX2=EXP(-SQRT((LOG(XT2M))**2-LOG(ARG)*CN))

      RETURN

C**** END OF ARNDX2 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARNDX3.
      REAL FUNCTION ARNDX3()

C...Ariadne function RNDom Xt2 version 3

C...Generate an x_t^2 according to a Sudakov suppressed distribution.
C...Suitable for constant alpha_QCD q-qbar emission

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARNDX3=0.0
      ARG=RLU(IDUM)
      IF (LOG(ARG)*CN.LT.LOG(XT2C/XT2M)) RETURN
      ARNDX3=XT2M*(ARG**CN)

      RETURN

C**** END OF ARNDX3 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARNDX4.
      REAL FUNCTION ARNDX4()

C...Ariadne function RNDom Xt2 version 4

C...Generate an x_t^2 according to a Sudakov suppressed distribution.
C...Suitable for O(alpha_S) ME boson-gluon processes

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARNDX4=0.0
      ARG=RLU(IDUM)
      IF (LOG(ARG)*CN.LT.1.0/XT2M-1.0/XT2C) RETURN
      ARNDX4=1.0/(1.0/XT2M-CN*LOG(ARG))

      RETURN

C**** END OF ARNDX4 ****************************************************
      END
C***********************************************************************
C***********************************************************************
C $Id: arrndy.f,v 3.12 1995/08/13 17:29:21 lonnblad Exp $
CDECK  ID>, ARNDY1.
      REAL FUNCTION ARNDY1()

C...Ariadne function RaNDom Y version 1

C...Generates a properly distributed Y
C...Suitable for gluon and photon emission

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ZMAX=SQRT(XTS/XT2)+SQRT(MAX(XTS/XT2-1.0,0.0))
      YMAX=LOG(MIN(ZMAX,XT3/XT))
      YMIN=-LOG(MIN(ZMAX,XT1/XT))

      ARNDY1=YMIN+RLU(IDUM)*(YMAX-YMIN)

      RETURN

C**** END OF ARNDY1 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARNDY2.
      REAL FUNCTION ARNDY2()

C...Ariadne function RaNDom Y version 2

C...Generates a properly distributed Y
C...Suitable for gluon emission from extended dipole

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      AE1=1.0
      AE3=1.0
      ARNDY2=ARNDY1()
      B1=BC1-XT*EXP(ARNDY2)
      B3=BC3-XT*EXP(-ARNDY2)
      B2=2.0-B1-B3
      PTTRU1=XT*W
      PTTRU3=PTTRU1
      IF (MSTA(25).EQ.2) THEN
        IF ((1.0-B1+Y1-(SY2+SY3)**2)*(1.0-B3+Y3-(SY1+SY2)**2).GE.
     $       0.25*(1.0-B2+Y2-(SY1+SY3)**2)) THEN
          PTTRU1=0.5*W
          PTTRU3=PTTRU1
        ELSE
          PTTRU1=W*SQRT((1.0-B1+Y1-(SY2+SY3)**2)*
     $         (1.0-B3+Y3-(SY1+SY2)**2)/(1.0-B2+Y2-(SY1+SY3)**2))
          PTTRU3=PTTRU1
        ENDIF
      ENDIF
      IF (MSTA(25).EQ.4.OR.MSTA(25).EQ.5) THEN
        BZ12=B1**2-4.0*Y1
        BZ22=B2**2-4.0*Y2
        BZ32=B3**2-4.0*Y3
        BCOS=2.0*BZ12*BZ22+2.0*BZ12*BZ32+2.0*BZ22*BZ32
     $       -BZ12**2-BZ22**2-BZ32**2
        IF (BCOS.LE.0.0) THEN
          QFAIL=.TRUE.
          RETURN
        ENDIF
        IF (MSTA(25).EQ.4) THEN
          PTTRU1=0.25*W*SQRT(BCOS/BZ32)
          PTTRU3=0.25*W*SQRT(BCOS/BZ12)
        ELSE
          PTTRU1=0.25*W*SQRT(BCOS/BZ12)
          PTTRU3=0.25*W*SQRT(BCOS/BZ32)
        ENDIF
      ENDIF

      IF (ALP1.GE.0.0) THEN
        ALPHA1=ALP1
        THEMU1=XMU1
      ELSEIF (PTTRU1.GT.ABS(ALP1)) THEN
        ALPHA1=2.0
        THEMU1=SQRT(ABS(XMU1*ALP1))
      ELSE
        ALPHA1=1.0
        THEMU1=XMU1
      ENDIF
      IF (ALP3.GE.0.0) THEN
        ALPHA3=ALP3
        THEMU3=XMU3
      ELSEIF (PTTRU3.GT.ABS(ALP3)) THEN
        ALPHA3=2.0
        THEMU3=SQRT(ABS(XMU3*ALP3))
      ELSE
        ALPHA3=1.0
        THEMU3=XMU3
      ENDIF

      IF (QEXDY.AND.MHAR(131).EQ.2) THEN
       IF (QE1) THEN
          BGPMAX=((THEMU1/SQRT(BPDY*BMDY))**ALPHA1)*BZP*W
          IF (BGPMAX.LT.BPDY)
     $         ALPHA1=LOG(BPDY/(BZP*W))/LOG(THEMU1/SQRT(BPDY*BMDY))
        ENDIF
        IF (QE3) THEN
          BGMMAX=((THEMU3/SQRT(BPDY*BMDY))**ALPHA3)*BZM*W
          IF (BGMMAX.LT.BMDY)
     $         ALPHA3=LOG(BMDY/(BZM*W))/LOG(THEMU3/SQRT(BPDY*BMDY))
        ENDIF
      ENDIF

      IF (MSTA(25).GT.0) THEN
        IF (QE1) AE1=((THEMU1/PTTRU1)**ALPHA1)*
     $       (1.0/RLU(IDUM)-1.0)**PARA(25)
        IF (QE3) AE3=((THEMU3/PTTRU3)**ALPHA3)*
     $       (1.0/RLU(IDUM)-1.0)**PARA(25)
        IF (MSTA(25).EQ.3.AND.PTTRU1.LE.THEMU1) AE1=1.0
        IF (MSTA(25).EQ.3.AND.PTTRU3.LE.THEMU3) AE3=1.0
        BP1=(1.0-AE1)*(BZP-SY1)+SY1
        BM3=(1.0-AE3)*(BZM-SY3)+SY3
      ELSE
        IF (QE1) AE1=(THEMU1/PTTRU1)**ALPHA1
        IF (QE3) AE3=(THEMU3/PTTRU3)**ALPHA3
        BP1=(1.0-AE1)*BZP
        BM3=(1.0-AE3)*BZM
      ENDIF

      IF (BP1.LE.SY1) THEN
        BP1=0.0
        BM1=0.0
      ELSE
        BM1=Y1/BP1
      ENDIF
      IF (BM3.LE.SY3) THEN
        BM3=0.0
        BP3=0.0
      ELSE
        BP3=Y3/BM3
      ENDIF

      ZMAX=SQRT(XTS/XT2)+SQRT(MAX(XTS/XT2-1.0,0.0))
      ZMIN=MIN(ZMAX,XT1/XT)
      ZMAX=MIN(ZMAX,XT3/XT)

      AZ1=1.0-BP1-BP3
      AZ3=1.0-BM1-BM3
      A=0.5/XT
      IF (AZ1*AZ3.GT.0.0) A=(0.5+SQRT(MAX(0.25-XT2/(AZ1*AZ3),0.0)))/XT

      ZMAX=MIN(ZMAX,ABS(AZ1)*A)
      ZMIN=MIN(ZMIN,ABS(AZ3)*A)

      IF (ZMAX.LE.0.0.OR.ZMIN.LE.0.0) THEN
        QFAIL=.TRUE.
      ELSEIF (ARNDY2.GT.LOG(ZMAX).OR.ARNDY2.LT.-LOG(ZMIN)) THEN
        QFAIL=.TRUE.
      ENDIF

      IF (MHAR(131).NE.0.AND.QEXDY.AND.(.NOT.QFAIL)) THEN
        SIG=(B1**NXP1+B3**NXP3)/(S*XT2)
        BGP=W*XT*EXP(ARNDY2)
        BGM=W*XT*EXP(-ARNDY2)
        TH=-BGP*BMDY-XT2*S
        UH=-BGM*BPDY-XT2*S
        SH=BGP*BMDY+BGM*BPDY+2.0*XT2*S+BPDY*BMDY
        SIGW=((SH+UH)**2+(SH+TH)**2)/(SH*UH*TH)
        IF (SIGW/SIG.LT.RLU(0)) THEN
          QFAIL=.TRUE.
          RETURN
        ENDIF
        IF (MHAR(131).EQ.3) THEN
          XMW=SQRT(BPDY*BMDY)
          XMTW=SQRT(BPDY*BMDY+XT2*S)
          EYW=SQRT(BPDY/BMDY)
          IF ((QE1.AND.BGP+(XMTW-XMW)*EYW.GT.AE1*W*BZP).OR.
     $         (QE3.AND.BGM+(XMTW-XMW)/EYW.GT.AE3*W*BZM)) THEN
            QFAIL=.TRUE.
            RETURN
          ENDIF
        ENDIF
      ENDIF

      IF ((.NOT.QFAIL).OR.(.NOT.QEXDY).OR.MHAR(123).EQ.0) RETURN

      BGP=W*XT*EXP(ARNDY2)
      BGM=W*XT*EXP(-ARNDY2)
      
      IF (ABS(MSTA(22)).LT.3.AND.(BGP.GT.BPDY.OR.BGM.GT.BMDY)) RETURN
      IF (ABS(MSTA(22)).EQ.3.AND.BGP.GT.BPDY.AND.BGM.GT.BMDY) RETURN
      IF (MHAR(123).EQ.-1.OR.MHAR(123).GE.3) THEN
        BGPMAX=BZP*W
        IF (QE1) BGPMAX=((THEMU1/(W*XT))**ALPHA1)*BZP*W
        BGMMAX=BZM*W
        IF (QE3) BGMMAX=((THEMU3/(W*XT))**ALPHA3)*BZM*W
        R1=0.0
        IF (BGP.GT.BGPMAX.AND.MHAR(123).LT.4)
     $       R1=LOG(BGP/BGPMAX)/LOG(BPDY/BGPMAX)
        IF (MHAR(123).EQ.4) R1=1.0-EXP((BGPMAX-BGP)/BGPMAX)
        R3=0.0
        IF (BGM.GT.BGMMAX.AND.MHAR(123).LT.4)
     $       R3=LOG(BGM/BGMMAX)/LOG(BMDY/BGMMAX)
        IF (MHAR(123).EQ.4) R3=1.0-EXP((BGMMAX-BGM)/BGMMAX)
        IF (RLU(0).LT.R1.OR.RLU(0).LT.R3) RETURN
      ENDIF

      QFAIL=.FALSE.
      AE1=1.0
      AE3=1.0
      BP1=0.0
      BP3=0.0
      BM1=0.0
      BM3=0.0

      RETURN

C**** END OF ARNDY2 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARNDY3.
      REAL FUNCTION ARNDY3()

C...Ariadne function RaNDom Y version 3

C...Generates a properly distributed Y
C...Suitable for q-qbar emission

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ZMAX=SQRT(XTS/XT2)+SQRT(MAX(XTS/XT2-1.0,0.0))
      ZMIN=MIN(ZMAX,XT1/XT)
      ZMAX=MIN(ZMAX,XT3/XT)

      YMAX=LOG(ZMAX)
      YMIN=-LOG(ZMIN)

      ARNDY3=-LOG(1.0/ZMAX+RLU(IDUM)*(ZMIN-1.0/ZMAX))

      RETURN

C**** END OF ARNDY3 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARNDY4.
      REAL FUNCTION ARNDY4()

C...Ariadne function RaNDom Y version 4

C...Generates a properly distributed Y
C...Suitable for q-qbar emission from extended dipole

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/


      AE1=1.0
      AE3=1.0
      PTTRU1=XT*W
      PTTRU3=PTTRU1
      ARNDY4=ARNDY3()
      B1=BC1-XT*EXP(ARNDY4)
      B3=BC3-XT*EXP(-ARNDY4)
      B2=2.0-B1-B3
      IF (MSTA(25).EQ.2) THEN
        IF ((1.0-B1+Y1-(SY2+SY3)**2)*(1.0-B3+Y3-(SY1+SY2)**2).GE.
     $       0.25*(1.0-B2+Y2-(SY1+SY3)**2)) THEN
          PTTRU1=0.5*W
          PTTRU3=PTTRU1
        ELSE
          PTTRU1=W*SQRT((1.0-B1+Y1-(SY2+SY3)**2)*
     $         (1.0-B3+Y3-(SY1+SY2)**2)/(1.0-B2+Y2-(SY1+SY3)**2))
          PTTRU3=PTTRU1
        ENDIF
      ENDIF
      IF (MSTA(25).EQ.4.OR.MSTA(25).EQ.5) THEN
        BZ12=B1**2-4.0*Y1
        BZ22=B2**2-4.0*Y2
        BZ32=B3**2-4.0*Y3
        BCOS=2.0*BZ12*BZ22+2.0*BZ12*BZ32+2.0*BZ22*BZ32
     $       -BZ12**2-BZ22**2-BZ32**2
        IF (BCOS.LE.0.0) THEN
          QFAIL=.TRUE.
          RETURN
        ENDIF
        IF (MSTA(25).EQ.4) THEN
          PTTRU1=0.25*W*SQRT(BCOS/BZ32)
          PTTRU3=0.25*W*SQRT(BCOS/BZ12)
        ELSE
          PTTRU1=0.25*W*SQRT(BCOS/BZ12)
          PTTRU3=0.25*W*SQRT(BCOS/BZ32)
        ENDIF
      ENDIF

      IF (ALP1.GE.0.0) THEN
        ALPHA1=ALP1
        THEMU1=XMU1
      ELSEIF (PTTRU1.GT.ABS(ALP1)) THEN
        ALPHA1=2.0
        THEMU1=SQRT(ABS(XMU1*ALP1))
      ELSE
        ALPHA1=1.0
        THEMU1=XMU1
      ENDIF
      IF (ALP3.GE.0.0) THEN
        ALPHA3=ALP3
        THEMU3=XMU3
      ELSEIF (PTTRU3.GT.ABS(ALP3)) THEN
        ALPHA3=2.0
        THEMU3=SQRT(ABS(XMU3*ALP3))
      ELSE
        ALPHA3=1.0
        THEMU3=XMU3
      ENDIF

      IF (MSTA(25).GT.0) THEN
        IF (QE1) AE1=((THEMU1/PTTRU1)**ALPHA1)*
     $       (1.0/RLU(IDUM)-1.0)**PARA(25)
        IF (QE3) AE3=((THEMU3/PTTRU3)**ALPHA3)*
     $       (1.0/RLU(IDUM)-1.0)**PARA(25)
        IF (MSTA(25).EQ.3.AND.PTTRU1.LE.THEMU1) AE1=1.0
        IF (MSTA(25).EQ.3.AND.PTTRU3.LE.THEMU3) AE3=1.0
      ELSE
        IF (QE1) AE1=(THEMU1/PTTRU1)**ALPHA1
        IF (QE3) AE3=(THEMU3/PTTRU3)**ALPHA3
      ENDIF

      BP1=(1.0-AE1)*(BZP-SY1)+SY1
      IF (BP1.LE.SY1) THEN
        BP1=0.0
        BM1=0.0
      ELSE
        BM1=Y1/BP1
      ENDIF
      BM3=(1.0-AE3)*(BZM-SY3)+SY3
      IF (BM3.LE.SY3) THEN
        BM3=0.0
        BP3=0.0
      ELSE
        BP3=Y3/BM3
      ENDIF

      ZMAX=SQRT(XTS/XT2)+SQRT(MAX(XTS/XT2-1.0,0.0))
      ZMIN=MIN(ZMAX,XT1/XT)
      ZMAX=MIN(ZMAX,XT3/XT)

      AZ1=1.0-BP1-BP3
      AZ3=1.0-BM1-BM3
      A=0.5/XT
      IF (AZ1*AZ3.GT.0.0) A=(0.5+SQRT(MAX(0.25-XT2/(AZ1*AZ3),0.0)))/XT

      ZMAX=MIN(ZMAX,ABS(AZ1)*A)
      ZMIN=MIN(ZMIN,ABS(AZ3)*A)

      IF (ZMAX.LE.0.0.OR.ZMIN.LE.0.0) THEN
        QFAIL=.TRUE.
      ELSEIF (ARNDY4.GT.LOG(ZMAX).OR.ARNDY4.LT.-LOG(ZMIN)) THEN
        QFAIL=.TRUE.
      ENDIF

      RETURN

C**** END OF ARNDY4 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARNDY5.
      REAL FUNCTION ARNDY5()

C...Ariadne function RaNDom Y version 5

C...Generates a properly distributed Y
C...Suitable for q-qbar emission

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ZMAX=SQRT(XTS/XT2)+SQRT(MAX(XTS/XT2-1.0,0.0))
      ZMIN=MIN(ZMAX,XT1/XT)
      ZMAX=MIN(ZMAX,XT3/XT)

      YMAX=LOG(ZMAX)
      YMIN=-LOG(ZMIN)

      ARNDY5=YMIN+RLU(IDUM)*(YMAX-YMIN)

      RETURN

C**** END OF ARNDY5 ****************************************************
      END
C***********************************************************************
C $Id: arrobo.f,v 3.3 1994/05/11 07:10:51 lonnblad Exp $
CDECK  ID>, AROBO1.
      SUBROUTINE AROBO1(THE,PHI,DBEX,DBEY,DBEZ,I1)

C...Ariadne subroutine ROtate BOost 1 parton

C...Rotates and boosts 1 parton in /ARPART/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      DIMENSION I(1)


      I(1)=I1
      CALL ARROBO(THE,PHI,DBEX,DBEY,DBEZ,1,I)

      RETURN

C**** END OF AROBO1 ****************************************************
      END
C***********************************************************************
C $Id: arrobo.f,v 3.3 1994/05/11 07:10:51 lonnblad Exp $
CDECK  ID>, AROBO2.
      SUBROUTINE AROBO2(THE,PHI,DBEX,DBEY,DBEZ,I1,I2)

C...Ariadne subroutine ROtate BOost 2 partons

C...Rotates and boosts 2 partons in /ARPART/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      DIMENSION I(2)


      I(1)=I1
      I(2)=I2
      CALL ARROBO(THE,PHI,DBEX,DBEY,DBEZ,2,I)

      RETURN

C**** END OF AROBO2 ****************************************************
      END
C***********************************************************************
C $Id: arrobo.f,v 3.3 1994/05/11 07:10:51 lonnblad Exp $
CDECK  ID>, AROBO3.
      SUBROUTINE AROBO3(THE,PHI,DBEX,DBEY,DBEZ,I1,I2,I3)

C...Ariadne subroutine ROtate BOost 3 partons

C...Rotates and boosts 3 partons in /ARPART/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      DIMENSION I(3)


      I(1)=I1
      I(2)=I2
      I(3)=I3
      CALL ARROBO(THE,PHI,DBEX,DBEY,DBEZ,3,I)

      RETURN

C**** END OF AROBO3 ****************************************************
      END
C***********************************************************************
C $Id: arrobo.f,v 3.3 1994/05/11 07:10:51 lonnblad Exp $
CDECK  ID>, AROBO4.
      SUBROUTINE AROBO4(THE,PHI,DBEX,DBEY,DBEZ,I1,I2,I3,I4)

C...Ariadne subroutine ROtate BOost 4 partons

C...Rotates and boosts 4 partons in /ARPART/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      DIMENSION I(4)


      I(1)=I1
      I(2)=I2
      I(3)=I3
      I(4)=I4
      CALL ARROBO(THE,PHI,DBEX,DBEY,DBEZ,4,I)

      RETURN

C**** END OF AROBO4 ****************************************************
      END
C***********************************************************************
C $Id: arrobo.f,v 3.3 1994/05/11 07:10:51 lonnblad Exp $
CDECK  ID>, AROBO5.
      SUBROUTINE AROBO5(THE,PHI,DBEX,DBEY,DBEZ,I1,I2,I3,I4,I5)

C...Ariadne subroutine ROtate BOost 5 partons

C...Rotates and boosts 5 partons in /ARPART/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      DIMENSION I(5)


      I(1)=I1
      I(2)=I2
      I(3)=I3
      I(4)=I4
      I(5)=I5
      CALL ARROBO(THE,PHI,DBEX,DBEY,DBEZ,5,I)

      RETURN

C**** END OF AROBO5 ****************************************************
      END
C***********************************************************************
C $Id: arrobo.f,v 3.3 1994/05/11 07:10:51 lonnblad Exp $
CDECK  ID>, ARROBO.
      SUBROUTINE ARROBO(THE,PHI,DBEX,DBEY,DBEZ,NI,I)

C...ARiadne subroutine ROtate and BOost

C...Rotates and boost NI particles in /ARPART/

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      DIMENSION I(NI)


      CALL ARDBRB(DBLE(THE),DBLE(PHI),DBEX,DBEY,DBEZ,NI,I)

      RETURN

C**** END OF ARROBO ****************************************************
      END
C***********************************************************************
C $Id: arrobo.f,v 3.3 1994/05/11 07:10:51 lonnblad Exp $
CDECK  ID>, ARDBRB.
      SUBROUTINE ARDBRB(DTHE,DPHI,DBEX,DBEY,DBEZ,NI,I)

C...ARiadne subroutine DouBle precision ROtate and BOost

C...Rotates and boost NI particles in /ARPART/ using double precision
C...angles.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/

      DIMENSION I(NI),BR(3,3),BV(3),DP(4)


      IF (DTHE**2+DPHI**2.GT.1.0D-20) THEN

C...Rotate (typically from z axis to direction theta,phi)

        DSP=SIN(DPHI)
        DCP=COS(DPHI)
        DST=SIN(DTHE)
        DCT=COS(DTHE)

        BR(1,1)=DCT*DCP
        BR(1,2)=-DSP
        BR(1,3)=DST*DCP
        BR(2,1)=DCT*DSP
        BR(2,2)=DCP
        BR(2,3)=DST*DSP
        BR(3,1)=-DST
        BR(3,2)=0.0
        BR(3,3)=DCT

        DO 100 IJ=1,NI
          DO 110 J=1,3
            BV(J)=BP(I(IJ),J)
 110      CONTINUE
          DO 120 J=1,3
            BP(I(IJ),J)=BR(J,1)*BV(1)+BR(J,2)*BV(2)+BR(J,3)*BV(3)
 120      CONTINUE
 100    CONTINUE

      ENDIF

      DBTOT2=DBEX**2+DBEY**2+DBEZ**2
      IF (DBTOT2.GT.1.0D-20) THEN
        IF (DBTOT2.GE.1.0D0) CALL ARERRM('ARROBO',14,0)
        DGA=1.0D0/DSQRT(1.0D0-DBTOT2)

        DO 200 IJ=1,NI
          DO 210 J=1,4
            DP(J)=BP(I(IJ),J)
 210      CONTINUE
          DBEP=DBEX*DP(1)+DBEY*DP(2)+DBEZ*DP(3)
          DGABEP=DGA*(DGA*DBEP/(1.0D0+DGA)+DP(4))

          BP(I(IJ),1)=DP(1)+DGABEP*DBEX
          BP(I(IJ),2)=DP(2)+DGABEP*DBEY
          BP(I(IJ),3)=DP(3)+DGABEP*DBEZ
          BP(I(IJ),4)=DGA*(DP(4)+DBEP)

 200    CONTINUE

      ENDIF

      RETURN

C**** END OF ARDBRB ****************************************************
      END
C***********************************************************************
C $Id: arsplg.f,v 3.6 1994/05/11 07:10:52 lonnblad Exp $
CDECK  ID>, ARSPLG.
      SUBROUTINE ARSPLG(IG,IFLAV)

C...ARiadne subroutine SPLit Gluon

C...Splits a gluon entry into a q and a q-bar entry

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT2/ PQMAS(10)
      SAVE /ARDAT2/

      INXT(I)=IDO(IP3(I))


C...Allocate space for new parton and new string if there is room
      IPART=IPART+1
      ISTRS=ISTRS+1

      IF (IPART.GE.MAXPAR-10) CALL ARERRM('ARSPLG',6,0)
      IF (ISTRS.GT.MAXSTR) CALL ARERRM('ARSPLG',8,0)

C...Set new pointers
      IDP=IDI(IG)
      IDN=IDO(IG)
      IDO(IG)=0
      IDI(IPART)=0
      IDO(IPART)=IDN

      IP1(IDN)=IPART

      IS=ISTR(IDP)

C...If closed gluonic string, no new string is created. The colour flow
C...which was previously undefined is set randomly
      IF (IFLOW(IS).EQ.2) THEN
        ISTRS=ISTRS-1
        IFLOW(IS)=1
        IPF(IS)=IPART
        IPL(IS)=IG
        IF (RLU(IDUM).GT.0.5) IFLOW(IS)=-1
        IFL(IPART)=IFLAV*IFLOW(IS)
        IFL(IG)=-IFL(IPART)

C...If new string is created set pointers for its partons
      ELSE
        IFLOW(ISTRS)=IFLOW(IS)
        IPF(ISTRS)=IPART
        IPL(ISTRS)=IPL(IS)
        IPL(IS)=IG
        IFL(IPART)=IFLAV*IFLOW(IS)
        IFL(IG)=-IFL(IPART)
        IDNI=IDN
 100    ISTR(IDNI)=ISTRS
        IF (.NOT.QQ(IP3(IDNI))) THEN
          IDNI=INXT(IDNI)
          GOTO 100
        ENDIF
      ENDIF

C...Reset momenta for created quarks and flag affected dipoles
      DO 200 I=1,4
        BP(IG,I)=0.0
        BP(IPART,I)=0.0
 200  CONTINUE
      BP(IG,5)=PQMAS(IFLAV)
      BP(IPART,5)=PQMAS(IFLAV)
      QEX(IG)=.FALSE.
      QEX(IPART)=.FALSE.
      XPMU(IG)=0.0
      XPMU(IPART)=0.0
      XPA(IG)=0.0
      XPA(IPART)=0.0
      QQ(IG)=.TRUE.
      QQ(IPART)=.TRUE.
      QDONE(IDP)=.FALSE.
      QDONE(IDN)=.FALSE.
      INO(IG)=SIGN(1000*ABS(INO(IG))+IO,INO(IG))
      INO(IPART)=INO(IG)
      INQ(IPART)=IG
      INQ(IG)=IPART

      RETURN

C**** END OF ARSPLG ****************************************************
      END
C***********************************************************************
C $Id: arstor.f,v 3.6 1995/06/09 15:46:45 lonnblad Exp $
CDECK  ID>, ARSTOR.
      SUBROUTINE ARSTOR(ID,IDS,IS1,IS3)

C...ARiadne subroutine STORe 

C...Stores a dipole entry for later use

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/


      IDS=MAXDIP
      SDIP(IDS)=SDIP(ID)
      IP1(IDS)=IP1(ID)
      IP3(IDS)=IP3(ID)
      BX1(IDS)=BX1(ID)
      BX3(IDS)=BX3(ID)
      PT2IN(IDS)=PT2IN(ID)
      AEX1(IDS)=AEX1(ID)
      AEX3(IDS)=AEX3(ID)
      QDONE(IDS)=QDONE(ID)
      QEM(IDS)=QEM(ID)
      IRAD(IDS)=IRAD(ID)
      ISTR(IDS)=ISTR(ID)
      ICOLI(IDS)=ICOLI(ID)

      I1=IP1(ID)
      I3=IP3(ID)
      IS1=MAXPAR-1
      IS3=MAXPAR
      DO 100 I=1,5
        BP(IS1,I)=BP(I1,I)
        BP(IS3,I)=BP(I3,I)
 100  CONTINUE
      IFL(IS1)=IFL(I1)
      IFL(IS3)=IFL(I3)
      QEX(IS1)=QEX(I1)
      QEX(IS3)=QEX(I3)
      XPA(IS1)=XPA(I1)
      XPA(IS3)=XPA(I3)
      XPMU(IS1)=XPMU(I1)
      XPMU(IS3)=XPMU(I3)
      PT2GG(IS1)=PT2GG(I1)
      PT2GG(IS3)=PT2GG(I3)
      QQ(IS1)=QQ(I1)
      QQ(IS3)=QQ(I3)
      IDI(IS1)=IDI(I1)
      IDI(IS3)=IDI(I3)
      IDO(IS1)=IDO(I1)
      IDO(IS3)=IDO(I3)
      INO(IS1)=INO(I1)
      INO(IS3)=INO(I3)

      RETURN

C**** END OF ARSTOR ****************************************************
      END
C***********************************************************************
C $Id: arstor.f,v 3.6 1995/06/09 15:46:45 lonnblad Exp $
CDECK  ID>, ARCODI.
      SUBROUTINE ARCODI(ID,IDS,IS1,IS3)

C...ARiadne subroutine COpy DIpole

C...Makes a full copy of a dipole with its two partons

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/


      IDIPS=IDIPS+1
      IDS=IDIPS
      I1=IP1(ID)
      I3=IP3(ID)
      IPART=IPART+2
      IS1=IPART-1
      IS3=IPART

      SDIP(IDS)=SDIP(ID)
      IP1(IDS)=IS1
      IP3(IDS)=IS3
      BX1(IDS)=BX1(ID)
      BX3(IDS)=BX3(ID)
      PT2IN(IDS)=PT2IN(ID)
      AEX1(IDS)=AEX1(ID)
      AEX3(IDS)=AEX3(ID)
      QDONE(IDS)=QDONE(ID)
      QEM(IDS)=QEM(ID)
      IRAD(IDS)=IRAD(ID)
      ISTR(IDS)=ISTR(ID)
      ICOLI(IDS)=ICOLI(ID)

      DO 100 I=1,5
        BP(IS1,I)=BP(I1,I)
        BP(IS3,I)=BP(I3,I)
 100  CONTINUE
      IFL(IS1)=IFL(I1)
      IFL(IS3)=IFL(I3)
      QEX(IS1)=QEX(I1)
      QEX(IS3)=QEX(I3)
      XPA(IS1)=XPA(I1)
      XPA(IS3)=XPA(I3)
      XPMU(IS1)=XPMU(I1)
      XPMU(IS3)=XPMU(I3)
      PT2GG(IS1)=PT2GG(I1)
      PT2GG(IS3)=PT2GG(I3)
      QQ(IS1)=QQ(I1)
      QQ(IS3)=QQ(I3)
      IDI(IS1)=IDI(I1)
      IDI(IS3)=IDS
      IDO(IS1)=IDS
      IDO(IS3)=IDO(I3)
      INO(IS1)=INO(I1)
      INO(IS3)=INO(I3)
      INQ(IS1)=INQ(I1)
      INQ(IS3)=INQ(I3)

      RETURN

C**** END OF ARCODI ****************************************************
      END
C***********************************************************************
C $Id: artest.f,v 3.4 1995/08/15 09:08:57 lonnblad Exp $
CDECK  ID>, ARTEST.
      SUBROUTINE ARTEST(IPRINT)

C...ARiadne subroutine TEST

C...Performs various tests on Ariadne

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARDAT3/ IWRN(40)
      SAVE /ARDAT3/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/

      MSTA(9)=1
      MSTA(6)=-1
      MSTA(20)=1

      MSTJ(21)=0

      CALL ARINIT('ARIADNE')

      DO 110 I=1,10000

        PARA(1)=0.1+0.5*RLU(IDUM)
        PARA(2)=0.05+0.25*RLU(IDUM)
        PARA(3)=PARA(1)+0.1+RLU(IDUM)
        PARA(5)=0.1+RLU(IDUM)
        PARA(10)=0.5+RLU(IDUM)
        PARA(11)=0.5+RLU(IDUM)
        PARA(12)=5.0+10.0*RLU(IDUM)
        PARA(25)=2.0*RLU(IDUM)

        MSTA(11)=INT(5.0*RLU(IDUM))
        MSTA(12)=INT(2.0*RLU(IDUM))
        MSTA(16)=INT(3.0*RLU(IDUM))
        MSTA(17)=INT(4.0*RLU(IDUM))
        MSTA(18)=INT(4.0*RLU(IDUM))
        MSTA(19)=INT(2.0*RLU(IDUM))
        MSTA(25)=INT(3.0*RLU(IDUM))
        MSTA(31)=INT(2.0*RLU(IDUM))

        W=10.0*EXP(RLU(IDUM)*LOG(1000.0))
 100    SM1=RLU(IDUM)*20.0
        SM2=RLU(IDUM)*20.0
        E1=0.5*(W**2+SM1**2-SM2**2)/W
        E2=W-E1
        IF (E1.LT.SM1) GOTO 100
        IF (E2.LT.SM2) GOTO 100
        NE1=INT(RLU(IDUM)*4.0)
        NE2=INT(RLU(IDUM)*4.0)
        N=2
        P(1,1)=0.0
        P(1,2)=0.0
        P(1,3)=-SQRT(E1**2-SM1**2)
        P(1,4)=E1
        P(1,5)=SM1
        K(1,1)=2
        K(1,2)=1
        K(1,3)=999
        K(1,4)=NE1
        K(1,5)=0
        P(2,1)=0.0
        P(2,2)=0.0
        P(2,3)=SQRT(E2**2-SM2**2)
        P(2,4)=E2
        P(2,5)=SM2
        K(2,1)=1
        K(2,2)=-1
        K(2,3)=999
        K(2,4)=NE2
        K(2,5)=0

        CALL AREXEC
        IF (RLU(IDUM).GT.0.99) CALL LUEXEC

        IF (IPRINT.GT.0.AND.MOD(I,100).EQ.0) CALL LULIST(2)

 110  CONTINUE

      NERRA=0
      DO 200 I=1,40
        NERRA=NERRA+IWRN(I)
 200  CONTINUE

      NWRNA=IWRN(13)+IWRN(10)
      NERRA=NERRA-NWRNA
      IF (NERRA.EQ.0) THEN
        WRITE(MSTA(7),1000)
      ELSE
        WRITE(MSTA(7),1010) NERRA
      ENDIF

      IF (NWRNA.GT.0) WRITE(MSTA(7),1020) NWRNA

      NWRNJ=MSTU(27)
      NERRJ=MSTU(23)

      IF (NWRNJ+NERRJ.NE.0) WRITE(MSTA(7),1030) NWRNJ,NERRJ

 1000 FORMAT('No errors experienced by Ariadne.')
 1010 FORMAT(I5,' errors occurred in Ariadne.')
 1020 FORMAT(I5,' Non-serious warnings issued by Ariadne')
 1030 FORMAT(I5,' warnings and',I5,' errors occured in JETSET when ',
     $     'attempting to fragment',/
     $     ,' parton state produced by Ariadne.')

      RETURN

C**** END OF ARTEST ****************************************************
      END
C***********************************************************************
C $Id: arveto.f,v 3.13 1994/09/20 12:38:42 lonnblad Exp $
CDECK  ID>, ARVET1.
      REAL FUNCTION ARVET1()

C...ARiadne function VETo factor version 1

C...Determine the acceptance factor for chosen x_t^2 and y
C...Suitable for photon emission with constant alpha_EM

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARVET1=0.0
      IF (B2.LE.0) RETURN
      ARVET1=-((FQ1*(1.0-B1)/B2-FQ3*(1.0-B3)/B2)**2)*
     $         (B1**NXP1+B3**NXP3)*(YMAX-YMIN)*0.5/LOG(XT2)

      IF (MSTA(19).EQ.0) RETURN

      ARVET1=ARVET1*ARVETH()

      RETURN

C**** END OF ARVET1 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARVET2.
      REAL FUNCTION ARVET2()

C...ARiadne function VETo factor version 2

C...Determine the acceptance factor for chosen x_t^2 and y
C...Suitable for photon emission with running alpha_EM

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARVET2=ARVET1()*ULALEM(XT2*S)/ULALEM(0.25*S)

      RETURN

C**** END OF ARVET2 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARVET3.
      REAL FUNCTION ARVET3()

C...ARiadne function VETo factor version 3

C...Determine the acceptance factor for chosen x_t^2 and y
C...Suitable for gluon emission with constant alpha_QCD

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARVET3=-(B1**NXP1+B3**NXP3)*(YMAX-YMIN)*0.5/LOG(XT2)

      IF (MSTA(19).EQ.0) RETURN

      ARVET3=ARVET3*ARVETH()


      RETURN

C**** END OF ARVET3 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARVET4.
      REAL FUNCTION ARVET4()

C...ARiadne function VETo factor version 4

C...Determine the acceptance factor for chosen x_t^2 and y
C...Suitable for gluon emission with running alpha_QCD

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARVET4=(B1**NXP1+B3**NXP3)*(YMAX-YMIN)*0.5/YINT

      IF (MSTA(19).EQ.0) RETURN

      ARVET4=ARVET4*ARVETH()


      RETURN

C**** END OF ARVET4 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARVET5.
      REAL FUNCTION ARVET5()

C...ARiadne function VETo factor version 5

C...Determine the acceptance factor for chosen x_t^2 and y
C...Suitable for q-qbar emission

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARVET5=((1.0D0-B3+Y3)**2+(1.0D0-B2+Y2)**2)*XT*
     $         (EXP(-YMIN)-EXP(-YMAX))/YINT

      IF (MSTA(23).EQ.1) ARVET5=ARVET5*(BC1-B1)/(1.0D0-B1+Y1)

      RETURN

C**** END OF ARVET5 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARVERT6.
      REAL FUNCTION ARVET6()

C...ARiadne function VETo factor version 6

C...Determine the acceptance factor for chosen x_t^2 and y
C...Suitable for gluon emission with running alpha_QCD according to
C...O(alpha_S) gluon emission for lepto production

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON /ARINT4/ BASS(5),BASSX1,BASSX3,IFLASS
      SAVE /ARINT4/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/


      BCNST0=0.0
      Y3P=ZSQEV*Y3
      Y2P=ZSQEV*Y2
      Y1P=ZSQEV*Y1
      B3P=1.0-ZSQEV*(1.0-B3)
      B1P=B1-(Y1P-Y3P)*(1.0-ZSQEV)/ZSQEV
      B2P=2.0-B1P-B3P
      BASSX1=B1P
      BASSX3=B3P

      B13=MAX(1.0-B3P+Y3P,BCNST0)
      B12=MAX(1.0-B2P+Y2P,BCNST0)
      B11=MAX(1.0-B1P+Y1P,BCNST0)
      B13Q=B13+SQ2
      CG1=((B12/B3P)**2+(SQ2/B13Q)**2)*SQ2/B13Q
      CG2=2.0*(B12*SQ2/(B13Q*B3P)+1.0)*B13*B11*SQ2/(B3P*B13Q**2)
      CG3=4.0*YFAC*B11*B12*B13*(SQ2**2)/((B3P**2)*B13Q**3)
      CG0=(3.0+4.0*YFAC/27.0)
      IF (MHAR(116).LE.0) THEN
        CG1=(B12/B3P)**2+(SQ2/B13Q)**2
        CG2=2.0*(B12*SQ2/(B13Q*B3P)+1.0)*B13*B11/(B3P*B13Q)
        CG3=4.0*YFAC*B11*B12*B13*SQ2/((B3P**2)*B13Q**2)
        CG0=(6.0+0.25*YFAC)
        IF (MHAR(116).LT.0) CG0=CG0*SQRT(B13Q/SQ2)
      ENDIF

      ARVET6=(YMAX-YMIN)*(CG1+CG2+CG3)/(YINT*CG0)

      IF (MSTA(19).EQ.0) RETURN

      IF (MSTA(19).EQ.2) ARVET6=ARVET6*
     $     MIN(1.0,LOG(XT2/XLAM2)/LOG(PARA(21)*SQ2/XLAM2))

      ARVET6=ARVET6*ARVETH()


      RETURN

C**** END OF ARVET6 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARVET7.
      REAL FUNCTION ARVET7()

C...ARiadne function VETo factor version 7

C...Determine the acceptance factor for chosen x_t^2 and y
C...Suitable for gluon emission with constant alpha_QCD according to
C...O(alpha_S) gluon emission for lepto production


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON /ARINT4/ BASS(5),BASSX1,BASSX3,IFLASS
      SAVE /ARINT4/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/

      BCNST0=0.0
      Y3P=ZSQEV*Y3
      Y2P=ZSQEV*Y2
      Y1P=ZSQEV*Y1
      B3P=1.0-ZSQEV*(1.0-B3)
      B1P=B1-(Y1P-Y3P)*(1.0-ZSQEV)/ZSQEV
      B2P=2.0-B1P-B3P
      BASSX1=B1P
      BASSX3=B3P

      B13=MAX(1.0-B3P+Y3P,BCNST0)
      B12=MAX(1.0-B2P+Y2P,BCNST0)
      B11=MAX(1.0-B1P+Y1P,BCNST0)
      B13Q=B13+SQ2
      CG1=((B12/B3P)**2+(SQ2/B13Q)**2)*SQ2/B13Q
      CG2=2.0*(B12*SQ2/(B13Q*B3P)+1.0)*B13*B11*SQ2/(B3P*B13Q**2)
      CG3=4.0*YFAC*B11*B12*B13*(SQ2**2)/((B3P**2)*B13Q**3)
      CG0=(3.0+4.0*YFAC/27.0)
      IF (MHAR(116).LE.0) THEN
        CG1=(B12/B3P)**2+(SQ2/B13Q)**2
        CG2=2.0*(B12*SQ2/(B13Q*B3P)+1.0)*B13*B11/(B3P*B13Q)
        CG3=4.0*YFAC*B11*B12*B13*SQ2/((B3P**2)*B13Q**2)
        CG0=(6.0+0.25*YFAC)
        IF (MHAR(116).LT.0) CG0=CG0*SQRT(B13Q/SQ2)
      ENDIF

      ARVET7=-(YMAX-YMIN)*(CG1+CG2+CG3)/(LOG(XT2)*CG0)

      IF (MSTA(19).EQ.0) RETURN

      ARVET7=ARVET7*ARVETH()


      RETURN

C**** END OF ARVET7 ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARVETH.
      REAL FUNCTION ARVETH()

C...ARiadne function Heavy VETo factor

C...Extra acceptance factor for heavy dipoles

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARVETH=0.0
      BX1=1.0-B1+Y1-Y3
      BX3=1.0-B3+Y3-Y1
      IF (B2.GE.1.0.OR.BX1.LE.0.OR.BX3.LE.0) RETURN
      BXM=BX1/BX3
      ARVETH=1.0-(Y1*BXM+Y3/BXM)/(1.0-B2)

      RETURN

C**** END OF ARVETH ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARVET8.
      REAL FUNCTION ARVET8()

C...ARiadne function VETo factor version 8

C...Determine the acceptance factor for chosen x_t^2 and y
C...Suitable for q-qbar emission

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/


      ARVET8=((1.0D0-B3+Y3)**2+(1.0D0-B2+Y2)**2)*(BC3-B3)*
     $         (YMAX-YMIN)/YINT

      RETURN

C**** END OF ARVET8 ****************************************************
      END
C***********************************************************************
C $Id: artune.f,v 3.19 1995/11/30 10:15:29 leif Exp $
CDECK  ID>, ARTUNE.
      SUBROUTINE ARTUNE(SET)

C...ARiadne subroutine TUNE

C...Sets parameters and switches in Ariadne and other programs which
C...Ariadne runs with.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/
      COMMON /PYPARS/ MSTP(200),PARP(200),MSTI(200),PARI(200)
      SAVE /PYPARS/

      CHARACTER SET*(*)


      PARA(1)=0.22
      PARA(2)=0.2
      PARA(3)=0.6
      PARA(4)=1.0/137.0
      PARA(5)=0.6
      PARA(6)=-1.0
      PARA(7)=0.0
      PARA(8)=0.0
      PARA(9)=0.0
      PARA(10)=1.0
      PARA(11)=0.6
      PARA(12)=0.6
      PARA(13)=0.6
      PARA(14)=1.0
      PARA(15)=1.0
      PARA(16)=-1.0
      PARA(17)=2.0
      PARA(18)=1.0
      PARA(19)=0.001
      PARA(20)=0.0
      PARA(21)=1.0
      PARA(22)=0.0
      PARA(23)=0.0
      PARA(24)=0.0
      PARA(25)=2.0
      PARA(26)=9.0
      PARA(27)=0.6
      PARA(28)=0.0
      PARA(29)=0.0
      PARA(30)=0.0
      PARA(31)=25.0
      PARA(32)=0.0
      PARA(33)=0.0
      PARA(34)=0.0
      PARA(35)=0.0
      PARA(36)=0.0
      PARA(37)=0.0
      PARA(38)=0.0
      PARA(39)=0.001
      PARA(40)=1.0E32

      MSTA(3)=0
      MSTA(6)=-1
      MSTA(11)=0
      MSTA(12)=1
      MSTA(14)=1
      MSTA(15)=5
      MSTA(16)=2
      MSTA(17)=3
      MSTA(18)=3
      MSTA(19)=2
      MSTA(20)=0
      MSTA(21)=0
      MSTA(22)=1
      MSTA(23)=1
      MSTA(24)=2
      MSTA(25)=1
      MSTA(26)=0
      MSTA(27)=0
      MSTA(28)=0
      MSTA(29)=0
      MSTA(30)=3
      MSTA(31)=1
      MSTA(32)=2
      MSTA(33)=1
      MSTA(34)=2
      MSTA(35)=0
      MSTA(36)=2
      MSTA(37)=1

      PHAR(101)=-1.0
      PHAR(102)=-1.0
      PHAR(103)=1.0
      PHAR(104)=1.0
      PHAR(105)=0.0
      PHAR(107)=-1.0
      PHAR(109)=2.0

      MHAR(101)=2
      MHAR(102)=2
      MHAR(103)=1
      MHAR(104)=0
      MHAR(106)=0
      MHAR(107)=0
      MHAR(108)=0
      MHAR(109)=0
      MHAR(110)=0
      MHAR(111)=1
      MHAR(112)=-1
      MHAR(113)=1
      MHAR(115)=0
      MHAR(116)=0
      MHAR(117)=0
      MHAR(118)=0
      MHAR(120)=1
      MHAR(123)=0
      MHAR(128)=1
      MHAR(130)=1
      MHAR(131)=1
      MHAR(132)=1
      MHAR(133)=9
      MHAR(134)=1

      PHAR(101)=-1.0
      PHAR(102)=-1.0
      PHAR(103)=1.0
      PHAR(104)=1.0
      PHAR(105)=0.0
      PHAR(107)=-1.0

      PARP(85)=0.0

      IF (SET.EQ.'4.04') THEN
        PARA(19)=0.0
        PARA(25)=0.0
        MSTA(19)=1
        MSTA(22)=0
        MSTA(23)=0
        MSTA(25)=0
        MSTA(26)=0
        MSTA(30)=1
        MSTA(32)=0
        MSTA(33)=0
        MSTA(36)=0
        MSTA(37)=0
        MSTA(38)=0
        MSTA(39)=0
        MSTA(40)=0
        MHAR(101)=0
        MHAR(103)=0
        MHAR(111)=0
        MHAR(120)=0
        MHAR(128)=0
        MHAR(130)=0
        MHAR(131)=0
        MHAR(132)=0
        MHAR(133)=0
        MHAR(134)=0
        MSTJ(11)=1
        PARJ(41)=0.23
        PARJ(42)=0.34
        PARJ(21)=0.405
        PARL(3)=0.47
        WRITE(MSTA(7),1000) 'version 4.04 of the EMC/DELPHI'
      ELSEIF (SET.EQ.'4.05') THEN
        PARA(19)=-1.0
        PARA(21)=0.25
        PARA(25)=0.0
        MSTA(19)=2
        MSTA(30)=1
        MSTA(32)=1
        MSTA(36)=0
        MSTA(37)=0
        MHAR(101)=0
        MHAR(103)=0
        MHAR(111)=0
        MHAR(120)=0
        MHAR(128)=0
        MHAR(130)=0
        MHAR(131)=0
        MHAR(132)=0
        MHAR(133)=0
        MHAR(134)=0

        MSTJ(11)=1
        PARJ(41)=0.23
        PARJ(42)=0.34
        PARJ(21)=0.405
        PARL(3)=0.6
        WRITE(MSTA(7),1000) 'version 4.05 of the EMC/DELPHI'
      ELSEIF (SET.EQ.'4.06') THEN
        PARA(21)=0.25
        PARA(25)=0.0
        MSTA(19)=2
        MSTA(30)=1
        MSTA(36)=0
        MSTA(37)=0
        MHAR(101)=1
        MHAR(120)=0
        MHAR(128)=0
        MHAR(130)=0
        MHAR(131)=0
        MHAR(132)=0
        MHAR(133)=0

        MSTJ(11)=1
        PARJ(41)=0.23
        PARJ(42)=0.34
        PARJ(21)=0.405
        PARL(3)=0.6
        WRITE(MSTA(7),1000) 'version 4.06 of the EMC/DELPHI'
      ELSEIF (SET.EQ.'ALEPH'.OR.SET.EQ.'aleph') THEN
        PARA(1)=0.218
        PARA(3)=0.58
        PARA(5)=0.58
        PARA(25)=0.0
        MSTA(19)=1
        MSTA(20)=1
        MSTA(30)=1
        MSTA(36)=0
        MSTA(37)=0
        MHAR(101)=1
        MHAR(111)=0
        MHAR(120)=0
        MHAR(128)=0
        MHAR(130)=0
        MHAR(131)=0
        MHAR(132)=0
        MHAR(133)=0
        MHAR(134)=0
        MSTJ(11)=3
        PARJ(41)=0.5
        PARJ(42)=0.81
        PARJ(21)=0.354
        PARJ(54)=-0.05
        PARJ(55)=-0.006
        WRITE(MSTA(7),1000) SET
      ELSEIF (SET.EQ.'DELPHI'.OR.SET.EQ.'delphi') THEN
        PARA(25)=0.0
        MSTA(19)=1
        MSTA(30)=1
        MSTA(36)=0
        MSTA(37)=0
        MHAR(101)=1
        MHAR(120)=0
        MHAR(128)=0
        MHAR(130)=0
        MHAR(132)=0
        MHAR(133)=0
        MHAR(134)=0
        MSTJ(11)=1
        PARJ(41)=0.23
        PARJ(42)=0.34
        PARJ(21)=0.405
        WRITE(MSTA(7),1000) SET
      ELSEIF (SET.EQ.'OPAL'.OR.SET.EQ.'opal') THEN
        PARA(1)=0.20
        PARA(3)=1.0
        PARA(5)=1.0
        PARA(25)=0.0
        MSTA(19)=1
        MSTA(30)=1
        MSTA(36)=0
        MSTA(37)=0
        MHAR(101)=1
        MHAR(111)=0
        MHAR(120)=0
        MHAR(128)=0
        MHAR(130)=0
        MHAR(131)=0
        MHAR(132)=0
        MHAR(133)=0
        MHAR(134)=0
        PARJ(41)=0.18
        PARJ(42)=0.34
        PARJ(21)=0.37
        WRITE(MSTA(7),1000) SET
      ELSEIF (SET.EQ.'A406P04'.OR.SET.EQ.'a406p04'.OR.
     $        SET.EQ.'A406P05'.OR.SET.EQ.'a406p05'.OR.
     $        SET.EQ.'A406P07'.OR.SET.EQ.'a406p07'.OR.
     $        SET.EQ.'A406P09'.OR.SET.EQ.'a406p09'.OR.
     $        SET.EQ.'LEP2GG'.OR.SET.EQ.'lep2gg') THEN
        PARA(21)=1.0
        PARA(25)=0.0
        PARA(27)=0.6
        MSTA(19)=2
        MSTA(30)=3
        MSTA(36)=2
        MSTA(37)=1

        PHAR(109)=2.0
        MHAR(101)=1
        MHAR(111)=0
        MHAR(118)=0
        MHAR(120)=1
        MHAR(123)=1
        MHAR(128)=0
        MHAR(130)=0
        MHAR(131)=0
        MHAR(132)=0
        MHAR(133)=0
        MHAR(134)=0

        MSTJ(11)=1
        PARJ(41)=0.23
        PARJ(42)=0.34
        PARJ(21)=0.405
        PARL(3)=0.6
        WRITE(MSTA(7),1000) 'PRELIMINARY 4.06'
      ELSEIF (SET.EQ.'EMC'.OR.SET.EQ.'emc'.OR.
     $       SET.EQ.'4.07'.OR.SET.EQ.'4.08') THEN
        PARA(21)=1.0
        PARA(25)=2.0
        PARA(26)=9.0
        PARA(27)=0.6
        PARA(28)=0.0
        MSTA(19)=2
        MSTA(22)=1
        MSTA(30)=3
        MSTA(35)=0
        MSTA(36)=2
        MSTA(37)=1

        PHAR(109)=2.0
        MHAR(101)=2
        MHAR(111)=1
        MHAR(118)=0
        MHAR(120)=1
        MHAR(123)=0
        MHAR(128)=1
        MHAR(130)=1
        MHAR(131)=1
        MHAR(132)=1
        MHAR(133)=9
        MHAR(134)=1

        MSTJ(11)=1
        PARJ(41)=0.23
        PARJ(42)=0.34
        PARJ(21)=0.405
        PARL(3)=0.6
        PARP(85)=0.0
        WRITE(MSTA(7),1000) 'EMC/DELPHI'
      ELSE
        WRITE(MSTA(7),1010) SET
      ENDIF

 1000 FORMAT(7x,'Parameters and switches initialized using the "',A,
     $     '" tuning set')
 1010 FORMAT('Tuning set "',A,'" does not exist. Parameters and',
     $     ' switches retains their default value')

      RETURN

C**** END OF ARTUNE ****************************************************
      END
C***********************************************************************
C $Id: arprda.f,v 3.1 1994/05/11 07:10:43 lonnblad Exp $
CDECK  ID>, ARPRDA.
      SUBROUTINE ARPRDA

C...ARiadne subroutine PRint DAta

C...Prints out parameters and switches used in Ariadne.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/


      WRITE(MSTA(7),*)
      WRITE(MSTA(7),1000)
      DO 100 I=1,20
        WRITE(MSTA(7),1010) I,MSTA(I),MSTA(I+20),PARA(I),PARA(I+20)
 100  CONTINUE
      WRITE(MSTA(7),*)

 1000 FORMAT(10X,'Parameters and switches used by Ariadne:',/,/,
     $     '         I   MSTA(I) MSTA(I+20)   PARA(I) PARA(I+20)',/)
 1010 FORMAT(2I10,I11,3X,2G11.3)

      RETURN

C**** END OF ARPRDA ****************************************************
      END
C***********************************************************************
C $Id: archki.f,v 3.14 1995/02/22 12:43:47 lonnblad Exp $
CDECK  ID>, ARCHKI.
      SUBROUTINE ARCHKI(ID,IOK)

C...ARiadne subroutine CHeck KInematics

C...Checks if the generated emission for dipole ID (or current dipole
C...if ID=0) is kinematically allowed.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT2/ PQMAS(10)
      SAVE /ARDAT2/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      common /xdummy/ xx1,xx3

      IOK=0

      IF (ID.NE.0) THEN
        IFLG=IRAD(ID)
        QE1=QEX(IP1(ID))
        QE3=QEX(IP3(ID))
        QQ1=QQ(IP1(ID))
        QQ3=QQ(IP3(ID))
        S=SDIP(ID)
        W=SQRT(S)
        SY1=BP(IP1(ID),5)/W
        SY3=BP(IP3(ID),5)/W
        SY2=0.0
        XT2GG1=-1.0
        XT2GG3=-1.0
        IF (IFLG.NE.0) THEN
          SY2=PQMAS(ABS(IFLG))/W
          IF (IFLG.GT.0) THEN
            XT2GG3=PT2GG(IP3(ID))/S
          ELSE
            XT2GG1=PT2GG(IP1(ID))/S
          ENDIF
          XT2GG3=MAX(XT2GG3,XT2GG1)
          XT2GG1=XT2GG3
        ENDIF
        XT2MP=PT2LST/S
        SSY=SY1+SY2+SY3
        Y1=SY1**2
        Y2=SY2**2
        Y3=SY3**2
        BZP=0.5*(1.0+Y1-Y3+SQRT(1.0+(Y1-Y3)**2-2.0*(Y1+Y3)))
        BZM=0.5*(1.0+Y3-Y1+SQRT(1.0+(Y1-Y3)**2-2.0*(Y1+Y3)))
        B1=BX1(ID)
        B3=BX3(ID)
        AE1=AEX1(ID)
        AE3=AEX3(ID)
        IF (MSTA(25).GT.0) THEN
          BP1=(1.0-AE1)*(BZP-SY1)+SY1
        ELSE
          BP1=(1.0-AE1)*BZP
        ENDIF
        IF (BP1.LE.SY1) THEN
          BP1=0.0
          BM1=0.0
        ELSE
          BM1=Y1/BP1
        ENDIF
        IF (MSTA(25).GT.0) THEN
          BM3=(1.0-AE3)*(BZM-SY3)+SY3
        ELSE
          BM3=(1.0-AE3)*BZM
        ENDIF
        IF (BM3.LE.SY3) THEN
          BM3=0.0
          BP3=0.0
        ELSE
          BP3=Y3/BM3
        ENDIF
      ENDIF

      QRG=(MSTA(17).NE.0)
      QNG=((MSTA(17).EQ.1.OR.MSTA(17).EQ.2).AND.MSTA(16).GT.0.AND.
     $     ((QQ1.AND.(.NOT.QE1)).OR.(QQ3.AND.(.NOT.QE3))))
      QRG=(QRG.AND.(.NOT.QNG))

      IF (PARA(19).LT.0.0) THEN
        IF (KQ1.GT.0) THEN
          XX1=1.0-BMRP1-BMR1*B1
          SQ2=XT2*S/(1.0-XX1)
          IF (ARSTRA(KF1,KQ1,XX1,-1.0,SQ2).LT.0.0) RETURN
          XX1=1.0-BMRP1-BMR1*BP1
          SQ2=XT2*S/(1.0-XX1)
          IF (ARSTRA(KF1,KQ1,XX1,-1.0,SQ2).LT.0.0) RETURN
        ENDIF
        IF (KQ3.GT.0) THEN
          XX3=1.0-BMRP3-BMR3*B3
          SQ2=XT2*S/(1.0-XX3)
          IF (ARSTRA(KF3,KQ3,XX3,1.0,SQ2).LT.0.0) RETURN
          XX3=1.0-BMRP3-BMR3*BM3
          SQ2=XT2*S/(1.0-XX3)
          IF (ARSTRA(KF3,KQ3,XX3,1.0,SQ2).LT.0.0) RETURN
        ENDIF
      ENDIF

      IF (IFLG.EQ.0.AND.(QE1.OR.QE3).AND.
     $     (BP1.GT.0.0.OR.BM3.GT.0.0).AND.QRG) THEN
        AZ1=1.0-BP1-BP3
        AZ3=1.0-BM1-BM3
        IF (AZ1.LE.0.0) RETURN
        IF (AZ3.LE.0.0) RETURN
        Y1A=Y1/(AZ1*AZ3)
        IF (BP1.GT.0.0) Y1A=0.0
        Y3A=Y3/(AZ1*AZ3)
        IF (BM3.GT.0.0) Y3A=0.0
        BE1=0.5*(1.0-(1.0-B1+Y1-Y3)/AZ1+Y1A-Y3A)
        BE3=0.5*(1.0-(1.0-B3+Y3-Y1)/AZ3+Y3A-Y1A)
        BE2=1.0-BE1-BE3
        BP1A=BE1**2-Y1A
        BP2A=BE2**2-Y2
        BP3A=BE3**2-Y3A
        IF (2.0*(BP1A*BP2A+BP2A*BP3A+BP3A*BP1A).LE.
     $       (BP1A**2+BP2A**2+BP3A**2)) RETURN
        IF (BE1.LT.SQRT(Y1A)) RETURN
        IF (BE2.LT.SY2) RETURN
        IF (BE3.LT.SQRT(Y3A)) RETURN
        PT21=B3
        PT23=B1
        IF (BP1.GT.0.0.AND.BM3.GT.0.0.AND.MSTA(17).GE.2) THEN
          BP2=1.0-B1+Y1-Y3
          BM2=1.0-B3+Y3-Y1
          PT21=(BM2*BP2**3)/(1.0-BP1-BP2)**2
          PT23=(BP2*BM2**3)/(1.0-BM3-BM2)**2
        ENDIF
        IF ((BP1.GT.0.0.AND.BM3.GT.0.0.AND.PT21.GE.PT23).OR.
     $       (BM3.GT.0.0.AND.BP1.LE.0.0)) THEN
          BM3=0.0
          BP3=0.0
        ELSE
          BP1=0.0
          BM1=0.0
        ENDIF
        AZ1=1.0-BP1-BP3
        AZ3=1.0-BM1-BM3
        IF (AZ1.LE.0.0) RETURN
        IF (AZ3.LE.0.0) RETURN
        Y1A=Y1/(AZ1*AZ3)
        IF (BP1.GT.0.0) Y1A=0.0
        Y3A=Y3/(AZ1*AZ3)
        IF (BM3.GT.0.0) Y3A=0.0
        BE1=0.5*(1.0-(1.0-B1+Y1-Y3)/AZ1+Y1A-Y3A)
        BE3=0.5*(1.0-(1.0-B3+Y3-Y1)/AZ3+Y3A-Y1A)
        BE2=1.0-BE1-BE3
        BP1A=BE1**2-Y1A
        BP2A=BE2**2-Y2
        BP3A=BE3**2-Y3A
        IF (2.0*(BP1A*BP2A+BP2A*BP3A+BP3A*BP1A).LE.
     $       (BP1A**2+BP2A**2+BP3A**2)) RETURN
        IF (BE1.LT.SQRT(Y1A)) RETURN
        IF (BE2.LT.SY2) RETURN
        IF (BE3.LT.SQRT(Y3A)) RETURN
      ELSE

        BE1=0.5*B1
        BE3=0.5*B3
        BE2=1.0-BE1-BE3
          
        BP1A=BE1**2-Y1
        BP2A=BE2**2-Y2
        BP3A=BE3**2-Y3
        IF (2.0*(BP1A*BP2A+BP2A*BP3A+BP3A*BP1A).LE.
     $       (BP1A**2+BP2A**2+BP3A**2)) RETURN
        IF (BE1.LT.SY1) RETURN
        IF (BE2.LT.SY2) RETURN
        IF (BE3.LT.SY3) RETURN

        IF (IFLG.NE.0.AND.MSTA(28).NE.0) THEN
          QUITIT=.FALSE.
          SMQQ=1.0D0-B1+Y1
          IF (ABS(MSTA(28)).EQ.2) SMQQ=BC1-B1
          IF (XT2GG1.GT.0.0.AND.XT2GG3.GT.0.0) THEN
            IF (SMQQ.GT.XT2GG1.AND.SMQQ.GT.XT2GG3) QUITIT=.TRUE.
            IF ((SMQQ.GT.XT2GG1.OR.SMQQ.GT.XT2GG3)
     $           .AND.RLU(IDUM).GT.0.5) QUITIT=.TRUE.
          ELSEIF (XT2GG1.GT.0.0) THEN
            IF (SMQQ.GT.XT2GG1) QUITIT=.TRUE.
          ELSEIF (XT2GG3.GT.0.0) THEN
            IF (SMQQ.GT.XT2GG3) QUITIT=.TRUE.
          ENDIF
          IF (QUITIT) RETURN
        ENDIF

      ENDIF

      IF (PHAR(101).GT.0.AND.
     $     ARTPT2(0,S,B1,B3,Y1,Y2,Y3).GT.PHAR(101)) RETURN

      IOK=1

      RETURN

C**** END OF ARCHKI ****************************************************
      END
C***********************************************************************
C $Id: archki.f,v 3.14 1995/02/22 12:43:47 lonnblad Exp $
CDECK  ID>, ARTPT2.
      REAL FUNCTION ARTPT2(ID,SN,BX1IN,BX3IN,Y1IN,Y2IN,Y3IN)

C...Ariadne function True PT2

C...Calculates the (minimum) true p_t^2 of a gluon given x1 and x3 of
C...an emission 


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      

      ARTPT2=-1.0

      IF (ID.EQ.0) THEN
        S=SN
        B1=BX1IN
        B3=BX3IN
        Y1=Y1IN
        Y2=Y2IN
        Y3=Y3IN
      ELSE
        S=SDIP(ID)
        B1=BX1(ID)
        B3=BX3(ID)
        Y1=(BP(IP1(ID),5)**2)/SDIP(ID)
        Y2=0.0
        Y3=(BP(IP3(ID),5)**2)/SDIP(ID)
      ENDIF


      BZ12=0.25*B1**2-Y1
      BZ22=0.25*(2.0-B1-B3)**2-Y2
      BZ32=0.25*B3**2-Y3
      BCOS=2.0*BZ12*BZ22+2.0*BZ12*BZ32+2.0*BZ22*BZ32
     $     -BZ12**2-BZ22**2-BZ32**2
      IF (BCOS.LE.0.0) RETURN
      ARTPT2=0.25*S*BCOS/MAX(BZ12,BZ32)

      RETURN

C**** END OF ARTPT2 ****************************************************
      END
C***********************************************************************
C $Id: arexma.f,v 3.3 1994/05/11 07:10:22 lonnblad Exp $
CDECK  ID>, AREXMA.
      SUBROUTINE AREXMA(I1,I3)

C...ARiadne subroutine make EXtended partons MAssless

C...Makes extended partons massless.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/


      IF (MSTA(31).GT.0) RETURN
      IF ((.NOT.QEX(I1)).AND.(.NOT.QEX(I3))) RETURN
      DPE1=BP(I1,4)
      DPE3=BP(I3,4)
      DPE=DPE1+DPE3
      DPX1=BP(I1,1)
      DPX3=BP(I3,1)
      DBEX=(DPX1+DPX3)/DPE
      DPY1=BP(I1,2)
      DPY3=BP(I3,2)
      DBEY=(DPY1+DPY3)/DPE
      DPZ1=BP(I1,3)
      DPZ3=BP(I3,3)
      DBEZ=(DPZ1+DPZ3)/DPE
      CALL AROBO2(0.0,0.0,-DBEX,-DBEY,-DBEZ,I1,I3)

C...Calculate rotation angles but no need for rotation yet
      PX=BP(I1,1)
      PY=BP(I1,2)
      PZ=BP(I1,3)
      PHI=ULANGL(PX,PY)
      THE=ULANGL(PZ,SQRT(PX**2+PY**2))
      CALL AROBO2(0.0,-PHI,0.0D0,0.0D0,0.0D0,I1,I3)
      CALL AROBO2(-THE,0.0,0.0D0,0.0D0,0.0D0,I1,I3)
      IF (QEX(I1)) BP(I1,5)=0.0
      IF (QEX(I3)) BP(I3,5)=0.0
      BE=BP(I1,4)+BP(I3,4)
      BP(I1,4)=0.5*(BE**2+BP(I1,5)**2-BP(I3,5)**2)/BE
      BP(I3,4)=BE-BP(I1,4)
      BP(I1,3)=SQRT(BP(I1,4)**2-BP(I1,5)**2)
      BP(I3,3)=-BP(I1,3)
      BP(I1,2)=0.0
      BP(I3,2)=0.0
      BP(I1,1)=0.0
      BP(I3,1)=0.0

      CALL AROBO2(THE,PHI,DBEX,DBEY,DBEZ,I1,I3)

      RETURN

C**** END OF AREXMA ****************************************************
      END
C***********************************************************************
C $Id: arphas.f,v 3.5 1994/05/11 07:10:41 lonnblad Exp $
CDECK  ID>, ARPHAS.
      SUBROUTINE ARPHAS(IFIRST)

C...ARiadne function PHi ASymmetry

C...Calculate a phi-angle to rotate en emission to  correctly treat
C...asymmetries in O(alpha_S)  ME for lepto production.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON /ARINT4/ BASS(5),BASSX1,BASSX3,IFLASS
      SAVE /ARINT4/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/


      IF (IFLASS.EQ.0) RETURN

      PHI=ULANGL(SNGL(BASS(1)),SNGL(BASS(2)))
      CALL LUDBRB(IFIRST,N,0.0,-PHI,0.0D0,0.0D0,0.0D0)


      BEPS1=1.0-PARA(39)
      BEPS0=PARA(39)
      B1=MIN(BASSX1,BEPS1)
      B3=MIN(BASSX3,BEPS1)
      B2=MIN(2.0D0-B1-B3,BEPS1)
      B12=1.0D0-B2

      SQ2=XQ2/W2
      XP=MAX(MIN(SQ2/(1.0-B3+SQ2),BEPS1),BEPS0)
      ZQ=MAX(MIN(B12/B3,BEPS1),BEPS0)


      IF (IFLASS.EQ.21) THEN
C.......Calculate guon asymmetry
        LST(24)=2
        SIGT=(ZQ**2+XP**2)/((1.0-XP)*(1.0-ZQ))+2.0*(XP*ZQ+1.0)
        SIGS=4.0*XP*ZQ
        SIG1=2.0*XY*SQRT((1.0-XY)*XP*ZQ/((1.0-XP)*(1.0-ZQ)))*
     $       (1.0-2.0/XY)*(1.0-ZQ-XP+2.0*XP*ZQ)
        SIG2=2.0*(1.0-XY)*XP*ZQ
      ELSE
C.......Calculate quark asymmetry
        LST(24)=3
        SIGT=(XP**2+(1.0-XP)**2)*(ZQ**2+(1.0-ZQ)**2)/(ZQ*(1.0-ZQ))
        SIGS=8.0*XP*(1.0-XP)
        SIG1=2.0*XY*SQRT((1.0-XY)*XP*(1.0-XP)/(ZQ*(1.0-ZQ)))
        SIG2=4.0*(1.0-XY)*XP*(1.0-XP)
      ENDIF

      SIG0=0.5*(1.0+(1.0-XY)**2)*SIGT+(1.0-XY)*SIGS

 100  PHI=RLU(0)*PARU(2)
      IF (SIG0+SIN(PHI)*SIG1+SIN(2.0*PHI)*SIG2.LT.
     $     RLU(0)*(SIG0+SIG1+SIG2)) GOTO 100

      CALL LUDBRB(IFIRST,N,0.0,PHI,0.0D0,0.0D0,0.0D0)
      
      RETURN

C**** END OF ARPHAS ****************************************************
      END
C***********************************************************************
C $Id: arlept.f,v 3.21 1995/08/13 17:29:13 lonnblad Exp $
CDECK  ID>, ARLEPT.
      SUBROUTINE ARLEPT

C...ARiadne subroutine perform cascade on LEPTo event

C...Performs a cascade starting on a zero'th order event from LEPTO


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT4/ BASS(5),BASSX1,BASSX3,IFLASS
      SAVE /ARINT4/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/


C...Check that Ariadne was properly initialized
      IF (MSTA(2).EQ.0.OR.MSTA(1).NE.3) CALL ARERRM('ARLEPT',12,0)
      IFLASS=0
      MSAV33=MSTA(33)

C...Boost to the hadronic center of mass
      CALL ARBOLE(THEL,PHI1,PHI2,DBXL,DBYL,DBZL)

C...Check which quark was struck and try to decide whether it was
C...a sea quark
      IFLSTR=LST(25)

C...Copy to Ariadne event record
      CALL ARCOPA(5,1,SIGN(1,IFLSTR))
      IF (MSTA(30).LT.2) THEN
        QEX(1)=.FALSE.
        XPMU(1)=0.0
        XPA(1)=0.0
      ELSE
        QEX(1)=.TRUE.
        IF (PARA(14).GE.0) THEN
          XPMU(1)=SQRT(XQ2)*PARA(14)
        ELSE
          XPMU(1)=ABS(PARA(14))
        ENDIF
        XPA(1)=PARA(15)
      ENDIF
      CALL ARCOPA(6,2,-SIGN(1,IFLSTR))
      CALL ARCRDI(1,1,2,1,.FALSE.)
      CALL ARCOLI(1,-1)
      IPART=2
      IDIPS=1
      ISTRS=1
      IFLOW(1)=SIGN(1,IFLSTR)
      IPF(1)=1
      IPL(1)=2
      IMF=5
      IML=N
      QDUMP=.FALSE.
      NSAV=N+1

      IRQ=0
      IRD=2
      IRP=0
      IF (N.GT.6) IRP=7

      CALL ARREMN(2,IRQ,IRD,IRP,-1)

      IF (PHAR(112).LT.0) THEN
        PHAR(112)=-XPMU(IRD)**2
        IF (MHAR(107).EQ.4) PHAR(112)=-XQ2
      ENDIF

      IF (IRP.LE.0.OR.MSTA(32).GT.1) THEN
        LST(24)=1
        PT2LST=PARA(40)
        CALL ARCASC
        GOTO 900
      ENDIF

C...Initiate initial g->QQ splitting
      PT2BGF=PARA(40)
      IF (MSTA(9).GT.0) CALL ARCHEM(1)
      IO=0
      LST(24)=1

      PT2LST=PARA(40)
      PT2MIN=ARGPT2(1)/PHAR(103)
 210  IF (ABS(MSTA(33)).GT.0) THEN
        CALL ARPTQQ(K(2,2),IFLSTR,SQRT(W2),
     $       PT2BGF,PT2MIN,X,XQ2,XY,XP,ZQ,YQ,PHI)
      ELSE
        CALL ARPTQQ(K(2,2),IFLSTR,SQRT(W2),
     $       PT2BGF,PT2MIN,X,XQ2,1.0,XP,ZQ,YQ,PHI)
      ENDIF
      IF (PT2BGF.GT.PT2MIN) THEN
        CALL ARINQQ(2,IFLSTR,IRP,PT2BGF,YQ,ZQ,PHI,QFAIL)
        IF (QFAIL) GOTO 210
        LST(24)=3
        CALL AREVOL(SQRT(PHAR(103)*PT2BGF),0.0)
      ELSE
        CALL AREVOL(SQRT(PT2LST),0.0)
        IF (IO.GT.0) LST(24)=2
      ENDIF

C...Check momentum and dump to /LUJETS/
      IF (.NOT.QDUMP) CALL ARDUMP
      IF (MSTA(9).GT.0) CALL ARCHEM(0)
      GOTO 900

C...Include Phi asymmetries for matrix element
 900  IF (IO.GT.0.AND.ABS(MSTA(33)).EQ.1) CALL ARPHAS(NSAV)

      MSTA(33)=MSAV33
      CALL LUDBRB(1,N,0.0,PHI2,0.0D0,0.0D0,0.0D0)
      CALL LUDBRB(1,N,THEL,PHI1,DBXL,DBYL,DBZL)
        
      RETURN

C**** END OF ARLEPT ****************************************************
      END
C***********************************************************************
C $Id: argdis.f,v 3.14 1995/08/15 09:08:49 lonnblad Exp $
CDECK  ID>, ARGDIS.
      SUBROUTINE ARGDIS(ID)

C...ARiadne subroutine Generate first Deep Inelastic Scattering emission

C...Generates a p-t^2 for a possible emission from an original dipole in
C...a DIS scattering according to O(alpha_S) matrix elements

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/


C...Copy some information from dipole record
C...S      = the invariant mass squared
C...W      = total energy in dipole
C...XT2MP  = maximum allowed fractional p_t^2 (x_t^2) for restricted  
C...         phase space option
C...QQ1(3) = Boolean variable 'is quark' for parton 1(3)
C...QE1(3) = true if parton 1(3) is extended
C...ALP1(3)= alpha parameter of parton 1(3)
C...XMU1(3)= mu parameter of parton 1(3)
C...SY1(3) = fractional mass of parton 1(3)
      PT2IN(ID)=0.0
      S=SDIP(ID)
      IF (S.LE.4.0*PARA(3)**2) RETURN
      W=SQRT(S)
      QQ1=QQ(IP1(ID))
      QQ3=QQ(IP3(ID))
      QE1=QEX(IP1(ID))
      QE3=QEX(IP3(ID))
      ALP1=XPA(IP1(ID))
      ALP3=XPA(IP3(ID))
      XMU1=XPMU(IP1(ID))
      XMU3=XPMU(IP3(ID))
      SY1=BP(IP1(ID),5)/W
      SY3=BP(IP3(ID),5)/W
      IFL1=IFL(IP1(ID))
      IFL3=IFL(IP3(ID))
      IF (PARA(19).LT.0.0) CALL ARPRGC(ID)

      IF (S.LT.4.0*PARA(3)**2) RETURN

      IF (MSTA(36).EQ.-1) XMU3=PARA(11)

C...XLAM = scaled lambda_QCD squared
      XLAM2=PARA(1)**2/S

C...alpha_0 for alpha_QCD = alpha_0/ln(p_t^2/lambda_QCD^2)
      XNUMFL=MAX(ARNOFL(W,MAX(5,MSTA(15))),3.0)
      ALPHA0=12.0*PARU(1)/(33.0-2.0*XNUMFL)

C...Set Q^2 and Y dependencies for veto algorithm
      ZSQEV=S/W2
      SQ2=XQ2/W2
      YFAC=2.0*(1.0-XY)/(1.0+(1.0-XY)**2)

C...Call veto algorithm
      CALL ARGDIG(ID)


      RETURN

C**** END OF ARGDIS ****************************************************
      END
C***********************************************************************
C $Id: argdis.f,v 3.14 1995/08/15 09:08:49 lonnblad Exp $
CDECK  ID>, ARGDIG.
      SUBROUTINE ARGDIG(ID)

C...ARiadne subroutine Generate first Deep Inelastic Scattering emission

C...Generates a p-t^2 for a possible emission from an original dipole in
C...a DIS scattering according to O(alpha_S) matrix elements

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/

      EXTERNAL ARNDX1,ARNDX2,ARNDY2,ARVET6,ARVET7
      REAL ARNDX1,ARNDX2,ARNDY2,ARVET6,ARVET7


C...First gluon emission
      SY2=0.0
      IFLG=0

C...Calculate mass dependent parameters
      CALL ARMADE

C...C = colour factors etc. in cross section
      C=2.0*(3.0+4.0*YFAC/27.0)/(3.0*PARU(1))
      IF (MHAR(116).LE.0) THEN
        C=2.0*(6.0+0.25*YFAC)/(3.0*PARU(1))
      ENDIF

C...Minimum x_t^2
      XT2C=MAX(PT2IN(ID),PARA(3)**2)/S
      XT2=0.0

      IF (XT2M.LE.XT2C) GOTO 900

C...Set additional parameters and call the veto algorith with
C...Suitable random functions
      IF (MSTA(12).GT.0) THEN
C.......Running alpha_QDC
        YINT=2.0*LOG(0.5/SQRT(XLAM2)+SQRT(0.25/XLAM2-1.0))
        CN=1.0/(YINT*C*ALPHA0)
        CALL ARMCDI(ARNDX1,ARNDY2,ARVET6)
      ELSE
C.......Constant alpha_QCD
        YINT=1.0
        CN=2.0/(C*PARA(2))
        CALL ARMCDI(ARNDX2,ARNDY2,ARVET7)
      ENDIF

C...Save the generated values of p_t^2, x1, x3, a1 and a3
      IF (XT2.GT.XT2C) THEN
        PT2IN(ID)=XT2*S
        BX1(ID)=B1
        BX3(ID)=B3
        AEX1(ID)=AE1
        AEX3(ID)=AE3
        IRAD(ID)=0
      ENDIF

 900  CONTINUE


      RETURN

C**** END OF ARGDIG ****************************************************
      END
C***********************************************************************
C $Id: arpyth.f,v 3.16 1995/08/15 09:08:54 lonnblad Exp $
CDECK  ID>, ARPYTH.
      SUBROUTINE ARPYTH

C...ARiadne subroutine perform cascade on PYTHia event

C...Performs a cascade starting on a zero'th order event from PYTHIA


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT2/KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
      INTEGER  KCHG
      REAL  PMAS,PARF,VCKM
      SAVE /GUDAT2/
**JWG  add psi'(3685) as KC code 80, needed for Eurodec interface
*      --- ---------- -- -- ---- --- ------ --- ------- ---------
      INTEGER  IDPSIP
      PARAMETER  (IDPSIP=80)
      COMMON /PYPARS/ MSTP(200),PARP(200),MSTI(200),PARI(200)
      SAVE /PYPARS/
      COMMON /PYINT1/ MINT(400),VINT(400)
      SAVE /PYINT1/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/

      DIMENSION IR(4)

      ICC(KF)=KCHG(LUCOMP(IABS(KF)),2)*ISIGN(1,KF)
      QDIFF(I,J)=((ABS(K(K(I,3),2)).EQ.210.OR.
     $     ABS(K(K(I,3),2)).EQ.2110.OR.ABS(K(K(I,3),2)).EQ.2210).AND.
     $     K(K(I,3),3).EQ.J)


      IF (LUCOMP(IABS(MSTI(13))).EQ.0) MSTI(13)=K(1,2)
      IF (LUCOMP(IABS(MSTI(14))).EQ.0) MSTI(14)=K(2,2)

C...Check that Ariadne was properly initialized
      IF (MSTA(2).EQ.0.OR.MSTA(1).NE.2) CALL ARERRM('ARPYTH',12,0)

C...Boost to total cms with particl 1 along z-axis
      CALL ARBOPY(THEPY,PHIPY,DBXPY,DBYPY,DBZPY,PHI2PY)

C...Save some parameters that may be changed locally
      ISUB=MSTI(1)
      IFIRST=MSTI(4)+1

C...If we have no colour in the initial state Life is easy
      QH1=(KLU(1,13).NE.0)
      QH2=(KLU(2,13).NE.0)
      IF (ICC(MSTI(13)).EQ.0.AND.ICC(MSTI(14)).EQ.0.AND.
     $     (.NOT.QH1).AND.(.NOT.QH2)) THEN
        IF (ISUB.EQ.25.OR.ISUB.EQ.22) THEN
          CALL ARPYWW
        ELSE
          CALL ARPARS(IFIRST,N)
        ENDIF
        GOTO 900
      ENDIF

C...Check For Drell-Yan type event and make preparations
      CALL ARPRDY

C...Mark up all coloured particles not coming from the hard
C...interaction and save positions of true remnants
      IRQ1=0
      IRD1=0
      IRP1=0
      IRQ2=0
      IRD2=0
      IRP2=0
      PRX1=0.0
      PRY1=0.0
      PRX2=0.0
      PRY2=0.0
      QD1=.FALSE.
      QD2=.FALSE.
      DO 100 I=IFIRST,N
        IF (LUCOMP(IABS(K(I,2))).EQ.0) GOTO 100
        IC=ICC(K(I,2))
        IF (K(I,3).EQ.1.OR.QDIFF(I,1)) THEN
          IF (QDIFF(I,1)) QD1=.TRUE.
          IF (IC.EQ.0) THEN
            IRP1=I
          ELSE
            PRX1=PRX1+P(I,1)
            PRY1=PRY1+P(I,2)
            IF (IC*K(1,2).GT.0) THEN
              IRQ1=I
            ELSE
              IRD1=I
            ENDIF
          ENDIF
        ELSEIF (K(I,3).EQ.2.OR.QDIFF(I,2)) THEN
          IF (QDIFF(I,2)) QD2=.TRUE.
          IF (IC.EQ.0) THEN
            IRP2=I
          ELSE
            PRX2=PRX2+P(I,1)
            PRY2=PRY2+P(I,2)
            IF (IC*K(2,2).GT.0) THEN
              IRQ2=I
            ELSE
              IRD2=I
            ENDIF
          ENDIF
        ENDIF
 100  CONTINUE

C...Transfer all dipoles to be cascaded to the Ariadne event record
      IR(1)=IRQ1
      IR(2)=IRD1
      IR(3)=IRQ2
      IR(4)=IRD2
      NSAVE=N
      CALL ARSCAN(IFIRST,NSAVE,4,IR)
      QDUMP=.FALSE.
      
C...Set extendedness of remnants and redistribute momentum if hadron
C...in initial state otherwise special treatment for resolved photon
      IF (QH1) THEN
        IF (.NOT.QD1) CALL ARREMN(1,IR(1),IR(2),IRP1,1)
      ELSE
        JR=MAX(IR(1),IR(2))
        IF (JR.EQ.0.OR.(MHAR(126).EQ.1.AND.
     $       (MINT(107).EQ.3.OR.MINT(107).EQ.0))) THEN
          IF (JR.GT.0) QEX(JR)=.FALSE.
        ELSE
          QEX(JR)=.TRUE.
          XPMU(JR)=PARA(14)*SQRT(PRX1**2+PRY1**2)
          IF (MHAR(128).GT.0)
     $         XPMU(JR)=MAX(XPMU(JR),PARA(14)*ABS(P(1,5)))
          XPA(JR)=PARA(15)
        ENDIF
      ENDIF

      IF (QH2) THEN
        IF (.NOT.QD2) CALL ARREMN(2,IR(3),IR(4),IRP2,-1)
      ELSE
        JR=MAX(IR(3),IR(4))
        IF (JR.EQ.0.OR.(MHAR(126).EQ.1.AND.
     $       (MINT(108).EQ.3.OR.MINT(108).EQ.0))) THEN
          IF (JR.GT.0) QEX(JR)=.FALSE.
        ELSE
          QEX(JR)=.TRUE.
          XPMU(JR)=PARA(14)*SQRT(PRX2**2+PRY2**2)
          IF (MHAR(128).GT.0)
     $         XPMU(JR)=MAX(XPMU(JR),PARA(14)*ABS(P(2,5)))
          XPA(JR)=PARA(15)
        ENDIF
      ENDIF

C...Do special things when DIS lepto-production
      XQ2=-1.0
      XMUST=-1.0
      IF ((MINT(43).EQ.2.OR.MINT(43).EQ.3).AND.
     $     (ISUB.EQ.10.OR.ISUB.EQ.83)) THEN
        X=PARI(34)
        XQ2=-PARI(15)
        XMUST=SQRT(XQ2)*PARA(14)
      ENDIF

C...Perform cascade
      IF (ISUB.EQ.95) THEN
        PT2LST=PHAR(103)*PARP(81)**2
      ELSEIF(ISUB/10.EQ.9.AND.MSTA(34).NE.0) THEN
        PT2LST=MAX(PARP(81)**2,PARI(18))*PHAR(103)
      ELSEIF (MSTA(14).EQ.1) THEN
        PT2LST=PARA(40)
        IF ((ISUB.GE.11.AND.ISUB.LE.17).OR.
     $       (ISUB.GE.28.AND.ISUB.LE.32).OR.
     $       ISUB.EQ.53.OR.ISUB.EQ.68.OR.
     $       (ISUB.GE.80.AND.ISUB.LE.84).OR.
     $       (ISUB.GE.86.AND.ISUB.LE.89).OR.
     $       (ISUB.GE.111.AND.ISUB.LE.113).OR.
     $       ISUB.EQ.115) PT2LST=PARI(18)*PHAR(103)
        IF ((ISUB.EQ.33.OR.ISUB.EQ.34.OR.ISUB.EQ.54).AND.
     $       MHAR(130).EQ.1) PT2LST=PARI(18)*PHAR(103)
      ELSEIF (XMUST.LT.0) THEN
        IF ((ISUB.GE.11.AND.ISUB.LE.17).OR.
     $       (ISUB.GE.28.AND.ISUB.LE.32).OR.
     $       ISUB.EQ.53.OR.ISUB.EQ.68.OR.
     $       (ISUB.GE.80.AND.ISUB.LE.84).OR.
     $       (ISUB.GE.86.AND.ISUB.LE.89).OR.
     $       (ISUB.GE.111.AND.ISUB.LE.113).OR.
     $       ISUB.EQ.115) XMUST=SQRT(PARI(18))*PARA(14)
      ENDIF

C...Set struck quark extended
      IF (MSTA(30).GT.1.AND.XMUST.GT.0) THEN
        DO 110 I=1,IPART
          IF (.NOT.QEX(I)) THEN
            QEX(I)=.TRUE.
            XPMU(I)=XMUST
            XPA(I)=PARA(15)
          ENDIF
 110    CONTINUE
      ENDIF

      CALL ARCASC

C...If multiple interactions, cascade these seperately
      IF (MHAR(133).GT.1.AND.MHAR(133).LT.8) THEN
        IF (MHAR(133).GE.6) NSV=N
        MHAR(133)=-MHAR(133)
        CALL ARPARS(IFIRST,NSAVE)
        MHAR(133)=-MHAR(133)
        IF (MHAR(133).EQ.6) N=NSV
        IF (MHAR(133).EQ.7) THEN
          DO 800 I=1,NSV
            IF (K(I,1).LT.10) K(I,1)=K(I,1)+10
 800      CONTINUE
        ENDIF
      ENDIF

C...If Drell-Yan event fix cascade on decay products
      CALL ARFIDY(NSAVE)

 900  CALL LUDBRB(1,N,0.0,PHI2PY,0.0D0,0.0D0,0.0D0)
      CALL LUDBRB(1,N,THEPY,PHIPY,DBXPY,DBYPY,DBZPY)

      RETURN

C**** END OF ARPYTH ****************************************************
      END
C***********************************************************************
C $Id: arpyth.f,v 3.16 1995/08/15 09:08:54 lonnblad Exp $
CDECK  ID>, ARPRDY.
      SUBROUTINE ARPRDY

C...ARiadne subroutine PRepare for Drell-Yan event

C...Check output from PYTHIA for Drell-Yan event and make preparations.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON /PYPARS/ MSTP(200),PARP(200),MSTI(200),PARI(200)
      SAVE /PYPARS/


      QQ(MAXPAR-2)=.FALSE.
      ISUB=MSTI(1)
      IFIRST=MSTI(4)+1

C...Check which subprocess is active
      ISDY=0
      IF ((ISUB.GT.0.AND.ISUB.LE.8).OR.
     $     (ISUB.GE.14.AND.ISUB.LE.27).OR.
     $     (ISUB.GE.29.AND.ISUB.LE.32).OR.
     $     (ISUB.GE.58.AND.ISUB.LE.67).OR.
     $     (ISUB.GE.69.AND.ISUB.LE.79).OR.
     $     (ISUB.GE.85.AND.ISUB.LE.89).OR.
     $     (ISUB.GE.101.AND.ISUB.LE.144).OR.
     $     (ISUB.GE.151.AND.ISUB.LE.161).OR.
     $     (ISUB.GE.165.AND.ISUB.LE.187)) ISDY=1
      QFISH=.TRUE.
      IF (QFISH.AND.(ISUB.GE.34.AND.ISUB.LE.37).OR.
     $     (ISUB.GE.39.AND.ISUB.LE.42).OR.
     $     (ISUB.GE.44.AND.ISUB.LE.47).OR.
     $     (ISUB.GE.49.AND.ISUB.LE.52).OR.ISUB.EQ.80) ISDY=-1
      IF ((ISUB.EQ.11.AND.MSTI(15)*MSTI(16).LT.0.AND.QFISH).OR.
     $     (ISUB.GE.18.AND.ISUB.LE.27).OR.
     $     (ISUB.GE.58.AND.ISUB.LE.67).OR.
     $     (ISUB.GE.69.AND.ISUB.LE.79).OR.ISUB.EQ.85.OR.ISUB.EQ.110.OR.
     $     ISUB.EQ.114.OR.(ISUB.GE.116.AND.ISUB.LE.119).OR.
     $     (ISUB.GE.165.AND.ISUB.LE.172).OR.
     $     ISUB.EQ.176.OR.ISUB.EQ.177) ISDY=2
      IF ((ISUB.GE.71.AND.ISUB.LE.73).OR.ISUB.EQ.76.OR.ISUB.EQ.77)
     $     ISDY=3

C...In som cases we know which particle is D-Y boson
      ITDY=0
      IF (ISUB.EQ.14.OR.ISUB.EQ.29.OR.ISUB.EQ.34.OR.ISUB.EQ.39.OR.
     $     ISUB.EQ.44.OR.ISUB.EQ.49.OR.ISUB.EQ.115) ITDY=22
      IF (ISUB.EQ.1.OR.ISUB.EQ.7.OR.ISUB.EQ.15.OR.ISUB.EQ.30.OR.
     $     ISUB.EQ.33.OR.ISUB.EQ.40.OR.ISUB.EQ.45.OR.ISUB.EQ.50.OR.
     $     ISUB.EQ.101) ITDY=23
      IF (ISUB.EQ.2.OR.ISUB.EQ.4.OR.ISUB.EQ.6.OR.ISUB.EQ.16.OR.
     $     ISUB.EQ.31.OR.ISUB.EQ.36.OR.ISUB.EQ.41.OR.ISUB.EQ.46.OR.
     $     ISUB.EQ.51) ITDY=24
      IF (ISUB.EQ.3.OR.ISUB.EQ.5.OR.ISUB.EQ.8.OR.ISUB.EQ.17.OR.
     $     ISUB.EQ.32.OR.ISUB.EQ.37.OR.ISUB.EQ.42.OR.ISUB.EQ.47.OR.
     $     ISUB.EQ.52.OR.ISUB.EQ.102.OR.ISUB.EQ.103.OR.ISUB.EQ.111.OR.
     $     ISUB.EQ.112.OR.ISUB.EQ.113.OR.ISUB.EQ.121.OR.ISUB.EQ.122.OR.
     $     ISUB.EQ.123.OR.ISUB.EQ.124) ITDY=25
      IF (ISUB.EQ.141) ITDY=32
      IF (ISUB.EQ.142) ITDY=34
      IF (ISUB.EQ.151.OR.ISUB.EQ.152.OR.ISUB.EQ.153.OR.ISUB.EQ.173.OR.
     $     ISUB.EQ.174.OR.ISUB.EQ.181.OR.ISUB.EQ.182) ITDY=35
      IF (ISUB.EQ.156.OR.ISUB.EQ.157.OR.ISUB.EQ.158.OR.ISUB.EQ.178.OR.
     $     ISUB.EQ.179.OR.ISUB.EQ.186.OR.ISUB.EQ.187) ITDY=36
      IF (ISUB.EQ.143.OR.ISUB.EQ.161) ITDY=37
      IF (ISUB.EQ.144) ITDY=40
      IF (ISUB.EQ.80) ITDY=211
      IF (ISUB.EQ.86) ITDY=443
      IF (ISUB.EQ.87) ITDY=10441
      IF (ISUB.EQ.88) ITDY=20443
      IF (ISUB.EQ.89) ITDY=445

      IF (ISDY.EQ.0) RETURN

      IF (ISDY.EQ.2.OR.ISDY.EQ.3) THEN
C...This is not quite Drell-Yan but the outgoing particles from the
C...hard sub-process constitutes a colour singlet, so combined they
C...should get recoils from initial state and we treat the combined
C...system like a Drell-Yan produced particle
        IF (ISDY.EQ.3) THEN
          I1=9
          I2=10
        ELSE
          I1=7
          I2=8
        ENDIF
        N=N+1
        K(N,1)=11
        K(N,2)=80
        K(N,3)=I1
        K(N,4)=0
        K(N,5)=0
        P(N,1)=P(I1,1)+P(I2,1)
        P(N,2)=P(I1,2)+P(I2,2)
        P(N,3)=P(I1,3)+P(I2,3)
        P(N,4)=P(I1,4)+P(I2,4)
        P(N,5)=SQRT(MAX(P(N,4)**2-P(N,3)**2-P(N,2)**2-P(N,1)**2,0.0))
        K(I1,1)=K(I1,1)+100
        K(I2,1)=K(I2,1)+100
        IDY=N
      ELSE
C...This is Drell-Yan, so find boson
        IF (ITDY.GT.0) THEN
          IDY=IFIRST-1
 900      IDY=IDY+1
          IF (IDY.LE.N.AND.ABS(K(IDY,2)).NE.ITDY) GOTO 900
          IF (IDY.GT.N) CALL ARERRM('ARPYTH',27,0)
        ELSE
          IDY=IFIRST
        ENDIF
      ENDIF

      IF (K(IDY,1).LT.10) THEN
        K(IDY,1)=K(IDY,1)+100
      ELSE
        K(IDY,1)=K(IDY,1)+40
      ENDIF
      DYE=P(IDY,4)
      DYBZ=SQRT(P(IDY,1)**2+P(IDY,2)**2+P(IDY,3)**2)/DYE
      PHIDY=ULANGL(P(IDY,1),P(IDY,2))
      THEDY=ULANGL(P(IDY,3),SQRT(P(IDY,1)**2+P(IDY,2)**2))

C...Find all D-Y Boson decay products, deactivate them and boost to c.m.s
      DO 200 I=K(IDY,3)+1,N
        IF (I.EQ.IDY) GOTO 200
        KPAR=0
        IF (K(I,3).GT.0) KPAR=K(K(I,3),1)
        IF (K(I,3).EQ.IDY.OR.K(I,3).EQ.K(IDY,3).OR.
     $       KPAR.GE.100) THEN
          CALL LUDBRB(I,I,0.0,-PHIDY,0.0D0,0.0D0,0.0D0)
          CALL LUDBRB(I,I,-THEDY,0.0,0.0D0,0.0D0,0.0D0)
          CALL LUDBRB(I,I,0.0,0.0,0.0D0,0.0D0,-DYBZ)
          K(I,1)=K(I,1)+100
        ENDIF
 200  CONTINUE

      CALL ARCOPA(IDY,MAXPAR-2,2)
C...Perform cascade on remnant system (and transfer recoils to D-Y Boson
      QQ(MAXPAR-2)=.TRUE.
      IDI(MAXPAR-2)=IDY

      RETURN

C**** END OF ARPRDY ****************************************************
      END
C***********************************************************************
C $Id: arpyth.f,v 3.16 1995/08/15 09:08:54 lonnblad Exp $
CDECK  ID>, ARFIDY.
      SUBROUTINE ARFIDY(NSAVE)

C...ARiadne subroutine FInish up Drell-Yan event

C...Finish Drell-Yan event performing cascade on D-Y decay products


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON /PYPARS/ MSTP(200),PARP(200),MSTI(200),PARI(200)
      SAVE /PYPARS/


      IF (.NOT.QQ(MAXPAR-2)) RETURN
      QQ(MAXPAR-2)=.FALSE.
      IFIRST=MSTI(4)+1

C...Activate D-Y Boson decay products, boost to new Boson momenta and
C...Perform possible cascade.
      IDY=IDI(MAXPAR-2)
      DYE=P(IDY,4)
      DYBZ=SQRT(P(IDY,1)**2+P(IDY,2)**2+P(IDY,3)**2)/DYE
      PHIDY=ULANGL(P(IDY,1),P(IDY,2))
      THEDY=ULANGL(P(IDY,3),SQRT(P(IDY,1)**2+P(IDY,2)**2))
      DO 210 I=K(IDY,3),NSAVE
        IF (I.EQ.IDY) THEN
          IF (K(I,1).GE.100) K(I,1)=K(I,1)-100
        ELSEIF (K(I,1).GE.100) THEN
          K(I,1)=K(I,1)-100
          CALL LUDBRB(I,I,0.0,0.0,0.0D0,0.0D0,DYBZ)
          CALL LUDBRB(I,I,THEDY,PHIDY,0.0D0,0.0D0,0.0D0)
        ENDIF
 210  CONTINUE
      CALL ARPARS(IFIRST,NSAVE)

      RETURN

C**** END OF ARFIDY ****************************************************
      END
C***********************************************************************
C $Id: arpyth.f,v 3.16 1995/08/15 09:08:54 lonnblad Exp $
CDECK  ID>, ARPYWW.
      SUBROUTINE ARPYWW

C...ARiadne subroutine PYthia WW event

C...Handle a e+e- -> W+W- or e+e- -> Z0Z0 event from PYTHIA

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON /PYPARS/ MSTP(200),PARP(200),MSTI(200),PARI(200)
      SAVE /PYPARS/

      DIMENSION IR(1)


      IR(1)=0
      CALL ARSCAN(MSTI(4)+1,N,1,IR)
      MHAR(108)=1
      CALL ARCASC
      IF (PARA(28).GT.0.0.AND.MHAR(101).EQ.2.AND.MSTA(35).EQ.2) THEN
        DO 110 ID=1,IDIPS
          IF (QEM(ID)) GOTO 110
          QDONE(ID)=.FALSE.
          ICOLI(ID)=MOD(ICOLI(ID),1000)
 110    CONTINUE
        IF (MHAR(111).GT.0) THEN
          PARA(28)=-PARA(28)
          PT2LST=PARA(40)
          CALL ARCONT
          PARA(28)=-PARA(28)
        ENDIF
      ENDIF
      MHAR(108)=0

      RETURN

C**** END OF ARPYWW ****************************************************
      END
C***********************************************************************
C $Id: arptqq.f,v 3.9 1994/09/20 12:38:38 lonnblad Exp $
CDECK  ID>, ARPTQQ.
      SUBROUTINE ARPTQQ(KF,KQ,PM,PT2MAX,PT2MIN,X,XQ2,XY,XP,ZQ,YQ,PHI)

C...ARiadne get PT2 of initial state g->QQ

C...Get kinematical variables describing an initial-state g->qqbar
C...splitting.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/


      XP=X
      ZQ=1.0
      IF (MHAR(104).GT.1.AND.XY.GE.1.0) THEN
        CALL ARMTQQ(KF,KQ,PM,PT2MAX,PT2MIN,X,XQ2,YQ,PHI)
        RETURN
      ENDIF

      PHI=0
      T2=(1.0-X)*XQ2
      IF (MHAR(102).EQ.2) T2=XQ2
      PT2MAX=MIN(PT2MAX,0.25*T2/X)
      IF (MHAR(102).EQ.2) PT2MAX=MIN(PT2MAX,0.25*(1.0-X)*T2/X)
      IF (MHAR(102).LT.0) GOTO 900
      RMQ=ULMASS(KQ)
      PT2CUT=PT2MIN
      IF (MHAR(102).GE.1) PT2CUT=MAX(PT2MIN,PARA(3)**2+RMQ**2)
      IF (PT2MAX.LE.PT2CUT) GOTO 900

      XNUMFL=MAX(ARNOFL(SQRT(T2/X),MAX(5,MSTA(15))),3.0)
      ALPHA0=12.0*PARU(1)/(33.0-2.0*XNUMFL)
      SQ2MIN=PHAR(103)*PT2CUT/PARA(21)
      IF (MSTA(19).EQ.2) SQ2MIN=MAX(SQ2MIN,XQ2)
      SQ2MIN=MAX(SQ2MIN,4.0*RMQ**2)
      STRA0=ARSTRA(KF,KQ,X,1.0,SQ2MIN)
      STRAQ=ARSTRA(KF,KQ,X,1.0,XQ2)
      IF (MHAR(113).EQ.-2.AND.MHAR(102).EQ.2) THEN
        XPMAX=T2*0.25/(PT2CUT+T2*0.25)
        STRAQ=ARSTRA(KF,KQ,X,XPMAX,XQ2)
      ENDIF
      IF (STRA0.LE.0.0) STRA0=STRAQ
      IF (MHAR(113).NE.1) STRA0=STRAQ
      IF (MSTA(19).NE.2) STRA0=MAX(STRAQ,STRA0)

      IF (MHAR(109).GT.0) THEN
        SQ2MIN=PT2CUT/
     $       ((0.5+SQRT(MAX(0.25-PT2CUT*X/(XQ2*(1.0-X)),0.0)))*(1.0-X))
        SQ2MAX=0.5*(XQ2+PT2MAX)
        STRA0=STRAQ
        STRA0=MAX(STRA0,ARSTRA(KF,KQ,X,1.0,SQ2MIN))
        STRA0=MAX(STRA0,ARSTRA(KF,KQ,X,1.0,SQ2MAX))
      ENDIF

      CY=(1.0-XY)/(1.0+(1.0-XY)**2)
      CQ=1.0+CY
      IF (MHAR(102).EQ.2) CQ=0.125+0.25*CY
      C=PHAR(104)*0.25*ALPHA0*STRA0*CQ/PARU(1)
      THEMAX=PT2MAX
      YINT=4.0*LOG(SQRT(THEMAX/PT2CUT)+SQRT(THEMAX/PT2CUT-1.0))
      CN=1.0/(YINT*C)
      IF (MHAR(110).GT.0) CN=1.0/(YINT*C*ALPHA0)
      XLAM2=(PARA(1)**2)/PHAR(103)

 100  IF (PT2MAX.LE.PT2CUT) GOTO 900
      ARG=RLU(IDUM)
      IF (LOG(ARG)*CN.LT.
     $     LOG(LOG(PT2CUT/XLAM2)/LOG(PT2MAX/XLAM2))) GOTO 900
      PT2MAX=XLAM2*(PT2MAX/XLAM2)**(ARG**CN)

      YMAX=2.0*LOG(SQRT(THEMAX/PT2MAX)+SQRT(THEMAX/PT2MAX-1.0))
      Y=(RLU(IDUM)*2.0-1.0)*YMAX

      ZQ=1.0/(1.0+EXP(-Y))
      IF (MHAR(112).LT.0.OR.MHAR(112).EQ.2) ZQ=MIN(ZQ,1.0-ZQ)
      IF (MHAR(102).EQ.2) THEN
        XP=T2*ZQ*(1.0-ZQ)/(PT2MAX+T2*ZQ*(1.0-ZQ))
      ELSE
        XP=ZQ*(1.0-ZQ)*T2/PT2MAX
      ENDIF
      IF (XP.LE.X.OR.XP.GE.1.0) GOTO 100

      SQ2=PHAR(103)*PT2MAX/PARA(21)

      W=2.0*YMAX/YINT
      IF (MSTA(19).EQ.2) THEN
        W=W*MIN(1.0,LOG(PT2MAX/XLAM2)/LOG(PARA(21)*XQ2/XLAM2))
        SQ2=MAX(SQ2,XQ2)
      ENDIF
      SQ2=MAX(SQ2,SQ2MIN)
      IF (MHAR(109).GT.0) SQ2=PT2MAX/
     $     ((0.5+SQRT(MAX(0.25-PT2MAX*XP/(XQ2*(1.0-XP)),0.0)))*
     $     (1.0-XP))
      IF (MHAR(113).EQ.1) THEN
        STRA=ARSTRA(KF,KQ,X,XP,SQ2)
        W=W*STRA/STRA0
      ELSE
        BETA=PARA(25)
        IF (MSTA(25).EQ.0) BETA=0.0
        PTIN=SQRT(PHAR(103)*PT2MAX)
        IF (MHAR(113).EQ.2) PTIN=2.0*PTIN
        XMU=PARA(11)
        ALPHA=PARA(10)
        IF (PARA(10).GT.0.0) THEN
          XMU=PARA(11)
          ALPHA=PARA(10)
        ELSEIF (PTIN.GE.ABS(PARA(10))) THEN
          XMU=SQRT(ABS(PARA(10)*PARA(11)))
          ALPHA=2.0
        ELSE
          XMU=PARA(11)
          ALPHA=1.0
        ENDIF
        IF (X/XP.GT.((1.0/RLU(IDUM)-1.0)**BETA)*(XMU/PTIN)**ALPHA)
     $       GOTO 100
      ENDIF
      IF (MHAR(102).EQ.2) THEN
        W=W*(XP*(1.0-XP)*(XP**2+(1.0-XP)**2)*(ZQ**2+(1.0-ZQ)**2)+
     $       16.0*((XP*(1.0-XP))**2)*ZQ*(1.0-ZQ)*CY)/CQ
      ELSE
        W=W*((XP**2+(1.0-XP)**2)*(ZQ**2+(1.0-ZQ)**2)+
     $       16.0*XP*(1.0-XP)*ZQ*(1.0-ZQ)*CY)/CQ
      ENDIF

      IF (W.GT.1.0) THEN
        CALL ARERRM('ARPTQQ',22,0)
        RETURN
      ENDIF

      IF (W.LT.RLU(IDUM)) GOTO 100

      IF (MHAR(113).EQ.-1) THEN
        IF (PT2MAX.LT.ZQ*(1.0-X)*XQ2) GOTO 100
        IF (PT2MAX.LT.(1.0-ZQ)*(1.0-X)*XQ2) GOTO 100
      ENDIF

      YQ=0.5*LOG(ZQ*(1.0-X)/((1.0-ZQ)*(X/XP-X)))

      XA=0.125*(1.0+(1.0-XY)**2)*(XP**2+(1.0-XP)**2)*
     $     (ZQ**2+(1.0-ZQ)**2)/(ZQ*(1.0-ZQ))+2.0*(1.0-XY)*XP*(1.0-XP)
      XB=0.5*XY*SQRT((1.0-XY)*XP*(1.0-XP)/(ZQ*(1.0-ZQ)))*(1.0-2.0/XY)*
     $     (1.0-2.0*ZQ)*(1.0-2.0*XP)
      XC=(1.0-XY)*XP*(1.0-XP)

      ABC=ABS(XA)+ABS(XB)+ABS(XC)
 200  PHI=PARU(2)*RLU(IDUM)
      IF (XA+XB*COS(PHI)+XC*COS(2.0*PHI).LT.RLU(IDUM)*ABC) GOTO 200

      RETURN

 900  PT2MAX=0.0
      RETURN

C**** END OF ARPTQQ ****************************************************
      END
C***********************************************************************
C $Id: arinqq.f,v 3.6 1994/09/20 12:38:33 lonnblad Exp $
CDECK  ID>, ARINQQ.
      SUBROUTINE ARINQQ(IT,KQ,IRP,PT2,YQ,ZQ,PHI,QFAIL)

C...ARiadne perform INitial state g->QQ

C...Try to perform an initial-state g->qqbar splitting.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARSTRF/ KFSAVE(2),XSAVE(2),XQ2SAV(2),XPQSAV(2,-6:6)
      SAVE /ARSTRF/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/

      DIMENSION ISTQ(MAXPAR),IREM(MAXPAR)


      IF (MHAR(104).GT.0) THEN
        CALL ARNIQQ(IT,KQ,IRP,PT2,YQ,PHI,QFAIL)
        RETURN
      ENDIF

      QFAIL=.TRUE.
      RMQ2=ULMASS(KQ)
      IF (MHAR(102).GE.1) THEN
        DMT2Q=PT2
        DPT2Q=DMT2Q-RMQ2**2
      ELSE
        DPT2Q=PT2
        DMT2Q=DPT2Q+RMQ2**2
      ENDIF
      
C...First divide up all partons into remnant and struck system
      NREM=2
      IR=INQ(IRP)
      IREM(1)=IRP
      IREM(2)=IR
      NSTQ=1
      IQ=IDI(IRP)
      ISTQ(1)=IQ
C...      DO 100 I=1,IPART
C...        IF (I.EQ.IRP.OR.I.EQ.IR.OR.I.EQ.IQ) GOTO 100
C...        IF (INO(I).LT.0.OR.QEX(I)) THEN
C...          NREM=NREM+1
C...          IREM(NREM)=I
C...        ELSE
C...          NSTQ=NSTQ+1
C...          ISTQ(NSTQ)=I
C...        ENDIF
C... 100  CONTINUE
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NREM,IREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NSTQ,ISTQ)

C...Check that emission is possible
      SR=DMR**2
      S=MAX(0.0D0,(DER+DEQ)**2-(DZR+DZQ)**2-
     $     (DYR+DYQ)**2-(DXR+DXQ)**2)
      SQ1=DMQ**2
      SQ=(RMQ2**2)/ZQ+SQ1/(1.0-ZQ)+DPT2Q/(ZQ*(1.0-ZQ))
      IF (SQRT(S).LT.SQRT(SQ)+SQRT(SR)) RETURN

C...Boost to CMS with struck system on Z-axis
      CALL ARSUME(0,DBTX,DBTY,DBTZ,DBTE,DMTM,NREM,IREM)
      CALL ARSUME(1,DBTX,DBTY,DBTZ,DBTE,DMTM,NSTQ,ISTQ)
      DBTZ=DBTZ/DBTE
      DBTY=DBTY/DBTE
      DBTX=DBTX/DBTE
      CALL ARROBO(0.0,0.0,-DBTX,-DBTY,-DBTZ,NREM,IREM)
      CALL ARROBO(0.0,0.0,-DBTX,-DBTY,-DBTZ,NSTQ,ISTQ)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NSTQ,ISTQ)
      PHIT=ULANGL(SNGL(DXQ),SNGL(DYQ))
      THET=ULANGL(SNGL(DZQ),SNGL(SQRT(DXQ**2+DYQ**2)))
      CALL ARROBO(0.0,-PHIT,0.0D0,0.0D0,0.0D0,NREM,IREM)
      CALL ARROBO(0.0,-PHIT,0.0D0,0.0D0,0.0D0,NSTQ,ISTQ)
      CALL ARROBO(-THET,0.0,0.0D0,0.0D0,0.0D0,NREM,IREM)
      CALL ARROBO(-THET,0.0,0.0D0,0.0D0,0.0D0,NSTQ,ISTQ)

      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NSTQ,ISTQ)
C...Rotate struck system to correct PT
      DPP0=DZQ+DEQ
      DPT=SQRT(DPT2Q)
      CALL ARDBRB(-ASIN(DPT/DZQ),DBLE(PHI-PHIT),
     $     0.0D0,0.0D0,0.0D0,NSTQ,ISTQ)

C...Boost to correct momentum
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NSTQ,ISTQ)
      DPP02=(DZQ+DEQ)**2
      DPP2=((1.0D0-DBLE(ZQ))*DPP0)**2
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $     (DPP2-DPP02)/(DPP2+DPP02),NSTQ,ISTQ)

C...Insert new quark
      IO=IO+1
      IPART=IPART+1
      IFL(IPART)=-KQ
      IF (MSTA(30).LT.2.OR.MSTA(30).EQ.3) THEN
        QEX(IPART)=.FALSE.
        XPMU(IPART)=0.0
        XPA(IPART)=0.0
        QEX(IQ)=.FALSE.
        XPMU(IQ)=0.0
        XPA(IQ)=0.0
      ELSE
        QEX(IPART)=.TRUE.
        IF (PARA(14).GE.0) THEN
          XPMU(IPART)=SQRT(XQ2SAV(IT))*PARA(14)
        ELSE
          XPMU(IPART)=ABS(PARA(14))
        ENDIF
        XPA(IPART)=PARA(15)
      ENDIF
      QEX(IPART)=.FALSE.
      QQ(IPART)=.TRUE.
      INO(IPART)=IO
      INQ(IPART)=0
      DPP=ZQ*DPP0
      BP(IPART,5)=RMQ2
      BP(IPART,4)=0.5*(DPP+DMT2Q/DPP)
      BP(IPART,3)=0.5*(DPP-DMT2Q/DPP)
      BP(IPART,2)=-DYQ
      BP(IPART,1)=-DXQ
      NSTQ=NSTQ+1
      ISTQ(NSTQ)=IPART

C...Insert new remnant
      IPART=IPART+1
      IFL(IPART)=INO(IRP)
      QEX(IPART)=QEX(IRP)
      QQ(IPART)=.TRUE.
      INO(IPART)=0
      INQ(IPART)=0
      XPMU(IPART)=XPMU(IRP)
      XPA(IPART)=XPA(IRP)
      BP(IPART,1)=BP(IRP,1)
      BP(IPART,2)=BP(IRP,2)
      BP(IPART,3)=BP(IRP,3)
      BP(IPART,4)=BP(IRP,4)
      BP(IPART,5)=BP(IRP,5)
      IREM(1)=IPART
      QQ(IRP)=.FALSE.

C...Sum up energy again
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NSTQ,ISTQ)
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NREM,IREM)

C...Boost around to fix up energy
      IF (SQRT(S).LT.DMQ+DMR) THEN
        CALL ARERRM('ARINQQ',25,0)
        GOTO 900
      ENDIF
      DPQ2=ARPCMS(S,SNGL(DMQ),SNGL(DMR))**2
      DPQ02=(DEQ+DZQ)**2
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $     (DPQ2-DPQ02)/(DPQ2+DPQ02),NSTQ,ISTQ)
      DMR2=ARPCMS(S,SNGL(DMR),SNGL(DMQ))**2
      DMR02=(DER-DZR)**2
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $     (DMR02-DMR2)/(DMR02+DMR2),NREM,IREM)

C...Boost and rotate back to original system
      CALL ARROBO(THET,PHIT,DBTX,DBTY,DBTZ,NREM,IREM)
      CALL ARROBO(THET,PHIT,DBTX,DBTY,DBTZ,NSTQ,ISTQ)

C...Finally fix mass of second remnant and connect new dipole
      IQ2=IPART-1
      IR=IPART
      DE=BP(IQ2,4)+BP(IR,4)
      DBEX=(BP(IQ2,1)+BP(IR,1))/DE
      DBEY=(BP(IQ2,2)+BP(IR,2))/DE
      DBEZ=(BP(IQ2,3)+BP(IR,3))/DE
      CALL AROBO2(0.0,0.0,-DBEX,-DBEY,-DBEZ,IQ2,IR)
      PX=BP(IQ2,1)
      PY=BP(IQ2,2)
      PZ=BP(IQ2,3)
      PHIT=ULANGL(PX,PY)
      THET=ULANGL(PZ,SQRT(PX**2+PY**2))
      CALL AROBO2(0.0,-PHIT,0.0D0,0.0D0,0.0D0,IQ2,IR)
      CALL AROBO2(-THET,0.0,0.0D0,0.0D0,0.0D0,IQ2,IR)
      RMR=ULMASS(IFL(IR))
      RMQ=BP(IQ2,5)
      BZ=ARZCMS(ARMAS2(IQ2,IR),RMQ,RMR)
      IF (BZ.LT.0.0) THEN
        CALL ARERRM('ARINQQ',10,0)
      ELSE
        BP(IQ2,3)=BZ
        BP(IQ2,4)=SQRT(BZ**2+BP(IQ2,5)**2)
        BP(IR,5)=RMR
        BP(IR,4)=SQRT(BZ**2+RMR**2)
        BP(IR,3)=-BZ
      ENDIF

      CALL AROBO2(THET,PHIT,DBEX,DBEY,DBEZ,IQ2,IR)

      IDIPS=IDIPS+1
      ISTRS=ISTRS+1
      CALL ARCRDI(IDIPS,IQ2,IR,ISTRS,.FALSE.)
      IDI(IQ2)=0
      IDO(IR)=0
      IPF(ISTRS)=IQ2
      IPL(ISTRS)=IR
      IFLOW(ISTRS)=SIGN(1,-KQ)

      QFAIL=.FALSE.

 900  DO 300 ID=1,IDIPS
        QDONE(ID)=.FALSE.
 300  CONTINUE

      RETURN

C**** END OF ARINQQ ****************************************************
      END
C***********************************************************************
C $Id: arsume.f,v 3.2 1994/05/11 07:10:55 lonnblad Exp $
CDECK  ID>, ARSUME.
      SUBROUTINE ARSUME(NULL,BSX,BSY,BSZ,BSE,BSM,NI,I)

C...ARiadne subroutine SUM Energy and momentum

C...Sum energy and mometum of NI partons in /ARPART/


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/

      DIMENSION I(NI)


      IF (NULL.EQ.0) THEN
        BSX=0.0
        BSY=0.0
        BSZ=0.0
        BSE=0.0
      ENDIF

      DO 100 IJ=1,NI
        II=I(IJ)
        BSX=BSX+BP(II,1)
        BSY=BSY+BP(II,2)
        BSZ=BSZ+BP(II,3)
        BSE=BSE+BP(II,4)
 100  CONTINUE

      B0=0.0
      BSM=SQRT(MAX(B0,BSE**2-BSZ**2-BSY**2-BSX**2))

      RETURN

C**** END OF ARSUME ****************************************************
      END
C***********************************************************************
C $Id: arzcms.f,v 3.3 1995/02/22 12:44:10 lonnblad Exp $
CDECK  ID>, ARZCMS.
      REAL FUNCTION ARZCMS(S,SM1,SM2)

C...ARiadne function get Z component in CMS

C...Returns the z component of a particle momentum when placed in the
C...cms system of itself and an other particle given the two particle
C...masses SM1 and SM2 and the total energy squared S

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      ARZCMS=-1
      AA=(S-(SM1+SM2)**2)
      IF (AA.LT.0.0) RETURN
      ARZCMS=0.5*SQRT(AA*(S-(SM1-SM2)**2)/S)

      RETURN

C**** END OF ARZCMS ****************************************************
      END
C***********************************************************************
C $Id: arpcms.f,v 3.3 1995/02/22 12:44:03 lonnblad Exp $
CDECK  ID>, ARPCMS.
      REAL FUNCTION ARPCMS(S,SM1,SM2)

C...ARiadne function get Positive ligth-cone component in CMS

C...Returns the positive light-cone  component of a particle momentum
C...when placed in the cms system of itself and an other particle given
C...the two particle masses SM1 and SM2 and the total energy squared S

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      ARPCMS=-1
      A1=0.25*(S-(SM1+SM2)**2)
      IF (A1.LT.0.0) RETURN
      A2=(S-(SM1-SM2)**2)/S
      ARPCMS=SQRT(A1*A2)+SQRT(A1*A2+SM1**2)

      RETURN

C**** END OF ARPCMS ****************************************************
      END
C***********************************************************************
CDECK  ID>, ARSTRA.
      REAL FUNCTION ARSTRA(KF,KQ,X,XP,XQ2)

C...ARiadne function Structure Function RAtio

C...Return ratio of structure functions for given flavour, x, xp and Q^2

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/

      REAL XPQ(-6:6),XPYST(-25:25)


      IF (MSTA(1).EQ.3) THEN
        CALL LNSTRF(X/ABS(XP),XQ2,XPQ)
        ARSTRA=XPQ(0)
        CALL LNSTRF(X,XQ2,XPQ)
        XFQ=MIN(XPQ(KQ),XPQ(-KQ))
        IF (XP.LT.0.0.AND.PARA(19).LT.0.0) THEN
          IF (XFQ.LT.-PARA(19)) THEN
            ARSTRA=-1.0
            RETURN
          ENDIF
        ENDIF
C        IF (MHAR(118).EQ.0) XFQ=MAX(XFQ,ABS(PARA(19)))
        IF (MHAR(118).EQ.0.AND.XFQ.LT.ABS(PARA(19))) THEN
          XFQ=ABS(PARA(19))
        ENDIF
        IF (XFQ.GT.0.0) THEN
          ARSTRA=ARSTRA/XFQ
        ELSE
          ARSTRA=-1.0
        ENDIF
      ELSE
        CALL PYSTFU(KF,X/ABS(XP),XQ2,XPYST)
        ARSTRA=XPYST(0)
        CALL PYSTFU(KF,X,XQ2,XPYST)
        XFQ=MIN(XPYST(KQ),XPYST(-KQ))
        IF (XP.LT.0.0.AND.PARA(19).LT.0.0) THEN
          IF (XFQ.LT.-PARA(19)) THEN
            ARSTRA=-1.0
            RETURN
          ENDIF
        ENDIF
C        IF (MHAR(118).EQ.0) XFQ=MAX(XFQ,ABS(PARA(19)))
        IF (MHAR(118).EQ.0.AND.XFQ.LT.ABS(PARA(19))) THEN
          XFQ=ABS(PARA(19))
        ENDIF
        IF (XFQ.GT.0.0) THEN
          ARSTRA=ARSTRA/XFQ
        ELSE
          ARSTRA=-1.0
        ENDIF
      ENDIF
      IF (MHAR(102).NE.2) ARSTRA=ARSTRA*XP

      RETURN

C**** END OF ARSTRA ****************************************************
      END
C***********************************************************************
C $Id: arscan.f,v 3.6 1995/08/13 17:29:22 lonnblad Exp $
CDECK  ID>, ARSCAN.
      SUBROUTINE ARSCAN(NSTART,NEND,NR,IR)

C...ARiadne subroutine SCAN the event record

C...Parse through the /LUJETS/ event record to find un-cascaded
C...strings and put them in the Ariadne event record

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/

      DIMENSION IR(NR)


      IDIR=0
      IPART=0
      IDIPS=0
      ISTRS=0
      PT2LST=PARA(40)
      QQ(MAXPAR-3)=.FALSE.
      QQ(MAXPAR-4)=.FALSE.
      IMF=0
      IML=0
      PHAR(131)=0.0
      PHAR(132)=0.0

C...Loop over entries in /LUJETS/ to be considered
      DO 100 I=NSTART,NEND

C...If IDIR=0 there is no current string so skip all entries which
C...are not the begining of a string (K(I,1)=2) otherwise copy
C...parton to dipole record
        IF (IDIR.EQ.0) THEN
          IF (K(I,1).NE.2) THEN
            K(I,4)=MAX(K(I,4),0)
            GOTO 100
          ENDIF
          CALL ARGTYP(I,ITYP)
          IF (MHAR(133).GE.1.AND.ITYP.EQ.2.AND.K(I,3).EQ.0) THEN
            K(I,4)=MAX(K(I,4),0)
            PHAR(131)=PHAR(131)+P(I,3)+P(I,4)
            PHAR(132)=PHAR(132)-P(I,3)+P(I,4)
            IF (K(I+1,1).EQ.1) THEN
              PHAR(131)=PHAR(131)+P(I+1,3)+P(I+1,4)
              PHAR(132)=PHAR(132)-P(I+1,3)+P(I+1,4)
            ENDIF
            GOTO 100
          ENDIF            
          IF (MHAR(133).GE.3.AND.K(I,3).EQ.0) THEN
            K(I,4)=MAX(K(I,4),0)
            PHAR(131)=PHAR(131)+P(I,3)+P(I,4)
            PHAR(132)=PHAR(132)-P(I,3)+P(I,4)
            IF (K(I+1,1).EQ.1) THEN
              PHAR(131)=PHAR(131)+P(I+1,3)+P(I+1,4)
              PHAR(132)=PHAR(132)-P(I+1,3)+P(I+1,4)
            ENDIF
            GOTO 100
          ENDIF            
          IF (ITYP.EQ.0) CALL ARERRM('ARPARS',1,I)
          IF (MSTA(29).EQ.1.AND.ITYP.EQ.2) THEN
            K(I,4)=MAX(K(I,4),0)
            GOTO 100
          ENDIF
          IF (IMF.EQ.0) IMF=I
          IDIR=ITYP
          IPART=IPART+1
          IPFST=IPART
          ISTRS=ISTRS+1
          CALL ARCOPA(I,IPART,ITYP)
          DO 200 J=1,NR
            IF (IR(J).EQ.I) IR(J)=-IPART
 200      CONTINUE
        ELSE

          DO 210 J=1,NR
            IF (IR(J).EQ.I) IR(J)=-IPART-1
 210      CONTINUE

C...If in a string, copy parton and create a dipole. Error if
C...colour singlets of triplets are found
          IF (K(I,1).EQ.2) THEN
            CALL ARGTYP(I,ITYP)
            IF (ABS(ITYP).EQ.1) CALL ARERRM('ARPARS',2,I)
            IF (ABS(ITYP).EQ.0) CALL ARERRM('ARPARS',1,I)
            IPART=IPART+1
            IDIPS=IDIPS+1
            CALL ARCOPA(I,IPART,ITYP)
            CALL ARCRDI(IDIPS,IPART-1,IPART,ISTRS,.FALSE.)
            CALL ARCOLI(IDIPS,-ISTRS)

C...If the end of a string check colour flow and consistency
          ELSEIF (K(I,1).EQ.1) THEN
            CALL ARGTYP(I,ITYP)
            IF (ITYP.EQ.0) CALL ARERRM('ARPARS',1,I)
            IML=I
            IPART=IPART+1
            IDIPS=IDIPS+1
            CALL ARCOPA(I,IPART,ITYP)
            CALL ARCRDI(IDIPS,IPART-1,IPART,ISTRS,.FALSE.)
            CALL ARCOLI(IDIPS,-ISTRS)
C...........If purely gluonic string create extra dipole
            IF (ITYP.EQ.2) THEN
              IF (IDIR.NE.2) CALL ARERRM('ARPARS',4,I)
              IDIPS=IDIPS+1
              CALL ARCRDI(IDIPS,IPART,IPFST,ISTRS,.FALSE.)
              CALL ARCOLI(IDIPS,-ISTRS)
C...........If ordinary string create EM-dipole
            ELSE
              IF (ITYP.NE.-IDIR) CALL ARERRM('ARPARS',5,I)
              IF (MSTA(20).GT.0.AND.IDIPS.EQ.1.AND.
     $               (.NOT.QEX(IPFST)).AND.(.NOT.QEX(IPART))) THEN
                IDIPS=IDIPS+1
                CALL ARCRDI(IDIPS,IPART,IPFST,ISTRS,.TRUE.)
              ENDIF
            ENDIF

C...Initialize string variables in dipole record and perform cascade
            IF (MSTA(14).GE.1) PT2LST=MIN(PT2LST,ARMIPT(IPFST,IPART))
            IF (PARA(6).GT.0.0) PT2LST=MIN(PT2LST,PARA(6))
            IPF(ISTRS)=IPFST
            IPL(ISTRS)=IPART
            IFLOW(ISTRS)=IDIR
            CALL AREXMA(IPFST,IPART)
            IDIR=0
          ENDIF
        ENDIF
 100  CONTINUE

      DO 220 J=1,NR
        IR(J)=-IR(J)
 220  CONTINUE

      RETURN

C**** END OF ARPARS ****************************************************
      END
C***********************************************************************
C $Id: arremn.f,v 3.15 1995/08/15 09:08:56 lonnblad Exp $
CDECK  ID>, ARREMN.
      SUBROUTINE ARREMN(IT,IQR,IDR,IRP,IDIR)

C...ARiadne subroutine FIx REmnants

C...Redistribute remnants and prepare for BGF-like emission


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARSTRF/ KFSAVE(2),XSAVE(2),XQ2SAV(2),XPQSAV(2,-6:6)
      SAVE /ARSTRF/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      COMMON /PYPARS/ MSTP(200),PARP(200),MSTI(200),PARI(200)
      SAVE /PYPARS/
      COMMON /PYINT3/ XSFX(2,-40:40),ISIG(1000,3),SIGH(1000)
      SAVE /PYINT3/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/

      DIMENSION XPQ(-6:6),XPYST(-25:25)


      IF (MHAR(133).GE.5.AND.MHAR(133).LT.9)
     $     CALL ARINCR(IDIR,IQR,IDR,IRP)

      QQ(MAXPAR-5+IT)=.FALSE.
      KFT=K(IT,2)
      FACMU=1.0

C...Get some information from PYTHIA/LEPTO
      IF (MSTA(1).EQ.2) THEN
        KFSTR=K(2+IT,2)
        PARL(4)=0.75
        IF (XQ2.LT.0) THEN
          XSAVE(IT)=PARI(30+IT)
          IF (XSAVE(IT).LE.0.0) THEN
            BRZ=0.0
            BRE=0.0
            IF (IQR.GT.0) THEN
              BRZ=BRZ+BP(IQR,3)
              BRE=BRE+BP(IQR,4)
            ENDIF
            IF (IDR.GT.0) THEN
              BRZ=BRZ+BP(IDR,3)
              BRE=BRE+BP(IDR,4)
            ENDIF
            IF (IRP.GT.0) THEN
              BRZ=BRZ+P(IRP,3)
              BRE=BRE+P(IRP,4)
            ENDIF
            XSAVE(IT)=1.0D0-(BRE+IDIR*BRZ)/(P(IT,4)+IDIR*P(IT,3))
          ENDIF
          XQ2SAV(IT)=PARI(24)
        ELSE
          XSAVE(IT)=X
          XQ2SAV(IT)=XQ2
        ENDIF
        CALL PYSTFU(KFT,XSAVE(IT),XQ2SAV(IT),XPYST)
        DO 10 KF=-6,6
          XPQSAV(IT,KF)=XPYST(KF)
 10     CONTINUE
        XCMU=PARA(10+IT)
      ELSE
        XSAVE(IT)=X
        XQ2SAV(IT)=XQ2
        CALL LNSTRF(X,XQ2,XPQ)
        DO 20 KF=-6,6
          XPQSAV(IT,KF)=XPQ(KF)
 20     CONTINUE
        KFSTR=LST(25)
        XCMU=PARA(11)
      ENDIF
      IF (MSTA(30).NE.0) XCMU=XCMU/(1.0-XSAVE(IT))

C...Check if we hit a Pomeron or something like that
      MHAR(129)=0
      NTRY=0
 200  NTRY=NTRY+1
      IF (MSTA(34).NE.0.AND.XSAVE(IT).GT.0.0) THEN
        KFL=KFSTR
        IF (KFSTR.EQ.21) KFL=0
        IF (MSTA(34).GT.0) THEN
          CALL ARPOSF(KFT,KFL,XSAVE(IT),XQ2SAV(IT),
     $         XPOM,TPOM,KFTF,KFPR,XPQSAV(IT,KFL),XFPOM)
        ELSE
          CALL ARUPOM(KFT,KFL,XSAVE(IT),XQ2SAV(IT),
     $         XPOM,TPOM,KFTF,KFPR,XPQSAV(IT,KFL),XFPOM)
        ENDIF
        IF (XFPOM.GT.XPQSAV(IT,KFL)*PARA(18)) THEN
          IF (NTRY.LE.1) CALL ARERRM('ARREMN',29,0)
          XFPOM=XPQSAV(IT,KFL)*PARA(18)
        ENDIF

        IF (XFPOM.GT.RLU(IDUM)*XPQSAV(IT,KFL).AND.NTRY.LT.10000) THEN
          CALL ARPOKI(IT,IQR,IDR,IRP,IDIR,KFTF,KFPR,XPOM,TPOM,QFAIL)
          IF (QFAIL) GOTO 200
          IF (MSTA(1).EQ.3) MSTA(33)=0
          MHAR(129)=1
          RETURN
        ENDIF
      ENDIF

C...If this quark was in fact a gluon or if non-baryonic target -
C...just fix extendedness
      IF (MOD(KFT/1000,10).EQ.0.OR.KFSTR.EQ.21.OR.
     $     XSAVE(IT).LE.0.0) THEN
        IF (IDR.GT.0) THEN
          QEX(IDR)=.TRUE.
          XPA(IDR)=PARA(10)
          XPMU(IDR)=XCMU
          Z=1.0
          PTI=SQRT(BP(IDR,1)**2+BP(IDR,2)**2)
          IF (IQR.GT.0) Z=(BP(IDR,4)+IDIR*BP(IDR,3))/
     $         (BP(IDR,4)+IDIR*BP(IDR,3)+BP(IQR,4)+IDIR*BP(IQR,3))
          IF (IRP.GT.0) Z=(BP(IDR,4)+IDIR*BP(IDR,3))/
     $         (BP(IDR,4)+IDIR*BP(IDR,3)+P(IRP,4)+IDIR*P(IRP,3))
          IF (MHAR(115).NE.0.OR.ABS(MSTA(36)).EQ.1) THEN
            XPMU(IDR)=XCMU/Z
          ELSE
            XPA(IDR)=PARA(15)
            IF (MSTA(36).EQ.2) XPMU(IDR)=PARA(14)*PTI
            IF (MSTA(36).EQ.3) XPMU(IDR)=PARA(14)*PTI/(1.0-XSAVE(IT))
            IF (MSTA(36).EQ.4)
     $           XPMU(IDR)=PARA(14)*PTI/(Z*(1.0-XSAVE(IT)))
          ENDIF
        ENDIF
        IF (IQR.GT.0) THEN
          QEX(IQR)=.TRUE.
          XPA(IQR)=PARA(10)
          XPMU(IQR)=XCMU
          Z=1.0
          PTI=SQRT(BP(IQR,1)**2+BP(IQR,2)**2)
          IF (IDR.GT.0) Z=(BP(IQR,4)+IDIR*BP(IQR,3))/
     $         (BP(IDR,4)+IDIR*BP(IDR,3)+BP(IQR,4)+IDIR*BP(IQR,3))
          IF (IRP.GT.0) Z=(BP(IQR,4)+IDIR*BP(IQR,3))/
     $         (BP(IQR,4)+IDIR*BP(IQR,3)+P(IRP,4)+IDIR*P(IRP,3))
          IF (MHAR(115).NE.0.OR.ABS(MSTA(36)).EQ.1) THEN
            XPMU(IQR)=XCMU/Z
          ELSE
            XPA(IQR)=PARA(15)
            IF (MSTA(36).EQ.2) XPMU(IQR)=PARA(14)*PTI
            IF (MSTA(36).EQ.3) XPMU(IQR)=PARA(14)*PTI/(1.0-XSAVE(IT))
            IF (MSTA(36).EQ.4)
     $           XPMU(IQR)=PARA(14)*PTI/(Z*(1.0-XSAVE(IT)))
          ENDIF
        ENDIF

        RETURN
      ENDIF

C...Get valens quark flavours from baryon
      KFTA=ABS(KFT)
      KFQ1=SIGN(KFTA/1000,KFT)
      KFTA=MOD(KFTA,1000)
      KFQ2=SIGN(KFTA/100,KFT)
      KFTA=MOD(KFTA,100)
      KFQ3=SIGN(KFTA/10,KFT)
      QSEA=(KFSTR.NE.KFQ1.AND.KFSTR.NE.KFQ2.AND.KFSTR.NE.KFQ3)
      QSEA=(QSEA.OR.(XPQSAV(IT,KFSTR)-XPQSAV(IT,-KFSTR))/
     $     (XPQSAV(IT,KFSTR)+XPQSAV(IT,-KFSTR)).LT.RLU(0))

C...Sum up remnant momentum
      IR=0
      IF (IQR.GT.0) THEN
        IF (IDR.GT.0) CALL ARERRM('ARREMN',30,0)
        IR=IQR
      ELSE
        IF (IDR.LE.0) CALL ARERRM('ARREMN',30,0)
        IR=IDR
      ENDIF
      BRX=BP(IR,1)
      BRY=BP(IR,2)
      BRZ=BP(IR,3)
      BRE=BP(IR,4)
      IF (IRP.GT.0) THEN
        BRX=BRX+P(IRP,1)
        BRY=BRY+P(IRP,2)
        BRZ=BRZ+P(IRP,3)
        BRE=BRE+P(IRP,4)
      ENDIF
      IRPJ=IRP
      IF (IRPJ.GT.0) K(IRPJ,4)=0
      IRP=-IRP

C...Scale mu for remnant if multiple interactions
      IF (MHAR(133).EQ.4.AND.PHAR(131).GT.0.AND.IDIR.GT.0) THEN
        FACMU=(PHAR(131)+BRZ+BRE)/(BRZ+BRE)
      ELSEIF (MHAR(133).EQ.4.AND.PHAR(132).GT.0.AND.IDIR.LT.0) THEN
        FACMU=(PHAR(132)-BRZ+BRE)/(BRE-BRZ)
      ENDIF

C...Select particle to fix momentum transfer with
      IF (QQ(MAXPAR-2)) THEN
        ISQ=MAXPAR-2
      ELSEIF(IDI(IR).GT.0) THEN
        ISQ=IP1(IDI(IR))
      ELSE
        ISQ=IP3(IDO(IR))
      ENDIF

C...Rotate to Z-axis and calculate boost
      DBZ=(BRZ+BP(ISQ,3))/(BRE+BP(ISQ,4))
      S=(BRE+BP(ISQ,4))**2-(BRZ+BP(ISQ,3))**2-
     $     (BRY+BP(ISQ,2))**2-(BRX+BP(ISQ,1))**2
      
      IF (S.LT.0) CALL ARERRM('ARREMN',25,0)

      IF (QSEA) THEN
        IRP=MAXPAR-5+IT
        IF (IRPJ.GT.0) K(IRPJ,4)=-IRP
        QQ(IRP)=QSEA
C...Select diquark
        NTRY=0
 100    NTRY=NTRY+1
        IF (NTRY.GT.10000) THEN
          CALL ARERRM('ARREMN',22,0)
          RETURN
        ENDIF
        QIDENT=.FALSE.
        RND=RLU(0)
        IF (RND.LT.1.0/3.0) THEN
          KFQ=KFQ1
          KFR=MAX(ABS(KFQ2),ABS(KFQ3))*1000+
     $         MIN(ABS(KFQ2),ABS(KFQ3))*100+3
          QIDENT=(KFQ2.EQ.KFQ3)
        ELSEIF (RND.LT.2.0/3.0) THEN
          KFQ=KFQ2
          KFR=MAX(ABS(KFQ1),ABS(KFQ3))*1000+
     $         MIN(ABS(KFQ1),ABS(KFQ3))*100+3
          QIDENT=(KFQ1.EQ.KFQ3)
        ELSE
          KFQ=KFQ3
          KFR=MAX(ABS(KFQ1),ABS(KFQ2))*1000+
     $         MIN(ABS(KFQ1),ABS(KFQ2))*100+3
          QIDENT=(KFQ1.EQ.KFQ2)
        ENDIF

C...If non-identical  quarks, make diquark spinless with probability
C...PARL(4)
        IF ((.NOT.QIDENT).AND.RLU(IDUM).LT.PARL(4)) KFR=KFR-2
        IF (KFQ.LT.0) KFR=-KFR

C...Get flavour of particle
        IF (KFQ*KFSTR.LT.0) THEN
          CALL LUKFDI(KFR,-KFSTR,IDUM,KFP)
          KFREM1=KFQ
          KFREM2=KFR
        ELSE
          CALL LUKFDI(KFQ,-KFSTR,IDUM,KFP)
          KFREM1=KFR
          KFREM2=KFQ
        ENDIF

        IF (KFP.EQ.0) GOTO 100

C...  Assign z of hadron
        CALL LUPTDI(KFREM2,PTX,PTY)

        IF (MSTA(37).EQ.0) THEN
          IF (MSTA(1).EQ.2) THEN
            IF(MSTP(91).LE.0) THEN
              PTI=0.
            ELSEIF(MSTP(91).EQ.1) THEN
              PTI=PARP(91)*SQRT(-LOG(RLU(0)))
            ELSE
              RPT1=RLU(0)
              RPT2=RLU(0)
              PTI=-PARP(92)*LOG(RPT1*RPT2)
            ENDIF
            IF(PTI.GT.PARP(93)) GOTO 100
          ELSE
            PTI=PARL(3)*SQRT(-LOG(RLU(0)))
          ENDIF
        ELSEIF (MSTA(37).EQ.1) THEN
          PTI=PARA(27)*SQRT(-LOG(RLU(0)))
        ELSEIF (MSTA(37).EQ.2) THEN
          RPT1=RLU(0)
          RPT2=RLU(0)
          PTI=-PARA(27)*LOG(RPT1*RPT2)/SQRT(6.0)          
        ENDIF
        PHII=PARU(2)*RLU(0)
        PTIX=PTI*COS(PHII)
        PTIY=PTI*SIN(PHII)

        RMR1=ULMASS(KFREM1)
        RMP=ULMASS(KFP)
        RMTSQ=SQRT(BP(ISQ,5)**2+(BP(ISQ,1)+BRX-PTIX-PTX)**2+
     $       (BP(ISQ,2)+BRY-PTIY-PTY)**2)
        RMT2R1=RMR1**2+PTIX**2+PTIY**2
        RMT2P=RMP**2+PTX**2+PTY**2
        CALL LUZDIS(KFREM2,0,RMT2P,Z)
        RMR=SQRT(RMT2P/Z+RMT2R1/(1.0-Z))
        PT2SQ=(BRX+BP(ISQ,1))**2+(BRY+BP(ISQ,2))**2
        PZTOT=ARZCMS(S+PT2SQ,RMR,RMTSQ)
        IF (PZTOT.LE.0.0) GOTO 100
        PP=SQRT(PZTOT**2+RMR**2)+PZTOT

C...Set info for chopped off hadron
        IFL(IRP)=KFP
        INO(IRP)=KFREM2
        INQ(IRP)=IR
        IDI(IRP)=ISQ
        IDO(IRP)=KFSTR
        BP(IRP,1)=PTX
        BP(IRP,2)=PTY
        BP(IRP,3)=IDIR*0.5*(Z*PP-RMT2P/(Z*PP))
        BP(IRP,4)=0.5*(Z*PP+RMT2P/(Z*PP))
        BP(IRP,5)=RMP
        QEX(IRP)=.TRUE.
        XPA(IRP)=PARA(10)
        XPMU(IRP)=XCMU*FACMU
        PT2GG(IRP)=-1.0
        IF (ABS(MSTA(36)).EQ.1) XPMU(IRP)=FACMU*XCMU/Z
        IF (MSTA(36).EQ.2) XPMU(IRP)=FACMU*PARA(14)*PTI
        IF (MSTA(36).EQ.3) XPMU(IRP)=FACMU*PARA(14)*PTI/(1.0-XSAVE(IT))
        IF (MSTA(36).EQ.4) XPMU(IRP)=FACMU*PARA(14)*PTI/
     $       (Z*(1.0-XSAVE(IT)))
        IRDIR(IT)=IDIR

C...Set info for remnant
        IFL(IR)=KFREM1
        BP(IR,1)=PTIX
        BP(IR,2)=PTIY
        BP(IR,3)=IDIR*0.5*((1.0-Z)*PP-RMT2R1/((1.0-Z)*PP))
        BP(IR,4)=0.5*((1.0-Z)*PP+RMT2R1/((1.0-Z)*PP))
        BP(IR,5)=RMR1
        QEX(IR)=.TRUE.
        XPA(IR)=PARA(10)
        XPMU(IR)=FACMU*XCMU
        IF (ABS(MSTA(36)).EQ.1) XPMU(IR)=FACMU*XCMU/(1.0-Z)
        IF (MSTA(36).EQ.2) XPMU(IR)=FACMU*PARA(14)*PTI
        IF (MSTA(36).EQ.3) XPMU(IR)=FACMU*PARA(14)*PTI/(1.0-XSAVE(IT))
        IF (MSTA(36).EQ.4) XPMU(IR)=FACMU*PARA(14)*PTI/
     $       ((1.0-XSAVE(IT))*(1.0-Z))

C...Fix momentum for struck particle
        BP(ISQ,1)=BP(ISQ,1)+BRX-PTX-PTIX
        BP(ISQ,2)=BP(ISQ,2)+BRY-PTY-PTIY
        BP(ISQ,3)=-BP(IR,3)-BP(IRP,3)
        BP(ISQ,4)=SQRT(BP(ISQ,1)**2+BP(ISQ,2)**2+
     $       BP(ISQ,3)**2+BP(ISQ,5)**2)

C...boost back
        CALL AROBO3(0.0,0.0,0.0D0,0.0D0,DBZ,ISQ,IR,IRP)

      ELSE

C...We have a valens-quark interaction
C...Get flavor of diquark
 110    IF (KFQ2.EQ.KFSTR) THEN
          KFQ=KFQ2
          KFQ2=KFQ1
          KFQ1=KFQ
        ELSEIF (KFQ3.EQ.KFSTR) THEN
          KFQ=KFQ3
          KFQ3=KFQ1
          KFQ1=KFQ
        ENDIF
        KFR=SIGN(MAX(ABS(KFQ2),ABS(KFQ3))*1000+
     $       MIN(ABS(KFQ2),ABS(KFQ3))*100+3,KFQ1)
        IF (KFQ2.NE.KFQ3.AND.RLU(0).LT.PARL(4))
     $       KFR=SIGN(ABS(KFR)-2,KFR)

        RMR=ULMASS(KFR)
        
        IF (MSTA(37).EQ.0) THEN
          IF (MSTA(1).EQ.2) THEN
            IF(MSTP(91).LE.0) THEN
              PTI=0.
            ELSEIF(MSTP(91).EQ.1) THEN
              PTI=PARP(91)*SQRT(-LOG(RLU(0)))
            ELSE
              RPT1=RLU(0)
              RPT2=RLU(0)
              PTI=-PARP(92)*LOG(RPT1*RPT2)
            ENDIF
            IF(PTI.GT.PARP(93)) GOTO 110
          ELSE
            PTI=PARL(3)*SQRT(-LOG(RLU(0)))
          ENDIF
        ELSEIF (MSTA(37).EQ.1) THEN
          PTI=PARA(27)*SQRT(-LOG(RLU(0)))
        ELSEIF (MSTA(37).EQ.2) THEN
          RPT1=RLU(0)
          RPT2=RLU(0)
          PTI=-PARA(27)*LOG(RPT1*RPT2)/SQRT(6.0)          
        ENDIF
        PHII=PARU(2)*RLU(0)
        PTIX=PTI*COS(PHII)
        PTIY=PTI*SIN(PHII)

        RMTSQ=SQRT(BP(ISQ,5)**2+(BP(ISQ,1)+BRX-PTIX)**2+
     $       (BP(ISQ,2)+BRY-PTIY)**2)
        RMT2R=RMR**2+PTI**2
        RMTR=SQRT(RMT2R)
        PT2SQ=(BP(ISQ,1)+BRX)**2+(BP(ISQ,2)+BRY)**2
        PZTOT=ARZCMS(S+PT2SQ,RMTR,RMTSQ)
        IF (PZTOT.LT.0.0) GOTO 110

C...Set info for remnant
        IFL(IR)=KFR
        BP(IR,1)=PTIX
        BP(IR,2)=PTIY
        BP(IR,3)=IDIR*PZTOT
        BP(IR,4)=SQRT(PZTOT**2+RMT2R)
        BP(IR,5)=RMR
        QEX(IR)=.TRUE.
        XPMU(IR)=FACMU*XCMU
        IF (MSTA(36).EQ.2) XPMU(IR)=FACMU*PARA(14)*PTI
        IF (MSTA(36).GE.3) XPMU(IR)=FACMU*PARA(14)*PTI/(1.0-XSAVE(IT))
        XPA(IR)=PARA(10)

C...Fix momentum for struck particle
        BP(ISQ,1)=BP(ISQ,1)+BRX-PTIX
        BP(ISQ,2)=BP(ISQ,2)+BRY-PTIY
        BP(ISQ,3)=-BP(IR,3)
        BP(ISQ,4)=SQRT(BP(ISQ,1)**2+BP(ISQ,2)**2+
     $       BP(ISQ,3)**2+BP(ISQ,5)**2)

C...Boost back
        CALL AROBO2(0.0,0.0,0.0D0,0.0D0,DBZ,ISQ,IR)

      ENDIF
        
      RETURN

C**** END OF ARREMN ****************************************************
      END
C***********************************************************************
C $Id: arremn.f,v 3.15 1995/08/15 09:08:56 lonnblad Exp $
CDECK  ID>, ARINCR.
      SUBROUTINE ARINCR(IDIR,IQR,IDR,IRP)

C...ARiadne subroutine FIx REmnants

C...Redistribute remnants and prepare for BGF-like emission


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/


      DIMENSION IPRT(4)

      IF (IDIR.GT.0) THEN
        IF(PHAR(131).LE.0) RETURN
        BPX=PHAR(131)
      ELSEIF (IDIR.LT.0) THEN
        IF(PHAR(132).LE.0) RETURN
        BPX=PHAR(132)
      ENDIF

      NPRT=0
      BPR=0.0
      IF (IQR.GT.0) THEN
        BPR=BPR+BP(IQR,4)+IDIR*BP(IQR,3)
        NPRT=NPRT+1
        IPRT(NPRT)=IQR
      ENDIF
      IF (IDR.GT.0) THEN
        BPR=BPR+BP(IDR,4)+IDIR*BP(IDR,3)
        NPRT=NPRT+1
        IPRT(NPRT)=IDR
      ENDIF
      IF (IRP.GT.0) THEN
        BPR=BPR+P(IRP,4)+IDIR*P(IRP,3)
      ENDIF

      DPN2=(BPR+BPX)**2
      DPO2=BPR**2
      DBZ=IDIR*(DPN2-DPO2)/(DPN2+DPO2)

      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,DBZ,NPRT,IPRT)
      IF (IRP.GT.0)
     $     CALL LUDBRB(IRP,IRP,0.0,0.0,0.0D0,0.0D0,DBZ)

      RETURN
      END

C***********************************************************************
C $Id: arpoki.f,v 3.3 1994/05/11 07:10:41 lonnblad Exp $
CDECK  ID>, ARPOKI.
      SUBROUTINE ARPOKI(IT,IQR,IDR,IRP,IDIR,KFTF,KFPR,XPOM,TPOM,QFAIL)

C...ARiadne subroutine POmeron KInematics

C...Redistribute remnants assuming an incoming hadron IT, outgoing
C...hadron KFTF with a pomeron (or other colourless  sub object) with
C...momentum fraction XPOM and viruality -TPOM giving a remnant of
C...flavour KFPR. IQR, IDR and IRP as in subroutine ARREMN


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/
      COMMON /PYPARS/ MSTP(200),PARP(200),MSTI(200),PARI(200)
      SAVE /PYPARS/


      QFAIL=.TRUE.

C...Sum up remnant momentum
      BRX=0.0
      BRY=0.0
      BRZ=0.0
      BRE=0.0
      IF (IQR.GT.0) THEN
        IF (IDR.GT.0.AND.KFPR.NE.21) CALL ARERRM('ARPOKI',30,0)
        BRX=BRX+BP(IQR,1)
        BRY=BRY+BP(IQR,2)
        BRZ=BRZ+BP(IQR,3)
        BRE=BRE+BP(IQR,4)
      ENDIF
      IF (IDR.GT.0) THEN
        IF (IQR.GT.0.AND.KFPR.NE.21) CALL ARERRM('ARPOKI',30,0)
        BRX=BRX+BP(IDR,1)
        BRY=BRY+BP(IDR,2)
        BRZ=BRZ+BP(IDR,3)
        BRE=BRE+BP(IDR,4)
      ENDIF
      IF (IRP.GT.0) THEN
        IF (IQR.GT.0.AND.IDR.GT.0) CALL ARERRM('ARPOKI',30,0)
        BRX=BRX+P(IRP,1)
        BRY=BRY+P(IRP,2)
        BRZ=BRZ+P(IRP,3)
        BRE=BRE+P(IRP,4)
      ENDIF

      IF (KFPR.EQ.21) THEN
        IF (IQR.LE.0.OR.IDR.LE.0) CALL ARERRM('ARPOKI',30,0)
        IR=MIN(IQR,IDR)
      ELSE
        IR=MAX(IQR,IDR)
      ENDIF

C...Select particle to fix momentum transfer with
      IF (QQ(MAXPAR-2)) THEN
        ISQ=MAXPAR-2
      ELSEIF (IDI(IR).GT.0) THEN
        IF (IDO(IR).GT.0.AND.QEX(IP1(IDI(IR)))) THEN
          ISQ=IP3(IDO(IR))
        ELSE
          ISQ=IP1(IDI(IR))
        ENDIF
      ELSE
        ISQ=IP3(IDO(IR))
      ENDIF

      RM2PI=P(IT,5)**2
      RMPF=ULMASS(KFTF)
      RM2PF=RMPF**2
      PT2PF=TPOM*(1.0-XPOM)+XPOM*(RM2PI*(1.0-XPOM)-RM2PF)
      IF (PT2PF.LT.0.0) RETURN

      PHIPF=PARU(2)*RLU(0)
      PTXPF=SQRT(PT2PF)*COS(PHIPF)
      PTYPF=SQRT(PT2PF)*SIN(PHIPF)
      PPI=P(IT,4)+IDIR*P(IT,3)
      PPF=(1.0-XPOM)*PPI
      RMT2PF=RM2PF+PT2PF
      K(N+1,1)=1
      K(N+1,2)=KFTF
      K(N+1,3)=IT
      K(N+1,4)=0
      K(N+1,5)=0
      P(N+1,1)=PTXPF
      P(N+1,2)=PTYPF
      P(N+1,3)=IDIR*0.5*(PPF-RMT2PF/PPF)
      P(N+1,4)=0.5*(PPF+RMT2PF/PPF)
      P(N+1,5)=RMPF

C...Calculate boost to struck pomeron CMS and check kinematics
      
      RMPR=ULMASS(KFPR)
      RMT2PR=RMPR**2
      RMT2SQ=(BRX+BP(ISQ,1)-PTXPF)**2+
     $     (BRY+BP(ISQ,2)-PTYPF)**2+BP(ISQ,5)**2
      BSE=BRE+BP(ISQ,4)-P(N+1,4)
      BSZ=BRZ+BP(ISQ,3)-P(N+1,3)
      BSY=BRY+BP(ISQ,2)-P(N+1,2)
      BSX=BRX+BP(ISQ,1)-P(N+1,1)
      S=BSE**2-BSZ**2-BSY**2-BSX**2
      DBZ=BSZ/BSE
      
      IF (S.LT.0) RETURN
      BW=SQRT(S)
      IF (SQRT(RMT2PR)+SQRT(RMT2SQ).GE.BW) RETURN

 100  IF (PARA(16).GT.0) THEN
        PTI=PARA(16)*SQRT(-LOG(RLU(0)))
        IF (PTI.GT.PARA(17)) GOTO 100
      ELSEIF (MSTA(1).EQ.2) THEN
        IF(MSTP(91).LE.0) THEN
          PTI=0.
        ELSEIF(MSTP(91).EQ.1) THEN
          PTI=PARP(91)*SQRT(-LOG(RLU(0)))
        ELSE
          RPT1=RLU(0)
          RPT2=RLU(0)
          PTI=-PARP(92)*LOG(RPT1*RPT2)
        ENDIF
        IF(PTI.GT.PARP(93)) GOTO 100
      ELSE
        PTI=PARL(3)*SQRT(-LOG(RLU(0)))
      ENDIF
      PHII=PARU(2)*RLU(0)
      PTIX=PTI*COS(PHII)
      PTIY=PTI*SIN(PHII)

      RMT2PR=PTI**2+RMPR**2
      RMTPR=SQRT(RMT2PR)
      RMT2SQ=(BSX-PTIX)**2+(BSY-PTIY)**2+BP(ISQ,5)**2
      RMTSQ=SQRT(RMT2SQ)
      IF (RMTPR+RMTSQ.GE.BW) GOTO 100
      PT2SQ=BSX**2+BSY**2
      PZTOT=ARZCMS(S+PT2SQ,RMTSQ,RMTPR)
      IF (PZTOT.LT.0.0) GOTO 100

      BP(ISQ,1)=BSX-PTIX
      BP(ISQ,2)=BSY-PTIY
      BP(ISQ,3)=-IDIR*PZTOT
      BP(ISQ,4)=SQRT(PZTOT**2+RMT2SQ)

      IF (KFPR.EQ.21) CALL ARJOQQ(IQR,IDR)

      BP(IR,1)=PTIX
      BP(IR,2)=PTIY
      BP(IR,3)=IDIR*PZTOT
      BP(IR,4)=SQRT(PZTOT**2+RMT2PR)
      BP(IR,5)=RMPR

      IFL(IR)=KFPR
      QEX(IR)=.TRUE.
      XPMU(IR)=PARA(14)*MAX(PTI,SQRT(TPOM))
      XPA(IR)=PARA(15)
      PT2GG(IR)=0.0
      IF (IDI(IR).GT.0) QDONE(IDI(IR))=.FALSE.
      IF (IDO(IR).GT.0) QDONE(IDO(IR))=.FALSE.

      CALL AROBO2(0.0,0.0,0.0D0,0.0D0,DBZ,ISQ,IR)

      N=N+1
      IF (IRP.GT.0) THEN
        IF (K(IRP,1).LT.10) K(IRP,1)=K(IRP,1)+10
        IRP=-IRP
      ENDIF
      QFAIL=.FALSE.

      RETURN

C**** END OF ARPOKI ****************************************************
      END
C***********************************************************************
C $Id: arposf.f,v 3.5 1994/09/20 12:38:37 lonnblad Exp $
CDECK  ID>, ARPOSF.
      SUBROUTINE ARPOSF(KFT,KFSTR,X,XQ2,XPOM,TPOM,KFTF,KFPR,XFP,XFPOM)

C...ARiadne subroutine POmeron Structure Function

C...Return some information about possible pomeron interaction given
C...a target KFT with a struck parton KFSTR at X and XQ2. XFPOM is x
C...times the part of the KFT structure function for KFSTR which is due
C...to a pomeron. It must be smaller or equal to the total
C...given by XFP. XPOM and TPOM are the momentum fraction and
C...virtuality of the responsible pomeron. KFPR is the flavour of the
C...pomeron remnant and KFTF is the KF code of the outgoing target.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /ARPOPA/ TOTSIG,PPOW,CA(3),PB(3),CF(0:6),XA(0:6),NB(0:6)
      SAVE /ARPOPA/ 


C...Get normalization
      KFL=ABS(KFSTR)
      IF (KFL.EQ.21) KFL=0
      POW=0.5*PPOW
      DO 100 IFL=0,6
        IF (MSTA(34).EQ.2) THEN
          XA(IFL)=1.0
          NB(IFL)=1
          POW=1.0
        ELSEIF (MSTA(34).EQ.3) THEN
          XA(IFL)=1.0
          NB(IFL)=1
          POW=1.0
        ENDIF
        IF (NB(IFL).LT.0.OR.XA(IFL)+POW+NB(IFL).LT.1.0.OR.
     $       XA(IFL).LT.-1.0.OR.XA(IFL)+POW.LT.-1.0)
     $       CALL ARERRM('ARPOSF',25,0)
        IF (IFL.EQ.0) THEN
          IF (PHAR(102).GE.0.0) CF(IFL)=PHAR(102)
          XNORM=CF(IFL)*ARIPSF(XA(IFL),NB(IFL),0.0)
        ELSE
          XNORM=XNORM+2.0*CF(IFL)*ARIPSF(XA(IFL),NB(IFL),0.0)
        ENDIF
 100  CONTINUE
      IF (MSTA(27).EQ.0) XNORM=1.0

C...Get t-integral an generate t
      XNP=0
      SA=0
      BMIN=PARA(40)
      BMAX=0.0
      DO 110 I=1,3
        IF (CA(I).EQ.0) GOTO 110
        IF (PB(I).LT.0) CALL ARERRM('ARPOSF',25,0)
        SA=SA+CA(I)
        BPB=PB(I)
        BMIN=MIN(BMIN,BPB)
        BMAX=MAX(BMAX,BPB)
        IF (MHAR(117).GT.0.OR.PB(I)*XQ2.GT.LOG(PARA(40))) THEN
          XNP=XNP+CA(I)/PB(I)
        ELSE
          XNP=XNP+CA(I)*(1.0-EXP(-PB(I)*XQ2))/PB(I)
        ENDIF
 110  CONTINUE
      XNP=XNP/TOTSIG
      IF (MHAR(117).GT.0.OR.BMIN*XQ2.GT.LOG(PARA(40))) THEN
 120    TPOM=-LOG(RLU(IDUM))/BMIN
        SUM=0
        DO 140 I=1,3
          IF (PB(I)*TPOM.LE.LOG(PARA(40)))
     $         SUM=SUM+CA(I)*EXP(-PB(I)*TPOM)
 140    CONTINUE
        IF (SUM.LT.RLU(IDUM)*SA*EXP(-BMIN*TPOM)) GOTO 120
      ELSE
 130    TPOM=-LOG(1.0-RLU(IDUM)*(1.0-EXP(-BMIN*XQ2)))/BMIN
        SUM=0
        DO 150 I=1,3
          IF (PB(I)*TPOM.LE.LOG(PARA(40)))
     $         SUM=SUM+CA(I)*EXP(-PB(I)*TPOM)
 150    CONTINUE
        IF (SUM.LT.RLU(IDUM)*SA*EXP(-BMIN*TPOM)) GOTO 130
      ENDIF

C...Calculate pomeron part of structure function
      AP=XA(KFL)+POW
      IF (MSTA(34).EQ.1) THEN
        XFPOM=CF(KFL)*XNP*ARIPSF(AP-1.0,NB(KFL),X)*(X**(POW-1.0))/XNORM
      ELSEIF (MSTA(34).EQ.2) THEN
        XFPOM=CF(KFL)*XNP*(1.0/6.0-1.5*X-(1.5+3.0*LOG(X))*X**2+
     $       (17.0/6.0-LOG(X))*X**3)/XNORM
      ELSEIF (MSTA(34).EQ.3) THEN
        XFPOM=CF(KFL)*XNP*(1.0/6.0-2.5*X-(40.0/3.0+10.0*LOG(X))*X**2+
     $       (40.0/3.0-10.0*LOG(X))*X**3+2.5*X**4-(1.0/6.0)*X**5)/XNORM
      ENDIF

C...Generate Z
      NP=0
      IF (MSTA(34).EQ.2) THEN
        NP=3
      ELSEIF (MSTA(34).EQ.3) THEN
        NP=5
      ENDIF
      IF (ABS(AP).LT.PARA(39)) THEN
 200    Z=X**RLU(0)
        IF (((1.0-X/Z)**NP)*((1.0-Z)**NB(KFL)).LT.RLU(IDUM)) GOTO 200
      ELSE
 210    Z=(1.0-RLU(IDUM)*(1.0-X**AP))**(1.0/AP)
        IF (((1.0-X/Z)**NP)*((1.0-Z)**NB(KFL)).LT.RLU(IDUM)) GOTO 210
      ENDIF
      XPOM=X/Z

C..Set flavours
      KFTF=KFT
      KFPR=-KFSTR
      IF (KFPR.EQ.0) KFPR=21

      RETURN

C**** END OF ARPOSF ****************************************************
      END
C***********************************************************************
C $Id: arposf.f,v 3.5 1994/09/20 12:38:37 lonnblad Exp $
CDECK  ID>, ARIPSF.
      REAL FUNCTION ARIPSF(A,N,X)

C...ARiadne function Integrate part of Pomeron Structure Function

C...Returns the integral from X to 1 of the function Z**A*(1-Z)**N for
C...A>-1 and N>=0 used in calculation of pomeron part of nucleon
C...structure function

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)


      FAC=1.0
      SUM=0.0
      NI=N
      AI=A
      ARIPSF=1.0/SQRT(A+1.0)
      IF (N.LT.0.OR.A.LE.-1.0.OR.X.LT.0.0.OR.X.GE.1.0) RETURN

 100  IF (NI.EQ.0) THEN
        SUM=SUM+FAC*(1.0-X**(AI+1.0))/(AI+1.0)
        ARIPSF=SUM
        RETURN
      ELSE
        AI=AI+1
        FAC=FAC/AI
        SUM=SUM-FAC*(X**AI)*((1.0-X)**NI)
        FAC=FAC*NI
        NI=NI-1
        GOTO 100
      ENDIF

C**** END OF ARIPSF ****************************************************
      END
C***********************************************************************
C $Id: arupom.f,v 3.4 1995/08/13 17:29:27 lonnblad Exp $
CDECK  ID>, ARUPOM.
      SUBROUTINE ARUPOM(KFT,KFSTR,X,XQ2,XPOM,TPOM,KFTF,KFPR,XFP,XFPOM)

C...ARiadne dummy routine User POMeron structure function

C...Produce an error message if user defined function for pomeron
C...structure function has not been linked

C...Return some information about possible pomeron interaction given
C...a target KFT with a struck parton KFSTR at X and XQ2. XFPOM is x
C...times the part of the KFT structure function for KFSTR which is due
C...to a pomeron. It must be smaller or equal to the total
C...given by XFP. XPOM and TPOM are the momentum fraction and
C...virtuality of the responsible pomeron. KFPR is the flavour of the
C...pomeron remnant and KFTF is the KF code of the outgoing target.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)


      CALL ARERRM('ARUPOM',24,0)

      RETURN

C**** END OF ARUPOM ****************************************************
      END
C***********************************************************************
CDECK  ID>, LNSTRF.
      SUBROUTINE LNSTRF(X,XQ2,XPQ)

C...ariadne dummy routine LNSTRF

C...Produce an error message if Lepto structure functions has not
C...been linked.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      REAL XPQ(-6:6)


      CALL ARERRM('LNSTRF',24,0)

      RETURN

C**** END OF LNSTRF ****************************************************
      END
C***********************************************************************
CDECK  ID>, PYSTFU.
      SUBROUTINE PYSTFU(KF,X,XQ2,XPQ)

C...ariadne dummy routine PYSTFU

C...Produce an error message if Lepto structure functions has not
C...been linked.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)

      REAL XPQ(-25:25)


      CALL ARERRM('PYSTFU',24,0)

      RETURN

C**** END OF PYSTFU ****************************************************
      END
C***********************************************************************
C $Id: arniqq.f,v 3.4 1994/10/06 16:49:48 lonnblad Exp $
CDECK  ID>, ARNIQQ.
      SUBROUTINE ARNIQQ(IT,KQ,IRP,PT2,YQ,PHIQ,QFAIL)

C...ARiadne perform INitial state g->QQ

C...Try to perform an initial-state g->qqbar splitting.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARSTRF/ KFSAVE(2),XSAVE(2),XQ2SAV(2),XPQSAV(2,-6:6)
      SAVE /ARSTRF/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/

      DIMENSION ISTQ(MAXPAR),IREM(MAXPAR),ITOT(MAXPAR)


      QFAIL=.TRUE.
      RMQ2=ULMASS(KQ)
      IF (MHAR(102).GE.1) THEN
        DMT2Q=PT2
        DPT2Q=DMT2Q-RMQ2**2
      ELSE
        DPT2Q=PT2
        DMT2Q=DPT2Q+RMQ2**2
      ENDIF

C...First boost all particle to total cms
      DO 100 I=1,IPART
        ITOT(I)=I
 100  CONTINUE
      NI=IPART
      DO 110 I=2,4
        IF (QQ(MAXPAR-I)) THEN
          NI=NI+1
          ITOT(NI)=MAXPAR-I
        ENDIF
 110  CONTINUE
      CALL ARSUME(0,DXT,DYT,DZT,DET,DMT,NI,ITOT)
      DBXT=DXT/DET
      DBYT=DYT/DET
      DBZT=DZT/DET
      CALL ARROBO(0.0,0.0,-DBXT,-DBYT,-DBZT,NI,ITOT)
      
C...Then divide up all partons into remnant and struck system
      NREM=2
      IR=INQ(IRP)
      IREM(1)=IRP
      IREM(2)=IR
      NSTQ=1
      IQ=IDI(IRP)
      ISTQ(1)=IQ
C...      DO 100 I=1,IPART
C...        IF (I.EQ.IRP.OR.I.EQ.IR.OR.I.EQ.IQ) GOTO 100
C...        IF (INO(I).LT.0.OR.QEX(I)) THEN
C...          NREM=NREM+1
C...          IREM(NREM)=I
C...        ELSE
C...          NSTQ=NSTQ+1
C...          ISTQ(NSTQ)=I
C...        ENDIF
C... 100  CONTINUE

C...Now rotate remnant system to negative z-axis and quark in x-z plane
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NREM,IREM)
      PHIT=ULANGL(REAL(DXR),REAL(DYR))
      THET=ULANGL(REAL(DZR),REAL(SQRT(DXR**2+DYR**2)))-PARU(1)
      CALL ARROBO(0.0,-PHIT,0.0D0,0.0D0,0.0D0,NI,ITOT)
      CALL ARROBO(-THET,0.0,0.0D0,0.0D0,0.0D0,NI,ITOT)
      CALL ARROBO(0.0,-PHIQ,0.0D0,0.0D0,0.0D0,NI,ITOT)

C...Check that emission is possible
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NREM,IREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NSTQ,ISTQ)

      BXQ=SQRT(DPT2Q)
      BYQ=0.0
      BZQ=SQRT(DMT2Q)*SINH(YQ)
      BEQ=SQRT(DMT2Q)*COSH(YQ)
      BQP=BEQ+BZQ
      BQM=BEQ-BZQ

      B0P=DEQ+DZQ
      B0M=DEQ-DZQ
      BM0D2=DMQ**2+(DXQ-BXQ)**2+(DYQ-BYQ)**2

      BRP=DER+DZR
      BRM=DER-DZR

      BRQP=B0P+BRP-BQP
      BRQM=B0M+BRM-BQM

      BA=(BRQP*BRQM+BRP*BRM-BM0D2)/(2.0*BRQM*BRP)
      BB=BRM*BRQP/(BRP*BRQM)

      IF (BA**2.LT.BB.OR.BA.LE.0.0.OR.BRQP.LE.0.0.OR.BRQM.LE.0.0)
     $     GOTO 900

      DAR=BA-SQRT(BA**2-BB)

      IF (DAR.LE.1.0) GOTO 900

      DXZQ=SIGN(SQRT(DXQ**2+DZQ**2),DZQ)
      IF (ABS(DXZQ).LE.ABS(DXQ-BXQ)) GOTO 900

C...Boost remnant system to correct rapidity
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $     (DAR**2-1.0D0)/(DAR**2+1.0D0),NREM,IREM)

C...Rotate struck system to right pt
      CALL ARROBO(REAL(ASIN((DXQ-BXQ)/DXZQ)-ASIN(DXQ/DXZQ)),
     $     0.0,0.0D0,0.0D0,0.0D0,NSTQ,ISTQ)

C...Boost struck system to right rapidity
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NSTQ,ISTQ)
      DPP2=(BRP*(1.0-DAR)+B0P-BQP)**2
      DPP02=(DZQ+DEQ)**2
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,(DPP2-DPP02)/(DPP2+DPP02),
     $     NSTQ,ISTQ)

C...Insert new quark
      IO=IO+1
      IPART=IPART+1
      IQ2=IPART
      IFL(IQ2)=-KQ
      IF (MSTA(30).LT.2.OR.MSTA(30).EQ.3) THEN
        QEX(IQ2)=.FALSE.
        XPMU(IQ2)=0.0
        XPA(IQ2)=0.0
        QEX(IQ)=.FALSE.
        XPMU(IQ)=0.0
        XPA(IQ)=0.0
      ELSE
        QEX(IQ2)=.TRUE.
        IF (PARA(14).GE.0) THEN
          XPMU(IQ2)=SQRT(XQ2SAV(IT))*PARA(14)
        ELSE
          XPMU(IQ2)=ABS(PARA(14))
        ENDIF
        XPA(IQ2)=PARA(15)
      ENDIF
      QEX(IQ2)=.FALSE.
      QQ(IQ2)=.TRUE.
      INO(IQ2)=IO
      INQ(IQ2)=0
      BP(IQ2,5)=RMQ2
      BP(IQ2,4)=BEQ
      BP(IQ2,3)=BZQ
      BP(IQ2,2)=BYQ
      BP(IQ2,1)=BXQ
      NI=NI+1
      ITOT(NI)=IQ2

C...Insert new remnant
      IPART=IPART+1
      IR=IPART
      IFL(IR)=INO(IRP)
      QEX(IR)=QEX(IRP)
      QQ(IR)=.TRUE.
      INO(IR)=0
      INQ(IR)=0
      XPMU(IR)=XPMU(IRP)
      XPA(IR)=XPA(IRP)
      BP(IR,1)=BP(IRP,1)
      BP(IR,2)=BP(IRP,2)
      BP(IR,3)=BP(IRP,3)
      BP(IR,4)=BP(IRP,4)
      BP(IR,5)=BP(IRP,5)
      QQ(IRP)=.FALSE.
      NI=NI+1
      ITOT(NI)=IR

C...Fix new string and dipole
      IDIPS=IDIPS+1
      ISTRS=ISTRS+1
      CALL ARCRDI(IDIPS,IQ2,IR,ISTRS,.FALSE.)
      IDI(IQ2)=0
      IDO(IR)=0
      IPF(ISTRS)=IQ2
      IPL(ISTRS)=IR
      IFLOW(ISTRS)=SIGN(1,-KQ)

      QFAIL=.FALSE.

C...Reset all dipole flags
 900  DO 200 ID=1,IDIPS
        QDONE(ID)=.FALSE.
 200  CONTINUE

C...Boost back
      CALL ARROBO(0.0,PHIQ,0.0D0,0.0D0,0.0D0,NI,ITOT)
      CALL ARROBO(THET,PHIT,DBXT,DBYT,DBZT,NI,ITOT)

      RETURN

C**** END OF ARNIQQ ****************************************************
      END
C***********************************************************************
C $Id: armtqq.f,v 3.4 1994/10/06 16:49:47 lonnblad Exp $
CDECK  ID>, ARMTQQ.
      SUBROUTINE ARMTQQ(KF,KQ,PM,PT2MAX,PT2MIN,X,XQ2,YQ,PHI)

C...ARiadne get PT2 of initial state g->QQ

C...Get kinematical variables describing an initial-state g->qqbar
C...splitting.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/


      PHI=0
      T2=XQ2
      PT2MAX=MIN(PT2MAX,0.25*PM**2)
      IF (MHAR(102).LT.0) GOTO 900
      RMQ=ULMASS(KQ)
      PT2CUT=PT2MIN
      PT2CUT=MAX(PT2MIN,PARA(3)**2+RMQ**2)
      IF (PT2MAX.LE.PT2CUT) GOTO 900

      XNUMFL=MAX(ARNOFL(SQRT(T2/X),MAX(5,MSTA(15))),3.0)
      ALPHA0=12.0*PARU(1)/(33.0-2.0*XNUMFL)
      SQ2MIN=PHAR(103)*PT2CUT/PARA(21)
      SQ2MAX=PHAR(103)*PT2MAX/PARA(21)
      IF (MSTA(19).EQ.2) SQ2MIN=MAX(SQ2MIN,XQ2)
      SQ2MIN=MAX(SQ2MIN,4.0*RMQ**2)
      STRA0=ARSTRA(KF,KQ,X,1.0,SQ2MIN)
      STRA0=MAX(STRA0,ARSTRA(KF,KQ,X,1.0,XQ2))
      STRA0=MAX(STRA0,ARSTRA(KF,KQ,X,1.0,SQ2MAX))
      
      C=PHAR(104)*ALPHA0*STRA0/PARU(1)
      ZINT=1.0-X
      CN=1.0/(C*ZINT)
      XLAM2=(PARA(1)**2)/PHAR(103)

 100  IF (PT2MAX.LE.PT2CUT) GOTO 900
      ARG=RLU(IDUM)
      IF (LOG(ARG)*CN.LT.
     $     LOG(LOG(PT2CUT/XLAM2)/LOG(PT2MAX/XLAM2))) GOTO 900
      PT2MAX=XLAM2*(PT2MAX/XLAM2)**(ARG**CN)

      Z=X+RLU(0)*(1.0-X)
      SQ2=PHAR(103)*PT2MAX/PARA(21)

      W=(Z**2+(1.0-Z)**2)*0.25
      IF (MSTA(19).EQ.2) THEN
        W=W*MIN(1.0,LOG(PT2MAX/XLAM2)/LOG(PARA(21)*XQ2/XLAM2))
        SQ2=MAX(SQ2,XQ2)
      ENDIF
      SQ2=MAX(SQ2,SQ2MIN)
      IF (MHAR(113).EQ.1) THEN
        STRA=ARSTRA(KF,KQ,X,Z,SQ2)
        W=W*STRA/STRA0
      ELSE
        BETA=PARA(25)
        IF (MSTA(25).EQ.0) BETA=0.0
        PTIN=SQRT(PHAR(103)*PT2MAX)
        IF (MHAR(113).EQ.2) PTIN=2.0*PTIN
        XMU=PARA(11)
        ALPHA=PARA(10)
        IF (PARA(10).GT.0.0) THEN
          XMU=PARA(11)
          ALPHA=PARA(10)
        ELSEIF (PTIN.GE.ABS(PARA(10))) THEN
          XMU=SQRT(ABS(PARA(10)*PARA(11)))
          ALPHA=2.0
        ELSE
          XMU=PARA(11)
          ALPHA=1.0
        ENDIF
        IF (X/Z.GT.((1.0/RLU(IDUM)-1.0)**BETA)*(XMU/PTIN)**ALPHA)
     $       GOTO 100
      ENDIF

      IF (W.GT.1.0) THEN
        CALL ARERRM('ARPTQQ',22,0)
        RETURN
      ENDIF

      IF (W.LT.RLU(IDUM)) GOTO 100

      IF (MHAR(113).EQ.-1) THEN
        IF (PT2MAX.LT.Z*(1.0-X)*XQ2) GOTO 100
        IF (PT2MAX.LT.(1.0-Z)*(1.0-X)*XQ2) GOTO 100
      ENDIF

      YQ=0.5*LOG(PT2MAX*(Z/((1.0-Z)*X*PM))**2)
      PHI=PARU(2)*RLU(IDUM)

      RETURN

 900  PT2MAX=0.0
      RETURN

C**** END OF ARMTQQ ****************************************************
      END
C***********************************************************************
C $Id: arging.f,v 3.11 1995/08/15 09:08:50 lonnblad Exp $
CDECK  ID>, ARGING.
      SUBROUTINE ARGING(ID,IRP)

C...ARiadne Generate INitial state G->QQ

C...Generate kinematical variables describing an initial-state g->qqbar
C...splitting.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/

      INTEGER NTT,NTE1,NTE2
      DATA NTT/0/,NTE1/0/,NTE2/0/


      IF (MHAR(120).NE.0) THEN
        CALL ARGIG2(ID,IRP)
        RETURN
      ENDIF

      IF (MHAR(102).LT.0) RETURN

      QEXDIS=(MSTA(1).EQ.3.AND.IO.EQ.0)

      IR=INQ(IRP)
      IT=IRP+5-MAXPAR

      IF (IRAD(ID).EQ.10000+IRP) THEN
        PT2IN(ID)=PT2SAV(IT)
        IRAD(ID)=IRASAV(IT)
        AEX1(ID)=A1SAVE(IT)
        AEX3(ID)=A3SAVE(IT)
        BX1(ID)=B1SAVE(IT)
        BX3(ID)=B3SAVE(IT)
      ENDIF

      NPREM=2
      IPREM(1)=IRP
      IPREM(2)=IR
      IDIR=IRDIR(IT)
      KQ=IDO(IRP)
      KF=K(IT,2)
      RMQ=ULMASS(KQ)
      PM=P(IT,4)+IDIR*P(IT,3)
      PT2CUT=MAX(PARA(3)**2+RMQ**2,PT2IN(ID))/PHAR(103)

      IF (NPTOT.EQ.0) THEN
        DO 10 I=1,IPART
          IPTOT(I)=I
 10     CONTINUE
        NPTOT=IPART
      ENDIF

      IF (MHAR(103).GT.0) THEN
        NPSTQ=0
        DO 20 I=1,NPTOT
          IF (INO(IPTOT(I)).NE.0) THEN
            NPSTQ=NPSTQ+1
            IPSTQ(NPSTQ)=IPTOT(I)
          ENDIF
 20     CONTINUE
        CALL ARPADD(-IDI(IRP),NPSTQ,IPSTQ)
      ELSE
        NPSTQ=1
        IPSTQ(1)=IDI(IRP)
      ENDIF

      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NPREM,IPREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)
      B0P=DEQ-IDIR*DZQ
      B0M=DEQ+IDIR*DZQ
      BRP=DER-IDIR*DZR
      BRM=DER+IDIR*DZR

      XX=1.0-BRM/PM
      IF (QEXDIS) XX=X

      PT2MX=MIN(REAL((SQRT(DXQ**2+DYQ**2+DZQ**2)-
     $     SQRT(DXQ**2+DYQ**2))**2),PT2LST)
      IF (MHAR(119).GT.0) THEN
        RMTQ=SQRT(B0P*B0M)
        STOT=(DEQ+DER)**2-(DZQ+DZR)**2-(DYQ+DYR)**2-(DXQ+DXR)**2
        PT2MX=MIN(ARZCMS(STOT,RMTQ,RMQ)**2,PT2LST)
      ENDIF
      IF (PT2MX.LE.PT2CUT) GOTO 900
      IF (QEXDIS) THEN
        SQ2MAX=0.5*(XQ2+PT2MX)
        SQ2MIN=PT2CUT/
     $       ((0.5+SQRT(MAX(0.25-PT2CUT*X/(XQ2*(1.0-X)),0.0)))*(1.0-X))
      ELSE
        SQ2MAX=PT2MX+XX*B0P*PM
        SQ2MIN=PT2CUT/(1.0-XX)
      ENDIF

      XNUMFL=MAX(ARNOFL(SQRT(SQ2MAX),MAX(5,MSTA(15))),3.0)
      ALPHA0=12.0*PARU(1)/(33.0-2.0*XNUMFL)
      IF (MHAR(118).EQ.0) THEN
        STRA0=ARSTRA(KF,KQ,XX,1.0,SQ2MIN)
        DO 30 IQ2=1,20
          SQ2=EXP(LOG(SQ2MIN)+REAL(IQ2)*(LOG(SQ2MAX)-LOG(SQ2MIN))/20.0)
          STRA0=MAX(STRA0,ARSTRA(KF,KQ,XX,1.0,SQ2))
 30     CONTINUE
      ELSE
        STRA0=ARSTRA(KF,KQ,XX,1.0,SQ2MAX)*REAL(MHAR(118))
      ENDIF
      IF (STRA0.LE.0.0) THEN
        GOTO 900
      ENDIF

      C=PHAR(104)*ALPHA0*STRA0/PARU(1)
      ZINT=1.0-X
      CN=1.0/(C*ZINT)
      XLAM2=(PARA(1)**2)/PHAR(103)
      IF (QEXDIS) THEN
        CY=(1.0-XY)/(1.0+(1.0-XY)**2)
        CQ=0.125+0.25*CY
        C=PHAR(104)*0.25*ALPHA0*STRA0*CQ/PARU(1)
        THEMAX=PT2MX
        YINT=4.0*LOG(SQRT(PT2MX/PT2CUT)+SQRT(PT2MX/PT2CUT-1.0))
        CN=1.0/(YINT*C)
      ENDIF

 100  IF (PT2MX.LE.PT2CUT) GOTO 900
      ARG=RLU(IDUM)
      IF (LOG(ARG)*CN.LT.
     $     LOG(LOG(PT2CUT/XLAM2)/LOG(PT2MX/XLAM2))) GOTO 900
      PT2MX=XLAM2*(PT2MX/XLAM2)**(ARG**CN)

      IF (QEXDIS) THEN
        YMAX=2.0*LOG(SQRT(THEMAX/PT2MX)+SQRT(THEMAX/PT2MX-1.0))
        Y=(RLU(IDUM)*2.0-1.0)*YMAX
        ZQ=1.0/(1.0+EXP(-Y))
        IF (MHAR(102).EQ.2) THEN
          Z=XQ2*ZQ*(1.0-ZQ)/(PT2MX+XQ2*ZQ*(1.0-ZQ))
        ELSE
          Z=ZQ*(1.0-ZQ)*XQ2/PT2MX
        ENDIF
        IF (Z.LE.X.OR.Z.GE.1.0) GOTO 100
        SQ2=PT2MX/
     $     ((0.5+SQRT(MAX(0.25-PT2MX*Z/(XQ2*(1.0-Z)),0.0)))*(1.0-Z))
        W=2.0*YMAX/YINT
        W=W*(Z*(1.0-Z)*(Z**2+(1.0-Z)**2)*(ZQ**2+(1.0-ZQ)**2)+
     $       16.0*((Z*(1.0-Z))**2)*ZQ*(1.0-ZQ)*CY)/CQ
        IF (MSTA(19).EQ.2) THEN
          W=W*MIN(1.0,LOG(PT2MX/XLAM2)/LOG(PARA(21)*XQ2/XLAM2))
          SQ2=MAX(SQ2,XQ2)
        ENDIF
      ELSE
        Z=XX+RLU(0)*(1.0-XX)
        W=(Z**2+(1.0-Z)**2)*0.25
        IF (MHAR(119).EQ.0.AND.
     $       Z.GE.1.0/(1.0+PT2MX/(XX*B0P*PM))) GOTO 100
        SQ2=PT2MX/(1.0-Z)
      ENDIF

      IF (MHAR(113).EQ.1) THEN
        STRA=ARSTRA(KF,KQ,XX,Z,SQ2)
        IF (MHAR(118).EQ.0.AND.STRA.LE.0.0) GOTO 100
        IF (STRA.LT.0.0) THEN
          GOTO 100
        ENDIF
        W=W*STRA/STRA0
      ELSE
        BETA=PARA(25)
        IF (MSTA(25).EQ.0) BETA=0.0
        PTIN=SQRT(PHAR(103)*PT2MX)
        IF (MHAR(113).EQ.2) PTIN=2.0*PTIN
        XMU=PARA(11)
        ALPHA=PARA(10)
        IF (PARA(10).GT.0.0) THEN
          XMU=PARA(11)
          ALPHA=PARA(10)
        ELSEIF (PTIN.GE.ABS(PARA(10))) THEN
          XMU=SQRT(ABS(PARA(10)*PARA(11)))
          ALPHA=2.0
        ELSE
          XMU=PARA(11)
          ALPHA=1.0
        ENDIF
        IF (XX/Z.GT.((1.0/RLU(IDUM)-1.0)**BETA)*(XMU/PTIN)**ALPHA)
     $       GOTO 100
      ENDIF

      IF (MHAR(118).EQ.0.AND.W.GT.1.0) THEN
        CALL ARERRM('ARGING',22,0)
        GOTO 900
      ENDIF

      IF (W.LT.RLU(IDUM)) GOTO 100

      IF (MHAR(113).EQ.-1) THEN
        IF (PT2MX.LT.Z*(1.0-X)*XQ2) GOTO 100
        IF (PT2MX.LT.(1.0-Z)*(1.0-X)*XQ2) GOTO 100
      ENDIF

      IF (QEXDIS) THEN
        YQ=-IDIR*0.5*LOG(ZQ*(1.0-X)/((1.0-ZQ)*(X/Z-X)))
        XA=0.125*(1.0+(1.0-XY)**2)*(Z**2+(1.0-Z)**2)*
     $       (ZQ**2+(1.0-ZQ)**2)/(ZQ*(1.0-ZQ))+2.0*(1.0-XY)*Z*(1.0-Z)
        XB=0.5*XY*SQRT((1.0-XY)*Z*(1.0-Z)/(ZQ*(1.0-ZQ)))*
     $       (1.0-2.0/XY)*(1.0-2.0*ZQ)*(1.0-2.0*Z)
        XC=(1.0-XY)*Z*(1.0-Z)
        ABC=ABS(XA)+ABS(XB)+ABS(XC)
 200    PHI=PARU(2)*RLU(IDUM)
        IF (XA+XB*COS(PHI)+XC*COS(2.0*PHI).LT.RLU(IDUM)*ABC) GOTO 200
      ELSE
        YQ=-IDIR*0.5*LOG(PT2MX*(Z/((1.0-Z)*XX*PM))**2)
        PHI=PARU(2)*RLU(IDUM)
      ENDIF

      IF (MHAR(119).GT.0) THEN

        YQ=Z
        BM=(1.0-XX/Z)*PM
        IF (BM.LT.DMR) GOTO 100
        BPH=B0P+BRP-BRP*BRM/BM
        BMH=B0M+BRM-BM

        DPT2Q=PT2MX-RMQ**2
        RMTQ=SQRT(PT2MX)
        DXS=DXQ-SQRT(DPT2Q)*COS(PHI)
        DYS=DYQ-SQRT(DPT2Q)*SIN(PHI)
        RMTS=SQRT(DMQ**2+DXS**2+DYS**2)
        STOT=BPH*BMH
        DZS=ARZCMS(STOT,RMTS,RMTQ)
        IF (DZS.LT.0.0) GOTO 100
        IF (DZS**2+DYS**2+DXS**2.LE.DYQ**2+DXQ**2) GOTO 100

      ELSE
        

        DPT2Q=PT2MX-RMQ**2
        DMT2Q=PT2MX

        BXQ=SQRT(DPT2Q)*COS(PHI)
        BYQ=SQRT(DPT2Q)*SIN(PHI)
        BZQ=SQRT(DMT2Q)*SINH(YQ)
        BEQ=SQRT(DMT2Q)*COSH(YQ)
        BQP=BEQ-IDIR*BZQ
        BQM=BEQ+IDIR*BZQ

        BM0D2=DMQ**2+(DXQ-BXQ)**2+(DYQ-BYQ)**2
        BRQP=B0P+BRP-BQP
        BRQM=B0M+BRM-BQM

        BA=(BRQP*BRQM+BRP*BRM-BM0D2)/(2.0*BRQM*BRP)
        BB=BRM*BRQP/(BRP*BRQM)

        IF (BA**2.LT.BB.OR.BA.LE.0.0.OR.BRQP.LE.0.0.OR.BRQM.LE.0.0)
     $       GOTO 100

        DAR=BA-SQRT(BA**2-BB)

        IF (DAR.LE.1.0) GOTO 100

        DQ=SQRT(DXQ**2+DYQ**2+DZQ**2)
        IF (DQ.LE.SQRT((DXQ-BXQ)**2+(DYQ-BYQ)**2)) GOTO 100

      ENDIF

      NTT=NTT+1
      IF (W.GT.1.0) THEN
        NTE1=NTE1+1
        IF (MOD(NTE1,10).EQ.0) WRITE(0,*) REAL(NTE1)/REAL(NTT)
      ENDIF
      IF (STRA.GT.STRA0) THEN
        NTE2=NTE2+1
        IF (MOD(NTE2,10).EQ.0) WRITE(0,*) REAL(NTE2)/REAL(NTT)
      ENDIF

      IF (PT2MX*PHAR(103).GT.PT2IN(ID)) THEN
        PT2SAV(IT)=PT2IN(ID)
        IRASAV(IT)=IRAD(ID)
        A1SAVE(IT)=AEX1(ID)
        A3SAVE(IT)=AEX3(ID)
        B1SAVE(IT)=BX1(ID)
        B3SAVE(IT)=BX3(ID)
        PT2GG(IRP)=PT2MX
        PT2IQQ(IT)=PT2MX
        PT2IN(ID)=PT2MX*PHAR(103)
        IRAD(ID)=10000+IRP
        AEX1(ID)=YQ
        AEX3(ID)=YQ
        BX1(ID)=PHI
        BX3(ID)=PHI
      ENDIF

      RETURN

 900  PT2GG(IRP)=0.0
      RETURN

C**** END OF ARGING ****************************************************
      END
C***********************************************************************
C $Id: arging.f,v 3.11 1995/08/15 09:08:50 lonnblad Exp $
CDECK  ID>, ARGIG2.
      SUBROUTINE ARGIG2(ID,IRP)

C...ARiadne Generate INitial state G->QQ

C...Generate kinematical variables describing an initial-state g->qqbar
C...splitting.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/

      INTEGER NTT,NTE1,NTE2
      DATA NTT/0/,NTE1/0/,NTE2/0/


      IF (MHAR(102).LT.0) RETURN

      QEXDIS=((MSTA(1).EQ.3.AND.IO.EQ.0.AND.MHAR(120).GT.0).OR.
     $     (MSTA(1).EQ.2.AND.IO.EQ.0.AND.
     $     XQ2.GT.0.0.AND.MHAR(120).GT.0))

      IR=INQ(IRP)
      IT=IRP+5-MAXPAR

      IF (IRAD(ID).EQ.10000+IRP) THEN
        PT2IN(ID)=PT2SAV(IT)
        IRAD(ID)=IRASAV(IT)
        AEX1(ID)=A1SAVE(IT)
        AEX3(ID)=A3SAVE(IT)
        BX1(ID)=B1SAVE(IT)
        BX3(ID)=B3SAVE(IT)
      ENDIF

      NPREM=2
      IPREM(1)=IRP
      IPREM(2)=IR
      KQ=IDO(IRP)
      KF=K(IT,2)
      RMQ=ULMASS(KQ)
      DMQ2=RMQ**2
      IT=IRP+5-MAXPAR
      IDIR=IRDIR(IT)
      PM=P(IT,4)+IDIR*P(IT,3)
      PT2CUT=MAX(PARA(3)**2,PT2IN(ID))/PHAR(103)
      IF (QEXDIS) PT2CUT=MAX(PARA(3)**2+SNGL(DMQ2),PT2IN(ID))/PHAR(103)

      IF (NPTOT.EQ.0) THEN
        DO 10 I=1,IPART
          IPTOT(I)=I
 10     CONTINUE
        NPTOT=IPART
      ENDIF

      NPSTQ=0
      DO 20 I=1,NPTOT
        IF (INO(IPTOT(I)).EQ.0) THEN
          IF (INQ(IPTOT(I)).GE.0) GOTO 20
          IF (K(-INQ(IPTOT(I)),3).LE.2) GOTO 20
        ENDIF
        NPSTQ=NPSTQ+1
        IPSTQ(NPSTQ)=IPTOT(I)
 20   CONTINUE
      IF (MSTA(1).NE.2.OR.IDI(IRP).GT.IPART)
     $     CALL ARPADD(-IDI(IRP),NPSTQ,IPSTQ)

      QEXDY=((MHAR(120).GT.0.AND.NPSTQ.EQ.1.AND.IPSTQ(1).EQ.MAXPAR-2)
     $     .OR.(MHAR(124).EQ.2.AND.
     $     ((NPSTQ.EQ.1.AND.IPSTQ(1).EQ.MAXPAR-2).OR.NPSTQ.GT.1)))

      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NPREM,IPREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)

      DSTOT=(DER+DEQ)**2-(DZR+DZQ)**2-(DYR+DYQ)**2-(DXR+DXQ)**2
      DMS2=DMQ**2

      XX=1.0-(DER+IDIR*DZR)/PM
      IF (QEXDY) XX=DMS2/DSTOT
      IF (QEXDIS) XX=X

      PT2MX=MIN(REAL(((DSTOT+DMQ2-DMS2)**2)/(4.0*DSTOT)-DMQ2),PT2LST)
      SMT2MX=PT2MX+DMQ2
      SMT2CT=PT2CUT+DMQ2
      
      IF (QEXDIS) PT2MX=PT2MX+DMQ2
      
      IF (PT2MX.LE.PT2CUT) GOTO 900

      IF (QEXDIS) THEN
        SQ2MAX=0.5*(XQ2+PT2MX)
        SQ2MIN=PT2CUT/
     $       ((0.5+SQRT(MAX(0.25-PT2CUT*X/(XQ2*(1.0-X)),0.0)))*(1.0-X))
      ELSE
        SQ2MAX=DSTOT-DMQ2-DMS2
        SQ2MIN=0.5*(DSTOT-DMQ2-DMS2-
     $       SQRT((DSTOT-DMQ2-DMS2)**2-4.0*(DMQ2*DMS2+PT2CUT*DSTOT)))
      ENDIF
      SQ2MIN=MAX(SQ2MIN,REAL(DMQ2)+PHAR(109))
      IF (ABS(KQ).EQ.4) SQ2MIN=MAX(SQ2MIN,2.56+PHAR(109))

      XNUMFL=MAX(ARNOFL(SQRT(SQ2MAX),MAX(5,MSTA(15))),3.0)
      ALPHA0=12.0*PARU(1)/(33.0-2.0*XNUMFL)

      IF (MHAR(127).EQ.0) THEN
        STRA0=ARSTRA(KF,KQ,XX,1.0,SQ2MAX)
        IF (STRA0.LE.0.0) THEN
          GOTO 900
        ENDIF
        IF (MHAR(118).GT.0) THEN
          STRA0=STRA0*REAL(MHAR(118))
        ELSEIF (MHAR(118).LT.0) THEN
          STRA0=2.0*STRA0/(1.0-XX)
          IF (ABS(KQ).GE.4) STRA0=STRA0*ABS(REAL(MHAR(118)))
        ELSE
          STRA0=MAX(STRA0,ARSTRA(KF,KQ,XX,1.0,SQ2MIN))
        ENDIF
      ELSE
        STRA0=ARSTRA(KF,KQ,XX,1.0,REAL(MHAR(127))*SMT2MX)
        IF (STRA0.LE.0.0) THEN
          GOTO 900
        ENDIF
        STRA0=MAX(STRA0,ARSTRA(KF,KQ,XX,1.0,REAL(MHAR(127))*SMT2CT))
      ENDIF

      C=PHAR(104)*ALPHA0*STRA0/PARU(1)
      ZINT=1.0-XX
      CN=1.0/(C*ZINT)
      XLAM2=(PARA(1)**2)/PHAR(103)
      IF (QEXDY) THEN
        SQARG=1.0-4.0*(PT2CUT+DMQ2)*DSTOT/((DSTOT+DMQ2-DMS2)**2)
        XIINT=LOG((1.0+SQRT(SQARG))/(1.0-SQRT(SQARG)))
        CN=1.0/(C*XIINT)
      ELSEIF (QEXDIS) THEN
        CY=(1.0-XY)/(1.0+(1.0-XY)**2)
        CQ=0.125+0.25*CY
        C=PHAR(104)*0.25*ALPHA0*STRA0*CQ/PARU(1)
        THEMAX=PT2MX
        YINT=4.0*LOG(SQRT(PT2MX/PT2CUT)+SQRT(PT2MX/PT2CUT-1.0))
        CN=1.0/(YINT*C)
      ENDIF

 100  IF (PT2MX.LE.PT2CUT) GOTO 900
      ARG=RLU(IDUM)
      IF (LOG(ARG)*CN.LT.
     $     LOG(LOG(PT2CUT/XLAM2)/LOG(PT2MX/XLAM2))) GOTO 900
      PT2MX=XLAM2*(PT2MX/XLAM2)**(ARG**CN)

      IF (QEXDIS) THEN
        YMAX=2.0*LOG(SQRT(THEMAX/PT2MX)+SQRT(THEMAX/PT2MX-1.0))
        Y=(RLU(IDUM)*2.0-1.0)*YMAX
        ZQ=1.0/(1.0+EXP(-Y))
        IF (MHAR(102).EQ.2) THEN
          Z=XQ2*ZQ*(1.0-ZQ)/(PT2MX+XQ2*ZQ*(1.0-ZQ))
        ELSE
          Z=ZQ*(1.0-ZQ)*XQ2/PT2MX
        ENDIF
        IF (Z.LE.X.OR.Z.GE.1.0) GOTO 100
        SQ2=PT2MX/
     $     ((0.5+SQRT(MAX(0.25-PT2MX*Z/(XQ2*(1.0-Z)),0.0)))*(1.0-Z))
        W=2.0*YMAX/YINT
        W=W*(Z*(1.0-Z)*(Z**2+(1.0-Z)**2)*(ZQ**2+(1.0-ZQ)**2)+
     $       16.0*((Z*(1.0-Z))**2)*ZQ*(1.0-ZQ)*CY)/CQ
        IF (MSTA(19).EQ.2) THEN
          W=W*MIN(1.0,LOG(PT2MX/XLAM2)/LOG(PARA(21)*XQ2/XLAM2))
          SQ2=MAX(SQ2,XQ2)
        ENDIF
        XI=ZQ
        IF (XI.GE.1.0) GOTO 100
        IF (SQRT((PT2MX+DMQ2*(1.0-XI)+DMS2*XI)/(XI*(1.0-XI))).GE.
     $       SQRT(DSTOT)-DMR) GOTO 100
      ELSEIF (QEXDY) THEN
        XIMAX=0.5*(DSTOT+DMQ2-DMS2+
     $       SQRT((DSTOT+DMQ2-DMS2)**2-4.0*(PT2MX+DMQ2)*DSTOT))/DSTOT
        XIMIN=0.5*(DSTOT+DMQ2-DMS2-
     $       SQRT((DSTOT+DMQ2-DMS2)**2-4.0*(PT2MX+DMQ2)*DSTOT))/DSTOT
        XI=XIMIN*((XIMAX/XIMIN)**RLU(0))
        SH=(PT2MX+DMQ2*(1.0-XI)+DMS2*XI)/(XI*(1.0-XI))
        TH=-(PT2MX+DMS2*XI)/(1.0-XI)
        UH=DMS2+DMQ2-SH-TH
        SQ2=-TH
        IF (SQRT(DSTOT).LE.SQRT(SH)+DMR) GOTO 100
        Z=DMS2/SH
        IF (MHAR(124).GT.0) THEN
          PMR=ARPCMS(REAL(DSTOT),REAL(DMR),SQRT(SH))
          PMR0=ARPCMS(REAL(DSTOT),REAL(DMR),REAL(DMQ))
          Z=XX/(1.0-(1.0-XX)*PMR/PMR0)
        ENDIF
        W=0.25*PT2MX/(PT2MX+XI*DMS2)
        IF (MHAR(120).EQ.1) W=W*Z
        IF (MHAR(125).EQ.940801) W=W*2.0
        W=W*LOG(XIMAX/XIMIN)/XIINT
        W=W*(SH**2+TH**2+2.0*DMS2*UH)/(SH**2)
      ELSE
        Z=XX+RLU(0)*(1.0-XX)
        W=(Z**2+(1.0-Z)**2)*0.25
        SQ2=PT2MX/(1.0-Z)
        XI=(DMQ2+PT2MX)/(XX*(1.0/Z-1.0)*DSTOT)
        IF (MHAR(124).EQ.1) THEN
          AARG=DSTOT*XX*(1.0-Z)+DMS2*(Z-XX)
          BARG=(DMS2-DMQ2)*Z*(1.0-XX)-AARG
          CARG=(DMQ2+PT2MX)*(1.0-XX)*Z
          SQARG=BARG**2-4.0*AARG*CARG
          IF (SQARG.LT.0.0) GOTO 100
          XI=0.5*(-BARG-SQRT(SQARG))/AARG
          IF (XI.LE.0.0) GOTO 100
        ELSEIF (MHAR(124).EQ.3) THEN
          XI=(SQ2+DMQ2)/((1.0-(1.0-XX/Z)/(1.0-XX))*(DSTOT-DMS2))
        ENDIF
        IF (XI.GE.1.0) GOTO 100
        IF (SQRT((PT2MX+DMQ2*(1.0-XI)+DMS2*XI)/(XI*(1.0-XI))).GE.
     $       SQRT(DSTOT)-DMR) GOTO 100
      ENDIF

      SQ2=MAX(SQ2,SQ2MIN)
      IF (MHAR(127).EQ.0) THEN
        STRA=ARSTRA(KF,KQ,XX,Z,SQ2)
      ELSE
        SMT2MX=PT2MX+DMQ2
        IF (QEXDIS) SMT2MX=PT2MX
        STRA=ARSTRA(KF,KQ,XX,Z,REAL(MHAR(127))*SMT2MX)
      ENDIF
      IF (STRA.LT.0.0) GOTO 100
      W=W*STRA/STRA0

      IF (W.LT.RLU(IDUM)) GOTO 100

      IF (QEXDIS) THEN
        YQ=ZQ
        XA=0.125*(1.0+(1.0-XY)**2)*(Z**2+(1.0-Z)**2)*
     $       (ZQ**2+(1.0-ZQ)**2)/(ZQ*(1.0-ZQ))+2.0*(1.0-XY)*Z*(1.0-Z)
        XB=0.5*XY*SQRT((1.0-XY)*Z*(1.0-Z)/(ZQ*(1.0-ZQ)))*
     $       (1.0-2.0/XY)*(1.0-2.0*ZQ)*(1.0-2.0*Z)
        XC=(1.0-XY)*Z*(1.0-Z)
        ABC=ABS(XA)+ABS(XB)+ABS(XC)
 200    PHI=PARU(2)*RLU(IDUM)
        IF (XA+XB*COS(PHI)+XC*COS(2.0*PHI).LT.RLU(IDUM)*ABC) GOTO 200
      ELSE
        YQ=XI
        PHI=PARU(2)*RLU(IDUM)
      ENDIF

      NTT=NTT+1
      IF (W.GT.1.0) THEN
        NTE1=NTE1+1
        WRITE(0,*) REAL(NTE1)/REAL(NTT),REAL(NTE2)/REAL(NTT)
      ENDIF
      IF (STRA.GT.STRA0) THEN
        NTE2=NTE2+1
      ENDIF

      IF (QEXDIS) PT2MX=PT2MX-DMQ2

      IF (PT2MX*PHAR(103).GT.PT2IN(ID)) THEN
        PT2SAV(IT)=PT2IN(ID)
        IRASAV(IT)=IRAD(ID)
        A1SAVE(IT)=AEX1(ID)
        A3SAVE(IT)=AEX3(ID)
        B1SAVE(IT)=BX1(ID)
        B3SAVE(IT)=BX3(ID)
        PT2GG(IRP)=PT2MX
        PT2IQQ(IT)=PT2MX
        PT2IN(ID)=PT2MX*PHAR(103)
        IRAD(ID)=10000+IRP
        AEX1(ID)=YQ
        AEX3(ID)=YQ
        BX1(ID)=PHI
        BX3(ID)=PHI
      ENDIF

      RETURN

 900  PT2GG(IRP)=0.0
      RETURN

C**** END OF ARGIG2 ****************************************************
      END
C***********************************************************************
C $Id: aradig.f,v 3.13 1995/08/15 09:08:44 lonnblad Exp $
CDECK  ID>, ARADIG.
      SUBROUTINE ARADIG(ID)

C...Ariadne RADiater Initial state G->qq

C...Perform an initial-state g->qqbar splitting.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARSTRF/ KFSAVE(2),XSAVE(2),XQ2SAV(2),XPQSAV(2,-6:6)
      SAVE /ARSTRF/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/


      IF (MHAR(120).NE.0) THEN
        CALL ARADG2(ID)
        RETURN
      ENDIF

      IF (ABS(MSTA(33)).EQ.1.AND.MSTA(1).EQ.3.AND.IO.EQ.1) THEN
        LST(24)=3
        QEXDIS=.TRUE.
      ELSE
        QEXDIS=.FALSE.
      ENDIF
      IRP=IRAD(ID)-10000
      IT=IRP+5-MAXPAR
      IR=INQ(IRP)
      NPREM=2
      IPREM(1)=IRP
      IPREM(2)=IR
      IDIR=IRDIR(IT)
      DIR=IDIR
      KQ=IDO(IRP)
      RMQ2=ULMASS(KQ)
      PM=P(IT,4)+IDIR*P(IT,3)
      DMT2Q=PT2IQQ(IT)
      DPT2Q=DMT2Q-RMQ2**2
      YQ=AEX1(ID)
      PHIQ=BX1(ID)

      IF (MHAR(103).GT.0) THEN
        NPSTQ=0
        DO 110 I=1,NPTOT
          IF (INO(IPTOT(I)).NE.0) THEN
            NPSTQ=NPSTQ+1
            IPSTQ(NPSTQ)=IPTOT(I)
          ENDIF
 110    CONTINUE
        CALL ARPADD(-IDI(IRP),NPSTQ,IPSTQ)
      ELSE
        NPSTQ=1
        IPSTQ(1)=IDI(IRP)
      ENDIF

      CALL ARROBO(0.0,-PHIQ,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NPREM,IPREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)
      CALL ARSUME(0,DXT,DYT,DZT,DET,DMT,NPREM,IPREM)
        CALL ARSUME(1,DXT,DYT,DZT,DET,DMT,NPSTQ,IPSTQ)
      B0P=DEQ-IDIR*DZQ
      B0M=DEQ+IDIR*DZQ
      BRP=DER-IDIR*DZR
      BRM=DER+IDIR*DZR

      XX=1.0-BRM/PM
      IF (QEXDIS) XX=X

      IF (MHAR(119).GT.0) THEN
        Z=YQ
        DRM=(1.0-XX/Z)*PM
        DR=BRM
        CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $       DIR*(DRM**2-DR**2)/(DRM**2+DR**2),NPREM,IPREM)
        BPH=B0P+BRP-BRP*BRM/DRM
        BMH=B0M+BRM-DRM

        DXQ2=SQRT(DPT2Q)
        RMTQ=SQRT(DMT2Q)
        RMTS=SQRT(DMQ**2+DYQ**2+(DXQ-DXQ2)**2)
        STOT=BPH*BMH
        DZS=ARZCMS(STOT,RMTS,RMTQ)
        DZSP=SQRT(DZS**2+(DXQ-DXQ2)**2-DXQ**2)
        DPSP=DZSP+SQRT(DZSP**2+DXQ**2+DYQ**2+DMQ**2)
        DP=B0P
        CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $       DIR*(DP**2-DPSP**2)/(DP**2+DPSP**2),NPSTQ,IPSTQ)
        DXZQ=-DIR*SQRT(DXQ**2+DZSP**2)
        IF (ABS(DXZQ).LE.ABS(DXQ-DXQ2)) THEN
          CALL ARERRM('ARADIG',9,0)
          GOTO 900
        ENDIF
        CALL ARROBO(REAL(ASIN((DXQ-DXQ2)/DXZQ)-ASIN(DXQ/DXZQ)),
     $     0.0,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)

        IPART=IPART+1
        IQ2=IPART
        IFL(IQ2)=-KQ
        IF (MSTA(30).LT.2.OR.MSTA(30).EQ.3) THEN
          QEX(IQ2)=.FALSE.
          XPMU(IQ2)=0.0
          XPA(IQ2)=0.0
        ELSE
          QEX(IQ2)=.TRUE.
          IF (PARA(14).GE.0) THEN
            XPMU(IQ2)=SQRT(XQ2SAV(IT))*PARA(14)
          ELSE
            XPMU(IQ2)=ABS(PARA(14))
          ENDIF
          XPA(IQ2)=PARA(15)
        ENDIF
        QEX(IQ2)=.FALSE.
        QQ(IQ2)=.TRUE.
        INO(IQ2)=IO
        INQ(IQ2)=0
        BP(IQ2,5)=RMQ2
        BP(IQ2,1)=DXQ2
        BP(IQ2,2)=0.0
        BP(IQ2,3)=DIR*DZS
        BP(IQ2,4)=SQRT(RMQ2**2+DZS**2+DPT2Q)
        NPSTQ=NPSTQ+1
        IPSTQ(NPSTQ)=IQ2

        CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)
        DM=DEQ-IDIR*DZQ
        DMH=BMH
        CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $       DIR*(DMH**2-DM**2)/(DMH**2+DM**2),NPSTQ,IPSTQ)

        CALL ARSUME(0,DXU,DYU,DZU,DEU,DMU,NPREM,IPREM)
        CALL ARSUME(1,DXU,DYU,DZU,DEU,DMU,NPSTQ,IPSTQ)

        GOTO 100

      ENDIF

      BXQ=SQRT(DPT2Q)
      BYQ=0.0
      BZQ=SQRT(DMT2Q)*SINH(YQ)
      BEQ=SQRT(DMT2Q)*COSH(YQ)
      BQP=BEQ-IDIR*BZQ
      BQM=BEQ+IDIR*BZQ

      BM0D2=DMQ**2+(DXQ-BXQ)**2+(DYQ-BYQ)**2
      BRQP=B0P+BRP-BQP
      BRQM=B0M+BRM-BQM

      BA=(BRQP*BRQM+BRP*BRM-BM0D2)/(2.0*BRQM*BRP)
      BB=BRM*BRQP/(BRP*BRQM)

      IF (BA**2.LT.BB.OR.BA.LE.0.0.OR.BRQP.LE.0.0.OR.BRQM.LE.0.0) THEN
        CALL ARERRM('ARADIG',9,0)
        GOTO 900
      ENDIF

      DAR=BA-SQRT(BA**2-BB)

      IF (DAR.LE.1.0) CALL ARERRM('ARADIG',9,0)

      DXZQ=SIGN(SQRT(DXQ**2+DZQ**2),DZQ)
      IF (ABS(DXZQ).LE.ABS(DXQ-BXQ)) THEN
        CALL ARERRM('ARADIG',9,0)
        GOTO 900
      ENDIF

C...Boost remnant system to correct rapidity
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $     -DIR*(DAR**2-1.0D0)/(DAR**2+1.0D0),NPREM,IPREM)

C...Rotate struck system to right pt
      CALL ARROBO(REAL(ASIN((DXQ-BXQ)/DXZQ)-ASIN(DXQ/DXZQ)),
     $     0.0,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)

C...Boost struck system to right rapidity
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)
      DPP2=(BRP*(1.0-DAR)+B0P-BQP)**2
      DPP02=(DZQ-IDIR*DEQ)**2
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,-DIR*(DPP2-DPP02)/(DPP2+DPP02),
     $     NPSTQ,IPSTQ)


C...Insert new quark
      IPART=IPART+1
      IQ2=IPART
      IFL(IQ2)=-KQ
      IF (MSTA(30).LT.2.OR.MSTA(30).EQ.3) THEN
        QEX(IQ2)=.FALSE.
        XPMU(IQ2)=0.0
        XPA(IQ2)=0.0
      ELSE
        QEX(IQ2)=.TRUE.
        IF (PARA(14).GE.0) THEN
          XPMU(IQ2)=SQRT(XQ2SAV(IT))*PARA(14)
        ELSE
          XPMU(IQ2)=ABS(PARA(14))
        ENDIF
        XPA(IQ2)=PARA(15)
      ENDIF
CERROR      QEX(IQ2)=.FALSE.
      QQ(IQ2)=.TRUE.
      INO(IQ2)=IO
      INQ(IQ2)=0
      BP(IQ2,5)=RMQ2
      BP(IQ2,4)=BEQ
      BP(IQ2,3)=BZQ
      BP(IQ2,2)=BYQ
      BP(IQ2,1)=BXQ
      CALL AROBO1(0.0,PHIQ,0.0D0,0.0D0,0.0D0,IQ2)

C...Insert new remnant
 100  IPART=IPART+1
      IR=IPART
      IFL(IR)=INO(IRP)
      QEX(IR)=QEX(IRP)
      QQ(IR)=.TRUE.
      INO(IR)=0
      INQ(IR)=0
      XPMU(IR)=XPMU(IRP)
      XPA(IR)=XPA(IRP)
      BP(IR,1)=BP(IRP,1)
      BP(IR,2)=BP(IRP,2)
      BP(IR,3)=BP(IRP,3)
      BP(IR,4)=BP(IRP,4)
      BP(IR,5)=BP(IRP,5)
      QQ(IRP)=.FALSE.

C...Fix new string and dipole
      IDIPS=IDIPS+1
      ISTRS=ISTRS+1
      CALL ARCRDI(IDIPS,IQ2,IR,ISTRS,.FALSE.)
      IDI(IQ2)=0
      IDO(IR)=0
      IPF(ISTRS)=IQ2
      IPL(ISTRS)=IR
      IFLOW(ISTRS)=SIGN(1,-KQ)
      CALL ARCOLI(IDIPS,ID)

C...Reset all dipole flags
      DO 200 IDD=1,IDIPS
        QDONE(IDD)=.FALSE.
 200  CONTINUE

 900  CALL ARROBO(0.0,PHIQ,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)

      RETURN

C**** END OF ARADIG ****************************************************
      END
C***********************************************************************
C $Id: aradig.f,v 3.13 1995/08/15 09:08:44 lonnblad Exp $
CDECK  ID>, ARADG2.
      SUBROUTINE ARADG2(ID)

C...Ariadne RADiater initial state G->qq

C...Perform an initial-state g->qqbar splitting.


      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARSTRF/ KFSAVE(2),XSAVE(2),XQ2SAV(2),XPQSAV(2,-6:6)
      SAVE /ARSTRF/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/


      IF (ABS(MSTA(33)).EQ.1.AND.MSTA(1).EQ.3.AND.IO.EQ.1) THEN
        LST(24)=3
      ENDIF
      IRP=IRAD(ID)-10000
      IT=IRP+5-MAXPAR
      IR=INQ(IRP)
      NPREM=2
      IPREM(1)=IRP
      IPREM(2)=IR
      KQ=IDO(IRP)
      RMQ=ULMASS(KQ)
      DMQ2=RMQ**2
      DPT2Q=PT2IQQ(IT)
      XI=AEX1(ID)
      PHIQ=BX1(ID)

      NPSTQ=0
      DO 110 I=1,IPART
        IF (INO(I).EQ.0) THEN
          IF (INQ(I).GE.0) GOTO 110
          IF (K(-INQ(I),3).LE.2) GOTO 110
        ENDIF
        NPSTQ=NPSTQ+1
        IPSTQ(NPSTQ)=I
 110  CONTINUE
      IF (MSTA(1).NE.2.OR.IDI(IRP).GT.IPART)
     $     CALL ARPADD(-IDI(IRP),NPSTQ,IPSTQ)

      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NPREM,IPREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)

      DBEX=(DXR+DXQ)/(DER+DEQ)
      DBEY=(DYR+DYQ)/(DER+DEQ)
      DBEZ=(DZR+DZQ)/(DER+DEQ)

      CALL ARROBO(0.0,0.0,-DBEX,-DBEY,-DBEZ,NPSTQ,IPSTQ)
      CALL ARROBO(0.0,0.0,-DBEX,-DBEY,-DBEZ,NPREM,IPREM)
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NPREM,IPREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)
      DSTOT=(DER+DEQ)**2-(DZR+DZQ)**2-(DYR+DYQ)**2-(DXR+DXQ)**2
      PHI=ULANGL(REAL(DXQ),REAL(DYQ))
      THE=ULANGL(REAL(DZQ),REAL(SQRT(DXQ**2+DYQ**2)))
      CALL ARROBO(0.0,-PHI,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)
      CALL ARROBO(0.0,-PHI,0.0D0,0.0D0,0.0D0,NPREM,IPREM)
      CALL ARROBO(-THE,0.0,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)
      CALL ARROBO(-THE,0.0,0.0D0,0.0D0,0.0D0,NPREM,IPREM)
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NPREM,IPREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)

      DMS2=DMQ**2

      DSH=(DPT2Q+DMQ2*(1.0-XI)+DMS2*XI)/(XI*(1.0-XI))

      DPMR=ARPCMS(REAL(DSTOT),REAL(DMR),REAL(SQRT(DSH)))
      DPMR0=DER-DZR
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $     (DPMR0**2-DPMR**2)/(DPMR0**2+DPMR**2),NPREM,IPREM)

      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,-DZQ/DEQ,NPSTQ,IPSTQ)
      CALL ARROBO(0.0,PHI-PHIQ,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)
      CALL ARROBO(0.0,0.0,-DSQRT(DPT2Q)/DSQRT(DPT2Q+DMQ**2),
     $     0.0D0,0.0D0,NPSTQ,IPSTQ)
      DPPTOT=SQRT(DSH)
      DPPQ=(1.0-XI)*DPPTOT
      DPPQ2=XI*DPPTOT
      DPPQ02=DPT2Q+DMQ**2
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $     (DPPQ**2-DPPQ02)/(DPPQ**2+DPPQ02),NPSTQ,IPSTQ)
      
C...Insert new quark
      IPART=IPART+1
      IQ2=IPART
      IFL(IQ2)=-KQ
      IF (MSTA(30).LT.2.OR.MSTA(30).EQ.3) THEN
        QEX(IQ2)=.FALSE.
        XPMU(IQ2)=0.0
        XPA(IQ2)=0.0
      ELSE
        QEX(IQ2)=.TRUE.
        IF (PARA(14).GE.0) THEN
          XPMU(IQ2)=SQRT(XQ2SAV(IT))*PARA(14)
        ELSE
          XPMU(IQ2)=ABS(PARA(14))
        ENDIF
        XPA(IQ2)=PARA(15)
      ENDIF
CERROR      QEX(IQ2)=.FALSE.
      QQ(IQ2)=.TRUE.
      INO(IQ2)=IO
      INQ(IQ2)=0
      BP(IQ2,1)=SQRT(DPT2Q)
      BP(IQ2,2)=0.0
      BP(IQ2,3)=0.5*(DPPQ2-(DPT2Q+DMQ2)/DPPQ2)
      BP(IQ2,4)=0.5*(DPPQ2+(DPT2Q+DMQ2)/DPPQ2)
      BP(IQ2,5)=RMQ

      NPSTQ=NPSTQ+1
      IPSTQ(NPSTQ)=IQ2

      CALL ARROBO(0.0,PHIQ-PHI,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)

      DZ=ARZCMS(REAL(DSTOT),REAL(SQRT(DSH)),REAL(DMR))
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,DZ/SQRT((DZ**2+DSH)),NPSTQ,IPSTQ)

C...Insert new remnant
 100  IPART=IPART+1
      IR=IPART
      IPREM(1)=IR
      IFL(IR)=INO(IRP)
      QEX(IR)=QEX(IRP)
      QQ(IR)=.TRUE.
      INO(IR)=0
      INQ(IR)=0
      XPMU(IR)=XPMU(IRP)
      XPA(IR)=XPA(IRP)
      BP(IR,1)=BP(IRP,1)
      BP(IR,2)=BP(IRP,2)
      BP(IR,3)=BP(IRP,3)
      BP(IR,4)=BP(IRP,4)
      BP(IR,5)=BP(IRP,5)
      QQ(IRP)=.FALSE.

C...Fix new string and dipole
      IDIPS=IDIPS+1
      ISTRS=ISTRS+1
      CALL ARCRDI(IDIPS,IQ2,IR,ISTRS,.FALSE.)
      IDI(IQ2)=0
      IDO(IR)=0
      IPF(ISTRS)=IQ2
      IPL(ISTRS)=IR
      IFLOW(ISTRS)=SIGN(1,-KQ)
      CALL ARCOLI(IDIPS,ID)

C...Reset all dipole flags
      DO 200 IDD=1,IDIPS
        QDONE(IDD)=.FALSE.
 200  CONTINUE

      CALL ARROBO(THE,PHI,DBEX,DBEY,DBEZ,NPSTQ,IPSTQ)
      CALL ARROBO(THE,PHI,DBEX,DBEY,DBEZ,NPREM,IPREM)

      CALL ARCHEM(0)

      IF (IO.EQ.1) THEN
        PHAR(121)=0.5*LOG(MAX(BP(IQ2,4)+BP(IQ2,3),1.0D-30)/
     $       MAX(BP(IQ2,4)-BP(IQ2,3),1.0D-30))
        PHAR(122)=BP(IQ2,1)**2+BP(IQ2,2)**2
      ENDIF

      RETURN

C**** END OF ARADG2 ****************************************************
      END
C***********************************************************************
C $Id: arearr.f,v 3.10 1995/11/30 10:15:21 leif Exp $
CDECK  ID>, ARCOLI.
      SUBROUTINE ARCOLI(ID,IDR)

C...Ariadne subroutine assign COLour Index

C...Assigns a colour index to dipole ID, requiring it to be different
C...IDR if IDR > 0

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/


      ICOLI(ID)=0
      IF (PARA(26).LE.1.0.OR.QEM(ID).OR.MSTA(35).EQ.0) RETURN
      NCOL=INT(PARA(26)+0.5)
      IDP=IDI(IP1(ID))
      IDN=IDO(IP3(ID))
 100  ICOL=INT(RLU(0)*REAL(NCOL))+1
      ICOLI(ID)=ICOL
      IF (IDR.LT.0.AND.(MSTA(35).EQ.1.OR.MSTA(35).EQ.2)) THEN
        ICOLI(ID)=ICOL-1000*IDR
      ENDIF
      IF (IDR.GT.0) THEN
        IF ((MHAR(107).GE.3.OR.MHAR(107).LT.0).AND.
     $       PT2LST.GT.ABS(PHAR(112))) THEN
          ICOLI(ID)=ICOL+1000*ISTRS
        ELSE
          ICOLI(ID)=ICOL+1000*(ICOLI(IDR)/1000)
          IF (MHAR(107).GT.1.OR.(MHAR(107).EQ.1.AND.IO.EQ.1)) THEN
            IF (ICOLI(IDR).EQ.ICOLI(ID)) GOTO 100
          ENDIF
        ENDIF
      ENDIF
      IF (IDN.GT.0.AND.(.NOT.QEM(IDN))) THEN
        IF (ICOLI(IDN).EQ.ICOLI(ID)) GOTO 100
      ENDIF
      IF (IDP.GT.0.AND.(.NOT.QEM(IDP))) THEN
        IF (ICOLI(IDP).EQ.ICOLI(ID)) GOTO 100
      ENDIF

      RETURN

C**** END OF ARCOLI ****************************************************
      END
C***********************************************************************
C $Id: arearr.f,v 3.10 1995/11/30 10:15:21 leif Exp $
CDECK  ID>, ARSWAP.
      SUBROUTINE ARSWAP(ID1,ID2)

C...ARiadne subroutine SWAP partons

C...Get the colour neighbour ICON and anti-colour neighbour ICBN of
C...parton I and the respective connecting dipoles IDCON and IDCBN.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
      
      SAVE /ARLIST/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/

      QDONE(ID1)=.FALSE.
      QDONE(ID2)=.FALSE.
      QDUMP=.FALSE.
      PT2GG(MAXPAR-3)=-1.0
      PT2GG(MAXPAR-4)=-1.0
      NPTOT=0
      I1=IP1(ID1)
      I2=IP1(ID2)

      IS1=ISTR(ID1)
      IS2=ISTR(ID2)
      MHAR(135)=MHAR(135)+1
      IF (IS1.EQ.IS2) MHAR(136)=MHAR(136)+1
      IF (IFLOW(IS1)*IFLOW(IS2).LT.0) THEN
        IF (IFLOW(IS2).LT.0) THEN
          CALL AREVST(IS2)
        ELSE
          CALL AREVST(IS1)
        ENDIF
      ENDIF

      IP1(ID1)=I2
      IP1(ID2)=I1
      IDO(I1)=ID2
      IDO(I2)=ID1
      SDIP(ID1)=ARMAS2(I2,IP3(ID1))
      SDIP(ID2)=ARMAS2(I1,IP3(ID2))

      IF (IS1.NE.IS2) THEN
        IF (IFLOW(IS1).NE.2.AND.IFLOW(IS2).NE.2) THEN
          IL=IPL(IS1)
          IPL(IS1)=IPL(IS2)
          IPL(IS2)=IL
          I=IPF(IS1)
 100      ISTR(IDO(I))=IS1
          I=IP3(IDO(I))
          IF (I.NE.IPL(IS1)) GOTO 100
          I=IPF(IS2)
 110      ISTR(IDO(I))=IS2
          I=IP3(IDO(I))
          IF (I.NE.IPL(IS2)) GOTO 110
          CALL ARCHFL
        ELSEIF(IFLOW(IS1).EQ.2.AND.IFLOW(IS2).NE.2) THEN
          I=IPF(IS2)
 120      ISTR(IDO(I))=IS2
          I=IP3(IDO(I))
          IF (I.NE.IPL(IS2)) GOTO 120
          CALL ARREMS(IS1)
          CALL ARCHFL
        ELSEIF(IFLOW(IS1).NE.2.AND.IFLOW(IS2).EQ.2) THEN
          I=IPF(IS1)
 130      ISTR(IDO(I))=IS1
          I=IP3(IDO(I))
          IF (I.NE.IPL(IS1)) GOTO 130
          CALL ARREMS(IS2)
          CALL ARCHFL
        ELSE
          IPF(IS1)=I1
          IPL(IS1)=IP1(IDI(I1))
          ISTR(IDI(I1))=IS1
          I=IPF(IS1)
 140      ISTR(IDO(I))=IS1
          I=IP3(IDO(I))
          IF (I.NE.IPL(IS1)) GOTO 140
          CALL ARREMS(IS2)
          CALL ARCHFL
        ENDIF
        RETURN
      ENDIF

      I=IPF(IS1)
      IR1=I1
      IR2=I2
 200  IF (I.EQ.IR1) IR1=0
      IF (I.EQ.IR2) IR2=0
      I=IP3(IDO(I))
      IF (I.NE.IPL(IS1).AND.I.NE.IPF(IS1)) GOTO 200
      IF (IFLOW(IS1).EQ.2.AND.I.EQ.IPF(IS1)) IPL(IS1)=IP1(IDI(I))
      IF (I.EQ.IR1) IR1=0
      IF (I.EQ.IR2) IR2=0

      IF (MAX(IR1,IR2).EQ.0) THEN
        CALL ARCHFL
        RETURN
      ENDIF

      IF (ISTRS+1.GT.MAXSTR) CALL ARERRM('ARSWAP',8,0)

      ISTRS=ISTRS+1
      IS1=ISTRS
      IPF(IS1)=MAX(IR1,IR2)
      I=IPF(IS1)
      IPL(IS1)=IP1(IDI(I))
      ISTR(IDI(I))=IS1
      IFLOW(IS1)=2
 210  ISTR(IDO(I))=IS1
      I=IP3(IDO(I))
      IF (I.NE.IPL(IS1)) GOTO 210

      CALL ARCHFL
      RETURN

C**** END OF ARSWAP ****************************************************
      END
C***********************************************************************
C $Id: arearr.f,v 3.10 1995/11/30 10:15:21 leif Exp $
CDECK  ID>, ARCHFL.
      SUBROUTINE ARCHFL

C...ARiadne subroutine CHeck colour FLow 

C...Checks colour flow consistency in the dipole record

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/

      DIMENSION ICP(MAXPAR),ICD(MAXDIP)
      INXT(I)=IP3(IDO(I))


      DO 100 I=1,IPART
        ICP(I)=0
 100  CONTINUE
      DO 110 I=1,IDIPS
        ICD(I)=0
 110  CONTINUE
      NPC=0

      IF (ISTRS.LE.0.OR.ISTRS.GT.MAXSTR) CALL ARERRM('ARCHFL',5,0)
C...Loop over all strings in dipole record
      DO 200 IS=1,ISTRS

C...Loop over all particles in each string
        I=IPF(IS)
 210    NPC=NPC+1
        IF (NPC.GT.IPART) CALL ARERRM('ARCHFL',5,0)
        IF (I.LE.0.OR.I.GT.IPART) CALL ARERRM('ARCHFL',5,0)
        IF (ICP(I).NE.0) CALL ARERRM('ARCHFL',5,0)
        ICP(I)=1
        IF (I.NE.IPL(IS)) THEN
          ID=IDO(I)
          IF (ID.LE.0.OR.ID.GT.IDIPS) CALL ARERRM('ARCHFL',5,0)
          IF (ICD(ID).NE.0) CALL ARERRM('ARCHFL',5,0)
          ICD(ID)=1
          I=IP3(ID)
          GOTO 210
        ENDIF
        IF (IFLOW(IS).EQ.2) THEN
          ID=IDO(I)
          IF (ID.LE.0.OR.ID.GT.IDIPS) CALL ARERRM('ARCHFL',5,0)
          IF (ICD(ID).NE.0) CALL ARERRM('ARCHFL',5,0)
          ICD(ID)=1
        ENDIF
 200  CONTINUE

      NT=1
      DO 300 I=1,IPART
        NT=NT*ICP(I)
 300  CONTINUE
      DO 310 I=1,IDIPS
        IF (.NOT.QEM(I)) NT=NT*ICD(I)
 310  CONTINUE

      IF (NT.EQ.0) CALL ARERRM('ARCHFL',5,0)
        
      RETURN

C**** END OF ARCHFL ****************************************************
      END
C***********************************************************************
C $Id: arearr.f,v 3.10 1995/11/30 10:15:21 leif Exp $
CDECK  ID>, AREARR.
      SUBROUTINE AREARR

C...Ariadne subroutine REARRange colour flow.

C...Reconnects partons to alternative colour flows if this decreases
C...total 'lambda'

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/


      IF (PARA(26).LE.1.0.OR.MSTA(35).EQ.0) RETURN
      DO 100 ID=1,IDIPS
        IF (QEM(ID)) GOTO 100
        IF (ICOLI(ID).EQ.0) CALL ARERRM('AREARR',32,0)
        SDIP(ID)=ARMAS2(IP1(ID),IP3(ID))
 100  CONTINUE

      DO 110 IS=1,ISTRS
        IF (IFLOW(IS).LT.0) CALL AREVST(IS)
 110  CONTINUE

 300  IX1SEL=0
      IX2SEL=0
      XLDIFF=0.0
      DO 200 ID1=1,IDIPS
        IF (QEM(ID1)) GOTO 200
        IA=IP1(ID1)
        IB=IP3(ID1)
        SAB=SDIP(ID1)
        AFAC=1.0
        BFAC=1.0
        IF (PHAR(107).GT.0.AND.ABS(IFL(IA)).GT.1000) AFAC=PHAR(107)
        IF (PHAR(107).GT.0.AND.ABS(IFL(IB)).GT.1000) BFAC=PHAR(107)
        ALA=0.0
        XMA=1.0
        ALB=0.0
        XMB=1.0
        IF (MHAR(106).EQ.1) THEN
          IF (QEX(IA)) THEN
            ALA=XPA(IA)
            XMA=XPMU(IA)
          ENDIF
          IF (QEX(IB)) THEN
            ALB=XPA(IB)
            XMB=XPMU(IB)
          ENDIF
        ENDIF
        SLAB=2.0*(LOG(SAB*AFAC*BFAC)+
     $       ALA*LOG(XMA)+ALB*LOG(XMB))/(2.0+ALA+ALB)
        DO 210 ID2=1,IDIPS
          IF (QEM(ID2)) GOTO 210
          IF (ID1.EQ.ID2) GOTO 210
          IF (ICOLI(ID1).NE.ICOLI(ID2)) GOTO 210
          IC=IP1(ID2)
          ID=IP3(ID2)
          SCD=SDIP(ID2)
          CFAC=1.0
          DFAC=1.0
          IF (PHAR(107).GT.0.AND.ABS(IFL(IC)).GT.1000) CFAC=PHAR(107)
          IF (PHAR(107).GT.0.AND.ABS(IFL(ID)).GT.1000) DFAC=PHAR(107)
          ALC=0.0
          XMC=1.0
          ALD=0.0
          XMD=1.0
          IF (MHAR(106).EQ.1) THEN
            IF (QEX(IC)) THEN
              ALC=XPA(IC)
              XMC=XPMU(IC)
            ENDIF
            IF (QEX(ID)) THEN
              ALD=XPA(ID)
              XMD=XPMU(ID)
            ENDIF
          ENDIF
          SAD=ARMAS2(IA,ID)
          SBC=ARMAS2(IB,IC)
          SLCD=2.0*(LOG(SCD*CFAC*DFAC)+
     $         ALC*LOG(XMC)+ALD*LOG(XMD))/(2.0+ALC+ALD)
          SLBC=2.0*(LOG(SBC*BFAC*CFAC)+
     $         ALC*LOG(XMC)+ALB*LOG(XMB))/(2.0+ALC+ALB)
          SLAD=2.0*(LOG(SAD*AFAC*DFAC)+
     $         ALA*LOG(XMA)+ALD*LOG(XMD))/(2.0+ALA+ALD)
          XLD=SLAB+SLCD-SLBC-SLAD
          IF (XLD.LE.XLDIFF) GOTO 210
          IF ((MHAR(106).EQ.-1.OR.MHAR(106).EQ.2).AND.
     $         MAX(SLAD,SLBC).GT.MIN(SLAB,SLCD)) GOTO 210
          IX1SEL=ID1
          IX2SEL=ID2
          XLDIFF=XLD
 210    CONTINUE
 200  CONTINUE
      IF (IX1SEL.EQ.0.OR.IX2SEL.EQ.0) RETURN
      CALL ARSWAP(IX1SEL,IX2SEL)
      GOTO 300

C**** END OF AREARR ****************************************************
      END

C***********************************************************************
C $Id: arputr.f,v 3.1 1995/08/13 17:29:15 lonnblad Exp $
CDECK  ID>, ARPUTR.
      SUBROUTINE ARPUTR(IH)

C...ARiadne subroutine PUT event Record on the stack

C...Stores the event record for later use

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      PARAMETER (MAXSTK=2)
      COMMON /ARSTAK/ BPP(MAXPAR,5,MAXSTK),IFLP(MAXPAR,MAXSTK),
     $                QEXP(MAXPAR,MAXSTK),QQP(MAXPAR,MAXSTK),
     $                IDIP(MAXPAR,MAXSTK),IDOP(MAXPAR,MAXSTK),
     $                INOP(MAXPAR,MAXSTK),INQP(MAXPAR,MAXSTK),
     $                XPMUP(MAXPAR,MAXSTK),XPAP(MAXPAR,MAXSTK),
     $                PT2GGP(MAXPAR,MAXSTK),IPARTP(MAXSTK),
     $                BX1P(MAXDIP,MAXSTK),BX3P(MAXDIP,MAXSTK),
     $                PT2INP(MAXDIP,MAXSTK),SDIPP(MAXDIP,MAXSTK),
     $                IP1P(MAXDIP,MAXSTK),IP3P(MAXDIP,MAXSTK),
     $                AEX1P(MAXDIP,MAXSTK),AEX3P(MAXDIP,MAXSTK),
     $                QDONEP(MAXDIP,MAXSTK),QEMP(MAXDIP,MAXSTK),
     $                IRADP(MAXDIP,MAXSTK),ISTRP(MAXDIP,MAXSTK),
     $                ICOLIP(MAXDIP,MAXSTK),IDIPSP(MAXSTK),
     $                IPFP(MAXSTR,MAXSTK),IPLP(MAXSTR,MAXSTK),
     $                IFLOWP(MAXSTR,MAXSTK),PT2LSP(MAXSTK),
     $                PT2MAP(MAXSTK),IMFP(MAXSTK),IMLP(MAXSTK),
     $                IOP(MAXSTK),QDUMPP(MAXSTK),ISTRSP(MAXSTK)
      SAVE /ARSTAK/


      IF (IH.LT.1.OR.IH.GT.MAXSTK) THEN
        CALL ARERRM('ARPUTR',31,0)
        RETURN
      ENDIF

      IPARTP(IH)=IPART
      IDIPSP(IH)=IDIPS
      PT2LSP(IH)=PT2LST
      PT2MAP(IH)=PT2MAX
      IMFP(IH)=IMF
      IMLP(IH)=IML
      IOP(IH)=IO
      QDUMPP(IH)=QDUMP
      ISTRSP(IH)=ISTRS
      DO 100 IPASS=1,2
        IF (IPASS.EQ.1) THEN
          I1P=1
          I2P=IPART
          I1D=1
          I2D=IDIPS
          I1S=1
          I2S=ISTRS
        ELSE
          I1P=MAXPAR-4
          I2P=MAXPAR
          I1D=1
          I2D=0
          I1S=1
          I2S=0
        ENDIF
        DO 110 IP=I1P,I2P
          DO 120 J=1,5
            BPP(IP,J,IH)=BP(IP,J)
 120      CONTINUE
          IFLP(IP,IH)=IFL(IP)
          QEXP(IP,IH)=QEX(IP)
          QQP(IP,IH)=QQ(IP)
          IDIP(IP,IH)=IDI(IP)
          IDOP(IP,IH)=IDO(IP)
          INOP(IP,IH)=INO(IP)
          INQP(IP,IH)=INQ(IP)
          XPMUP(IP,IH)=XPMU(IP)
          XPAP(IP,IH)=XPA(IP)
          PT2GGP(IP,IH)=PT2GG(IP)
 110    CONTINUE
        DO 130 ID=I1D,I2D
          BX1P(ID,IH)=BX1(ID)
          BX3P(ID,IH)=BX3(ID)
          PT2INP(ID,IH)=PT2IN(ID)
          SDIPP(ID,IH)=SDIP(ID)
          IP1P(ID,IH)=IP1(ID)
          IP3P(ID,IH)=IP3(ID)
          AEX1P(ID,IH)=AEX1(ID)
          AEX3P(ID,IH)=AEX3(ID)
          QDONEP(ID,IH)=QDONE(ID)
          QEMP(ID,IH)=QEM(ID)
          IRADP(ID,IH)=IRAD(ID)
          ISTRP(ID,IH)=ISTR(ID)
          ICOLIP(ID,IH)=ICOLI(ID)
 130    CONTINUE
        DO 140 IS=I1S,I2S
          IPFP(IS,IH)=IPF(IS)
          IPLP(IS,IH)=IPL(IS)
          IFLOWP(IS,IH)=IFLOW(IS)
 140    CONTINUE
 100  CONTINUE

      RETURN

C**** END OF ARPUPO ****************************************************
      END
C***********************************************************************
C $Id: arputr.f,v 3.1 1995/08/13 17:29:15 lonnblad Exp $
CDECK  ID>, ARGETR.
      SUBROUTINE ARGETR(IH)

C...ARiadne subroutine GET event Record from stack

C...Restores an event record from the stack

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      PARAMETER (MAXSTK=2)
      COMMON /ARSTAK/ BPP(MAXPAR,5,MAXSTK),IFLP(MAXPAR,MAXSTK),
     $                QEXP(MAXPAR,MAXSTK),QQP(MAXPAR,MAXSTK),
     $                IDIP(MAXPAR,MAXSTK),IDOP(MAXPAR,MAXSTK),
     $                INOP(MAXPAR,MAXSTK),INQP(MAXPAR,MAXSTK),
     $                XPMUP(MAXPAR,MAXSTK),XPAP(MAXPAR,MAXSTK),
     $                PT2GGP(MAXPAR,MAXSTK),IPARTP(MAXSTK),
     $                BX1P(MAXDIP,MAXSTK),BX3P(MAXDIP,MAXSTK),
     $                PT2INP(MAXDIP,MAXSTK),SDIPP(MAXDIP,MAXSTK),
     $                IP1P(MAXDIP,MAXSTK),IP3P(MAXDIP,MAXSTK),
     $                AEX1P(MAXDIP,MAXSTK),AEX3P(MAXDIP,MAXSTK),
     $                QDONEP(MAXDIP,MAXSTK),QEMP(MAXDIP,MAXSTK),
     $                IRADP(MAXDIP,MAXSTK),ISTRP(MAXDIP,MAXSTK),
     $                ICOLIP(MAXDIP,MAXSTK),IDIPSP(MAXSTK),
     $                IPFP(MAXSTR,MAXSTK),IPLP(MAXSTR,MAXSTK),
     $                IFLOWP(MAXSTR,MAXSTK),PT2LSP(MAXSTK),
     $                PT2MAP(MAXSTK),IMFP(MAXSTK),IMLP(MAXSTK),
     $                IOP(MAXSTK),QDUMPP(MAXSTK),ISTRSP(MAXSTK)
      SAVE /ARSTAK/


      IF (IH.LT.1.OR.IH.GT.MAXSTK) THEN
        CALL ARERRM('ARGETR',31,0)
        RETURN
      ENDIF

      IPART=IPARTP(IH)
      IDIPS=IDIPSP(IH)
      PT2LST=PT2LSP(IH)
      PT2MAX=PT2MAP(IH)
      IMF=IMFP(IH)
      IML=IMLP(IH)
      IO=IOP(IH)
      QDUMP=QDUMPP(IH)
      ISTRS=ISTRSP(IH)
      DO 100 IPASS=1,2
        IF (IPASS.EQ.1) THEN
          I1P=1
          I2P=IPART
          I1D=1
          I2D=IDIPS
          I1S=1
          I2S=ISTRS
        ELSE
          I1P=MAXPAR-4
          I2P=MAXPAR
          I1D=1
          I2D=0
          I1S=1
          I2S=0
        ENDIF
        DO 110 IP=I1P,I2P
          DO 120 J=1,5
            BP(IP,J)=BPP(IP,J,IH)
 120      CONTINUE
          IFL(IP)=IFLP(IP,IH)
          QEX(IP)=QEXP(IP,IH)
          QQ(IP)=QQP(IP,IH)
          IDI(IP)=IDIP(IP,IH)
          IDO(IP)=IDOP(IP,IH)
          INO(IP)=INOP(IP,IH)
          INQ(IP)=INQP(IP,IH)
          XPMU(IP)=XPMUP(IP,IH)
          XPA(IP)=XPAP(IP,IH)
          PT2GG(IP)=PT2GGP(IP,IH)
 110    CONTINUE
        DO 130 ID=I1D,I2D
          BX1(ID)=BX1P(ID,IH)
          BX3(ID)=BX3P(ID,IH)
          PT2IN(ID)=PT2INP(ID,IH)
          SDIP(ID)=SDIPP(ID,IH)
          IP1(ID)=IP1P(ID,IH)
          IP3(ID)=IP3P(ID,IH)
          AEX1(ID)=AEX1P(ID,IH)
          AEX3(ID)=AEX3P(ID,IH)
          QDONE(ID)=QDONEP(ID,IH)
          QEM(ID)=QEMP(ID,IH)
          IRAD(ID)=IRADP(ID,IH)
          ISTR(ID)=ISTRP(ID,IH)
          ICOLI(ID)=ICOLIP(ID,IH)
 130    CONTINUE
        DO 140 IS=I1S,I2S
          IPF(IS)=IPFP(IS,IH)
          IPL(IS)=IPLP(IS,IH)
          IFLOW(IS)=IFLOWP(IS,IH)
 140    CONTINUE
 100  CONTINUE

      RETURN

C**** END OF ARGETR ****************************************************
      END
C***********************************************************************
C $Id: arthrw.f,v 3.2 1995/08/15 09:08:59 lonnblad Exp $
CDECK  ID>, ARTHRW.
      REAL FUNCTION ARTHRW(ID,JRAD,I1,I3,IN1,IN2)

C...ARiadne subroutine THRoW emission

C...Signals emissions not fulfilling certain criteria

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/


      UTHROW=ARUTHR(ID,JRAD,I1,I3,IN1,IN2)
      ARTHRW=UTHROW
      IF (PARA(28).EQ.0.0.OR.UTHROW.LT.0) RETURN
      ARTHRW=-1.0
      GMAX=PARA(40)
      GMIN=0.0
      IF (PARA(28).GT.0.0) THEN
        GMIN=PARA(28)
      ELSE
        GMAX=-PARA(28)
      ENDIF
      DO 100 IP=IN1,IN2
        IF (IFL(IP).EQ.21.AND.(BP(IP,4).GT.GMAX.OR.BP(IP,4).LT.GMIN))
     $       RETURN
 100  CONTINUE

      ARTHRW=1.0

      RETURN

C**** END OF ARTHRW ****************************************************
      END
C***********************************************************************
C $Id: aruthr.f,v 3.1 1995/08/13 17:29:28 lonnblad Exp $
CDECK  ID>, ARUTHR.
      REAL FUNCTION ARUTHR(ID,JRAD,I1,I3,IN1,IN2)

C...ARiadne dummy routine User THRow emission

C...Enables a user to check each emission and trow it away if it
C...doesn't meet some criteria

C...The arguments are the radiating dipole ID, the original partons
C...I1 and I3 of the dipole, the first IN1 and last IN2 radiated
C...parton and the type of emission JRAD. The routine should return a
C...negative number if the emission doesn't meet the specified
C...conditions, positive otherwise.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)


      ARUTHR=1.0

      RETURN

C**** END OF ARUTHR ****************************************************
      END
C***********************************************************************
C $Id: ar4frm.f,v 3.2 1995/08/15 09:08:43 lonnblad Exp $
CDECK  ID>, AR4FRM.
      SUBROUTINE AR4FRM(ATOTSQ,A1SQ,A2SQ,ISTRAT,IRADG,ITAU)

C...ARiadne subroutine 4 FeRMion generator interface

C...General interface to a four fermion generator as specified by the
C...QCD generator working group of the LEP2 workshop

C...The following subroutine illustrates how to write a generic
C...interface between electroweak generators and QCD generators
C...for LEP 2 applications.
C...In this particular case, an electroweak generator is supposed to
C...have produced two fermions, two antifermions and an arbitrary
C...number of photons. These particles are stored in the HEPEVT
C...common block, in the order 3 = fermion, 4 = antifermion,
C...5 = fermion, 6 = antifermion, 7 onwards = photons.
C...Quarks and leptons should not appear in mixed order,
C...i.e. if 3 is a quark then 4 can not be an antilepton.
C...Incoming positron and electron are assumed stored in
C...positions 1 and 2, but the program never checks this.
C...The subroutine LU4FRM is supposed to read the configuration,
C...and call JETSET to do parton showers and fragmentation.
C...Since the colour flow need not be unique, three real numbers
C...should be given when LU4FRM is called:
C...ATOTSQ = total squared amplitude for the event, irrespective of
C...    colour flow;
C...A1SQ = squared amplitude for the configuration with 3 + 4 and
C...    5 + 6 as the two colour singlets; and
C...A2SQ = squared amplitude for the configuration with 3 + 6 and
C...    5 + 4 as the two colour singlets.
C...The choice of strategy is determined by an integer input:
C...ISTRAT = 0 : pick configurations according to A1SQ : A2SQ;
C...       = 1 : assign interference to maximize 3 + 4 and 5 + 6; or
C...       = 2 : assign interference to maximize 3 + 6 and 5 + 4.
C...Final-state QED radiation may be allowed or inhibited:
C...IRAD = 0 : no final-state photon radiation.
C...     = 1 : photon radiation inside each final fermion pair.
C...tau lepton decay may be  handled by QCD generator or not.
C...ITAU = 0 : taus are considered stable by QCD generator.
C...     = 1 : taus are allowed to decay by QCD generator.

      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100,MAXONI=100)

      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      INTEGER  NLUPDM,NPLBUF
      PARAMETER  (NLUPDM=4000,NPLBUF=5)
      COMMON/GUJETS/N,K(NLUPDM,5),P(NLUPDM,NPLBUF),V(NLUPDM,5)
      INTEGER  N,K
      REAL  P,V
      SAVE /GUJETS/
      COMMON/GUDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      INTEGER  MSTU,MSTJ
      REAL  PARU,PARJ
      SAVE /GUDAT1/

C...Call LUHEPC to convert from HEPEVT to LUJETS common.
      CALL LUHEPC(2)

C...Check that event is arranged according to conventions. Else stop.
      IF (N.LT.6) CALL ARERRM('AR4FRM',33,0)
      DO 100 I=3,6
        KFA=IABS(K(I,2))
        IF ((KFA.GE.1.AND.KFA.LE.6).OR.(KFA.GE.11.AND.KFA.LE.16)) THEN
        ELSE
          CALL ARERRM('AR4FRM',34,I)
        ENDIF
        IF (ISIGN(1,K(I,2)).NE.(-1)**(I-1)) CALL ARERRM('AR4FRM',35,I)
  100 CONTINUE
      DO 110 I=7,N
         IF (K(I,2).NE.22) CALL ARERRM('AR4FRM',36,I)
  110 CONTINUE

C....Check that E**2 = m**2 + p**2 for particles. Else stop.
      DO 120 I=1,N
        PE=SQRT(P(I,1)**2+P(I,2)**2+P(I,3)**2+P(I,5)**2)
        IF (ABS(P(I,4)-PE).GT.PARA(39)*MIN(P(I,4),PE))
     $       CALL ARERRM('AR4FRM',37,I)
  120 CONTINUE

C...Check which fermion pairs are quarks and which leptons.
C...Stop if inconsistent.
      IF (IABS(K(3,2)).LT.10.AND.IABS(K(4,2)).LT.10) THEN
        IQL34=1
      ELSEIF (IABS(K(3,2)).GT.10.AND.IABS(K(4,2)).GT.10) THEN
        IQL34=2
      ELSE
        CALL ARERRM('AR4FRM',38,3)
      ENDIF
      IF (IABS(K(5,2)).LT.10.AND.IABS(K(6,2)).LT.10) THEN
        IQL56=1
      ELSEIF (IABS(K(5,2)).GT.10.AND.IABS(K(6,2)).GT.10) THEN
        IQL56=2
      ELSE
        CALL ARERRM('AR4FRM',38,5)
      ENDIF

C...Do trivial colour pairing and parton shower when none or one
C...of the fermion pairs are quarks.
      IF (IQL34.EQ.2.AND.IQL56.EQ.2) THEN
      ELSEIF (IQL34.EQ.1.AND.IQL56.EQ.2) THEN
        CALL ARGTYP(3,ITYP)
        CALL ARCOPA(3,1,ITYP)
        CALL ARCOPA(4,2,-ITYP)
        IPART=2
        CALL ARCRDI(1,1,2,1,.FALSE.)
        CALL ARCOLI(1,-1)
        IDIPS=1
        IF (IRADG.GT.0) THEN
          IDIPS=IDIPS+1
          CALL ARCRDI(2,2,1,1,.TRUE.)
        ENDIF
        IMF=3
        IML=4
        PT2LST=PARA(40)
        IF (PARA(6).GT.0.0) PT2LST=MIN(PT2LST,PARA(6))
        IPF(1)=1
        IPL(1)=IPART
        ISTRS=1
        IFLOW(1)=ITYP
        QDUMP=.FALSE.
        CALL ARCASC
      ELSEIF (IQL34.EQ.2.AND.IQL56.EQ.1) THEN
        CALL ARGTYP(5,ITYP)
        CALL ARCOPA(5,1,ITYP)
        CALL ARCOPA(6,2,-ITYP)
        IPART=2
        CALL ARCRDI(1,1,2,1,.FALSE.)
        CALL ARCOLI(1,-1)
        IDIPS=1
        IF (IRADG.GT.0) THEN
          IDIPS=IDIPS+1
          CALL ARCRDI(2,2,1,1,.TRUE.)
        ENDIF
        IMF=5
        IML=6
        PT2LST=PARA(40)
        IF (PARA(6).GT.0.0) PT2LST=MIN(PT2LST,PARA(6))
        IPF(1)=1
        IPL(1)=IPART
        ISTRS=1
        IFLOW(1)=ITYP
        QDUMP=.FALSE.
        CALL ARCASC

C....Decide colour pairing when two quark pairs.
      ELSE
        R1SQ=A1SQ
        R2SQ=A2SQ
        RDELTA=ATOTSQ-A1SQ-A2SQ
        IF (ISTRAT.EQ.1) THEN
          IF (RDELTA.GT.0.0) R1SQ=R1SQ+RDELTA
          IF (RDELTA.LT.0.0) R2SQ=MAX(0.0,R2SQ+RDELTA)
        ELSEIF (ISTRAT.EQ.2) THEN
          IF (RDELTA.GT.0.0) R2SQ=R2SQ+RDELTA
          IF (RDELTA.LT.0.0) R1SQ=MAX(0.0,R1SQ+RDELTA)
        ENDIF
        IPAIR=1
        IF (R2SQ.GT.RLU(0)*(R1SQ+R2SQ)) IPAIR=2

C...Do colour joining and parton showers when two quark pairs.
        IF (IPAIR.EQ.1) THEN
          I1=3
          I2=4
          I3=5
          I4=6
        ELSE
          I1=3
          I2=6
          I3=5
          I4=4
        ENDIF
        CALL ARGTYP(I1,ITYP)
        CALL ARCOPA(I1,1,ITYP)
        CALL ARCOPA(I2,2,-ITYP)
        IDIPS=1
        CALL ARCRDI(IDIPS,1,2,1,.FALSE.)
        CALL ARCOLI(IDIPS,-1)
        IF (IRADG.GT.0) THEN
          IDIPS=IDIPS+1
          CALL ARCRDI(IDIPS,2,1,1,.TRUE.)
        ENDIF
        IPF(1)=1
        IPL(1)=2
        IFLOW(1)=ITYP
        CALL ARGTYP(I3,ITYP)
        CALL ARCOPA(I3,3,ITYP)
        CALL ARCOPA(I4,4,-ITYP)
        IDIPS=IDIPS+1
        CALL ARCRDI(IDIPS,3,4,2,.FALSE.)
        CALL ARCOLI(IDIPS,-2)
        IF (IRADG.GT.0) THEN
          IDIPS=IDIPS+1
          CALL ARCRDI(IDIPS,4,3,1,.TRUE.)
        ENDIF
        IPF(2)=3
        IPL(2)=4
        IFLOW(2)=ITYP
        ISTRS=2
        IPART=4
        IMF=3
        IML=6
        PT2LST=PARA(40)
        IF (PARA(6).GT.0.0) PT2LST=MIN(PT2LST,PARA(6))
        ISTRS=2
        QDUMP=.FALSE.
C...Perform the cascade without crosstalk between colour singlet systems
        CALL ARCASC
C...If the cascade was limited in gluon energy, allow for cross talk
C...between the colour singlet systems and perform emissions below
C...that energy.
        IF (PARA(28).GT.0.AND.MHAR(101).EQ.2.AND.MSTA(35).EQ.2) THEN
          DO 150 ID=1,IDIPS
            IF (QEM(ID)) GOTO 150
            QDONE(ID)=.FALSE.
            ICOLI(ID)=MOD(ICOLI(ID),1000)
 150      CONTINUE
          PARA(28)=-PARA(28)
          PT2LST=PARA(40)
          CALL ARCONT
          PARA(28)=-PARA(28)
        ENDIF

      ENDIF

C...Do fragmentation and decays. Possibly except tau decay.
      IF (ITAU.EQ.0) THEN
        DO 130 I=3,6
  130   IF (IABS(K(I,2)).EQ.15) K(I,1)=11
      ENDIF
      CALL LUEXEC
      IF (ITAU.EQ.0) THEN
        DO 140 I=3,6
  140   IF (IABS(K(I,2)).EQ.15) K(I,1)=1
      ENDIF

      RETURN

C**** END OF AR4FRM ****************************************************
      END
