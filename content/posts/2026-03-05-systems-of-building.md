---
title: "Systems of Building, Not Building Systems"
slug: systems-of-building
published_at: '2026-03-05'
author: pixelhandler
tags:
- Workflow
- AI
- Quality
- TDD
- Developer Experience
meta_description: The craft evolved from what I build to how I build it. On containment,
  outside-in TDD, browser automation for quality assurance, and the introspective practice
  of designing a development workflow in the age of AI.
---

## Systems of Building, Not Building Systems

**On containment, focus, and the practice of examining how you work**

The tools are moving fast. Faster than any stretch I can remember — and I've been through a few cycles. Learn the new thing, adapt, keep building.

This time feels different. It's not a new framework or editor. *It's a new relationship with tools entirely.* I have an AI pair that can read my codebase, run my tests, and draft a pull request while I think through the next problem. That changes things — not just what I can build, but how I think about building.

Somewhere in the past year I noticed I was spending less time learning new libraries and more time thinking about process. How do I structure a work session? How do I make sure the code that gets generated actually holds up? How do I stay focused when the tooling makes it easy to scatter?

I think more about systems of building than building systems. There's a paradox in that. I spent years focused on designing and building systems — the software itself, the architecture, the data models. Now I find myself designing systems *of* building — the workflows, the feedback loops, the practices that shape how things get made. The craft evolved from what I build to how I build it.

## Containment Enables Quality

That phrase — *containment enables quality* — comes from how Stripe designed their coding agents. They put AI into quarantined environments with clear boundaries: one task, one branch, one set of constraints. The containment isn't a limitation. It's what makes quality possible.

I've been applying that idea to my own workflow at a personal scale, across three *dimensions*.

### Containing Conventions

Most teams have conventions. They live in a wiki, or an onboarding doc, or in the heads of senior engineers. The problem is that none of those places are where you're actually working. When you're in the middle of a commit or structuring a PR, the conventions aren't present.

I started encoding my development lifecycle — plan, implement, test, commit, PR, review — into a skill file that my AI tooling reads automatically. Not aspirational process. Honest process. How I actually work, what I actually name things, where artifacts actually go.

The effect is consistency without willpower. The conventions show up at the moment they matter — when I'm planning, when I'm committing, when I'm reviewing. They evolve as I learn. When I discover a better pattern, I update the file. It's a living record, not a frozen document.

The key insight: conventions that live where the AI can apply them are conventions that actually get followed. Everything else is aspiration.

### Containing Attention

*The second dimension is focus.* Creating room for deep work on a single problem, without context-switching contamination.

I set up isolated environments per issue — a fresh clone, unique ports, a separate database. The skill file scopes the session to *this* ticket, *this* plan, *this* branch. Everything outside that boundary disappears. It's the personal-scale version of Stripe's devbox philosophy: cattle, not pets. Spin up an environment, do the work, tear it down.

This isn't about delegating work to AI. It's about creating the conditions where you — with AI — can do focused, uninterrupted work on one thing. The isolation removes the temptation to check on other branches, fix that unrelated bug, or chase a tangent.

Creating room for focus is a deliberate engineering practice, not an accident. You have to build it.

### Containing Risk

*The third dimension is quality assurance* — making sure that what gets built actually works as intended. Not "the tests pass" quality. Visible, verifiable proof that a solution solves the problem it claims to solve.

I picked up browser automation recently, learning Playwright as a new skill. The motivation wasn't testing for testing's sake. It was a desire to tip the balance of AI-assisted development toward delivering quality solutions. When code gets generated quickly, the risk shifts from "can I build this?" to "does this actually work the way users expect?" A passing test suite isn't enough to answer that question. *You need evidence* — screenshots that show the before and after, recordings that walk through the behavior, assertions that verify specific claims about what the user sees. The goal is a body of proof that you can point to and say: this works, and here's how I know.

Outside-in test-driven development became the discipline. Start from what the user sees. Write a failing test that asserts the behavior you want. Implement until it passes. Then verify with evidence — not just green checkmarks, but proof.

Learning browser automation gave me new skills I didn't have before — screenshot comparison across branches, scripted demo recordings, and automated smoke testing. These aren't just testing techniques. They're tools for building evidence. Three layers of evidence changed how I think about quality:

**Behavioral assertions** — automated smoke tests that walk through user workflows. Does the record appear in the list? Does the form save correctly? Does the filter show the right results? Each assertion answers a specific question about the application's behavior.

**Visual screenshots** — captured against both the main branch and the feature branch, then compared side by side. You can see exactly what changed. Unintended regressions show up immediately. The visual diff is honest in a way that passing tests alone aren't.

**Demo recordings** — scripted video walkthroughs that document how the feature actually behaves. These serve as proof artifacts for PR review and stakeholder communication. When someone asks "what does this change do?" you have a recording, not just a description.

