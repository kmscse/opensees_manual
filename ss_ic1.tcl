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
