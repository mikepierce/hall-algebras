################################################################################
## constants-D4.g
## Constants associated to a folded D4-type quiver


Unbind(a); Unbind(b); Unbind(c); Unbind(v1); Unbind(v2); Unbind(v3);
Q := Quiver(3, [[1,2,"b"], [2,1,"c"], [2,3,"a"]]); 
q := 7;
k := GF(q);
#k := Rationals;
zero := Zero(k);
one := One(k);
two := 2*one;
kQ := PathAlgebra(k,Q);
AssignGeneratorVariables(kQ);
A := kQ/[b*c]; ## path left-to-right, not function composition.

## Generate all the indecomposable modules of kQ
Ind := [];
S := SimpleModules(A);
S1 := S[1]; S2 := S[2]; S3 := S[3]; 
P := IndecProjectiveModules(A);
P1 := P[1]; P2 := P[2]; P3 := P[3]; 
I := IndecInjectiveModules(A);
I1 := I[1]; I2 := I[2]; I3 := I[3]; 
AppendDistinct(Ind, S);
AppendDistinct(Ind, P);
AppendDistinct(Ind, I);
for i in [1..Length(VerticesOfQuiver(Q))] do
    SetName(S[i], Concatenation("S", String(i)));
    SetName(P[i], Concatenation("P", String(i)));
    SetName(I[i], Concatenation("I", String(i)));
od;
## S23 is a generator of Ext^1(S2,S3)
ext := ExtOverAlgebra(S2,S3);
pushout := PushOut(ext[1],ext[2][1]);
S23 := Range(pushout[1]);
SetName(S23,"S23");
Add(Ind, S23);
## S213 is a generator of Ext^1(I1,S3), or of Ext^1(S23,S[1]) too
ext := ExtOverAlgebra(I1,S3);
pushout := PushOut(ext[1],ext[2][1]);
S213 := Range(pushout[1]);
SetName(S213,"S213");
Add(Ind, S213);
## S12 is a generator of Ext^1(S1,S2)
ext := ExtOverAlgebra(S1,S2);
pushout := PushOut(ext[1],ext[2][1]);
S12 := Range(pushout[1]);
SetName(S12,"S12");
Add(Ind, S12);
## S2132 is a generator (of two generators) of Ext^1(I2,S3), 
## or also of Ext^1(S213,S[2]) too
ext := ExtOverAlgebra(I2,S3);
pushout := PushOut(ext[1],ext[2][1]);
S2132 := Range(pushout[1]);
SetName(S2132,"S2132");
Add(Ind, S2132);

# Some convenient aliases
S21 := I1;
S212 := I2;
S1S1 := DirectSumOfQPAModules([S1,S1]);
S1S2 := DirectSumOfQPAModules([S1,S2]);
S1S1S1 := DirectSumOfQPAModules([S1,S1,S1]);
S1S1S2 := DirectSumOfQPAModules([S1,S1,S2]);
S1S2S2 := DirectSumOfQPAModules([S1,S2,S2]);
S2S2S2 := DirectSumOfQPAModules([S2,S2,S2]);
S1S1S2S2 := DirectSumOfQPAModules([S1,S1,S2,S2]);
S1S12 := DirectSumOfQPAModules([S1,S12]);
S2S12 := DirectSumOfQPAModules([S2,S12]);
S1S21 := DirectSumOfQPAModules([S1,S21]);
S2S21 := DirectSumOfQPAModules([S2,S21]);
S2S3 := DirectSumOfQPAModules([S2,S3]);
S12S3 := DirectSumOfQPAModules([S12,S3]);
S1I2 := DirectSumOfQPAModules([S1,I2]);
S1S212 := DirectSumOfQPAModules([S1,S212]);
S1S2S12 := DirectSumOfQPAModules([S1,S2,S12]);
S1S2S21 := DirectSumOfQPAModules([S1,S2,S21]);
S12S21 := DirectSumOfQPAModules([S12,S21]);
S1S3 := DirectSumOfQPAModules([S1,S3]);
S1S23 := DirectSumOfQPAModules([S1,S23]);
S123 := P1;
S2123 := I3;
S21323 := P2;
