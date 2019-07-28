tactics_f <- list()

tactics_f[["mitre-attack"]] <- tibble(
  id = c(
    "initial-access", "execution", "persistence", "privilege-escalation",
    "defense-evasion", "credential-access", "discovery", "lateral-movement",
    "collection", "command-and-control", "exfiltration", "impact"
  ),
  pretty = c(
    "Initial Access", "Execution", "Persistence", "Privilege Escalation",
    "Defense Evasion", "Credential Access", "Discovery", "Lateral Movement",
    "Collection", "Command & Control", "Exfiltration", "Impact"
  ),
  nl = c(
    "Initial\nAccess", "Execution", "Persistence", "Privilege\nEscalation",
    "Defense\nEvasion", "Credential\nAccess", "Discovery", "Lateral\nMovement",
    "Collection", "Command\n&\nControl", "Exfiltration", "Impact"
  )
)

tactics_f[["mitre-pre-attack"]] <- tibble(
  id = c(
    "priority-definition-planning", "priority-definition-direction",
    "target-selection", "technical-information-gathering",
    "people-information-gathering", "organizational-information-gathering",
    "technical-weakness-identification", "people-weakness-identification",
    "organizational-weakness-identification", "adversary-opsec",
    "establish-&-maintain-infrastructure", "persona-development",
    "build-capabilities", "test-capabilities", "stage-capabilities",
    "launch", "compromise"
  ),
  pretty = c(
    "Priority Definition Planning", "Priority Definition Direction",
    "Target Selection", "Technical Information Gathering", "People Information Gathering",
    "Organizational Information Gathering", "Technical Weakness Identification",
    "People Weakness Identification", "Organizational Weakness Identification",
    "Adversary Opsec", "Establish & Maintain Infrastructure", "Persona Development",
    "Build Capabilities", "Test Capabilities", "Stage Capabilities",
    "Launch", "Compromise"
  ),
  nl = c(
    "Priority\nDefinition\nPlanning", "Priority\nDefinition\nDirection",
    "Target\nSelection", "Technical\nInformation\nGathering", "People\nInformation\nGathering",
    "Organizational\nInformation\nGathering", "Technical\nWeakness\nIdentification",
    "People\nWeakness\nIdentification", "Organizational\nWeakness\nIdentification",
    "Adversary\nOpsec", "Establish\n&\nMaintain\nInfrastructure",
    "Persona\nDevelopment", "Build\nCapabilities", "Test\nCapabilities",
    "Stage\nCapabilities", "Launch", "Compromise"
  )
)

tactics_f[["mitre-mobile-attack"]] <- tibble(
  id = c(
    "initial-access", "persistence", "privilege-escalation", "defense-evasion",
    "credential-access", "discovery", "lateral-movement", "effects", "network-effects",
    "remote-service-effects", "collection", "exfiltration", "command-and-control"
  ),
  pretty = c(
    "Initial Access", "Persistence", "Privilege Escalation", "Defense Evasion",
    "Credential Access", "Discovery", "Lateral Movement", "Effects",
    "Network Effects", "Remote Service Effects", "Collection", "Exfiltration",
    "Command & Control"
  ),
  nl = c(
    "Initial\nAccess", "Persistence", "Privilege\nEscalation",
    "Defense\nEvasion", "Credential\nAccess", "Discovery", "Lateral\nMovement",
    "Effects", "Network\nEffects", "Remote\nService\nEffects", "Collection",
    "Exfiltration", "Command\n&\nControl"
  )
)

#' @title Tactics factors (generally for sorting & pretty-printing)
#' @name tactics_f
#' @docType data
#' @export
NULL
