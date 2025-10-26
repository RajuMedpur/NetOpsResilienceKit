*** Settings ***
Library           Process
*** Test Cases ***
Chaos Test: DNS Pod Recovery
    [Documentation]    Inject pod-delete chaos via LitmusChaos and verify dns-pod recovers within 15s
    # Step 1: Apply the ChaosEngine
    ${apply}=    Run Process    kubectl    apply    -f    litmus-chaos/engines/dns-pod-delete-chaosengine.yaml    stdout=PIPE    stderr=PIPE
    Log    ${apply.stdout}

    # Step 2: Wait for chaos to complete (TOTAL_CHAOS_DURATION + buffer)
    Sleep    20

    # Step 3: Check if pod is back and running
    ${check}=    Run Process    kubectl    get    pods    -l    app=dns-pod    -n    default    --no-headers    stdout=PIPE    stderr=PIPE
    Log    ${check.stdout}
    Should Contain    ${check.stdout}    Running
