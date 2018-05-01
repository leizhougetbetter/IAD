subroutine AspirationUpdate(nodeUpdate, payoffUpdate, randNumUpdate)
    use global
    implicit none
    integer,intent(in)::nodeUpdate
    real(8),intent(in)::payoffUpdate
    real(8), intent(in)::randNumUpdate

    real(8)::switchProb
    real(8)::AspirationMinusPayoff
    !!

    AspirationMinusPayoff = aspirationValueNode(nodeUpdate) - payoffUpdate
    switchProb = real(1.0,8) / (real(1.0,8) + exp(-selectionIntensity * AspirationMinusPayoff))
    !!!
    if(randNumUpdate < switchProb)then
        strategyPGG(nodeUpdate) = 1 - strategyPGG(nodeUpdate)
    end if
    
    return 
end subroutine AspirationUpdate