# Overall

1. Assign weight to each in-lasso and cross-lasso edge that already exists.
2. Add extra co edges (e.g. +1 self-edges on each write and others following po)
3. Add cross-iteration po edges (incl. transitive ones)
4. Compute derived relations

# Weights

- Edges from the lasso to outside should have strictly negative weight
- Edges from outside to the lasso should have strictly positive weight
- Edges fully within the lasso can have any weight

# Calculating weight of derived relations

- Sequencing two weighted relations adds their weights.
- If several paths derive the same edge, their possible weights are unioned.
- Transitive closure repeats this process to a fixed point, using widening when
  weights become unbounded.
- After closing `co`, cross-lasso edges are intersected with the required sign
  constraints again.

# Step-by-step algorithm

## Step 1: generate concrete (and finite) executions

- Invoke herd7 to generate all consistent (and finite) executions for the input litmus test
- Use `-variant cutoff` to prompt herd7 to insert cutoff events
- Filter executions that include a cutoff event and discard the others

## Step 2: calculate the instructions that constitute the loop

For each of the selected executions, determine the _static_ program order
indices of the first and last instruction of the loop.

This is done as follows:

- Find the cutoff event
- Take the event's static po index as the _start_ of the loop
- Find a branch event that precedes the cutoff event according to "runtime" po.
  In other words, since the last branch event that precedes the cutoff in program
  order.
- Use the static po index of the selected branch event as the _end_ of the loop

The algorithm rejects executions that feature more than one cutoff event.
Moreover, it also rejects executions which contain more than one branch event
in the same processor as the cutoff event. This is a conservative measure to
the sake of simplifying loop detection for now, and can be relaxed at a later stage.

## Step 3: determine the loop iterations included in the graph

Given an execution for which we could successfully detect the static po bounds
of the loop, we then want to detect which events in the execution graph
constitute different runtime iterations of the loop. A typical herd7 graph
obtained with `-unroll 1` or `-unroll 2` should contain 2 to 4 iterations in
the same graph, before cutoff is reached.

This is done as follows:

- Keep only events from the cutoff processor whose static po index lies between
  the loop start and end, inclusive.
- Sort those events by runtime po index.
- Split the sorted list after each branch event. The branch event is included as
  the last event of the iteration.

As this construction uses branch events as delimiters between iteration, we are
relying on the assumption described above that there is only one branch per
loop.

## Step 4: check lasso candidate

This step checks whether the last iteration of the loop, among all iterations
detected in the previous step, is a good candidate for a repeating lasso.

This is done as follows:

- Check that the lasso candidate and the iteration before it have _identical_
  events. This means: events with same type and values, appearing in same program
  order.
- Check that there are no cross-iteration rf-reg edges. This is a temporary
  measure to simplify things; I don't have a solid justification for why we
  should rule out those lassos.

If the lasso candidate passes these checks, it is considered viable for the
following consistency and fairness checks. Otherwise, the candidate lasso's
whole execution is discarded.

For now the lasso-finding logic is quite simple. In later iterations we can
consider making this algorithm smarter, for example by trying to construct a
lasso out of multiple loop iterations.

## Step 5: add extra edges induces by the lasso

Once we have found a proper lasso (i.e. a loop iteration that we believe can be
repeated indefinitely), we need to enrich the execution graph with additional
edges. That is because each even within the lasso is not really a single event,
but rather a finite representation of an _infinite_ sequence of events, one per
iteration.

This is better explained with a visual example:

TODO: idea: if the lasso contains ev1, ev2, ev3, then in actuality each evn represents infinite events evn_i, for each iteration i \in {1,...}.

Concretely, we add the following extra edges:

- po edges

  - each po edge from the (last) branch event of the penultimate iteration to any event inside the lasso is turned into a po edge with weight [1, +inf)
  - one po edge with +1 weight is added from the (last) branch event of the lasso to each of its own events, whenever one such edge exists between the previous iteration and the lasso
  - transitive closure

- co edges

  - we first assign weights to existing co edges: TODO
  - we then add co edges with +1 weight from each lasso write to each other lasso write (incl. self edges)
  - transitively close
  - adjust cross-lasso edges, so that lasso-to-external edges have strictly negative weight, and external-to-lasso edges have strictly positive weights.
    - concrete example demonstrating why this is needed: TODO

- rf edges

  - This is in order to ensure that every read event in the lasso (of which there could be infinitely many) has an assigned write event that its reading from.
  - Currently the logic is very simple: for every already-existing rf edge:
    - if it goes from the outside to the lasso: assign weight [1, +inf)
    - if it goes from the lasso to the outside: assign weight -1. This signifies that the outside load reads just once from the store in the first loop iteration.
    - if it goes from the lasso to the lasso: assign weight 0
  - This could be even smarter: if the rf edge is from the previous iteration's event E1 into the lasso's event E2, this could also become a 1 weight rf edge from the lasso's E1 equivalent (say, E1') to E2.

- to every other existing edge, we just assign 0 weight to them

One may ask: ok but why do you choose to set an existing rf edge to, say, [1,
+inf)? We says it's correct? And why not two edges, one with weight 1 and one
with weight [2, +inf)?

Answer: TODO, but in short, we are not claiming to exhaustively enumerate all
possible combinations, because the lasso represents an infinite sequence of
events, so it wouldn't be possible to do so anyway. Our edge/weight assignment
only represents a few of several plausible assignments, selected among others
based on heuristics. How do we know the assignment is correct? Well, we don't,
just how in the finitary case we don't know if a particular configuration of rf
edges makes sense (in terms of the memory model). That is what the following
consistency check is meant to establish.

## Step 6: compute weights of remaining builtin relations

The previous steps take care of computing weighted edges for the following "primitive" relations:

- `po`
- `iico_*`
- `rf`
- `co`

However, there are other builtin symbols, for sets and relations, that are
needed to evaluate a cat model. The next step therefore is to compute weighted
variants for all the other relations, such as `loc`, `id`, `int`, `ext`, etc.

This is essentially what is done in `machModelChecker.ml`.

The weight to use for these relations depends on the nature of the relation itself.
For example:

- `id` should have weight 0, because non-0 weight necessarily implies the two endpoints are not the same;
- `int` and `ext` should have weight Z, because being from the same/different process is a property that holds the same regardless of how many loop iterations have taken place;
- `loc` should also have weight Z: if two events have same location, then this will be true for any copy of those events across different loop iterations;

## Step 7: compute weights of "derived" relations

Derived relations are any relations that are not builtin. For instance, `ob`,
but also `rf^-1`.

Derived relations are constructed by composing smaller relations via the
relational algebra operators of the cat language (union, intersection,
sequence, etc.).
Thus, to determine which weight to assign to a composite relation, we need to
define a corresponding relational algebra on the domain of weights.
Once that's done, we can just evaluate as follows:

```
W(r U r') = W(r) Uw W(r')
W(r ; r') = W(r) ;w W(r')
...
```
