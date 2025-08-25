# Rules

- CONSOLIDATE as much code as possible. No duplication
- Don't stop until there are NO lint errors, tests pass, and coverage is 100%
- NO dynamic types! Never access dynamic properties. Use generic type parameters instead of dynamic values
- NO late variables. If you can't instantiate the variable as final, make it nullable!
- Top level functions over methods. Move as many methods as possible into shared functions
- Share as much code as possible in a single location, especially shared functions
- Use typedef Records where possible. No classes if you can avoid them
