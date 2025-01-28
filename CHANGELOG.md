# Changelog

<!--[//]: # (
## <Release number> <Date YYYY-MM-DD>
### Breaking changes
### Deprecations
### New features
### Bug fixes
)-->

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
