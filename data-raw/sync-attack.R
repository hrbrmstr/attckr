## code to prepare `enterprise_attack` dataset goes here
library(tidyverse)

unlink(
  sprintf("%s.xz", here::here(
    "data-raw",
    c(
      "enterprise-attack.json",
      "mobile-attack.json",
      "pre-attack.json"
    )
  ))
)

download.file(
  url = c(
    "https://github.com/mitre/cti/raw/master/enterprise-attack/enterprise-attack.json",
    "https://github.com/mitre/cti/raw/master/mobile-attack/mobile-attack.json",
    "https://github.com/mitre/cti/raw/master/pre-attack/pre-attack.json"
  ),
  destfile = c(
    here::here(
      "data-raw",
      c(
        "enterprise-attack.json",
        "mobile-attack.json",
        "pre-attack.json"
      )
    )
  ),
  method = "libcurl"
)

walk(
  here::here(
    "data-raw",
    c(
      "enterprise-attack.json",
      "mobile-attack.json",
      "pre-attack.json"
    )
  ),
  ~system2("xz", args = .x)
)

jsonlite::fromJSON(
  here::here("data-raw/enterprise-attack.json.xz")
) -> enterprise_attack

enterprise_attack[["objects"]] <- tibble::as_tibble(enterprise_attack[["objects"]])

usethis::use_data(enterprise_attack, overwrite = TRUE, compress = "xz")

jsonlite::fromJSON(
  here::here("data-raw/mobile-attack.json.xz")
) -> mobile_attack

mobile_attack[["objects"]] <- tibble::as_tibble(mobile_attack[["objects"]])

usethis::use_data(mobile_attack, overwrite = TRUE, compress = "xz")

jsonlite::fromJSON(
  here::here("data-raw/pre-attack.json.xz")
) -> pre_attack

pre_attack[["objects"]] <- tibble::as_tibble(pre_attack[["objects"]])

usethis::use_data(pre_attack, overwrite = TRUE, compress = "xz")

bind_rows(
  tibble(
    technique = enterprise_attack$objects$name,
    description = enterprise_attack$objects$x_mitre_detection,
    tactic = enterprise_attack$objects$kill_chain_phases
  ) %>%
    filter(lengths(tactic) > 0) %>%
    unnest(),
  tibble(
    technique = mobile_attack$objects$name,
    description = mobile_attack$objects$x_mitre_detection,
    tactic = mobile_attack$objects$kill_chain_phases
  ) %>%
    filter(lengths(tactic) > 0) %>%
    unnest(),
  tibble(
    technique = pre_attack$objects$name,
    description = pre_attack$objects$description,
    tactic = pre_attack$objects$kill_chain_phases
  ) %>%
    filter(lengths(tactic) > 0) %>%
    unnest()
) -> tidy_attack

usethis::use_data(tidy_attack, overwrite = TRUE, compress = "xz")
