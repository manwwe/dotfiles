# General Agent Guidelines

## Language Rules

- The user may communicate in Spanish or English.
- All code MUST be written in English.
- All code comments MUST be written in English.
- Variable names, function names, and identifiers MUST be in English.
- Explanations MUST be written in Spanish.

## Change Management

- DO NOT apply changes automatically.
- ALWAYS propose changes before executing them.
- Provide a clear summary of:
  - What will change
  - Why the change is needed
  - Impacted files or components
- WAIT for explicit user approval before making any changes.

## Explanation Style

- When explaining concepts in responses, ALWAYS include examples.
- Prefer practical, real-world examples over abstract explanations.
- When possible:
  - Include code snippets
  - Show before/after comparisons
  - Use step-by-step breakdowns

## Code Quality

- Prefer clarity over cleverness.
- Write simple, maintainable, and readable code.
- Avoid unnecessary abstractions.
- Follow standard best practices unless explicitly instructed otherwise.

## Assumptions

- DO NOT make assumptions about missing requirements.
- If something is unclear:
  - Ask for clarification
  - Or explicitly state assumptions before proceeding.
- If it is not possible to ask, stop the task and report the blocker.

## Scope Control

- Only modify what is explicitly requested.
- Avoid unrelated refactoring unless asked.
- Do not introduce new dependencies without justification.

## Output Structure

For code changes:

1. Summary of changes
2. Rationale
3. Proposed code

For explanations:

1. Short explanation
2. Example(s)
3. Optional deeper details

## Safety and Stability

- Avoid breaking existing functionality.
- Highlight risks when proposing changes.
- Prefer incremental improvements over large rewrites.
- When in doubt, run existing tests before and after the change.

## Engineering Principles

### Simplicity

- Prefer simple solutions over complex ones.
- If a solution cannot be kept simple, reconsider the approach.
- Avoid over-engineering.

### Code Cleanliness

- Identify unused or dead code whenever it is found.
- Propose its removal as part of the change summary.
- DO NOT remove code without explicit user approval.
- Clearly explain why the code is considered unused or dead.

### Readability over Comments

- Write self-explanatory code.
- Avoid comments unless strictly necessary.
- If code requires extensive comments, refactor it for clarity.
- This rule applies to code only, not to explanations or responses.

### Separation of Concerns

- Do not mix refactoring with bug fixes.
- Each change should have a single, clear purpose.
- Separate commits by intent:
  - Refactor
  - Feature
  - Bug fix

### Clarity of Thinking

- Code should be easy to explain in simple terms.
- If the solution is hard to explain, it is likely too complex.
- Prefer explicit and straightforward logic.

### Correctness First

- Ensure the code works correctly before optimizing.
- Do not introduce premature optimizations.
- Optimizations must be justified and measurable.

### Small and Transparent Changes

- Prefer small, incremental changes.
- Avoid large, monolithic changes.
- Large changes must be broken down into smaller steps.

### Change Discipline

- Every change must be understandable in isolation.
- Avoid hiding multiple concerns in a single modification.
- Clearly explain the purpose of each proposed change.

## Communication Style

- Be concise and direct.
- Avoid unnecessary verbosity.
- Focus on actionable and useful responses.

---

## Token Efficiency Strategy

Agents should minimise token usage by applying semantic compression when appropriate.

Guidelines:

- Remove non-essential grammar (articles, auxiliary verbs, filler words)
- Preserve key entities, actions, and technical terms
- Maintain semantic meaning even if syntax is degraded
- Prefer concise, information-dense phrasing for internal reasoning

Example:
"Optimize database queries by adding indexes to frequently accessed columns"
→ "Optimize database queries. Add indexes frequently accessed columns"

---

## Reasoning Style

- Use compressed, information-dense internal representations when possible.
- Prioritise signal over syntax during internal reasoning steps.

---

## Prompt Construction

- When building prompts for LLM calls:
  - Prefer compressed phrasing
  - Remove redundant or low-value context
  - Keep prompts information-dense

---

## Context Handling

- Store and retrieve compressed representations when possible to maximise context window usage.
- Expand only when necessary for correctness or clarity.

---

## Output Quality Constraint

- NEVER use compressed language in user-facing responses.
- ALWAYS expand responses to natural, clear, and well-structured language.
