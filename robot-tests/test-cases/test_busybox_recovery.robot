*** Settings ***
Library           Process

*** Variables ***
${KUBECTL}        kubectl
${LABEL}          app=busybox
${NAMESPACE}      default

*** Test Cases ***
Chaos Mesh Pod Kill Validation
    ${before}=    Run Process
    ...    ${KUBECTL}
    ...    get
    ...    pod
    ...    -l
    ...    ${LABEL}
    ...    -n
    ...    ${NAMESPACE}
    ...    -o
    ...    jsonpath={.items[0].metadata.uid}
    ...    stdout=True
    ${before_uid}=    Set Variable    ${before.stdout}
    Log    UID before chaos: ${before_uid}

    Log    Waiting for Chaos Mesh to kill pod and restart...
    Sleep    30s

    ${after}=    Run Process
    ...    ${KUBECTL}
    ...    get
    ...    pod
    ...    -l
    ...    ${LABEL}
    ...    -n
    ...    ${NAMESPACE}
    ...    -o
    ...    jsonpath={.items[0].metadata.uid}
    ...    stdout=True
    ${after_uid}=    Set Variable    ${after.stdout}
    Log    UID after chaos: ${after_uid}

    Should Not Be Equal    ${before_uid}    ${after_uid}
