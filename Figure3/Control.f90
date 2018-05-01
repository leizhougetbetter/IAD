!-----------------2016-5-20-------------------------------!
! Heterogeneous Aspiration Dynamics - Coauther with BinWu !
!---------------------------------------------------------!
module global
    use MT_PNRG
    implicit none
    !
    integer,parameter::Ntotal = 1000
    !
    integer,save::numPlayerInGame
    !
    real(8),save::selectionIntensity
    real(8),save::a0Beg, a0End, a0Gap
    !!!
    !!! A Player -- 1; B Player -- 0
    integer,save::strategyPGG(Ntotal)
    !!!
    real(8),save::aspirationValueNode(Ntotal)
    real,save::initialFrequencyA = 0.45
    !!!!
    integer,parameter::minimumDegree = 2
    integer,save::degreeMain(Ntotal)
    !!
    character(4),save::networkType
    !!!
    type structuredPopulations
        integer,allocatable::neighborNode(:)
    end type
    !!!
    !
end module
    
INCLUDE 'link_fnl_static.h'
!DEC$ OBJCOMMENT LIB:'libiomp5md.lib'

program main
    use global
    implicit none
    integer::timesRepeated
    !Number of nodes  
    character(32)::inputFileName
    character(15)::inputFileNameValueY
    logical::alive
    !!!
    real(8),allocatable::APlayerPayoff(:), BPlayerPayoff(:)
    namelist /keyParameters/ networkType, a0Beg, a0End, a0Gap, timesRepeated, initialFrequencyA

    !!!
    timesRepeated = 3
    
    !!!
    aspirationValueNode = -1.0
    !!! ------ Input delta of y values and interval of y ------ !!!
    inputFileNameValueY = 'yParameters.inp'
    inquire(file = inputFileNameValueY, exist = alive)
    if(.not. alive)then
        write(*,*) "ERROR: File "//inputFileNameValueY//" is NOT found!"
        stop
    end if
    open(unit = 166, file = inputFileNameValueY,status = 'old')
    read(166, nml = keyParameters) 
    close(166)       
    !!! ----- Read Parameters By Line ----- !!!
    inputFileName = 'AspirationDynamicsParameters.txt'
    !
    inquire(file = inputFileName, exist = alive)
    if(.not. alive)then
        write(*,*) "ERROR: File "//inputFileName//" is NOT found!"
        stop
    end if
    open(unit = 188, file = inputFileName,status = 'old')
    !!!
    read(188,*)
    read(188,*)
    read(188,*)
    read(188,*)
    !!!
    read(188,*) 
    read(188,*) numPlayerInGame 
    !!!
    allocate(APlayerPayoff(numPlayerInGame))
    allocate(BPlayerPayoff(numPlayerInGame))
    !!!
    read(188,*) 
    read(188,*) 
    read(188,*) APlayerPayoff
    read(188,*) BPlayerPayoff
    !!!
    read(188,*) 
    read(188,*) aspirationValueNode
    !!!!
    read(188,*) 
    read(188,*) selectionIntensity
    !!!
    write(*,*) 
    write(*,"(' Population Size = ', I4)") Ntotal
    write(*,*) "----------------"
    write(*,"(' # of Player in a game = ', I3)") numPlayerInGame
    write(*,*) "----------------"
    write(*,"('  Payoff Parameters')")
    write(*,*) "A:",APlayerPayoff
    write(*,*) "B:",BPlayerPayoff
    write(*,*) "----------------"
    write(*,*) "Maximum and minimum Aspiration values:"
    write(*,*) maxval(aspirationValueNode), minval(aspirationValueNode)
    write(*,*) "----------------"
    write(*,"(' Selection Intensity = ', F8.5)") selectionIntensity
    write(*,*) "----------------"
    write(*,"(2X,'RepeatedTimes = ', I5)") timesRepeated
    write(*,*) "----------------"
    write(*,"(2X,'Initial fraction of A = ', F5.3)") initialFrequencyA
    write(*,*) "----------------"

    if(any(aspirationValueNode == -1.0))then
        write(*,*) "The number of Aspiration Values MUST equal to the population size!"
        stop
    elseif(selectionIntensity < 0)then
        write(*,*) "The Selection Intensity MUST be Non-nagetive!"
        stop
    end if
    !stop
    !!!! RNOPT(8) --- A 32-bit Mersenne Twister generator is used.
    !!! RNOPT(9) --- A 64-bit Mersenne Twister generator is used.
    call RNOPT(8)  
    
    call frequencyCalculation(timesRepeated, &
    APlayerPayoff, BPlayerPayoff)
    !stop
end
    