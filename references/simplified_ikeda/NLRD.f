C     ************************************************************************
C     *  Simple Prediction Formula of Roll Damping                           *
C     *                         on the Basis of Ikeda's Method               *
C     *                                                                      *
C     *  Roll_Damping.for            coded by Yoshiho IKEDA                  *
C     *                                       Yuki KAWAHARA                  *
C     *                                       Kazuya MAEKAWA                 *
C     *                                       Osaka Prefecture University    *
C     *                                       Graduate School of Engineering *
C     *  last up date 2009.07.08                                             *
C     ************************************************************************
      PROGRAM  MAIN
      implicit none
      double precision,parameter :: PI = 3.14159
      double precision,parameter :: RO = 102
      double precision,parameter :: KVC = 1.14e-6
C     KVC : Kinematic Viscosity Coefficient

      double precision :: LPP,LB,BD,CB,CMID,OGD,PHI,TW,LBKL,BBKB
      double precision :: OMEGA,BRTH,DRAFT,OMEGAHAT,X1,X2,X3,X4,X5
      character :: BKCOMP,OK
      double precision :: CF,RF,SF,BF,BFHAT
      double precision A111,A112,A113,A121,A122,A123,A124,A131,A132,
     & A133,A134,A11,A12,A13,AA111,AA112,AA113,AA121,AA122,AA123,AA11,
     & AA12,AA1,A1,A2,A31,A32,A33,A34,A35,A36,A37,AA311,AA31,AA32,XX4,
     & AA3,A3,BWHAT
      double precision :: FE1,FE2,AE,BE1,BE2,BE3,CR,BEHAT,B44HAT
      double precision :: FBK1,FBK2,FBK3,FBK5,ABK,BBK1,BBK2,BBK3,BBKHAT

C     *******************************************
C     ***     Input principal particulars     ***
C     *******************************************
90    write(*,*) '----- INPUT PRINCIPAL PARTICULARS -----'
      write(*,*) ' SHIP LENGTH - Lpp [m] : '
      read(*,*) LPP
C
      write(*,*) ' RATIO of SHIP LENGTH to BREADTH - Lpp/B : '
      read(*,*) LB
C
      write(*,*) "RATIO of BREADTH to DRAFT - B/d [2.5 < B/d < 4.5] "
100   read(*,*) BD
      if (BD.lt.2.5 .or. 4.5.lt.BD) then
       write(*,*) "Please confirm the range of B/d [2.5 < B/d < 4.5]"
       go to 100
      end if 
C
200   write(*,*) "BLOCK COEFFICIENT - Cb [0.5 < Cb < 0.85]" 
      read(*,*) CB
      if (CB.lt.0.5 .or. 0.85.lt.CB) then
       write(*,*) "Please confirm the range of Cb [0.5 < Cb < 0.85]"
       go to 200 
      end if 
C
300   write(*,*) "MIDSHIP SECTION COEFFICIENT - Cm [0.9 < Cm < 0.99]"
      read(*,*) CMID
      if (CMID.lt.0.9 .or. 0.99.lt.CMID) then
       write(*,*) "Please confirm the range of Cm [0.9 < Cm < 0.99]"
       go to 300
      end if 
C
400   write(*,*) "OG/d [-1.5 < OG/d < 0.2]"
      write(*,*) "Downward direction is positive."
      read(*,*) OGD
      if (OGD.lt.-1.5 .or. 0.2.lt.OGD) then
       write(*,*) ' Please confirm the range of OG/d [-1.5ÅOGdÅ0.2]. '
       go to 400      
      end if 
C
      write(*,*) "ROLL ANGLE - fo [deg.]"
      read(*,*) PHI
      PHI=ABS(PHI)
C
      write(*,*) "WAVE PERIOD - Tw [sec.] [f0HAT 1.0]"
      read(*,*) TW
      OMEGA=2*PI/TW
      
      BRTH=LPP/LB ; DRAFT=BRTH/BD ; OMEGAHAT=OMEGA*SQRT(BRTH/2/9.81)
      if (OMEGAHAT.gt.1.0) then
       write(*,*) "Please confirm the range of f0HAT [f0HAT > 1.0]"
       go to 400
      end if 

