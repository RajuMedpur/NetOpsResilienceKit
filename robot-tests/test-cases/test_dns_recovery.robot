*** Settings ***
Library           OperatingSystem
*** Test Cases ***
Verify DNS Recovery
    [Documentation]    Ensure dns-pod-1 recovers within 5s after chaos injection
    Sleep    5
    Run    kubectl get pod dns-pod-1
    Should Contain    ${output}    Running
