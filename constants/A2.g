################################################################################
## constants-A2.g
## Constants associated to the A2 quiver

Unbind(a); Unbind(v1); Unbind(v2);
Q := Quiver(2, [[1,2,"a"]]); 
q := 7;
k := GF(q);
zero := Zero(k);
one := One(k);
two := 2*one;
kQ := PathAlgebra(k,Q);
AssignGeneratorVariables(kQ);
A := kQ; 

## Generate all the indecomposable modules of kQ
Ind := [];
S := SimpleModules(A);
S1 := S[1]; S2 := S[2];
SetName(S[1], "S1");
SetName(S[2], "S2");
P := IndecProjectiveModules(A);
P1 := P[1];
SetName(P[1], "P1");
AppendDistinct(Ind, S);
AppendDistinct(Ind, P);

# Some convenient aliases
S12 := P1;
I2 := P1;
S1S1 := DirectSumOfQPAModules([S1,S1]);
S1S2 := DirectSumOfQPAModules([S1,S2]);
S1S1S1 := DirectSumOfQPAModules([S1,S1,S1]);
S1S1S2 := DirectSumOfQPAModules([S1,S1,S2]);
S1S2S2 := DirectSumOfQPAModules([S1,S2,S2]);
S2S2S2 := DirectSumOfQPAModules([S2,S2,S2]);
S1P1 := DirectSumOfQPAModules([S1,S12]);
S2P1 := DirectSumOfQPAModules([S2,S12]);

