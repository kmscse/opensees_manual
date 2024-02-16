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

# uniaxialMaterial  StrPen01                $Tag    $sy       $fy       $su     $fu      $Kz     $R      $Cd      $db       $fc     $la
uniaxialMaterial  StrPen01                  400     0.02      65        0.7     97.5     0.50    0.7     0.0      1.0       4.35    25.0

# Define cross-section for nonlinear column
set colDia 24;            # bending in this direction (local and global y)
set cover 1.38;
set bcent 1.81;           # [expr $cover+0.197+0.5]
set As    0.60;           # Area of no. 7 bar
set R [expr $colDia/2.0]
set Rc [expr $colDia/2.0-$cover]
set Rb [expr $colDia/2.0-$bcent]

section Fiber 1 {
    # core concrete fibers
    patch circ                              1       70        22        0.0      0.0      0.0     $Rc     0.0      360.0
    # concrete cover fibers
    patch circ                              2       70        2         0.0      0.0      $Rc     $R      0.0      360.0
    # reinforcing fibers
    layer circ                              5       14        $As       0.0      0.0      $Rb     -90.0   244.3   
}

section Fiber 2 {
    # core concrete fibers
    patch circ                              3       70        22        0.0      0.0      0.0     $Rc     0.0      360.0
    # concrete cover fibers
    patch circ                              3       70        2         0.0      0.0      $Rc     $R      0.0      360.0
    # reinforcing fibers
    layer circ                              5       14        $As       0.0      0.0      $Rb     -90.0   244.3   
}

section Fiber 5 {
    # core concrete fibers
    patch circ                              200     70        22        0.0      0.0      0.0     $Rc     0.0      360.0
    # concrete cover fibers
    patch circ                              2       70        2         0.0      0.0      $Rc     $R      0.0      360.0
    # reinforcing fibers
    layer circ                              400     14        $As       0.0      0.0      $Rb     -90.0   244.3   
}

# Define cross-section for nonlinear cap beam
set bmw 27;                       # bending in this direction (local and global y)
set bmh 24;                       # bending in this direction (local and global y)
set cover 1.38;
set bcent 1.81;                   # [expr $cover+0.197+0.5]

set aw [expr $bmw/2.0]
set ac [expr $bmw/2.0-$cover]
set ab [expr $bmw/2.0-$bcent]
set bw [expr $bmh/2.0]
set bc [expr $bmh/2.0-$cover]
set bb [expr $bmh/2.0-$bcent]

section Fiber 3 {
    # concrete fibers
    patch quad    4    48     1     -$bw      -$aw      $bw     -$aw     $bw      $aw     -$bw      $aw
    # reinforcing fibers
    layer straight 6    7    $As     -$bb      $ab      -$bb     -$ab
    layer straight 6    7    $As      $bb      $ab       $bb     -$ab  
}

# Define column elements
## Geometry of column elements
geomTransf Linear 1

# Number of integration points along of element
set np 5


# Create the columns using displacement controlled beam-column elements
#                                     tag     ndl     ndJ      nsecs     secID     transfTag
element dispBeamColumn         1       1      2       $np      3          1
element dispBeamColumn         2       2      3       $np      3          1
element dispBeamColumn         3       3      4       $np      3          1
element dispBeamColumn         4       4      5       $np      3          1
element dispBeamColumn         5       5      6       $np      3          1
element dispBeamColumn         6       6      7       $np      3          1
element dispBeamColumn         7       4      8       $np      2          1
element dispBeamColumn         8       13     9       $np      1          1
element dispBeamColumn         9       9      10      $np      1          1
element dispBeamColumn         10      10     11      $np      1          1
element dispBeamColumn         11      11     12      $np      1          1
#   zeroLengthSection          tag     ndl    ndJ      secID
element zeroLengthSection      12      8      13       5

# Set up and perform analysis
## Create recorders
recorder  Node  -file   topdispac.out  -time  -node  13  -dof  1   disp
recorder  Node  -file   rot4ac.out     -time  -node  4   -dof  3   disp
recorder  Node  -file   rot8ac.out     -time  -node  8   -dof  3   disp
recorder  Drift drift84ac.out    4   8  2  1
recorder  Drift curvatureac.out    8   9  3  1
recorder  Drift curvatureac1.out   13  9  3  1
recorder  Element  -file   secstrspac.out  -time  -ele  8  section 5 fiber  -$Rb  0  5  stressStrain
recorder  Element  -file   secstrsnac.out  -time  -ele  8  section 5 fiber   $Rb  0  5  stressStrain
recorder  Element  -file   secstrcac.out   -time  -ele  8  section 5 fiber   $Rc  0  1  stressStrain
recorder  plot     topdispac.out  Node12_Ydisp   10   10   300   300  -columns  2  1

set P -90.0
pattern Plain  1  "Constant" {
    load  12  $P  0.0  0.0
}

# Define analysis parameters
integrator LoadControl  0
system SparseGeneral  -piv
test   NormDisplncr  1.0e-4  2000
numberer Plain
constraints Plain
algorithm KrylovNewton
analysis Static

# Do one analysis for constant axial load
analyze 1
