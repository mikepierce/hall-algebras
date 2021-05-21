################################################################################
### hall.g
### For computing the Hall algebra of a quiver algebra generated by QPA


Read("misc.g");
Read("constants/D4-folded.g");
#Read("constants/D4-folded-alt.g");
#Read("constants/A4.g");

FLAG_DEBUG := false; # set to true to print basic debugging information
DEBUGGER := function(s) if FLAG_DEBUG then Print(s,"\n"); fi; end;


## Returns the k-span generated by the set B as a list,
## where k := LeftActingDomain(B[1]).
## Warning: k needs to be finite.
SpanOverSet := function(B,k)
local scalars, span;
    # Is B empty?
    if Length(Compacted(B))=0 then 
        return [];
    fi;

    # Is B infinite?
    if Size(Compacted(B))=infinity then 
        Error("the basis needs to be a finite set,");
    fi;

    scalars := Tuples(k, Length(B));
    span := List(scalars, pair -> [B,pair]);
    Apply(span, TransposedMatOp);
    Apply(span, map -> Sum(List(map, Product)));
    return span;
end;


## Returns true if M and N are isomorphic, and false otherwise.
## The function IsomorphicModules does the same things it appears.
AreIsomorphicPathAlgebraModules := function(M,N)
    return IsPathAlgebraMatModuleHomomorphism(IsomorphismOfModules(M,N));
end;


## Given a kQ-module M, returns Q.
QuiverOfPathAlgebraModule := function(M)
    return QuiverOfPathAlgebra(RightActingAlgebra(M)); 
end;


## Given a kQ-module M, returns k.
FieldOfPathAlgebraModule := function(M)
    return LeftActingDomain(RightActingAlgebra(M)); 
end;


## Returns dim_k Hom(M,N)
## Not to be confused with the capitalized DimHom function
dimHom := function(M,N) 
    return Length(HomOverAlgebra(M,N)); 
end;


## Returns dim_k Ext(M,N)
dimExt := function(M,N) 
    return Length(ExtOverAlgebra(M,N)[2]); 
end;

## Returns the list ... TODO
ModulesWithDimVect := function(Ms, v)
    return Filtered(Ms, M -> (v= DimensionVector(M)));
end;


## Returns |Aut(M)| by building all endomorphisms and counting the isomorphisms.
## TODO: Is there something cleverer to do here than build ALL endomorphisms?
NumberOfAut := function(M) 
local k; 

    ## Is M a kQ-module?
    if not IsPathAlgebraMatModule(M) then
        Error("the argument needs to be a path-algebra module,");
    fi;

    k := FieldOfPathAlgebraModule(M);

    ## Is k a finite field?
    if Size(k) = infinity then 
        return infinity;
    fi;

    return Length(Filtered(SpanOverSet(HomOverAlgebra(M,M), k), IsIsomorphism));
end;


## Take two quiver modules and return a list 
## of all extensions of them, distinct up to isomorphism.
## TODO: I'll bet it isn't necessary to build the entire space Ext^1(M,N)
##       and then delete duplicates up to isomorphism, right?
DistinctExtensions := function(M, N)
local ext, basis, scalars, space;

    if Size(FieldOfPathAlgebraModule(M)) = infinity then
        Error("DistinctExtensions() only works over finite fields for now.");
    fi;

    ## Get a basis for Ext(M,N) in terms of pullback maps 
    ## (see the QPA documentation)
    ext := ExtOverAlgebra(M,N);
    basis := ext[2];

    ## If there are no non-trivial extensions, then we're done here
    if basis = [ ] then return [DirectSumOfQPAModules([M,N])]; fi;

    ## Build all linear combinations of those basis elements over the base field
    scalars := Tuples(FieldOfPathAlgebraModule(M), Length(basis));
    space := List(scalars, pair -> [basis,pair]);
    Apply(space, TransposedMatOp);
    Apply(space, map -> Sum(List(map, Product)));

    ## Convert these linear combinations of maps to literal objects in Ext^1(M,N)
    Apply(space, map -> PushOut(ext[1], map));
    Apply(space, pushout -> Range(pushout[1]));

    ## Return the space of extension objects unique up to isomorphism
    return UniqueByFunction(space, IsomorphismOfModules);
