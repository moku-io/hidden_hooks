# Changelog

<!--[//]: # (
## <Release number> <Date YYYY-MM-DD>
### Breaking changes
### Deprecations
### New features
### Bug fixes
)-->

## 1.3.0 2025-03-03

### New features

- Added `sole` and `present` keyword parameter for hook invocation.
- Made hook invocation return the result values.

## 1.2.0 2025-02-04

### New features

- Added the `context` keyword parameter for hooks.

## 1.1.2 2025-01-28

### Bug fixes

- Fixed Active Record integration not setting callbacks for derived classes.
- Removed `after_*_commit` shortcut hooks.
  - These aren't actually callbacks, but little more than wrappers for `after_commit` itself, so the method that gets called on the callback object is always `#after_commit`, causing some weird behaviors.

## 1.1.1 2025-01-28

### Bug fixes

- Removed `around_*` callbacks.
  - The problem with `around_*` callbacks is that the callback needs to yield to the passed block otherwise the callback chain stops, so if there aren't hooks for a certain callback no one's yielding and the chain always stops.

## 1.1.0 2025-01-28

### New features

- Added transactional callbacks to the Active Record integration.
- Added `around_*` callbacks to the Active Record integration.

## 1.0.0 2025-01-24

First release. Refer to [README.md](README.md) for the full documentation.
