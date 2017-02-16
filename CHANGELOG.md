# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Changed
- Pass scrub directives (of [XMLScrubber](https://github.com/imacchiato/xml_scrubber)) and `log: true` to log request and response XML

### Fixed
- Logging sensitive information. Remove old way of relying on passing a logger that knew how to scrub

## [0.3.0] - 2017-02-13
### Added
- Log in the info level, the request and response XMLs if logging is enabled
- Logger logs to STDOUT by default

## [0.2.0] - 2016-03-09
### Added
- `read_timeout` and `open_timeout` to set the timeout values, in seconds, to the SOAP client

## [0.1.0] - 2016-03-01
### Added
- Initial working version
