*** Settings ***
Library           Process
Library           OperatingSystem

*** Test Cases ***
Verify Busybox Pod Recovers After Chaos
    [Tags]    recovery
    ${status}=    Run Process    kubectl get pods -n chaos-testing
    Should Contain    ${status.stdout}    busybox
    Should Contain    ${status.stdout}    Running
