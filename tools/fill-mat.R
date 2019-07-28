filter(tidy_attack, matrix == "mitre-attack") %>%
  distinct(tactic, technique) %>%
  mutate(tactic = fct_tactic("id", "nl")) %>%
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



filter(tidy_attack, matrix == "mitre-attack") %>%
  distinct(tactic, technique)
