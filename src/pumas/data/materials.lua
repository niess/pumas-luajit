-- Tabulated materials from the Particle Data Group (PDG)
-- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/index.html

return {

    -- A-150 tissue-equivalent plastic
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/a-150_tissue-equivalent_plastic.html
    A150TissueEquivalentPlastic = {
        ZoA = 0.5489578, x0 = 0.1329, I = 6.51E-08, x1 = 2.6234, density = 1127,
        delta0 = 0, state = 'liquid', k = 3.4442, a = 0.1078, Cbar = 3.11,
        elements = {O = 0.052316, N = 0.035057, Ca = 0.018378, H = 0.101327,
        C = 0.775501, F = 0.017422}
    },

    -- Acetone
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/acetone.html
    Acetone = {
        ZoA = 0.55089, x0 = 0.2197, I = 6.42E-08, x1 = 2.6928, density = 789.9,
        delta0 = 0, state = 'liquid', k = 3.4047, a = 0.111, Cbar = 3.4341,
        elements = {H = 0.104122, C = 0.620405, O = 0.275473}
    },

    -- Acetylene CHCH
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/acetylene_CHCH.html
    AcetyleneCHCH = {
        ZoA = 0.5376265, x0 = 1.6017, I = 5.82E-08, x1 = 4.0074,
        density = 1.097, delta0 = 0, state = 'gaz', k = 3.4277, a = 0.1217,
        Cbar = 9.8419, elements = {C = 0.922582, H = 0.077418}
    },

    -- Actinium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/actinium_Ac.html
    Actinium = {
        ZoA = 0.3920221, x0 = 0.4559, I = 8.41E-07, x1 = 3.7966,
        density = 10070, delta0 = 0.14, state = 'liquid', k = 3.2683,
        a = 0.0857, Cbar = 6.3742, elements = {Ac = 1}
    },

    -- Adenine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/adenine.html
    Adenine = {
        ZoA = 0.5179918, x0 = 0.1295, I = 7.14E-08, x1 = 2.4219, density = 1350,
        delta0 = 0, state = 'liquid', k = 3.0271, a = 0.2091, Cbar = 3.1724,
        elements = {H = 0.037294, C = 0.44443, N = 0.518275}
    },

    -- Adipose tissue ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/adipose_tissue_ICRP.html
    AdiposeTissueICRP = {
        ZoA = 0.55838, x0 = 0.1827, I = 6.32E-08, x1 = 2.653, density = 920,
        delta0 = 0, state = 'liquid', k = 3.4817, a = 0.1028, Cbar = 3.2367,
        elements = {K = 0.00032, O = 0.232333, S = 0.00073, H = 0.119477,
        P = 0.00016, Fe = 2E-05, Zn = 2E-05, Ca = 2E-05, Na = 0.0005,
        Cl = 0.00119, Mg = 2E-05, C = 0.63724, N = 0.00797}
    },

    -- Ag halides in phot emulsion
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ag_halides_in_phot_emulsion.html
    AgHalidesInPhotEmulsion = {
        ZoA = 0.4366328, x0 = 0.0353, I = 4.871E-07, x1 = 3.2117,
        density = 6470, delta0 = 0, state = 'liquid', k = 2.6814, a = 0.2459,
        Cbar = 5.6166, elements = {I = 0.003357, Br = 0.422895, Ag = 0.573748}
    },

    -- Air dry 1 atm
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/air_dry_1_atm.html
    AirDry1Atm = {
        ZoA = 0.4991766, x0 = 1.7418, I = 8.57E-08, x1 = 4.2759,
        density = 1.205, delta0 = 0, state = 'gaz', k = 3.3994, a = 0.1091,
        Cbar = 10.5961, elements = {Ar = 0.012827, O = 0.231781, C = 0.000124,
        N = 0.755267}
    },

    -- Alanine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/alanine.html
    Alanine = {
        ZoA = 0.5386981, x0 = 0.1354, I = 7.19E-08, x1 = 2.6336, density = 1420,
        delta0 = 0, state = 'liquid', k = 3.3526, a = 0.1148, Cbar = 3.0965,
        elements = {O = 0.359159, H = 0.07919, C = 0.404439, N = 0.157213}
    },

    -- Aluminum
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/aluminum_Al.html
    Aluminum = {
        ZoA = 0.4818116, x0 = 0.1708, I = 1.66E-07, x1 = 3.0127, density = 2699,
        delta0 = 0.12, state = 'liquid', k = 3.6345, a = 0.0802, Cbar = 4.2395,
        elements = {Al = 1}
    },

    -- Aluminum oxide sapphire
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/aluminum_oxide_sapphire.html
    AluminumOxideSapphire = {
        ZoA = 0.4903841, x0 = 0.0402, I = 1.452E-07, x1 = 2.8665,
        density = 3970, delta0 = 0, state = 'liquid', k = 3.5458, a = 0.085,
        Cbar = 3.5682, elements = {Al = 0.529251, O = 0.470749}
    },

    -- Amber
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/amber.html
    Amber = {
        ZoA = 0.5516984, x0 = 0.1335, I = 6.32E-08, x1 = 2.561, density = 1100,
        delta0 = 0, state = 'liquid', k = 3.4098, a = 0.1193, Cbar = 3.0701,
        elements = {H = 0.10593, C = 0.788973, O = 0.105096}
    },

    -- Americium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/americium_Am.html
    Americium = {
        ZoA = 0.3908484, x0 = 0.2274, I = 9.34E-07, x1 = 3.5021,
        density = 13670, delta0 = 0.14, state = 'liquid', k = 2.7615,
        a = 0.2031, Cbar = 6.2813, elements = {Am = 1}
    },

    -- Ammonia
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ammonia.html
    Ammonia = {
        ZoA = 0.5870308, x0 = 1.6822, I = 5.37E-08, x1 = 4.1158,
        density = 0.826, delta0 = 0, state = 'gaz', k = 3.6464, a = 0.0831,
        Cbar = 9.8763, elements = {N = 0.822453, H = 0.177547}
    },

    -- Aniline
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/aniline.html
    Aniline = {
        ZoA = 0.5368395, x0 = 0.1618, I = 6.62E-08, x1 = 2.5805, density = 1023,
        delta0 = 0, state = 'liquid', k = 3.3434, a = 0.1313, Cbar = 3.2622,
        elements = {H = 0.075759, C = 0.773838, N = 0.150403}
    },

    -- Anthracene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/anthracene.html
    Anthracene = {
        ZoA = 0.5273631, x0 = 0.1146, I = 6.95E-08, x1 = 2.5213, density = 1283,
        delta0 = 0, state = 'liquid', k = 3.2831, a = 0.1468, Cbar = 3.1514,
        elements = {C = 0.94345, H = 0.05655}
    },

    -- Antimony
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/antimony_Sb.html
    Antimony = {
        ZoA = 0.4188568, x0 = 0.3189, I = 4.87E-07, x1 = 3.3489, density = 6691,
        delta0 = 0.14, state = 'liquid', k = 2.9319, a = 0.1665, Cbar = 5.6241,
        elements = {Sb = 1}
    },

    -- Argon gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/argon_gas_Ar.html
    ArgonGas = {
        ZoA = 0.4505846, x0 = 1.7635, I = 1.88E-07, x1 = 4.4855,
        density = 1.662, delta0 = 0, state = 'gaz', k = 2.9618, a = 0.1971,
        Cbar = 11.948, elements = {Ar = 1}
    },

    -- Arsenic
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/arsenic_As.html
    Arsenic = {
        ZoA = 0.4404604, x0 = 0.1767, I = 3.47E-07, x1 = 3.5702, density = 5730,
        delta0 = 0.08, state = 'liquid', k = 3.4176, a = 0.0663, Cbar = 5.051,
        elements = {As = 1}
    },

    -- Astatine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/astatine_At.html
    Astatine = {
        ZoA = 0.404787, x0 = 0.7833, I = 8.25E-07, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.3118, Cbar = 7.0039,
        elements = {At = 1}
    },

    -- B-100 Bone-equivalent plastic
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/b-100_Bone-equivalent_plastic.html
    B100BoneEquivalentPlastic = {
        ZoA = 0.5273535, x0 = 0.1252, I = 8.59E-08, x1 = 3.042, density = 1450,
        delta0 = 0, state = 'liquid', k = 3.7365, a = 0.0527, Cbar = 3.4528,
        elements = {O = 0.032085, N = 0.0215, Ca = 0.176589, H = 0.065471,
        C = 0.536945, F = 0.167411}
    },

    -- Bakelite
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/bakelite.html
    Bakelite = {
        ZoA = 0.5278805, x0 = 0.1471, I = 7.24E-08, x1 = 2.6055, density = 1250,
        delta0 = 0, state = 'liquid', k = 3.347, a = 0.1271, Cbar = 3.2582,
        elements = {H = 0.057441, C = 0.774591, O = 0.167968}
    },

    -- Barium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/barium_Ba.html
    Barium = {
        ZoA = 0.4077828, x0 = 0.419, I = 4.91E-07, x1 = 3.4547, density = 3500,
        delta0 = 0.14, state = 'liquid', k = 2.8906, a = 0.1827, Cbar = 6.3153,
        elements = {Ba = 1}
    },

    -- Barium fluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/barium_fluoride.html
    BariumFluoride = {
        ZoA = 0.4220736, x0 = 0.0099, I = 3.759E-07, x1 = 3.387, density = 4893,
        delta0 = 0, state = 'liquid', k = 2.8867, a = 0.1599, Cbar = 5.4116,
        elements = {Ba = 0.78328, F = 0.21672}
    },

    -- Barium sulfate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/barium_sulfate.html
    BariumSulfate = {
        ZoA = 0.4456033, x0 = 0.0128, I = 2.857E-07, x1 = 3.4069,
        density = 4500, delta0 = 0, state = 'liquid', k = 3.0427, a = 0.1175,
        Cbar = 4.8923, elements = {O = 0.274212, S = 0.137368, Ba = 0.58842}
    },

    -- Benzene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/benzene.html
    Benzene = {
        ZoA = 0.5376265, x0 = 0.171, I = 6.34E-08, x1 = 2.5091, density = 878.7,
        delta0 = 0, state = 'liquid', k = 3.2174, a = 0.1652, Cbar = 3.3269,
        elements = {C = 0.922582, H = 0.077418}
    },

    -- Berkelium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/berkelium_Bk.html
    Berkelium = {
        ZoA = 0.3926013, x0 = 0.0509, I = 9.52E-07, x1 = 2.5, density = 9860,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2556, Cbar = 3.9886,
        elements = {Bk = 1}
    },

    -- Beryllium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/beryllium_Be.html
    Beryllium = {
        ZoA = 0.4438438, x0 = 0.0592, I = 6.37E-08, x1 = 1.6922, density = 1848,
        delta0 = 0.14, state = 'liquid', k = 2.4339, a = 0.8039, Cbar = 2.7847,
        elements = {Be = 1}
    },

    -- Beryllium oxide BeO
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/beryllium_oxide_BeO.html
    BerylliumOxide = {
        ZoA = 0.4797798, x0 = 0.0241, I = 9.32E-08, x1 = 2.5846, density = 3010,
        delta0 = 0, state = 'liquid', k = 3.4927, a = 0.1076, Cbar = 2.9801,
        elements = {Be = 0.36032, O = 0.63968}
    },

    -- Bismuth
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/bismuth_Bi.html
    Bismuth = {
        ZoA = 0.3971672, x0 = 0.4152, I = 8.23E-07, x1 = 3.8248, density = 9747,
        delta0 = 0.14, state = 'liquid', k = 3.1671, a = 0.0941, Cbar = 6.3505,
        elements = {Bi = 1}
    },

    -- Bismuth germanate BGO
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/bismuth_germanate_BGO.html
    BismuthGermanate = {
        ZoA = 0.4206107, x0 = 0.0456, I = 5.341E-07, x1 = 3.7816,
        density = 7130, delta0 = 0, state = 'liquid', k = 3.0781, a = 0.0957,
        Cbar = 5.7409, elements = {O = 0.154126, Bi = 0.671054, Ge = 0.17482}
    },

    -- Bismuth silicate BSO
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/bismuth_silicate_BSO.html
    BismuthSilicate = {
        ZoA = 0.4225985, x0 = 0.4077, I = 5.192E-07, x1 = 3.0557,
        density = 7120, delta0 = 0, state = 'liquid', k = 3, a = 0.2187,
        Cbar = 5.9374, elements = {Si = 0.075759, O = 0.172629, Bi = 0.751613}
    },

    -- Blood ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/blood_ICRP.html
    BloodICRP = {
        ZoA = 0.5498747, x0 = 0.2239, I = 7.52E-08, x1 = 2.8017, density = 1060,
        delta0 = 0, state = 'liquid', k = 3.5406, a = 0.0849, Cbar = 3.4581,
        elements = {K = 0.00163, O = 0.759414, S = 0.00185, H = 0.101866,
        Fe = 0.00046, P = 0.00035, Si = 3E-05, Zn = 1E-05, Ca = 6E-05,
        Na = 0.00185, Cl = 0.00278, Mg = 4E-05, C = 0.10002, N = 0.02964}
    },

    -- Bohrium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/bohrium_Bh.html
    Bohrium = {
        ZoA = 0.3961012, x0 = 0.6345, I = 1.087E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2739, Cbar = 6.5475,
        elements = {Bh = 1}
    },

    -- Boron
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/boron_B.html
    Boron = {
        ZoA = 0.4622354, x0 = 0.0305, I = 7.6E-08, x1 = 1.9688, density = 2370,
        delta0 = 0.14, state = 'liquid', k = 2.4512, a = 0.5622, Cbar = 2.8477,
        elements = {B = 1}
    },

    -- Boron carbide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/boron_carbide.html
    BoronCarbide = {
        ZoA = 0.4703473, x0 = 0.0093, I = 8.47E-08, x1 = 2.1006, density = 2520,
        delta0 = 0, state = 'liquid', k = 2.8076, a = 0.3709, Cbar = 2.9859,
        elements = {B = 0.78261, C = 0.21739}
    },

    -- Boron oxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/boron_oxide.html
    BoronOxide = {
        ZoA = 0.4882872, x0 = 0.1843, I = 9.96E-08, x1 = 2.7379, density = 1812,
        delta0 = 0, state = 'liquid', k = 3.3832, a = 0.1155, Cbar = 3.6027,
        elements = {B = 0.310551, O = 0.689449}
    },

    -- Borosilicate glass Pyrex Corning 7740
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/borosilicate_glass_Pyrex_Corning_7740.html
    BorosilicateGlassPyrexCorning7740 = {
        ZoA = 0.4970599, x0 = 0.1479, I = 1.34E-07, x1 = 2.9933, density = 2230,
        delta0 = 0, state = 'liquid', k = 3.5224, a = 0.0827, Cbar = 3.9708,
        elements = {B = 0.040061, O = 0.539564, Na = 0.028191, Al = 0.011644,
        K = 0.003321, Si = 0.37722}
    },

    -- Brain ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/brain_ICRP.html
    BrainICRP = {
        ZoA = 0.5541432, x0 = 0.2206, I = 7.33E-08, x1 = 2.8021, density = 1030,
        delta0 = 0, state = 'liquid', k = 3.5585, a = 0.0825, Cbar = 3.4279,
        elements = {K = 0.0031, O = 0.737723, S = 0.00177, H = 0.110667,
        P = 0.00354, Fe = 5E-05, Zn = 1E-05, Ca = 9E-05, Na = 0.00184,
        Cl = 0.00236, Mg = 0.00015, C = 0.12542, N = 0.01328}
    },

    -- Bromine gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/bromine_gas.html
    BromineGas = {
        ZoA = 0.4380251, x0 = 1.5262, I = 3.43E-07, x1 = 4.9899,
        density = 7.072, delta0 = 0, state = 'gaz', k = 3.467, a = 0.0633,
        Cbar = 11.7307, elements = {Br = 1}
    },

    -- Butane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/butane.html
    Butane = {
        ZoA = 0.5848367, x0 = 1.3792, I = 4.83E-08, x1 = 3.7528,
        density = 2.489, delta0 = 0, state = 'gaz', k = 3.4884, a = 0.1085,
        Cbar = 8.5651, elements = {C = 0.826592, H = 0.173408}
    },

    -- C-552 air-equivalent plastic
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/C-552_air-equivalent_plastic.html
    C552AirEquivalentPlastic = {
        ZoA = 0.4996714, x0 = 0.151, I = 8.68E-08, x1 = 2.7083, density = 1760,
        delta0 = 0, state = 'liquid', k = 3.4344, a = 0.1049, Cbar = 3.3338,
        elements = {Si = 0.003973, F = 0.465209, H = 0.02468, C = 0.50161,
        O = 0.004527}
    },

    -- Cadmium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cadmium_Cd.html
    Cadmium = {
        ZoA = 0.4269931, x0 = 0.1281, I = 4.69E-07, x1 = 3.1667, density = 8650,
        delta0 = 0.14, state = 'liquid', k = 2.6772, a = 0.2461, Cbar = 5.2727,
        elements = {Cd = 1}
    },

    -- Cadmium telluride CdTe
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cadmium_telluride_CdTe.html
    CadmiumTelluride = {
        ZoA = 0.4166371, x0 = 0.0438, I = 5.393E-07, x1 = 3.2836,
        density = 6200, delta0 = 0, state = 'liquid', k = 2.6665, a = 0.2484,
        Cbar = 5.9096, elements = {Te = 0.531645, Cd = 0.468355}
    },

    -- Cadmium tungstate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cadmium_tungstate.html
    CadmiumTungstate = {
        ZoA = 0.4274778, x0 = 0.0123, I = 4.683E-07, x1 = 3.5941,
        density = 7900, delta0 = 0, state = 'liquid', k = 2.915, a = 0.1286,
        Cbar = 5.3594, elements = {Cd = 0.312027, O = 0.177644, W = 0.510329}
    },

    -- Caesium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/caesium_Cs.html
    Caesium = {
        ZoA = 0.4138294, x0 = 0.5473, I = 4.88E-07, x1 = 3.5914, density = 1873,
        delta0 = 0.14, state = 'liquid', k = 2.8866, a = 0.1823, Cbar = 6.9135,
        elements = {Cs = 1}
    },

    -- Calcium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/calcium_Ca.html
    Calcium = {
        ZoA = 0.4990219, x0 = 0.3228, I = 1.91E-07, x1 = 3.1191, density = 1550,
        delta0 = 0.14, state = 'liquid', k = 3.0745, a = 0.1564, Cbar = 5.0396,
        elements = {Ca = 1}
    },

    -- Calcium carbonate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/calcium_carbonate.html
    CalciumCarbonate = {
        ZoA = 0.4995649, x0 = 0.0492, I = 1.364E-07, x1 = 3.0549,
        density = 2800, delta0 = 0, state = 'liquid', k = 3.412, a = 0.083,
        Cbar = 3.7738, elements = {O = 0.479554, C = 0.120003, Ca = 0.400443}
    },

    -- Calcium fluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/calcium_fluoride.html
    CalciumFluoride = {
        ZoA = 0.4867105, x0 = 0.0676, I = 1.66E-07, x1 = 3.1683, density = 3180,
        delta0 = 0, state = 'liquid', k = 3.5263, a = 0.0694, Cbar = 4.0653,
        elements = {Ca = 0.513341, F = 0.486659}
    },

    -- Calcium oxide CaO
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/calcium_oxide_CaO.html
    CalciumOxide = {
        ZoA = 0.4993072, x0 = 0.0172, I = 1.761E-07, x1 = 3.0171,
        density = 3300, delta0 = 0, state = 'liquid', k = 3.1936, a = 0.1213,
        Cbar = 4.1209, elements = {Ca = 0.714701, O = 0.285299}
    },

    -- Calcium sulfate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/calcium_sulfate.html
    CalciumSulfate = {
        ZoA = 0.4994818, x0 = 0.0587, I = 1.523E-07, x1 = 3.1229,
        density = 2960, delta0 = 0, state = 'liquid', k = 3.4495, a = 0.0771,
        Cbar = 3.9388, elements = {O = 0.470095, S = 0.235497, Ca = 0.294408}
    },

    -- Calcium tungstate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/calcium_tungstate.html
    CalciumTungstate = {
        ZoA = 0.4376265, x0 = 0.0323, I = 3.95E-07, x1 = 3.8932, density = 6062,
        delta0 = 0, state = 'liquid', k = 3.2649, a = 0.0621, Cbar = 5.2603,
        elements = {O = 0.22227, Ca = 0.139202, W = 0.638529}
    },

    -- Californium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/californium_Cf.html
    Californium = {
        ZoA = 0.3903138, x0 = 0.0623, I = 9.66E-07, x1 = 2.5, density = 15100,
        delta0 = 0, state = 'liquid', k = 3, a = 0.258, Cbar = 4.0236,
        elements = {Cf = 1}
    },

    -- Carbon amorphous
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/carbon_amorphous_C.html
    CarbonAmorphous = {
        ZoA = 0.4995504, x0 = 0.0351, I = 7.8E-08, x1 = 2.486, density = 2000,
        delta0 = 0.1, state = 'liquid', k = 3.0036, a = 0.2024, Cbar = 2.9925,
        elements = {C = 1}
    },

    -- Carbon compact
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/carbon_compact_C.html
    CarbonCompact = {
        ZoA = 0.4995504, x0 = 0.0178, I = 7.8E-08, x1 = 2.3415, density = 2265,
        delta0 = 0.12, state = 'liquid', k = 2.8697, a = 0.2614, Cbar = 2.868,
        elements = {C = 1}
    },

    -- Carbon dioxide gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/carbon_dioxide_gas.html
    CarbonDioxideGas = {
        ZoA = 0.4998932, x0 = 1.6294, I = 8.5E-08, x1 = 4.1825, density = 1.842,
        delta0 = 0, state = 'gaz', k = 3.3227, a = 0.1177, Cbar = 10.1537,
        elements = {C = 0.272916, O = 0.727084}
    },

    -- Carbon gem diamond
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/carbon_gem_diamond.html
    CarbonGemDiamond = {
        ZoA = 0.4995504, x0 = 0.1135, I = 7.8E-08, x1 = 2.2458, density = 3520,
        delta0 = 0.12, state = 'liquid', k = 2.8697, a = 0.2614, Cbar = 2.4271,
        elements = {C = 1}
    },

    -- Carbon graphite
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/carbon_graphite_C.html
    CarbonGraphite = {
        ZoA = 0.4995504, x0 = 0.009, I = 7.8E-08, x1 = 2.4817, density = 2210,
        delta0 = 0.14, state = 'liquid', k = 2.9532, a = 0.2076, Cbar = 2.8926,
        elements = {C = 1}
    },

    -- Carbon tetrachloride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/carbon_tetrachloride.html
    CarbonTetrachloride = {
        ZoA = 0.4810706, x0 = 0.1773, I = 1.663E-07, x1 = 2.9165,
        density = 1594, delta0 = 0, state = 'liquid', k = 3.0116, a = 0.1902,
        Cbar = 4.7712, elements = {C = 0.078083, Cl = 0.921917}
    },

    -- Carbon tetrafluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/carbon_tetrafluoride.html
    CarbonTetrafluoride = {
        ZoA = 0.4772497, x0 = 1.7, I = 1.15E-07, x1 = 4, density = 3.78,
        delta0 = 0, state = 'gaz', k = 3, a = 0.1855, Cbar = 10.0858,
        elements = {C = 0.136548, F = 0.86345}
    },

    -- Cellulose
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cellulose.html
    Cellulose = {
        ZoA = 0.5303558, x0 = 0.158, I = 7.76E-08, x1 = 2.6778, density = 1420,
        delta0 = 0, state = 'liquid', k = 3.381, a = 0.1115, Cbar = 3.2647,
        elements = {H = 0.062162, C = 0.444462, O = 0.493376}
    },

    -- Cellulose acetate butyrate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cellulose_acetate_butyrate.html
    CelluloseAcetateButyrate = {
        ZoA = 0.5327468, x0 = 0.1794, I = 7.46E-08, x1 = 2.6809, density = 1200,
        delta0 = 0, state = 'liquid', k = 3.3738, a = 0.1144, Cbar = 3.3497,
        elements = {H = 0.067125, C = 0.545403, O = 0.387472}
    },

    -- Cellulose nitrate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cellulose_nitrate.html
    CelluloseNitrate = {
        ZoA = 0.5142155, x0 = 0.1897, I = 8.7E-08, x1 = 2.7253, density = 1490,
        delta0 = 0, state = 'liquid', k = 3.3237, a = 0.1181, Cbar = 3.4762,
        elements = {O = 0.578212, H = 0.029216, C = 0.271296, N = 0.121276}
    },

    -- Ceric sulfate dosimeter solution
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ceric_sulfate_dosimeter_solution.html
    CericSulfateDosimeterSolution = {
        ZoA = 0.5527018, x0 = 0.2363, I = 7.67E-08, x1 = 2.8769, density = 1030,
        delta0 = 0, state = 'liquid', k = 3.5607, a = 0.0767, Cbar = 3.5212,
        elements = {O = 0.874976, S = 0.014627, N = 0.0008, H = 0.107596,
        Ce = 0.002001}
    },

    -- Cerium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cerium_Ce.html
    Cerium = {
        ZoA = 0.4139427, x0 = 0.2676, I = 5.23E-07, x1 = 3.3395, density = 6770,
        delta0 = 0.14, state = 'liquid', k = 2.8592, a = 0.1889, Cbar = 5.7669,
        elements = {Ce = 1}
    },

    -- Cerium fluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cerium_fluoride.html
    CeriumFluoride = {
        ZoA = 0.4312287, x0 = 0.2, I = 3.484E-07, x1 = 3, density = 6160,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1862, Cbar = 5.0079,
        elements = {F = 0.289153, Ce = 0.710847}
    },

    -- Cesium fluoride CsF
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cesium_fluoride_CsF.html
    CesiumFluoride = {
        ZoA = 0.4213204, x0 = 0.0084, I = 4.407E-07, x1 = 3.3374,
        density = 4115, delta0 = 0, state = 'liquid', k = 2.728, a = 0.2205,
        Cbar = 5.9046, elements = {Cs = 0.874931, F = 0.125069}
    },

    -- Cesium iodide CsI
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cesium_iodide_CsI.html
    CesiumIodide = {
        ZoA = 0.41569, x0 = 0.0395, I = 5.531E-07, x1 = 3.3353, density = 4510,
        delta0 = 0, state = 'liquid', k = 2.6657, a = 0.2538, Cbar = 6.2807,
        elements = {I = 0.488451, Cs = 0.511549}
    },

    -- Chlorine gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/chlorine_gas.html
    ChlorineGas = {
        ZoA = 0.4795054, x0 = 1.5566, I = 1.74E-07, x1 = 4.3005, density = 2.98,
        delta0 = 0, state = 'gaz', k = 2.9702, a = 0.1985, Cbar = 11.147,
        elements = {Cl = 1}
    },

    -- Chlorobenzene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/chlorobenzene.html
    Chlorobenzene = {
        ZoA = 0.5152567, x0 = 0.1714, I = 8.91E-08, x1 = 2.9272, density = 1106,
        delta0 = 0, state = 'liquid', k = 3.3797, a = 0.0986, Cbar = 3.8201,
        elements = {H = 0.044772, C = 0.640254, Cl = 0.314974}
    },

    -- Chloroform
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/chloroform.html
    Chloroform = {
        ZoA = 0.4858439, x0 = 0.1786, I = 1.56E-07, x1 = 2.9581, density = 1483,
        delta0 = 0, state = 'liquid', k = 3.0627, a = 0.1696, Cbar = 4.7055,
        elements = {H = 0.008443, C = 0.100613, Cl = 0.890944}
    },

    -- Chromium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/chromium_Cr.html
    Chromium = {
        ZoA = 0.4615722, x0 = 0.034, I = 2.57E-07, x1 = 3.0451, density = 7180,
        delta0 = 0.14, state = 'liquid', k = 2.9896, a = 0.1542, Cbar = 4.1781,
        elements = {Cr = 1}
    },

    -- Cobalt
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cobalt_Co.html
    Cobalt = {
        ZoA = 0.4581458, x0 = 0.0187, I = 2.97E-07, x1 = 3.179, density = 8900,
        delta0 = 0.12, state = 'liquid', k = 2.9502, a = 0.1447, Cbar = 4.2601,
        elements = {Co = 1}
    },

    -- Compact bone ICRU
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/compact_bone_ICRU.html
    CompactBoneICRU = {
        ZoA = 0.5300584, x0 = 0.0944, I = 9.19E-08, x1 = 3.0201, density = 1850,
        delta0 = 0, state = 'liquid', k = 3.6419, a = 0.0582, Cbar = 3.339,
        elements = {Ca = 0.147, O = 0.410016, S = 0.002, N = 0.027, Mg = 0.002,
        H = 0.063984, C = 0.278, P = 0.07}
    },

    -- Copernicium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/copernicium_Cn.html
    Copernicium = {
        ZoA = 0.3927385, x0 = 0.6774, I = 1.156E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2841, Cbar = 6.6791,
        elements = {Cn = 1}
    },

    -- Copper
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/copper_Cu.html
    Copper = {
        ZoA = 0.4563602, x0 = 0.0254, I = 3.22E-07, x1 = 3.2792, density = 8960,
        delta0 = 0.08, state = 'liquid', k = 2.9044, a = 0.1434, Cbar = 4.419,
        elements = {Cu = 1}
    },

    -- Cortical bone ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cortical_bone_ICRP.html
    CorticalBoneICRP = {
        ZoA = 0.5212671, x0 = 0.1161, I = 1.064E-07, x1 = 3.0919,
        density = 1850, delta0 = 0, state = 'liquid', k = 3.5919, a = 0.062,
        Cbar = 3.6488, elements = {O = 0.446096, S = 0.00315, H = 0.047234,
        P = 0.10497, Zn = 0.0001, N = 0.04199, C = 0.14433, Ca = 0.20993,
        Mg = 0.0022}
    },

    -- Curium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/curium_Cm.html
    Curium = {
        ZoA = 0.3885539, x0 = 0.2484, I = 9.39E-07, x1 = 3.516, density = 13510,
        delta0 = 0.14, state = 'liquid', k = 2.7579, a = 0.2026, Cbar = 6.3097,
        elements = {Cm = 1}
    },

    -- Cyclohexane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/cyclohexane.html
    Cyclohexane = {
        ZoA = 0.570231, x0 = 0.1728, I = 5.64E-08, x1 = 2.5549, density = 779,
        delta0 = 0, state = 'liquid', k = 3.4278, a = 0.1204, Cbar = 3.1544,
        elements = {C = 0.856289, H = 0.143711}
    },

    -- Darmstadtium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/darmstadtium_Ds.html
    Darmstadtium = {
        ZoA = 0.3912293, x0 = 0.6632, I = 1.129E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2807, Cbar = 6.6357,
        elements = {Ds = 1}
    },

    -- Deuterium gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/deuterium_gas.html
    DeuteriumGas = {
        ZoA = 0.4964997, x0 = 1.8793, I = 1.92E-08, x1 = 3.2872,
        density = 0.1677, delta0 = 0, state = 'gaz', k = 5.7273, a = 0.1409,
        Cbar = 9.6543, elements = {D = 1}
    },

    -- Deuterium oxide liquid
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/deuterium_oxide_liquid.html
    DeuteriumOxideLiquid = {
        ZoA = 0.4993134, x0 = 0.24, I = 7.97E-08, x1 = 2.8004, density = 1107,
        delta0 = 0, state = 'liquid', k = 3.4773, a = 0.0912, Cbar = 3.5017,
        elements = {D = 0.201133, O = 0.798867}
    },

    -- 12-dichlorobenzene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/12-dichlorobenzene.html
    Dichlorobenzene = {
        ZoA = 0.5033701, x0 = 0.1587, I = 1.065E-07, x1 = 2.8276,
        density = 1305, delta0 = 0, state = 'liquid', k = 3.0836, a = 0.1601,
        Cbar = 4.0348, elements = {H = 0.027425, C = 0.490233, Cl = 0.482342}
    },

    -- Dichlorodiethyl ether
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/dichlorodiethyl_ether.html
    DichlorodiethylEther = {
        ZoA = 0.5173938, x0 = 0.1773, I = 1.033E-07, x1 = 3.1586,
        density = 1220, delta0 = 0, state = 'liquid', k = 3.525, a = 0.068,
        Cbar = 4.0135, elements = {O = 0.111874, H = 0.056381, C = 0.335942,
        Cl = 0.495802}
    },

    -- 12-dichloroethane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/12-dichloroethane.html
    Dichloroethane = {
        ZoA = 0.5052253, x0 = 0.1375, I = 1.119E-07, x1 = 2.9529,
        density = 1235, delta0 = 0, state = 'liquid', k = 3.1675, a = 0.1338,
        Cbar = 4.1849, elements = {H = 0.04074, C = 0.242746, Cl = 0.716515}
    },

    -- Diethyl ether
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/diethyl_ether.html
    DiethylEther = {
        ZoA = 0.5665295, x0 = 0.2231, I = 6E-08, x1 = 2.6745, density = 713.8,
        delta0 = 0, state = 'liquid', k = 3.4586, a = 0.1055, Cbar = 3.3721,
        elements = {H = 0.135978, C = 0.648171, O = 0.215851}
    },

    -- Dimethyl sulfoxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/dimethyl_sulfoxide.html
    DimethylSulfoxide = {
        ZoA = 0.537481, x0 = 0.2021, I = 9.86E-08, x1 = 3.1263, density = 1101,
        delta0 = 0, state = 'liquid', k = 3.5708, a = 0.0662, Cbar = 3.9844,
        elements = {S = 0.410348, H = 0.077403, C = 0.307467, O = 0.204782}
    },

    -- Dubnium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/dubnium_Db.html
    Dubnium = {
        ZoA = 0.3916069, x0 = 0.6224, I = 1.061E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2711, Cbar = 6.5105,
        elements = {Db = 1}
    },

    -- Dysprosium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/dysprosium_Dy.html
    Dysprosium = {
        ZoA = 0.4061538, x0 = 0.0822, I = 6.28E-07, x1 = 3.4474, density = 8551,
        delta0 = 0.14, state = 'liquid', k = 2.5849, a = 0.2466, Cbar = 5.9182,
        elements = {Dy = 1}
    },

    -- E-Glass
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/E-Glass.html
    EGlass = {
        ZoA = 0.4968594, x0 = 0.2, I = 1.434E-07, x1 = 3, density = 2610,
        delta0 = 0, state = 'liquid', k = 3, a = 0.138, Cbar = 3.9495,
        elements = {B = 0.031058, O = 0.488551, Mg = 0.018094, Al = 0.074093,
        Ca = 0.135793, Si = 0.252411}
    },

    -- Einsteinium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/einsteinium_Es.html
    Einsteinium = {
        ZoA = 0.3927278, x0 = 0.5697, I = 9.8E-07, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2595, Cbar = 6.3488,
        elements = {Es = 1}
    },

    -- Epotek-301-1
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/Epotek-301-1.html
    Epotek3011 = {
        ZoA = 0.5340374, x0 = 0.2, I = 7.67E-08, x1 = 2, density = 1190,
        delta0 = 0, state = 'liquid', k = 3, a = 0.427, Cbar = 3.4112,
        elements = {O = 0.231531, H = 0.069894, C = 0.68964, N = 0.008936}
    },

    -- Erbium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/erbium_Er.html
    Erbium = {
        ZoA = 0.4065551, x0 = 0.0658, I = 6.58E-07, x1 = 3.4932, density = 9026,
        delta0 = 0.14, state = 'liquid', k = 2.5573, a = 0.2482, Cbar = 5.9565,
        elements = {Er = 1}
    },

    -- Ethane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ethane.html
    Ethane = {
        ZoA = 0.5984637, x0 = 1.509, I = 4.54E-08, x1 = 3.8726, density = 1.263,
        delta0 = 0, state = 'gaz', k = 3.6095, a = 0.0963, Cbar = 9.0965,
        elements = {C = 0.798885, H = 0.201115}
    },

    -- Ethanol
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ethanol.html
    Ethanol = {
        ZoA = 0.564276, x0 = 0.2218, I = 6.29E-08, x1 = 2.7052, density = 789.3,
        delta0 = 0, state = 'liquid', k = 3.4834, a = 0.0988, Cbar = 3.3699,
        elements = {H = 0.131269, C = 0.521438, O = 0.347294}
    },

    -- Ethyl cellulose
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ethyl_cellulose.html
    EthylCellulose = {
        ZoA = 0.543981, x0 = 0.1683, I = 6.93E-08, x1 = 2.6527, density = 1130,
        delta0 = 0, state = 'liquid', k = 3.4098, a = 0.1108, Cbar = 3.2415,
        elements = {H = 0.090027, C = 0.585182, O = 0.324791}
    },

    -- Ethylene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ethylene.html
    Ethylene = {
        ZoA = 0.570231, x0 = 1.5528, I = 5.07E-08, x1 = 3.9327, density = 1.175,
        delta0 = 0, state = 'gaz', k = 3.5387, a = 0.1064, Cbar = 9.438,
        elements = {C = 0.856289, H = 0.143711}
    },

    -- Europium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/europium_Eu.html
    Europium = {
        ZoA = 0.4145719, x0 = 0.1888, I = 5.8E-07, x1 = 3.4633, density = 5244,
        delta0 = 0.14, state = 'liquid', k = 2.6245, a = 0.2445, Cbar = 6.2276,
        elements = {Eu = 1}
    },

    -- Eye lens ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/eye_lens_ICRP.html
    EyeLensICRP = {
        ZoA = 0.5486918, x0 = 0.207, I = 7.33E-08, x1 = 2.7446, density = 1100,
        delta0 = 0, state = 'liquid', k = 3.455, a = 0.0969, Cbar = 3.372,
        elements = {O = 0.653751, H = 0.099269, C = 0.19371, N = 0.05327}
    },

    -- Fermium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/fermium_Fm.html
    Fermium = {
        ZoA = 0.3889613, x0 = 0.5821, I = 9.94E-07, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2622, Cbar = 6.3868,
        elements = {Fm = 1}
    },

    -- Ferric oxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ferric_oxide.html
    FerricOxide = {
        ZoA = 0.475927, x0 = 0.0074, I = 2.273E-07, x1 = 3.2573, density = 5200,
        delta0 = 0, state = 'liquid', k = 3.1313, a = 0.1048, Cbar = 4.2245,
        elements = {Fe = 0.699433, O = 0.300567}
    },

    -- Ferroboride FeB
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ferroboride_FeB.html
    Ferroboride = {
        ZoA = 0.4650315, x0 = 0.0988, I = 2.61E-07, x1 = 3.1749, density = 7150,
        delta0 = 0, state = 'liquid', k = 3.024, a = 0.1291, Cbar = 4.2057,
        elements = {B = 0.162174, Fe = 0.837826}
    },

    -- Ferrous oxide FeO
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ferrous_oxide_FeO.html
    FerrousOxide = {
        ZoA = 0.4732441, x0 = 0.0279, I = 2.486E-07, x1 = 3.2002,
        density = 5700, delta0 = 0, state = 'liquid', k = 3.0168, a = 0.1296,
        Cbar = 4.3175, elements = {Fe = 0.777311, O = 0.222689}
    },

    -- Ferrous sulfate dosimeter solution
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ferrous_sulfate_dosimeter_solution.html
    FerrousSulfateDosimeterSolution = {
        ZoA = 0.5531987, x0 = 0.2378, I = 7.64E-08, x1 = 2.8254, density = 1024,
        delta0 = 0, state = 'liquid', k = 3.4923, a = 0.0876, Cbar = 3.5183,
        elements = {Fe = 5.4E-05, O = 0.878636, S = 0.012968, Na = 2.2E-05,
        H = 0.108259, N = 2.7E-05, Cl = 3.4E-05}
    },

    -- Flerovium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/flerovium_Fl.html
    Flerovium = {
        ZoA = 0.3942045, x0 = 0.6923, I = 1.185E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2878, Cbar = 6.7249,
        elements = {Fl = 1}
    },

    -- Fluorine gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/fluorine_gas.html
    FluorineGas = {
        ZoA = 0.4737241, x0 = 1.8433, I = 1.15E-07, x1 = 4.4096, density = 1.58,
        delta0 = 0, state = 'gaz', k = 3.2962, a = 0.1108, Cbar = 10.9653,
        elements = {F = 1}
    },

    -- Francium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/francium_Fr.html
    Francium = {
        ZoA = 0.3900995, x0 = 1.1175, I = 8.27E-07, x1 = 3, density = 1870,
        delta0 = 0, state = 'liquid', k = 3, a = 0.4321, Cbar = 8.0292,
        elements = {Fr = 1}
    },

    -- Freon-12
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/Freon-12.html
    Freon12 = {
        ZoA = 0.4796798, x0 = 0.3035, I = 1.43E-07, x1 = 3.2659, density = 1120,
        delta0 = 0, state = 'liquid', k = 3.4626, a = 0.0798, Cbar = 4.8251,
        elements = {F = 0.314247, C = 0.099335, Cl = 0.586418}
    },

    -- Freon-13
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/Freon-13.html
    Freon13 = {
        ZoA = 0.4786563, x0 = 0.3659, I = 1.266E-07, x1 = 3.2337, density = 950,
        delta0 = 0, state = 'liquid', k = 3.5551, a = 0.0724, Cbar = 4.7483,
        elements = {F = 0.545622, C = 0.114983, Cl = 0.339396}
    },

    -- Freon-13b1
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/Freon-13b1.html
    Freon13b1 = {
        ZoA = 0.4566514, x0 = 0.3522, I = 2.105E-07, x1 = 3.7554,
        density = 1500, delta0 = 0, state = 'liquid', k = 3.7194, a = 0.0393,
        Cbar = 5.3555, elements = {F = 0.382749, C = 0.080659, Br = 0.536592}
    },

    -- Freon-13i1
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/Freon-13i1.html
    Freon13i1 = {
        ZoA = 0.4389771, x0 = 0.2847, I = 2.935E-07, x1 = 3.728, density = 1800,
        delta0 = 0, state = 'liquid', k = 3.1658, a = 0.0911, Cbar = 5.8774,
        elements = {I = 0.647767, F = 0.290924, C = 0.061309}
    },

    -- G10
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/G10.html
    G10 = {
        ZoA = 0.6336556, x0 = 0.2, I = 1.104E-07, x1 = 3, density = 1800,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1297, Cbar = 3.7685,
        elements = {B = 0.01864, O = 0.385764, H = 0.275853, Si = 0.151423,
        Mg = 0.010842, N = 0.027945, Ca = 0.081496, C = 0.003583,
        Al = 0.044453}
    },

    -- Gadolinium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/gadolinium_Gd.html
    Gadolinium = {
        ZoA = 0.4069875, x0 = 0.1058, I = 5.91E-07, x1 = 3.3932, density = 7901,
        delta0 = 0.14, state = 'liquid', k = 2.5977, a = 0.2511, Cbar = 5.8737,
        elements = {Gd = 1}
    },

    -- Gadolinium oxysulfide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/gadolinium_oxysulfide.html
    GadoliniumOxysulfide = {
        ZoA = 0.4226422, x0 = 0.1774, I = 4.933E-07, x1 = 3.4045,
        density = 7440, delta0 = 0, state = 'liquid', k = 2.63, a = 0.2216,
        Cbar = 5.5347, elements = {O = 0.084528, S = 0.08469, Gd = 0.830782}
    },

    -- Gadolinium silicate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/gadolinium_silicate.html
    GadoliniumSilicate = {
        ZoA = 0.43068, x0 = 0.2039, I = 4.054E-07, x1 = 3, density = 6710,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1961, Cbar = 5.2267,
        elements = {Si = 0.066462, Gd = 0.744233, O = 0.189305}
    },

    -- Gallium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/gallium_Ga.html
    Gallium = {
        ZoA = 0.4446159, x0 = 0.2267, I = 3.34E-07, x1 = 3.5434, density = 5904,
        delta0 = 0.14, state = 'liquid', k = 3.1314, a = 0.0944, Cbar = 4.9353,
        elements = {Ga = 1}
    },

    -- Gallium arsenide GaAs
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/gallium_arsenide_GaAs.html
    GalliumArsenide = {
        ZoA = 0.4424635, x0 = 0.1764, I = 3.849E-07, x1 = 3.642, density = 5310,
        delta0 = 0, state = 'liquid', k = 3.3356, a = 0.0715, Cbar = 5.3299,
        elements = {Ga = 0.482019, As = 0.517981}
    },

    -- Gel in photographic emulsion
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/gel_in_photographic_emulsion.html
    GelInPhotographicEmulsion = {
        ZoA = 0.5396714, x0 = 0.1709, I = 7.48E-08, x1 = 2.7058, density = 1291,
        delta0 = 0, state = 'liquid', k = 3.4418, a = 0.101, Cbar = 3.2687,
        elements = {O = 0.38064, S = 0.01088, N = 0.11124, H = 0.08118,
        C = 0.41606}
    },

    -- Germanium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/germanium_Ge.html
    Germanium = {
        ZoA = 0.4405887, x0 = 0.3376, I = 3.5E-07, x1 = 3.6096, density = 5323,
        delta0 = 0.14, state = 'liquid', k = 3.3306, a = 0.0719, Cbar = 5.1411,
        elements = {Ge = 1}
    },

    -- Glucose dextrose monohydrate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/glucose_dextrose_monohydrate.html
    GlucoseDextroseMonohydrate = {
        ZoA = 0.5348367, x0 = 0.1411, I = 7.72E-08, x1 = 2.67, density = 1540,
        delta0 = 0, state = 'liquid', k = 3.3946, a = 0.1078, Cbar = 3.1649,
        elements = {H = 0.071204, C = 0.363652, O = 0.565144}
    },

    -- Glutamine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/glutamine.html
    Glutamine = {
        ZoA = 0.5336603, x0 = 0.1347, I = 7.33E-08, x1 = 2.6301, density = 1460,
        delta0 = 0, state = 'liquid', k = 3.3254, a = 0.1193, Cbar = 3.1167,
        elements = {O = 0.328427, H = 0.068965, C = 0.410926, N = 0.191681}
    },

    -- Glycerol
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/glycerol.html
    Glycerol = {
        ZoA = 0.5428578, x0 = 0.1653, I = 7.26E-08, x1 = 2.6862, density = 1261,
        delta0 = 0, state = 'liquid', k = 3.4481, a = 0.1017, Cbar = 3.2267,
        elements = {H = 0.087554, C = 0.391262, O = 0.521185}
    },

    -- Gold
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/gold_Au.html
    Gold = {
        ZoA = 0.4010824, x0 = 0.2021, I = 7.9E-07, x1 = 3.6979, density = 19320,
        delta0 = 0.14, state = 'liquid', k = 3.1101, a = 0.0976, Cbar = 5.5747,
        elements = {Au = 1}
    },

    -- Guanine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/guanine.html
    Guanine = {
        ZoA = 0.5160899, x0 = 0.1163, I = 7.5E-08, x1 = 2.4296, density = 1580,
        delta0 = 0, state = 'liquid', k = 3.0186, a = 0.2053, Cbar = 3.1171,
        elements = {O = 0.105867, H = 0.033346, C = 0.39738, N = 0.463407}
    },

    -- Gypsum plaster of Paris
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/gypsum_plaster_of_Paris.html
    GypsumPlasterOfParis = {
        ZoA = 0.5111004, x0 = 0.0995, I = 1.297E-07, x1 = 3.1206,
        density = 2320, delta0 = 0, state = 'liquid', k = 3.5134, a = 0.0695,
        Cbar = 3.8382, elements = {Ca = 0.232797, O = 0.557572, S = 0.186215,
        H = 0.023416}
    },

    -- Hafnium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/hafnium_Hf.html
    Hafnium = {
        ZoA = 0.4033794, x0 = 0.1965, I = 7.05E-07, x1 = 3.4337,
        density = 13310, delta0 = 0.14, state = 'liquid', k = 2.6155,
        a = 0.2292, Cbar = 5.7139, elements = {Hf = 1}
    },

    -- Hassium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/hassium_Hs.html
    Hassium = {
        ZoA = 0.4012871, x0 = 0.6392, I = 1.102E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.275, Cbar = 6.5619,
        elements = {Hs = 1}
    },

    -- Heavymet in ATLAS calorimeter
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/heavymet_in_ATLAS_calorimeter.html
    HeavymetInATLASCalorimeter = {
        ZoA = 0.405938, x0 = 0.2167, I = 7.27E-07, x1 = 3.496, density = 19300,
        delta0 = 0.14, state = 'liquid', k = 2.8447, a = 0.1551, Cbar = 5.4059,
        elements = {Ni = 0.035, W = 0.95, Cu = 0.015}
    },

    -- Heavymet in Rochester gamma stop
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/heavymet_in_Rochester_gamma_stop.html
    HeavymetInRochesterGammaStop = {
        ZoA = 0.4091473, x0 = 0.2167, I = 7.27E-07, x1 = 3.496, density = 19300,
        delta0 = 0.14, state = 'liquid', k = 2.8447, a = 0.1551, Cbar = 5.4059,
        elements = {Ni = 0.06, W = 0.9, Cu = 0.04}
    },

    -- Helium gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/helium_gas_He.html
    HeliumGas = {
        ZoA = 0.4996752, x0 = 2.2017, I = 4.18E-08, x1 = 3.6122,
        density = 0.1663, delta0 = 0, state = 'gaz', k = 5.8347, a = 0.1344,
        Cbar = 11.1393, elements = {He = 1}
    },

    -- Holmium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/holmium_Ho.html
    Holmium = {
        ZoA = 0.4062329, x0 = 0.0761, I = 6.5E-07, x1 = 3.4782, density = 8795,
        delta0 = 0.14, state = 'liquid', k = 2.5726, a = 0.2464, Cbar = 5.9587,
        elements = {Ho = 1}
    },

    -- Hydrogen gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/hydrogen_gas.html
    HydrogenGas = {
        ZoA = 0.991375, x0 = 1.8639, I = 1.92E-08, x1 = 3.2718,
        density = 0.08376, delta0 = 0, state = 'gaz', k = 5.7273, a = 0.1409,
        Cbar = 9.5834, elements = {H = 1}
    },

    -- Indium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/indium_In.html
    Indium = {
        ZoA = 0.4267624, x0 = 0.2406, I = 4.88E-07, x1 = 3.2032, density = 7310,
        delta0 = 0.14, state = 'liquid', k = 2.7144, a = 0.2388, Cbar = 5.5211,
        elements = {In = 1}
    },

    -- Iodine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/iodine_I.html
    Iodine = {
        ZoA = 0.4176385, x0 = 0.0549, I = 4.91E-07, x1 = 3.2596, density = 4930,
        delta0 = 0, state = 'liquid', k = 2.7276, a = 0.2377, Cbar = 5.9488,
        elements = {I = 1}
    },

    -- Iridium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/iridium_Ir.html
    Iridium = {
        ZoA = 0.4005889, x0 = 0.0819, I = 7.57E-07, x1 = 3.548, density = 22420,
        delta0 = 0.1, state = 'liquid', k = 2.9658, a = 0.1269, Cbar = 5.3418,
        elements = {Ir = 1}
    },

    -- Iron
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/iron_Fe.html
    Iron = {
        ZoA = 0.4655727, x0 = 0.0012, I = 2.86E-07, x1 = 3.1531, density = 7874,
        delta0 = 0.12, state = 'liquid', k = 2.9632, a = 0.1468, Cbar = 4.2911,
        elements = {Fe = 1}
    },

    -- Krypton gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/krypton_gas_Kr.html
    KryptonGas = {
        ZoA = 0.4296035, x0 = 1.7153, I = 3.52E-07, x1 = 5.0743,
        density = 3.486, delta0 = 0, state = 'gaz', k = 3.4051, a = 0.0745,
        Cbar = 12.5094, elements = {Kr = 1}
    },

    -- Lanthanum
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lanthanum_La.html
    Lanthanum = {
        ZoA = 0.4103524, x0 = 0.3164, I = 5.01E-07, x1 = 3.3296, density = 6145,
        delta0 = 0.14, state = 'liquid', k = 2.8828, a = 0.1859, Cbar = 5.7865,
        elements = {La = 1}
    },

    -- Lanthanum bromide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lanthanum_bromide.html
    LanthanumBromide = {
        ZoA = 0.4278722, x0 = 0.3581, I = 4.545E-07, x1 = 3, density = 5290,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2197, Cbar = 5.6997,
        elements = {Br = 0.633124, La = 0.366875}
    },

    -- Lanthanum chloride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lanthanum_chloride.html
    LanthanumChloride = {
        ZoA = 0.4403406, x0 = 0.2418, I = 3.295E-07, x1 = 3, density = 3860,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2016, Cbar = 5.3428,
        elements = {Cl = 0.43365, La = 0.56635}
    },

    -- Lanthanum fluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lanthanum_fluoride.html
    LanthanumFluoride = {
        ZoA = 0.4287897, x0 = 0.2, I = 3.363E-07, x1 = 3, density = 5900,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1852, Cbar = 4.986,
        elements = {F = 0.290939, La = 0.709061}
    },

    -- Lanthanum oxybromide LaOBr
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lanthanum_oxybromide_LaOBr.html
    LanthanumOxybromide = {
        ZoA = 0.4258791, x0 = 0.035, I = 4.397E-07, x1 = 3.3288, density = 6280,
        delta0 = 0, state = 'liquid', k = 2.8457, a = 0.1783, Cbar = 5.4666,
        elements = {O = 0.068138, Br = 0.340294, La = 0.591568}
    },

    -- Lanthanum oxysulfide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lanthanum_oxysulfide.html
    LanthanumOxysulfide = {
        ZoA = 0.4270567, x0 = 0.0906, I = 4.212E-07, x1 = 3.2664,
        density = 5860, delta0 = 0, state = 'liquid', k = 2.7298, a = 0.215,
        Cbar = 5.447, elements = {O = 0.0936, S = 0.093778, La = 0.812622}
    },

    -- Lawrencium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lawrencium_Lr.html
    Lawrencium = {
        ZoA = 0.3929648, x0 = 0.6045, I = 1.034E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2671, Cbar = 6.4555,
        elements = {Lr = 1}
    },

    -- Lead
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lead_Pb.html
    Lead = {
        ZoA = 0.3957338, x0 = 0.3776, I = 8.23E-07, x1 = 3.8073,
        density = 11350, delta0 = 0.14, state = 'liquid', k = 3.1608,
        a = 0.0936, Cbar = 6.2018, elements = {Pb = 1}
    },

    -- Lead fluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lead_fluoride.html
    LeadFluoride = {
        ZoA = 0.4078196, x0 = 0.4668, I = 6.354E-07, x1 = 3, density = 7770,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2389, Cbar = 6.0333,
        elements = {Pb = 0.845035, F = 0.154965}
    },

    -- Lead glass
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lead_glass.html
    LeadGlass = {
        ZoA = 0.4209939, x0 = 0.0614, I = 5.264E-07, x1 = 3.8146,
        density = 6220, delta0 = 0, state = 'liquid', k = 3.074, a = 0.0954,
        Cbar = 5.8476, elements = {Si = 0.080866, O = 0.156453, Ti = 0.008092,
        Pb = 0.751938, As = 0.002651}
    },

    -- Lead oxide PbO
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lead_oxide_PbO.html
    LeadOxide = {
        ZoA = 0.4032094, x0 = 0.0356, I = 7.667E-07, x1 = 3.5456,
        density = 9530, delta0 = 0, state = 'liquid', k = 2.7299, a = 0.1964,
        Cbar = 6.2162, elements = {Pb = 0.928318, O = 0.071682}
    },

    -- Lead tungstate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lead_tungstate.html
    LeadTungstate = {
        ZoA = 0.4130535, x0 = 0.4068, I = 6.007E-07, x1 = 3.0023,
        density = 8300, delta0 = 0, state = 'liquid', k = 3, a = 0.2276,
        Cbar = 5.8528, elements = {Pb = 0.455347, O = 0.140462, W = 0.404011}
    },

    -- Liquid argon
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_argon.html
    LiquidArgon = {
        ZoA = 0.4505846, x0 = 0.2, I = 1.88E-07, x1 = 3, density = 1396,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1956, Cbar = 5.2146,
        elements = {Ar = 1}
    },

    -- Liquid bromine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_bromine.html
    LiquidBromine = {
        ZoA = 0.4380251, x0 = 0.3669, I = 3.57E-07, x1 = 3, density = 3103,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2211, Cbar = 5.7268,
        elements = {Br = 1}
    },

    -- Liquid chlorine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_chlorine.html
    LiquidChlorine = {
        ZoA = 0.4795054, x0 = 0.2, I = 1.74E-07, x1 = 3, density = 1574,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1802, Cbar = 4.8776,
        elements = {Cl = 1}
    },

    -- Liquid deuterium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_deuterium.html
    LiquidDeuterium = {
        ZoA = 0.4964997, x0 = 0.4467, I = 2.18E-08, x1 = 1.8923,
        density = 163.8, delta0 = 0, state = 'liquid', k = 5.6249, a = 0.1348,
        Cbar = 3.1288, elements = {D = 1}
    },

    -- Liquid fluorine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_fluorine.html
    LiquidFluorine = {
        ZoA = 0.4737241, x0 = 0.2, I = 1.15E-07, x1 = 3, density = 1507,
        delta0 = 0, state = 'liquid', k = 3, a = 0.145, Cbar = 4.105,
        elements = {F = 1}
    },

    -- Liquid helium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_helium.html
    LiquidHelium = {
        ZoA = 0.4996752, x0 = 0.4729, I = 4.18E-08, x1 = 2, density = 124.9,
        delta0 = 0, state = 'liquid', k = 3, a = 0.6571, Cbar = 4.518,
        elements = {He = 1}
    },

    -- Liquid hydrogen
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_hydrogen.html
    LiquidHydrogen = {
        ZoA = 0.991375, x0 = 0.44, I = 2.18E-08, x1 = 1.8856, density = 70.8,
        delta0 = 0, state = 'gaz', k = 5.6249, a = 0.1348, Cbar = 3.0977,
        elements = {H = 1}
    },

    -- Liquid krypton
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_krypton_Kr.html
    LiquidKrypton = {
        ZoA = 0.4296035, x0 = 0.4454, I = 3.52E-07, x1 = 3, density = 2418,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2349, Cbar = 5.9674,
        elements = {Kr = 1}
    },

    -- Liquid neon
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_neon.html
    LiquidNeon = {
        ZoA = 0.4955451, x0 = 0.2, I = 1.37E-07, x1 = 3, density = 1204,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1692, Cbar = 4.6345,
        elements = {Ne = 1}
    },

    -- Liquid nitrogen
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_nitrogen.html
    LiquidNitrogen = {
        ZoA = 0.499743, x0 = 0.3039, I = 8.2E-08, x1 = 2, density = 807,
        delta0 = 0, state = 'liquid', k = 3, a = 0.5329, Cbar = 3.9996,
        elements = {N = 1}
    },

    -- Liquid oxygen
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_oxygen.html
    LiquidOxygen = {
        ZoA = 0.5000219, x0 = 0.2868, I = 9.5E-08, x1 = 2, density = 1141,
        delta0 = 0, state = 'liquid', k = 3, a = 0.5223, Cbar = 3.9471,
        elements = {O = 1}
    },

    -- Liquid propane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_propane.html
    LiquidPropane = {
        ZoA = 0.589483, x0 = 0.2564, I = 5.2E-08, x1 = 2.6271, density = 493,
        delta0 = 0, state = 'liquid', k = 3.562, a = 0.1033, Cbar = 3.4162,
        elements = {C = 0.817145, H = 0.182855}
    },

    -- Liquid xenon
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/liquid_xenon_Xe.html
    LiquidXenon = {
        ZoA = 0.4112907, x0 = 0.5993, I = 4.82E-07, x1 = 3, density = 2953,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2659, Cbar = 6.4396,
        elements = {Xe = 1}
    },

    -- Lithium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lithium_Li.html
    Lithium = {
        ZoA = 0.4321521, x0 = 0.1304, I = 4E-08, x1 = 1.6397, density = 534,
        delta0 = 0.14, state = 'liquid', k = 2.4993, a = 0.9514, Cbar = 3.1221,
        elements = {Li = 1}
    },

    -- Lithium amide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lithium_amide.html
    LithiumAmide = {
        ZoA = 0.5224698, x0 = 0.0198, I = 5.55E-08, x1 = 2.5152, density = 1178,
        delta0 = 0, state = 'liquid', k = 3.7534, a = 0.0874, Cbar = 2.7961,
        elements = {H = 0.087783, N = 0.609955, Li = 0.302262}
    },

    -- Lithium carbonate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lithium_carbonate.html
    LithiumCarbonate = {
        ZoA = 0.4871945, x0 = 0.0551, I = 8.79E-08, x1 = 2.6598, density = 2110,
        delta0 = 0, state = 'liquid', k = 3.5417, a = 0.0994, Cbar = 3.2029,
        elements = {O = 0.649579, C = 0.16255, Li = 0.187871}
    },

    -- Lithium fluoride LiF
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lithium_fluoride_LiF.html
    LithiumFluoride = {
        ZoA = 0.4626001, x0 = 0.0171, I = 9.4E-08, x1 = 2.7049, density = 2635,
        delta0 = 0, state = 'liquid', k = 3.7478, a = 0.0759, Cbar = 3.1667,
        elements = {F = 0.732415, Li = 0.267585}
    },

    -- Lithium hydride LiH
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lithium_hydride_LiH.html
    LithiumHydride = {
        ZoA = 0.5030599, x0 = 0.0988, I = 3.65E-08, x1 = 1.4515, density = 820,
        delta0 = 0, state = 'liquid', k = 2.5849, a = 0.9057, Cbar = 2.358,
        elements = {Li = 0.873203, H = 0.126797}
    },

    -- Lithium iodide LiI
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lithium_iodide_LiI.html
    LithiumIodide = {
        ZoA = 0.4183912, x0 = 0.0892, I = 4.851E-07, x1 = 3.3702,
        density = 3494, delta0 = 0, state = 'liquid', k = 2.7146, a = 0.2327,
        Cbar = 6.2671, elements = {I = 0.948142, Li = 0.051858}
    },

    -- Lithium oxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lithium_oxide.html
    LithiumOxide = {
        ZoA = 0.4684916, x0 = 0.0511, I = 7.36E-08, x1 = 2.5874, density = 2013,
        delta0 = 0, state = 'liquid', k = 3.7878, a = 0.0803, Cbar = 2.934,
        elements = {O = 0.53543, Li = 0.46457}
    },

    -- Lithium tetraborate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lithium_tetraborate.html
    LithiumTetraborate = {
        ZoA = 0.4847895, x0 = 0.0737, I = 9.46E-08, x1 = 2.6502, density = 2440,
        delta0 = 0, state = 'liquid', k = 3.4389, a = 0.1107, Cbar = 3.2093,
        elements = {B = 0.25568, O = 0.662235, Li = 0.082085}
    },

    -- Livermorium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/livermorium_Lv.html
    Livermorium = {
        ZoA = 0.3956276, x0 = 0.7064, I = 1.213E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2913, Cbar = 6.7681,
        elements = {Lv = 1}
    },

    -- Lung ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lung_ICRP.html
    LungICRP = {
        ZoA = 0.5495746, x0 = 0.2261, I = 7.53E-08, x1 = 2.8001, density = 1050,
        delta0 = 0, state = 'liquid', k = 3.5353, a = 0.0859, Cbar = 3.4708,
        elements = {K = 0.00194, O = 0.757072, S = 0.00225, H = 0.101278,
        P = 0.0008, Fe = 0.00037, Zn = 1E-05, Ca = 9E-05, Na = 0.00184,
        Cl = 0.00266, Mg = 0.00073, C = 0.10231, N = 0.02865}
    },

    -- Lutetium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lutetium_Lu.html
    Lutetium = {
        ZoA = 0.4057908, x0 = 0.156, I = 6.94E-07, x1 = 3.5218, density = 9841,
        delta0 = 0.14, state = 'liquid', k = 2.5643, a = 0.2403, Cbar = 5.9784,
        elements = {Lu = 1}
    },

    -- Lutetium aluminum oxide 1
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lutetium_aluminum_oxide_1.html
    LutetiumAluminumOxide1 = {
        ZoA = 0.4320927, x0 = 0.2, I = 4.232E-07, x1 = 3, density = 8300,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1902, Cbar = 5.0967,
        elements = {Al = 0.107949, Lu = 0.700017, O = 0.192034}
    },

    -- Lutetium aluminum oxide 2
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lutetium_aluminum_oxide_2.html
    LutetiumAluminumOxide2 = {
        ZoA = 0.4390698, x0 = 0.2, I = 3.659E-07, x1 = 3, density = 6730,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1858, Cbar = 4.9994,
        elements = {Al = 0.158379, Lu = 0.616224, O = 0.225396}
    },

    -- Lutetium fluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lutetium_fluoride.html
    LutetiumFluoride = {
        ZoA = 0.4224826, x0 = 0.2214, I = 4.587E-07, x1 = 3, density = 8300,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1986, Cbar = 5.2803,
        elements = {Lu = 0.754291, F = 0.245709}
    },

    -- Lutetium silicon oxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/lutetium_silicon_oxide.html
    LutetiumSiliconOxide = {
        ZoA = 0.4279328, x0 = 0.2732, I = 4.72E-07, x1 = 3, density = 7400,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2062, Cbar = 5.4394,
        elements = {Si = 0.06132, O = 0.17466, Lu = 0.76402}
    },

    -- M3 WAX
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/M3_WAX.html
    M3WAX = {
        ZoA = 0.5550295, x0 = 0.1523, I = 6.79E-08, x1 = 2.7529, density = 1050,
        delta0 = 0, state = 'liquid', k = 3.6412, a = 0.0786, Cbar = 3.254,
        elements = {O = 0.092183, Mg = 0.134792, H = 0.114318, C = 0.655823,
        Ca = 0.002883}
    },

    -- Magnesium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/magnesium_Mg.html
    Magnesium = {
        ZoA = 0.4937134, x0 = 0.1499, I = 1.56E-07, x1 = 3.0668, density = 1740,
        delta0 = 0.08, state = 'liquid', k = 3.6166, a = 0.0816, Cbar = 4.5297,
        elements = {Mg = 1}
    },

    -- Magnesium carbonate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/magnesium_carbonate.html
    MagnesiumCarbonate = {
        ZoA = 0.4981362, x0 = 0.086, I = 1.18E-07, x1 = 2.7997, density = 2958,
        delta0 = 0, state = 'liquid', k = 3.5003, a = 0.0922, Cbar = 3.4319,
        elements = {O = 0.569278, C = 0.142455, Mg = 0.288267}
    },

    -- Magnesium fluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/magnesium_fluoride.html
    MagnesiumFluoride = {
        ZoA = 0.4815223, x0 = 0.1369, I = 1.343E-07, x1 = 2.863, density = 3000,
        delta0 = 0, state = 'liquid', k = 3.6485, a = 0.0793, Cbar = 3.7105,
        elements = {Mg = 0.390117, F = 0.609883}
    },

    -- Magnesium oxide MgO
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/magnesium_oxide_MgO.html
    MagnesiumOxide = {
        ZoA = 0.4962176, x0 = 0.0575, I = 1.438E-07, x1 = 2.858, density = 3580,
        delta0 = 0, state = 'liquid', k = 3.5968, a = 0.0831, Cbar = 3.6404,
        elements = {Mg = 0.603036, O = 0.396964}
    },

    -- Magnesium tetraborate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/magnesium_tetraborate.html
    MagnesiumTetraborate = {
        ZoA = 0.4900675, x0 = 0.1147, I = 1.083E-07, x1 = 2.7635,
        density = 2530, delta0 = 0, state = 'liquid', k = 3.4893, a = 0.097,
        Cbar = 3.4328, elements = {B = 0.240837, O = 0.62379, Mg = 0.135373}
    },

    -- Manganese
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/manganese_Mn.html
    Manganese = {
        ZoA = 0.4550584, x0 = 0.0447, I = 2.72E-07, x1 = 3.1074, density = 7440,
        delta0 = 0.14, state = 'liquid', k = 2.9796, a = 0.1497, Cbar = 4.2702,
        elements = {Mn = 1}
    },

    -- Meitnerium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/meitnerium_Mt.html
    Meitnerium = {
        ZoA = 0.3918664, x0 = 0.6522, I = 1.115E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2781, Cbar = 6.6019,
        elements = {Mt = 1}
    },

    -- Mendelevium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/mendelevium_Md.html
    Mendelevium = {
        ZoA = 0.3913242, x0 = 0.5886, I = 1.007E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2636, Cbar = 6.4068,
        elements = {Md = 1}
    },

    -- Mercuric iodide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/mercuric_iodide.html
    MercuricIodide = {
        ZoA = 0.4093311, x0 = 0.104, I = 6.845E-07, x1 = 3.4728, density = 6360,
        delta0 = 0, state = 'liquid', k = 2.7264, a = 0.2151, Cbar = 6.3787,
        elements = {I = 0.55856, Hg = 0.44144}
    },

    -- Mercury
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/mercury_Hg.html
    Mercury = {
        ZoA = 0.3988195, x0 = 0.2756, I = 8E-07, x1 = 3.7275, density = 13550,
        delta0 = 0.14, state = 'liquid', k = 3.0519, a = 0.1101, Cbar = 5.9605,
        elements = {Hg = 1}
    },

    -- Methane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/methane.html
    Methane = {
        ZoA = 0.6231489, x0 = 1.6263, I = 4.17E-08, x1 = 3.9716,
        density = 0.6672, delta0 = 0, state = 'gaz', k = 3.6257, a = 0.0925,
        Cbar = 9.5243, elements = {C = 0.748694, H = 0.251306}
    },

    -- Methanol
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/methanol.html
    Methanol = {
        ZoA = 0.5616682, x0 = 0.2529, I = 6.76E-08, x1 = 2.7639,
        density = 791.4, delta0 = 0, state = 'liquid', k = 3.5477, a = 0.0897,
        Cbar = 3.516, elements = {H = 0.125822, C = 0.374852, O = 0.499326}
    },

    -- Mix D wax
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/mix_D_wax.html
    MixDWax = {
        ZoA = 0.5646912, x0 = 0.1371, I = 6.09E-08, x1 = 2.7145, density = 990,
        delta0 = 0, state = 'liquid', k = 3.6823, a = 0.0749, Cbar = 3.078,
        elements = {O = 0.03502, Mg = 0.038594, H = 0.13404, C = 0.77796,
        Ti = 0.014386}
    },

    -- Mn-dimethyl formamide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/mn-dimethyl_formamide.html
    MnDimethylFormamide = {
        ZoA = 0.5471629, x0 = 0.1977, I = 6.66E-08, x1 = 2.6686,
        density = 948.7, delta0 = 0, state = 'liquid', k = 3.371, a = 0.1147,
        Cbar = 3.3311, elements = {O = 0.218887, H = 0.096523, C = 0.492965,
        N = 0.191625}
    },

    -- Molybdenum
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/molybdenum_Mo.html
    Molybdenum = {
        ZoA = 0.4377234, x0 = 0.2267, I = 4.24E-07, x1 = 3.2784,
        density = 10220, delta0 = 0.14, state = 'liquid', k = 3.2549,
        a = 0.1053, Cbar = 4.8793, elements = {Mo = 1}
    },

    -- Moscovium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/moscovium_Mc.html
    Moscovium = {
        ZoA = 0.3976569, x0 = 0.696, I = 1.199E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2887, Cbar = 6.7363,
        elements = {Mc = 1}
    },

    -- Ms20 tissue substitute
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ms20_tissue_substitute.html
    Ms20TissueSubstitute = {
        ZoA = 0.5387954, x0 = 0.1997, I = 7.51E-08, x1 = 2.8033, density = 1000,
        delta0 = 0, state = 'liquid', k = 3.6061, a = 0.0829, Cbar = 3.5341,
        elements = {O = 0.186381, N = 0.017798, Mg = 0.130287, H = 0.081192,
        C = 0.583442, Cl = 0.0009}
    },

    -- Muscle-equivalent liquid without sucrose
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/muscle-equivalent_liquid_without_sucrose.html
    MuscleEquivalentLiquidWithoutSucrose = {
        ZoA = 0.5500582, x0 = 0.2187, I = 7.42E-08, x1 = 2.768, density = 1070,
        delta0 = 0, state = 'liquid', k = 3.4982, a = 0.0914, Cbar = 3.4216,
        elements = {O = 0.742522, H = 0.101969, C = 0.120058, N = 0.035451}
    },

    -- Muscle-equivalent liquid with sucrose
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/muscle-equivalent_liquid_with_sucrose.html
    MuscleEquivalentLiquidWithSucrose = {
        ZoA = 0.5482054, x0 = 0.2098, I = 7.43E-08, x1 = 2.755, density = 1110,
        delta0 = 0, state = 'liquid', k = 3.4699, a = 0.0948, Cbar = 3.391,
        elements = {O = 0.7101, H = 0.098234, C = 0.156214, N = 0.035451}
    },

    -- Naphtalene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/naphtalene.html
    Naphtalene = {
        ZoA = 0.5304906, x0 = 0.1374, I = 6.84E-08, x1 = 2.5429, density = 1145,
        delta0 = 0, state = 'liquid', k = 3.2654, a = 0.1477, Cbar = 3.2274,
        elements = {C = 0.937091, H = 0.062909}
    },

    -- N-butyl alcohol
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/n-butyl_alcohol.html
    NButylAlcohol = {
        ZoA = 0.5665295, x0 = 0.1937, I = 5.99E-08, x1 = 2.6439,
        density = 809.8, delta0 = 0, state = 'liquid', k = 3.5139, a = 0.1008,
        Cbar = 3.2425, elements = {H = 0.135978, C = 0.648171, O = 0.215851}
    },

    -- Neodymium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/neodymium_Nd.html
    Neodymium = {
        ZoA = 0.4159676, x0 = 0.195, I = 5.46E-07, x1 = 3.3029, density = 7008,
        delta0 = 0.14, state = 'liquid', k = 2.705, a = 0.2353, Cbar = 5.8135,
        elements = {Nd = 1}
    },

    -- Neon gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/neon_gas_Ne.html
    NeonGas = {
        ZoA = 0.4955451, x0 = 2.0735, I = 1.37E-07, x1 = 4.6421,
        density = 0.8385, delta0 = 0, state = 'gaz', k = 3.5771, a = 0.0806,
        Cbar = 11.9041, elements = {Ne = 1}
    },

    -- Neptunium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/neptunium_Np.html
    Neptunium = {
        ZoA = 0.3923256, x0 = 0.1869, I = 9.02E-07, x1 = 3.369, density = 20250,
        delta0 = 0.14, state = 'liquid', k = 2.8082, a = 0.1974, Cbar = 5.8149,
        elements = {Np = 1}
    },

    -- N-heptane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/n-heptane.html
    NHeptane = {
        ZoA = 0.5787032, x0 = 0.1928, I = 5.44E-08, x1 = 2.5706,
        density = 683.8, delta0 = 0, state = 'liquid', k = 3.4885, a = 0.1125,
        Cbar = 3.1978, elements = {C = 0.839063, H = 0.160937}
    },

    -- N-hexane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/n-hexane.html
    NHexane = {
        ZoA = 0.5800823, x0 = 0.1984, I = 5.4E-08, x1 = 2.5757, density = 660.3,
        delta0 = 0, state = 'liquid', k = 3.5027, a = 0.1108, Cbar = 3.2156,
        elements = {C = 0.836259, H = 0.163741}
    },

    -- Nickel
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/nickel_Ni.html
    Nickel = {
        ZoA = 0.4770553, x0 = 0.0566, I = 3.11E-07, x1 = 3.1851, density = 8902,
        delta0 = 0.1, state = 'liquid', k = 2.843, a = 0.165, Cbar = 4.3115,
        elements = {Ni = 1}
    },

    -- Nihonium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/nihonium_Nh.html
    Nihonium = {
        ZoA = 0.3948536, x0 = 0.6818, I = 1.171E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2852, Cbar = 6.6925,
        elements = {Nh = 1}
    },

    -- Niobium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/niobium_Nb.html
    Niobium = {
        ZoA = 0.4413044, x0 = 0.1785, I = 4.17E-07, x1 = 3.2201, density = 8570,
        delta0 = 0.14, state = 'liquid', k = 3.093, a = 0.1388, Cbar = 5.0141,
        elements = {Nb = 1}
    },

    -- Nitrobenzene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/nitrobenzene.html
    Nitrobenzene = {
        ZoA = 0.5198277, x0 = 0.1777, I = 7.58E-08, x1 = 2.663, density = 1199,
        delta0 = 0, state = 'liquid', k = 3.3091, a = 0.1273, Cbar = 3.4073,
        elements = {O = 0.259918, H = 0.040935, C = 0.585374, N = 0.113773}
    },

    -- Nitrogen gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/nitrogen_gas.html
    NitrogenGas = {
        ZoA = 0.499743, x0 = 1.7378, I = 8.2E-08, x1 = 4.1323, density = 1.165,
        delta0 = 0, state = 'gaz', k = 3.2125, a = 0.1535, Cbar = 10.54,
        elements = {N = 1}
    },

    -- Nitrous oxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/nitrous_oxide.html
    NitrousOxide = {
        ZoA = 0.4998444, x0 = 1.6477, I = 8.49E-08, x1 = 4.1565,
        density = 1.831, delta0 = 0, state = 'gaz', k = 3.3318, a = 0.1199,
        Cbar = 10.1575, elements = {O = 0.363517, N = 0.636483}
    },

    -- Nobelium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/nobelium_No.html
    Nobelium = {
        ZoA = 0.3936689, x0 = 0.595, I = 1.02E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.265, Cbar = 6.4264,
        elements = {No = 1}
    },

    -- N-pentane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/n-pentane.html
    NPentane = {
        ZoA = 0.5819974, x0 = 0.2086, I = 5.36E-08, x1 = 2.5855,
        density = 626.2, delta0 = 0, state = 'liquid', k = 3.5265, a = 0.1081,
        Cbar = 3.2504, elements = {C = 0.832365, H = 0.167635}
    },

    -- N-propyl alcohol
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/n-propyl_alcohol.html
    NPropylAlcohol = {
        ZoA = 0.5656655, x0 = 0.2046, I = 6.11E-08, x1 = 2.6681,
        density = 803.5, delta0 = 0, state = 'liquid', k = 3.5415, a = 0.0964,
        Cbar = 3.2915, elements = {H = 0.134173, C = 0.599595, O = 0.266232}
    },

    -- Nylon du Pont Elvamide 8062M
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/Nylon_du_Pont_Elvamide_8062M.html
    NylonDuPontElvamide8062M = {
        ZoA = 0.5505474, x0 = 0.1503, I = 6.43E-08, x1 = 2.6004, density = 1080,
        delta0 = 0, state = 'liquid', k = 3.4044, a = 0.1151, Cbar = 3.125,
        elements = {O = 0.148539, H = 0.103509, C = 0.648415, N = 0.099536}
    },

    -- Nylon type 11 Rilsan
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/Nylon_type_11_Rilsan.html
    NylonType11Rilsan = {
        ZoA = 0.5564007, x0 = 0.0678, I = 6.16E-08, x1 = 2.4281, density = 1425,
        delta0 = 0, state = 'liquid', k = 3.2576, a = 0.1487, Cbar = 2.7514,
        elements = {O = 0.087289, H = 0.115476, C = 0.720819, N = 0.076417}
    },

    -- Nylon type 6-10
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/Nylon_type_6-10.html
    NylonType610 = {
        ZoA = 0.5522787, x0 = 0.1304, I = 6.32E-08, x1 = 2.5681, density = 1140,
        delta0 = 0, state = 'liquid', k = 3.3912, a = 0.1185, Cbar = 3.0333,
        elements = {O = 0.1133, H = 0.107062, C = 0.680449, N = 0.099189}
    },

    -- Nylon type 6 6-6
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/Nylon_type_6_6-6.html
    NylonType666 = {
        ZoA = 0.5478279, x0 = 0.1261, I = 6.39E-08, x1 = 2.5759, density = 1180,
        delta0 = 0, state = 'liquid', k = 3.3826, a = 0.1182, Cbar = 3.0289,
        elements = {O = 0.141389, H = 0.097976, C = 0.636856, N = 0.123779}
    },

    -- Octane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/octane.html
    Octane = {
        ZoA = 0.5776625, x0 = 0.1882, I = 5.47E-08, x1 = 2.5664,
        density = 702.6, delta0 = 0, state = 'liquid', k = 3.4776, a = 0.1139,
        Cbar = 3.1834, elements = {C = 0.841179, H = 0.158821}
    },

    -- Oganesson
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/oganesson_Og.html
    Oganesson = {
        ZoA = 0.4010686, x0 = 2.0204, I = 1.242E-06, x1 = 1.9972, density = 12,
        delta0 = 0, state = 'gaz', k = 3, a = 0.0703, Cbar = 13.8662,
        elements = {Og = 1}
    },

    -- Osmium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/osmium_Os.html
    Osmium = {
        ZoA = 0.3995101, x0 = 0.0891, I = 7.46E-07, x1 = 3.5414,
        density = 22570, delta0 = 0.1, state = 'liquid', k = 2.9608, a = 0.1275,
        Cbar = 5.3083, elements = {Os = 1}
    },

    -- Oxygen gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/oxygen_gas.html
    OxygenGas = {
        ZoA = 0.5000219, x0 = 1.7541, I = 9.5E-08, x1 = 4.3213, density = 1.332,
        delta0 = 0, state = 'gaz', k = 3.2913, a = 0.1178, Cbar = 10.7004,
        elements = {O = 1}
    },

    -- Palladium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/palladium_Pd.html
    Palladium = {
        ZoA = 0.4322455, x0 = 0.0563, I = 4.7E-07, x1 = 3.0555, density = 12020,
        delta0 = 0.14, state = 'liquid', k = 2.7239, a = 0.2418, Cbar = 4.9358,
        elements = {Pd = 1}
    },

    -- Paraffin
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/paraffin.html
    Paraffin = {
        ZoA = 0.572638, x0 = 0.1289, I = 5.59E-08, x1 = 2.5084, density = 930,
        delta0 = 0, state = 'liquid', k = 3.4288, a = 0.1209, Cbar = 2.9551,
        elements = {C = 0.851395, H = 0.148605}
    },

    -- Parylene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/parylene.html
    Parylene = {
        ZoA = 0.5376289, x0 = 0.2, I = 6.6E-08, x1 = 2, density = 1060,
        delta0 = 0, state = 'liquid', k = 3, a = 0.3941, Cbar = 3.2197,
        elements = {C = 0.922577, H = 0.077423}
    },

    -- Phosphorus
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/phosphorus_P.html
    Phosphorus = {
        ZoA = 0.4842803, x0 = 0.1696, I = 1.73E-07, x1 = 2.7815, density = 2200,
        delta0 = 0.14, state = 'liquid', k = 2.9158, a = 0.2361, Cbar = 4.5214,
        elements = {P = 1}
    },

    -- Photographic emulsion
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/photographic_emulsion.html
    PhotographicEmulsion = {
        ZoA = 0.4545213, x0 = 0.1009, I = 3.31E-07, x1 = 3.4866, density = 3815,
        delta0 = 0, state = 'liquid', k = 3.0094, a = 0.124, Cbar = 5.3319,
        elements = {I = 0.00312, O = 0.066101, S = 0.00189, N = 0.01932,
        Br = 0.349103, H = 0.0141, C = 0.072261, Ag = 0.474105}
    },

    -- Plate glass
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/plate_glass.html
    PlateGlass = {
        ZoA = 0.4973163, x0 = 0.1237, I = 1.454E-07, x1 = 3.0649,
        density = 2400, delta0 = 0, state = 'liquid', k = 3.5381, a = 0.0768,
        Cbar = 4.0602, elements = {Si = 0.336553, O = 0.4598, Ca = 0.107205,
        Na = 0.096441}
    },

    -- Platinum
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/platinum_Pt.html
    Platinum = {
        ZoA = 0.3998257, x0 = 0.1484, I = 7.9E-07, x1 = 3.6212, density = 21450,
        delta0 = 0.12, state = 'liquid', k = 3.0417, a = 0.1113, Cbar = 5.4732,
        elements = {Pt = 1}
    },

    -- Plutonium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/plutonium_Pu.html
    Plutonium = {
        ZoA = 0.3851449, x0 = 0.1557, I = 9.21E-07, x1 = 3.3981,
        density = 19840, delta0 = 0.14, state = 'liquid', k = 2.7679,
        a = 0.2042, Cbar = 5.8748, elements = {Pu = 1}
    },

    -- Plutonium dioxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/plutonium_dioxide.html
    PlutoniumDioxide = {
        ZoA = 0.3987067, x0 = 0.2311, I = 7.465E-07, x1 = 3.5554,
        density = 11460, delta0 = 0, state = 'liquid', k = 2.6522, a = 0.2059,
        Cbar = 5.9719, elements = {Pu = 0.881945, O = 0.118055}
    },

    -- Polonium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polonium_Po.html
    Polonium = {
        ZoA = 0.4019485, x0 = 0.4267, I = 8.3E-07, x1 = 3.8293, density = 9320,
        delta0 = 0.14, state = 'liquid', k = 3.183, a = 0.0928, Cbar = 6.4003,
        elements = {Po = 1}
    },

    -- Polyacrylonitrile
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyacrylonitrile.html
    Polyacrylonitrile = {
        ZoA = 0.5276274, x0 = 0.1504, I = 6.96E-08, x1 = 2.5159, density = 1170,
        delta0 = 0, state = 'liquid', k = 3.1975, a = 0.1628, Cbar = 3.2459,
        elements = {H = 0.056983, C = 0.679056, N = 0.263962}
    },

    -- Polycarbonate Lexan
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polycarbonate_Lexan.html
    PolycarbonateLexan = {
        ZoA = 0.5269312, x0 = 0.1606, I = 7.31E-08, x1 = 2.6225, density = 1200,
        delta0 = 0, state = 'liquid', k = 3.3288, a = 0.1286, Cbar = 3.3201,
        elements = {H = 0.055491, C = 0.755751, O = 0.188758}
    },

    -- Polychlorostyrene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polychlorostyrene.html
    Polychlorostyrene = {
        ZoA = 0.5251321, x0 = 0.1238, I = 8.17E-08, x1 = 2.9241, density = 1300,
        delta0 = 0, state = 'liquid', k = 3.5441, a = 0.0753, Cbar = 3.4659,
        elements = {H = 0.061869, C = 0.696325, Cl = 0.241806}
    },

    -- Polyethylene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyethylene.html
    Polyethylene = {
        ZoA = 0.570231, x0 = 0.1489, I = 5.74E-08, x1 = 2.5296, density = 890,
        delta0 = 0, state = 'liquid', k = 3.4292, a = 0.1211, Cbar = 3.0563,
        elements = {C = 0.856289, H = 0.143711}
    },

    -- Polyethylene terephthalate Mylar
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyethylene_terephthalate_Mylar.html
    PolyethyleneTerephthalateMylar = {
        ZoA = 0.5203444, x0 = 0.1562, I = 7.87E-08, x1 = 2.6507, density = 1400,
        delta0 = 0, state = 'liquid', k = 3.3076, a = 0.1268, Cbar = 3.3262,
        elements = {H = 0.041959, C = 0.625017, O = 0.333025}
    },

    -- Polyimide film
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyimide_film.html
    PolyimideFilm = {
        ZoA = 0.5126286, x0 = 0.1509, I = 7.96E-08, x1 = 2.5631, density = 1420,
        delta0 = 0, state = 'liquid', k = 3.1921, a = 0.1597, Cbar = 3.3497,
        elements = {O = 0.209235, H = 0.026362, C = 0.691133, N = 0.07327}
    },

    -- Polymethylmethacrylate acrylic
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polymethylmethacrylate_acrylic.html
    PolymethylmethacrylateAcrylic = {
        ZoA = 0.5393117, x0 = 0.1824, I = 7.4E-08, x1 = 2.6681, density = 1190,
        delta0 = 0, state = 'liquid', k = 3.3836, a = 0.1143, Cbar = 3.3297,
        elements = {H = 0.080538, C = 0.599848, O = 0.319614}
    },

    -- Polyoxymethylene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyoxymethylene.html
    Polyoxymethylene = {
        ZoA = 0.5328203, x0 = 0.1584, I = 7.74E-08, x1 = 2.6838, density = 1425,
        delta0 = 0, state = 'liquid', k = 3.4002, a = 0.1081, Cbar = 3.2514,
        elements = {H = 0.067135, C = 0.400017, O = 0.532848}
    },

    -- Polypropylene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polypropylene.html
    Polypropylene = {
        ZoA = 0.570231, x0 = 0.1452, I = 5.74E-08, x1 = 2.5259, density = 905,
        delta0 = 0, state = 'liquid', k = 3.4292, a = 0.1211, Cbar = 3.0395,
        elements = {C = 0.856289, H = 0.143711}
    },

    -- Polystyrene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polystyrene.html
    Polystyrene = {
        ZoA = 0.5376265, x0 = 0.1647, I = 6.87E-08, x1 = 2.5031, density = 1060,
        delta0 = 0, state = 'liquid', k = 3.2224, a = 0.1645, Cbar = 3.2999,
        elements = {C = 0.922582, H = 0.077418}
    },

    -- Polytetrafluoroethylene Teflon
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polytetrafluoroethylene_Teflon.html
    PolytetrafluoroethyleneTeflon = {
        ZoA = 0.4799271, x0 = 0.1648, I = 9.91E-08, x1 = 2.7404, density = 2200,
        delta0 = 0, state = 'liquid', k = 3.4046, a = 0.1061, Cbar = 3.4161,
        elements = {C = 0.240183, F = 0.759817}
    },

    -- Polytrifluorochloroethylene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polytrifluorochloroethylene.html
    Polytrifluorochloroethylene = {
        ZoA = 0.4808101, x0 = 0.1714, I = 1.207E-07, x1 = 3.0265,
        density = 2100, delta0 = 0, state = 'liquid', k = 3.5085, a = 0.0773,
        Cbar = 3.8551, elements = {F = 0.489354, C = 0.20625, Cl = 0.304395}
    },

    -- Polyvinylacetate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyvinylacetate.html
    Polyvinylacetate = {
        ZoA = 0.5342739, x0 = 0.1769, I = 7.37E-08, x1 = 2.6747, density = 1190,
        delta0 = 0, state = 'liquid', k = 3.3762, a = 0.1144, Cbar = 3.3309,
        elements = {H = 0.070245, C = 0.558066, O = 0.371689}
    },

    -- Polyvinyl alcohol
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyvinyl_alcohol.html
    PolyvinylAlcohol = {
        ZoA = 0.544732, x0 = 0.1401, I = 6.97E-08, x1 = 2.6315, density = 1300,
        delta0 = 0, state = 'liquid', k = 3.3893, a = 0.1118, Cbar = 3.1115,
        elements = {H = 0.091517, C = 0.545298, O = 0.363185}
    },

    -- Polyvinyl butyral
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyvinyl_butyral.html
    PolyvinylButyral = {
        ZoA = 0.5452996, x0 = 0.1555, I = 6.72E-08, x1 = 2.6186, density = 1120,
        delta0 = 0, state = 'liquid', k = 3.3983, a = 0.1154, Cbar = 3.1865,
        elements = {H = 0.092802, C = 0.680561, O = 0.226637}
    },

    -- Polyvinylchloride PVC
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyvinylchloride_PVC.html
    PolyvinylchloridePVC = {
        ZoA = 0.5119741, x0 = 0.1559, I = 1.082E-07, x1 = 2.9415,
        density = 1300, delta0 = 0, state = 'liquid', k = 3.2104, a = 0.1244,
        Cbar = 4.0532, elements = {H = 0.04838, C = 0.38436, Cl = 0.56726}
    },

    -- Polyvinylidene chloride Saran
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyvinylidene_chloride_Saran.html
    PolyvinylideneChlorideSaran = {
        ZoA = 0.4951152, x0 = 0.1314, I = 1.343E-07, x1 = 2.9009,
        density = 1700, delta0 = 0, state = 'liquid', k = 3.102, a = 0.1547,
        Cbar = 4.2506, elements = {H = 0.020793, C = 0.247793, Cl = 0.731413}
    },

    -- Polyvinylidene fluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyvinylidene_fluoride.html
    PolyvinylideneFluoride = {
        ZoA = 0.4997083, x0 = 0.1717, I = 8.88E-08, x1 = 2.7375, density = 1760,
        delta0 = 0, state = 'liquid', k = 3.42, a = 0.1032, Cbar = 3.3793,
        elements = {H = 0.03148, C = 0.375141, F = 0.593379}
    },

    -- Polyvinyl pyrrolidone
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyvinyl_pyrrolidone.html
    PolyvinylPyrrolidone = {
        ZoA = 0.5397833, x0 = 0.1324, I = 6.77E-08, x1 = 2.5867, density = 1250,
        delta0 = 0, state = 'liquid', k = 3.3326, a = 0.125, Cbar = 3.1017,
        elements = {O = 0.143953, H = 0.081616, C = 0.648407, N = 0.126024}
    },

    -- Polyvinyltoluene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/polyvinyltoluene.html
    Polyvinyltoluene = {
        ZoA = 0.5413555, x0 = 0.1464, I = 6.47E-08, x1 = 2.4855, density = 1032,
        delta0 = 0, state = 'liquid', k = 3.2393, a = 0.161, Cbar = 3.1997,
        elements = {C = 0.915, H = 0.085}
    },

    -- Potassium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/potassium_K.html
    Potassium = {
        ZoA = 0.4859546, x0 = 0.3851, I = 1.9E-07, x1 = 3.1724, density = 862,
        delta0 = 0.1, state = 'liquid', k = 2.9233, a = 0.1983, Cbar = 5.6423,
        elements = {K = 1}
    },

    -- Potassium iodide KI
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/potassium_iodide_KI.html
    PotassiumIodide = {
        ZoA = 0.4337289, x0 = 0.1044, I = 4.319E-07, x1 = 3.3442,
        density = 3130, delta0 = 0, state = 'liquid', k = 2.7558, a = 0.2205,
        Cbar = 6.1088, elements = {K = 0.235528, I = 0.764472}
    },

    -- Potassium oxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/potassium_oxide.html
    PotassiumOxide = {
        ZoA = 0.488344, x0 = 0.048, I = 1.899E-07, x1 = 3.011, density = 2320,
        delta0 = 0, state = 'liquid', k = 3.0121, a = 0.1679, Cbar = 4.6463,
        elements = {K = 0.830148, O = 0.169852}
    },

    -- Praseodymium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/praseodymium_Pr.html
    Praseodymium = {
        ZoA = 0.4187129, x0 = 0.2313, I = 5.35E-07, x1 = 3.2753, density = 6773,
        delta0 = 0.14, state = 'liquid', k = 2.7331, a = 0.2326, Cbar = 5.8003,
        elements = {Pr = 1}
    },

    -- Promethium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/promethium_Pm.html
    Promethium = {
        ZoA = 0.4209422, x0 = 0.1614, I = 5.6E-07, x1 = 3.3186, density = 7264,
        delta0 = 0.14, state = 'liquid', k = 2.6674, a = 0.2428, Cbar = 5.8163,
        elements = {Pm = 1}
    },

    -- Propane
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/propane.html
    Propane = {
        ZoA = 0.589483, x0 = 1.4339, I = 4.71E-08, x1 = 3.8011, density = 1.868,
        delta0 = 0, state = 'gaz', k = 3.592, a = 0.0992, Cbar = 8.7939,
        elements = {C = 0.817145, H = 0.182855}
    },

    -- Protactinium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/protactinium_Pa.html
    Protactinium = {
        ZoA = 0.393878, x0 = 0.3144, I = 8.78E-07, x1 = 3.5079, density = 15370,
        delta0 = 0.14, state = 'liquid', k = 2.9845, a = 0.1477, Cbar = 6.0327,
        elements = {Pa = 1}
    },

    -- Pyridine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/pyridine.html
    Pyridine = {
        ZoA = 0.5309187, x0 = 0.167, I = 6.62E-08, x1 = 2.5245, density = 981.9,
        delta0 = 0, state = 'liquid', k = 3.1977, a = 0.164, Cbar = 3.3148,
        elements = {H = 0.06371, C = 0.759217, N = 0.177073}
    },

    -- Radium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/radium_Ra.html
    Radium = {
        ZoA = 0.3893375, x0 = 0.5991, I = 8.26E-07, x1 = 3.9428, density = 5000,
        delta0 = 0.14, state = 'liquid', k = 3.2454, a = 0.088, Cbar = 7.0452,
        elements = {Ra = 1}
    },

    -- Radon
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/radon_Rn.html
    Radon = {
        ZoA = 0.387356, x0 = 1.5368, I = 7.94E-07, x1 = 4.9889, density = 9.066,
        delta0 = 0, state = 'gaz', k = 2.7409, a = 0.208, Cbar = 13.2839,
        elements = {Rn = 1}
    },

    -- Rhenium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/rhenium_Re.html
    Rhenium = {
        ZoA = 0.4027776, x0 = 0.0559, I = 7.36E-07, x1 = 3.4845,
        density = 21020, delta0 = 0.08, state = 'liquid', k = 2.8627,
        a = 0.1518, Cbar = 5.3445, elements = {Re = 1}
    },

    -- Rhodium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/rhodium_Rh.html
    Rhodium = {
        ZoA = 0.4372923, x0 = 0.0576, I = 4.49E-07, x1 = 3.1069,
        density = 12410, delta0 = 0.14, state = 'liquid', k = 2.8633, a = 0.192,
        Cbar = 4.8008, elements = {Rh = 1}
    },

    -- Roentgenium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/roentgenium_Rg.html
    Roentgenium = {
        ZoA = 0.3933813, x0 = 0.6672, I = 1.143E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2816, Cbar = 6.6477,
        elements = {Rg = 1}
    },

    -- Rubber butyl
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/rubber_butyl.html
    RubberButyl = {
        ZoA = 0.570231, x0 = 0.1347, I = 5.65E-08, x1 = 2.5154, density = 920,
        delta0 = 0, state = 'liquid', k = 3.4296, a = 0.1211, Cbar = 2.9915,
        elements = {C = 0.856289, H = 0.143711}
    },

    -- Rubber natural
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/rubber_natural.html
    RubberNatural = {
        ZoA = 0.5577682, x0 = 0.1512, I = 5.98E-08, x1 = 2.4815, density = 920,
        delta0 = 0, state = 'liquid', k = 3.2879, a = 0.1506, Cbar = 3.1272,
        elements = {C = 0.881629, H = 0.118371}
    },

    -- Rubber neoprene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/rubber_neoprene.html
    RubberNeoprene = {
        ZoA = 0.5195184, x0 = 0.1501, I = 9.3E-08, x1 = 2.9461, density = 1230,
        delta0 = 0, state = 'liquid', k = 3.3632, a = 0.0976, Cbar = 3.7911,
        elements = {H = 0.05692, C = 0.542646, Cl = 0.400434}
    },

    -- Rubidium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/rubidium_Rb.html
    Rubidium = {
        ZoA = 0.4329116, x0 = 0.5737, I = 3.63E-07, x1 = 3.7995, density = 1532,
        delta0 = 0.14, state = 'liquid', k = 3.4177, a = 0.0726, Cbar = 6.4776,
        elements = {Rb = 1}
    },

    -- Ruthenium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ruthenium_Ru.html
    Ruthenium = {
        ZoA = 0.4353332, x0 = 0.0599, I = 4.41E-07, x1 = 3.0834,
        density = 12410, delta0 = 0.14, state = 'liquid', k = 2.8707,
        a = 0.1934, Cbar = 4.7694, elements = {Ru = 1}
    },

    -- Rutherfordium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/rutherfordium_Rf.html
    Rutherfordium = {
        ZoA = 0.3893352, x0 = 0.6157, I = 1.047E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2696, Cbar = 6.4898,
        elements = {Rf = 1}
    },

    -- Samarium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/samarium_Sm.html
    Samarium = {
        ZoA = 0.4123382, x0 = 0.1503, I = 5.74E-07, x1 = 3.3443, density = 7520,
        delta0 = 0.14, state = 'liquid', k = 2.6403, a = 0.247, Cbar = 5.8517,
        elements = {Sm = 1}
    },

    -- Scandium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/scandium_Sc.html
    Scandium = {
        ZoA = 0.4671244, x0 = 0.164, I = 2.16E-07, x1 = 3.0593, density = 2989,
        delta0 = 0.1, state = 'liquid', k = 3.0517, a = 0.1575, Cbar = 4.6949,
        elements = {Sc = 1}
    },

    -- Seaborgium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/seaborgium_Sg.html
    Seaborgium = {
        ZoA = 0.3938632, x0 = 0.6309, I = 1.074E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2731, Cbar = 6.5365,
        elements = {Sg = 1}
    },

    -- Selenium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/selenium_Se.html
    Selenium = {
        ZoA = 0.4305334, x0 = 0.2258, I = 3.48E-07, x1 = 3.6264, density = 4500,
        delta0 = 0.1, state = 'liquid', k = 3.4317, a = 0.0657, Cbar = 5.321,
        elements = {Se = 1}
    },

    -- Shielding concrete
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/shielding_concrete.html
    ShieldingConcrete = {
        ZoA = 0.5027312, x0 = 0.1301, I = 1.352E-07, x1 = 3.0466,
        density = 2300, delta0 = 0, state = 'liquid', k = 3.5467, a = 0.0751,
        Cbar = 3.9464, elements = {K = 0.013, O = 0.529107, Al = 0.033872,
        Si = 0.337021, Fe = 0.014, Na = 0.016, Ca = 0.044, Mg = 0.002,
        C = 0.001, H = 0.01}
    },

    -- Silica aerogel
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/silica_aerogel.html
    SilicaAerogel = {
        ZoA = 0.5009712, x0 = 0.6029, I = 1.392E-07, x1 = 3, density = 200,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2668, Cbar = 6.4507,
        elements = {Si = 0.453451, O = 0.543192, H = 0.003357}
    },

    -- Silicon
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/silicon_Si.html
    Silicon = {
        ZoA = 0.4984779, x0 = 0.2015, I = 1.73E-07, x1 = 2.8716, density = 2329,
        delta0 = 0.14, state = 'liquid', k = 3.2546, a = 0.1492, Cbar = 4.4355,
        elements = {Si = 1}
    },

    -- Silicon dioxide fused quartz
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/silicon_dioxide_fused_quartz.html
    SiliconDioxideFusedQuartz = {
        ZoA = 0.4993001, x0 = 0.15, I = 1.392E-07, x1 = 3.014, density = 2200,
        delta0 = 0, state = 'liquid', k = 3.5064, a = 0.0841, Cbar = 4.056,
        elements = {Si = 0.467435, O = 0.532565}
    },

    -- Silver
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/silver_Ag.html
    Silver = {
        ZoA = 0.4357177, x0 = 0.0657, I = 4.7E-07, x1 = 3.1074, density = 10500,
        delta0 = 0.14, state = 'liquid', k = 2.6899, a = 0.2458, Cbar = 5.063,
        elements = {Ag = 1}
    },

    -- Silver bromide AgBr
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/silver_bromide_AgBr.html
    SilverBromide = {
        ZoA = 0.4366996, x0 = 0.0352, I = 4.866E-07, x1 = 3.2109,
        density = 6473, delta0 = 0, state = 'liquid', k = 2.682, a = 0.2458,
        Cbar = 5.6139, elements = {Br = 0.425537, Ag = 0.574463}
    },

    -- Silver chloride AgCl
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/silver_chloride_AgCl.html
    SilverChloride = {
        ZoA = 0.4465494, x0 = 0.0139, I = 3.984E-07, x1 = 3.2022,
        density = 5560, delta0 = 0, state = 'liquid', k = 2.7041, a = 0.2297,
        Cbar = 5.3437, elements = {Ag = 0.752632, Cl = 0.247368}
    },

    -- Silver iodide AgI
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/silver_iodide_AgI.html
    SilverIodide = {
        ZoA = 0.4259452, x0 = 0.0148, I = 5.435E-07, x1 = 3.2908,
        density = 6010, delta0 = 0, state = 'liquid', k = 2.6572, a = 0.2506,
        Cbar = 5.9342, elements = {I = 0.540542, Ag = 0.459458}
    },

    -- Skeletal muscle ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/skeletal_muscle_ICRP.html
    SkeletalMuscleICRP = {
        ZoA = 0.5493013, x0 = 0.2282, I = 7.53E-08, x1 = 2.7999, density = 1040,
        delta0 = 0, state = 'liquid', k = 3.533, a = 0.0864, Cbar = 3.4809,
        elements = {K = 0.00302, O = 0.754773, S = 0.00241, H = 0.100637,
        P = 0.0018, Fe = 4E-05, Zn = 5E-05, Ca = 3E-05, Na = 0.00075,
        Cl = 0.00079, Mg = 0.00019, C = 0.10783, N = 0.02768}
    },

    -- Skin ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/skin_ICRP.html
    SkinICRP = {
        ZoA = 0.5492492, x0 = 0.2019, I = 7.27E-08, x1 = 2.7526, density = 1100,
        delta0 = 0, state = 'liquid', k = 3.4643, a = 0.0946, Cbar = 3.3546,
        elements = {K = 0.00085, O = 0.619002, S = 0.00159, H = 0.100588,
        P = 0.00033, Fe = 1E-05, Zn = 1E-05, Ca = 0.00015, Na = 7E-05,
        Cl = 0.00267, Mg = 6E-05, C = 0.22825, N = 0.04642}
    },

    -- Sodium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/sodium_Na.html
    Sodium = {
        ZoA = 0.4784731, x0 = 0.288, I = 1.49E-07, x1 = 3.1962, density = 971,
        delta0 = 0.08, state = 'liquid', k = 3.6452, a = 0.0777, Cbar = 5.0526,
        elements = {Na = 1}
    },

    -- Sodium carbonate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/sodium_carbonate.html
    SodiumCarbonate = {
        ZoA = 0.4906197, x0 = 0.1287, I = 1.25E-07, x1 = 2.8591, density = 2532,
        delta0 = 0, state = 'liquid', k = 3.5638, a = 0.0872, Cbar = 3.7178,
        elements = {O = 0.452861, C = 0.113323, Na = 0.433815}
    },

    -- Sodium chloride NaCl
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/sodium_chloride_NaCl.html
    SodiumChloride = {
        ZoA = 0.4790998, x0 = 0.1995, I = 1.753E-07, x1 = 2.9995,
        density = 2170, delta0 = 0, state = 'liquid', k = 3, a = 0.1596,
        Cbar = 4.4227, elements = {Cl = 0.606626, Na = 0.393375}
    },

    -- Sodium iodide NaI
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/sodium_iodide_NaI.html
    SodiumIodide = {
        ZoA = 0.4269689, x0 = 0.1203, I = 4.52E-07, x1 = 3.592, density = 3667,
        delta0 = 0, state = 'liquid', k = 3.0398, a = 0.1252, Cbar = 6.0572,
        elements = {I = 0.846627, Na = 0.153373}
    },

    -- Sodium monoxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/sodium_monoxide.html
    SodiumMonoxide = {
        ZoA = 0.4840357, x0 = 0.1652, I = 1.488E-07, x1 = 2.9793,
        density = 2270, delta0 = 0, state = 'liquid', k = 3.6943, a = 0.075,
        Cbar = 4.1892, elements = {Na = 0.741857, O = 0.258143}
    },

    -- Sodium nitrate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/sodium_nitrate.html
    SodiumNitrate = {
        ZoA = 0.4941473, x0 = 0.1534, I = 1.146E-07, x1 = 2.8221,
        density = 2261, delta0 = 0, state = 'liquid', k = 3.5097, a = 0.0939,
        Cbar = 3.6502, elements = {O = 0.56472, Na = 0.270485, N = 0.164795}
    },

    -- Soft tissue ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/soft_tissue_ICRP.html
    SoftTissueICRP = {
        ZoA = 0.5511313, x0 = 0.2211, I = 7.23E-08, x1 = 2.7799, density = 1000,
        delta0 = 0, state = 'liquid', k = 3.511, a = 0.0893, Cbar = 3.4354,
        elements = {K = 0.00199, O = 0.630238, S = 0.00199, H = 0.104472,
        P = 0.00133, Fe = 5E-05, Zn = 3E-05, Ca = 0.00023, Na = 0.00113,
        Cl = 0.00134, Mg = 0.00013, C = 0.23219, N = 0.02488}
    },

    -- Soft tissue ICRU four-component
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/soft_tissue_ICRU_four-component.html
    SoftTissueICRUFourComponent = {
        ZoA = 0.5496735, x0 = 0.2377, I = 7.49E-08, x1 = 2.7908, density = 1000,
        delta0 = 0, state = 'liquid', k = 3.4371, a = 0.0963, Cbar = 3.5087,
        elements = {O = 0.761828, H = 0.101172, C = 0.111, N = 0.026}
    },

    -- Solid carbon dioxide dry ice
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/solid_carbon_dioxide_dry_ice.html
    SolidCarbonDioxideDryIce = {
        ZoA = 0.4998932, x0 = 0.2, I = 8.5E-08, x1 = 2, density = 1563,
        delta0 = 0, state = 'liquid', k = 3, a = 0.4339, Cbar = 3.4513,
        elements = {C = 0.272916, O = 0.727084}
    },

    -- Standard rock
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/standard_rock.html
    StandardRock = {
        ZoA = 0.5, x0 = 0.0492, I = 1.364E-07, x1 = 3.0549, density = 2650,
        delta0 = 0, state = 'liquid', k = 3.412, a = 0.083, Cbar = 3.7738,
        elements = {Rk = 1}
    },

    -- Stilbene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/stilbene.html
    Stilbene = {
        ZoA = 0.5325523, x0 = 0.1734, I = 6.77E-08, x1 = 2.5142,
        density = 970.7, delta0 = 0, state = 'liquid', k = 3.2168, a = 0.1666,
        Cbar = 3.368, elements = {C = 0.932899, H = 0.067101}
    },

    -- Striated muscle ICRU
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/striated_muscle_ICRU.html
    StriatedMuscleICRU = {
        ZoA = 0.5509452, x0 = 0.2249, I = 7.47E-08, x1 = 2.8032, density = 1040,
        delta0 = 0, state = 'liquid', k = 3.5383, a = 0.0851, Cbar = 3.4636,
        elements = {K = 0.005, O = 0.729003, S = 0.005, H = 0.101997, P = 0.002,
        Na = 0.0008, Mg = 0.0002, C = 0.123, N = 0.035}
    },

    -- Strontium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/strontium_Sr.html
    Strontium = {
        ZoA = 0.433686, x0 = 0.4585, I = 3.66E-07, x1 = 3.6778, density = 2540,
        delta0 = 0.14, state = 'liquid', k = 3.4435, a = 0.0716, Cbar = 5.9867,
        elements = {Sr = 1}
    },

    -- Sucrose
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/sucrose.html
    Sucrose = {
        ZoA = 0.5316527, x0 = 0.1341, I = 7.75E-08, x1 = 2.6558, density = 1581,
        delta0 = 0, state = 'liquid', k = 3.363, a = 0.113, Cbar = 3.1526,
        elements = {H = 0.064779, C = 0.42107, O = 0.514151}
    },

    -- Sulfur
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/sulfur_S.html
    Sulfur = {
        ZoA = 0.4989787, x0 = 0.158, I = 1.8E-07, x1 = 2.7159, density = 2000,
        delta0 = 0.14, state = 'liquid', k = 2.6456, a = 0.3399, Cbar = 4.6659,
        elements = {S = 1}
    },

    -- Tantalum
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/tantalum_Ta.html
    Tantalum = {
        ZoA = 0.4034308, x0 = 0.2117, I = 7.18E-07, x1 = 3.4805,
        density = 16650, delta0 = 0.14, state = 'liquid', k = 2.7623, a = 0.178,
        Cbar = 5.5262, elements = {Ta = 1}
    },

    -- Technetium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/technetium_Tc.html
    Technetium = {
        ZoA = 0.4391914, x0 = 0.0949, I = 4.28E-07, x1 = 3.1253,
        density = 11500, delta0 = 0.14, state = 'liquid', k = 2.9738,
        a = 0.1657, Cbar = 4.7769, elements = {Tc = 1}
    },

    -- Tellurium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/tellurium_Te.html
    Tellurium = {
        ZoA = 0.4075139, x0 = 0.3296, I = 4.85E-07, x1 = 3.4418, density = 6240,
        delta0 = 0.14, state = 'liquid', k = 3.0354, a = 0.1382, Cbar = 5.7131,
        elements = {Te = 1}
    },

    -- Tennessine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/tennessine_Ts.html
    Tennessine = {
        ZoA = 0.3976738, x0 = 0.712, I = 1.227E-06, x1 = 3, density = 14000,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2927, Cbar = 6.7851,
        elements = {Ts = 1}
    },

    -- Terbium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/terbium_Tb.html
    Terbium = {
        ZoA = 0.408998, x0 = 0.0947, I = 6.14E-07, x1 = 3.4224, density = 8230,
        delta0 = 0.14, state = 'liquid', k = 2.6056, a = 0.2445, Cbar = 5.9044,
        elements = {Tb = 1}
    },

    -- Terphenyl
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/terphenyl.html
    Terphenyl = {
        ZoA = 0.5214577, x0 = 0.1322, I = 7.17E-08, x1 = 2.5429, density = 1234,
        delta0 = 0, state = 'liquid', k = 3.2685, a = 0.1496, Cbar = 3.2639,
        elements = {C = 0.955457, H = 0.044543}
    },

    -- Testes ICRP
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/testes_ICRP.html
    TestesICRP = {
        ZoA = 0.5510036, x0 = 0.2274, I = 7.5E-08, x1 = 2.7988, density = 1040,
        delta0 = 0, state = 'liquid', k = 3.5428, a = 0.0853, Cbar = 3.4698,
        elements = {K = 0.00208, O = 0.773884, S = 0.00146, H = 0.104166,
        P = 0.00125, Fe = 2E-05, Zn = 2E-05, Ca = 0.0001, Na = 0.00226,
        Cl = 0.00244, Mg = 0.00011, C = 0.09227, N = 0.01994}
    },

    -- Tetrachloroethylene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/tetrachloroethylene.html
    Tetrachloroethylene = {
        ZoA = 0.482409, x0 = 0.1713, I = 1.592E-07, x1 = 2.9083, density = 1625,
        delta0 = 0, state = 'liquid', k = 3.0156, a = 0.1859, Cbar = 4.6619,
        elements = {C = 0.144856, Cl = 0.855144}
    },

    -- Thallium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/thallium_Tl.html
    Thallium = {
        ZoA = 0.3963167, x0 = 0.3491, I = 8.1E-07, x1 = 3.8044, density = 11720,
        delta0 = 0.14, state = 'liquid', k = 3.145, a = 0.0945, Cbar = 6.1365,
        elements = {Tl = 1}
    },

    -- Thallium chloride TlCl
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/thallium_chloride_TlCl.html
    ThalliumChloride = {
        ZoA = 0.4086174, x0 = 0.0705, I = 6.903E-07, x1 = 3.5716,
        density = 7004, delta0 = 0, state = 'liquid', k = 2.769, a = 0.186,
        Cbar = 6.3009, elements = {Tl = 0.852187, Cl = 0.147822}
    },

    -- Thorium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/thorium_Th.html
    Thorium = {
        ZoA = 0.3878675, x0 = 0.4202, I = 8.47E-07, x1 = 3.7681,
        density = 11720, delta0 = 0.14, state = 'liquid', k = 3.261, a = 0.0865,
        Cbar = 6.2473, elements = {Th = 1}
    },

    -- Thulium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/thulium_Tm.html
    Thulium = {
        ZoA = 0.4084435, x0 = 0.0812, I = 6.74E-07, x1 = 3.5085, density = 9321,
        delta0 = 0.14, state = 'liquid', k = 2.5469, a = 0.2489, Cbar = 5.9677,
        elements = {Tm = 1}
    },

    -- Tin
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/tin_Sn.html
    Tin = {
        ZoA = 0.421191, x0 = 0.2879, I = 4.88E-07, x1 = 3.2959, density = 7310,
        delta0 = 0.14, state = 'liquid', k = 2.8576, a = 0.1869, Cbar = 5.534,
        elements = {Sn = 1}
    },

    -- Tissue-equivalent gas Methane based
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/tissue-equivalent_gas_Methane_based.html
    TissueEquivalentGasMethaneBased = {
        ZoA = 0.5498506, x0 = 1.6442, I = 6.12E-08, x1 = 4.1399,
        density = 1.064, delta0 = 0, state = 'gaz', k = 3.4708, a = 0.0995,
        Cbar = 9.95, elements = {O = 0.40678, H = 0.101869, C = 0.456179,
        N = 0.035172}
    },

    -- Tissue-equivalent gas Propane based
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/tissue-equivalent_gas_Propane_based.html
    TissueEquivalentGasPropaneBased = {
        ZoA = 0.5501921, x0 = 1.5139, I = 5.95E-08, x1 = 3.9916,
        density = 1.826, delta0 = 0, state = 'gaz', k = 3.5159, a = 0.098,
        Cbar = 9.3529, elements = {O = 0.293366, H = 0.102672, C = 0.56894,
        N = 0.035022}
    },

    -- Titanium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/titanium_Ti.html
    Titanium = {
        ZoA = 0.4596059, x0 = 0.0957, I = 2.33E-07, x1 = 3.0386, density = 4540,
        delta0 = 0.12, state = 'liquid', k = 3.0302, a = 0.1566, Cbar = 4.445,
        elements = {Ti = 1}
    },

    -- Titanium dioxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/titanium_dioxide.html
    TitaniumDioxide = {
        ZoA = 0.4757962, x0 = 0.0119, I = 1.795E-07, x1 = 3.1647,
        density = 4260, delta0 = 0, state = 'liquid', k = 3.3267, a = 0.0857,
        Cbar = 3.9522, elements = {Ti = 0.599408, O = 0.400592}
    },

    -- Toluene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/toluene.html
    Toluene = {
        ZoA = 0.54259, x0 = 0.1722, I = 6.25E-08, x1 = 2.5728, density = 866.9,
        delta0 = 0, state = 'liquid', k = 3.3558, a = 0.1328, Cbar = 3.3026,
        elements = {C = 0.91249, H = 0.08751}
    },

    -- Trichloroethylene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/trichloroethylene.html
    Trichloroethylene = {
        ZoA = 0.4870968, x0 = 0.1803, I = 1.481E-07, x1 = 2.914, density = 1460,
        delta0 = 0, state = 'liquid', k = 3.0137, a = 0.1827, Cbar = 4.6148,
        elements = {H = 0.007671, C = 0.182831, Cl = 0.809498}
    },

    -- Triethyl phosphate
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/triethyl_phosphate.html
    TriethylPhosphate = {
        ZoA = 0.53794, x0 = 0.2054, I = 8.12E-08, x1 = 2.9428, density = 1070,
        delta0 = 0, state = 'liquid', k = 3.6302, a = 0.0692, Cbar = 3.6242,
        elements = {O = 0.351334, H = 0.082998, C = 0.395628, P = 0.17004}
    },

    -- Tungsten
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/tungsten_W.html
    Tungsten = {
        ZoA = 0.4025217, x0 = 0.2167, I = 7.27E-07, x1 = 3.496, density = 19300,
        delta0 = 0.14, state = 'liquid', k = 2.8447, a = 0.1551, Cbar = 5.4059,
        elements = {W = 1}
    },

    -- Tungsten hexafluoride
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/tungsten_hexafluoride.html
    TungstenHexafluoride = {
        ZoA = 0.4297725, x0 = 0.302, I = 3.544E-07, x1 = 4.2602, density = 2400,
        delta0 = 0, state = 'liquid', k = 3.5134, a = 0.0366, Cbar = 5.9881,
        elements = {W = 0.617277, F = 0.382723}
    },

    -- Uranium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/uranium_U.html
    Uranium = {
        ZoA = 0.3865075, x0 = 0.226, I = 8.9E-07, x1 = 3.3721, density = 18950,
        delta0 = 0.14, state = 'liquid', k = 2.8171, a = 0.1968, Cbar = 5.8694,
        elements = {U = 1}
    },

    -- Uranium dicarbide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/uranium_dicarbide.html
    UraniumDicarbide = {
        ZoA = 0.3968701, x0 = 0.2191, I = 7.52E-07, x1 = 3.5208,
        density = 11280, delta0 = 0, state = 'liquid', k = 2.6577, a = 0.2112,
        Cbar = 6.0247, elements = {C = 0.091669, U = 0.908331}
    },

    -- Uranium monocarbide UC
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/uranium_monocarbide_UC.html
    UraniumMonocarbide = {
        ZoA = 0.3919377, x0 = 0.2524, I = 8.62E-07, x1 = 3.4941,
        density = 13630, delta0 = 0, state = 'liquid', k = 2.6169, a = 0.2297,
        Cbar = 6.121, elements = {C = 0.048036, U = 0.951964}
    },

    -- Uranium oxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/uranium_oxide.html
    UraniumOxide = {
        ZoA = 0.3999592, x0 = 0.1938, I = 7.206E-07, x1 = 3.5292,
        density = 10960, delta0 = 0, state = 'liquid', k = 2.6711, a = 0.2046,
        Cbar = 5.9605, elements = {U = 0.881498, O = 0.118502}
    },

    -- Urea
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/urea.html
    Urea = {
        ZoA = 0.5327825, x0 = 0.1603, I = 7.28E-08, x1 = 2.6525, density = 1323,
        delta0 = 0, state = 'liquid', k = 3.3461, a = 0.1161, Cbar = 3.2032,
        elements = {O = 0.266411, H = 0.067131, C = 0.199999, N = 0.466459}
    },

    -- Valine
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/valine.html
    Valine = {
        ZoA = 0.5462495, x0 = 0.1441, I = 6.77E-08, x1 = 2.6227, density = 1230,
        delta0 = 0, state = 'liquid', k = 3.3774, a = 0.1139, Cbar = 3.1059,
        elements = {O = 0.27315, H = 0.094641, C = 0.512645, N = 0.119565}
    },

    -- Vanadium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/vanadium_V.html
    Vanadium = {
        ZoA = 0.4514983, x0 = 0.0691, I = 2.45E-07, x1 = 3.0322, density = 6110,
        delta0 = 0.14, state = 'liquid', k = 3.0163, a = 0.1544, Cbar = 4.2659,
        elements = {V = 1}
    },

    -- Viton fluoroelastomer
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/viton_fluoroelastomer.html
    VitonFluoroelastomer = {
        ZoA = 0.4858445, x0 = 0.2106, I = 9.86E-08, x1 = 2.7874, density = 1800,
        delta0 = 0, state = 'liquid', k = 3.4556, a = 0.0997, Cbar = 3.5943,
        elements = {H = 0.009417, C = 0.280555, F = 0.710028}
    },

    -- Water ice
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/water_ice.html
    WaterIce = {
        ZoA = 0.5550013, x0 = 0.2586, I = 7.97E-08, x1 = 2.819, density = 918,
        delta0 = 0, state = 'liquid', k = 3.4773, a = 0.0912, Cbar = 3.5873,
        elements = {O = 0.888106, H = 0.111894}
    },

    -- Water liquid
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/water_liquid.html
    WaterLiquid = {
        ZoA = 0.5550013, x0 = 0.24, I = 7.97E-08, x1 = 2.8004, density = 1000,
        delta0 = 0, state = 'liquid', k = 3.4773, a = 0.0912, Cbar = 3.5017,
        elements = {O = 0.888106, H = 0.111894}
    },

    -- Water vapor
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/water_vapor.html
    WaterVapor = {
        ZoA = 0.5550013, x0 = 1.7952, I = 7.16E-08, x1 = 4.3437,
        density = 0.7562, delta0 = 0, state = 'gaz', k = 3.5901, a = 0.081,
        Cbar = 10.5962, elements = {O = 0.888106, H = 0.111894}
    },

    -- Xenon gas
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/xenon_gas_Xe.html
    XenonGas = {
        ZoA = 0.4112907, x0 = 1.5631, I = 4.82E-07, x1 = 4.7372,
        density = 5.483, delta0 = 0, state = 'gaz', k = 2.7414, a = 0.2331,
        Cbar = 12.7285, elements = {Xe = 1}
    },

    -- Xylene
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/xylene.html
    Xylene = {
        ZoA = 0.5462418, x0 = 0.1695, I = 6.18E-08, x1 = 2.5675, density = 870,
        delta0 = 0, state = 'liquid', k = 3.3564, a = 0.1322, Cbar = 3.2698,
        elements = {C = 0.905065, H = 0.094935}
    },

    -- Ytterbium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/ytterbium_Yb.html
    Ytterbium = {
        ZoA = 0.404498, x0 = 0.1144, I = 6.84E-07, x1 = 3.6191, density = 6903,
        delta0 = 0.14, state = 'liquid', k = 2.5141, a = 0.253, Cbar = 6.3071,
        elements = {Yb = 1}
    },

    -- Yttrium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/yttrium_Y.html
    Yttrium = {
        ZoA = 0.4386665, x0 = 0.3608, I = 3.79E-07, x1 = 3.5542, density = 4469,
        delta0 = 0.14, state = 'liquid', k = 3.4585, a = 0.0714, Cbar = 5.4801,
        elements = {Y = 1}
    },

    -- Yttrium aluminum oxide 1
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/yttrium_aluminum_oxide_1.html
    YttriumAluminumOxide1 = {
        ZoA = 0.4637388, x0 = 0.2, I = 2.393E-07, x1 = 3, density = 5500,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1538, Cbar = 4.2973,
        elements = {Y = 0.542487, Al = 0.164636, O = 0.292876}
    },

    -- Yttrium aluminum oxide 2
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/yttrium_aluminum_oxide_2.html
    YttriumAluminumOxide2 = {
        ZoA = 0.4683154, x0 = 0.2, I = 2.18E-07, x1 = 3, density = 4560,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1534, Cbar = 4.2884,
        elements = {Y = 0.449308, Al = 0.227263, O = 0.323428}
    },

    -- Yttrium bromide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/yttrium_bromide.html
    YttriumBromide = {
        ZoA = 0.4381986, x0 = 0.2831, I = 4.1E-07, x1 = 3, density = 5290,
        delta0 = 0, state = 'liquid', k = 3, a = 0.2077, Cbar = 5.4697,
        elements = {Y = 0.270545, Br = 0.729455}
    },

    -- Yttrium silicon oxide
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/yttrium_silicon_oxide.html
    YttriumSiliconOxide = {
        ZoA = 0.4617098, x0 = 0.2, I = 2.581E-07, x1 = 3, density = 4540,
        delta0 = 0, state = 'liquid', k = 3, a = 0.1696, Cbar = 4.6447,
        elements = {Y = 0.621949, O = 0.279813, Si = 0.098237}
    },

    -- Zinc
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/zinc_Zn.html
    Zinc = {
        ZoA = 0.4588419, x0 = 0.0049, I = 3.3E-07, x1 = 3.3668, density = 7133,
        delta0 = 0.08, state = 'liquid', k = 2.8652, a = 0.1471, Cbar = 4.6906,
        elements = {Zn = 1}
    },

    -- Zirconium
    -- Ref: https://pdg.lbl.gov/2020/AtomicNuclearProperties/HTML/zirconium_Zr.html
    Zirconium = {
        ZoA = 0.4384801, x0 = 0.2957, I = 3.93E-07, x1 = 3.489, density = 6506,
        delta0 = 0.14, state = 'liquid', k = 3.4533, a = 0.0718, Cbar = 5.1774,
        elements = {Zr = 1}
    },

}
