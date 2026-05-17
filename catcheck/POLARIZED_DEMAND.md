# Polarized Demand Analysis

## Problem

The current backward analysis computes an output-contribution demand. A child
receives demand for the part of its forward value that can flow into the value
of its parent expression.

That is useful for explaining output contribution, but it is not the same as
semantic reachability or satisfiability. Some expressions affect their parent
without contributing values to the parent output.

The clearest case is set or relation difference:

```cat
A \ B
```

Values from `B` never flow into the output of `A \ B`. They affect the result
negatively, by removing values that would otherwise come from `A`. Therefore an
ordinary output-demand value for `B` can be empty even when `B` is meaningful and
non-empty.

## Examples

For:

```cat
EXC-ENTRY \ SVC
```

the current output-demand analysis can infer empty demand for `SVC`, because no
`SVC` element appears in the output of the difference. This should not produce:

```text
this set expression is always empty in its context
```

`SVC` is not semantically empty. It is relevant as a subtractor. A polarized
demand analysis would record `SVC` as negatively relevant.

For:

```cat
Exp \ SVC
```

if `Exp` and `SVC` are disjoint, the RHS subtracts nothing from the LHS. A future
diagnostic could say:

```text
this subtraction removes nothing in this context
```

That is a different statement from saying that `SVC` itself is empty.

For:

```cat
Exp & FAULT
```

if `Exp` and `FAULT` are disjoint, the whole intersection is genuinely empty in
positive context. This should keep the current style of diagnostic:

```text
this set expression is always empty in its context
```

## Demand Shape

A future analysis can represent demand with polarity:

```ocaml
type demand = {
  positive : D.t;
  negative : D.t;
}
```

`positive` means values that may contribute to the enclosing output.

`negative` means values whose presence may affect the enclosing output by
excluding, removing, or complementing values.

The analysis would still use the existing forward value of each expression. The
combined relevance checks would become:

```text
positive_relevance = fw(expr) meet demand.positive
negative_relevance = fw(expr) meet demand.negative
```

## Transfer Sketch

The exact implementation should live next to the current backward transfer
logic, but it should not be treated as a drop-in replacement unless all
diagnostics are updated to understand polarity.

For set-like expressions, the intended shape is:

```text
Union / Try / If:
  child.positive += parent.positive
  child.negative += parent.negative

Inter:
  left.positive  += parent.positive meet fw(right)
  right.positive += parent.positive meet fw(left)
  left.negative  += parent.negative
  right.negative += parent.negative

Diff: A \ B
  A.positive += parent.positive
  B.negative += parent.positive meet fw(A)

Comp: ~A
  A.negative += parent.positive
```

The negative-parent cases need careful treatment before implementation. For
example, a subtraction inside an already negative context may flip or combine
polarity depending on the diagnostic question. The first implementation should
therefore be conservative and test-driven.

Relation operators need the same treatment, but with relation-specific transfer
functions. `Seq`, `Cartesian`, and `ToId` should be specified with examples
before being implemented.

## Reporting Model

`top.ml` should eventually report based on polarity-aware categories:

- Positive empty expression: `fw(expr) meet demand.positive = empty`.
- Negative no-op subtraction or complement: the negative relevance of the
  subtractor or complemented expression is empty.
- No diagnostic: an expression is non-empty and negatively relevant, even if its
  positive contribution demand is empty.

Under that model:

```cat
EXC-ENTRY \ SVC
```

would not report `SVC` as empty, because `SVC` is negatively relevant.

```cat
Exp \ SVC
```

could report that the subtraction removes nothing if `Exp meet SVC = empty`.

```cat
Exp & FAULT
```

would still report the intersection as empty when the positive relevance is
empty.

## Current Compromise

Until polarized demand exists, the empty-expression diagnostic suppresses
expressions under known negative contexts:

- RHS of `Diff`
- operand of `Comp`

This avoids the misleading `SVC` diagnostic without changing the existing
forward or backward analysis.
