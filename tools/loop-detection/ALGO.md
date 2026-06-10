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
