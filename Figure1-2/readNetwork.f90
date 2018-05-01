subroutine readNetwork(networkMain)
    use global
    implicit none
    type(structuredPopulations),intent(out)::networkMain(Ntotal) 
    !!!
    integer::nodeIndex
    character(50)::neighFormat
    !!!
    
    !!!! Read Static regular network 
    open(unit = 121, file = "NetworkStructure_AspDyn")
    write(neighFormat, *) "(",degreeMain,"(I3,1X))"
    do nodeIndex = 1, Ntotal
        allocate(networkMain(nodeIndex)%neighborNode(degreeMain))
        read(121,neighFormat) networkMain(nodeIndex)%neighborNode
    end do
    close(121)

    !stop
    return
    end subroutine readNetwork