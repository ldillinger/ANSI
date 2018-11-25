# ANSI

A small library for slightly more convenient ANSI encoded strings. Useful for shells.

Supports:
- Compiling ANSI escape sequences
- CSI Cursor codes
- SGR Color codes

## Usage

```
let sgr: SGR = .bgcolor(.black) & .color(.blue) & .style(.bold)
let hello = ANSIString(escaping: "hello", sgr: sgr)
let world = SGR.color(.red) + ", world!"
let helloWorld = hello + ", " + world
```
