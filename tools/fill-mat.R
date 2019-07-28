library(hrbrthemes)
library(tidyverse)

distinct(tidy_attack, id, tactic, technique, matrix)

table(nchar(tidy_attack$id))
table(substr(tidy_attack$technique[which(nchar(tidy_attack$technique) < 9)], 1,1 ))

filter(tidy_attack, matrix == "mitre-attack") %>%
  distinct(tactic, technique) %>%
  arrange(technique) %>%
  mutate(tactic = fct_tactic(tactic, "id", "nl")) %>%
  group_by(tactic) %>%
  mutate(ypos = 1:n()) %>%
  ggplot(aes(tactic, ypos)) +
  geom_tile(color = "#b2b2b2", fill = "white") +
  geom_text(aes(label = technique), size = 2) +
  scale_x_discrete(position = "top") +
  scale_y_reverse(expand = c(0,0)) +
  labs(
    x = NULL, y = NULL
  ) +
  theme_minimal() +
  theme(panel.grid = element_blank()) +
  theme(axis.text.y = element_blank())

library(igraph)
library(ggraph)

filter(tidy_attack, matrix == "mitre-attack") %>%
  distinct(id, tactic) %>%
  select(2, 1) -> gdf

g <- graph_from_data_frame(gdf)

tactic_v <- c("initial-access", "persistence", "defense-evasion", "privilege-escalation", "discovery", "credential-access", "execution", "lateral-movement", "collection", "exfiltration", "command-and-control")

strength_df <- enframe(strength(g, vids = V(g), "in"))

e_focus <- filter(strength_df, (value > 1), !(name %in% tactic_v)) %>% pull(name)

strength_df %>%
  mutate(
    fil = case_when(
      name %in% tactic_v ~ ft_cols$blue,
      value > 1 ~ ft_cols$slate,
      TRUE ~ "white"
    ),
    col = case_when(
      name %in% tactic_v ~ ft_cols$yellow,
      value > 1 ~ "white",
      TRUE ~ ft_cols$slate
    ),
    lab_size = case_when(
      name %in% tactic_v ~ 4,
      TRUE ~ 2
    )
  )  -> vdf

g <- graph_from_data_frame(gdf, vertices = vdf)

map_chr(E(g), ~{
  if (any(unlist(strsplit(attr(.x, "vnames"), "|", fixed = TRUE)) %in% e_focus)) {
    ft_cols$red
  } else {
    ft_cols$gray
  }
}) -> E(g)$ecol

map_dbl(E(g), ~{
  if (any(unlist(strsplit(attr(.x, "vnames"), "|", fixed = TRUE)) %in% e_focus)) {
    0.25
  } else {
    0.125
  }
}) -> E(g)$ewid

minC <- rep(-Inf, vcount(g))
maxC <- rep(Inf, vcount(g))
minC[1] <- maxC[1] <- 0

ggraph(g, layout = "fr", niter = 5000, start.temp = 2*(vcount(g)), minx=minC, maxx=maxC, miny=minC, maxy=maxC) +
  geom_edge_link(
    aes(colour = I(ecol), width = I(ewid)), alpha=1/4
  ) +
  geom_node_label(
    aes(label = name, fill = I(fil), color = I(col), size = I(lab_size)),
    family = font_es
  ) +
  labs(
    x = NULL, y = NULL
  ) +
  theme_ft_rc(grid="") +
  theme(axis.text = element_blank())




c(
  "event_id", "incident_id", "event_ts", "detection_ts", "tactic",
  "technique", "discovery_source", "reporting_source", "responder_id"
)

n <- 200

filter(tidy_attack, matrix == "mitre-attack") %>%
  distinct(tactic, id) -> pre

ttidx <- sample(nrow(pre), n, replace = TRUE)

tibble(
  event_id = ulid::ulid_generate(n),
  incident_id = sample(ulid::ulid_generate(30), n, replace = TRUE),
  event_ts = sample(seq(as.Date("2019-04-01"), as.Date("2019-06-29"), "1 day"), n, replace = TRUE),
  detection_ts = event_ts + 1,
  tactic = pre[["tactic"]][ttidx],
  technique = pre[["id"]][ttidx],
  discovery_source = sample(c("Log src 1", "Log src 2", "Log src 3"), n, replace = TRUE),
  reporting_source = rep("Insight IDR", n),
  responder_id = sample(c("Thing one", "Thing two"), n, replace = TRUE)
) -> smpl

write_csv(smpl, "inst/extdat/sample-incidents.csv.gz")

count(xx, tactic, technique) %>%
  mutate(tactic = fct_tactic(tactic, "pretty", "nl")) %>%
  left_join(
    filter(tidy_attack, matrix == "mitre-attack") %>%
      distinct(id, technique),
    c("technique" = "id")
  ) %>%
  complete(tactic, technique.y) %>%
  mutate(technique.y = factor(technique.y, rev(sort(unique(technique.y))))) %>%
  ggplot(aes(tactic, technique.y)) +
  geom_tile(aes(fill = n), color = "#2b2b2b", size = 0.125) +
  scale_x_discrete(expand = c(0, 0), position = "top") +
  scale_fill_viridis_c(direction = -1, na.value = "white") +
  labs(
    x = NULL, y = NULL
  ) +
  theme_minimal() +
  theme(panel.grid=element_blank())

count(xx, detection_ts) %>%
  ggplot() +
  geom_col(aes(detection_ts, n), width=0.6)
