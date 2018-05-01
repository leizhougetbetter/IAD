subroutine AspirationUpdate(nodeUpdate, payoffUpdate, randUpdate)
    use global
    implicit none
    integer,intent(in)::nodeUpdate
    real,intent(in)::payoffUpdate, randUpdate

    real::switchProb
    real::AspirationMinusPayoff
    !!
    
    
    AspirationMinusPayoff = aspirationValueNode(nodeUpdate) - payoffUpdate
    switchProb = 1.0 / (1 + exp(-1.0 * selectionIntensity * AspirationMinusPayoff))
    !call RANDOM_NUMBER(randUpdate)
    !call RNUN(randUpdateArray)
    !randUpdate = randUpdateArray(1)
    
    if(randUpdate < switchProb)then
        strategyPGG(nodeUpdate) = 1 - strategyPGG(nodeUpdate)
    end if
    
    
    !write(*,*) "Aspiration Value"
    !write(*,*) aspirationValueNode(nodeUpdate)
    !write(*,*) "Payoff Update Node"
    !write(*,*) payoffUpdate
    !write(*,*) "randUpdate"
    !write(*,*) randUpdate
    !write(*,*) "Switching Probability"
    !write(*,*) switchProb
    !pause
    return 
end subroutine AspirationUpdate