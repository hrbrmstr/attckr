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

jsonlite::fromJSON(
  here::here("data-raw/mobile-attack.json.xz")
) -> mobile_attack

mobile_attack[["objects"]] <- tibble::as_tibble(mobile_attack[["objects"]])

jsonlite::fromJSON(
  here::here("data-raw/pre-attack.json.xz")
) -> pre_attack

pre_attack[["objects"]] <- tibble::as_tibble(pre_attack[["objects"]])

bind_rows(
  map_df(1:nrow(enterprise_attack$objects), ~{
    if (is.na(enterprise_attack$objects$name[[.x]])) return(NULL)
    if (is.null(enterprise_attack$objects$kill_chain_phases[[.x]])) return(NULL)
    tibble(
      technique = enterprise_attack$objects$name[[.x]],
      description = enterprise_attack$objects$description[.x],
      id = discard(enterprise_attack$objects$external_references[[.x]]$external_id, is.na) %||% NA_character_,
      phs = enterprise_attack$objects$kill_chain_phases[.x]
    ) %>%
      unnest()
  }),
  map_df(1:nrow(mobile_attack$objects), ~{
    if (is.na(mobile_attack$objects$name[[.x]])) return(NULL)
    if (is.null(mobile_attack$objects$kill_chain_phases[[.x]])) return(NULL)
    tibble(
      technique = mobile_attack$objects$name[[.x]],
      description = mobile_attack$objects$description[.x],
      id = discard(mobile_attack$objects$external_references[[.x]]$external_id, is.na) %||% NA_character_,
      phs = mobile_attack$objects$kill_chain_phases[.x]
    ) %>%
      unnest()
  }),
  map_df(1:nrow(pre_attack$objects), ~{
    if (is.na(pre_attack$objects$name[[.x]])) return(NULL)
    if (is.null(pre_attack$objects$kill_chain_phases[[.x]])) return(NULL)
    tibble(
      technique = pre_attack$objects$name[[.x]],
      description = pre_attack$objects$description[.x],
      id = discard(pre_attack$objects$external_references[[.x]]$external_id, is.na) %||% NA_character_,
      phs = pre_attack$objects$kill_chain_phases[.x]
    ) %>%
      unnest()
  })
) %>%
  rename(tactic = phase_name, matrix = kill_chain_name) %>%
  distinct() -> tidy_attack

usethis::use_data(
  enterprise_attack, mobile_attack, pre_attack, tidy_attack,
  internal = FALSE,
  overwrite = TRUE,
  compress = "xz"
)

bind_rows(enterprise_attack$objects$kill_chain_phases) %>%
  distinct(phase_name)


















