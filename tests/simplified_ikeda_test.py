from rolldecay.simplified_ikeda import calculate_roll_damping
import numpy as np

def test_calculate_roll_damping():

    """
    L / B = 6.0
    B / d = 4.0,
    Cb = 0.65,
    Cm = 0.98,
    φa = 10,
    bBK / B = 0.025
    lBK / Lpp = 0.2
    """
    L_div_B = 6.0
    B_div_d = 4.0
    CB = 0.65
    CMID = 0.98
    PHI = 10
    bBK_div_B = 0.025
    lBK_div_Lpp = 0.2
    OG_div_d = -0.2

    LPP = 300
    Beam = LPP/L_div_B
    DRAFT = Beam/B_div_d

    lBK = LPP*lBK_div_Lpp
    bBK =Beam*bBK_div_B
    OMEGA = 0.6/(np.sqrt(Beam / 2 / 9.81))

    OG = DRAFT*OG_div_d

    B44HAT, BFHAT, BWHAT, BEHAT, BBKHAT = calculate_roll_damping(LPP,Beam,CB,CMID,OG,PHI,lBK,bBK,OMEGA,DRAFT)
