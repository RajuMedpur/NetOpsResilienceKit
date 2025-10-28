*** Settings ***
Library           Process

*** Variables ***
${KUBECTL}        kubectl
${LABEL}          app=busybox
${NAMESPACE}      chaos-testing
${CHAOS_FILE}     C:/test-netops/NetOpsResilienceKit/chaosmesh/experiments/busybox-podchaos.yaml

*** Test Cases ***
Chaos Mesh Pod Kill Validation
    # Step 1: Capture UID before chaos
    ${cmd_before}=    Set Variable    ${KUBECTL} get pod -l ${LABEL} -n ${NAMESPACE} -o jsonpath="{.items[0].metadata.uid}"
    ${before}=    Run Process    ${cmd_before}    shell=True    stdout=True
    ${before_uid}=    Set Variable    ${before.stdout}
    Log    >>> BEFORE UID: ${before_uid}

    # Step 2: Inject chaos
    # ${apply_cmd}=    Set Variable    ${KUBECTL} apply -f "${CHAOS_FILE}" -n ${NAMESPACE}
    ${apply_cmd}=    Set Variable    ${KUBECTL} replace --force -f "${CHAOS_FILE}" -n ${NAMESPACE}
    ${chaos}=    Run Process    ${apply_cmd}    shell=True    stdout=True    stderr=True
    Log    >>> Chaos apply stdout: ${chaos.stdout}
    Log    >>> Chaos apply stderr: ${chaos.stderr}
    Log    >>> Chaos applied. Waiting for recovery...

    # Step 3: Wait for pod to be killed and recreated
    Sleep    60s

    # Step 4: Capture UID after chaos
    ${cmd_after}=    Set Variable    ${KUBECTL} get pod -l ${LABEL} -n ${NAMESPACE} -o jsonpath="{.items[0].metadata.uid}"
    ${after}=    Run Process    ${cmd_after}    shell=True    stdout=True
    ${after_uid}=    Set Variable    ${after.stdout}
    Log    >>> AFTER UID: ${after_uid}

    # Step 5: Validate resiliency
    Should Not Be Equal    ${before_uid}    ${after_uid}
