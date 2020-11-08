# Hall Algebras in GAP 

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A GAP package that contains functions 
related to finding the forbidden minors of a given graph property.
In particular, this package has functions relating to the properties
of a graph being [apex][APEX], edge-apex, or contraction-apex.
Additionally in the *brute-force-search* directory
is a Mathematica notebook containing the details how to perform 
a brute-force search for certain classes of minor-minimal graphs.
This package was used to arrive at the results in these papers:


# Important Functions

 -  `NonApexGraphQ[g]` takes a graph *g*
    and yields True if *g* is non-apex and False otherwise.
   
    There are also functions `NonEdgeApexGraphQ[g]` 
    and `NonContractionApexGraphQ[g]` defined similarly.

 -  `MMGraphQ[P,g]` takes a graph property *P* 
    such that *&not;P* is closed under taking minors
    and a graph *g* and returns True if *g* is minor-minimal
    with respect to *P* and False otherwise.
    This function is defined pretty simply as 
   
    ```Mathematica
      MMGraphQ[P,g] := Return[P[g] && !MemberQ[P /@ SimpleMinors[g], True]];
    ```

    There are three specific implementations of this function.
    Firstly there is `MMNAGraphQ[g]` which is simply defined
    as `MMGraphQ[NonApexGraphQ,g]`.
    There are also functions `MMNEGraphQ[g]` and `MMNCGraphQ[g]`, 
	but these have to defined differently because neither of the properties
    edge-apex or contraction-apex are closed under taking minors.

 -  `SimpleMinors[g]` takes a graph *g* and returns
    a list of the simple minors of *g*. 
    Specifically it returns a list of all distinct graphs 
    that are the result of either deleting an edge, 
    contracting an edge, or deleting a degree-*0* vertex in *g*.  
    
    `SimpleMinors[g,n]` returns the distinct minors with a minimum
    vertex degree of *n*.

# Supplementary Functions

 -  `EdgeContract[g,e]` contracts the edge *e* in the graph *g*.
    Note that this function is built into Mathematica 10.

 -  `DeleteGraphDuplicates[{g1, ..., gn}]` removes duplicate graphs 
    (up to isomorphism) from the list
    *{g<sub>1</sub>, &#8230;, g<sub>n</sub>}*.

 -  `GraphSimplify[g]` simplifies the graph *g* so that the result
    will have no degree-*0*, -*1*, or -*2* vertices.
    
    `GraphSimplify[]` will print an outline 
	of the graph simplification algorithm.

 -  `GraphColor[g]` displays the graph *g* with edges and vertices colored
	according to their equivalence. In particular, the edges 
	*e<sub>1</sub>* and *e<sub>2</sub>* (respectively the vertices
	*v<sub>1</sub>* and *v<sub>2</sub>*) will be colored the same if
    *g-e<sub>1</sub>* and *g-e<sub>2</sub>* (respectively 
	*g-v<sub>1</sub>* and *g-v<sub>2</sub>*) are isomorphic.

 -  `GraphModel[g]` displays the graph *g* in various different layouts
	with the edges and vertices colored with `GraphColor`.

	`GraphModel[g,n]` displays *n* different layouts of *g* like above.

