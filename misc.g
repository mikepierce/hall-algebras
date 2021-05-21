################################################################################
### misc.g
### Some miscellaneous helper functions that don't depend on QPA


### Add element item to list if it is distinct from everything in list
AddDistinct := function(list, item)
    if not(item in list) then 
        Add(list,item);
    fi;
end;


### Append elements of new to list that are distinct from elements of list
AppendDistinct := function(list, new)
local i;
    for i in new do
        AddDistinct(list,i);
    od;
end;


### A generalization of the function Unique()
UniqueByFunction:=function ( list,fun )
local l,i;
    l:= [];
        for i in list do
    if ForAll(l,x->fun(x,i)=false) then
        Add(l,i);
    fi;
    od;
    return l;
end;


### Returns every possible n×m matrix over a finite set k
EveryMatrix := function(k,n,m)

    if Size(k)=infinity then
        Error("the first argument needs to be a finite set,");
    fi;

    if (n=0 or m=0) then 
        return []; 
    fi;

    if not (IsPosInt(n) and IsPosInt(m)) then
        Error("the latter two arguments need to be non-negative integers,");
    fi;

    return Tuples(Tuples(k,m),n);
end;


