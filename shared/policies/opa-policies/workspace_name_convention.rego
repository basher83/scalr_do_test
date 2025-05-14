package terraform 


import input.tfplan as tfplan
import input.tfrun as tfrun

deny["The workspace should end in '-dev', but we'll let it slide.."] {
    not endswith(tfrun.workspace.name, "-dev")
}