os_family = "linux"

init_scripts = [
    "puppet_agent",
    "network",
    "custom"
]

custom = "uname -a"
