*** Settings ***
Library           Process

*** Test Cases ***
Chaos Test: BusyBox Deployment Recovery
    [Documentation]    Inject pod-delete chaos and verify busybox pod auto-recovers via Deployment
    Run Process    kubectl apply -f litmus-chaos/engines/busybox-chaosengine.yaml
    Sleep    20
    ${status}=    Run Process    kubectl get pods -l app=busybox -n default --no-headers stdout=PIPE
    Log    ${status.stdout}
    Should Contain    ${status.stdout}    Running
