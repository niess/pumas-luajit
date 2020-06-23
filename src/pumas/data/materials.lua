-- Tabulated materials from the Particle Data Group (PDG)
-- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/index.html

return {

    -- A-150 tissue-equivalent plastic
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/a-150_tissue-equivalent_plastic.html
    A150TissueEquivalentPlastic = {
        Cbar = 3.11, I = 65.1, a = 0.1078, composition = {{"H", 0.101327}, {"C",
        0.775501}, {"N", 0.035057}, {"O", 0.052316}, {"F", 0.017422}, {"Ca",
        0.018378}}, delta0 = 0, density = 1.127, k = 3.4442, x0 = 0.1329,
        x1 = 2.6234
    },

    -- Acetone
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/acetone.html
    Acetone = {
        Cbar = 3.4341, I = 64.2, a = 0.111, composition = {{"H", 0.104122},
        {"C", 0.620405}, {"O", 0.275473}}, delta0 = 0, density = 0.7899,
        k = 3.4047, x0 = 0.2197, x1 = 2.6928
    },

    -- Acetylene CHCH
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/acetylene_CHCH.html
    AcetyleneCHCH = {
        Cbar = 9.8419, I = 58.2, a = 0.1217, composition = {{"H", 0.077418},
        {"C", 0.922582}}, delta0 = 0, density = 0.001097, k = 3.4277,
        x0 = 1.6017, x1 = 4.0074
    },

    -- Actinium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/actinium_Ac.html
    Actinium = {
        Cbar = 6.3742, I = 841, a = 0.0857, composition = {{"Ac", 1}},
        delta0 = 0.14, density = 10.07, k = 3.2683, x0 = 0.4559, x1 = 3.7966
    },

    -- Adenine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/adenine.html
    Adenine = {
        Cbar = 3.1724, I = 71.4, a = 0.2091, composition = {{"H", 0.037294},
        {"C", 0.44443}, {"N", 0.518275}}, delta0 = 0, density = 1.35,
        k = 3.0271, x0 = 0.1295, x1 = 2.4219
    },

    -- Adipose tissue ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/adipose_tissue_ICRP.html
    AdiposeTissueICRP = {
        Cbar = 3.2367, I = 63.2, a = 0.1028, composition = {{"H", 0.119477},
        {"C", 0.63724}, {"N", 0.00797}, {"O", 0.232333}, {"Na", 0.0005}, {"Mg",
        2e-05}, {"P", 0.00016}, {"S", 0.00073}, {"Cl", 0.00119}, {"K", 0.00032},
        {"Ca", 2e-05}, {"Fe", 2e-05}, {"Zn", 2e-05}}, delta0 = 0,
        density = 0.92, k = 3.4817, x0 = 0.1827, x1 = 2.653
    },

    -- Ag halides in phot emulsion
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ag_halides_in_phot_emulsion.html
    AgHalidesInPhotEmulsion = {
        Cbar = 5.6166, I = 487.1, a = 0.2459, composition = {{"Br", 0.422895},
        {"Ag", 0.573748}, {"I", 0.003357}}, delta0 = 0, density = 6.47,
        k = 2.6814, x0 = 0.0353, x1 = 3.2117
    },

    -- Air dry 1 atm
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/air_dry_1_atm.html
    AirDry1Atm = {
        Cbar = 10.5961, I = 85.7, a = 0.1091, composition = {{"C", 0.000124},
        {"N", 0.755267}, {"O", 0.231781}, {"Ar", 0.012827}}, delta0 = 0,
        density = 0.001205, k = 3.3994, x0 = 1.7418, x1 = 4.2759
    },

    -- Alanine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/alanine.html
    Alanine = {
        Cbar = 3.0965, I = 71.9, a = 0.1148, composition = {{"H", 0.07919},
        {"C", 0.404439}, {"N", 0.157213}, {"O", 0.359159}}, delta0 = 0,
        density = 1.42, k = 3.3526, x0 = 0.1354, x1 = 2.6336
    },

    -- Aluminum
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/aluminum_Al.html
    Aluminum = {
        Cbar = 4.2395, I = 166, a = 0.0802, composition = {{"Al", 1}},
        delta0 = 0.12, density = 2.699, k = 3.6345, x0 = 0.1708, x1 = 3.0127
    },

    -- Aluminum oxide sapphire
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/aluminum_oxide_sapphire.html
    AluminumOxideSapphire = {
        Cbar = 3.5682, I = 145.2, a = 0.085, composition = {{"O", 0.470749},
        {"Al", 0.529251}}, delta0 = 0, density = 3.97, k = 3.5458, x0 = 0.0402,
        x1 = 2.8665
    },

    -- Amber
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/amber.html
    Amber = {
        Cbar = 3.0701, I = 63.2, a = 0.1193, composition = {{"H", 0.10593},
        {"C", 0.788973}, {"O", 0.105096}}, delta0 = 0, density = 1.1,
        k = 3.4098, x0 = 0.1335, x1 = 2.561
    },

    -- Americium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/americium_Am.html
    Americium = {
        Cbar = 6.2813, I = 934, a = 0.2031, composition = {{"Am", 1}},
        delta0 = 0.14, density = 13.67, k = 2.7615, x0 = 0.2274, x1 = 3.5021
    },

    -- Ammonia
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ammonia.html
    Ammonia = {
        Cbar = 9.8763, I = 53.7, a = 0.0831, composition = {{"H", 0.177547},
        {"N", 0.822453}}, delta0 = 0, density = 0.000826, k = 3.6464,
        x0 = 1.6822, x1 = 4.1158
    },

    -- Aniline
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/aniline.html
    Aniline = {
        Cbar = 3.2622, I = 66.2, a = 0.1313, composition = {{"H", 0.075759},
        {"C", 0.773838}, {"N", 0.150403}}, delta0 = 0, density = 1.023,
        k = 3.3434, x0 = 0.1618, x1 = 2.5805
    },

    -- Anthracene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/anthracene.html
    Anthracene = {
        Cbar = 3.1514, I = 69.5, a = 0.1468, composition = {{"H", 0.05655},
        {"C", 0.94345}}, delta0 = 0, density = 1.283, k = 3.2831, x0 = 0.1146,
        x1 = 2.5213
    },

    -- Antimony
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/antimony_Sb.html
    Antimony = {
        Cbar = 5.6241, I = 487, a = 0.1665, composition = {{"Sb", 1}},
        delta0 = 0.14, density = 6.691, k = 2.9319, x0 = 0.3189, x1 = 3.3489
    },

    -- Argon gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/argon_gas_Ar.html
    ArgonGas = {
        Cbar = 11.948, I = 188, a = 0.1971, composition = {{"Ar", 1}},
        delta0 = 0, density = 0.001662, k = 2.9618, x0 = 1.7635, x1 = 4.4855
    },

    -- Arsenic
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/arsenic_As.html
    Arsenic = {
        Cbar = 5.051, I = 347, a = 0.0663, composition = {{"As", 1}},
        delta0 = 0.08, density = 5.73, k = 3.4176, x0 = 0.1767, x1 = 3.5702
    },

    -- B-100 Bone-equivalent plastic
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/b-100_Bone-equivalent_plastic.html
    B100BoneEquivalentPlastic = {
        Cbar = 3.4528, I = 85.9, a = 0.0527, composition = {{"H", 0.065471},
        {"C", 0.536945}, {"N", 0.0215}, {"O", 0.032085}, {"F", 0.167411}, {"Ca",
        0.176589}}, delta0 = 0, density = 1.45, k = 3.7365, x0 = 0.1252,
        x1 = 3.042
    },

    -- Bakelite
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/bakelite.html
    Bakelite = {
        Cbar = 3.2582, I = 72.4, a = 0.1271, composition = {{"H", 0.057441},
        {"C", 0.774591}, {"O", 0.167968}}, delta0 = 0, density = 1.25,
        k = 3.347, x0 = 0.1471, x1 = 2.6055
    },

    -- Barium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/barium_Ba.html
    Barium = {
        Cbar = 6.3153, I = 491, a = 0.1827, composition = {{"Ba", 1}},
        delta0 = 0.14, density = 3.5, k = 2.8906, x0 = 0.419, x1 = 3.4547
    },

    -- Barium fluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/barium_fluoride.html
    BariumFluoride = {
        Cbar = 5.4116, I = 375.9, a = 0.1599, composition = {{"F", 0.21672},
        {"Ba", 0.78328}}, delta0 = 0, density = 4.893, k = 2.8867, x0 = 0.0099,
        x1 = 3.387
    },

    -- Barium sulfate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/barium_sulfate.html
    BariumSulfate = {
        Cbar = 4.8923, I = 285.7, a = 0.1175, composition = {{"O", 0.274212},
        {"S", 0.137368}, {"Ba", 0.58842}}, delta0 = 0, density = 4.5,
        k = 3.0427, x0 = 0.0128, x1 = 3.4069
    },

    -- Benzene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/benzene.html
    Benzene = {
        Cbar = 3.3269, I = 63.4, a = 0.1652, composition = {{"H", 0.077418},
        {"C", 0.922582}}, delta0 = 0, density = 0.8787, k = 3.2174, x0 = 0.171,
        x1 = 2.5091
    },

    -- Berkelium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/berkelium_Bk.html
    Berkelium = {
        Cbar = 3.9886, I = 952, a = 0.2556, composition = {{"Bk", 1}},
        delta0 = 0, density = 9.86, k = 3, x0 = 0.0509, x1 = 2.5
    },

    -- Beryllium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/beryllium_Be.html
    Beryllium = {
        Cbar = 2.7847, I = 63.7, a = 0.8039, composition = {{"Be", 1}},
        delta0 = 0.14, density = 1.848, k = 2.4339, x0 = 0.0592, x1 = 1.6922
    },

    -- Beryllium oxide BeO
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/beryllium_oxide_BeO.html
    BerylliumOxide = {
        Cbar = 2.9801, I = 93.2, a = 0.1076, composition = {{"Be", 0.36032},
        {"O", 0.63968}}, delta0 = 0, density = 3.01, k = 3.4927, x0 = 0.0241,
        x1 = 2.5846
    },

    -- Bismuth
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/bismuth_Bi.html
    Bismuth = {
        Cbar = 6.3505, I = 823, a = 0.0941, composition = {{"Bi", 1}},
        delta0 = 0.14, density = 9.747, k = 3.1671, x0 = 0.4152, x1 = 3.8248
    },

    -- Bismuth germanate BGO
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/bismuth_germanate_BGO.html
    BismuthGermanate = {
        Cbar = 5.7409, I = 534.1, a = 0.0957, composition = {{"O", 0.154126},
        {"Ge", 0.17482}, {"Bi", 0.671054}}, delta0 = 0, density = 7.13,
        k = 3.0781, x0 = 0.0456, x1 = 3.7816
    },

    -- Bismuth silicate BSO
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/bismuth_silicate_BSO.html
    BismuthSilicate = {
        Cbar = 5.9374, I = 519.2, a = 0.2187, composition = {{"O", 0.172629},
        {"Si", 0.075759}, {"Bi", 0.751613}}, delta0 = 0, density = 7.12, k = 3,
        x0 = 0.4077, x1 = 3.0557
    },

    -- Blood ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/blood_ICRP.html
    BloodICRP = {
        Cbar = 3.4581, I = 75.2, a = 0.0849, composition = {{"H", 0.101866},
        {"C", 0.10002}, {"N", 0.02964}, {"O", 0.759414}, {"Na", 0.00185}, {"Mg",
        4e-05}, {"Si", 3e-05}, {"P", 0.00035}, {"S", 0.00185}, {"Cl", 0.00278},
        {"K", 0.00163}, {"Ca", 6e-05}, {"Fe", 0.00046}, {"Zn", 1e-05}},
        delta0 = 0, density = 1.06, k = 3.5406, x0 = 0.2239, x1 = 2.8017
    },

    -- Boron
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/boron_B.html
    Boron = {
        Cbar = 2.8477, I = 76, a = 0.5622, composition = {{"B", 1}},
        delta0 = 0.14, density = 2.37, k = 2.4512, x0 = 0.0305, x1 = 1.9688
    },

    -- Boron carbide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/boron_carbide.html
    BoronCarbide = {
        Cbar = 2.9859, I = 84.7, a = 0.3709, composition = {{"B", 0.78261},
        {"C", 0.21739}}, delta0 = 0, density = 2.52, k = 2.8076, x0 = 0.0093,
        x1 = 2.1006
    },

    -- Boron oxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/boron_oxide.html
    BoronOxide = {
        Cbar = 3.6027, I = 99.6, a = 0.1155, composition = {{"B", 0.310551},
        {"O", 0.689449}}, delta0 = 0, density = 1.812, k = 3.3832, x0 = 0.1843,
        x1 = 2.7379
    },

    -- Borosilicate glass Pyrex Corning 7740
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/borosilicate_glass_Pyrex_Corning_7740.html
    BorosilicateGlassPyrexCorning7740 = {
        Cbar = 3.9708, I = 134, a = 0.0827, composition = {{"B", 0.040061},
        {"O", 0.539564}, {"Na", 0.028191}, {"Al", 0.011644}, {"Si", 0.37722},
        {"K", 0.003321}}, delta0 = 0, density = 2.23, k = 3.5224, x0 = 0.1479,
        x1 = 2.9933
    },

    -- Brain ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/brain_ICRP.html
    BrainICRP = {
        Cbar = 3.4279, I = 73.3, a = 0.0825, composition = {{"H", 0.110667},
        {"C", 0.12542}, {"N", 0.01328}, {"O", 0.737723}, {"Na", 0.00184}, {"Mg",
        0.00015}, {"P", 0.00354}, {"S", 0.00177}, {"Cl", 0.00236}, {"K",
        0.0031}, {"Ca", 9e-05}, {"Fe", 5e-05}, {"Zn", 1e-05}}, delta0 = 0,
        density = 1.03, k = 3.5585, x0 = 0.2206, x1 = 2.8021
    },

    -- Bromine gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/bromine_gas.html
    BromineGas = {
        Cbar = 11.7307, I = 343, a = 0.0633, composition = {{"Br", 1}},
        delta0 = 0, density = 0.007072, k = 3.467, x0 = 1.5262, x1 = 4.9899
    },

    -- Butane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/butane.html
    Butane = {
        Cbar = 8.5651, I = 48.3, a = 0.1085, composition = {{"H", 0.173408},
        {"C", 0.826592}}, delta0 = 0, density = 0.002489, k = 3.4884,
        x0 = 1.3792, x1 = 3.7528
    },

    -- C-552 air-equivalent plastic
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/C-552_air-equivalent_plastic.html
    C552AirEquivalentPlastic = {
        Cbar = 3.3338, I = 86.8, a = 0.1049, composition = {{"H", 0.02468},
        {"C", 0.50161}, {"O", 0.004527}, {"F", 0.465209}, {"Si", 0.003973}},
        delta0 = 0, density = 1.76, k = 3.4344, x0 = 0.151, x1 = 2.7083
    },

    -- Cadmium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cadmium_Cd.html
    Cadmium = {
        Cbar = 5.2727, I = 469, a = 0.2461, composition = {{"Cd", 1}},
        delta0 = 0.14, density = 8.65, k = 2.6772, x0 = 0.1281, x1 = 3.1667
    },

    -- Cadmium telluride CdTe
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cadmium_telluride_CdTe.html
    CadmiumTelluride = {
        Cbar = 5.9096, I = 539.3, a = 0.2484, composition = {{"Cd", 0.468355},
        {"Te", 0.531645}}, delta0 = 0, density = 6.2, k = 2.6665, x0 = 0.0438,
        x1 = 3.2836
    },

    -- Cadmium tungstate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cadmium_tungstate.html
    CadmiumTungstate = {
        Cbar = 5.3594, I = 468.3, a = 0.1286, composition = {{"O", 0.177644},
        {"Cd", 0.312027}, {"W", 0.510329}}, delta0 = 0, density = 7.9,
        k = 2.915, x0 = 0.0123, x1 = 3.5941
    },

    -- Caesium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/caesium_Cs.html
    Caesium = {
        Cbar = 6.9135, I = 488, a = 0.1823, composition = {{"Cs", 1}},
        delta0 = 0.14, density = 1.873, k = 2.8866, x0 = 0.5473, x1 = 3.5914
    },

    -- Calcium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/calcium_Ca.html
    Calcium = {
        Cbar = 5.0396, I = 191, a = 0.1564, composition = {{"Ca", 1}},
        delta0 = 0.14, density = 1.55, k = 3.0745, x0 = 0.3228, x1 = 3.1191
    },

    -- Calcium carbonate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/calcium_carbonate.html
    CalciumCarbonate = {
        Cbar = 3.7738, I = 136.4, a = 0.083, composition = {{"C", 0.120003},
        {"O", 0.479554}, {"Ca", 0.400443}}, delta0 = 0, density = 2.8,
        k = 3.412, x0 = 0.0492, x1 = 3.0549
    },

    -- Calcium fluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/calcium_fluoride.html
    CalciumFluoride = {
        Cbar = 4.0653, I = 166, a = 0.0694, composition = {{"F", 0.486659},
        {"Ca", 0.513341}}, delta0 = 0, density = 3.18, k = 3.5263, x0 = 0.0676,
        x1 = 3.1683
    },

    -- Calcium oxide CaO
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/calcium_oxide_CaO.html
    CalciumOxide = {
        Cbar = 4.1209, I = 176.1, a = 0.1213, composition = {{"O", 0.285299},
        {"Ca", 0.714701}}, delta0 = 0, density = 3.3, k = 3.1936, x0 = 0.0172,
        x1 = 3.0171
    },

    -- Calcium sulfate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/calcium_sulfate.html
    CalciumSulfate = {
        Cbar = 3.9388, I = 152.3, a = 0.0771, composition = {{"O", 0.470095},
        {"S", 0.235497}, {"Ca", 0.294408}}, delta0 = 0, density = 2.96,
        k = 3.4495, x0 = 0.0587, x1 = 3.1229
    },

    -- Calcium tungstate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/calcium_tungstate.html
    CalciumTungstate = {
        Cbar = 5.2603, I = 395, a = 0.0621, composition = {{"O", 0.22227},
        {"Ca", 0.139202}, {"W", 0.638529}}, delta0 = 0, density = 6.062,
        k = 3.2649, x0 = 0.0323, x1 = 3.8932
    },

    -- Californium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/californium_Cf.html
    Californium = {
        Cbar = 4.0236, I = 966, a = 0.258, composition = {{"Cf", 1}},
        delta0 = 0, density = 15.1, k = 3, x0 = 0.0623, x1 = 2.5
    },

    -- Carbon amorphous
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/carbon_amorphous_C.html
    CarbonAmorphous = {
        Cbar = 2.9925, I = 78, a = 0.2024, composition = {{"C", 1}},
        delta0 = 0.1, density = 2, k = 3.0036, x0 = 0.0351, x1 = 2.486
    },

    -- Carbon compact
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/carbon_compact_C.html
    CarbonCompact = {
        Cbar = 2.868, I = 78, a = 0.2614, composition = {{"C", 1}},
        delta0 = 0.12, density = 2.265, k = 2.8697, x0 = 0.0178, x1 = 2.3415
    },

    -- Carbon dioxide gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/carbon_dioxide_gas.html
    CarbonDioxideGas = {
        Cbar = 10.1537, I = 85, a = 0.1177, composition = {{"C", 0.272916},
        {"O", 0.727084}}, delta0 = 0, density = 0.001842, k = 3.3227,
        x0 = 1.6294, x1 = 4.1825
    },

    -- Carbon gem diamond
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/carbon_gem_diamond.html
    CarbonGemDiamond = {
        Cbar = 2.4271, I = 78, a = 0.2614, composition = {{"C", 1}},
        delta0 = 0.12, density = 3.52, k = 2.8697, x0 = 0.1135, x1 = 2.2458
    },

    -- Carbon graphite
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/carbon_graphite_C.html
    CarbonGraphite = {
        Cbar = 2.8926, I = 78, a = 0.2076, composition = {{"C", 1}},
        delta0 = 0.14, density = 2.21, k = 2.9532, x0 = 0.009, x1 = 2.4817
    },

    -- Carbon tetrachloride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/carbon_tetrachloride.html
    CarbonTetrachloride = {
        Cbar = 4.7712, I = 166.3, a = 0.1902, composition = {{"C", 0.078083},
        {"Cl", 0.921917}}, delta0 = 0, density = 1.594, k = 3.0116, x0 = 0.1773,
        x1 = 2.9165
    },

    -- Carbon tetrafluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/carbon_tetrafluoride.html
    CarbonTetrafluoride = {
        Cbar = 10.0858, I = 115, a = 0.1855, composition = {{"C", 0.136548},
        {"F", 0.86345}}, delta0 = 0, density = 0.00378, k = 3, x0 = 1.7, x1 = 4
    },

    -- Cellulose
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cellulose.html
    Cellulose = {
        Cbar = 3.2647, I = 77.6, a = 0.1115, composition = {{"H", 0.062162},
        {"C", 0.444462}, {"O", 0.493376}}, delta0 = 0, density = 1.42,
        k = 3.381, x0 = 0.158, x1 = 2.6778
    },

    -- Cellulose acetate butyrate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cellulose_acetate_butyrate.html
    CelluloseAcetateButyrate = {
        Cbar = 3.3497, I = 74.6, a = 0.1144, composition = {{"H", 0.067125},
        {"C", 0.545403}, {"O", 0.387472}}, delta0 = 0, density = 1.2,
        k = 3.3738, x0 = 0.1794, x1 = 2.6809
    },

    -- Cellulose nitrate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cellulose_nitrate.html
    CelluloseNitrate = {
        Cbar = 3.4762, I = 87, a = 0.1181, composition = {{"H", 0.029216}, {"C",
        0.271296}, {"N", 0.121276}, {"O", 0.578212}}, delta0 = 0,
        density = 1.49, k = 3.3237, x0 = 0.1897, x1 = 2.7253
    },

    -- Ceric sulfate dosimeter solution
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ceric_sulfate_dosimeter_solution.html
    CericSulfateDosimeterSolution = {
        Cbar = 3.5212, I = 76.7, a = 0.0767, composition = {{"H", 0.107596},
        {"N", 0.0008}, {"O", 0.874976}, {"S", 0.014627}, {"Ce", 0.002001}},
        delta0 = 0, density = 1.03, k = 3.5607, x0 = 0.2363, x1 = 2.8769
    },

    -- Cerium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cerium_Ce.html
    Cerium = {
        Cbar = 5.7669, I = 523, a = 0.1889, composition = {{"Ce", 1}},
        delta0 = 0.14, density = 6.77, k = 2.8592, x0 = 0.2676, x1 = 3.3395
    },

    -- Cerium fluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cerium_fluoride.html
    CeriumFluoride = {
        Cbar = 5.0079, I = 348.4, a = 0.1862, composition = {{"Ce", 0.710847},
        {"F", 0.289153}}, delta0 = 0, density = 6.16, k = 3, x0 = 0.2, x1 = 3
    },

    -- Cesium fluoride CsF
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cesium_fluoride_CsF.html
    CesiumFluoride = {
        Cbar = 5.9046, I = 440.7, a = 0.2205, composition = {{"F", 0.125069},
        {"Cs", 0.874931}}, delta0 = 0, density = 4.115, k = 2.728, x0 = 0.0084,
        x1 = 3.3374
    },

    -- Cesium iodide CsI
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cesium_iodide_CsI.html
    CesiumIodide = {
        Cbar = 6.2807, I = 553.1, a = 0.2538, composition = {{"I", 0.488451},
        {"Cs", 0.511549}}, delta0 = 0, density = 4.51, k = 2.6657, x0 = 0.0395,
        x1 = 3.3353
    },

    -- Chlorine gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/chlorine_gas.html
    ChlorineGas = {
        Cbar = 11.147, I = 174, a = 0.1985, composition = {{"Cl", 1}},
        delta0 = 0, density = 0.00298, k = 2.9702, x0 = 1.5566, x1 = 4.3005
    },

    -- Chlorobenzene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/chlorobenzene.html
    Chlorobenzene = {
        Cbar = 3.8201, I = 89.1, a = 0.0986, composition = {{"H", 0.044772},
        {"C", 0.640254}, {"Cl", 0.314974}}, delta0 = 0, density = 1.106,
        k = 3.3797, x0 = 0.1714, x1 = 2.9272
    },

    -- Chloroform
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/chloroform.html
    Chloroform = {
        Cbar = 4.7055, I = 156, a = 0.1696, composition = {{"H", 0.008443},
        {"C", 0.100613}, {"Cl", 0.890944}}, delta0 = 0, density = 1.483,
        k = 3.0627, x0 = 0.1786, x1 = 2.9581
    },

    -- Chromium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/chromium_Cr.html
    Chromium = {
        Cbar = 4.1781, I = 257, a = 0.1542, composition = {{"Cr", 1}},
        delta0 = 0.14, density = 7.18, k = 2.9896, x0 = 0.034, x1 = 3.0451
    },

    -- Cobalt
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cobalt_Co.html
    Cobalt = {
        Cbar = 4.2601, I = 297, a = 0.1447, composition = {{"Co", 1}},
        delta0 = 0.12, density = 8.9, k = 2.9502, x0 = 0.0187, x1 = 3.179
    },

    -- Compact bone ICRU
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/compact_bone_ICRU.html
    CompactBoneICRU = {
        Cbar = 3.339, I = 91.9, a = 0.0582, composition = {{"H", 0.063984},
        {"C", 0.278}, {"N", 0.027}, {"O", 0.410016}, {"Mg", 0.002}, {"P", 0.07},
        {"S", 0.002}, {"Ca", 0.147}}, delta0 = 0, density = 1.85, k = 3.6419,
        x0 = 0.0944, x1 = 3.0201
    },

    -- Copper
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/copper_Cu.html
    Copper = {
        Cbar = 4.419, I = 322, a = 0.1434, composition = {{"Cu", 1}},
        delta0 = 0.08, density = 8.96, k = 2.9044, x0 = 0.0254, x1 = 3.2792
    },

    -- Cortical bone ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cortical_bone_ICRP.html
    CorticalBoneICRP = {
        Cbar = 3.6488, I = 106.4, a = 0.062, composition = {{"H", 0.047234},
        {"C", 0.14433}, {"N", 0.04199}, {"O", 0.446096}, {"Mg", 0.0022}, {"P",
        0.10497}, {"S", 0.00315}, {"Ca", 0.20993}, {"Zn", 0.0001}}, delta0 = 0,
        density = 1.85, k = 3.5919, x0 = 0.1161, x1 = 3.0919
    },

    -- Curium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/curium_Cm.html
    Curium = {
        Cbar = 6.3097, I = 939, a = 0.2026, composition = {{"Cm", 1}},
        delta0 = 0.14, density = 13.51, k = 2.7579, x0 = 0.2484, x1 = 3.516
    },

    -- Cyclohexane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/cyclohexane.html
    Cyclohexane = {
        Cbar = 3.1544, I = 56.4, a = 0.1204, composition = {{"H", 0.143711},
        {"C", 0.856289}}, delta0 = 0, density = 0.779, k = 3.4278, x0 = 0.1728,
        x1 = 2.5549
    },

    -- Deuterium gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/deuterium_gas.html
    DeuteriumGas = {
        Cbar = 9.6543, I = 19.2, a = 0.1409, composition = {{"D", 1}},
        delta0 = 0, density = 0.0001677, k = 5.7273, x0 = 1.8793, x1 = 3.2872
    },

    -- Deuterium oxide liquid
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/deuterium_oxide_liquid.html
    DeuteriumOxideLiquid = {
        Cbar = 3.5017, I = 79.7, a = 0.0912, composition = {{"D", 0.201133},
        {"O", 0.798867}}, delta0 = 0, density = 1.107, k = 3.4773, x0 = 0.24,
        x1 = 2.8004
    },

    -- 12-dichlorobenzene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/12-dichlorobenzene.html
    Dichlorobenzene = {
        Cbar = 4.0348, I = 106.5, a = 0.1601, composition = {{"H", 0.027425},
        {"C", 0.490233}, {"Cl", 0.482342}}, delta0 = 0, density = 1.305,
        k = 3.0836, x0 = 0.1587, x1 = 2.8276
    },

    -- Dichlorodiethyl ether
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/dichlorodiethyl_ether.html
    DichlorodiethylEther = {
        Cbar = 4.0135, I = 103.3, a = 0.068, composition = {{"H", 0.056381},
        {"C", 0.335942}, {"O", 0.111874}, {"Cl", 0.495802}}, delta0 = 0,
        density = 1.22, k = 3.525, x0 = 0.1773, x1 = 3.1586
    },

    -- 12-dichloroethane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/12-dichloroethane.html
    Dichloroethane = {
        Cbar = 4.1849, I = 111.9, a = 0.1338, composition = {{"H", 0.04074},
        {"C", 0.242746}, {"Cl", 0.716515}}, delta0 = 0, density = 1.235,
        k = 3.1675, x0 = 0.1375, x1 = 2.9529
    },

    -- Diethyl ether
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/diethyl_ether.html
    DiethylEther = {
        Cbar = 3.3721, I = 60, a = 0.1055, composition = {{"H", 0.135978}, {"C",
        0.648171}, {"O", 0.215851}}, delta0 = 0, density = 0.7138, k = 3.4586,
        x0 = 0.2231, x1 = 2.6745
    },

    -- Dimethyl sulfoxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/dimethyl_sulfoxide.html
    DimethylSulfoxide = {
        Cbar = 3.9844, I = 98.6, a = 0.0662, composition = {{"H", 0.077403},
        {"C", 0.307467}, {"O", 0.204782}, {"S", 0.410348}}, delta0 = 0,
        density = 1.101, k = 3.5708, x0 = 0.2021, x1 = 3.1263
    },

    -- Dysprosium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/dysprosium_Dy.html
    Dysprosium = {
        Cbar = 5.9182, I = 628, a = 0.2466, composition = {{"Dy", 1}},
        delta0 = 0.14, density = 8.551, k = 2.5849, x0 = 0.0822, x1 = 3.4474
    },

    -- Erbium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/erbium_Er.html
    Erbium = {
        Cbar = 5.9565, I = 658, a = 0.2482, composition = {{"Er", 1}},
        delta0 = 0.14, density = 9.026, k = 2.5573, x0 = 0.0658, x1 = 3.4932
    },

    -- Ethane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ethane.html
    Ethane = {
        Cbar = 9.0965, I = 45.4, a = 0.0963, composition = {{"H", 0.201115},
        {"C", 0.798885}}, delta0 = 0, density = 0.001263, k = 3.6095,
        x0 = 1.509, x1 = 3.8726
    },

    -- Ethanol
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ethanol.html
    Ethanol = {
        Cbar = 3.3699, I = 62.9, a = 0.0988, composition = {{"H", 0.131269},
        {"C", 0.521438}, {"O", 0.347294}}, delta0 = 0, density = 0.7893,
        k = 3.4834, x0 = 0.2218, x1 = 2.7052
    },

    -- Ethyl cellulose
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ethyl_cellulose.html
    EthylCellulose = {
        Cbar = 3.2415, I = 69.3, a = 0.1108, composition = {{"H", 0.090027},
        {"C", 0.585182}, {"O", 0.324791}}, delta0 = 0, density = 1.13,
        k = 3.4098, x0 = 0.1683, x1 = 2.6527
    },

    -- Ethylene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ethylene.html
    Ethylene = {
        Cbar = 9.438, I = 50.7, a = 0.1064, composition = {{"H", 0.143711},
        {"C", 0.856289}}, delta0 = 0, density = 0.001175, k = 3.5387,
        x0 = 1.5528, x1 = 3.9327
    },

    -- Europium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/europium_Eu.html
    Europium = {
        Cbar = 6.2276, I = 580, a = 0.2445, composition = {{"Eu", 1}},
        delta0 = 0.14, density = 5.244, k = 2.6245, x0 = 0.1888, x1 = 3.4633
    },

    -- Eye lens ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/eye_lens_ICRP.html
    EyeLensICRP = {
        Cbar = 3.372, I = 73.3, a = 0.0969, composition = {{"H", 0.099269},
        {"C", 0.19371}, {"N", 0.05327}, {"O", 0.653751}}, delta0 = 0,
        density = 1.1, k = 3.455, x0 = 0.207, x1 = 2.7446
    },

    -- Ferric oxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ferric_oxide.html
    FerricOxide = {
        Cbar = 4.2245, I = 227.3, a = 0.1048, composition = {{"O", 0.300567},
        {"Fe", 0.699433}}, delta0 = 0, density = 5.2, k = 3.1313, x0 = 0.0074,
        x1 = 3.2573
    },

    -- Ferroboride FeB
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ferroboride_FeB.html
    Ferroboride = {
        Cbar = 4.2057, I = 261, a = 0.1291, composition = {{"B", 0.162174},
        {"Fe", 0.837826}}, delta0 = 0, density = 7.15, k = 3.024, x0 = 0.0988,
        x1 = 3.1749
    },

    -- Ferrous oxide FeO
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ferrous_oxide_FeO.html
    FerrousOxide = {
        Cbar = 4.3175, I = 248.6, a = 0.1296, composition = {{"O", 0.222689},
        {"Fe", 0.777311}}, delta0 = 0, density = 5.7, k = 3.0168, x0 = 0.0279,
        x1 = 3.2002
    },

    -- Ferrous sulfate dosimeter solution
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ferrous_sulfate_dosimeter_solution.html
    FerrousSulfateDosimeterSolution = {
        Cbar = 3.5183, I = 76.4, a = 0.0876, composition = {{"H", 0.108259},
        {"N", 2.7e-05}, {"O", 0.878636}, {"Na", 2.2e-05}, {"S", 0.012968},
        {"Cl", 3.4e-05}, {"Fe", 5.4e-05}}, delta0 = 0, density = 1.024,
        k = 3.4923, x0 = 0.2378, x1 = 2.8254
    },

    -- Fluorine gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/fluorine_gas.html
    FluorineGas = {
        Cbar = 10.9653, I = 115, a = 0.1108, composition = {{"F", 1}},
        delta0 = 0, density = 0.00158, k = 3.2962, x0 = 1.8433, x1 = 4.4096
    },

    -- Francium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/francium_Fr.html
    Francium = {
        Cbar = 8.0292, I = 827, a = 0.4321, composition = {{"Fr", 1}},
        delta0 = 0, density = 1.87, k = 3, x0 = 1.1175, x1 = 3
    },

    -- Freon-12
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/Freon-12.html
    Freon12 = {
        Cbar = 4.8251, I = 143, a = 0.0798, composition = {{"C", 0.099335},
        {"F", 0.314247}, {"Cl", 0.586418}}, delta0 = 0, density = 1.12,
        k = 3.4626, x0 = 0.3035, x1 = 3.2659
    },

    -- Freon-13
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/Freon-13.html
    Freon13 = {
        Cbar = 4.7483, I = 126.6, a = 0.0724, composition = {{"C", 0.114983},
        {"F", 0.545622}, {"Cl", 0.339396}}, delta0 = 0, density = 0.95,
        k = 3.5551, x0 = 0.3659, x1 = 3.2337
    },

    -- Freon-13b1
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/Freon-13b1.html
    Freon13b1 = {
        Cbar = 5.3555, I = 210.5, a = 0.0393, composition = {{"C", 0.080659},
        {"F", 0.382749}, {"Br", 0.536592}}, delta0 = 0, density = 1.5,
        k = 3.7194, x0 = 0.3522, x1 = 3.7554
    },

    -- Freon-13i1
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/Freon-13i1.html
    Freon13i1 = {
        Cbar = 5.8774, I = 293.5, a = 0.0911, composition = {{"C", 0.061309},
        {"F", 0.290924}, {"I", 0.647767}}, delta0 = 0, density = 1.8,
        k = 3.1658, x0 = 0.2847, x1 = 3.728
    },

    -- Gadolinium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/gadolinium_Gd.html
    Gadolinium = {
        Cbar = 5.8737, I = 591, a = 0.2511, composition = {{"Gd", 1}},
        delta0 = 0.14, density = 7.901, k = 2.5977, x0 = 0.1058, x1 = 3.3932
    },

    -- Gadolinium oxysulfide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/gadolinium_oxysulfide.html
    GadoliniumOxysulfide = {
        Cbar = 5.5347, I = 493.3, a = 0.2216, composition = {{"O", 0.084528},
        {"S", 0.08469}, {"Gd", 0.830782}}, delta0 = 0, density = 7.44, k = 2.63,
        x0 = 0.1774, x1 = 3.4045
    },

    -- Gadolinium silicate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/gadolinium_silicate.html
    GadoliniumSilicate = {
        Cbar = 5.2267, I = 405.4, a = 0.1961, composition = {{"Gd", 0.744233},
        {"Si", 0.066462}, {"O", 0.189305}}, delta0 = 0, density = 6.71, k = 3,
        x0 = 0.2039, x1 = 3
    },

    -- Gallium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/gallium_Ga.html
    Gallium = {
        Cbar = 4.9353, I = 334, a = 0.0944, composition = {{"Ga", 1}},
        delta0 = 0.14, density = 5.904, k = 3.1314, x0 = 0.2267, x1 = 3.5434
    },

    -- Gallium arsenide GaAs
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/gallium_arsenide_GaAs.html
    GalliumArsenide = {
        Cbar = 5.3299, I = 384.9, a = 0.0715, composition = {{"Ga", 0.482019},
        {"As", 0.517981}}, delta0 = 0, density = 5.31, k = 3.3356, x0 = 0.1764,
        x1 = 3.642
    },

    -- Gel in photographic emulsion
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/gel_in_photographic_emulsion.html
    GelInPhotographicEmulsion = {
        Cbar = 3.2687, I = 74.8, a = 0.101, composition = {{"H", 0.08118}, {"C",
        0.41606}, {"N", 0.11124}, {"O", 0.38064}, {"S", 0.01088}}, delta0 = 0,
        density = 1.291, k = 3.4418, x0 = 0.1709, x1 = 2.7058
    },

    -- Germanium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/germanium_Ge.html
    Germanium = {
        Cbar = 5.1411, I = 350, a = 0.0719, composition = {{"Ge", 1}},
        delta0 = 0.14, density = 5.323, k = 3.3306, x0 = 0.3376, x1 = 3.6096
    },

    -- Glucose dextrose monohydrate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/glucose_dextrose_monohydrate.html
    GlucoseDextroseMonohydrate = {
        Cbar = 3.1649, I = 77.2, a = 0.1078, composition = {{"H", 0.071204},
        {"C", 0.363652}, {"O", 0.565144}}, delta0 = 0, density = 1.54,
        k = 3.3946, x0 = 0.1411, x1 = 2.67
    },

    -- Glutamine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/glutamine.html
    Glutamine = {
        Cbar = 3.1167, I = 73.3, a = 0.1193, composition = {{"H", 0.068965},
        {"C", 0.410926}, {"N", 0.191681}, {"O", 0.328427}}, delta0 = 0,
        density = 1.46, k = 3.3254, x0 = 0.1347, x1 = 2.6301
    },

    -- Glycerol
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/glycerol.html
    Glycerol = {
        Cbar = 3.2267, I = 72.6, a = 0.1017, composition = {{"H", 0.087554},
        {"C", 0.391262}, {"O", 0.521185}}, delta0 = 0, density = 1.261,
        k = 3.4481, x0 = 0.1653, x1 = 2.6862
    },

    -- Gold
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/gold_Au.html
    Gold = {
        Cbar = 5.5747, I = 790, a = 0.0976, composition = {{"Au", 1}},
        delta0 = 0.14, density = 19.32, k = 3.1101, x0 = 0.2021, x1 = 3.6979
    },

    -- Guanine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/guanine.html
    Guanine = {
        Cbar = 3.1171, I = 75, a = 0.2053, composition = {{"H", 0.033346}, {"C",
        0.39738}, {"N", 0.463407}, {"O", 0.105867}}, delta0 = 0, density = 1.58,
        k = 3.0186, x0 = 0.1163, x1 = 2.4296
    },

    -- Gypsum plaster of Paris
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/gypsum_plaster_of_Paris.html
    GypsumPlasterOfParis = {
        Cbar = 3.8382, I = 129.7, a = 0.0695, composition = {{"H", 0.023416},
        {"O", 0.557572}, {"S", 0.186215}, {"Ca", 0.232797}}, delta0 = 0,
        density = 2.32, k = 3.5134, x0 = 0.0995, x1 = 3.1206
    },

    -- Hafnium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/hafnium_Hf.html
    Hafnium = {
        Cbar = 5.7139, I = 705, a = 0.2292, composition = {{"Hf", 1}},
        delta0 = 0.14, density = 13.31, k = 2.6155, x0 = 0.1965, x1 = 3.4337
    },

    -- Heavymet in ATLAS calorimeter
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/heavymet_in_ATLAS_calorimeter.html
    HeavymetInATLASCalorimeter = {
        Cbar = 5.4059, I = 727, a = 0.1551, composition = {{"Ni", 0.035}, {"Cu",
        0.015}, {"W", 0.95}}, delta0 = 0.14, density = 19.3, k = 2.8447,
        x0 = 0.2167, x1 = 3.496
    },

    -- Heavymet in Rochester gamma stop
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/heavymet_in_Rochester_gamma_stop.html
    HeavymetInRochesterGammaStop = {
        Cbar = 5.4059, I = 727, a = 0.1551, composition = {{"Ni", 0.06}, {"Cu",
        0.04}, {"W", 0.9}}, delta0 = 0.14, density = 19.3, k = 2.8447,
        x0 = 0.2167, x1 = 3.496
    },

    -- Helium gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/helium_gas_He.html
    HeliumGas = {
        Cbar = 11.1393, I = 41.8, a = 0.1344, composition = {{"He", 1}},
        delta0 = 0, density = 0.0001663, k = 5.8347, x0 = 2.2017, x1 = 3.6122
    },

    -- Holmium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/holmium_Ho.html
    Holmium = {
        Cbar = 5.9587, I = 650, a = 0.2464, composition = {{"Ho", 1}},
        delta0 = 0.14, density = 8.795, k = 2.5726, x0 = 0.0761, x1 = 3.4782
    },

    -- Hydrogen gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/hydrogen_gas.html
    HydrogenGas = {
        Cbar = 9.5834, I = 19.2, a = 0.1409, composition = {{"H", 1}},
        delta0 = 0, density = 8.376e-05, k = 5.7273, x0 = 1.8639, x1 = 3.2718
    },

    -- Indium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/indium_In.html
    Indium = {
        Cbar = 5.5211, I = 488, a = 0.2388, composition = {{"In", 1}},
        delta0 = 0.14, density = 7.31, k = 2.7144, x0 = 0.2406, x1 = 3.2032
    },

    -- Iodine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/iodine_I.html
    Iodine = {
        Cbar = 5.9488, I = 491, a = 0.2377, composition = {{"I", 1}},
        delta0 = 0, density = 4.93, k = 2.7276, x0 = 0.0549, x1 = 3.2596
    },

    -- Iridium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/iridium_Ir.html
    Iridium = {
        Cbar = 5.3418, I = 757, a = 0.1269, composition = {{"Ir", 1}},
        delta0 = 0.1, density = 22.42, k = 2.9658, x0 = 0.0819, x1 = 3.548
    },

    -- Iron
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/iron_Fe.html
    Iron = {
        Cbar = 4.2911, I = 286, a = 0.1468, composition = {{"Fe", 1}},
        delta0 = 0.12, density = 7.874, k = 2.9632, x0 = 0.0012, x1 = 3.1531
    },

    -- Krypton gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/krypton_gas_Kr.html
    KryptonGas = {
        Cbar = 12.5094, I = 352, a = 0.0745, composition = {{"Kr", 1}},
        delta0 = 0, density = 0.003486, k = 3.4051, x0 = 1.7153, x1 = 5.0743
    },

    -- Lanthanum
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lanthanum_La.html
    Lanthanum = {
        Cbar = 5.7865, I = 501, a = 0.1859, composition = {{"La", 1}},
        delta0 = 0.14, density = 6.145, k = 2.8828, x0 = 0.3164, x1 = 3.3296
    },

    -- Lanthanum bromide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lanthanum_bromide.html
    LanthanumBromide = {
        Cbar = 5.6997, I = 454.5, a = 0.2197, composition = {{"La", 0.366875},
        {"Br", 0.633124}}, delta0 = 0, density = 5.29, k = 3, x0 = 0.3581,
        x1 = 3
    },

    -- Lanthanum chloride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lanthanum_chloride.html
    LanthanumChloride = {
        Cbar = 5.3428, I = 329.5, a = 0.2016, composition = {{"La", 0.56635},
        {"Cl", 0.43365}}, delta0 = 0, density = 3.86, k = 3, x0 = 0.2418,
        x1 = 3
    },

    -- Lanthanum fluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lanthanum_fluoride.html
    LanthanumFluoride = {
        Cbar = 4.986, I = 336.3, a = 0.1852, composition = {{"La", 0.709061},
        {"F", 0.290939}}, delta0 = 0, density = 5.9, k = 3, x0 = 0.2, x1 = 3
    },

    -- Lanthanum oxybromide LaOBr
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lanthanum_oxybromide_LaOBr.html
    LanthanumOxybromide = {
        Cbar = 5.4666, I = 439.7, a = 0.1783, composition = {{"O", 0.068138},
        {"Br", 0.340294}, {"La", 0.591568}}, delta0 = 0, density = 6.28,
        k = 2.8457, x0 = 0.035, x1 = 3.3288
    },

    -- Lanthanum oxysulfide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lanthanum_oxysulfide.html
    LanthanumOxysulfide = {
        Cbar = 5.447, I = 421.2, a = 0.215, composition = {{"O", 0.0936}, {"S",
        0.093778}, {"La", 0.812622}}, delta0 = 0, density = 5.86, k = 2.7298,
        x0 = 0.0906, x1 = 3.2664
    },

    -- Lead
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lead_Pb.html
    Lead = {
        Cbar = 6.2018, I = 823, a = 0.0936, composition = {{"Pb", 1}},
        delta0 = 0.14, density = 11.35, k = 3.1608, x0 = 0.3776, x1 = 3.8073
    },

    -- Lead fluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lead_fluoride.html
    LeadFluoride = {
        Cbar = 6.0333, I = 635.4, a = 0.2389, composition = {{"Pb", 0.845035},
        {"F", 0.154965}}, delta0 = 0, density = 7.77, k = 3, x0 = 0.4668,
        x1 = 3
    },

    -- Lead glass
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lead_glass.html
    LeadGlass = {
        Cbar = 5.8476, I = 526.4, a = 0.0954, composition = {{"O", 0.156453},
        {"Si", 0.080866}, {"Ti", 0.008092}, {"As", 0.002651}, {"Pb", 0.751938}},
        delta0 = 0, density = 6.22, k = 3.074, x0 = 0.0614, x1 = 3.8146
    },

    -- Lead oxide PbO
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lead_oxide_PbO.html
    LeadOxide = {
        Cbar = 6.2162, I = 766.7, a = 0.1964, composition = {{"O", 0.071682},
        {"Pb", 0.928318}}, delta0 = 0, density = 9.53, k = 2.7299, x0 = 0.0356,
        x1 = 3.5456
    },

    -- Lead tungstate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lead_tungstate.html
    LeadTungstate = {
        Cbar = 5.8528, I = 600.7, a = 0.2276, composition = {{"Pb", 0.455347},
        {"W", 0.404011}, {"O", 0.140462}}, delta0 = 0, density = 8.3, k = 3,
        x0 = 0.4068, x1 = 3.0023
    },

    -- Liquid argon
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_argon.html
    LiquidArgon = {
        Cbar = 5.2146, I = 188, a = 0.1956, composition = {{"Ar", 1}},
        delta0 = 0, density = 1.396, k = 3, x0 = 0.2, x1 = 3
    },

    -- Liquid bromine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_bromine.html
    LiquidBromine = {
        Cbar = 5.7268, I = 357, a = 0.2211, composition = {{"Br", 1}},
        delta0 = 0, density = 3.103, k = 3, x0 = 0.3669, x1 = 3
    },

    -- Liquid chlorine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_chlorine.html
    LiquidChlorine = {
        Cbar = 4.8776, I = 174, a = 0.1802, composition = {{"Cl", 1}},
        delta0 = 0, density = 1.574, k = 3, x0 = 0.2, x1 = 3
    },

    -- Liquid deuterium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_deuterium.html
    LiquidDeuterium = {
        Cbar = 3.1288, I = 21.8, a = 0.1348, composition = {{"D", 1}},
        delta0 = 0, density = 0.1638, k = 5.6249, x0 = 0.4467, x1 = 1.8923
    },

    -- Liquid fluorine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_fluorine.html
    LiquidFluorine = {
        Cbar = 4.105, I = 115, a = 0.145, composition = {{"F", 1}}, delta0 = 0,
        density = 1.507, k = 3, x0 = 0.2, x1 = 3
    },

    -- Liquid helium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_helium.html
    LiquidHelium = {
        Cbar = 4.518, I = 41.8, a = 0.6571, composition = {{"He", 1}},
        delta0 = 0, density = 0.1249, k = 3, x0 = 0.4729, x1 = 2
    },

    -- Liquid hydrogen
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_hydrogen.html
    LiquidHydrogen = {
        Cbar = 3.0977, I = 21.8, a = 0.1348, composition = {{"H", 1}},
        delta0 = 0, density = 0.0708, k = 5.6249, x0 = 0.44, x1 = 1.8856
    },

    -- Liquid krypton
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_krypton_Kr.html
    LiquidKrypton = {
        Cbar = 5.9674, I = 352, a = 0.2349, composition = {{"Kr", 1}},
        delta0 = 0, density = 2.418, k = 3, x0 = 0.4454, x1 = 3
    },

    -- Liquid neon
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_neon.html
    LiquidNeon = {
        Cbar = 4.6345, I = 137, a = 0.1692, composition = {{"Ne", 1}},
        delta0 = 0, density = 1.204, k = 3, x0 = 0.2, x1 = 3
    },

    -- Liquid nitrogen
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_nitrogen.html
    LiquidNitrogen = {
        Cbar = 3.9996, I = 82, a = 0.5329, composition = {{"N", 1}}, delta0 = 0,
        density = 0.807, k = 3, x0 = 0.3039, x1 = 2
    },

    -- Liquid oxygen
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_oxygen.html
    LiquidOxygen = {
        Cbar = 3.9471, I = 95, a = 0.5223, composition = {{"O", 1}}, delta0 = 0,
        density = 1.141, k = 3, x0 = 0.2868, x1 = 2
    },

    -- Liquid propane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_propane.html
    LiquidPropane = {
        Cbar = 3.4162, I = 52, a = 0.1033, composition = {{"H", 0.182855}, {"C",
        0.817145}}, delta0 = 0, density = 0.493, k = 3.562, x0 = 0.2564,
        x1 = 2.6271
    },

    -- Liquid xenon
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/liquid_xenon_Xe.html
    LiquidXenon = {
        Cbar = 6.4396, I = 482, a = 0.2659, composition = {{"Xe", 1}},
        delta0 = 0, density = 2.953, k = 3, x0 = 0.5993, x1 = 3
    },

    -- Lithium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lithium_Li.html
    Lithium = {
        Cbar = 3.1221, I = 40, a = 0.9514, composition = {{"Li", 1}},
        delta0 = 0.14, density = 0.534, k = 2.4993, x0 = 0.1304, x1 = 1.6397
    },

    -- Lithium amide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lithium_amide.html
    LithiumAmide = {
        Cbar = 2.7961, I = 55.5, a = 0.0874, composition = {{"H", 0.087783},
        {"Li", 0.302262}, {"N", 0.609955}}, delta0 = 0, density = 1.178,
        k = 3.7534, x0 = 0.0198, x1 = 2.5152
    },

    -- Lithium carbonate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lithium_carbonate.html
    LithiumCarbonate = {
        Cbar = 3.2029, I = 87.9, a = 0.0994, composition = {{"Li", 0.187871},
        {"C", 0.16255}, {"O", 0.649579}}, delta0 = 0, density = 2.11,
        k = 3.5417, x0 = 0.0551, x1 = 2.6598
    },

    -- Lithium fluoride LiF
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lithium_fluoride_LiF.html
    LithiumFluoride = {
        Cbar = 3.1667, I = 94, a = 0.0759, composition = {{"Li", 0.267585},
        {"F", 0.732415}}, delta0 = 0, density = 2.635, k = 3.7478, x0 = 0.0171,
        x1 = 2.7049
    },

    -- Lithium hydride LiH
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lithium_hydride_LiH.html
    LithiumHydride = {
        Cbar = 2.358, I = 36.5, a = 0.9057, composition = {{"H", 0.126797},
        {"Li", 0.873203}}, delta0 = 0, density = 0.82, k = 2.5849, x0 = 0.0988,
        x1 = 1.4515
    },

    -- Lithium iodide LiI
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lithium_iodide_LiI.html
    LithiumIodide = {
        Cbar = 6.2671, I = 485.1, a = 0.2327, composition = {{"Li", 0.051858},
        {"I", 0.948142}}, delta0 = 0, density = 3.494, k = 2.7146, x0 = 0.0892,
        x1 = 3.3702
    },

    -- Lithium oxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lithium_oxide.html
    LithiumOxide = {
        Cbar = 2.934, I = 73.6, a = 0.0803, composition = {{"Li", 0.46457},
        {"O", 0.53543}}, delta0 = 0, density = 2.013, k = 3.7878, x0 = 0.0511,
        x1 = 2.5874
    },

    -- Lithium tetraborate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lithium_tetraborate.html
    LithiumTetraborate = {
        Cbar = 3.2093, I = 94.6, a = 0.1107, composition = {{"Li", 0.082085},
        {"B", 0.25568}, {"O", 0.662235}}, delta0 = 0, density = 2.44,
        k = 3.4389, x0 = 0.0737, x1 = 2.6502
    },

    -- Lung ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lung_ICRP.html
    LungICRP = {
        Cbar = 3.4708, I = 75.3, a = 0.0859, composition = {{"H", 0.101278},
        {"C", 0.10231}, {"N", 0.02865}, {"O", 0.757072}, {"Na", 0.00184}, {"Mg",
        0.00073}, {"P", 0.0008}, {"S", 0.00225}, {"Cl", 0.00266}, {"K",
        0.00194}, {"Ca", 9e-05}, {"Fe", 0.00037}, {"Zn", 1e-05}}, delta0 = 0,
        density = 1.05, k = 3.5353, x0 = 0.2261, x1 = 2.8001
    },

    -- Lutetium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lutetium_Lu.html
    Lutetium = {
        Cbar = 5.9784, I = 694, a = 0.2403, composition = {{"Lu", 1}},
        delta0 = 0.14, density = 9.841, k = 2.5643, x0 = 0.156, x1 = 3.5218
    },

    -- Lutetium aluminum oxide 1
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lutetium_aluminum_oxide_1.html
    LutetiumAluminumOxide1 = {
        Cbar = 5.0967, I = 423.2, a = 0.1902, composition = {{"Lu", 0.700017},
        {"Al", 0.107949}, {"O", 0.192034}}, delta0 = 0, density = 8.3, k = 3,
        x0 = 0.2, x1 = 3
    },

    -- Lutetium aluminum oxide 2
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lutetium_aluminum_oxide_2.html
    LutetiumAluminumOxide2 = {
        Cbar = 4.9994, I = 365.9, a = 0.1858, composition = {{"Lu", 0.616224},
        {"Al", 0.158379}, {"O", 0.225396}}, delta0 = 0, density = 6.73, k = 3,
        x0 = 0.2, x1 = 3
    },

    -- Lutetium fluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lutetium_fluoride.html
    LutetiumFluoride = {
        Cbar = 5.2803, I = 458.7, a = 0.1986, composition = {{"Lu", 0.754291},
        {"F", 0.245709}}, delta0 = 0, density = 8.3, k = 3, x0 = 0.2214, x1 = 3
    },

    -- Lutetium silicon oxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/lutetium_silicon_oxide.html
    LutetiumSiliconOxide = {
        Cbar = 5.4394, I = 472, a = 0.2062, composition = {{"Lu", 0.76402},
        {"Si", 0.06132}, {"O", 0.17466}}, delta0 = 0, density = 7.4, k = 3,
        x0 = 0.2732, x1 = 3
    },

    -- M3 WAX
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/M3_WAX.html
    M3WAX = {
        Cbar = 3.254, I = 67.9, a = 0.0786, composition = {{"H", 0.114318},
        {"C", 0.655823}, {"O", 0.092183}, {"Mg", 0.134792}, {"Ca", 0.002883}},
        delta0 = 0, density = 1.05, k = 3.6412, x0 = 0.1523, x1 = 2.7529
    },

    -- Magnesium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/magnesium_Mg.html
    Magnesium = {
        Cbar = 4.5297, I = 156, a = 0.0816, composition = {{"Mg", 1}},
        delta0 = 0.08, density = 1.74, k = 3.6166, x0 = 0.1499, x1 = 3.0668
    },

    -- Magnesium carbonate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/magnesium_carbonate.html
    MagnesiumCarbonate = {
        Cbar = 3.4319, I = 118, a = 0.0922, composition = {{"C", 0.142455},
        {"O", 0.569278}, {"Mg", 0.288267}}, delta0 = 0, density = 2.958,
        k = 3.5003, x0 = 0.086, x1 = 2.7997
    },

    -- Magnesium fluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/magnesium_fluoride.html
    MagnesiumFluoride = {
        Cbar = 3.7105, I = 134.3, a = 0.0793, composition = {{"F", 0.609883},
        {"Mg", 0.390117}}, delta0 = 0, density = 3, k = 3.6485, x0 = 0.1369,
        x1 = 2.863
    },

    -- Magnesium oxide MgO
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/magnesium_oxide_MgO.html
    MagnesiumOxide = {
        Cbar = 3.6404, I = 143.8, a = 0.0831, composition = {{"O", 0.396964},
        {"Mg", 0.603036}}, delta0 = 0, density = 3.58, k = 3.5968, x0 = 0.0575,
        x1 = 2.858
    },

    -- Magnesium tetraborate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/magnesium_tetraborate.html
    MagnesiumTetraborate = {
        Cbar = 3.4328, I = 108.3, a = 0.097, composition = {{"B", 0.240837},
        {"O", 0.62379}, {"Mg", 0.135373}}, delta0 = 0, density = 2.53,
        k = 3.4893, x0 = 0.1147, x1 = 2.7635
    },

    -- Manganese
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/manganese_Mn.html
    Manganese = {
        Cbar = 4.2702, I = 272, a = 0.1497, composition = {{"Mn", 1}},
        delta0 = 0.14, density = 7.44, k = 2.9796, x0 = 0.0447, x1 = 3.1074
    },

    -- Mercuric iodide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/mercuric_iodide.html
    MercuricIodide = {
        Cbar = 6.3787, I = 684.5, a = 0.2151, composition = {{"I", 0.55856},
        {"Hg", 0.44144}}, delta0 = 0, density = 6.36, k = 2.7264, x0 = 0.104,
        x1 = 3.4728
    },

    -- Mercury
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/mercury_Hg.html
    Mercury = {
        Cbar = 5.9605, I = 800, a = 0.1101, composition = {{"Hg", 1}},
        delta0 = 0.14, density = 13.55, k = 3.0519, x0 = 0.2756, x1 = 3.7275
    },

    -- Methane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/methane.html
    Methane = {
        Cbar = 9.5243, I = 41.7, a = 0.0925, composition = {{"H", 0.251306},
        {"C", 0.748694}}, delta0 = 0, density = 0.0006672, k = 3.6257,
        x0 = 1.6263, x1 = 3.9716
    },

    -- Methanol
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/methanol.html
    Methanol = {
        Cbar = 3.516, I = 67.6, a = 0.0897, composition = {{"H", 0.125822},
        {"C", 0.374852}, {"O", 0.499326}}, delta0 = 0, density = 0.7914,
        k = 3.5477, x0 = 0.2529, x1 = 2.7639
    },

    -- Mix D wax
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/mix_D_wax.html
    MixDWax = {
        Cbar = 3.078, I = 60.9, a = 0.0749, composition = {{"H", 0.13404}, {"C",
        0.77796}, {"O", 0.03502}, {"Mg", 0.038594}, {"Ti", 0.014386}},
        delta0 = 0, density = 0.99, k = 3.6823, x0 = 0.1371, x1 = 2.7145
    },

    -- Mn-dimethyl formamide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/mn-dimethyl_formamide.html
    MnDimethylFormamide = {
        Cbar = 3.3311, I = 66.6, a = 0.1147, composition = {{"H", 0.096523},
        {"C", 0.492965}, {"N", 0.191625}, {"O", 0.218887}}, delta0 = 0,
        density = 0.9487, k = 3.371, x0 = 0.1977, x1 = 2.6686
    },

    -- Molybdenum
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/molybdenum_Mo.html
    Molybdenum = {
        Cbar = 4.8793, I = 424, a = 0.1053, composition = {{"Mo", 1}},
        delta0 = 0.14, density = 10.22, k = 3.2549, x0 = 0.2267, x1 = 3.2784
    },

    -- Ms20 tissue substitute
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ms20_tissue_substitute.html
    Ms20TissueSubstitute = {
        Cbar = 3.5341, I = 75.1, a = 0.0829, composition = {{"H", 0.081192},
        {"C", 0.583442}, {"N", 0.017798}, {"O", 0.186381}, {"Mg", 0.130287},
        {"Cl", 0.0009}}, delta0 = 0, density = 1, k = 3.6061, x0 = 0.1997,
        x1 = 2.8033
    },

    -- Muscle-equivalent liquid without sucrose
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/muscle-equivalent_liquid_without_sucrose.html
    MuscleEquivalentLiquidWithoutSucrose = {
        Cbar = 3.4216, I = 74.2, a = 0.0914, composition = {{"H", 0.101969},
        {"C", 0.120058}, {"N", 0.035451}, {"O", 0.742522}}, delta0 = 0,
        density = 1.07, k = 3.4982, x0 = 0.2187, x1 = 2.768
    },

    -- Muscle-equivalent liquid with sucrose
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/muscle-equivalent_liquid_with_sucrose.html
    MuscleEquivalentLiquidWithSucrose = {
        Cbar = 3.391, I = 74.3, a = 0.0948, composition = {{"H", 0.098234},
        {"C", 0.156214}, {"N", 0.035451}, {"O", 0.7101}}, delta0 = 0,
        density = 1.11, k = 3.4699, x0 = 0.2098, x1 = 2.755
    },

    -- Naphtalene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/naphtalene.html
    Naphtalene = {
        Cbar = 3.2274, I = 68.4, a = 0.1477, composition = {{"H", 0.062909},
        {"C", 0.937091}}, delta0 = 0, density = 1.145, k = 3.2654, x0 = 0.1374,
        x1 = 2.5429
    },

    -- N-butyl alcohol
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/n-butyl_alcohol.html
    NButylAlcohol = {
        Cbar = 3.2425, I = 59.9, a = 0.1008, composition = {{"H", 0.135978},
        {"C", 0.648171}, {"O", 0.215851}}, delta0 = 0, density = 0.8098,
        k = 3.5139, x0 = 0.1937, x1 = 2.6439
    },

    -- Neodymium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/neodymium_Nd.html
    Neodymium = {
        Cbar = 5.8135, I = 546, a = 0.2353, composition = {{"Nd", 1}},
        delta0 = 0.14, density = 7.008, k = 2.705, x0 = 0.195, x1 = 3.3029
    },

    -- Neon gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/neon_gas_Ne.html
    NeonGas = {
        Cbar = 11.9041, I = 137, a = 0.0806, composition = {{"Ne", 1}},
        delta0 = 0, density = 0.0008385, k = 3.5771, x0 = 2.0735, x1 = 4.6421
    },

    -- Neptunium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/neptunium_Np.html
    Neptunium = {
        Cbar = 5.8149, I = 902, a = 0.1974, composition = {{"Np", 1}},
        delta0 = 0.14, density = 20.25, k = 2.8082, x0 = 0.1869, x1 = 3.369
    },

    -- N-heptane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/n-heptane.html
    NHeptane = {
        Cbar = 3.1978, I = 54.4, a = 0.1125, composition = {{"H", 0.160937},
        {"C", 0.839063}}, delta0 = 0, density = 0.6838, k = 3.4885, x0 = 0.1928,
        x1 = 2.5706
    },

    -- N-hexane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/n-hexane.html
    NHexane = {
        Cbar = 3.2156, I = 54, a = 0.1108, composition = {{"H", 0.163741}, {"C",
        0.836259}}, delta0 = 0, density = 0.6603, k = 3.5027, x0 = 0.1984,
        x1 = 2.5757
    },

    -- Nickel
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/nickel_Ni.html
    Nickel = {
        Cbar = 4.3115, I = 311, a = 0.165, composition = {{"Ni", 1}},
        delta0 = 0.1, density = 8.902, k = 2.843, x0 = 0.0566, x1 = 3.1851
    },

    -- Niobium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/niobium_Nb.html
    Niobium = {
        Cbar = 5.0141, I = 417, a = 0.1388, composition = {{"Nb", 1}},
        delta0 = 0.14, density = 8.57, k = 3.093, x0 = 0.1785, x1 = 3.2201
    },

    -- Nitrobenzene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/nitrobenzene.html
    Nitrobenzene = {
        Cbar = 3.4073, I = 75.8, a = 0.1273, composition = {{"H", 0.040935},
        {"C", 0.585374}, {"N", 0.113773}, {"O", 0.259918}}, delta0 = 0,
        density = 1.199, k = 3.3091, x0 = 0.1777, x1 = 2.663
    },

    -- Nitrogen gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/nitrogen_gas.html
    NitrogenGas = {
        Cbar = 10.54, I = 82, a = 0.1535, composition = {{"N", 1}}, delta0 = 0,
        density = 0.001165, k = 3.2125, x0 = 1.7378, x1 = 4.1323
    },

    -- Nitrous oxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/nitrous_oxide.html
    NitrousOxide = {
        Cbar = 10.1575, I = 84.9, a = 0.1199, composition = {{"N", 0.636483},
        {"O", 0.363517}}, delta0 = 0, density = 0.001831, k = 3.3318,
        x0 = 1.6477, x1 = 4.1565
    },

    -- N-pentane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/n-pentane.html
    NPentane = {
        Cbar = 3.2504, I = 53.6, a = 0.1081, composition = {{"H", 0.167635},
        {"C", 0.832365}}, delta0 = 0, density = 0.6262, k = 3.5265, x0 = 0.2086,
        x1 = 2.5855
    },

    -- N-propyl alcohol
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/n-propyl_alcohol.html
    NPropylAlcohol = {
        Cbar = 3.2915, I = 61.1, a = 0.0964, composition = {{"H", 0.134173},
        {"C", 0.599595}, {"O", 0.266232}}, delta0 = 0, density = 0.8035,
        k = 3.5415, x0 = 0.2046, x1 = 2.6681
    },

    -- Nylon du Pont Elvamide 8062M
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/Nylon_du_Pont_Elvamide_8062M.html
    NylonDuPontElvamide8062M = {
        Cbar = 3.125, I = 64.3, a = 0.1151, composition = {{"H", 0.103509},
        {"C", 0.648415}, {"N", 0.099536}, {"O", 0.148539}}, delta0 = 0,
        density = 1.08, k = 3.4044, x0 = 0.1503, x1 = 2.6004
    },

    -- Nylon type 11 Rilsan
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/Nylon_type_11_Rilsan.html
    NylonType11Rilsan = {
        Cbar = 2.7514, I = 61.6, a = 0.1487, composition = {{"H", 0.115476},
        {"C", 0.720819}, {"N", 0.076417}, {"O", 0.087289}}, delta0 = 0,
        density = 1.425, k = 3.2576, x0 = 0.0678, x1 = 2.4281
    },

    -- Nylon type 6-10
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/Nylon_type_6-10.html
    NylonType610 = {
        Cbar = 3.0333, I = 63.2, a = 0.1185, composition = {{"H", 0.107062},
        {"C", 0.680449}, {"N", 0.099189}, {"O", 0.1133}}, delta0 = 0,
        density = 1.14, k = 3.3912, x0 = 0.1304, x1 = 2.5681
    },

    -- Nylon type 6 6-6
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/Nylon_type_6_6-6.html
    NylonType666 = {
        Cbar = 3.0289, I = 63.9, a = 0.1182, composition = {{"H", 0.097976},
        {"C", 0.636856}, {"N", 0.123779}, {"O", 0.141389}}, delta0 = 0,
        density = 1.18, k = 3.3826, x0 = 0.1261, x1 = 2.5759
    },

    -- Octane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/octane.html
    Octane = {
        Cbar = 3.1834, I = 54.7, a = 0.1139, composition = {{"H", 0.158821},
        {"C", 0.841179}}, delta0 = 0, density = 0.7026, k = 3.4776, x0 = 0.1882,
        x1 = 2.5664
    },

    -- Oganesson
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/oganesson_Og.html
    Oganesson = {
        Cbar = 13.8662, I = 1242, a = 0.0703, composition = {{"Og", 1}},
        delta0 = 0, density = 0.012, k = 3, x0 = 2.0204, x1 = 1.9972
    },

    -- Osmium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/osmium_Os.html
    Osmium = {
        Cbar = 5.3083, I = 746, a = 0.1275, composition = {{"Os", 1}},
        delta0 = 0.1, density = 22.57, k = 2.9608, x0 = 0.0891, x1 = 3.5414
    },

    -- Oxygen gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/oxygen_gas.html
    OxygenGas = {
        Cbar = 10.7004, I = 95, a = 0.1178, composition = {{"O", 1}},
        delta0 = 0, density = 0.001332, k = 3.2913, x0 = 1.7541, x1 = 4.3213
    },

    -- Palladium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/palladium_Pd.html
    Palladium = {
        Cbar = 4.9358, I = 470, a = 0.2418, composition = {{"Pd", 1}},
        delta0 = 0.14, density = 12.02, k = 2.7239, x0 = 0.0563, x1 = 3.0555
    },

    -- Paraffin
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/paraffin.html
    Paraffin = {
        Cbar = 2.9551, I = 55.9, a = 0.1209, composition = {{"H", 0.148605},
        {"C", 0.851395}}, delta0 = 0, density = 0.93, k = 3.4288, x0 = 0.1289,
        x1 = 2.5084
    },

    -- Phosphorus
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/phosphorus_P.html
    Phosphorus = {
        Cbar = 4.5214, I = 173, a = 0.2361, composition = {{"P", 1}},
        delta0 = 0.14, density = 2.2, k = 2.9158, x0 = 0.1696, x1 = 2.7815
    },

    -- Photographic emulsion
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/photographic_emulsion.html
    PhotographicEmulsion = {
        Cbar = 5.3319, I = 331, a = 0.124, composition = {{"H", 0.0141}, {"C",
        0.072261}, {"N", 0.01932}, {"O", 0.066101}, {"S", 0.00189}, {"Br",
        0.349103}, {"Ag", 0.474105}, {"I", 0.00312}}, delta0 = 0,
        density = 3.815, k = 3.0094, x0 = 0.1009, x1 = 3.4866
    },

    -- Plate glass
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/plate_glass.html
    PlateGlass = {
        Cbar = 4.0602, I = 145.4, a = 0.0768, composition = {{"O", 0.4598},
        {"Na", 0.096441}, {"Si", 0.336553}, {"Ca", 0.107205}}, delta0 = 0,
        density = 2.4, k = 3.5381, x0 = 0.1237, x1 = 3.0649
    },

    -- Platinum
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/platinum_Pt.html
    Platinum = {
        Cbar = 5.4732, I = 790, a = 0.1113, composition = {{"Pt", 1}},
        delta0 = 0.12, density = 21.45, k = 3.0417, x0 = 0.1484, x1 = 3.6212
    },

    -- Plutonium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/plutonium_Pu.html
    Plutonium = {
        Cbar = 5.8748, I = 921, a = 0.2042, composition = {{"Pu", 1}},
        delta0 = 0.14, density = 19.84, k = 2.7679, x0 = 0.1557, x1 = 3.3981
    },

    -- Plutonium dioxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/plutonium_dioxide.html
    PlutoniumDioxide = {
        Cbar = 5.9719, I = 746.5, a = 0.2059, composition = {{"O", 0.118055},
        {"Pu", 0.881945}}, delta0 = 0, density = 11.46, k = 2.6522, x0 = 0.2311,
        x1 = 3.5554
    },

    -- Polonium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polonium_Po.html
    Polonium = {
        Cbar = 6.4003, I = 830, a = 0.0928, composition = {{"Po", 1}},
        delta0 = 0.14, density = 9.32, k = 3.183, x0 = 0.4267, x1 = 3.8293
    },

    -- Polyacrylonitrile
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyacrylonitrile.html
    Polyacrylonitrile = {
        Cbar = 3.2459, I = 69.6, a = 0.1628, composition = {{"H", 0.056983},
        {"C", 0.679056}, {"N", 0.263962}}, delta0 = 0, density = 1.17,
        k = 3.1975, x0 = 0.1504, x1 = 2.5159
    },

    -- Polycarbonate Lexan
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polycarbonate_Lexan.html
    PolycarbonateLexan = {
        Cbar = 3.3201, I = 73.1, a = 0.1286, composition = {{"H", 0.055491},
        {"C", 0.755751}, {"O", 0.188758}}, delta0 = 0, density = 1.2,
        k = 3.3288, x0 = 0.1606, x1 = 2.6225
    },

    -- Polychlorostyrene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polychlorostyrene.html
    Polychlorostyrene = {
        Cbar = 3.4659, I = 81.7, a = 0.0753, composition = {{"H", 0.061869},
        {"C", 0.696325}, {"Cl", 0.241806}}, delta0 = 0, density = 1.3,
        k = 3.5441, x0 = 0.1238, x1 = 2.9241
    },

    -- Polyethylene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyethylene.html
    Polyethylene = {
        Cbar = 3.0563, I = 57.4, a = 0.1211, composition = {{"H", 0.143711},
        {"C", 0.856289}}, delta0 = 0, density = 0.89, k = 3.4292, x0 = 0.1489,
        x1 = 2.5296
    },

    -- Polyethylene terephthalate Mylar
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyethylene_terephthalate_Mylar.html
    PolyethyleneTerephthalateMylar = {
        Cbar = 3.3262, I = 78.7, a = 0.1268, composition = {{"H", 0.041959},
        {"C", 0.625017}, {"O", 0.333025}}, delta0 = 0, density = 1.4,
        k = 3.3076, x0 = 0.1562, x1 = 2.6507
    },

    -- Polyimide film
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyimide_film.html
    PolyimideFilm = {
        Cbar = 3.3497, I = 79.6, a = 0.1597, composition = {{"H", 0.026362},
        {"C", 0.691133}, {"N", 0.07327}, {"O", 0.209235}}, delta0 = 0,
        density = 1.42, k = 3.1921, x0 = 0.1509, x1 = 2.5631
    },

    -- Polymethylmethacrylate acrylic
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polymethylmethacrylate_acrylic.html
    PolymethylmethacrylateAcrylic = {
        Cbar = 3.3297, I = 74, a = 0.1143, composition = {{"H", 0.080538}, {"C",
        0.599848}, {"O", 0.319614}}, delta0 = 0, density = 1.19, k = 3.3836,
        x0 = 0.1824, x1 = 2.6681
    },

    -- Polyoxymethylene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyoxymethylene.html
    Polyoxymethylene = {
        Cbar = 3.2514, I = 77.4, a = 0.1081, composition = {{"H", 0.067135},
        {"C", 0.400017}, {"O", 0.532848}}, delta0 = 0, density = 1.425,
        k = 3.4002, x0 = 0.1584, x1 = 2.6838
    },

    -- Polypropylene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polypropylene.html
    Polypropylene = {
        Cbar = 3.0395, I = 57.4, a = 0.1211, composition = {{"H", 0.143711},
        {"C", 0.856289}}, delta0 = 0, density = 0.905, k = 3.4292, x0 = 0.1452,
        x1 = 2.5259
    },

    -- Polystyrene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polystyrene.html
    Polystyrene = {
        Cbar = 3.2999, I = 68.7, a = 0.1645, composition = {{"H", 0.077418},
        {"C", 0.922582}}, delta0 = 0, density = 1.06, k = 3.2224, x0 = 0.1647,
        x1 = 2.5031
    },

    -- Polytetrafluoroethylene Teflon
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polytetrafluoroethylene_Teflon.html
    PolytetrafluoroethyleneTeflon = {
        Cbar = 3.4161, I = 99.1, a = 0.1061, composition = {{"C", 0.240183},
        {"F", 0.759817}}, delta0 = 0, density = 2.2, k = 3.4046, x0 = 0.1648,
        x1 = 2.7404
    },

    -- Polytrifluorochloroethylene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polytrifluorochloroethylene.html
    Polytrifluorochloroethylene = {
        Cbar = 3.8551, I = 120.7, a = 0.0773, composition = {{"C", 0.20625},
        {"F", 0.489354}, {"Cl", 0.304395}}, delta0 = 0, density = 2.1,
        k = 3.5085, x0 = 0.1714, x1 = 3.0265
    },

    -- Polyvinylacetate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyvinylacetate.html
    Polyvinylacetate = {
        Cbar = 3.3309, I = 73.7, a = 0.1144, composition = {{"H", 0.070245},
        {"C", 0.558066}, {"O", 0.371689}}, delta0 = 0, density = 1.19,
        k = 3.3762, x0 = 0.1769, x1 = 2.6747
    },

    -- Polyvinyl alcohol
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyvinyl_alcohol.html
    PolyvinylAlcohol = {
        Cbar = 3.1115, I = 69.7, a = 0.1118, composition = {{"H", 0.091517},
        {"C", 0.545298}, {"O", 0.363185}}, delta0 = 0, density = 1.3,
        k = 3.3893, x0 = 0.1401, x1 = 2.6315
    },

    -- Polyvinyl butyral
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyvinyl_butyral.html
    PolyvinylButyral = {
        Cbar = 3.1865, I = 67.2, a = 0.1154, composition = {{"H", 0.092802},
        {"C", 0.680561}, {"O", 0.226637}}, delta0 = 0, density = 1.12,
        k = 3.3983, x0 = 0.1555, x1 = 2.6186
    },

    -- Polyvinylchloride PVC
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyvinylchloride_PVC.html
    PolyvinylchloridePVC = {
        Cbar = 4.0532, I = 108.2, a = 0.1244, composition = {{"H", 0.04838},
        {"C", 0.38436}, {"Cl", 0.56726}}, delta0 = 0, density = 1.3, k = 3.2104,
        x0 = 0.1559, x1 = 2.9415
    },

    -- Polyvinylidene chloride Saran
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyvinylidene_chloride_Saran.html
    PolyvinylideneChlorideSaran = {
        Cbar = 4.2506, I = 134.3, a = 0.1547, composition = {{"H", 0.020793},
        {"C", 0.247793}, {"Cl", 0.731413}}, delta0 = 0, density = 1.7,
        k = 3.102, x0 = 0.1314, x1 = 2.9009
    },

    -- Polyvinylidene fluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyvinylidene_fluoride.html
    PolyvinylideneFluoride = {
        Cbar = 3.3793, I = 88.8, a = 0.1032, composition = {{"H", 0.03148},
        {"C", 0.375141}, {"F", 0.593379}}, delta0 = 0, density = 1.76, k = 3.42,
        x0 = 0.1717, x1 = 2.7375
    },

    -- Polyvinyl pyrrolidone
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyvinyl_pyrrolidone.html
    PolyvinylPyrrolidone = {
        Cbar = 3.1017, I = 67.7, a = 0.125, composition = {{"H", 0.081616},
        {"C", 0.648407}, {"N", 0.126024}, {"O", 0.143953}}, delta0 = 0,
        density = 1.25, k = 3.3326, x0 = 0.1324, x1 = 2.5867
    },

    -- Polyvinyltoluene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/polyvinyltoluene.html
    Polyvinyltoluene = {
        Cbar = 3.1997, I = 64.7, a = 0.161, composition = {{"H", 0.085}, {"C",
        0.915}}, delta0 = 0, density = 1.032, k = 3.2393, x0 = 0.1464,
        x1 = 2.4855
    },

    -- Potassium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/potassium_K.html
    Potassium = {
        Cbar = 5.6423, I = 190, a = 0.1983, composition = {{"K", 1}},
        delta0 = 0.1, density = 0.862, k = 2.9233, x0 = 0.3851, x1 = 3.1724
    },

    -- Potassium iodide KI
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/potassium_iodide_KI.html
    PotassiumIodide = {
        Cbar = 6.1088, I = 431.9, a = 0.2205, composition = {{"K", 0.235528},
        {"I", 0.764472}}, delta0 = 0, density = 3.13, k = 2.7558, x0 = 0.1044,
        x1 = 3.3442
    },

    -- Potassium oxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/potassium_oxide.html
    PotassiumOxide = {
        Cbar = 4.6463, I = 189.9, a = 0.1679, composition = {{"O", 0.169852},
        {"K", 0.830148}}, delta0 = 0, density = 2.32, k = 3.0121, x0 = 0.048,
        x1 = 3.011
    },

    -- Praseodymium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/praseodymium_Pr.html
    Praseodymium = {
        Cbar = 5.8003, I = 535, a = 0.2326, composition = {{"Pr", 1}},
        delta0 = 0.14, density = 6.773, k = 2.7331, x0 = 0.2313, x1 = 3.2753
    },

    -- Promethium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/promethium_Pm.html
    Promethium = {
        Cbar = 5.8163, I = 560, a = 0.2428, composition = {{"Pm", 1}},
        delta0 = 0.14, density = 7.264, k = 2.6674, x0 = 0.1614, x1 = 3.3186
    },

    -- Propane
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/propane.html
    Propane = {
        Cbar = 8.7939, I = 47.1, a = 0.0992, composition = {{"H", 0.182855},
        {"C", 0.817145}}, delta0 = 0, density = 0.001868, k = 3.592,
        x0 = 1.4339, x1 = 3.8011
    },

    -- Protactinium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/protactinium_Pa.html
    Protactinium = {
        Cbar = 6.0327, I = 878, a = 0.1477, composition = {{"Pa", 1}},
        delta0 = 0.14, density = 15.37, k = 2.9845, x0 = 0.3144, x1 = 3.5079
    },

    -- Pyridine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/pyridine.html
    Pyridine = {
        Cbar = 3.3148, I = 66.2, a = 0.164, composition = {{"H", 0.06371}, {"C",
        0.759217}, {"N", 0.177073}}, delta0 = 0, density = 0.9819, k = 3.1977,
        x0 = 0.167, x1 = 2.5245
    },

    -- Radium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/radium_Ra.html
    Radium = {
        Cbar = 7.0452, I = 826, a = 0.088, composition = {{"Ra", 1}},
        delta0 = 0.14, density = 5, k = 3.2454, x0 = 0.5991, x1 = 3.9428
    },

    -- Radon
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/radon_Rn.html
    Radon = {
        Cbar = 13.2839, I = 794, a = 0.208, composition = {{"Rn", 1}},
        delta0 = 0, density = 0.009066, k = 2.7409, x0 = 1.5368, x1 = 4.9889
    },

    -- Rhenium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/rhenium_Re.html
    Rhenium = {
        Cbar = 5.3445, I = 736, a = 0.1518, composition = {{"Re", 1}},
        delta0 = 0.08, density = 21.02, k = 2.8627, x0 = 0.0559, x1 = 3.4845
    },

    -- Rhodium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/rhodium_Rh.html
    Rhodium = {
        Cbar = 4.8008, I = 449, a = 0.192, composition = {{"Rh", 1}},
        delta0 = 0.14, density = 12.41, k = 2.8633, x0 = 0.0576, x1 = 3.1069
    },

    -- Rubber butyl
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/rubber_butyl.html
    RubberButyl = {
        Cbar = 2.9915, I = 56.5, a = 0.1211, composition = {{"H", 0.143711},
        {"C", 0.856289}}, delta0 = 0, density = 0.92, k = 3.4296, x0 = 0.1347,
        x1 = 2.5154
    },

    -- Rubber natural
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/rubber_natural.html
    RubberNatural = {
        Cbar = 3.1272, I = 59.8, a = 0.1506, composition = {{"H", 0.118371},
        {"C", 0.881629}}, delta0 = 0, density = 0.92, k = 3.2879, x0 = 0.1512,
        x1 = 2.4815
    },

    -- Rubber neoprene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/rubber_neoprene.html
    RubberNeoprene = {
        Cbar = 3.7911, I = 93, a = 0.0976, composition = {{"H", 0.05692}, {"C",
        0.542646}, {"Cl", 0.400434}}, delta0 = 0, density = 1.23, k = 3.3632,
        x0 = 0.1501, x1 = 2.9461
    },

    -- Rubidium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/rubidium_Rb.html
    Rubidium = {
        Cbar = 6.4776, I = 363, a = 0.0726, composition = {{"Rb", 1}},
        delta0 = 0.14, density = 1.532, k = 3.4177, x0 = 0.5737, x1 = 3.7995
    },

    -- Ruthenium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ruthenium_Ru.html
    Ruthenium = {
        Cbar = 4.7694, I = 441, a = 0.1934, composition = {{"Ru", 1}},
        delta0 = 0.14, density = 12.41, k = 2.8707, x0 = 0.0599, x1 = 3.0834
    },

    -- Samarium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/samarium_Sm.html
    Samarium = {
        Cbar = 5.8517, I = 574, a = 0.247, composition = {{"Sm", 1}},
        delta0 = 0.14, density = 7.52, k = 2.6403, x0 = 0.1503, x1 = 3.3443
    },

    -- Scandium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/scandium_Sc.html
    Scandium = {
        Cbar = 4.6949, I = 216, a = 0.1575, composition = {{"Sc", 1}},
        delta0 = 0.1, density = 2.989, k = 3.0517, x0 = 0.164, x1 = 3.0593
    },

    -- Selenium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/selenium_Se.html
    Selenium = {
        Cbar = 5.321, I = 348, a = 0.0657, composition = {{"Se", 1}},
        delta0 = 0.1, density = 4.5, k = 3.4317, x0 = 0.2258, x1 = 3.6264
    },

    -- Shielding concrete
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/shielding_concrete.html
    ShieldingConcrete = {
        Cbar = 3.9464, I = 135.2, a = 0.0751, composition = {{"H", 0.01}, {"C",
        0.001}, {"O", 0.529107}, {"Na", 0.016}, {"Mg", 0.002}, {"Al", 0.033872},
        {"Si", 0.337021}, {"K", 0.013}, {"Ca", 0.044}, {"Fe", 0.014}},
        delta0 = 0, density = 2.3, k = 3.5467, x0 = 0.1301, x1 = 3.0466
    },

    -- Silica aerogel
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/silica_aerogel.html
    SilicaAerogel = {
        Cbar = 6.4507, I = 139.2, a = 0.2668, composition = {{"O", 0.543192},
        {"Si", 0.453451}, {"H", 0.003357}}, delta0 = 0, density = 0.2, k = 3,
        x0 = 0.6029, x1 = 3
    },

    -- Silicon
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/silicon_Si.html
    Silicon = {
        Cbar = 4.4355, I = 173, a = 0.1492, composition = {{"Si", 1}},
        delta0 = 0.14, density = 2.329, k = 3.2546, x0 = 0.2015, x1 = 2.8716
    },

    -- Silicon dioxide fused quartz
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/silicon_dioxide_fused_quartz.html
    SiliconDioxideFusedQuartz = {
        Cbar = 4.056, I = 139.2, a = 0.0841, composition = {{"O", 0.532565},
        {"Si", 0.467435}}, delta0 = 0, density = 2.2, k = 3.5064, x0 = 0.15,
        x1 = 3.014
    },

    -- Silver
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/silver_Ag.html
    Silver = {
        Cbar = 5.063, I = 470, a = 0.2458, composition = {{"Ag", 1}},
        delta0 = 0.14, density = 10.5, k = 2.6899, x0 = 0.0657, x1 = 3.1074
    },

    -- Silver bromide AgBr
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/silver_bromide_AgBr.html
    SilverBromide = {
        Cbar = 5.6139, I = 486.6, a = 0.2458, composition = {{"Br", 0.425537},
        {"Ag", 0.574463}}, delta0 = 0, density = 6.473, k = 2.682, x0 = 0.0352,
        x1 = 3.2109
    },

    -- Silver chloride AgCl
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/silver_chloride_AgCl.html
    SilverChloride = {
        Cbar = 5.3437, I = 398.4, a = 0.2297, composition = {{"Cl", 0.247368},
        {"Ag", 0.752632}}, delta0 = 0, density = 5.56, k = 2.7041, x0 = 0.0139,
        x1 = 3.2022
    },

    -- Silver iodide AgI
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/silver_iodide_AgI.html
    SilverIodide = {
        Cbar = 5.9342, I = 543.5, a = 0.2506, composition = {{"Ag", 0.459458},
        {"I", 0.540542}}, delta0 = 0, density = 6.01, k = 2.6572, x0 = 0.0148,
        x1 = 3.2908
    },

    -- Skeletal muscle ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/skeletal_muscle_ICRP.html
    SkeletalMuscleICRP = {
        Cbar = 3.4809, I = 75.3, a = 0.0864, composition = {{"H", 0.100637},
        {"C", 0.10783}, {"N", 0.02768}, {"O", 0.754773}, {"Na", 0.00075}, {"Mg",
        0.00019}, {"P", 0.0018}, {"S", 0.00241}, {"Cl", 0.00079}, {"K",
        0.00302}, {"Ca", 3e-05}, {"Fe", 4e-05}, {"Zn", 5e-05}}, delta0 = 0,
        density = 1.04, k = 3.533, x0 = 0.2282, x1 = 2.7999
    },

    -- Skin ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/skin_ICRP.html
    SkinICRP = {
        Cbar = 3.3546, I = 72.7, a = 0.0946, composition = {{"H", 0.100588},
        {"C", 0.22825}, {"N", 0.04642}, {"O", 0.619002}, {"Na", 7e-05}, {"Mg",
        6e-05}, {"P", 0.00033}, {"S", 0.00159}, {"Cl", 0.00267}, {"K", 0.00085},
        {"Ca", 0.00015}, {"Fe", 1e-05}, {"Zn", 1e-05}}, delta0 = 0,
        density = 1.1, k = 3.4643, x0 = 0.2019, x1 = 2.7526
    },

    -- Sodium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/sodium_Na.html
    Sodium = {
        Cbar = 5.0526, I = 149, a = 0.0777, composition = {{"Na", 1}},
        delta0 = 0.08, density = 0.971, k = 3.6452, x0 = 0.288, x1 = 3.1962
    },

    -- Sodium carbonate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/sodium_carbonate.html
    SodiumCarbonate = {
        Cbar = 3.7178, I = 125, a = 0.0872, composition = {{"C", 0.113323},
        {"O", 0.452861}, {"Na", 0.433815}}, delta0 = 0, density = 2.532,
        k = 3.5638, x0 = 0.1287, x1 = 2.8591
    },

    -- Sodium chloride NaCl
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/sodium_chloride_NaCl.html
    SodiumChloride = {
        Cbar = 4.4227, I = 175.3, a = 0.1596, composition = {{"Na", 0.393375},
        {"Cl", 0.606626}}, delta0 = 0, density = 2.17, k = 3, x0 = 0.1995,
        x1 = 2.9995
    },

    -- Sodium iodide NaI
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/sodium_iodide_NaI.html
    SodiumIodide = {
        Cbar = 6.0572, I = 452, a = 0.1252, composition = {{"Na", 0.153373},
        {"I", 0.846627}}, delta0 = 0, density = 3.667, k = 3.0398, x0 = 0.1203,
        x1 = 3.592
    },

    -- Sodium monoxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/sodium_monoxide.html
    SodiumMonoxide = {
        Cbar = 4.1892, I = 148.8, a = 0.075, composition = {{"O", 0.258143},
        {"Na", 0.741857}}, delta0 = 0, density = 2.27, k = 3.6943, x0 = 0.1652,
        x1 = 2.9793
    },

    -- Sodium nitrate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/sodium_nitrate.html
    SodiumNitrate = {
        Cbar = 3.6502, I = 114.6, a = 0.0939, composition = {{"N", 0.164795},
        {"O", 0.56472}, {"Na", 0.270485}}, delta0 = 0, density = 2.261,
        k = 3.5097, x0 = 0.1534, x1 = 2.8221
    },

    -- Soft tissue ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/soft_tissue_ICRP.html
    SoftTissueICRP = {
        Cbar = 3.4354, I = 72.3, a = 0.0893, composition = {{"H", 0.104472},
        {"C", 0.23219}, {"N", 0.02488}, {"O", 0.630238}, {"Na", 0.00113}, {"Mg",
        0.00013}, {"P", 0.00133}, {"S", 0.00199}, {"Cl", 0.00134}, {"K",
        0.00199}, {"Ca", 0.00023}, {"Fe", 5e-05}, {"Zn", 3e-05}}, delta0 = 0,
        density = 1, k = 3.511, x0 = 0.2211, x1 = 2.7799
    },

    -- Soft tissue ICRU four-component
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/soft_tissue_ICRU_four-component.html
    SoftTissueICRUFourComponent = {
        Cbar = 3.5087, I = 74.9, a = 0.0963, composition = {{"H", 0.101172},
        {"C", 0.111}, {"N", 0.026}, {"O", 0.761828}}, delta0 = 0, density = 1,
        k = 3.4371, x0 = 0.2377, x1 = 2.7908
    },

    -- Solid carbon dioxide dry ice
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/solid_carbon_dioxide_dry_ice.html
    SolidCarbonDioxideDryIce = {
        Cbar = 3.4513, I = 85, a = 0.4339, composition = {{"C", 0.272916}, {"O",
        0.727084}}, delta0 = 0, density = 1.563, k = 3, x0 = 0.2, x1 = 2
    },

    -- Standard rock
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/standard_rock.html
    StandardRock = {
        Cbar = 3.7738, I = 136.4, a = 0.083, composition = {{"Rk", 1}},
        delta0 = 0, density = 2.65, k = 3.412, x0 = 0.0492, x1 = 3.0549
    },

    -- Stilbene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/stilbene.html
    Stilbene = {
        Cbar = 3.368, I = 67.7, a = 0.1666, composition = {{"H", 0.067101},
        {"C", 0.932899}}, delta0 = 0, density = 0.9707, k = 3.2168, x0 = 0.1734,
        x1 = 2.5142
    },

    -- Striated muscle ICRU
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/striated_muscle_ICRU.html
    StriatedMuscleICRU = {
        Cbar = 3.4636, I = 74.7, a = 0.0851, composition = {{"H", 0.101997},
        {"C", 0.123}, {"N", 0.035}, {"O", 0.729003}, {"Na", 0.0008}, {"Mg",
        0.0002}, {"P", 0.002}, {"S", 0.005}, {"K", 0.005}}, delta0 = 0,
        density = 1.04, k = 3.5383, x0 = 0.2249, x1 = 2.8032
    },

    -- Strontium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/strontium_Sr.html
    Strontium = {
        Cbar = 5.9867, I = 366, a = 0.0716, composition = {{"Sr", 1}},
        delta0 = 0.14, density = 2.54, k = 3.4435, x0 = 0.4585, x1 = 3.6778
    },

    -- Sucrose
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/sucrose.html
    Sucrose = {
        Cbar = 3.1526, I = 77.5, a = 0.113, composition = {{"H", 0.064779},
        {"C", 0.42107}, {"O", 0.514151}}, delta0 = 0, density = 1.581,
        k = 3.363, x0 = 0.1341, x1 = 2.6558
    },

    -- Sulfur
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/sulfur_S.html
    Sulfur = {
        Cbar = 4.6659, I = 180, a = 0.3399, composition = {{"S", 1}},
        delta0 = 0.14, density = 2, k = 2.6456, x0 = 0.158, x1 = 2.7159
    },

    -- Tantalum
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/tantalum_Ta.html
    Tantalum = {
        Cbar = 5.5262, I = 718, a = 0.178, composition = {{"Ta", 1}},
        delta0 = 0.14, density = 16.65, k = 2.7623, x0 = 0.2117, x1 = 3.4805
    },

    -- Technetium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/technetium_Tc.html
    Technetium = {
        Cbar = 4.7769, I = 428, a = 0.1657, composition = {{"Tc", 1}},
        delta0 = 0.14, density = 11.5, k = 2.9738, x0 = 0.0949, x1 = 3.1253
    },

    -- Tellurium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/tellurium_Te.html
    Tellurium = {
        Cbar = 5.7131, I = 485, a = 0.1382, composition = {{"Te", 1}},
        delta0 = 0.14, density = 6.24, k = 3.0354, x0 = 0.3296, x1 = 3.4418
    },

    -- Terbium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/terbium_Tb.html
    Terbium = {
        Cbar = 5.9044, I = 614, a = 0.2445, composition = {{"Tb", 1}},
        delta0 = 0.14, density = 8.23, k = 2.6056, x0 = 0.0947, x1 = 3.4224
    },

    -- Terphenyl
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/terphenyl.html
    Terphenyl = {
        Cbar = 3.2639, I = 71.7, a = 0.1496, composition = {{"H", 0.044543},
        {"C", 0.955457}}, delta0 = 0, density = 1.234, k = 3.2685, x0 = 0.1322,
        x1 = 2.5429
    },

    -- Testes ICRP
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/testes_ICRP.html
    TestesICRP = {
        Cbar = 3.4698, I = 75, a = 0.0853, composition = {{"H", 0.104166}, {"C",
        0.09227}, {"N", 0.01994}, {"O", 0.773884}, {"Na", 0.00226}, {"Mg",
        0.00011}, {"P", 0.00125}, {"S", 0.00146}, {"Cl", 0.00244}, {"K",
        0.00208}, {"Ca", 0.0001}, {"Fe", 2e-05}, {"Zn", 2e-05}}, delta0 = 0,
        density = 1.04, k = 3.5428, x0 = 0.2274, x1 = 2.7988
    },

    -- Tetrachloroethylene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/tetrachloroethylene.html
    Tetrachloroethylene = {
        Cbar = 4.6619, I = 159.2, a = 0.1859, composition = {{"C", 0.144856},
        {"Cl", 0.855144}}, delta0 = 0, density = 1.625, k = 3.0156, x0 = 0.1713,
        x1 = 2.9083
    },

    -- Thallium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/thallium_Tl.html
    Thallium = {
        Cbar = 6.1365, I = 810, a = 0.0945, composition = {{"Tl", 1}},
        delta0 = 0.14, density = 11.72, k = 3.145, x0 = 0.3491, x1 = 3.8044
    },

    -- Thallium chloride TlCl
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/thallium_chloride_TlCl.html
    ThalliumChloride = {
        Cbar = 6.3009, I = 690.3, a = 0.186, composition = {{"Cl", 0.147822},
        {"Tl", 0.852187}}, delta0 = 0, density = 7.004, k = 2.769, x0 = 0.0705,
        x1 = 3.5716
    },

    -- Thorium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/thorium_Th.html
    Thorium = {
        Cbar = 6.2473, I = 847, a = 0.0865, composition = {{"Th", 1}},
        delta0 = 0.14, density = 11.72, k = 3.261, x0 = 0.4202, x1 = 3.7681
    },

    -- Thulium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/thulium_Tm.html
    Thulium = {
        Cbar = 5.9677, I = 674, a = 0.2489, composition = {{"Tm", 1}},
        delta0 = 0.14, density = 9.321, k = 2.5469, x0 = 0.0812, x1 = 3.5085
    },

    -- Tin
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/tin_Sn.html
    Tin = {
        Cbar = 5.534, I = 488, a = 0.1869, composition = {{"Sn", 1}},
        delta0 = 0.14, density = 7.31, k = 2.8576, x0 = 0.2879, x1 = 3.2959
    },

    -- Tissue-equivalent gas Methane based
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/tissue-equivalent_gas_Methane_based.html
    TissueEquivalentGasMethaneBased = {
        Cbar = 9.95, I = 61.2, a = 0.0995, composition = {{"H", 0.101869}, {"C",
        0.456179}, {"N", 0.035172}, {"O", 0.40678}}, delta0 = 0,
        density = 0.001064, k = 3.4708, x0 = 1.6442, x1 = 4.1399
    },

    -- Tissue-equivalent gas Propane based
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/tissue-equivalent_gas_Propane_based.html
    TissueEquivalentGasPropaneBased = {
        Cbar = 9.3529, I = 59.5, a = 0.098, composition = {{"H", 0.102672},
        {"C", 0.56894}, {"N", 0.035022}, {"O", 0.293366}}, delta0 = 0,
        density = 0.001826, k = 3.5159, x0 = 1.5139, x1 = 3.9916
    },

    -- Titanium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/titanium_Ti.html
    Titanium = {
        Cbar = 4.445, I = 233, a = 0.1566, composition = {{"Ti", 1}},
        delta0 = 0.12, density = 4.54, k = 3.0302, x0 = 0.0957, x1 = 3.0386
    },

    -- Titanium dioxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/titanium_dioxide.html
    TitaniumDioxide = {
        Cbar = 3.9522, I = 179.5, a = 0.0857, composition = {{"O", 0.400592},
        {"Ti", 0.599408}}, delta0 = 0, density = 4.26, k = 3.3267, x0 = 0.0119,
        x1 = 3.1647
    },

    -- Toluene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/toluene.html
    Toluene = {
        Cbar = 3.3026, I = 62.5, a = 0.1328, composition = {{"H", 0.08751},
        {"C", 0.91249}}, delta0 = 0, density = 0.8669, k = 3.3558, x0 = 0.1722,
        x1 = 2.5728
    },

    -- Trichloroethylene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/trichloroethylene.html
    Trichloroethylene = {
        Cbar = 4.6148, I = 148.1, a = 0.1827, composition = {{"H", 0.007671},
        {"C", 0.182831}, {"Cl", 0.809498}}, delta0 = 0, density = 1.46,
        k = 3.0137, x0 = 0.1803, x1 = 2.914
    },

    -- Triethyl phosphate
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/triethyl_phosphate.html
    TriethylPhosphate = {
        Cbar = 3.6242, I = 81.2, a = 0.0692, composition = {{"H", 0.082998},
        {"C", 0.395628}, {"O", 0.351334}, {"P", 0.17004}}, delta0 = 0,
        density = 1.07, k = 3.6302, x0 = 0.2054, x1 = 2.9428
    },

    -- Tungsten
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/tungsten_W.html
    Tungsten = {
        Cbar = 5.4059, I = 727, a = 0.1551, composition = {{"W", 1}},
        delta0 = 0.14, density = 19.3, k = 2.8447, x0 = 0.2167, x1 = 3.496
    },

    -- Tungsten hexafluoride
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/tungsten_hexafluoride.html
    TungstenHexafluoride = {
        Cbar = 5.9881, I = 354.4, a = 0.0366, composition = {{"F", 0.382723},
        {"W", 0.617277}}, delta0 = 0, density = 2.4, k = 3.5134, x0 = 0.302,
        x1 = 4.2602
    },

    -- Uranium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/uranium_U.html
    Uranium = {
        Cbar = 5.8694, I = 890, a = 0.1968, composition = {{"U", 1}},
        delta0 = 0.14, density = 18.95, k = 2.8171, x0 = 0.226, x1 = 3.3721
    },

    -- Uranium dicarbide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/uranium_dicarbide.html
    UraniumDicarbide = {
        Cbar = 6.0247, I = 752, a = 0.2112, composition = {{"C", 0.091669},
        {"U", 0.908331}}, delta0 = 0, density = 11.28, k = 2.6577, x0 = 0.2191,
        x1 = 3.5208
    },

    -- Uranium monocarbide UC
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/uranium_monocarbide_UC.html
    UraniumMonocarbide = {
        Cbar = 6.121, I = 862, a = 0.2297, composition = {{"C", 0.048036}, {"U",
        0.951964}}, delta0 = 0, density = 13.63, k = 2.6169, x0 = 0.2524,
        x1 = 3.4941
    },

    -- Uranium oxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/uranium_oxide.html
    UraniumOxide = {
        Cbar = 5.9605, I = 720.6, a = 0.2046, composition = {{"O", 0.118502},
        {"U", 0.881498}}, delta0 = 0, density = 10.96, k = 2.6711, x0 = 0.1938,
        x1 = 3.5292
    },

    -- Urea
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/urea.html
    Urea = {
        Cbar = 3.2032, I = 72.8, a = 0.1161, composition = {{"H", 0.067131},
        {"C", 0.199999}, {"N", 0.466459}, {"O", 0.266411}}, delta0 = 0,
        density = 1.323, k = 3.3461, x0 = 0.1603, x1 = 2.6525
    },

    -- Valine
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/valine.html
    Valine = {
        Cbar = 3.1059, I = 67.7, a = 0.1139, composition = {{"H", 0.094641},
        {"C", 0.512645}, {"N", 0.119565}, {"O", 0.27315}}, delta0 = 0,
        density = 1.23, k = 3.3774, x0 = 0.1441, x1 = 2.6227
    },

    -- Vanadium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/vanadium_V.html
    Vanadium = {
        Cbar = 4.2659, I = 245, a = 0.1544, composition = {{"V", 1}},
        delta0 = 0.14, density = 6.11, k = 3.0163, x0 = 0.0691, x1 = 3.0322
    },

    -- Viton fluoroelastomer
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/viton_fluoroelastomer.html
    VitonFluoroelastomer = {
        Cbar = 3.5943, I = 98.6, a = 0.0997, composition = {{"H", 0.009417},
        {"C", 0.280555}, {"F", 0.710028}}, delta0 = 0, density = 1.8,
        k = 3.4556, x0 = 0.2106, x1 = 2.7874
    },

    -- Water ice
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/water_ice.html
    WaterIce = {
        Cbar = 3.5873, I = 79.7, a = 0.0912, composition = {{"H", 0.111894},
        {"O", 0.888106}}, delta0 = 0, density = 0.918, k = 3.4773, x0 = 0.2586,
        x1 = 2.819
    },

    -- Water liquid
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/water_liquid.html
    WaterLiquid = {
        Cbar = 3.5017, I = 79.7, a = 0.0912, composition = {{"H", 0.111894},
        {"O", 0.888106}}, delta0 = 0, density = 1, k = 3.4773, x0 = 0.24,
        x1 = 2.8004
    },

    -- Water vapor
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/water_vapor.html
    WaterVapor = {
        Cbar = 10.5962, I = 71.6, a = 0.081, composition = {{"H", 0.111894},
        {"O", 0.888106}}, delta0 = 0, density = 0.0007562, k = 3.5901,
        x0 = 1.7952, x1 = 4.3437
    },

    -- Xenon gas
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/xenon_gas_Xe.html
    XenonGas = {
        Cbar = 12.7285, I = 482, a = 0.2331, composition = {{"Xe", 1}},
        delta0 = 0, density = 0.005483, k = 2.7414, x0 = 1.5631, x1 = 4.7372
    },

    -- Xylene
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/xylene.html
    Xylene = {
        Cbar = 3.2698, I = 61.8, a = 0.1322, composition = {{"H", 0.094935},
        {"C", 0.905065}}, delta0 = 0, density = 0.87, k = 3.3564, x0 = 0.1695,
        x1 = 2.5675
    },

    -- Ytterbium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/ytterbium_Yb.html
    Ytterbium = {
        Cbar = 6.3071, I = 684, a = 0.253, composition = {{"Yb", 1}},
        delta0 = 0.14, density = 6.903, k = 2.5141, x0 = 0.1144, x1 = 3.6191
    },

    -- Yttrium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/yttrium_Y.html
    Yttrium = {
        Cbar = 5.4801, I = 379, a = 0.0714, composition = {{"Y", 1}},
        delta0 = 0.14, density = 4.469, k = 3.4585, x0 = 0.3608, x1 = 3.5542
    },

    -- Yttrium aluminum oxide 1
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/yttrium_aluminum_oxide_1.html
    YttriumAluminumOxide1 = {
        Cbar = 4.2973, I = 239.3, a = 0.1538, composition = {{"Y", 0.542487},
        {"Al", 0.164636}, {"O", 0.292876}}, delta0 = 0, density = 5.5, k = 3,
        x0 = 0.2, x1 = 3
    },

    -- Yttrium aluminum oxide 2
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/yttrium_aluminum_oxide_2.html
    YttriumAluminumOxide2 = {
        Cbar = 4.2884, I = 218, a = 0.1534, composition = {{"Y", 0.449308},
        {"Al", 0.227263}, {"O", 0.323428}}, delta0 = 0, density = 4.56, k = 3,
        x0 = 0.2, x1 = 3
    },

    -- Yttrium bromide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/yttrium_bromide.html
    YttriumBromide = {
        Cbar = 5.4697, I = 410, a = 0.2077, composition = {{"Y", 0.270545},
        {"Br", 0.729455}}, delta0 = 0, density = 5.29, k = 3, x0 = 0.2831,
        x1 = 3
    },

    -- Yttrium silicon oxide
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/yttrium_silicon_oxide.html
    YttriumSiliconOxide = {
        Cbar = 4.6447, I = 258.1, a = 0.1696, composition = {{"Y", 0.621949},
        {"Si", 0.098237}, {"O", 0.279813}}, delta0 = 0, density = 4.54, k = 3,
        x0 = 0.2, x1 = 3
    },

    -- Zinc
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/zinc_Zn.html
    Zinc = {
        Cbar = 4.6906, I = 330, a = 0.1471, composition = {{"Zn", 1}},
        delta0 = 0.08, density = 7.133, k = 2.8652, x0 = 0.0049, x1 = 3.3668
    },

    -- Zirconium
    -- Ref: http://pdg.lbl.gov/2019/AtomicNuclearProperties/HTML/zirconium_Zr.html
    Zirconium = {
        Cbar = 5.1774, I = 393, a = 0.0718, composition = {{"Zr", 1}},
        delta0 = 0.14, density = 6.506, k = 3.4533, x0 = 0.2957, x1 = 3.489
    },

}
