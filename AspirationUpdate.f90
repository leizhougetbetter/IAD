subroutine AspirationUpdate(nodeUpdate, payoffUpdate, randNumUpdate)
    use global
    implicit none
    integer,intent(in)::nodeUpdate
    real,intent(in)::payoffUpdate
    real, intent(in)::randNumUpdate

    real::randUpdate
    real::switchProb
    real::AspirationMinusPayoff
    !!
    
    !!!! Difference between aspiration and payoff
    AspirationMinusPayoff = aspirationValueNode(nodeUpdate) - payoffUpdate
    !!!! calculate the switching probability
    switchProb = 1.0 / (1 + exp(-1.0 * selectionIntensity * AspirationMinusPayoff))
    !!!
    if(randNumUpdate < switchProb)then
        strategyPGG(nodeUpdate) = 1 - strategyPGG(nodeUpdate)
    end if
    
    
    !write(*,*) "Aspiration Value"
    !write(*,*) aspirationValueNode(nodeUpdate)
    !write(*,*) "Payoff Update Node"
    !write(*,*) payoffUpdate
    !write(*,*) "Switching Probability"
    !write(*,*) switchProb
    !pause
    return 
end subroutine AspirationUpdate