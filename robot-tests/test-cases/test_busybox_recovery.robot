*** Settings ***
Library           Process
Library           OperatingSystem
Suite Setup       Verify Kubectl Is Available
Suite Teardown    Log Test Completion

*** Variables ***
${KUBECTL}        C:\Program Files\Docker\Docker\resources\bin\kubectl.exe
${NAMESPACE}      chaos-testing
${LABEL}          app=busybox
${DEPLOYMENT}     busybox

*** Test Cases ***
Verify Kubectl Is Available
    ${check}=    Run Process    ${KUBECTL} version --client
    Should Contain    ${check.stdout}    Client Version

Sanity Check: Busybox Pod Is Running
    [Tags]    sanity
    ${result}=    Run Process    ${KUBECTL} get pods -n ${NAMESPACE}
    Should Contain    ${result.stdout}    ${DEPLOYMENT}
    Should Contain    ${result.stdout}    Running

Chaos Validation: Pod Restart Count Increases
    [Tags]    chaos
    ${before}=    Run Process    ${KUBECTL} get pod -l ${LABEL} -n ${NAMESPACE} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}"
    Sleep    150s
    ${after}=     Run Process    ${KUBECTL} get pod -l ${LABEL} -n ${NAMESPACE} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}"
    Log    Restart count before chaos: ${before.stdout}
    Log    Restart count after chaos: ${after.stdout}
    Should Be True    ${after.stdout} > ${before.stdout}

Schedule Check: Chaos Schedule Is Active
    [Tags]    schedule
    ${status}=    Run Process    ${KUBECTL} get schedule busybox-pod-kill-schedule -n ${NAMESPACE} -o jsonpath="{.status}"
    Should Contain    ${status.stdout}    nextStart

*** Keywords ***
Verify Kubectl Is Available
    ${check}=    Run Process    ${KUBECTL} version --client
    Should Contain    ${check.stdout}    Client Version

Log Test Completion
    Log    ✅ Chaos recovery test suite completed.