C     *** Input Bilge Keel ***
      write(*,*) '----- INPUT BILGE KEEL DATA -----'
      write(*,*)
     & ' Do you calculate roll damping of the Bilge Keel component?
     &   - (Y or N) '
      read(*,*) BKCOMP
      if (BKCOMP .eq. 'N' .or. BKCOMP .eq. 'n') then 
       go to 700
      end if
C      
500   write(*,*) ' RATIO of BILGE KEEL LENGTH to SHIP LENGTH - lBK/Lpp
     & [0.05ÅÖlBKÅÖ0.4] : '
      read(*,*) LBKL
      if (LBKL.lt.0.05 .or. 0.4.lt.LBKL) then
       write(*,*) 
     & ' Please confirm the range of lBK/Lpp [0.05ÅlBK/LppÅ0.4]. '
       go to 500      
      end if 
C
600   write(*,*) ' RATIO of BILGE KEEL BREADTH to SHIP BREADTH - bBK/B
     & [0.01ÅÖbBKÅÖ0.06] : '
      read(*,*) BBKB
      if (BBKB.lt.0.01 .or. 0.06.lt.BBKB) then
       write(*,*) 
     &  ' Please confirm the range of bBK/B [0.01 < bBK/B < 0.06]. '
       go to 600
      end if 

C     *** Data Confirmation ***
700   write(*,*) '----- PRINCIPAL PARTICULARS -----'
      write(*,710) LPP
      write(*,720) LB
      write(*,730) BD
      write(*,740) CB
      write(*,750) CMID
      write(*,760) OGD
      write(*,770) PHI
      write(*,780) TW

      if (BKCOMP .eq. 'N' .or. BKCOMP .eq. 'n') then 
       go to 900
      end if

      write(*,790) LBKL
      write(*,800) BBKB
      
710   format(7x,'Lpp',6x,'[m]',':',4x,f6.2)   
720   format(7x,'L/B',9x,':',4x,f6.2)
730   format(7x,'B/d',9x,':',4x,f6.2)
740   format(7x,'Cb',10x,':',4x,f6.2)
750   format(7x,'Cm',10x,':',4x,f6.2)
760   format(7x,'OG/d',8x,':',4x,f6.2)
770   format(7x,'É”',4x,'[deg.]',':',4x,f6.2)
780   format(7x,'Tw',4x,'[sec.]',':',4x,f6.2)
790   format(7x,'lBK/Lpp',5x,':',4x,f6.2)
800   format(7x,'bBK/B',7x,':',4x,f6.2)    

900   write(*,*) ' Is it OK (Y or N) ? '
      read(*,*) OK
      if (OK .eq. 'N' .or. OK .eq. 'n') then 
       go to 90
      end if
C     ********************************************************************
C     *** Calculation of roll damping by the proposed predition method ***
C     ********************************************************************

C     *** Frictional Component ***
      RF=DRAFT*((0.887d0+0.145d0*CB)*(1.7d0+CB*BD)-2.0d0*OGD)/PI
      SF=LPP*(1.75d0*DRAFT+CB*BRTH)
      CF=1.328*((3.22*RF**2*(PHI*PI/180)**2)/(TW*KVC))**-0.5
      BF=4.0/3.0/PI*RO*SF*RF**3*(PHI*PI/180)*OMEGA*CF
      BFHAT=BF/(RO*LPP*BRTH**3*DRAFT*CB)*SQRT(BRTH/2.0/9.81)