end;

## Take a list of quiver modules and return a list 
## of all extensions of them, distinct up to isomorphism.
## That is, given quiver modules [M, N, O]
## this reurns a list of all quiver modules that are result of extending
## M by N, and then extending each of those resulting extensions by O ...
## or extending M by the extensions of N by O, 
## because the operation is associative.
DistinctMultiExtensions := function(Ms)
local modules, ext, head;

    if not Ms=Flat(Ms) then 
        Error("DistinctMultiExtensions() takes a FLAT list of PathAlgebraModules.");
    fi;

    if not ForAll(Ms, IsPathAlgebraModule) then
        Error("DistinctMultiExtensions() takes a flat list of PATHALGEBRAMODULES.");
    fi;

    if Length(Ms) = 0 then return []; fi;

    modules = Ms;
    ext := [modules[1]];
    Remove(modules, 1);
    ## ext is the working list of extensions,
    ## and we're going to iteratively pop off the next module,
    ## build all the new extensions, flatten and delete duplicates, 
    ## then update ext, until there are no more modules left.
    while not IsEmpty(modules) do
        head = modules[1];
        Apply(ext, x->DistinctExtensions(x, head));
        ext := UniqueByFunction(Flat(ext), IsomorphismOfModules);
        Remove(modules, 1);
    od;
    
    return ext;
end;


## Given a path algebra module M defined over the rationals
## (BUT WITH INTEGRAL MATRIX ENTRIES!!!),
## "cast" module to be over a finite field k. 
## For example, take all the matrix entries n and send them to n*One(k).
## TODO: Acknowledge that this doesn't make me happy, and doesn't make sense.
##       But since I'm only feeding this function modules 
##       with matrix entries 0 or 1, I will ignore this strangeness.
PathAlgebraModuleFiniteFieldCast := function(M, k)
local A, B, matrices;
    A := RightActingAlgebra(M);
    B := PathAlgebra(k, QuiverOfPathAlgebra(A));
    matrices := List(MatricesOfPathAlgebraModule(M), L->List(L, n->n*One(k)));
    return RightModuleOverPathAlgebra(B, matrices);
end; 


## Returns the number of short exact sequences N → Y → M
## TODO This could be made much faster by making a list 
##      of the commutativity relations that must hold
##      and building the morphisms from the ground up.
NumberOfSES := function(M,N,Y)
local k, morphismsNY, morphismsYM, sequences;

    k := FieldOfPathAlgebraModule(M);

    if Size(k) = infinity then
        Error("NumberOfSES() only works over finite fields,");
    fi;

    morphismsNY := SpanOverSet(HomOverAlgebra(N,Y), k);
    morphismsNY := Filtered(morphismsNY, IsInjective);
    morphismsNY := Filtered(morphismsNY, f -> AreIsomorphicPathAlgebraModules(CoKernel(f),M));

    morphismsYM := SpanOverSet(HomOverAlgebra(Y,M), k);
    morphismsYM := Filtered(morphismsYM, IsSurjective);
    morphismsYM := Filtered(morphismsYM, f -> AreIsomorphicPathAlgebraModules(Kernel(f),N));

    sequences := Cartesian(morphismsNY, morphismsYM);
    sequences := Filtered(sequences, seq -> seq[1]*seq[2] = ZeroMapping(N,M));

    return Length(sequences);
end;


## Compute the Hall number associated to the short exact sequence N → Y → M
## WARNING: Only works over a finite field!
HallNumber := function(M,N,Y)

    # Are the modules over the same algebra?
    if RightActingAlgebra(Y) <> RightActingAlgebra(N) then
        Error("the entered modules are not over the same algebra,");
    fi;

    # Are the modules over a finite base field?
    if Size(FieldOfPathAlgebraModule(M))=infinity  then
        Error("HallNumber() only works with PathAlgebraModules over a finite field,");
    fi;

    # Are the modules over the same finite base field?
    if FieldOfPathAlgebraModule(M) <> FieldOfPathAlgebraModule(Y) or 
    FieldOfPathAlgebraModule(Y) <> FieldOfPathAlgebraModule(N) then
        Error("the input modules need to be over the same finite field,");
    fi;

    return NumberOfSES(M,N,Y)/(NumberOfAut(M)*NumberOfAut(N));
