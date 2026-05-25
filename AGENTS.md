# Agent Instructions for Digia's Neovim Configuration

Agent entry point. Read and understand this file first. _CLAUDE.md is a symlink to AGENTS.md._

## MANDATORY Agent Operating Rules

These rules apply to every task in this project unless explicitly overridden.

**Bias:** Caution over speed on non-trivial work.

### Rule 1. Think before coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask rather than guess.
- If multiple interpretations exist, present them -- don't pick silently
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

**Surface conflicts, don't average them:** If two patterns contradict, pick one (most recent / more tested). Explain why. Flag the other for cleanup.

**Read before you write:** Before adding code, read exports, immediate callers, shared utilities. If unsure why existing code is structured a certain way, ask.

### Rule 2. Simplicity first

**Minimum code that solves the problem. Nothing speculative. DO NOT over engineer.**

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "configurability" that wasn't requested
- No error handling for impossible scenarios
- If you write 200 lines and it could be 50, rewrite it

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify. If unsure, consult an expert matter subagent.

### Rule 3. Surgical changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it -- don't delete it

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked

The test: Every changed line should trace directly to the user's request.

### Rule 4. Goal-driven execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" -> "Write tests for invalid inputs, then make them pass"
- "Fix the bug" -> "Write a test that reproduces it, then make it pass"
- "Refactor X" -> "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

### Rule 5. Tests verify intent not just behavior

Tests must encode WHY behavior matters, not just WHAT it does.

A test that can't fail when business logic changes is wrong.

### Rule 6. Checkpoint after every significant step

Summarize what was done, what's verified, what's left.

Don't continue from a state you can't describe back.

**Token budgets are not advisory.** per-task: 4,000 tokens. Per-session: 30,000 tokens. If approaching budget, summarize and start fresh. Surface the breach. Do not silently overrun.

### Rule 7. Match the codebase's conventions, even if you disagree

Conformance > taste inside the codebase.

If you think a convention is harmful, surface it. Don't fork silently.

### Rule 8. Fail loud

"Completed" is wrong if anything was skipped silently.

"Tests pass" is wrong if any were skipped.

Default to surfacing uncertainty, not hiding it.

---

Now load `./README.md` for project orientation.

---

@./README.md
