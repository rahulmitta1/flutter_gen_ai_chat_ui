# Flutter Package Release Checklist

Use this checklist before every package release to ensure quality and consistency.

## Documentation
- [x] README.md is complete with:
  - Clear description of the package
  - Installation instructions
  - Basic usage examples
  - Screenshots/GIFs (if applicable)
- [x] API documentation with dartdoc comments
- [x] Example project demonstrating usage
- [x] Rename "docs" directory to "doc" (Pub convention)

## Version Management
- [x] Update version in pubspec.yaml following semantic versioning:
  - MAJOR: Breaking changes
  - MINOR: New features (backward compatible)
  - PATCH: Bug fixes (backward compatible)

## CHANGELOG
- [x] Update CHANGELOG.md with all notable changes for this version
- [x] Group changes by type (Added, Changed, Deprecated, Removed, Fixed, Security)
- [x] Include the version number and release date

## Code Quality
- [x] Run `flutter analyze` and fix all warnings/errors
- [x] Run `flutter test` to ensure all tests pass
- [ ] Check for deprecated API usage
- [x] Ensure proper code formatting with `dart format`

## Package Structure
- [x] Create `.pubignore` file to exclude unnecessary files
- [x] Fix any gitignored files that shouldn't be published
- [x] Ensure all file path references are correct
- [x] Verify package layout follows conventions

## Dependencies
- [x] Check for outdated dependencies with `flutter pub outdated`
- [x] Ensure all dependencies have appropriate version constraints
- [x] Minimize transitive dependencies when possible

## Licensing
- [x] Verify LICENSE file is present and correct
- [x] Ensure the license is mentioned in pubspec.yaml

## Platform Support
- [x] Verify platform compatibility in pubspec.yaml
- [ ] Test on all supported platforms

## Pre-publishing Checks
- [x] Run `flutter pub publish --dry-run` to check for issues
- [ ] Address any warnings or errors from the dry run
- [x] Commit all changes to source control

## Publishing
- [ ] Run `flutter pub publish` to publish the package
- [ ] Verify the package appears on pub.dev
- [ ] Test installing the published package in a sample project

## After Publishing
- [ ] Tag the release in your Git repository
- [ ] Create a GitHub release (if applicable)
- [ ] Announce the release in relevant communities

Always run through this checklist completely before publishing a new version of the package. This helps maintain quality and provides a consistent experience for users. 