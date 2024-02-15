# bridge T-joint
# -------------
# Units: kips, in.
# Pushover analysis multiple dispBeamColumn with strain penetration
# Modeling the circular RC column in a bridge T-joint tested by Sri Sritharan
# "Seismic response of column/cap beam tee connections with cap beam prestressing" Ph.D. thesis, UCSD

# Create ModelBuilder (with two dimensions and 2 DOF/node)
model basic -ndm 2 -ndf 3

# Create nodes
# tag X                     Y
node 1 0.0                  -48.0
node 2 0.0                  -30.0
node 3 0.0                  -12.0
node 4 0.0                  0.0
node 5 0.0                  12.0
node 6 0.0                  30.0
node 7 0.0                  48.0
node 8 12.0                 0.0
node 9 19.0                 0.0
node 10 40.0                0.0
node 11 61.5                0.0
node 12 84.0                0.0
node 13 12.0                0.0

# Fix supports at base of column
#      Tag DX    DY              RZ
fix    1    1    1               0
fix    7    1    0               0
# equalDOF $rNodeTag  $cNodeTag  $dof1 $dof2
equalDOF 8 13 2

# Define materials for nonlinear columns
## column Core    CONCRETE                 tag     f'c       ec0      f'cu      ecu
uniaxialMaterial  Concrete01                1      -6.38     -0.004   -5.11    -0.014
uniaxialMaterial  Concrete01                200    -6.38     -0.004   -5.11    -0.014
## column Cover    CONCRETE                 tag     f'c       ec0      f'cu      ecu
uniaxialMaterial  Concrete01                2      -4.56     -0.002    0.0     -0.006
## column stub CONCRETE                     tag     E
uniaxialMaterial  Elastic                   3       2280

## beam CONCRETE                            tag     f'c       ec0      f'cu      ecu
uniaxialMaterial  Concrete01                4      -5.76     -0.002     0      -0.006

## STEEL rebar
## STEEL02                                  tag     $Fy       $E       $b        $cR1   $cR2     $a1      $a2       $a3     $a4
uniaxialMaterial  Steel02                   5       65.0      29000   0.02       18.5   0.925    0.04     1.0       0.04    1.0
uniaxialMaterial  Steel02                   6       62.8      29000   0.02       18.5   0.925    0.00     1.0       0.00    1.0
uniaxialMaterial  Elastic                  7       29000

# uniaxialMaterial  StrPen01                $Tag    $sy       $fy       $su     $fu      $Kz     $Cd      $db       $fc     $la
uniaxialMaterial  StrPen01                  400     0.02      65        0.7     97.5     0.50    0.0      1.0       4.35    25.0