C     *** Wave Component ***
      X1=BD ; X2=CB ; X3=CMID
      X5=OMEGAHAT
      X4=1-OGD
      A111=-0.002222d0*X1**3+0.040871d0*X1**2-0.286866d0*X1
     &     +0.599424d0
      A112=0.010185d0*X1**3-0.161176d0*X1**2+0.904989d0*X1
     &     -1.641389d0
      A113=-0.015422d0*X1**3+0.220371d0*X1**2-1.084987d0*X1
     &     +1.834167d0
      A121=-0.0628667d0*X1**4+0.4989259d0*X1**3+0.52735d0*X1**2
     &           -10.7918672d0*X1+16.616327d0
      A122=0.1140667d0*X1**4-0.8108963d0*X1**3-2.2186833d0*X1**2
     &           +25.1269741d0*X1-37.7729778d0
      A123=-0.0589333d0*X1**4+0.2639704d0*X1**3+3.1949667d0*X1**2
     &           -21.8126569d0*X1+31.4113508d0
      A124=0.0107667d0*X1**4+0.0018704d0*X1**3-1.2494083d0*X1**2
     &           +6.9427931d0*X1-10.2018992d0
      A131=0.192207d0*X1**3-2.787462d0*X1**2+12.507855d0*X1
     &     -14.764856d0
      A132=-0.350563d0*X1**3+5.222348d0*X1**2-23.974852d0*X1
     &     +29.007851d0
      A133=0.237096d0*X1**3-3.535062d0*X1**2+16.368376d0*X1
     &     -20.539908d0
      A134=-0.067119d0*X1**3+0.966362d0*X1**2-4.407535d0*X1
     &     +5.894703d0

      A11=A111*X2**2+A112*X2+A113
      A12=A121*X2**3+A122*X2**2+A123*X2+A124
      A13=A131*X2**3+A132*X2**2+A133*X2+A134

      AA111=17.945d0*X1**3-166.294d0*X1**2+489.799d0*X1-493.142d0
      AA112=-25.507d0*X1**3+236.275d0*X1**2-698.683d0*X1+701.494d0
      AA113=9.077d0*X1**3-84.332d0*X1**2+249.983d0*X1-250.787d0
      AA121=-16.872d0*X1**3+156.399d0*X1**2-460.689d0*X1+463.848d0
      AA122=24.015d0*X1**3-222.507d0*X1**2+658.027d0*X1-660.665d0
      AA123=-8.56d0*X1**3+79.549d0*X1**2-235.827d0*X1+236.579d0

      AA11=AA111*X2**2+AA112*X2+AA113
      AA12=AA121*X2**2+AA122*X2+AA123

      AA1=(AA11*X3+AA12)*(1-X4)+1.0

      A1=(A11*X4**2+A12*X4+A13)*AA1
      A2=-1.402d0*X4**3+7.189d0*X4**2-10.993d0*X4+9.45d0

      A31=-7686.0287d0*X2**6+30131.5678d0*X2**5
     &   -49048.9664d0*X2**4+42480.7709d0*X2**3-20665.147d0*X2**2
     &   +5355.2035d0*X2-577.8827d0
      A32=61639.9103d0*X2**6-241201.0598d0*X2**5+392579.5937d0*X2**4
     &   -340629.4699d0*X2**3+166348.6917d0*X2**2-43358.7938d0*X2
     &   +4714.7918d0
      A33=-130677.4903d0*X2**6+507996.2604d0*X2**5
     &     -826728.7127d0*X2**4+722677.104d0*X2**3-358360.7392d0*X2**2
     &     +95501.4948d0*X2-10682.8619d0
      A34=-110034.6584d0*X2**6+446051.22d0*X2**5-724186.4643d0*X2**4
     &   +599411.9264d0*X2**3-264294.7189d0*X2**2+58039.7328d0*X2
     &   -4774.6414d0
      A35=709672.0656d0*X2**6-2803850.2395d0*X2**5+
     &     4553780.5017d0*X2**4-3888378.9905d0*X2**3+1839829.259d0*X2**2
     &     -457313.6939d0*X2+46600.823d0
      A36=-822735.9289d0*X2**6+3238899.7308d0*X2**5
     &    -5256636.5472d0*X2**4+4500543.147d0*X2**3-2143487.3508d0*X2**2
     &    +538548.1194d0*X2-55751.1528d0
      A37=299122.8727d0*X2**6-1175773.1606d0*X2**5
     &    +1907356.1357d0*X2**4-1634256.8172d0*X2**3+780020.9393d0*X2**2
     &    -196679.7143d0*X2+20467.0904d0

      AA311=(-17.102d0*X2**3+41.495d0*X2**2-33.234d0*X2+8.8007d0)*X4
     &     +36.566d0*X2**3-89.203d0*X2**2+71.8d0*X2-18.108d0

      AA31=(-0.3767d0*X1**3+3.39d0*X1**2-10.356d0*X1+11.588d0)*AA311
      AA32=-0.0727d0*X1**2+0.7d0*X1-1.2818d0

      XX4=X4-AA32

      AA3=AA31*(-1.05584d0*XX4**9+12.688d0*XX4**8-63.70534d0*XX4**7
     & +172.84571d0*XX4**6-274.05701d0*XX4**5+257.68705d0*XX4**4
     & -141.40915d0*XX4**3+44.13177d0*XX4**2-7.1654d0*XX4-0.0495d0*X1**2
     & +0.4518d0*X1-0.61655d0)

      A3=A31*X4**6+A32*X4**5+A33*X4**4+A34*X4**3+A35*X4**2
     &     +A36*X4+A37+AA3

      BWHAT=A1/X5*EXP(-A2*(LOG(X5)-A3)**2/1.44)

