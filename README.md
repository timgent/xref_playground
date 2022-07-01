# XrefPlayground

This repo is to demonstrate some challenges I've found with identifying compile-time dependencies using xref.

# Motivating Example

## Setup

In `lib/deps_test` you will find files with the following dependencies between them:

- `DepsTest` has a compile dependency on...
- `DepsTest.A` which has a runtime dependency on...
- `DepsTest.B` which has a runtime dependency on...
- `DepsTest.C` which has a runtime dependency on...
- `DepsTest.D`

## Motivation

Imagine this is a big project, and you're finding compile times slow - whenever you change a file, you end up needing to
compile lots of other files. In this case we want to try and remove as many compile time dependencies from `DepsTest.D`
as possible.

## Identifying compile time dependencies - xref to the rescue

We can identify all the compile time dependencies on `DepsTest.D` easily:

```
➜  xref_playground git:(main) mix xref graph --sink lib/deps_test/d.ex --label compile
lib/deps_test/deps_test.ex
└── lib/deps_test/a.ex (compile)
```

We can see there is one compile time dependency here - `DepsTest`, which itself has a compile time dependency on `DepsTest.A`.
However a challenge here is that we're interested in compile time dependencies on `DepsTest.D`, and from this output alone
it's impossible to say why `DepsTest` is dependent on `DepsTest.D`.

We can see it if we get the compile and runtime dependencies and follow the relationships through, but that isn't practical
in a large project where the graph can be massive.

```
➜  xref_playground git:(main) ✗ mix xref graph --sink lib/deps_test/d.ex
lib/deps_test/a.ex
└── lib/deps_test/b.ex
lib/deps_test/b.ex
└── lib/deps_test/c.ex
lib/deps_test/c.ex
└── lib/deps_test/d.ex
lib/deps_test/deps_test.ex
└── lib/deps_test/a.ex (compile)
```

## What would help?

I may be missing some context on how to use the xref tool, in which case advice for how to more easily understand and trace
back dependencies would be great.

If I'm not though, I'd like to propose that when looking at dependencies with a sink, where there are indirect dependencies
the output should include a graph showing how those indirect dependencies link back to the sink. For example:

```
➜  xref_playground git:(main) mix xref graph --sink lib/deps_test/d.ex --label compile --trace-to-sink
lib/deps_test/deps_test.ex
└── lib/deps_test/a.ex (compile)
  └── lib/deps_test/b.ex
    └── lib/deps_test/c.ex
      └── lib/deps_test/d.ex
```
