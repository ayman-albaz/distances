# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]


## [0.2.0] - 2024-05-24

### Breaking Changes
- **Module restructure**: `distances/seq` removed; all exports now live in `distances`. Update imports from `import distances/seq` to `import distances`.
- **Cosine distance**: Now returns `NaN` when either vector has zero magnitude (previously returned `0.0`).

### Added
- Edge-case handling: empty arrays, negative values in KL divergence, zero-magnitude cosine inputs.
- Expanded test coverage: empty inputs, single-element arrays, symmetry, negative values.

### Removed
- `src/distances/seq.nim` and `src/distances/` subdirectory.
- Arrymancer and neo implementations
- Hard coded functions


## [0.1.1] - 2021-06-09
### Added
- Main nim file


## [0.1.0] - 2021-06-09
### Added
- Created distances library