C     *** Eddy Component ***
      FE1=(-0.0182d0*CB+0.0155d0)*(BD-1.8d0)**3
      FE2=-79.414d0*CB**4+215.695d0*CB**3
     &            -215.883d0*CB**2+93.894d0*CB-14.848d0
      AE=FE1+FE2
      BE1=(3.98d0*CB-5.1525d0)*(-0.2d0*BD+1.6d0)*OGD*
     & ((0.9717d0*CB**2-1.55d0*CB+0.723d0)*OGD+0.04567d0*CB+0.9408d0)
      BE2=(0.25*OGD+0.95)*OGD
     &                 -219.2d0*CB**3+443.7d0*CB**2-283.3d0*CB+59.6d0
      BE3=-15d0*CB*BD+46.5d0*CB+11.2d0*BD-28.6d0
      CR=AE*EXP(BE1+BE2*CMID**BE3)
      BEHAT=4.0*OMEGAHAT*PHI*PI/180/(3.0*PI*CB*BD**3.0)*CR

C     *** Bilge Keel Component ***
      if (BKCOMP .eq. 'N' .or. BKCOMP .eq. 'n') then
        BBKHAT=0.0
      else
        FBK1=(-0.3651d0*CB+0.3907d0)*(BD-2.83d0)**2-2.21d0*CB+2.632d0
        FBK2=0.00255d0*PHI**2+0.122d0*PHI+0.4794d0
        FBK3=(-0.8913d0*BBKB**2-0.0733d0*BBKB)*LBKL**2
     &             +(5.2857d0*BBKB**2-0.01185d0*BBKB+0.00189d0)*LBKL
        ABK=FBK1*FBK2*FBK3
        BBK1=(5.0d0*BBKB+0.3d0*BD-0.2d0*LBKL
     &                 +0.00125d0*PHI**2-0.0425d0*PHI-1.86d0)*OGD
        BBK2=-15.0d0*BBKB+1.2d0*CB-0.1d0*BD
     &                 -0.0657d0*OGD**2+0.0586d0*OGD+1.6164d0
        BBK3=2.5d0*OGD+15.75d0
        BBKHAT=ABK*EXP(BBK1+BBK2*CMID**BBK3)*OMEGAHAT
      endif
C     *** Total Roll Damping ***
      B44HAT=BFHAT+BWHAT+BEHAT+BBKHAT      
C     *******************************
C     ***     Output to files     ***
C     *******************************
      open(10,FILE='output.csv')
      write(10,*) ' ----- INPUT PRINCIPAL PARTICULARS ----- '
      write(10,*) 'Lpp',LPP
      write(10,*) 'Lpp/B',LB
      write(10,*) 'B/d',BD
      write(10,*) 'Cb',CB
      write(10,*) 'Cm',CMID
      write(10,*) 'OG/d',OGD
      write(10,*) 'É”(PHI)',PHI
      write(10,*) 'Tw',TW

      if (BKCOMP .eq. 'N' .or. BKCOMP .eq. 'n') then 
       go to 1000
      end if

      write(10,*) 'lBK/Lpp',LBKL
      write(10,*) 'bBK/B',BBKB
      
1000  write(10,*) ' ----- Cal. by simplified prediction method ----- '
      write(10,*) ' BFHAT ',' BWHAT ',' BEHAT ',' BBKHAT ',' B44HAT '
      write(10,*) BFHAT,BWHAT,BEHAT,BBKHAT,B44HAT
      close(10)

      END  PROGRAM