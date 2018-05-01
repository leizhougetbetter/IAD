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
        read(121, "(I4)") degreeNow
        degreeMain(nodeIndex) = degreeNow
        write(neighFormat, *) "(",degreeNow,"(I4,1X))"
        
        allocate(networkMain(nodeIndex)%neighborNode(degreeNow))
        read(121,neighFormat) networkMain(nodeIndex)%neighborNode
    end do
    close(121)
    
    !!! Check the minimum degree of the network
    if(any(degreeMain < minimumDegree))then
        write(*,*) "Minimum group size is NOT satisfied!!"
        stop
    end if
        
    return
end subroutine readNetwork