subroutine readNetwork(networkMain)
    use global
    implicit none
    type(structuredPopulations),intent(out)::networkMain(Ntotal) 
    !!!
    integer::nodeIndex
    integer::degreeNow
    character(50)::neighFormat
    !!!
    
    
    open(unit = 121, file = "NetworkStructure_AspDyn_"//trim(adjustl(networkType)))
    write(*,*) "----------------------------------------------------"
    write(*,*) "Network File Read = ", "NetworkStructure_AspDyn_"//trim(adjustl(networkType))
    write(*,*) "----------------------------------------------------"
    
    do nodeIndex = 1, Ntotal
        read(121, "(I3)") degreeNow
        degreeMain(nodeIndex) = degreeNow
        write(neighFormat, *) "(",degreeNow,"(I3,1X))"
        
        allocate(networkMain(nodeIndex)%neighborNode(degreeNow))
        read(121,neighFormat) networkMain(nodeIndex)%neighborNode
    end do
    close(121)
    
    !!! Check the reading
    !do nodeIndex = 1, Ntotal
    !    write(*,*) "---------"
    !    write(*,*) "Node", nodeIndex
    !    write(*,*) "Neighbor"
    !    write(*,*) networkMain(nodeIndex)%neighborNode
    !end do

    !stop
    return
    end subroutine readNetwork