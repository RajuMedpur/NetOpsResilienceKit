*** Settings ***
Library           Process
Library           OperatingSystem
Suite Setup       Setup Environment
Suite Teardown    Teardown Environment

*** Variables ***
${NAMESPACE}      chaos-testing
${DEPLOYMENT}     busybox
${LABEL}          app=busybox

*** Test Cases ***
Verify Busybox Pod Is Running
    [Tags]    sanity
    ${result}=    Run Process    kubectl get pods -n ${NAMESPACE}
    Should Contain    ${result.stdout}    ${DEPLOYMENT}
    Should Contain    ${result.stdout}    Running

Verify Pod Restart Count Increases After Chaos
    [Tags]    chaos
    ${before}=    Run Process    kubectl get pod -l ${LABEL} -n ${NAMESPACE} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}"
    Sleep    150s
    ${after}=     Run Process    kubectl get pod -l ${LABEL} -n ${NAMESPACE} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}"
    Should Be True    ${after.stdout} > ${before.stdout}

Verify Chaos Schedule Is Active
    [Tags]    chaos
    ${status}=    Run Process    kubectl get schedule busybox-pod-kill-schedule -n ${NAMESPACE} -o jsonpath="{.status}"
    Should Contain    ${status.stdout}    nextStart

*** Keywords ***
Setup Environment
    Run Process    kubectl config current-context

Teardown Environment
    Log    Test suite completed.
