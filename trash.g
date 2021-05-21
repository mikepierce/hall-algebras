################################################################################
### trash.g
### old code


IndAlt := [S1,S2,S3,S23,S21,S12,S213,S212,S123,S2132,S2123,S21323];

HallNumberIndAltTimes := function(Y) 
    return List(IndAlt, X -> [X, HallNumber(X,Y,DirectSumOfQPAModules([X,Y]))]);
end;

ExtensionsIndAltTimes := function(Y) 
    return List(IndAlt, X -> Length(DistinctExtensions(X,Y)));
end;

### Looking at the abelian Lie ideal M of g
### And trying to identify it as an sl3 module.
Gensg := GeneratorsOfAlgebra(g);
s3 := Gensg[1]; p1 := Gensg[2]; s23 := Gensg[3];
s2132 := Gensg[4]; s213 := Gensg[5]; s1 := Gensg[6];
p2 := Gensg[7]; i3 := Gensg[8]; s12 := Gensg[9];
s2 := Gensg[10]; i2 := Gensg[11]; i1 := Gensg[12];
M := Subalgebra(g, [p1, s2132, s213, s1, p2, i3, s12, i2, i1]);
sl3 := SimpleLieAlgebra("A", 2, Rationals);
# NOTE a row vector is a depth-1 list, and a matrix is a list of row vectors
matrices := [
    [ [0,1,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,1],[0,0,0] ],
    [ [0,0,1],[0,0,0],[0,0,0] ]
];
sl3plus := LieAlgebra(Rationals, matrices);
basisV3 := [ [1,0,0],[0,1,0],[0,0,1] ];
V3 := VectorSpace(Rationals, basisV3, "basis");
basisVV := List(Cartesian(basisV3, basisV3), pair -> TransposedMat([pair[1]])*[pair[2]]);
VV := VectorSpace(Rationals, basisVV, "basis");
VVmodule := RightAlgebraModule(sl3, \*, VV);

### This I is my old attempt at building the primitive relations from scratch
I := [
    ### Degree-2 relations
    s1*s3,
    z*s1,
    z*s2,
    ### Degree-3 relations
    s3*(s2*s3),
    s2*(s2*s3),
    (s1*z)-s1*(s1*s2),
    ### Degree-4 relations
    s3*(s1*(s2*s3)),
    s3*(z*s3) - s3*(s1*(s2*s3)),
    s1*(z*s3) - s1*(s1*(s2*s3)),
    ### Degree-5 relations
    s1*(z*(s2*s3)) - s1*(s3*(s2*(s1*s2))) + s1*(s2*(s3*(s1*s2))) 
    # ...
];