The outside-in workflow has natural checkpoints — moments where you pause, review, and confirm before moving forward. Capture the baseline. Review the failing tests. Verify they pass. Compare the screenshots. Each checkpoint is a decision point: does this look right so far?

Some lessons came the hard way. You learn by doing, and the doing reveals assumptions you didn't know you had. The testing practice forces you to understand how your application actually works, not just how you think it works.

## In Practice: Outside-In Development with AI

Here's the current iteration of my workflow — what I actually follow today:

```
Ticket
  → Plan
  → Implementation (feature branch, TDD)
  → Test Data Script
  → Manual Testing (localhost, step-by-step with URLs)
  → E2E Testing (automate manual test scenarios)
      → Assertion tests (verify expected behavior)
      → Visual comparison (screenshots: main vs feature branch)
      → Demo recording (stakeholder walkthrough video)
  → Commit (specific files, descriptive message)
  → Push + Draft PR
  → Self-Review (read findings, do not post)
  → PR Comments (annotate hard-to-understand areas)
  → Team Review → Address Feedback → Merge

Outside-In TDD variant (for UI changes):
  → Plan
  → Phase 0: E2E Test Triage (new file vs existing)
  → Phase 1: Test Data Setup
  → Phase 2: Baseline Screenshots
    ── CHECKPOINT: review baseline ──
  → Phase 3: Failing E2E Tests
    ── CHECKPOINT: review failing output ──
  → Phase 4: Implement
  → Phase 5: Verify E2E Tests Pass
    ── CHECKPOINT: review passing output ──
  → Phase 6: Screenshot Comparison
  → Phase 7: Unit/Integration Tests
  → Phase 8: Demo Recording
  → Phase 9: Update Plan Doc
  → Commit → PR → Review
```

Browser automation brought these QA practices into my AI workflow — each one solving a real problem:

| Problem | Solution |
|---------|----------|
| Manual QA is slow and unrepeatable | Automated smoke tests run the same checks every time |
| No visual regression detection | Screenshot comparison captures baseline and current states for side-by-side diff |
| Feature demos are ad hoc | Scripted demo recordings produce consistent walkthroughs |
| Bug hunting requires setup | Bug reproduction specs encode the exact steps to reproduce |
| No outside-in acceptance gate | Write a failing Playwright test before implementation, then make it pass |
| Cross-branch comparison is manual | Run dev servers on different ports per clone and compare side-by-side |

With modern tooling — where AI can generate implementation code rapidly — outside-in discipline matters even more. It's what keeps the speed honest. Without it, you're shipping fast but blind. I can point AI agents at my running application and let them drive the browser — clicking through flows, capturing screenshots, hunting for regressions. During bug hunting, I reproduce issues systematically and verify fixes visually. During feature development, I have proof artifacts before I ever open a pull request.

The iteration of writing scratchpads — markdown files where I journal the problem, sketch the approach, document what I tried, record what I learned — that iteration *is* the system. Each scratchpad becomes a reference. Each reference shapes the next session. The workflow isn't a fixed process I follow. It's a living practice that evolves every time I sit down to work. I expect it will keep evolving.

## The Practice

The tools will keep changing. The frameworks, the AI capabilities, the testing libraries — all of it will be different in a year. What compounds isn't knowledge of any specific tool. *It's the habit of examining how you work.*

I journal a lot — in notebooks, in markdown files, in plan documents that start as scratch and evolve into reference material. The skill file itself is a kind of journal. It records how I work today, and the diff over time shows how my thinking has changed.

Being comfortable with re-thinking is part of the practice. Adam Grant's *Think Again* is built around this idea — that the willingness to reconsider what you know is more valuable than the knowledge itself. A workflow that felt right three months ago might need revision. A convention you were sure about might not hold up under new constraints. That's fine.

As Brené Brown put it:

> "Yes, learning requires focus. But, unlearning and relearning requires much more — it requires choosing courage over comfort."

That resonates. The small adjustments — observing your own behavior, noticing what's working and what isn't, journaling the process — those take more courage than learning a new tool. The point isn't to arrive at a perfect system. The point is to keep examining, keep adjusting, and enjoy the journey.

Freestyle skier and physicist Eileen Gu put it better than I can:

> "I'm very introspective. I spend a lot of time in my head, and it's not a bad place to be. I journal a lot. I break down all of my thought processes. I think I apply a very analytical lens to my own thinking, and I kind of modify it because it's so interesting. You can control what you think. You can control how you think, and therefore, you can control who you are."

That's the real system of building. Not the tools, not the workflow, not the skill file — though those matter. It's the willingness to look at how you think, break it down, and modify it. The containment that matters most is the one you apply to your own thinking: scoping it, examining it, refining it.

The tools will keep evolving. Build the practice of examining how you use them, and the rest follows.