end;


#n:=7;
#Powers := function(x,n)
#    return List([0..n], p -> x^p);
#end;
#M := S2132;
#N := DirectSumOfQPAModules([S1,S2]);
#Y := M;
##S12S3 := DirectSumOfQPAModules([S12,S3]);
#primes := Primes{[1..n+1]};
#primeFields := List(primes, p -> GF(p));
#primePowerMatrix := List(primes, p -> Powers(p, n));
#primePathAlgebraModules := List(primeFields, k -> rec(
#    M := PathAlgebraModuleFiniteFieldCast(M,k),
#    N := PathAlgebraModuleFiniteFieldCast(N,k),
#    Y := PathAlgebraModuleFiniteFieldCast(Y,k)
#));

## Compute the Hall polynomial f in k[q] 
## associated to the extension Y of kQ modules M by N.
## TODO: Instead of using the first n+1 primes, use powers of primes
##       to make the computation easier.
## TODO: Is the +1 marked XXX really necessary?
HallPolynomial := function(M,N,Y)
local Powers, A, R, q, n, primes, primeFields, primePowerMatrix, primePathAlgebraModules, hallNumbers, hallPolynomialCoefficients;

    DEBUGGER("Inside HallPolynomial");

    ## Make sure that M and N are over the rationals here
    if FieldOfPathAlgebraModule(M)<>Rationals 
    or FieldOfPathAlgebraModule(N)<>Rationals
    or FieldOfPathAlgebraModule(Y)<>Rationals then
        Error("The arguments need to be path algebra modules over the rationals, ");
    fi;

    ## Return [x^0, ..., x^n]
    Powers := function(x,n)
        return List([0..n], p -> x^p);
    end;

    A := RightActingAlgebra(M);
    R := PolynomialRing(Rationals, ["q"]);
    q := Indeterminate(Rationals, "q");
    n := dimExt(M,N) +1; ## XXX
    
    primes := Primes{[1..n+1]};
    primeFields := List(primes, p -> GF(p)); 
    primePowerMatrix := List(primes, p -> Powers(p, n));
    #primePathAlgebras := List(primeFields, k -> PathAlgebra(k,Q));
    primePathAlgebraModules := List(primeFields, k -> rec(
        M := PathAlgebraModuleFiniteFieldCast(M,k),
        N := PathAlgebraModuleFiniteFieldCast(N,k),
        Y := PathAlgebraModuleFiniteFieldCast(Y,k)
    ));
    #Ms := List(primeFields, k -> PathAlgebraModuleFiniteFieldCast(M,k));
    #Ns := List(primeFields, k -> PathAlgebraModuleFiniteFieldCast(M,k));
    #Ys := List(primeFields, k -> PathAlgebraModuleFiniteFieldCast(M,k));
    hallNumbers := List[primePathAlgebraModules, r -> HallNumber(r.M, r.N, r.Y)];
    hallPolynomialCoefficients := SolutionMat(primePowerMatrix, hallNumbers);

    return hallPolynomialCoefficients*Powers(q, n);
end;


## Takes two kQ modules and returns a list of all pairs (f,Y)
## where Y is an extension of the modules
## and f is the polynomial in k[q] that is its coefficient.
HallProduct := function(M,N)

    if RightActingAlgebra(M) <> RightActingAlgebra(N) then
        Error("the entered modules are not over the same algebra,");
    fi;

    return List(DistinctExtensions(M,N), ext -> [HallPolynomial(M,N,ext), ext]);
end;


## TODO
HallCoproduct := function(M)
    return;
end;


################################################################################
### NOTES ABOUT QPA

### AllSubmodulesOfModule(M) on 89 doesn't work
### AllIndecModulesOfLengthAtMost(A,n) on 89
### What is AllModulesOfLengthPlusOne???
### SaveAlgebra() doesn't work.
### IsPathAlgebraModule() has no meaning???
###   generally it looks like there are a tonne of functions that 
###   have keywords but are not actually defined.

### In a brk> loop
###   ShowArguments() prints the arguments of the No Method Found causing function
###   ShowArgument(n) prints the nth such arguments 
###   also try ShowDetails() ShowMethods(n=2 verbosity)


