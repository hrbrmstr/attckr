
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-66.7%25-lightgrey.svg)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/attckr.svg?branch=master)](https://travis-ci.org/hrbrmstr/attckr)  
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.2.0-blue.svg)
![License](https://img.shields.io/badge/License-Apache-blue.svg)

# attckr

Analyze Adversary Tactics and Techniques Using the MITRE ATT\&CK CTI
Corpus

## Description

MITRE ATT\&CK is a globally-accessible knowledge base of adversary
tactics and techniques based on real-world observations. The ATT\&CK
knowledge base is used as a foundation for the development of specific
threat models and methodologies in the private sector, in government,
and in the cybersecurity product and service community. Tools are
provided to analyze adversary tactics and techniques, build incident
metrics, and identify high level program gaps using the MITRE ATT\&CK
CTI Corpus.

## What’s Inside The Tin

The following functions are implemented:

  - `enterprise_attack`: Enterprise Attack Taxonomy
  - `fct_tactic`: Make an ordered Tactics factor with optional better
    labelling
  - `mobile_attack`: Mobile Attack Taxonomy
  - `pre_attack`: Pre-Attack Taxonomy
  - `read_events`: Read in ATT\&CK events from a file
  - `tidy_attack`: Combined ATT\&CK Matricies Tactics, Techniques and
    Technique detail
  - `validate_tactics`: Validate Tactics strings against MITRE
    authoritative source
  - `validate_technique_ids`: Validate Technique IDs
  - `validate_techniques`: Validate Techniques strings against MITRE
    authoritative source

## Installation

``` r
remotes::install_git("https://git.rud.is/hrbrmstr/attckr.git")
# or
remotes::install_git("https://git.sr.ht/~hrbrmstr/attckr")
# or
remotes::install_gitlab("hrbrmstr/attckr")
# or
remotes::install_bitbucket("hrbrmstr/attckr")
```

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.

## Usage

``` r
library(attckr)

# current version
packageVersion("attckr")
## [1] '0.1.0'
```

## attckr Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| R    |       10 | 0.91 | 168 | 0.95 |          50 | 0.77 |       72 | 0.74 |
| Rmd  |        1 | 0.09 |   8 | 0.05 |          15 | 0.23 |       25 | 0.26 |

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
