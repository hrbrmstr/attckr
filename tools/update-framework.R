# code to prepare datasets and factors goes here
# You need to execute the entire file for a complete dataset pkg

library(tidyverse)
library(stringi)
library(rvest)

# Remove saved JSON -------------------------------------------------------

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

# Get new JSON ------------------------------------------------------------

ent_url <- "https://github.com/mitre/cti/raw/master/enterprise-attack/enterprise-attack.json"
mob_url <- "https://github.com/mitre/cti/raw/master/mobile-attack/mobile-attack.json"
pre_url <- "https://github.com/mitre/cti/raw/master/pre-attack/pre-attack.json"

download.file(
  url = c(ent_url, mob_url, pre_url),
  destfile = c(
    here::here(
      "data-raw",
      c("enterprise-attack.json", "mobile-attack.json", "pre-attack.json")
    )
  ),
  method = "libcurl"
)

# Compress new JSON -------------------------------------------------------

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

# Make Enterprise matrix --------------------------------------------------

jsonlite::fromJSON(
  here::here("data-raw/enterprise-attack.json.xz")
) -> enterprise_attack

enterprise_attack[["objects"]] <- tibble::as_tibble(enterprise_attack[["objects"]])

# Make Mobile matrix ------------------------------------------------------

jsonlite::fromJSON(
  here::here("data-raw/mobile-attack.json.xz")
) -> mobile_attack

mobile_attack[["objects"]] <- tibble::as_tibble(mobile_attack[["objects"]])

# Make Pre matrix ---------------------------------------------------------

jsonlite::fromJSON(
  here::here("data-raw/pre-attack.json.xz")
) -> pre_attack

pre_attack[["objects"]] <- tibble::as_tibble(pre_attack[["objects"]])

# Make tidy summary structure ---------------------------------------------

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
      unnest(phs)
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
      unnest(phs)
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
      unnest(phs)
  })
) %>%
  rename(tactic = phase_name, matrix = kill_chain_name) %>%
  distinct() -> tidy_attack

# Make ordered tactics for factoring --------------------------------------

et_tbl <- read_html("https://attack.mitre.org/tactics/enterprise/") %>% html_nodes("table")
mb_tbl <- read_html("https://attack.mitre.org/tactics/mobile/") %>% html_nodes("table")
pre_tbl <- read_html("https://attack.mitre.org/tactics/pre/") %>% html_nodes("table")

et_tbl %>%
  html_table() %>%
  .[[1]] %>%
  as_tibble() %>%
  rename(taid = ID, pretty = Name, description = Description) %>%
  mutate(
    nl = stri_replace_all_fixed(pretty, " ", "\n"),
    id = stri_trans_tolower(pretty) %>% stri_replace_all_fixed(" ", "-")
  ) %>%
  select(taid, id, pretty, nl, description) %>%
  mutate(
    link = sprintf(
      "https://attack.mitre.org%s",
      html_attr(html_nodes(et_tbl, xpath = ".//td[1]/a"), "href")
    )
  ) -> ent_tac

mb_tbl %>%
  html_table() %>%
  .[[1]] %>%
  as_tibble() %>%
  rename(taid = ID, pretty = Name, description = Description) %>%
  mutate(
    nl = stri_replace_all_fixed(pretty, " ", "\n"),
    id = stri_trans_tolower(pretty) %>% stri_replace_all_fixed(" ", "-")
  ) %>%
  select(taid, id, pretty, nl, description) %>%
  mutate(
    link = sprintf(
      "https://attack.mitre.org%s",
      html_attr(html_nodes(mb_tbl, xpath = ".//td[1]/a"), "href")
    )
  ) -> mob_tac

pre_tbl %>%
  html_table() %>%
  .[[1]] %>%
  as_tibble() %>%
  rename(taid = ID, pretty = Name, description = Description) %>%
  mutate(
    nl = stri_replace_all_fixed(pretty, " ", "\n"),
    id = stri_trans_tolower(pretty) %>% stri_replace_all_fixed(" ", "-")
  ) %>%
  select(taid, id, pretty, nl, description) %>%
  mutate(
    link = sprintf(
      "https://attack.mitre.org%s",
      html_attr(html_nodes(pre_tbl, xpath = ".//td[1]/a"), "href")
    )
  ) -> pre_tac

tactics_f <- list()
tactics_f[["mitre-attack"]] <- ent_tac
tactics_f[["mitre-pre-attack"]] <- pre_tac
tactics_f[["mitre-mobile-attack"]] <- mob_tac

# Save it all out ---------------------------------------------------------

usethis::use_data(
  enterprise_attack, mobile_attack, pre_attack, tidy_attack, tactics_f,
  internal = FALSE,
  overwrite = TRUE,
  compress = "xz"
)

# Update docs -------------------------------------------------------------

upd <- as.character(Sys.Date())

cat(glue::glue("# This file is autogenerated from tools/update-framework.R
# DO NOT MODIFY BY HAND as all changes will be overwritten

#' @title Enterprise Attack Taxonomy v{enterprise_attack$spec_version}
#' @name enterprise_attack
#' @note Id: `{enterprise_attack$id}`
#' @note Last updated: {upd}
#' @references <{ent_url}>
#' @docType data
NULL

#' @title Mobile Attack Taxonomy v{mobile_attack$spec_version}
#' @name mobile_attack
#' @note Id: `{mobile_attack$id}`
#' @note Last updated: {upd}
#' @references <{mob_url}>
#' @docType data
NULL

#' @title Pre-Attack Taxonomy v{pre_attack$spec_version}
#' @name pre_attack
#' @note Id: `{pre_attack$id}`
#' @note Last updated: {upd}
#' @references <{pre_url}>
#' @docType data
NULL

#' @title Combined ATT&CK Matricies Tactics, Techniques and Technique detail
#' @name tidy_attack
#' @note Last updated: {upd}
#' @docType data
NULL

#' @title Tactics factors (generally for sorting & pretty-printing)
#' @name tactics_f
#' @note Last updated: {upd}
#' @docType data
NULL
"), file = here::here("R/data-docs.R"))

